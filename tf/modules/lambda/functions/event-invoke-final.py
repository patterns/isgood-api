"""
final step for subprocess
"""

import json
import os
import logging
import http.client

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
        # As the destination of the subprocess,
        # run final logic to provide results back to the consumer.

        logger.info('## event-invoke final')
        logger.info(event)

        jwt = begin_auth_to_known_webconsumer()

        # TODO
        # use jwt and send post
        req = make_request_from_fields(jwt, event)
        placeholder = send_post_to_known_webconsumer(req)


        response = {
                'statusCode': 200,
                'body': placeholder
        }
        return response



def begin_auth_to_known_webconsumer():
        # Obtain JWT that will be required by our known webapp consumer
        logger.info('## begin oauth')

        key = os.environ['CLIENT_ID']
        secret = os.environ['CLIENT_SECRET']

        data = {
                'client_id': key,
                'client_secret': secret,
                'audience': "https://www.isgood-api.com",
                'grant_type': "client_credentials"
        }
        payload = json.dumps(data)

        headers = { 'content-type': "application/json" }
        conn = http.client.HTTPSConnection("isgood-webapp.us.auth0.com")
        conn.request("POST", "/oauth/token", payload, headers)
        res = conn.getresponse()
        data = res.read()

        token = data.decode("utf-8")
        logger.info(token)

        return token


def make_request_from_fields(jwt, event):
        response_from_subproc = event['responsePayload']
        headers = {
                'content-type': "application/json",
                'Authorization': jwt['access_token']
                }
        request = {'headers': headers, 'payload': response_from_subproc['body']}
        return request

def send_post_to_known_webconsumer(req):
        endpoint = os.environ['WEBAPP_ENDPOINT']

        logger.info("## starting to send post...")
        logger.info(req)
        return "placeholder send-post"
        #conn = http.client.HTTPSConnection(endpoint)
        #conn.request("POST", "", req['payload'], req['headers'])
        #res = conn.getresponse()
        #data = res.read()

        #return data.decode("utf-8")


