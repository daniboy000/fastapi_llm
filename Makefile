include .env
PYTHON_VERSION = '3.17'

.PHONY: venv
setup: venv install

.PHONY: lint
lint: ruff mypy

.PHONY: runserver
runserver:
	@echo "Running server..."
	poetry run uvicorn fastapi_llm.main:app --host $(HOST) --port $(PORT) --reload

.PHONY: venv
venv:
	@echo "Install python with pyenv, define as local and create the virtual envirionment..."
	pyenv install --skip-existing ${PYTHON_VERSION}
	pyenv local ${PYTHON_VERSION}  # Activate Python for the current project
	poetry env use ${PYTHON_VERSION}

.PHONY: install
install:
	@echo "Installing dependencies..."
	poetry install --no-root --sync

.PHONY: tests
tests:
	@echo "Running tests..."
	poetry run pytest --cov=fastapi_llm --cov-report=html --cov-report=term-missing

.PHONY: ruff
ruff:
	@echo "Running ruff..."
	poetry run ruff check fastapi_llm

.PHONY: ruff-format
ruff-format:
	@echo "Running ruff-formatter..."
	poetry run ruff format fastapi_llm

.PHONY: mypy
mypy:
	@echo "Running mypy..."
	poetry run mypy fastapi_llm

.PHONE: clean
clean:
	@echo "Cleaning up..."
	if exist poetry.lock ( del poetry.lock /q /s )