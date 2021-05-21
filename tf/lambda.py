import json
import random

def recommend_by_project(proj):
        # fake 8 indicators
        random_pk = random.sample(range(1,100),8)
        accumulator = []
        for pk in random_pk:
            item = {'indicatorId': pk, 'alignedStrength': random.random()}
            accumulator.append(item)
        result = {}
        result['projectId'] = proj
        result['indicators'] = accumulator
        return result


def dereference_numbers(numbers):
        # fake indicator details
        accumulator = []
        for num in numbers:
            item = {'id': num, 'description': 'This is a {} indicator description'.format(num)}
            accumulator.append(item)
        result = {}
        result['indicators'] = accumulator
        return result


def handler(event, context):
        event_body = json.loads(event['body'])
        event_path = event['path']
        # overloading handler with multiple routes
        if '/lambda/mu' in event_path:
            result = dereference_numbers(event_body['numbers'])
        else:
            result = recommend_by_project(event_body['projectId'])

        response = {
               'statusCode': 200,
               'body': json.dumps(result)
        }
        return response

