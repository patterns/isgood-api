"""
event-invoke route handler
"""

import json
import os
import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

PROJECT_ID_STRING = "projectid"
DATA_STRING = "projectId"

def handler(event, context):
        # warning: AWS can retry or even occasionally lose events
        # when asynchronous (InvocationType='Event')
        # see https://docs.aws.amazon.com/lambda/latest/dg/API_Invoke.html

        logger.info('## event-invoke route')
        logger.info(event)

        body = json.loads(event['body'])
        logger.info('## request body')
        logger.info(body)

        data = body[DATA_STRING]

        subproc_response = invoke_subprocess(data)

        logger.info('## response')
        logger.info(subproc_response)

        # Lambda response returns 202 because we are invoking with
        # InvocationType = 'Event'
        if subproc_response["StatusCode"] != 202:
            response = {
                    'statusCode': 400,
                    'body': "ERROR subprocess failed"
            }
        else:
            response = {
                    'statusCode': subproc_response["StatusCode"]
            }
        return response


def invoke_subprocess(data):
        # Make payload passed to subprocess
        subproc_payload = json.dumps({
            PROJECT_ID_STRING: data
        })

        # Invoking subprocess asynchronously by using InvocationType='Event'
        sdk = boto3.client('lambda')
        response = sdk.invoke(
                FunctionName='event-invoke-step',
                InvocationType='Event',
                Payload=subproc_payload
        )

        # returns 202 on success
        return response


