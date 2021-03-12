from chalice.test import Client
from app import app


def test_recommendations_route():
    with Client(app) as client:
        response = client.http.get('/recommendations?criteria=AAA,BBB')
        assert response.status_code == 200
        assert response.json_body == {'Indicators': [{'id': 1, 'name': 'indicator-AAA'},{'id': 2, 'name': 'indicator-BBB'}]}


