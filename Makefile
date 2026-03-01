.PHONY: run test lint build up down

# Run locally with Flask dev server
run:
	cd app && python main.py

# Run tests
test:
	pytest tests/ -v --cov=app --cov-report=term-missing

# Lint
lint:
	ruff check app/

# Build Docker image locally
build:
	docker build -t hal9000-ops-target:local .

# Start with docker-compose
up:
	docker compose up --build

# Stop
down:
	docker compose down
