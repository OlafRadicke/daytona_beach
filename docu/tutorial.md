TUTORAL
=======


|  <img src="pics/United_Kingdom_and_United_States_flags.svg.png" alt="en flag" width="20%"/> | [translate this page in english](https://github-com.translate.goog/OlafRadicke/daytona_beach/blob/main/docu/tutorial.md?_x_tr_sl=de&_x_tr_tl=en&_x_tr_hl=de&_x_tr_pto=wapp) |
|:--|--:|


<!-- width -->

- [TUTORAL](#tutoral)
	- [HINTERGRUND / EINFÜHRUNG](#hintergrund--einführung)
	- [DER LÖSUNGSANSATZ](#der-lösungsansatz)
	- [SCHRITT-FÜR-SCHRITT-ANLEITUNG](#schritt-für-schritt-anleitung)


HINTERGRUND / EINFÜHRUNG
------------------------

Immer mehr Setups werden auf Kubernetes betrieben. Der Grund ist denkbar einfach. In der Modernen IT möchte man Infrastructure as Code (IaC) haben und Kubernetes macht es einem einfach das zu tun. Leider ist es aber so, das wir sehr viel Software haben die an sich sehr etabliert und gut ist, aber leider nicht *Kubernetes native* ist. Der Königsweg ist immer, wenn man mit Hilfe eines Operators den kompletten life cycle (Installation, Konfiguration, Updates, Backup, Restore und Deinstallation) der Applikation abdecken kann. Ist es aber nicht so, dann muss man sich überlegen, wie man das anders realisiert.

DER LÖSUNGSANSATZ
-----------------

Ein etabliertes Tool aus der *Alten Welt*, vor Kubernetes, ist das Konfigurations-Tool *Terraform* oder in seinem aktuellen Fork *OpenTofu*. Es hat ein enorm grosses Ökosystem, das zu fast jedem Problem eine fertige Lösung anzubieten hat. Solange wie die alten Tools aus der Alten welt, nicht *Kubernetes Ready* sind, kann man versuchen mit Terraform die Schwächen zu kompensieren.

Nur wie schafft man das ohne Medienbruch. Weder will man Terraform/OpenTofu auf seinen lokalem Rechner laufen lassen[^foot001]. Noch möchte man extra eine Virtuelle Maschin dafür aufsetzen und betreiben. Die naheliegende Idee ist natürlich Terraform/OpenTofu in Kubernetes laufen zu lassen. Un das möglichst auf unkomplizierte weise. Wie das aussehen kann, wird mit dem Code in diesem Repro demonstriert.

SCHRITT-FÜR-SCHRITT-ANLEITUNG
-----------------------------

#TODO

[^foot001]: Sonst läuft man wieder in das *for-me-works-Problem* rein. Sprich, bei dem einen Kollegen funktioniert es, und die anderen wissen nicht, was sie falsch gemacht haben, das es bei ihnen nicht funktioniert.