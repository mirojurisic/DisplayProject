import json, os
import boto3

# Initialize dynamodb boto3 object
dynamodb = boto3.resource("dynamodb")


def lambda_handler(event, context):
    # Set up dynamodb table object
    table = dynamodb.Table(os.getenv("db_name"))
    response = table.get_item(Key={"user": "id"})
    # print(response)
    ddbResponse = None
    if not response["Item"]:
        ddbResponse = table.put_item(
            Item={
                "user": "id",
                "clicks": 0,
            }
        )
        print("initialize")

    else:
        # Atomic update an item in table or add if doesn't exist
        ddbResponse = table.update_item(
            Key={"user": "id"},
            UpdateExpression="ADD clicks :inc",
            ExpressionAttributeValues={":inc": 1},
            ReturnValues="UPDATED_NEW",
        )
        print("update")

        # Return dynamodb response object
    print(ddbResponse)
    return ddbResponse
