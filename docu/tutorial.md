TUTORAL
=======


|  <img src="pics/United_Kingdom_and_United_States_flags.svg.png" alt="en flag" width="20%"/> | [translate this page in english](https://github-com.translate.goog/OlafRadicke/daytona_beach/blob/main/docu/tutorial.md?_x_tr_sl=de&_x_tr_tl=en&_x_tr_hl=de&_x_tr_pto=wapp) |
|:--|--:|


<!-- width -->

- [TUTORAL](#tutoral)
	- [HINTERGRUND / EINFÜHRUNG](#hintergrund--einführung)
	- [DER LÖSUNGSANSATZ](#der-lösungsansatz)
		- [Das Big Picture](#das-big-picture)
		- [Vorteile](#vorteile)
		- [Nachteile / Einschränkungen](#nachteile--einschränkungen)
	- [SCHRITT-FÜR-SCHRITT-ANLEITUNG](#schritt-für-schritt-anleitung)


HINTERGRUND / EINFÜHRUNG
------------------------

Immer mehr Setups werden auf Kubernetes betrieben. Der Grund ist denkbar einfach. In der Modernen IT möchte man Infrastructure as Code (IaC) haben und Kubernetes macht es einem einfach das zu tun. Leider ist es aber so, das wir sehr viel Software haben die an sich sehr etabliert und gut ist, aber leider nicht *Kubernetes native* ist. Der Königsweg ist immer, wenn man mit Hilfe eines Operators den kompletten life cycle (Installation, Konfiguration, Updates, Backup, Restore und Deinstallation) der Applikation abdecken kann. Ist es aber nicht so, dann muss man sich überlegen, wie man das anders realisiert.

DER LÖSUNGSANSATZ
-----------------

Ein etabliertes Tool aus der *Alten Welt*, vor Kubernetes, ist das Konfigurations-Tool *Terraform* oder in seinem aktuellen Fork *OpenTofu*. Es hat ein enorm grosses Ökosystem, das zu fast jedem Problem eine fertige Lösung anzubieten hat. Solange wie die alten Tools aus der Alten welt, nicht *Kubernetes Ready* sind, kann man versuchen mit Terraform die Schwächen zu kompensieren.

Nur wie schafft man das ohne Medienbruch. Weder will man Terraform/OpenTofu auf seinen lokalem Rechner laufen lassen[^foot001]. Noch möchte man extra eine Virtuelle Maschin dafür aufsetzen und betreiben. Die naheliegende Idee ist natürlich Terraform/OpenTofu in Kubernetes laufen zu lassen. Un das möglichst auf unkomplizierte weise. Wie das aussehen kann, wird mit dem Code in diesem Git Repository demonstriert.

### Das Big Picture

- Es wird ein Secret mit dem Vault-Server-Token erstellt
- Es wird ein *Hashicorp Vault-Server* in einem Kubernetes installier
- Mit Hilfe dieses Vault-Servers wird im Verzeichnis Terraform-Beispiel[^foot002] eine Datei mit Passwörtern verschlüsselt und in Git commited.
- Dann wird *Argo Workflows* in Kubernetes installiert
- Zum Schluss werden die Manifest-Dateien auf Kubernetes installiert, die die CI/CD-pipelines enthalten

Der Rest läuft automatisch mit Argo Workflows:

- Es wird ein temporäres PVC erstellt als Arbeitsverzeichnis
- Der Terraform-Code wird in das PVC geclont
- Mit Hilfe von `Mozilla SOPS` und dem *Hashicorp Vault-Server* wird die Datei mit den Passwörtern entschlüsselt.
- Terraform/OpenTofu wird initialisiert in dem es eine PVC als Backend in Kubernets verwendet.
- Dann läuft Terraform/OpenTofu und tut wofür es da ist[^foot003].

### Vorteile

- Die Geheimnisse bleiben im Kubernetes und werden nur dort entschlüsselt
- Der Terraform-State mit seinen Geheimnissen im Klartext bleibt per PVC in Kubernetes
- Durch die Verwendung von Vault und SOPS ist eine Key Rotation nicht zu aufwändig [^foot004] [^foot005]
- Da die Geheimnisse im Terraform-Code direkt gespeichert werde, ist das Handling einfacher. Es nicht mehr notwendig sich mit separat tools wie *Keepass* zu behelfen um Geheimnisse sicher zu speichern.

### Nachteile / Einschränkungen

- Mozilla SOPS unterstütz nur  YAML-, JSON-, ENV- and INI-Dateitypen aber Terraform verwendet `.tf` und Terragrunt `hcl`. Das bedeutet, das man nur die gesamte Datei verschlüsseln kann, statt nur den Teil der das eigentliche Geheimnis, wie ein Passwort darstellt.
- Das Henne-Ei-Problem den Vault-Server auch möglichst als IaC zu verwalten, kann auch dieses Setup nicht lösen. Das Secret das den Vault-Token beinhaltet, kann nicht im Vault-Server verwaltet werden.

SCHRITT-FÜR-SCHRITT-ANLEITUNG
-----------------------------

#TODO

[^foot001]: Sonst läuft man wieder in das *for-me-works-Problem* rein. Sprich, bei dem einen Kollegen funktioniert es, und die anderen wissen nicht, was sie falsch gemacht haben, das es bei ihnen nicht funktioniert.
[^foot002]: Ist in diesen Repository unter `terraform/examples-01` zu finden.
[^foot003]: In unserem Fall ist es nur ein "Hallo-Welt" ausgeben um zu zeigen, das die Passwörter erfolgreich entschlüsselt wurde.
[^foot004]: Siehe [Key rotation mit Vault](https://developer.hashicorp.com/vault/docs/internals/rotation)
[^foot005]: Siehe [Key Rotation mit SOPS](https://github.com/getsops/sops?tab=readme-ov-file#key-rotation)