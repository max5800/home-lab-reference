# Architektur

Die Referenz folgt einem geschichteten GitOps-Modell. Jede Schicht besitzt eine klar begrenzte Verantwortung und konsumiert nur die Ausgabe der vorherigen Schicht.

## Datenfluss

1. Ein Pull Request verändert deklarative Dateien und durchläuft ausschließlich lokale, credential-freie Prüfungen.
2. OpenTofu beschreibt die VM-Ressource auf dem Hypervisor. Terragrunt hält umgebungsspezifische Eingaben außerhalb des Moduls.
3. Ansible konvergiert Betriebssystemzustand und K3s-Voraussetzungen idempotent.
4. Rancher Fleet beobachtet Git und zieht freigegebene Kubernetes-Manifeste in den Cluster.
5. ESO authentisiert sich zur Laufzeit gegen Vault und materialisiert genau das von der Anwendung benötigte Kubernetes-Secret.

Das Diagramm ist als [GitHub-SVG](architecture.svg) und als [eigenständige HTML-Version](architecture.html) verfügbar.

## Vertrauenszonen

- **Beitragszone:** Entwicklerarbeitsplatz und Pull Request. Keine Produktionsidentitäten.
- **Steuerungsebene:** Git, IaC und Konfigurationscode. Nur deklarative Zustände.
- **Laufzeitzone:** Hypervisor, K3s und Workloads. Zugriff nur über bewusst eingerichtete kurzlebige Identitäten.
- **Secret-Zone:** Vault hält Werte; Git und CI kennen nur Pfade und Schemas.

## Eigentümerschaft

| Bereich | Typische Verantwortung | Freigabefokus |
| --- | --- | --- |
| `infrastructure/` | Platform/IaC | Ressourcenwirkung, State, Wiederverwendbarkeit |
| `configuration/` | Configuration | Idempotenz, Härtung, minimale Änderung |
| `kubernetes/` | Platform/App | GitOps-Kompatibilität, RBAC, Laufzeitsicherheit |
| `vault/` | Security | Least Privilege und Trennung von Werten/Referenzen |
| `.github/workflows/` | Repository-Maintainer | Trigger, Runner und minimale Berechtigungen |
