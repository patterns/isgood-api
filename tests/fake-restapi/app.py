from chalice import Chalice, BadRequestError, CognitoUserPoolAuthorizer
import random

app = Chalice(app_name='helloworld')
app.debug = True
app.api.cors = True
authorizer = CognitoUserPoolAuthorizer(
    'MyPool', provider_arns=['arn:YOUR_COGNITO_USER_POOL_ARN'])

@app.route('/')
def index():
    return {'about': 'hello world api'}

@app.route('/indications', methods=['POST'], authorizer=authorizer)
def predictions():
    # AWS api gateway doesn't like x-www-form-urlencoded
    # but you can use query params in path
    if app.current_request.query_params != None:
        param_txt = app.current_request.query_params.get('id')
    else: # if absent, must be JSON object.....
        payload = app.current_request.json_body
        param_txt = payload['id']

    # TODO Pass the JSON to DS to obtain recommended indicators.
    #      **Placeholder JSON for now**
    ##get_indicators(param_txt)
    accumulator = random.sample(range(1,100),5)


    result = {}
    result['success'] = True
    result['data'] = {'word': param_txt, 'vector': accumulator}
    return result


