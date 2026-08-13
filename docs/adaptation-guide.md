# Sicherer Anpassungsleitfaden

## 1. Eigenes Modell festlegen

Dokumentiere Cluster, Verantwortliche, DNS-Zone, Netzwerkgrenzen und Wiederherstellungsziele, bevor du Werte ersetzt. Nutze keine zufällig gewählten Produktivwerte.

## 2. IaC anbinden

- Konfiguriere ein geschütztes Remote-State-Backend.
- Passe Provider-Version und VM-Eingaben bewusst an.
- Verwende einen API-Token mit minimalen Rechten, der erst zur Laufzeit injiziert wird.
- Prüfe zuerst einen Plan; übernimm nie ungeprüft die Beispiel-VM-ID.

## 3. Ansible inventarisieren

- Ersetze die Dokumentationsadresse durch deine Inventory-Quelle.
- Richte kurzlebige SSH-Zertifikate oder eine vergleichbare dynamische Identität ein.
- Führe Syntax- und Check-Modus aus, bevor du konvergierst.
- Teste Idempotenz: Der zweite Lauf darf ohne Drift keine Änderung melden.

## 4. K3s und Fleet verbinden

- Registriere das Repository in Fleet außerhalb dieses Beispiels.
- Ersetze Namespace, Ingress-Domain und Image durch eigene, geprüfte Werte.
- Pinne Images nach Möglichkeit mit Digest.
- Verifiziere, dass der Cluster das Bundle zieht; nutze keinen parallelen `kubectl apply`-Pfad.

## 5. Vault und ESO einrichten

- Aktiviere Kubernetes-Authentisierung in deinem Vault separat und administrativ.
- Begrenze die Policy auf einen eigenen Beispielpfad.
- Lege den echten Wert direkt in Vault an, nie in Git oder CI-Logs.
- Passe `ClusterSecretStore` und ESO-Rolle an deine Umgebung an.

## 6. Delivery absichern

Dieses Repository enthält nur sichere Validierung. Für produktive Ausführung brauchst du einen separaten geschützten Workflow mit Review-Gates, kurzlebiger Authentisierung, unveränderlicher Artefaktidentität, Serialisierung und Live-Verifikation.
