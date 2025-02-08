DAYTONA_BEACH
=============

A experimental repo for SOAP, TOFU and ArgoCD-Workflow exercises and games.

- [DAYTONA\_BEACH](#daytona_beach)
	- [EXTERNAL DOKU](#external-doku)
	- [INSTALL](#install)
		- [SOPS](#sops)
		- [Vault client](#vault-client)
	- [GPG OPERATIONS](#gpg-operations)
	- [VAULT](#vault)
		- [Start Server local](#start-server-local)
		- [Check with client](#check-with-client)
		- [Create keys](#create-keys)
		- [Encrypt file](#encrypt-file)



EXTERNAL DOKU
-------------

* [Encrypting using Hashicorp Vault](https://github.com/getsops/sops?tab=readme-ov-file#encrypting-using-hashicorp-vault)

INSTALL
-------

### SOPS

Download: [on github](https://github.com/getsops/sops/releases)

### Vault client

```bash
$ sudo dnf install -y dnf-plugins-core
$ sudo dnf config-manager addrepo \
  --from-repofile=https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
$ sudo dnf -y install vault
```



GPG OPERATIONS
--------------


| Operation                         | Command                    |
|-----------------------------------|----------------------------|
| Kill gpg-agent                    | `gpgconf --kill gpg-agent` |
| List                              | `gpg -k`                   |
| list secret keys                  | `gpg -K`                   |
| decrypt data (default)            | `gpg -d`                   |
| generate a new key pair           | `gpg --generate-key`       |
| full featured key pair generation | `gpg --full-generate-key`  |
| export keys                       | `gpg --export`             |
| import/merge keys                 | `gpg --import`             |

VAULT
-----

Cline install: https://developer.hashicorp.com/vault/install

### Start Server local

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