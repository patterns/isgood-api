#!/usr/bin/env python3

import sys
import json
import boto3

def fetch():
    # The program needs to read the passed data in query from stdin
    input_json = sys.stdin.read()
    try:
        # The string data passed by query has json format
        input_dict = json.loads(input_json)
        pool_id = input_dict.get('user-pool-id')

        client = boto3.client('cognito-idp')
        try:
            client.admin_delete_user(
                 UserPoolId=pool_id,
                 Username='tester@example.com',
            )
        except:
            pass
        response = client.admin_create_user(
                 UserPoolId=pool_id,
                 Username='tester@example.com',
                 UserAttributes=[
                     {'Name':'email_verified', 'Value':'True'},
                     {'Name':'email', 'Value':'tester@example.com'},
                 ],
                 MessageAction='SUPPRESS',
        )
        resp2 = client.admin_set_user_password(
                 UserPoolId=pool_id,
                 Username='tester@example.com',
                 Password='testTerraform2*',
                 Permanent=True,
        )


        # The output is a json string with all key's values as string type
        ##output = json.dumps({str(key): str(value) for key, value in response.items()})
        output = json.dumps({'Username': response['User']['Username']})
        # The output must be returned in stdout
        sys.stdout.write(output)
    except ValueError as e:
        sys.exit(e)

if __name__ == "__main__":
    fetch()
