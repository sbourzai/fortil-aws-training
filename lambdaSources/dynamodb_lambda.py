import json
import boto3
import os

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table_name = os.getenv('DYNAMODB_TABLE', 'dynamo-aws-training')
    table = dynamodb.Table(table_name)

    try:
        # Parse the joke content from the POST request body
        body = json.loads(event.get('body', '{}'))
        joke = body.get('joke', 'No joke provided')

        # Create an item with a unique ID for the joke (using context or another method)
        joke_id = context.aws_request_id

        # Put the joke into DynamoDB
        table.put_item(
            Item={
                'id': joke_id,
                'joke': joke
            }
        )

        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Joke stored successfully!',
                'joke': joke
            })
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Error storing joke',
                'error': str(e)
            })
        }
