# hal9000-ops-target

> Dummy Python Flask application used as a CI/CD target for **HAL9000-OPS** agent testing.

## What's in here

| File | Purpose |
|---|---|
| `app/main.py` | Minimal Flask app with `/`, `/health`, `/ping` routes |
| `app/requirements.txt` | Pinned production dependencies |
| `Dockerfile` | Multi-stage build, non-root user, HEALTHCHECK |
| `docker-compose.yml` | Local dev stack |
| `tests/test_app.py` | Pytest suite (80% coverage gate) |
| `.github/workflows/ci.yml` | **Working** CI — test → lint → docker build |
| `.github/workflows/ci-broken.yml` | **Intentionally broken** CI for HAL9000-OPS to investigate |

## Quick start

```bash
# Run app locally
make run

# Run tests
make test

# Build Docker image
make build

# Start with docker-compose
make up
```