
"""
Purpose

To implement Lambda REQUEST authorizer on the websocket.

Logs written by this handler can be found in Amazon CloudWatch.
"""

import json
import logging
import os
import boto3
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# TODO boto3 call on **REST** API keys 
# see https://svdgraaf.nl/2018/06/01/Serverless-Basic-Authentication-Custom-Authorizer.html

def handler(event, context):
    # DEBUG DEBUG
    #test = event.get('requestContext', {}).get('identity')

    method_arn = event['methodArn']
    consumer_input = event.get('headers', {}).get('x-api-key')

    known_api_key = os.environ['WEBAPP_API_KEY']
    ##logger.info("Known key: %s ", known_api_key)

    if consumer_input == known_api_key:
        return generate_policy('DEBUGDEBUG', method_arn)
    else:
        raise Exception('Unauthorized')


def generate_policy(principal_id, method_arn):
    policy = {
        'principalId': principal_id,
        'policyDocument': {
            'Version': "2012-10-17",
            'Statement': [
                {
                    'Action': "execute-api:Invoke",
                    'Effect': "Allow",
                    'Resource': method_arn
                }
            ]
        }
    }

    return policy

