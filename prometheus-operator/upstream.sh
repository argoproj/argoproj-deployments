#!/bin/bash
helm dependency update upstream
helm template \
    -f ./upstream/values.yaml \
    --include-crds \
    --namespace prometheus-operator \
    prometheus-operator \
    ./upstream > resources/upstream.yaml
