import requests


def test_endpoint_echo(base):
    testid = 'test123'
    data = {'projectId':testid}
    response = requests.post(base + '/echo', json=data)

    assert response.status_code == 200
    body = response.json()
    assert body['projectId'] == testid

def test_endpoint_lambda(base):
    testid = 'test123'
    data = {'projectId':testid}
    response = requests.post(base + '/lambda', json=data)

    assert response.status_code == 401
    body = response.json()
    assert body['message'] == 'Unauthorized'


