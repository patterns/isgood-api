from chalice import Chalice, BadRequestError

app = Chalice(app_name='helloapi')
app.debug = True
##app.api.cors = True

@app.route('/')
def index():
    return {'hello': 'world'}

@app.route('/recommendations', methods=['GET'])
def recommended_indicators():
    result = {}
    param_txt = app.current_request.query_params.get('criteria')
    crit_list = param_txt.split(",")
    # TODO Pass the 4 criteria to DS to obtain recommended indicators.
    #      **Placeholder JSON for now**
    accumulator = []
    for idx, cr in enumerate(crit_list):
        cr_item = {'id': idx +1, 'name': 'indicator-%s' % cr}
        accumulator.append(cr_item)

    result['Indicators'] = accumulator
    return result


