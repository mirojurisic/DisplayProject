import { UpdateItemCommand, GetItemCommand, DynamoDBClient } from "@aws-sdk/client-dynamodb";

const client = new DynamoDBClient({});

// https://docs.aws.amazon.com/sdk-for-javascript/v3/developer-guide/dynamodb-example-table-read-write.html
export async function getCount(tableName) {

    const command = new GetItemCommand({
        TableName: tableName,
        // For more information about data types,
        // see https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/HowItWorks.NamingRulesDataTypes.html#HowItWorks.DataTypes and
        // https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Programming.LowLevelAPI.html#Programming.LowLevelAPI.DataTypeDescriptors
        Key: {
            "id": { N: "0" },
        },
    });

    const response = await client.send(command);
    console.log(response);
    return response;
};

export async function updateCount(tableName, increment) {
    const update_command = new UpdateItemCommand({
        TableName: tableName,
        Key: {
            "id": { N: "0" },
        },
        UpdateExpression: "ADD clicks :inc",
        ExpressionAttributeValues: {
            ":inc": { N: increment },
        },
        ReturnValues: "ALL_NEW",
    });

    const response = await client.send(update_command);
    console.log(response);
    return response;
};
