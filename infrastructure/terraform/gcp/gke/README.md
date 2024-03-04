# GKE Cluster module

Create GKE clusters

## Known Issues

- The cluster cannot be updated it's `private_cluster_config` after creation due to https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1876

## Usage

This modules assume you have the required permissions and an existing VPC (created by [network module](../network/README.md)).

To create a new clusters, add a file under the `vars/` folder and use the cluster name as the file name.
The cluster can be deployed by specifying the `CLUSTER` variable to the Make commands.

### Deploy changes

To apply changes to the module, log in with a user that has been added as an admin in the [user-access module](../user-access/README.md) and run the following commands

```
CLUSTER=argo-demo-apps make plan
CLUSTER=argo-demo-apps make apply
```

## Connecting to the cluster

To connect to the cluster, you can run the following command to update you Kubeconfig

```
gcloud container clusters get-credentials argo-demo-apps --region us-central1 --project argo-demo-apps
```
