import json
import boto3
import requests

TOKEN_TABLE_NAME = "fitbitToken"
HEART_TABLE_NAME = "HeartRate"


def get_access_token():
    table = boto3.resource("dynamodb").Table(TOKEN_TABLE_NAME)
    response = table.scan(Limit=1)
    items = response.get("Items", [])

    if not items:
        return None

    return items[0].get("access_token")


def save_heart_rate_data(heart_rate_json, collect_date):
    table = boto3.resource("dynamodb").Table(HEART_TABLE_NAME)

    activities = heart_rate_json.get("activities-heart", [])
    if not activities:
        raise Exception("No heart rate data returned from Fitbit")

    value = activities[0].get("value", {})
    resting_heart_rate = value.get("restingHeartRate")
    heart_rate_zones = value.get("heartRateZones", [])

    item = {
        "collect_date": collect_date,
        "restingHeartRate": resting_heart_rate if resting_heart_rate is not None else 0,
        "heartRateZones": json.dumps(heart_rate_zones)
    }

    table.put_item(Item=item)


def lambda_handler(event, context):
    # support direct Lambda test and API Gateway body
    if isinstance(event, dict) and event.get("body"):
        try:
            body = json.loads(event["body"]) if isinstance(event["body"], str) else event["body"]
        except Exception:
            body = {}
    else:
        body = event if isinstance(event, dict) else {}

    collect_date = body.get("collect_date")
    if not collect_date:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "Missing collect_date"})
        }

    access_token = get_access_token()
    if not access_token:
        return {
            "statusCode": 404,
            "body": json.dumps({"error": "No access token found in DynamoDB"})
        }

    url = f"https://api.fitbit.com/1/user/-/activities/heart/date/{collect_date}/1d.json"
    headers = {"Authorization": f"Bearer {access_token}"}

    try:
        resp = requests.get(url, headers=headers, timeout=20)
    except requests.RequestException as e:
        return {
            "statusCode": 502,
            "body": json.dumps({"error": "Network error calling Fitbit", "details": str(e)})
        }

    if resp.status_code != 200:
        return {
            "statusCode": resp.status_code,
            "body": json.dumps({"error": "Fitbit API request failed", "details": resp.text})
        }

    heart_rate_json = resp.json()

    try:
        save_heart_rate_data(heart_rate_json, collect_date)
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": "Failed to save heart rate data", "details": str(e)})
        }

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": f"Heart rate data saved successfully for {collect_date}"
        })
    }
    
