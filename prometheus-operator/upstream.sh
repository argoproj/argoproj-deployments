#!/bin/bash
helm dependency update upstream
helm template upstream --name prometheus-operator --namespace prometheus-operator > resources/upstream.yaml
