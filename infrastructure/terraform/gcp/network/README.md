# Remote state module

This module creates a VPC and DNS zone that can be used by GKE clusters.

## Requirements

- OpenTofu (>= 1.6)
- GCloud CLI (>= 464.0.0)

## Usage

### Deploy changes

To apply changes to the module, log in with a user that has been added as an admin in the [user-access module](../user-access/README.md) and run the following commands

```
make plan

make apply
```
