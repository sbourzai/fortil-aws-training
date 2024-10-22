import json
import urllib3

def lambda_handler(event, context):
    http = urllib3.PoolManager()
    url = 'https://api.chucknorris.io/jokes/random'

    try:
        response = http.request('GET', url)
        joke_data = json.loads(response.data.decode('utf-8'))
        joke = joke_data.get('value', 'No joke found')

        return {
            'statusCode': 200,
            'body': json.dumps({
                'joke': joke
            })
        }
        
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Error fetching joke',
                'error': str(e)
            })
        }
