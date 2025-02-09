#!/usr/bin/env bash

set -x
set -e
set -u

MY_NAMESPACE=argo
MY_SERVICE=foo
MY_PORT=2746

echo "go to: http://localhost:${MY_PORT}/"
kubectl -n ${MY_NAMESPACE} port-forward service/argo-server ${MY_PORT}:${MY_PORT}
# firefox http://localhost:${MY_PORT}/ &&