# Remote state module

Creates a bucket that will store the Terraform remote state used by different modules.

## Requirements

- OpenTofu
- GCloud

## Usage

### Initialization

**These steps are only required the first time this module is initialized in a GCP project.**

To bootstrap the permission, the module needs to be deployed locally, then imported in the remote state.

1. First, run the `./user-access` module. Follow the instructions in the [remote-state module](../user-access/README.md).
2. Run this module with `make plan && make apply` to create the remote storage.
3. When the remote storage is created, add the `backend` configuration to the `terraform.tf` file.
4. Finally, run `make plan` again. It will ask you if you want to migrate your local state file to the remote state. Enter `yes`. Delete the local state files on success.
