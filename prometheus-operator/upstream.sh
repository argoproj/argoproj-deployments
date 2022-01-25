#!/bin/bash
helm dependency update upstream
helm template \
    --include-crds \
    --namespace prometheus-operator \
    prometheus-operator \
    ./upstream > resources/upstream.yaml
