# User Access module

Manages IAM permissions in the GCP project.

## Requirements

- OpenTofu (>= 1.6)
- GCloud CLI (>= 464.0.0)

## Usage

In this module, you can use the `account_admins` and `admins` variables to give the necessary permissions in the GCP project to deploy the different terraform modules for Argo.

For Kubernetes access only, you can use the `k8s_admins` and `k8s_viewers` variables. This will give Kubernetes access to all clusters in the Argo projects.
Currently, there is no RBAC configured within the GKE clusters.

Since the tfvars used will contain **personal gmails**, it is **excluded** from the source dode. You can use the current state to rebuild the tfvars.
A redacted version is available until the list of gmails is stored externally and can be fetched at execution time.

### Initialization

**These steps are only required the first time this module is initialized in a GCP project.**

To initialize the permission, the module needs to be deployed locally, then imported in the remote state.

1. First, run the `./user-access` module without specifying a `state_bucket`. Add your user as part of the `account_admins` list. This requires at least the permissions from the roles `roles/iam.roleAdmin` and `roles/resourcemanager.projectIamAdmin` to be already given to the current user in the project.
2. After the module is applied, you need to create the remote state. Follow the instructions in the [remote-state module](../remote-state/README.md).
3. When the remote state is created, update the variable `state_bucket`, and add the `backend` configuration to the `terraform.tf` file.
4. Finally, run `make plan`. It will ask you if you want to migrate your local state file to the remote state. Enter `yes`. Delete the local state files on success.

### Add a new user

1. Make a copy of the vars/default.tfvars.redacted file: `cp vars/default.tfvars.redacted vars/default.tfvars`
2. Replace the redacted names of users with their email addresses, which can be found here: https://console.cloud.google.com/iam-admin/iam?authuser=1&project=argo-demo-apps
3. Add the email address of the new user to the corresponding list of permissions (e.g. `account_admins` for admin permissions, `k8s_admins` for Kubernetes admin permissions, etc.)
4. Proceed to "Deploy changes"

### Deploy changes

To apply changes to the module, log in with a user that is currently an admin and run the following commands

```
make plan

make apply
```
