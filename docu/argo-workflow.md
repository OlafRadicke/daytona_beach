ARGO WORKFLOW
=============

INSTALL
-------

Doku: [Quick Start](https://argo-workflows.readthedocs.io/en/latest/quick-start/)


```bash
$ ARGO_WORKFLOWS_VERSION="vX.Y.Z"
$ kubectl create namespace argo
$ kubectl apply -n argo -f "https://github.com/argoproj/argo-workflows/releases/download/${ARGO_WORKFLOWS_VERSION}/quick-start-minimal.yaml"
```


CLONE GIT REPOS
---------------

Use image [git-sync](https://github.com/kubernetes/git-sync)


```yaml
    - name:         get-clone
      inputs:
        parameters:
          - name:   gitRepo
            value:  "https://github.com/argoproj/argo-workflows.git"
          - name:   gitBranch
            value:  "main"
      # #this is the git fetch magic as an init container in the first step
      initContainers:
        - image: k8s.gcr.io/git-sync:v3.1.6
          args:
            - "--repo={{inputs.parameters.gitRepo}}"
            - "--root=/src/clone"
            - "--max-sync-failures=3"
            - "--timeout=200"
            - "--branch={{inputs.parameters.gitBranch}}"
            # - "--ssh"
            - "--one-time"
          name: git-data
          volumeMounts:
            - name: argo-workdir
              mountPath: /src ##
            # - name: git-secret
            #   mountPath: /etc/git-secret
      container:
        image:      golang:1.10
        command:    [sh, -c]
        args:       ["ls -lah && git status"]
        workingDir: /src/clone
        volumeMounts:                     # same syntax as k8s Pod spec
        - name:     argo-workdir
          mountPath: /src

```