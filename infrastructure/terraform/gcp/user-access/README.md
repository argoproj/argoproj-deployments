# User Access module

Manages IAM permissions in the GCP project.

## Requirements

- OpenTofu
- GCloud

## Usage

In this module, you can use the `users` and `admins` variables to give the necessary permissions in the GCP project to deploy the different terraform modules for Argo.

### Initialization

**These steps are only required the first time this module is initialized in a GCP project.**

To bootstrap the permission, the module needs to be deployed locally, then imported in the remote state.

1. First, run the `./user-access` module without specifying a `state_bucket`. Add your user as part of the `admins` list. This requires at least the permissions from the roles `roles/iam.roleAdmin` and `roles/resourcemanager.projectIamAdmin` to be already given to the current user in the project.
2. After the module is applied, you need to create the remote state. Follow the instructions in the [remote-state module](../remote-state/README.md).
3. When the remote state is created, update the variable `state_bucket`, and add the `backend` configuration to the `terraform.tf` file.
4. Finally, run `make plan`. It will ask you if you want to migrate your local state file to the remote state. Enter `yes`. Delete the local state files on success.
