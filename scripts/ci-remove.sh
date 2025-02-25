#!/usr/bin/env bash

set -x
set -e
set -u

kubectx atlantic-ocean
kubectl get node
kubectl delete -n argo -f ./manifest/workflow/05_after | true
kubectl delete -n argo -f ./manifest/workflow/01_befor