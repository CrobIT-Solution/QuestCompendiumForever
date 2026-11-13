# Quest Compendium Forever – Design-Demo 1.6.1

Status: **Technischer und optischer Korrektur-Zwischenstand**, noch keine endgültige Designfreigabe.

## Anlass

Beim Wechsel von der statischen Startansicht der Demo 1.6 zu interaktiven Questansichten wurden Teile der freigegebenen Grafik durch schlichte Rechtecke überlagert: ein nicht passender Titelbalken, deckende Pergament-Flächen, neue statt der originalen Info-Boxen und eine gestreckte Questreihe. In der linken Liste blieb außerdem die original markierte Quest unter der neuen Auswahl sichtbar.

## Korrekturen

- Bild der freigegebenen Startansicht bleibt unverändert.
- Interaktive Auswahl in der linken Questliste ohne doppelte Markierung.
- Dynamischer Titel mit Leder-/Goldgestaltung über der vollständig abgedeckten statischen Titelzeile.
- Dynamische Effizienzwerte in den sechs **ursprünglichen** Infobox-Rahmen, ohne die Rahmen zu ersetzen.
- Untere illustrierte Questreihe bleibt das Originalbild; für neue Auswahl wird lediglich eine dezente Auswahlmarkierung hinzugefügt. Bisheriger fest eingebrannter Goldrahmen wird bei anderer Auswahl abgedunkelt.
- Pergament-Überlagerungen zurückgenommen: vorhandene Landschaftsillustrationen und NPC-Porträts werden weniger überdeckt.
- Störendes, für die Chronik nicht passendes, auf dem Buchbild vorgedrucktes Abschnittsetikett wird mit einer Papierblende verdeckt.
- Demo 1.6.1 bleibt eine eigenständige HTML-Datei (Bilder eingebettet), ohne externe Questdaten.

## Browsertest

Chromium / Playwright, HTML über `page.set_content()` geladen, getestet:
- Startansicht (Originalgrafik), Suche mit Vorschlag ("spuren"), linke Questliste.
- Linker Questklick -> Chronik, Questknoten -> Details, Zurück -> Chronik, Baum-/Listenwechsel.
- Verschieben über Titelleiste: Delta 50 × 30 Pixel.
- Vergrößern am Ziehgriff: +115,5 Pixel Breite und +65 Pixel Höhe.
- Zurücksetzen auf Originalansicht.
- JavaScript-Laufzeitfehler: **keine** in diesen Abläufen.

## Bekannte Einschränkungen

- Die Kartenzeichnung und Teile der unteren Questreihe stammen weiterhin aus der freigegebenen Grafik und sind in der HTML-Demo nur illustrativ. Eine vollständige dynamische Datenbindung samt korrekter Kartenmarkerposition ist noch nicht implementiert.
- Das Buchlayout verwendet Demo-/Fantasiequestdaten; weder WoW-Forever-API noch WoWHead-Questdaten sind eingebunden.
- Der Titelbereich ist dem Original angenähert, aber noch nicht vollständig in einzelne dynamisch skalierbare echte WoW-Texturen zerlegt.
- Noch keine WoW-Ingame-Tests oder Addon-Releasefreigabe.

## Unveränderlichkeit / Ausschlüsse

- `main`, `addon/` sowie `archive/QuestCompendiumForever_Alpha_0.0.1.zip` nicht ändern.
- Original-Alpha-ZIP SHA-256: `1fa0564dd82598f88ccf6b6120ae6a3d96228b556a769c3cfbb0020a20f7e9b1`.
- Keine GitHub Actions, CI, Builds, Releases, Deployments oder kostenpflichtige Dienste.
