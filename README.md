# Quest Compendium Forever

Privates Entwicklungsrepository des Addons **Quest Compendium Forever** für **WoW Forever**.  
Entwickler/Maintainer: **Blackiron**. Repository-Ziel: **CrobIT-Solution/QuestCompendiumForever**.

> **Stand 11.11.2026:** Initialer Sicherungs- und Übernahmestand, **keine neue Addon-Version**. Alpha 0.0.1 ist ein ungetesteter Ingame-Prototyp. Es gab keine CI, Builds, Releases oder Deployments.

## Verbindliche Designvorlagen

1. `design/references/01_Hauptfenster_Original.png` – ursprüngliches Hauptfenster.
2. `design/references/02_Abenteuerchronik_Megaentwurf.png` – Stilvorlage für Questbaum und Questdetails.
3. `design/references/03_Kombinierter_Referenzentwurf_VERBINDLICH.png` – **maßgeblicher kombinierter Zielentwurf** (beide Vorlagen aus einem Guss).

Der letzte Punkt ist die gestaltende Hauptreferenz; spätere HTML-Prototypen sind **nicht** automatisch freigegeben. Hauptfenster, Suche, Karte, zwei Reihen mit je sechs Infoboxen und WoWHead-Kopierfeld gehören zur freigegebenen Zielgestaltung. Die obere Titelleiste soll Verschieben, Skalieren, Wiederherstellen und Maximieren auf höchstens 80 % Breite und 80 % Höhe **im Spiel** unterstützen. In der Browser-Demo entfällt diese Grenze.

## Verzeichnisstruktur

- `addon/QuestCompendiumForever/` – aus der Alpha 0.0.1 unverändert extrahierte sechs Dateien.
- `archive/QuestCompendiumForever_Alpha_0.0.1.zip` – **unveränderte Original-ZIP**, keine neue Release-Datei.
- `design/references/` – drei verbindliche freigegebene Designreferenzen.
- `demo/QuestCompendiumForever_DesignDemo_v1.3.html` – vorhandener, **nicht designfreigegebener** Browser-Zwischenstand, nur Archiv/Technikreferenz.
- `docs/` – Status, Testbericht, Designregeln und Importhinweise.
- `SHA256SUMS.txt` – Datei-Prüfsummen, um die Originale zu kontrollieren.

## Abgrenzungen

- Keine Nutzung fremder WoWHead-Questdaten vor eindeutiger Freigabe für **dieses** Projekt; Supportanfrage zu WoW-Market ist keine Generalgenehmigung.
- Questdaten in Screenshots/HTML-Demo sind **fiktive Beispieldaten**, keine verifizierte WoW-Forever-Datenbank.
- Für echte Funktionalität sind WoW-Forever-Ingame-Tests und API-Abgleiche nötig. Der Alpha-Testbericht verwendet Mock-APIs.
- Keine kostenpflichtigen Dienste, automatischen Actions/CI, Builds, Releases oder Deployments ohne gesonderte Freigabe.
- Grafikrechte sowie Nutzungsbedingungen vor öffentlicher Verteilung separat prüfen; das Repository bleibt bis dahin privat.

**Wichtig:** Die Dateien in diesem Importpaket sind die dokumentierte Bestandsübernahme, keine stillschweigende Freigabe zur Änderung des Addons.
