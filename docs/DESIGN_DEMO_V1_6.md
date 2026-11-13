# Quest Compendium Forever – Design-Demo 1.6

Stand: 13.11.2026 – Demo-Entwicklungsstand, **keine Designfreigabe und keine Addon-Änderung**.

## Verbindliche Designbasis
- `design/references/03_Kombinierter_Referenzentwurf_VERBINDLICH.png` bleibt das Zielbild für das gesamte WoW-nahe Hauptfenster.
- `design/references/02_Abenteuerchronik_Megaentwurf.png` bleibt die Stilreferenz für die Innenansichten.

## Änderungen gegenüber 1.5
- Questchronik auf zwei illustrierten Buchseiten neu verteilt: drei vorausgehende Quests links, Abzweigung und Abschluss rechts.
- Mit weichen, leicht texturierten Pergamentflächen störende statische Überschriften unter der Questchronik abgedeckt; Buchrücken und Außenrahmen bleiben sichtbar.
- Goldene Verbindungswege mit Verlauf, Schatten, Glanz und kleinen ornamentalen Zwischenpunkten neu geführt.
- Questtafeln weniger gestaucht und mit besser lesbarer Schrift, Medaillons und Statusindikatoren ausgelegt.
- Questdetails: Beschreibung und Belohnungen lesbarer, NPC-Name und Koordinaten auf getrennten Zeilen, Hintergrund-Doppelungen vermindert.

## Technische Prüfung
Manueller Chromium-Playwright-Test ohne Netzwerk: Suche mit Vorschlägen; linke Questauswahl; sechs vollständig sichtbare Questknoten; Klick auf Quest/Detail; Zurück; Baum-/Listenwechsel; Mausverschieben; Maus-Skalierung über rechten unteren Griff; keine JavaScript-Laufzeitfehler.

## Einschränkungen
Die interaktive HTML-Datei ist ein selbstständiger **Designprototyp mit Beispieldaten**. Die äußere Oberfläche und ein Teil der rechten Karte stammen aus dem unveränderlichen freigegebenen Bild; nicht alle sichtbaren Texte sind dynamisch. Die WoW-Forever-Lua-Oberfläche und echte Questdaten werden erst später umgesetzt. Der im Browser getestete freie Zoom ist nicht die 80-%-Ingame-Grenze. Die Buchseiten sind in 1.6 noch nicht so detailreich wie die Stilreferenz; weitere Designabnahme erforderlich.

`archive/QuestCompendiumForever_Alpha_0.0.1.zip` und der Original-Addon-Code bleiben unverändert. Keine CI, Builds, Releases, Deployments, kostenpflichtige Dienste oder WoWHead-Datenübernahmen.
