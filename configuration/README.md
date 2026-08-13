# Ansible-Beispiel

Voraussetzung fuer die Beispielrolle und ihre Dienste ist Debian/Ubuntu mit systemd.

Das Inventar nutzt eine RFC-5737-Dokumentationsadresse und ist ohne Anpassung nicht erreichbar. Die Basisrolle zeigt idempotente Paket-, Datei- und Servicezustände. Ein Neustart erfolgt nur über einen Handler, wenn sich die zugehörige Konfiguration ändert.

Eine reale Umgebung sollte dynamisches Inventar und kurzlebige SSH-Zertifikate nutzen. Der private Schlüssel gehört weder ins Repository noch in das Inventar.
