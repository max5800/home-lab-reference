# Home Lab Reference

Eine sichere, bewusst generische Lernreferenz für ein mehrschichtiges Home-Lab mit Proxmox, OpenTofu/Terragrunt, Ansible, K3s, Rancher Fleet, Vault und External Secrets Operator (ESO).

> Dieses Repository ist ein eigenständiges Lehrprojekt. Es ist kein Fork, kein Backup und keine direkt einsetzbare Produktionskonfiguration. Alle Namen, Adressen und Secret-Pfade sind Beispiele.

![Architektur der Referenz](docs/architecture.svg)

## Was du hier lernst

- Infrastruktur als wiederverwendbares OpenTofu-Modul modellieren und per Terragrunt instanziieren
- Betriebssysteme idempotent mit Ansible konfigurieren
- K3s-Workloads per Rancher Fleet aus Git ausrollen
- Geheimnisse als Referenzen mit Vault und ESO einbinden, ohne Werte in Git zu speichern
- Änderungen mit einer credential-freien GitHub-Actions-Pipeline prüfen
- Verantwortlichkeiten und Freigaben entlang eines nachvollziehbaren GitOps-Flusses trennen

## Schichten

| Schicht | Verzeichnis | Aufgabe |
| --- | --- | --- |
| Provisionierung | `infrastructure/` | OpenTofu-Modul und Terragrunt-Live-Konfiguration für eine Beispiel-VM |
| Konfiguration | `configuration/` | Statisches Beispiel-Inventar, Playbook und idempotente Basisrolle |
| Plattform | `kubernetes/` | Fleet-Bundle, Deployment, Service, Ingress, Certificate und ExternalSecret |
| Geheimnisse | `vault/` | Minimale, illustrative Lesepolicy für ESO |
| Qualität | `scripts/`, `.github/workflows/` | Lokale, offline-fähige Prüfungen und sichere CI |

Die ausführliche Erklärung steht in [docs/architecture.md](docs/architecture.md). Eine browserfreundliche Diagrammversion liegt unter [docs/architecture.html](docs/architecture.html).

## Voraussetzungen

Die vollständige Offline-Basisvalidierung benötigt:

- Make, Bash und Git
- Ruby mit den Standardbibliotheken YAML und REXML
- `file` zur Dateitypprüfung
- ripgrep (`rg`) für die Privacy-Prüfungen

Optional werden `gitleaks`, OpenTofu, Terragrunt und `ansible-playbook` erkannt und für zusätzliche Prüfungen verwendet. Fehlt eines dieser optionalen Werkzeuge, meldet die Validierung den übersprungenen Teil ausdrücklich; sie installiert nichts und greift nicht auf das Netzwerk zu. Für die Ausbringung der Kubernetes-Beispiele werden zusätzlich Fleet, ESO, Traefik, cert-manager und ein passend konfigurierter Vault-`ClusterSecretStore` benötigt.

## Schnellstart

```sh
git clone https://github.com/max5800/home-lab-reference.git
cd home-lab-reference
make validate
```

Die Validierung greift nicht auf Netzwerk, Cluster, Hypervisor oder Vault zu. Sie prüft unter anderem Shell-Syntax, YAML-Struktur, XML/SVG, HCL-Format (falls OpenTofu vorhanden), Dateitypen, Links sowie öffentliche Allowlisten und hochsignalige Secret-Muster.

## Repository-Tour

1. Starte mit `infrastructure/modules/proxmox-vm/`: Variablen und Ressourcen sind wiederverwendbar; die Live-Konfiguration enthält nur Beispielwerte.
2. Folge zu `configuration/playbooks/site.yml`: Die Rolle beschreibt den gewünschten Zustand und löst Neustarts nur über Handler aus.
3. Öffne `kubernetes/bundles/example-app/`: Fleet zieht Manifeste aus Git; ESO erzeugt das Laufzeit-Secret aus einer Vault-Referenz.
4. Lies `docs/change-flow.md`: Pull Request, Validierung, Freigabe und GitOps-Reconciliation sind getrennte Schritte.

## Sicher anpassen

Kopiere niemals reale Zugangsdaten in dieses Repository. Ersetze zuerst nur die dokumentierten Beispielwerte und prüfe jede Schicht einzeln. Der vollständige Leitfaden steht in [docs/adaptation-guide.md](docs/adaptation-guide.md).

Wichtige Leitplanken:

- Nutze eigene DNS-Namen statt `example.com` und eigene Netze statt der Dokumentationsadressen `192.0.2.0/24`.
- Lege Secret-Werte ausschließlich im eigenen Secret-Backend ab; Git enthält nur Referenzen.
- Ersetze Beispiel-Images durch vertrauenswürdige, möglichst digest-gepinnte Images.
- Führe Provisionierung und Konvergenz nur in einer bewusst eingerichteten, geschützten Delivery-Pipeline aus.
- Verwende diese öffentliche CI niemals für Infrastrukturzugriff; sie ist absichtlich reine Validierung.

## Sicherheitsmodell und Grenzen

Das Modell trennt Code, kurzlebige Laufzeitidentitäten und Secret-Werte. Pull Requests erhalten keine Secrets, kein OIDC und keinen Zugriff auf interne Systeme. Details und Bedrohungsannahmen stehen in [docs/security-model.md](docs/security-model.md).

Nicht enthalten sind Hochverfügbarkeit, Backup/Restore, produktionsfertige Netzwerkregeln, Vault-Bootstrap, Hypervisor-Zugang, echte Clusterregistrierung, Observability oder ein automatischer Infrastruktur-Apply. Diese Punkte sind absichtlich umgebungsspezifisch.

## Lizenz und Mitarbeit

Der Inhalt steht unter der [MIT-Lizenz](LICENSE). Beiträge sind willkommen; bitte zuerst [CONTRIBUTING.md](CONTRIBUTING.md) und [SECURITY.md](SECURITY.md) lesen.
