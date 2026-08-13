# Infrastructure-Beispiel

`modules/proxmox-vm` kapselt eine kleine VM-Ressource. `live/lab/example-vm` instanziiert sie mit reservierten Beispielwerten. Terragrunt generiert einen lokalen State und eine Providerkonfiguration; echte Credentials werden ausschließlich zur Laufzeit über die vom Provider dokumentierten Umgebungsvariablen bereitgestellt.

Die Dateien sind syntaktische Lehrbeispiele. Vor einem Plan müssen Endpoint, Zertifikatsvertrauen, VM-Template, Netzwerk, Storage, SSH-Key-Injektion und State-Backend sicher an die eigene Umgebung angepasst werden. Dieses Repository führt weder `plan` noch `apply` automatisch aus.
