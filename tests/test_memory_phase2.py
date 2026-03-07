"""Memory Test Phase 2 — test file using Python 3.10+ syntax.

This file deliberately uses `X | Y` union type syntax (PEP 604) and
`match/case` so that running it on Python 3.9 (as ci-memory-test-phase2.yml
does) causes a SyntaxError at collection time.

The error signature is similar to Phase 1 (wrong Python version → SyntaxError)
but uses different syntax features, testing whether HAL9000-OPS memory
recalls the earlier investigation.
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


def _parse_response(data: dict) -> str | None:
    """Use X | Y union type return — needs Python 3.10+."""
    match data.get("status"):
        case "ok":
            return "healthy"
        case "error":
            return "unhealthy"
        case _:
            return None


def test_index_response_parsing(client):
    response = client.get("/")
    result = _parse_response(response.get_json())
    assert result == "healthy"


def test_health_response_parsing(client):
    response = client.get("/health")
    data = response.get_json()
    # /health doesn't have "status" key, so parser returns None
    result = _parse_response(data)
    assert result is None


def test_ping_response_parsing(client):
    response = client.get("/ping")
    data = response.get_json()
    result = _parse_response(data)
    assert result is None
