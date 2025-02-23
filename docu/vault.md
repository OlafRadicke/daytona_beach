VAULT
-----

### Vault client

```bash
$ sudo dnf install -y dnf-plugins-core
$ sudo dnf config-manager addrepo \
  --from-repofile=https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
$ sudo dnf -y install vault
```


Cline install: https://developer.hashicorp.com/vault/install

### Start Server local

[Docker image of Vault](https://hub.docker.com/_/vault)

```bash
$ export VAULT_TOKEN=$(tr -dc 'A-Za-z0-9!?%=' < /dev/urandom | head -c 16)
$ export VAULT_SERVER_PORT=8200
$ docker run -d --rm \
   -p ${VAULT_SERVER_PORT}:${VAULT_SERVER_PORT} \
   vault:1.2.0 \
   server -dev -dev-root-token-id=${VAULT_TOKEN}
$ export VAULT_ADDR=http://127.0.0.1:${VAULT_SERVER_PORT}
```

### Check with client

```bash
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

### Encrypt file

```bash
$ sops encrypt --hc-vault-transit $VAULT_ADDR/v1/sops/keys/firstkey examples/hello.test.tf > ./crypted/hello.test.tf
```