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

## HAL9000-OPS integration

Point your HAL9000-OPS agent `.env` at this repo:

```bash
GITHUB_REPO=your-username/hal9000-ops-target
```

The `ci-broken.yml` workflow will fail on every push to `main` or `develop`,
giving HAL9000-OPS a live failure to investigate. It contains three deliberate bugs:

1. Invalid Python version string
2. Typo in requirements file path
3. Wrong test directory name

Each bug is clearly marked with `# ❌ BUG` and `# [FIX]` comments in the workflow file.
