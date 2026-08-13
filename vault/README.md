# Vault-Policy-Beispiel

Die Policy erlaubt nur das Lesen eines einzelnen generischen KV-v2-Pfads. Sie enthält weder Rollen-Setup noch Token oder Secret-Werte.

In einer realen Umgebung wird die Policy administrativ an eine dedizierte ESO-Kubernetes-Rolle gebunden. Die Workload erhält keinen direkten Vault-Token. Bootstrap und Auth-Backend-Konfiguration bleiben bewusst außerhalb dieses öffentlichen Beispiels.
