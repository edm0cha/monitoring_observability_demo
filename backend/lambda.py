import os
import json
import boto3

dynamodb = boto3.resource('dynamodb')
dynamodb_table = dynamodb.Table(os.environ['ITEMS_TABLE_NAME'])

def isPalindrome(s):
    return s == s[::-1]

def storeItem(item, id):
    print("Storing item: ", item, id)
    print("Item Lenght: ", len(item), id)
    print("Is Item Palindrome: ", isPalindrome(item), id)
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
        route = f"{event["requestContext"]["http"]["path"]} {event["requestContext"]["http"]["method"]}"
        # Verify Session ID
        if 'session-id' not in event["headers"]:
            print("Session-Id Header missing")
            setResponse(response, {"message": "Session-Id Header missing"}, 400)
            return response
        # Extract Request ID
        request_id = event["requestContext"]["requestId"]

        if route == '/items POST':
            print("Recived connection requestId:" ,request_id)
            request_body = json.loads(event["body"])
            item = request_body.get("item", "empty_item")
            setResponse(response, storeItem(item, request_id) , 200)
            print("Successfully Completed with code 200")
        elif route == '/items GET':
            items = dynamodb_table.scan()['Items']
            print("Items retrieved: ", len(items), request_id)
            setResponse(response, items, 200)
        else:
            response['statusCode'] = 400
            response['body'] = json.dumps({'message': 'Route does not exist'})
    except Exception as e:
        setResponse(response, {"message": str(e)}, 500)
        print("Error 500")
    return response