import json
import os
from datetime import datetime
import boto3
import requests

TOKEN_TABLE_NAME = "fitbitToken"
FITBIT_TOKEN_URL = "https://api.fitbit.com/oauth2/token"

BASIC_AUTH_B64 = os.environ.get("BASIC_AUTH_B64")

def get_token_record():
    table = boto3.resource("dynamodb").Table(TOKEN_TABLE_NAME)
    response = table.scan(Limit=1)
    items = response.get("Items", [])

    if not items:
        return None

    return items[0]


def lambda_handler(event, context):
    if not BASIC_AUTH_B64:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": "Missing BASIC_AUTH_B64 env var"})
        }

    record = get_token_record()
    if not record:
        return {
            "statusCode": 404,
            "body": json.dumps({"error": "No token record found in fitbitToken table"})
        }

    refresh_token = record.get("refresh_token")
    user_id = record.get("user_id")

    if not refresh_token:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "No refresh_token found"})
        }

    headers = {
        "Authorization": f"Basic {BASIC_AUTH_B64}",
        "Content-Type": "application/x-www-form-urlencoded"
    }

    data = {
        "grant_type": "refresh_token",
        "refresh_token": refresh_token
    }

    try:
        resp = requests.post(FITBIT_TOKEN_URL, headers=headers, data=data, timeout=20)
    except requests.RequestException as e:
        return {
            "statusCode": 502,
            "body": json.dumps({"error": "Network error calling Fitbit", "details": str(e)})
        }

    if resp.status_code != 200:
        return {
            "statusCode": resp.status_code,
            "body": json.dumps({"error": "Refresh token request failed", "details": resp.text})
        }

    token_json = resp.json()

    table = boto3.resource("dynamodb").Table(TOKEN_TABLE_NAME)

    item = {
        "user_id": user_id,
        "access_token": token_json["access_token"],
        "refresh_token": token_json.get("refresh_token", refresh_token),
        "expires_in": token_json.get("expires_in"),
        "token_type": token_json.get("token_type"),
        "time_stamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    }

    table.put_item(Item=item)

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": f"Access token refreshed successfully for {user_id}"
        })
    }
