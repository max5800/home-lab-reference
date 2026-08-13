# Sicherheitsrichtlinie

## Sicherheitsproblem melden

Bitte veröffentliche vermutete Secret-Leaks oder verwertbare Schwachstellen nicht in einem öffentlichen Issue. Nutze stattdessen GitHubs Funktion **Private vulnerability reporting** auf der Security-Seite dieses Repositorys, sofern sie aktiviert ist.

Teile nur die zum Reproduzieren notwendigen Informationen und niemals echte Geheimnisse. Maintainer bestätigen den Eingang, bewerten den Umfang und koordinieren eine Korrektur vor einer Veröffentlichung.

## Unterstützter Umfang

Nur der aktuelle Stand von `main` wird gepflegt. Die Beispiele sind Lehrmaterial und stellen keine gehärtete Produktionsplattform dar.

## Erwartete Sicherheitsinvarianten

- Keine Zugangsdaten oder persönlichen Infrastrukturdaten im Repository
- Credential-freie CI mit ausschließlich lesendem Repositoryzugriff
- Secret-Werte nur in einem externen Secret-Backend
- Keine automatischen oder manuellen Remote-Mutationen durch Validierungsskripte
