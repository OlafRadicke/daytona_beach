#!/usr/bin/env bash
# Deinstall ArgoCD Workflow operator

set -x
set -e
set -u


kubectx atlantic-ocean
kubectl get node

kubectl -n argo get CronWorkflow
kubectl -n argo get Workflow
kubectl -n argo get WorkflowTemplate
