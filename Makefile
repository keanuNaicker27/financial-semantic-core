# --- Configuration ---
DBT_DIR := dbt
PROFILE := default
TARGET := dev

# --- High-Level Commands ---
.PHONY: help install build test docs clean

help: ## Show this help message
	@echo "Financial-Semantic-Core Development Commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

install: ## Install dbt dependencies
	cd $(DBT_DIR) && dbt deps

build: ## Run all seeds, models, and snapshots
	cd $(DBT_DIR) && dbt build --target $(TARGET)

test: ## Run data quality tests
	cd $(DBT_DIR) && dbt test --target $(TARGET)

docs: ## Generate and serve dbt documentation
	cd $(DBT_DIR) && dbt docs generate && dbt docs serve

clean: ## Remove dbt artifacts and logs
	cd $(DBT_DIR) && dbt clean

# --- Staff Move: Multi-Cloud Execution Examples ---
run-azure: ## Run models targeting Azure Synapse/SQL
	cd $(DBT_DIR) && dbt run --target azure --tags sas_standardization

run-aws: ## Run models targeting AWS Athena
	cd $(DBT_DIR) && dbt run --target aws --tags sas_standardization

validate-sas: ## Run specific SAS mapping integrity checks
	cd $(DBT_DIR) && dbt test --select "tag:sas"
