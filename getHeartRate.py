import json
import requests
import boto3

DDB_TABLE_NAME = "fitbitToken"


def get_access_token():
    table = boto3.resource("dynamodb").Table(DDB_TABLE_NAME)

    # For this lab, if only one user's token is stored, grab the first item
    response = table.scan(Limit=1)
    items = response.get("Items", [])

    if not items:
        return None

    return items[0].get("access_token")


def lambda_handler(event, context):
    # Support API Gateway proxy event or direct Lambda test event
    if isinstance(event, dict) and "body" in event and event["body"]:
        try:
            body = event["body"]
            if isinstance(body, str):
                body = json.loads(body)
        except Exception:
            body = {}
    else:
        body = event

    startdate = body.get("startdate")
    enddate = body.get("enddate")

    if not startdate or not enddate:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "Missing startdate or enddate"})
        }

    access_token = get_access_token()
    if not access_token:
        return {
            "statusCode": 404,
            "body": json.dumps({"error": "No access token found in DynamoDB"})
        }

    url = f"https://api.fitbit.com/1/user/-/activities/heart/date/{startdate}/{enddate}.json"
    headers = {"Authorization": f"Bearer {access_token}"}

    try:
        resp = requests.get(url, headers=headers, timeout=20)
    except requests.RequestException as e:
        return {
            "statusCode": 502,
            "body": json.dumps({"error": "Network error calling Fitbit", "details": str(e)})
        }

    if resp.status_code == 200:
        return {
            "statusCode": 200,
            "body": json.dumps(resp.json())
        }

    return {
        "statusCode": resp.status_code,
        "body": json.dumps({
            "error": "Fitbit API request failed",
            "details": resp.text
        })
    }
