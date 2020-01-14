#!/bin/bash
helm dependency update upstream
helm template --set grafana.sidecar.dashboards.enabled=true --name prometheus-operator --namespace prometheus-operator upstream > resources/upstream.yaml
