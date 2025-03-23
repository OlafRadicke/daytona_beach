SOPS
====


Download: [on github](https://github.com/getsops/sops/releases)


Encrypting using Hashicorp Vault
--------------------------------

Doku: [Encrypting using Hashicorp Vault](https://github.com/getsops/sops/?tab=readme-ov-file#encrypting-using-hashicorp-vault)

More information about Vault Server setup see: [docu/vault-server.md](vault-server.md)

Used client image
-----------------

The used Docker image is build with the *Actions* ci build pipeline. See [.github/workflows](../.github/workflows)
You finde the result on [hub.docker.com](https://hub.docker.com/repository/docker/olafradicke/alpine-sops/general)

```bash
podman run --rm -it olafradicke/alpine-sops:0.7.2 --version
podman run --rm -it docker.io/olafradicke/alpine-sops:0.7.2  --version

```

Use Vault Server
----------------

### Check with client

```bash
$ export VAULT_ADDR='http://localhost:8200'
$ export VAULT_TOKEN='ChaNG_mE,plEAse!!'
$ vault status
```

### Create keys

It is required to enable a transit engine if not already done (It is suggested
to create a transit engine specifically for SOPS, in which it is possible to
have multiple keys with various permission levels)

```bash
$ vault secrets enable -path=sops transit
```

Example for `.sops.yaml` file:

```yaml
creation_rules:
    - path_regex:  \.test\.tf$
      hc_vault_transit_uri: "http://127.0.0.1:8200/v1/sops/keys/firstkey"
    - path_regex: \.yaml.secret$
      hc_vault_transit_uri: "http://127.0.0.1:8200/v1/sops/keys/secondkey"
    - path_regex: \.prod\.yaml$
      hc_vault_transit_uri: "http://127.0.0.1:8200/v1/sops/keys/thirdkey"
```

Create one or more keys

```bash
$ vault write sops/keys/firstkey type=rsa-4096
```

### Encrypt file with Server in Kubernetes

Start portforwarding

```bash
$ scripts/vault-portforward.sh
```

encrypt:

```bash
$ export VAULT_ADDR='http://localhost:8200'
$ export VAULT_TOKEN='ChaNG_mE,plEAse!!'
$ sops encrypt \
  --hc-vault-transit $VAULT_ADDR/v1/sops/keys/default \
  terraform/examples-01/sops-clear-text/terragrunt.hcl \
  > terraform/examples-01/terragrunt.hcl.sops
```

### Decrypt  file with Server in Kubernetes

Start portforwarding

```bash
$ scripts/vault-portforward.sh
```

Enter:

```bash
$ export VAULT_ADDR='http://localhost:8200'
$ export VAULT_TOKEN='ChaNG_mE,plEAse!!'
$ sops decrypt \
  terraform/examples-01/terragrunt.hcl.sops \
  > terraform/examples-01/terragrunt.hcl
```

