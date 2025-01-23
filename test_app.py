import pytest
from flask import Flask, url_for

def test_index(client):
    response = client.get('/')
    assert b'Welcome to the Guest Book!' in response.data

def test_add_guest(client):
    response = client.post('/add/Guest1')
    assert b"Added Guest1 to the guestbook" in response.data