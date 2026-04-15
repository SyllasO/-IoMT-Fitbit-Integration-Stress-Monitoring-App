import json
import boto3
from datetime import datetime

TABLE_NAME = "StressData"

def lambda_handler(event, context):
    # Support both Lambda test events and API Gateway proxy events
    if isinstance(event, dict) and event.get("body"):
        try:
            body = json.loads(event["body"]) if isinstance(event["body"], str) else event["body"]
        except Exception:
            body = {}
    else:
        body = event if isinstance(event, dict) else {}

    checkin_date = body.get("checkin_date")
    stress_score = body.get("stress_score")
    notes = body.get("notes", "")

    if not checkin_date or stress_score is None:
        return {
            "statusCode": 400,
            "body": json.dumps({
                "error": "Missing checkin_date or stress_score"
            })
        }

    try:
        stress_score = int(stress_score)
    except ValueError:
        return {
            "statusCode": 400,
            "body": json.dumps({
                "error": "stress_score must be a number"
            })
        }

    item = {
        "checkin_date": checkin_date,
        "stress_score": stress_score,
        "notes": notes,
        "time_stamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    }

    try:
        table = boto3.resource("dynamodb").Table(TABLE_NAME)
        table.put_item(Item=item)

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": f"Stress data saved successfully for {checkin_date}"
            })
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({
                "error": "Failed to save stress data",
                "details": str(e)
            })
        }
    
