import json
import random
import boto3
import os

sdk = boto3.client('cognito-idp')
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


def temporary_auth_bypass(body):
        # simplified auth flow until request-signing (and/or hosted-ui)
        # extract POST body and call admin_initiate_auth
        pool_id = os.environ.get('userpool_id')
        client_id = os.environ.get('appclient_id')
        if 'refresh' in body:
            auth_params = {'REFRESH_TOKEN': body['refresh']}
            auth_flow = 'REFRESH_TOKEN_AUTH'
        else:
            auth_params = {'USERNAME': body['username'], 'PASSWORD': body['password']}
            auth_flow='ADMIN_NO_SRP_AUTH'
        try:
            user = sdk.admin_initiate_auth(
                  UserPoolId=pool_id,
                  ClientId=client_id,
                  AuthFlow=auth_flow,
                  AuthParameters=auth_params)
            authres = user.get('AuthenticationResult')
            tokens = {'token': authres.get('IdToken')}
            return tokens

        except sdk.exceptions.NotAuthorizedException as ex:
            return {'error': 'The credentials provided do not match any in the system.'}
        except Exception as ex:
            return {'error': ex.__str__()}




def handler(event, context):
        event_body = json.loads(event['body'])
        event_path = event['path']

        # overloading this handler with multiple routes
        if '/muck' in event_path:
            result = temporary_auth_bypass(event_body)
        elif '/lambda/mu' in event_path:
            result = dereference_numbers(event_body['numbers'])
        else:
            result = recommend_by_project(event_body['projectId'])

        response = {
               'statusCode': 200,
               'body': json.dumps(result)
        }
        return response

