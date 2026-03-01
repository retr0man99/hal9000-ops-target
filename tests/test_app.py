import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "app"))

import pytest
from main import app


@pytest.fixture
def client():
    app.config["TESTING"] = True
    with app.test_client() as client:
        yield client


def test_index_returns_200(client):
    response = client.get("/")
    assert response.status_code == 200


def test_index_returns_json(client):
    response = client.get("/")
    data = response.get_json()
    assert data["status"] == "ok"
    assert data["service"] == "hal9000-ops-target"


def test_health_endpoint(client):
    response = client.get("/health")
    assert response.status_code == 200
    data = response.get_json()
    assert data["healthy"] is True


def test_ping_endpoint(client):
    response = client.get("/ping")
    assert response.status_code == 200
    data = response.get_json()
    assert data["pong"] is True
