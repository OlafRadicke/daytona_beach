DAYTONA_BEACH
=============

A experimental repo for SOPS, OpenTofu and ArgoCD-Workflow exercises and experience.

- [DAYTONA\_BEACH](#daytona_beach)
	- [HOW-TO](#how-to)
	- [KNOWN ISSUES](#known-issues)
	- [CI/CD](#cicd)
	- [TODOs / TAGs / PROJECT STATE](#todos--tags--project-state)




HOW-TO
------

See the [german tutoral](docu/tutorial.md) or the [english translation](https://github-com.translate.goog/OlafRadicke/daytona_beach/blob/main/docu/tutorial.md?_x_tr_sl=de&_x_tr_tl=en&_x_tr_hl=de&_x_tr_pto=wapp).


KNOWN ISSUES
------------

- The `Workflow` fail if the `WorkflowTemplate` are not installed first.
- The Vault Server lost his state in dev mode (so, don't stopped during your experiments).


CI/CD
-----

Github Action is used for building needed customized images.


TODOs / TAGs / PROJECT STATE
----------------------------

- [X] 0.0.x - Enable CronWorkflow
- [X] 0.2.x - Vault Server
- [X] 0.3.x - Checkout OpenTofu code
- [X] 0.4.x - Handle with artifacts / PVCs
- [X] 0.5.x - Add OpenTofu backend (PVC/local `-backend-config=PATH`)
- [X] 0.6.x - run OpenTofu code
- [X] 0.7.x - Integrate SOPS: Secrets OPerations
- [ ] 0.8.x - Code cleanups
- [ ] 0.9.x - Documentation
- [ ] 0.10.x - Update `manifest/workflow/99_disabled/03-CronWorkflow-terraform.yaml`

