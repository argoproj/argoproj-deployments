# GKE Cluster module

Create GKE clusters

## Known Issues

- Currently, the cluster cannot be update after creation due to https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1876

## Usage

This modules assume you have the permissions required (given by user-access module) and an existing VPC (created by network module).

To create multiple clusters, add a new file under the `vars/` folder and use the cluster name as the file name.
The cluster can be deployed by specifying the `CLUSTER` variable to the Make commands.

```
CLUSTER=argo-demo-apps make plan
CLUSTER=argo-demo-apps make apply
```

## Connection

To connect to the cluster, you can run the following command to update you Kubeconfig

```
gcloud container clusters get-credentials argo-demo-apps --region us-central1 --project argo-demo-apps
```
