# Sealed Secrets

This is a deployment of [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets).

## Usage

### Homebrew installation

The `kubeseal` client is also available on [homebrew](https://formulae.brew.sh/formula/kubeseal):

```bash
brew install kubeseal
```

### Encrypt secret values

Secrets a encrypted for a specific name and namespace.

```bash
echo -n "my secret value" | kubeseal --raw --namespace <TARGET_SECRET_NAMESPACE> --name <TARGET_SECRET_NAME> --controller-name=sealed-secrets --controller-namespace=sealed-secrets
```

### Validate sealed secrets

```bash
cat < SEALED_SECRET.yaml > | kubeseal --controller-name=sealed-secrets --controller-namespace=sealed-secrets --validate
```

### Create sealed secrets from secrets

```bash
# Create a yaml-encoded Secret somehow:
# (note use of `--dry-run` - this is just a local file!)
echo -n bar | kubectl create secret generic mysecret --dry-run=client --from-file=foo=/dev/stdin -o yaml >mysecret.yaml

kubeseal -f mysecret.yaml -w mysealedsecret.yaml --controller-name=sealed-secrets --controller-namespace=sealed-secrets

rm mysecret.yaml
```

### Annotations

The following annotations can be added on the `Secret` resource.

- use `sealedsecrets.bitnami.com/patch: 'true'` to only add/modify some keys of an existing secrets
- use `sealedsecrets.bitnami.com/managed: 'true'` to take ownership of an existing secret

## Backup

As a prevention, the encryption key has been saved manually as a [Secret](https://console.cloud.google.com/security/secret-manager/secret/sealed-secrets-key/versions?project=argo-demo-apps) in the GCP account.
