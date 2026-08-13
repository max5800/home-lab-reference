# Fleet- und K3s-Beispiel

Das Bundle zeigt Namespace-Isolation, ein eingeschränktes Deployment, Service, Ingress, ein cert-manager-`Certificate` und ein ESO-`ExternalSecret`. Es setzt voraus, dass Fleet, ESO, Traefik, cert-manager, ein `ClusterIssuer` namens `example-issuer` und ein `ClusterSecretStore` namens `vault-example` bereits separat installiert und sicher konfiguriert sind. Der Issuer ist absichtlich nicht Teil des Bundles, weil seine ACME- oder CA-Konfiguration umgebungsspezifisch ist.

`app.example.com` ist ein Platzhalter. Das öffentliche Test-Image macht das Manifest nachvollziehbar, sollte aber vor einer echten Reconciliation durch ein geprüftes und digest-gepinntes eigenes Image ersetzt werden. Das Beispiel nutzt absichtlich kein Kubernetes-`Secret` mit eingebetteten Werten und enthält keinen manuellen Apply-Pfad.
