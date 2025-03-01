#!/usr/bin/env bash

set -x
set -e
set -u

kubectx atlantic-ocean
kubectl get node

kubectl apply --wait=true -n argo -f ./manifest/workflow/01_befor
# sleep 2
kubectl apply --wait=true -n argo -f ./manifest/workflow/05_after
