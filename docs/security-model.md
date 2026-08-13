# Sicherheitsmodell

## Ziele

- Ein Leak des Git-Repositorys offenbart keine nutzbaren Zugangsdaten.
- Pull-Request-Code erreicht keine private Infrastruktur.
- Jede Laufzeitidentität erhält nur die minimal benötigten Rechte.
- Secret-Werte und deklarative Konfiguration bleiben getrennt.

## Kontrollen

1. **Beispieldaten:** Ausschließlich reservierte Domain- und IP-Bereiche.
2. **Vault-Referenzen:** Die Kubernetes-Dateien benennen nur einen generischen Remote-Pfad und eine Property.
3. **ESO:** Die Anwendung liest ein von ESO erzeugtes Secret, nicht Vault direkt.
4. **Credential-freie CI:** `contents: read`, GitHub-gehosteter Runner, kein OIDC, keine Secrets, keine Remote-Mutation.
5. **Offline-Validierung:** Skripte prüfen Dateien im Checkout und rufen keine externen Ziele auf.

## Bedrohungsannahmen

Untrusted Pull-Request-Code kann beliebige Repositorydateien beeinflussen. Deshalb darf PR-CI niemals auf langlebige Runner, interne Netze oder privilegierte Tokens treffen. Ein kompromittiertes Workload-Image darf nicht automatisch Vault lesen; ESO materialisiert nur das explizit erlaubte Secret.

## Nicht gelöste Risiken

Die Referenz liefert keine fertige PKI, Firewall, Policy Engine, Supply-Chain-Attestierung oder Backup-Strategie. Der Beispiel-Webserver ist kein Produktionsworkload. Wer die Dateien adaptiert, muss Images, Provider, Actions und Rollen separat prüfen und pinnen.
