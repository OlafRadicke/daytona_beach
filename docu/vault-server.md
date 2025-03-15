VAULT SERVER
============

Setup Vault Server
------------------

Use the bash script [scripts/vault-server-install.sh](../scripts/vault-server-install.sh) for bootstraping an Vautl server instance.

```bash
$ scripts/vault-server-install.sh
```

But don't use this for produktiv. This example use the token in clear text!

### Init key

```bash
$ # Substitute this with the address Vault is running on
$ export VAULT_ADDR=http://127.0.0.1:8200

$ # this may not be necessary in case you previously used `vault login` for production use
$ export VAULT_TOKEN=toor

$ # to check if Vault started and is configured correctly
$ vault status
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    1
Threshold       1
Version         1.2.0
Cluster Name    vault-cluster-618cc902
Cluster ID      e532e461-e8f0-1352-8a41-fc7c11096908
HA Enabled      false

$ # It is required to enable a transit engine if not already done (It is suggested to create a transit engine specifically for SOPS, in which it is possible to have multiple keys with various permission levels)
$ vault secrets enable -path=sops transit
Success! Enabled the transit secrets engine at: sops/

$ # Then create one or more keys
$ vault write sops/keys/firstkey type=rsa-4096
Success! Data written to: sops/keys/firstkey
```



Troubleshooting
---------------

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

