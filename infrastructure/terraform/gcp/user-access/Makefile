
login:
	gcloud auth application-default login

plan:
	tofu init -upgrade && tofu plan -var-file=vars/default.tfvars -out default.tfplan

apply:
	tofu apply default.tfplan
