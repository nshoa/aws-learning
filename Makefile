# AWS Learning - developer tasks
# Run `make help` to list targets.

TEMPLATES_DIR := labs/cloud_formation/templates
TEMPLATE ?= ec2-only
STACK    ?= $(TEMPLATE)-lab

CFN_CONFIG  := config/.cfnlintrc
YAML_CONFIG := config/.yamllint

.PHONY: help install lint validate yaml markdown deploy delete

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | \
		awk 'BEGIN{FS=":.*?## "}{printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

install: ## Install dev tooling and git hooks
	pip install -r requirements-dev.txt
	pre-commit install

lint: validate yaml markdown ## Run every linter

validate: ## Lint CloudFormation templates (cfn-lint)
	cfn-lint --config-file $(CFN_CONFIG)

yaml: ## Lint all YAML (yamllint)
	yamllint -c $(YAML_CONFIG) .

markdown: ## Lint all Markdown (markdownlint-cli2 via pre-commit; no system Node needed)
	pre-commit run markdownlint-cli2 --all-files

deploy: ## Deploy a stack, e.g. make deploy TEMPLATE=ec2-only STACK=my-stack
	aws cloudformation deploy \
		--template-file $(TEMPLATES_DIR)/$(TEMPLATE).yaml \
		--stack-name $(STACK)

delete: ## Delete a stack, e.g. make delete STACK=my-stack
	aws cloudformation delete-stack --stack-name $(STACK)
