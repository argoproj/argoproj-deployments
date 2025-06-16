# OpenTofu deployment

This sections contains multiple OpenTofu modules used to provision a Google Cloud Platform Project.

## Requirements

- OpenTofu (>= 1.6)
- GCloud CLI (>= 464.0.0)
- A GCP Project

## Deployment

This project contains multiples modules that can be applied indenpendely to provision a GKE cluster.

In a new account, the modules can be deployed in the following order:

1. User Access (requires update after the Remote State deployment)
2. Remote State
3. Network
4. GKE

Once a cluster has been provisioned, Argo CD is used to deploy applications into it.

### [User access](./user-access/README.md)

The user access module manages users permissions to the GCP project.
To allow a user to execute the GKE terraform, add it to the [user-access module](./user-access/README.md).

**WARNING:** This gives a lot of permission in the account that are not only restricted to the GKE cluster.

### [Remote state](./remote-state/README.md)

The remote state module creates a remote state storage that can be used as a state backend.

### [Network](./network/README.md)

The network module create the necessary VPC and DNS Zones that will be used by the GKE clusters.

### [GKE](./gke/README.md)

The GKE module provision one or more GKE clusters.

## Argo CD deployment

After the GKE cluster is deployed, you can deploy Argo CD on it and use Applications resources to provision other
components. Some componenets that are dependencies for Argo CD to work properly, such as Certificate Manager, will
need to be deployed manually first.

```
kubectl apply -k cert-manager -n cert-manager
kubectl apply -k argocd -n argocd
// If the apply for argocd fails, run it again. It might fail the first time due to missing CRDs

// Before applying the Applications, you might need to update the repoURL and targetRevision
// if you are working on custom branch
kubectl apply -k argoproj -n argocd
```
