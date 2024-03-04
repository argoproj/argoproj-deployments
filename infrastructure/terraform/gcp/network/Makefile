
login:
	gcloud auth application-default login

plan:
	tofu init -upgrade && tofu plan -out default.tfplan

apply:
	tofu apply default.tfplan
