import pytest
from app import app

@pytest.fixture
def client():
    app.config['TESTING'] = True
    return app.test_client()

def test_index(client):
    response = client.get('/')
    assert response.status_code == 200
    assert response.data == b"Welcome to the Guest Book!"

def test_add_guest(client):
    response = client.get('/add/testuser')
    assert response.status_code == 200
    assert b"Added testuser to the guestbook" in response.data
