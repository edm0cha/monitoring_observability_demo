import os
import json
import boto3

dynamodb = boto3.resource('dynamodb')
dynamodb_table = dynamodb.Table(os.environ['ITEMS_TABLE_NAME'])

def setResponse(response, message, statusCode):
    response.update(statusCode=statusCode)
    response.update(body=json.dumps(message))

def lambda_handler(event, _):
    response = {
        "headers": {
            "Content-Type": "application/json"
        }
    }
    try:
        items = dynamodb_table.scan()['Items']
        print("Items retrieved: ", len(items))
        setResponse(response, items, 200)
    except Exception as e:
        setResponse(response, {"message": str(e)}, 500)
        print("Error 500")
    return response