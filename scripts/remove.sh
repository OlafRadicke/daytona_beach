#!/usr/bin/env bash

set -x
set -e
set -u

kubectx atlantic-ocean
kubectl get node
kubectl delete -n argo -f ./manifest/after
kubectl delete -n argo -f ./manifest/befor