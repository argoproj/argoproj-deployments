# OpenTofu based deployment

## Requirements

- OpenTofu
- GCloud CLI
- GCP Project

## Bootstrap

To bootstrap the account

## User access

To allow a user to execute the GKE terraform, add it to the [user-access module](./user-access/README.md).

**WARNING:** This gives a lot of permission in the account that are not only restricted to the GKE cluster.

### Argo CD deployment

```
kubectl apply -k cert-manager -n cert-manager
kubectl apply -k argocd -n argocd
// If the apply for argocd fails, run it again. It might fail the first time due to missing CRDs

// Before applying the Applications, you might need to update the repoURL and targetRevision
// if you are working on custom branch
k apply -k argoproj -n argocd
```
