import json
import random

def handler(event, context):
        ##print("Received event: " + json.dumps(event, indent=2))

        event_body = json.loads(event['body'])
        param_txt = event_body['id']

        # size 8 to make diff from the other route
        accumulator = random.sample(range(1,100),8)
        result = {}
        result['success'] = True
        result['data'] = {'word': param_txt, 'vector': accumulator}

        response = {
               'statusCode': 200,
               'body': json.dumps(result)
        }

        return response
