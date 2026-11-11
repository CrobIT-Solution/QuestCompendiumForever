# Design-Demo 1.4 – integriertes Quest Compendium Forever

**Status:** Interaktiver Browser-Prototyp, **noch nicht designfreigegeben**. Keine neue WoW-Addon-Version.

## Verbindliche Vorlagen
- `design/references/03_Kombinierter_Referenzentwurf_VERBINDLICH.png` bleibt die gestalterische Gesamtvorlage.
- Hauptfenster, Questsuche, Karte, Questreihenleiste, zwei Reihen mit sechs Infoboxen und WoWHead-Kopierbereich bleiben in ihrer grundlegenden Anordnung bestehen.
- `design/references/02_Abenteuerchronik_Megaentwurf.png` ist die Referenz für die Buch- und Questchronikgestaltung.
- Die hier verwendeten WebP-Texturen sind **abgeleitete Demo-Ressourcen**, keine freigegebenen finalen WoW-Texturen.

## Inhalte
- `demo/QuestCompendiumForever_DesignDemo_v1.4.html`: vollständig offline nutzbare Demo (Bilder sind eingebettet).
- `assets/ui/base.webp`: Ansicht des freigegebenen kombinierten Entwurfs.
- `assets/ui/book_dynamic.webp`, `assets/ui/book_chronicle.webp`: austauschbare, vom Original abgeleitete Innenansichten.
- `assets/ui/plaque_wide_*.webp`: grafische Questtafeln nach Queststatus.

## Interaktion
- Suchvorschläge; linke Questauswahl öffnet die Questreihen-Chronik.
- Baum- und Listenansicht mit anklickbaren Knoten; Klick öffnet die Questdetails.
- Zurück-Button und illustriertes Questbuch mit Questgeber-Koordinaten.
- Klickbare Kartenbereiche mit **illustrativen** Questgeberhinweisen.
- Dynamische erste Infoboxenreihe; Original-Gesamtreihe bleibt als Bildreferenz sichtbar.
- Kopierbares WoWHead-**Beispiel**feld; es gibt keinen direkt startbaren Browser aus Lua.
- Browserfenster per Titelleiste verschiebbar und rechts unten frei skalierbar; die spätere **80%-Grenze gilt nur im Spiel**.

## Technischer Prüfumfang
Lokaler Chromium-Playwright-Test (ohne GitHub Actions, CI oder Netzverbindung):
- sechs Baumknoten sichtbar und anklickbar
- Suchvorschläge, Listen-/Baumwechsel, Details und Zurücknavigation
- Maus-Verschieben und -Skalieren ändern tatsächliche Fensterposition bzw. Größe
- keine JavaScript-Laufzeitfehler bei den geprüften Klickabläufen

**Noch offen:** Weitere manuelle Designabnahme, authentischere flexible Buch-/Questtexturen, echte WoW-Forever-Lua-Oberfläche, echte Questdaten und deren Nutzungsrechte.

## Unverändert und ausgeschlossen
- `archive/QuestCompendiumForever_Alpha_0.0.1.zip` bleibt unverändert (SHA-256: `1fa0564dd82598f88ccf6b6120ae6a3d96228b556a769c3cfbb0020a20f7e9b1`).
- Keine Addon-Codeänderungen, Builds, CI, Releases oder Deployments.
- Keine kostenpflichtigen Dienste und keine Nutzung von WoWHead-Daten ohne ausdrückliche Berechtigung.
