"""
subproccess for parent route
"""

import json
import os
import boto3
import logging
import random

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
        logger.info('## event-invoke subprocess')
        logger.info(event)

        # TODO
        # This Python file will be removed when
        # the real backend-lambda (DS/Brain) becomes live.




        project_id = event['projectid']

        result = recommend_by_project(project_id)

        response = {
               'statusCode': 200,
               'body': json.dumps(result)
        }
        return response


def recommend_by_project(proj):
        # In the meantime, return placeholder response
        # (fake 8 indicators)
        random_pk = random.sample(range(1,100),8)
        accumulator = []
        for pk in random_pk:
            item = {'indicatorId': pk, 'alignedStrength': random.random()}
            accumulator.append(item)
        result = {}
        result['projectId'] = proj
        result['indicators'] = accumulator
        return result


