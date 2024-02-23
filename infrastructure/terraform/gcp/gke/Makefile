.PHONY: help

help: ## Show help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

CLUSTER?=default
VAR_FILE=vars/$(CLUSTER).tfvars

validate-cluster:
	@if [ ! -f "$(VAR_FILE)" ]; then echo "File '$(VAR_FILE)' does not exist. Use CLUSTER=<your-cluster> make $(MAKECMDGOALS)"; exit 1; fi

login: ## Helper to authenticate to Google Cloud Platform
	gcloud auth application-default login

init: ## Upgrade the terraform modules
	@tofu init -upgrade
	# Add private_cluster_config to ignore_changes because of https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1876
	@sed -i '' 's|ignore_changes = \[node_pool, initial_node_count, resource_labels\["asmv"\]\]|ignore_changes = [node_pool, initial_node_count, resource_labels["asmv"], private_cluster_config]|' ./.terraform/modules/gke/modules/beta-private-cluster-update-variant/cluster.tf

plan: init plan-fast ## Plan with latest modules available

plan-fast: validate-cluster ## Plan
	@tofu workspace select -or-create=true "$(CLUSTER)"
	tofu plan -var-file="$(VAR_FILE)" -out "$(CLUSTER).tfplan"

apply: ## Apply
	tofu apply "$(CLUSTER).tfplan"
