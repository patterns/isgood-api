import json
import random

def handler(event, context):
        event_body = json.loads(event['body'])
        param_txt = event_body['projectId']
        ##offset = event_body['offset']
        ##limit = event_body['limit']
        ##name = event_body['name']
        ##description = event_body['description']
        ##impacts = event_body['projectImpacts']
        ##outcomes = event_body['outcomesDesired']

        # size 8 to make diff from the other route
        random_pk = random.sample(range(1,100),8)
        accumulator = []
        for pk in random_pk:
            item = {'indicatorId': pk, 'alignedStrength': random.random()}
            accumulator.append(item)
        result = {}
        result['projectId'] = param_txt
        result['indicators'] = accumulator

        response = {
               'statusCode': 200,
               'body': json.dumps(result)
        }

        return response
