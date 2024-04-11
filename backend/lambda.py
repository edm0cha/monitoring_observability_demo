import os
import json
import boto3

dynamodb = boto3.resource('dynamodb')
dynamodb_table = dynamodb.Table(os.environ['ITEMS_TABLE_NAME'])

def storeItem(item, id):
    print("Storing item: ", item)
    dynamodb_table.put_item(Item = {
        'id': id,
        'item': item
    })
    response = {"message": "Item stored successfully!"}
    print("Item Stored")
    return response

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
        request_id = event["requestContext"]["requestId"]
        print("requestId:" ,request_id)
        request_body = json.loads(event["body"])
        item = request_body.get("item", "empty_item")
        body_response = storeItem(item, request_id)
        setResponse(response, {"message": "Item stored successfully!"}, 200)
        print("Successfully Completed with code 200")
    except Exception as e:
        setResponse(response, {"message": str(e)}, 500)
        print("Error 500")
    return response