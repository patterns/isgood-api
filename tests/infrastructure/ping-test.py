import requests


def test_endpoint_echo(base):
    testid = 'test123'
    data = {'projectId':testid}
    response = requests.post(base + '/echo', json=data)

    assert response.status_code == 200
    body = response.json()
    assert body['projectId'] == testid

