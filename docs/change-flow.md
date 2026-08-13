# Änderungsfluss

## 1. Entwurf

Eine Änderung beginnt in einem kurzen Branch. Die betroffene Schicht und ihre Wirkung werden beschrieben. Reale Zugangsdaten bleiben außerhalb von Git.

## 2. Lokale Prüfung

`make validate` prüft Struktur und Hygiene ohne Netzwerk. Optionale installierte Werkzeuge erweitern die Prüfung, sind aber keine verdeckten Downloads.

## 3. Pull Request

GitHub Actions läuft auf einem frischen GitHub-gehosteten Runner mit `contents: read`. Der Workflow besitzt weder Secrets noch OIDC oder Schreibrechte.

## 4. Fachliche Freigabe

Reviewer beurteilen die betroffene Schicht, die Sicherheitsinvarianten und den Rollback-Plan. Eine grüne Syntaxprüfung ersetzt keine Wirkungsprüfung.

## 5. Reconciliation

In einer eigenen realen Umgebung würden geschützte, kurzlebig authentisierte Prozesse IaC und Ansible ausführen; Fleet zieht Kubernetes-Zustand selbstständig aus Git. Dieses Referenzrepository implementiert diese produktive Mutation absichtlich nicht.

## 6. Verifikation

Akzeptanz bedeutet: gewünschter Zustand ist in der Zielumgebung sichtbar, Health Checks bestehen und die beobachtete Revision entspricht der freigegebenen Revision. CI-Erfolg allein ist kein Deployment-Nachweis.
