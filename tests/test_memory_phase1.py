"""Memory Test Phase 1 — test file using match/case (requires Python 3.10+).

This file deliberately uses `match/case` syntax so that running it on
Python 3.8 (as ci-memory-test-phase1.yml does) causes a SyntaxError
at collection time, giving HAL9000-OPS a clear failure to investigate.
"""

import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "app"))

from main import app
import pytest


@pytest.fixture
def client():
    app.config["TESTING"] = True
    with app.test_client() as client:
        yield client


def _classify_status(code: int) -> str:
    """Use match/case — needs Python 3.10+."""
    match code:
        case 200:
            return "ok"
        case 404:
            return "not_found"
        case 500:
            return "server_error"
        case _:
            return "unknown"


def test_index_status_classification(client):
    response = client.get("/")
    label = _classify_status(response.status_code)
    assert label == "ok"


def test_health_status_classification(client):
    response = client.get("/health")
    label = _classify_status(response.status_code)
    assert label == "ok"


def test_unknown_route_classification(client):
    response = client.get("/nonexistent")
    label = _classify_status(response.status_code)
    assert label == "not_found"
