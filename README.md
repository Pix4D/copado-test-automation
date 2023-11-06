# Test-Automation

## Overview
This repository hosts a test automation suite, leveraging Robot Framework and 
Selenium, wrapped in Docker containers. The orchestration is done using Concourse CI. 
It also features a Django application to manage tests and feature toggles.

**Note:** This repository is currently in the development phase and not ready for 
production use. Best practices and more features are actively being considered.

## Structure
- `.github/`: GitHub Actions for continuous integration and deployment.
- `.concourse/`: Concourse CI pipeline definitions.
- `docker/`: Dockerfiles for the test environment setup.
- `django_app/`: Django project for managing test features.
- `tests/`: Robot Framework and Selenium test scripts.
- `docker-compose.yml`: Orchestration of Docker services.

## Getting Started
Ensure Docker and Docker Compose are installed. Clone the repository, and run:

```bash
docker-compose up --build
