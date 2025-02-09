#!/usr/bin/env bash
# Deinstall ArgoCD Workflow operator

set -x
set -e
set -u


kubectx atlantic-ocean
kubectl get node

ARGO_WORKFLOWS_VERSION="v3.6.3"
kubectl create namespace argo || true
kubectl apply -n argo -f "https://github.com/argoproj/argo-workflows/releases/download/${ARGO_WORKFLOWS_VERSION}/quick-start-minimal.yaml"

