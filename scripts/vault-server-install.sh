#!/usr/bin/env bash

set -x
set -e
set -u

kubectx atlantic-ocean
kubectl get node

kubectl create -n vault  -f ./manifest/services
