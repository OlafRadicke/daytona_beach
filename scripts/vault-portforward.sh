#!/usr/bin/env bash

set -x
set -e
set -u

MY_NAMESPACE=vault
MY_SERVICE=vault-server
MY_PORT=8200

echo "go to: http://localhost:${MY_PORT}/"
kubectx atlantic-ocean
kubectl -n ${MY_NAMESPACE} port-forward service/${MY_SERVICE} ${MY_PORT}:${MY_PORT}
# firefox http://localhost:${MY_PORT}/ &&