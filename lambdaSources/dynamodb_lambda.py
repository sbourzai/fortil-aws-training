import json
import urllib3
import boto3
import os

def lambda_handler(event, context):
    http = urllib3.PoolManager()
    dynamodb = boto3.resource('dynamodb')
    table_name = os.getenv('DYNAMODB_TABLE', 'dynamo-aws-training')
    table = dynamodb.Table(table_name)

    url = 'https://api.chucknorris.io/jokes/random'

    try:
        # Fetching joke from the API
        response = http.request('GET', url)
        joke_data = json.loads(response.data.decode('utf-8'))
        joke = joke_data.get('value', 'No joke found')

        # Putting joke into DynamoDB table
        table.put_item(
            Item={
                'id': joke_data['id'],  # Assuming the joke data has an 'id' field
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
                'message': 'Error fetching or storing joke',
                'error': str(e)
            })
        }
