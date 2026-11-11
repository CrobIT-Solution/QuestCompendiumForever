# Quest Compendium Forever – Interaktive Design-Demo 1.5

**Status:** Nicht freigegebener Designprototyp. **Kein Addon-Release.**

## Verbindliche Gestaltung

Die freigegebene Kombination aus dem ursprünglichen Hauptfenster und der gezeichneten Abenteuerchronik bleibt die visuelle Zielreferenz. Demo 1.5 verwendet die ursprüngliche Gesamtansicht und daraus abgeleitete wiederverwendbare Buch- und Questtafelbilder. Es handelt sich um einen weiteren visuellen Integrationsschritt, nicht um die endgültige 1:1-Umsetzung.

## Verbesserungen gegenüber Demo 1.4

- Pergamentübergänge: Weiche, organisch auslaufende Übergänge an den Buchseiten, gezeichnete Landschaftsmotive, sichtbarer Buchrücken und wiederhergestellte NPC-Porträts.
- Questtafeln: Individuelle kleine Fantasy-Motive für alle sechs Demoknoten, dreifach variierter Status (abgeschlossen, ausgewählt, verfügbar). Illustrierte Tafeln statt gestreckter flacher Verläufe; lesbarer dynamischer Questtext liegt separat darüber.
- Questpfade: Mehrschichtige goldene Verbindungen einschließlich Schatten, Glanz, Abzweigungen und ornamentalem Rhombus.
- Buchdetails: Leicht angepasste Fantasy-Schrifthierarchie, Pergamentfarben, Belohnungsleisten und Zurück-Button.
- Alle bisherigen Klick-, Such- und Fensterfunktionen bleiben erhalten.

## Im Browser geprüft

Mit lokalem Chromium/Playwright, ohne CI/Netz: Laden, Suche, Auswahl, sechs Questknoten, Baum-/Listenwechsel, Details, Zurück, Fensterziehen, Skalieren, keine JS-Laufzeitfehler. Kein tatsächlicher WoW-Forever-Ingame-Test.

## Geprüfte Einschränkungen

- Die Quests, NPC-Koordinaten, XP, Zeiten und Gruppenempfehlungen sind fiktive Beispielwerte.
- Hauptfenster und äußere Teile bleiben teilweise statische Grafikvorlage; Interaktionen betreffen die prototypischen Klickflächen und dynamischen Innenansichten.
- Linkfeld enthält einen Beispiel-WoWHead-Link, keinen bestätigten Zugriff auf WoWHead-Daten und öffnet keinen Browser aus dem Addon heraus.
- Browser-Demo ohne 80-Prozent-Begrenzung; die Begrenzung gilt nur für die geplante Ingame-Variante.

## Sicherheits- und Änderungsgrenzen

- **Keine Änderung** an `addon/` oder `archive/QuestCompendiumForever_Alpha_0.0.1.zip`.
- GitHub nur separater Feature-Branch; kein Merge nach `main`, keine CI, Builds, Releases oder Deployments.
- Rechte und Lizenzbedingungen vor Verwendung fremder Spieldaten separat klären.