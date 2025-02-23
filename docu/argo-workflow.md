ARGO WORKFLOW
-------------

### INSTALL

Doku: [Quick Start](https://argo-workflows.readthedocs.io/en/latest/quick-start/)


```bash
$ ARGO_WORKFLOWS_VERSION="vX.Y.Z"
$ kubectl create namespace argo
$ kubectl apply -n argo -f "https://github.com/argoproj/argo-workflows/releases/download/${ARGO_WORKFLOWS_VERSION}/quick-start-minimal.yaml"
```
