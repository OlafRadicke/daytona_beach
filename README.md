DAYTONA_BEACH
=============

A experimental repo for SOPS, TOFU and ArgoCD-Workflow exercises and experience.

- [DAYTONA\_BEACH](#daytona_beach)
	- [KNOWN ISSUES](#known-issues)
	- [TODOs](#todos)
	- [HOW-TO](#how-to)
		- [Helper scripts](#helper-scripts)
	- [CI/CD](#cicd)
	- [EXTERNAL DOCUMENTATION](#external-documentation)


KNOWN ISSUES
------------

- The workflows fail if the templates are not installed first.
- The Vault Server lost his state in dev mode (so, don't stopped during your experiments).


TODOs
-----

- [X] 0.0.x - Enable CronWorkflow
- [X] 0.2.x - Vault Server
- [X] 0.3.x - Checkout OpenTofu code
- [X] 0.4.x - Handle with artifacts / PVCs
- [X] 0.5.x - Add OpenTofu backend (PVC/local `-backend-config=PATH`)
- [X] 0.6.x - run OpenTofu code
- [X] 0.7.x - Integrate SOPS: Secrets OPerations
- [X] 0.8.x - Code cleanups

HOW-TO
------

Open #todo ...

### Helper scripts

In folder /scripts:

| Script                  | Function                                                 |
|-------------------------|----------------------------------------------------------|
| vault-server-install.sh | Deploy an Vault-Server in dev mod                        |
| vault-server-remove.sh  | Remove the Kubernetes Vault Server setup                 |
| vault-portforward.sh    | Create an Kubernetes portforwart to the Vault server     |
| flow-install.sh         | Installed the Workflows framework                        |
| flow-deinstall.sh       | Deinstalled the Workflows framework                      |
| flow-get.sh             | List stats of Workflow resources in Kubernetes           |
| flow-portforward.sh     | Create an Kubernetes portforwart to the Workflows WebGUI |
| ci-install.sh           | Deployed the demo Workflows CI                           |
| ci-remove.sh            | Remove the demo Workflows CI                             |

CI/CD
-----

Github Action is used for building needed customized images.


EXTERNAL DOCUMENTATION
----------------------

* [Encrypting using Hashicorp Vault](https://github.com/getsops/sops?tab=readme-ov-file#encrypting-using-hashicorp-vault)
* [Argo Workflow Git-Repo](https://github.com/argoproj/argo-workflows?tab=readme-ov-file)
* [Examples](https://github.com/argoproj/argo-workflows/tree/main/examples)
* [Cron workflows](https://argo-workflows.readthedocs.io/en/latest/cron-workflows/)
* [Volumes](https://argo-workflows.readthedocs.io/en/latest/walk-through/volumes/)
* [Workflow Templates](https://argo-workflows.readthedocs.io/en/latest/workflow-templates/)
* [Teragrunt](https://terragrunt.gruntwork.io/)