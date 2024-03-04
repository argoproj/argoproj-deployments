# Argo Workflows

### Initial deployment

You currently have to create secrets manually

```
kubectl apply -n argo -f resources/argo-server-sso-secret.yaml
kubectl apply -n argo -f resources/argo-workflows-webhook-clients-secret.yaml
```
