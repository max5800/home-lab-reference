# Beitragen

Danke für dein Interesse. Dieses Repository soll klein, generisch und sicher reproduzierbar bleiben.

## Ablauf

1. Erstelle einen Branch aus `main`.
2. Verwende ausschließlich reservierte Beispieldaten (`example.com`, `192.0.2.0/24`) und generische Identitäten.
3. Führe `make validate` aus.
4. Beschreibe im Pull Request Lernziel, Sicherheitswirkung und getestete Befehle.

## Grenzen

- Keine echten Zugangsdaten, internen Hostnamen, Personeninformationen oder produktiven Konfigurationen.
- Keine CI-Schritte mit Secrets, OIDC, Self-hosted Runnern oder Schreibrechten.
- Keine Abhängigkeit, die während der Validierung aus dem Netzwerk geladen wird.
- Neue Beispiele müssen ohne Zugriff auf Infrastruktur verständlich sein.

Commits sollten kurz und eindeutig beschrieben sein, zum Beispiel `docs: explain fleet reconciliation`.
