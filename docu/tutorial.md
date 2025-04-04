TUTORAL
=======


|  <img src="pics/United_Kingdom_and_United_States_flags.svg.png" alt="en flag" width="20%"/> | [translate this page in english](https://github-com.translate.goog/OlafRadicke/daytona_beach/blob/main/docu/tutorial.md?_x_tr_sl=de&_x_tr_tl=en&_x_tr_hl=de&_x_tr_pto=wapp) |
|:--|--:|


- [TUTORAL](#tutoral)
	- [HINTERGRUND / EINFÜHRUNG](#hintergrund--einführung)
	- [DER LÖSUNGSANSATZ](#der-lösungsansatz)
		- [Das Big Picture](#das-big-picture)
		- [Vorteile](#vorteile)
		- [Nachteile / Einschränkungen](#nachteile--einschränkungen)
	- [SCHRITT-FÜR-SCHRITT-ANLEITUNG](#schritt-für-schritt-anleitung)
		- [Vorbereitung](#vorbereitung)
		- [Der Vault-Server](#der-vault-server)
		- [Schlüsselmaterial erstellen](#schlüsselmaterial-erstellen)
		- [Geheimnisse im Terraform-Code verschlüsseln](#geheimnisse-im-terraform-code-verschlüsseln)
		- [Argo Workflows installation](#argo-workflows-installation)
		- [Workflow-CI/CD laufen lassen](#workflow-cicd-laufen-lassen)
		- [Zur Details der Implementierung](#zur-details-der-implementierung)
	- [WEITERFḦRENDE DOKUMENTATIONEN](#weiterfḧrende-dokumentationen)


HINTERGRUND / EINFÜHRUNG
------------------------

Immer mehr Setups werden auf Kubernetes betrieben. Der Grund ist denkbar einfach. In der modernen IT möchte man Infrastructure as Code (IaC) haben und Kubernetes macht es einem einfach. Leider ist es aber so, dass wir viel Software haben, die an sich etabliert und gut ist, aber leider nicht *Kubernetes native* ist. Der Königsweg ist immer, mit Hilfe eines Operators den kompletten life cycle (Installation, Konfiguration, Updates, Backup, Restore und Deinstallation) der Applikation abzudecken. Ist es aber nicht möglich, muss man es anders realisieren.

DER LÖSUNGSANSATZ
-----------------

Ein etabliertes Tool aus der *alten Welt*, vor Kubernetes, ist das Konfigurations-Tool *Terraform* oder in seinem aktuellen Fork *OpenTofu*. Es hat ein enorm grosses Ökosystem, das zu fast jedem Problem eine fertige Lösung anzubieten hat. Solange die alten Tools nicht *Kubernetes Ready* sind, kann man versuchen die Schwächen mit Terraform zu kompensieren.

Aber wie schafft man das ohne Medienbruch? Weder will man Terraform/OpenTofu auf seinen lokalem Rechner laufen lassen[^foot001], noch möchte man extra eine virtuelle Maschine dafür aufsetzen und betreiben. Die naheliegende Idee ist Terraform/OpenTofu in Kubernetes laufen zu lassen und das möglichst auf unkomplizierte Weise. Wie das aussehen kann, wird mit dem Code in diesem Git Repository demonstriert.

### Das Big Picture

- Es wird ein Secret mit dem Vault-Server-Token erstellt
- Es wird ein *Hashicorp Vault-Server* in einem Kubernetes installiert
- Mit Hilfe dieses Vault-Servers wird im Verzeichnis Terraform-Beispiel[^foot002] eine Datei mit Passwörtern verschlüsselt und in Git commited.
- Dann wird *Argo Workflows* in Kubernetes installiert
- Zum Schluss werden die Manifest-Dateien auf Kubernetes installiert, die die CI/CD-Pipelines enthalten

Der Rest läuft automatisch mit Argo Workflows:

- Es wird ein temporäres PVC als Arbeitsverzeichnis erstellt
- Der Terraform-Code wird in das PVC geclont
- Mit Hilfe von `Mozilla SOPS` und dem *Hashicorp Vault-Server* wird die Datei mit Passwörtern entschlüsselt.
- Terraform/OpenTofu wird initialisiert indem es eine PVC als Backend in Kubernets verwendet
- Dann läuft Terraform/OpenTofu und tut wofür es da ist[^foot003]

### Vorteile

- Die Geheimnisse bleiben im Kubernetes und werden nur dort entschlüsselt
- Der Terraform-State mit seinen Geheimnissen im Klartext bleibt per PVC in Kubernetes
- Durch die Verwendung von Vault und SOPS ist eine Key Rotation nicht zu aufwändig [^foot004] [^foot005]
- Da die Geheimnisse im Terraform-Code direkt gespeichert werden, ist das Handling einfacher. Es nicht mehr notwendig sich mit separaten Tools wie *Keepass* zu behelfen, um Geheimnisse sicher zu speichern
- Die *Argo Workflows* sind flexibel und können leicht angepasst werden
- Mit dem YAML-Format, hat man eine Konfigurationssprache, die eine geringe Einstiegshürde darstellt
- Es gibt zu `Argo Workflos`, `Mozilla SOPS` und `Hashicorp Vault` gute Dokumentationen, viele Beispiele und ein breite Nutzerbasis

### Nachteile / Einschränkungen

- Mozilla SOPS unterstützt nur  YAML-, JSON-, ENV- and INI-Dateitypen aber Terraform verwendet `.tf` und Terragrunt `hcl`. Das bedeutet, dass man nur die gesamte Datei verschlüsseln kann, anstatt nur den Teil, der das eigentliche Geheimnis, wie ein Passwort darstellt.
- Das Henne-Ei-Problem den Vault-Server auch möglichst als IaC zu verwalten, kann auch dieses Setup nicht lösen. Das Secret, das den Vault-Token beinhaltet, kann nicht im Vault-Server verwaltet werden.

SCHRITT-FÜR-SCHRITT-ANLEITUNG
-----------------------------

### Vorbereitung

Als erstes braucht man einen lauffähigen Kubernetes. Entweder man hat schon einen, man erstellt sich einen in der (Public-)Cloud oder installiert sich local [K3s](https://docs.k3s.io/installation)

Die Skripte, die im Folgendem verwendet werden, nutzen das Tool [kubectx](https://github.com/ahmetb/kubectx). Entweder man installiert sich das Tool, oder entfernt es aus den Skripten.

In den Skript muss noch der Name des Ziel-Cluster durch den eigen Cluster-Namen geändert werden, wenn man das Tool *kubectx* verwendet.

Es werden zwei Namespaces werwendet. Zum Anlegen kann man den folgenden Befehl nutzen:

```bash
$ kubernetes apply --wait=true  -f manifest/namespaces
```

### Der Vault-Server

Für die Installation des Vault-Servers gibt es das Script `scripts/vault-server-install.sh`. Das Installations-Setup ist aber nicht für den produktiven Einsatz geeignet. Zu beachten ist auch, dass die Daten des Servers nicht persistent auf einem PVC liegen. Ein Restart/Reinstallation für also zu dem Verlust der dort generierten Keys.

Zur Deinstallation gibt es das Skript `scripts/vault-server-remove.sh`.

Damit der Vault-Server für unseren nächsten Schritt auch lokal verfügbar ist, brauchen wir noch ein `port-forward`. Hier bei hilft das Skript `scripts/vault-portforward.sh`.

:fire: Damit der Vault-Server im Cluster und lokal bei uns unter den selben Namen erreichbar ist, muss noch ein Eintrag in der `/etc/hosts` gemacht werden. Das ist insofern wichtig, da SOPS den FQDN des Key-Server (Vault-Server) als Meta-Information in der verschlüsselten Datei speichert.

Der Eintrag könnte etwa so aussehen:

```ini
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 vault-server.vault
```

Da der Vault-Service im Namespace `vault` mit dem Namen `vault-server` laufen wird.

### Schlüsselmaterial erstellen


Für die nächsten Schritte muss CLT `vault` installiert sein. Installationsanleitung siehe [HIER](https://developer.hashicorp.com/vault/tutorials/get-started/install-binary).

Vom Tool werden zwei Umgebungsvariablen erwartet, die wir setzen müssen.

1. Damit der FQDN unter der der Vault-server zu erreichen ist:

```bash
$ export VAULT_ADDR=http://vault-server.vault:8200
```

2. Und der Token, mit dem wir uns authentifizieren, muss der gleiche Token sein, den wir auch bei der Installation des Vault-Servers verwendet haben[^foot006]:

```bash
$ export VAULT_TOKEN=toor
```

Um zu überprüfen ob alles passt, machen wir eine Statusabfrage auf den Vault-Server:

```bash
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
```

Wenn es keine Fehler gibt, machen wir weiter mit der erforderlichen Aktivierung einer Transit-Engine. Es wird empfohlen, eine Transit-Engine speziell für SOPS zu erstellen, in der mehrere Schlüssel mit unterschiedlichen Berechtigungsstufen vorhanden sein können.

```bash
$ vault secrets enable -path=sops transit

Success! Enabled the transit secrets engine at: sops/
```

Jetzt ist es an der Zeit, das Schlüsselmaterial vom Vault generieren zu lassen, mit dem wir unsere Geheimnisse im Terraform-Coder verschlüsseln wollen:

```bash
$ vault write sops/keys/default type=rsa-4096

Success! Data written to: sops/keys/default
```

### Geheimnisse im Terraform-Code verschlüsseln

:fire: Für diesen Schritt muss der `port-forward` zum Vault-Server aktiviert sein (siehe oben)!

Es gibt im Verzeichnis mit dem Terraform-Beispiel-Code ein Unterverzeichnis `terraform/examples-01/sops-clear-text` in dem eine Terragrunt-Datei mit einem Passwort in Klartext liegt (`user_password`). Diese Datei werden wir jetzt mit unserem neu generiertem Key verschlüsseln und an seinem zugedachtem Ort im Verzeichnis `terraform/examples-01` speichern. Beachte, das der Token in `VAULT_TOKEN` auch der ist, mit dem der Vault-Server konfiguriert wurde.

```bash
$ export VAULT_ADDR=http://vault-server.vault:8200
$ export VAULT_TOKEN='ChaNG_mE,plEAse!!'
$ sops encrypt \
  --hc-vault-transit $VAULT_ADDR/v1/sops/keys/default \
  terraform/examples-01/sops-clear-text/terragrunt.hcl \
  > terraform/examples-01/terragrunt.hcl.sops
```

Wenn wir uns jetzt die erstellte Datei `terraform/examples-01/terragrunt.hcl` ansehen, stellen wir fest, dass das Passwort nicht mehr lesbar ist.

Wenn wir testen wollen, ob wir die Datei auch wieder entschlüsseln können, geht das über diesen Befehl:

```bash
$ sops decrypt terraform/examples-01/terragrunt.hcl.sops
```

Damit die Workflows-CI/CD die Datei auch per Git pullen kann, dürfen wir nicht vergessen, sie auch zu commiten.

```bash
$ git add terraform/examples-01/terragrunt.hcl.sops
$ git commit -m 'Add cryped terragrunt file with password.'
$ git push
```

### Argo Workflows installation

Die Installation von *Argo Workflows* kann mit den Skript `scripts/flow-install.sh` erfolgen. Hierbei ist eigentlich nichts zu beachten.

Für weitere Informationen zu *Argo Workflows* sei auf die Projektseite verwiesen: [github.com/argoproj/argo-workflows](https://github.com/argoproj/argo-workflows/blob/main/README.md)

### Workflow-CI/CD laufen lassen

Der letzte Schritt ist nun, die Manifest-Dateien der Argo Workflows zu installieren. :fire: Hier ist zu beachten, dass erst die `WorkflowTemplate` und dann erst die `Workflow` bzw. die `CronWorkflow` installiert werden müssen. Das Skript `scripts/ci-install.sh` tut das aber automatisch in der richtigen Reihenfolge.

Um zu sehen ob alles funktioniert, können wir auf die Weboberfläche von Argo Workflows gehen. Wenn wir kein Ingress einrichten wollen, können wir das Skript `scripts/flow-portforward.sh` verwenden, um ein `port-forward` aufzubauen. Danach ist die Weboberfläche über [https://localhost:2746/](https://localhost:2746/) erreichbar.

![Weboberfläche von Argo Workflows](pics/screenshot-workflows.png)

Kommt es zu Fehlern, kann man das Skript `scripts/flow-get.sh` verwenden, um das Problem einzukreisen. Es gibt auf der Kommandozeile den Status der Workflows-Objekt zurück.


### Zur Details der Implementierung

Der Code in der Datei *[03-Workflow-terraform.yaml](../manifest/workflow/05_after/03-Workflow-terraform.yaml)* ist sehr detailliert kommentiert. Die CI/CD-Pipeline wird nur einmal aufgeführt. Möchte man dass der Workflow alle X Minuten aufgerufen wird, verwendet man `CronWorkflow` statt `Workflow` so wie in [03-CronWorkflow-terraform.yaml](../manifest/workflow/05_after/03-CronWorkflow-terraform.yaml) gezeigt.


WEITERFḦRENDE DOKUMENTATIONEN
-----------------------------

* [Encrypting using Hashicorp Vault](https://github.com/getsops/sops?tab=readme-ov-file#encrypting-using-hashicorp-vault)
* [Argo Workflow Git-Repo](https://github.com/argoproj/argo-workflows?tab=readme-ov-file)
* [Examples](https://github.com/argoproj/argo-workflows/tree/main/examples)
* [Cron workflows](https://argo-workflows.readthedocs.io/en/latest/cron-workflows/)
* [Volumes](https://argo-workflows.readthedocs.io/en/latest/walk-through/volumes/)
* [Workflow Templates](https://argo-workflows.readthedocs.io/en/latest/workflow-templates/)
* [Teragrunt](https://terragrunt.gruntwork.io/)

----

[^foot001]: Sonst läuft man wieder in das *for-me-works-Problem* rein. Sprich: bei dem einen Kollegen funktioniert es, und die anderen wissen nicht, was sie falsch gemacht haben, weil es bei ihnen nicht funktioniert.
[^foot002]: Ist in diesen Repository unter `terraform/examples-01` zu finden.
[^foot003]: In unserem Fall ist es nur eine "Hallo-Welt" Ausgabe um zu zeigen, dass die Passwörter erfolgreich entschlüsselt wurde.
[^foot004]: Siehe [Key rotation mit Vault](https://developer.hashicorp.com/vault/docs/internals/rotation)
[^foot005]: Siehe [Key Rotation mit SOPS](https://github.com/getsops/sops?tab=readme-ov-file#key-rotation)
[^foot006]: Der steht in der Datei `manifest/services/01-Secret-vault-token.yaml`