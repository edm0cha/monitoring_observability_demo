import os
import json
import boto3
from aws_lambda_powertools import Logger
# Added Metrics
from aws_lambda_powertools import Metrics
from aws_lambda_powertools.metrics import MetricUnit
from aws_lambda_powertools.utilities.typing import LambdaContext

logger = Logger(service="observability_demo")
# Initialize Metrics
metrics = Metrics(service="todo-list", namespace="ServerlessTodoList")

dynamodb = boto3.resource('dynamodb')
dynamodb_table = dynamodb.Table(os.environ['ITEMS_TABLE_NAME'])

def isPalindrome(s):
    return s == s[::-1]

def storeItem(item, id):
    # print("Storing item: ", item)
    # print("Item Lenght: ", len(item))
    # print("Is Item Palindrome: ", isPalindrome(item))
    dynamodb_table.put_item(Item = {
        'id': id,
        'item': item
    })
    response = {"message": "Item stored successfully!"}
    # Log and structured information
    logger.info("Item stored successfully", item=item, lenght=len(item), is_palindrome=isPalindrome(item), action="store_item")
    if isPalindrome(item):
        metrics.add_metric(name="IsPalindrome", unit=MetricUnit.Count, value=1)
    return response

def setResponse(response, message, statusCode):
    response.update(statusCode=statusCode)
    response.update(body=json.dumps(message))

# Add Loger context to the Handler
@logger.inject_lambda_context
@metrics.log_metrics  # ensures metrics are flushed upon request completion/failure

def lambda_handler(event, context: LambdaContext):
    response = {
        "headers": {
            "Content-Type": "application/json"
        }
    }
    try:
        route = f"{event["requestContext"]["http"]["path"]} {event["requestContext"]["http"]["method"]}"

        # Verify Session ID
        if 'session-id' not in event["headers"]:
            # Log and structured error
            logger.error("Session-Id Header missing", status=400)
            setResponse(response, {"message": "Session-Id Header missing"}, 400)
            return response
        # Verify Environment
        # if 'environment' not in event["headers"]:
        #     # Log and structured error
        #     logger.error("Environment Header missing", status=400)
        #     setResponse(response, {"message": "Environment Header missing"}, 400)
        #     return response
        
        # # Add Enviromennt Dimension to metrics
        # metrics.add_dimension(name="environment", value=event["headers"]['environment'])
        # Appends the session id to the logger
        logger.append_keys(session_id=event["headers"]["session-id"])

        if route == '/items POST':
            request_id = event["requestContext"]["requestId"]
            print("Recived connection requestId:" ,request_id)
            request_body = json.loads(event["body"])
            item = request_body.get("item", "empty_item")
            setResponse(response, storeItem(item, request_id) , 200)
            # Log and structured information
            logger.info("successfully completed", status=200)
            # Add a metric
            metrics.add_metric(name="CreatedItem", unit=MetricUnit.Count, value=1)
        elif route == '/items GET':
            items = dynamodb_table.scan()['Items']
            setResponse(response, items, 200)
            # Log and structured information
            logger.info("successfully completed", status=200, items_count=len(items), action="fetch_items")
            # Add a metric
            metrics.add_metric(name="ListedItems", unit=MetricUnit.Count, value=len(items))
        else:
            response['statusCode'] = 400
            response['body'] = json.dumps({'message': 'Route does not exist'})
    except Exception as e:
         # Log and structured error
        logger.error(str(e), status=500)
        setResponse(response, {"message": str(e)}, 500)
    return response