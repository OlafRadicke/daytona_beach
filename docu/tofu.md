TOFU
====


Backends
--------

Docu: [Backend Configuration](https://opentofu.org/docs/language/settings/backends/configuration/)




Use Docker Image
----------------


```bash
$ podman run -it --rm \
  -v $(pwd):/src:z \
  alpine/terragrunt:1.10.3 \
  --version
```

```bash
$ mkdir ${HOME}/terraform
```

```bash
$ podman run -it --rm \
  -v $(pwd):/src:z \
  -v ${HOME}/terraform:/terraform/state/:z \
  --workdir /src \
  --entrypoint terraform \
  alpine/terragrunt:1.10.3 \
	init -backend-config="path=/terraform/state/terraform.tfstate"
```

```bash
$ podman run -it --rm \
  -v $(pwd):/src:z \
  -v ${HOME}/terraform:/terraform/state/:z \
  --workdir /src \
  --entrypoint terragrunt \
  alpine/terragrunt:1.10.3 \
  run-all -backend-config=backend.tf apply
```