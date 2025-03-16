TOFU
====


Backends
--------

Docu: [Backend Configuration](https://opentofu.org/docs/language/settings/backends/configuration/)




Use Docker Image
----------------

### Version

```bash
$ podman run -it --rm \
  -v $(pwd):/src:z \
  alpine/terragrunt:1.10.3 \
  --version
```

### Create backend directory

```bash
$ mkdir ${HOME}/terraform
```

### Init terraform

```bash
$ podman run -it --rm \
  -v $(pwd)/terraform/examples-01:/src:z \
  -v ${HOME}/terraform:/terraform/state/:z \
  --workdir /src \
  --entrypoint terraform \
  alpine/terragrunt:1.10.3 \
	init -backend-config="path=/terraform/state/terraform.tfstate"
```

### plan


```bash
$ podman run -it --rm \
  -v $(pwd)/terraform/examples-01:/src:z \
  -v ${HOME}/terraform:/terraform/state/:z \
  --workdir /src \
  --entrypoint terragrunt \
  alpine/terragrunt:1.10.3 \
  run-all plan
```

###  Apply

```bash
$ podman run -it --rm \
  -v $(pwd)/terraform/examples-01:/src:z \
  -v ${HOME}/terraform:/terraform/state/:z \
  --workdir /src \
  --entrypoint terragrunt \
  alpine/terragrunt:1.10.3 \
  run-all apply
```

Generell
--------

- [Terraform Files – How to Structure a Terraform Project](https://spacelift.io/blog/terraform-files)