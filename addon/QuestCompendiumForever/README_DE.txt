Quest Compendium Forever
Alpha 0.0.1 - 10.11.2026
Entwickler/Maintainer: Blackiron
WoW Forever, Interface-Version 16001

INSTALLATION
1. World of Warcraft: Forever vollständig schließen.
2. Die ZIP-Datei entpacken.
3. Den Ordner "QuestCompendiumForever" nach
   World of Warcraft\_forever_\Interface\AddOns\ kopieren.
4. Sicherstellen, dass die Datei dort direkt liegt:
   ...\AddOns\QuestCompendiumForever\QuestCompendiumForever.toc
5. Spiel neu starten und das Addon in der Addon-Liste aktivieren.
6. Im Chat /qcf eingeben.

BEDIENUNG
/qcf                Addon-Fenster öffnen oder schließen
/questcompendium   Alternative zum Öffnen
/qcf status         Bekannte Questnamen und abgeschlossene Quests zählen
/qcf reset          Fensterposition/-größe zurücksetzen

Suche: Namen oder Quest-ID eingeben. Während des Tippens werden lokale
Treffer angezeigt. Mit Enter kann eine bisher unbekannte numerische
Quest-ID gezielt nachgeladen werden, soweit der Client sie kennt.

Fenster: An der Titelleiste ziehen, rechts unten die Ecke greifen.
Das Addon speichert die Position und Größe für deinen Charakter.

Queststatus: grün = abgeschlossen, blau = aktuell im Questlog,
gold = nicht abgeschlossen oder nicht bekannt.

Questreihe: Wenn der Client für eine Quest eine Questlinie mit IDs
bereitstellt, zeigt das Addon diese als anklickbare Folge an. Ohne diese
Information erscheint die Quest einzeln und ein eindeutiger Hinweis.
Bei mehr als sechs Quests sind die Pfeile zur Navigation da.

Karte: Zeigt Kartenkacheln des Spielclients und einen Marker, wenn
Positionen verfügbar sind. Questgeberpositionen kommen zunächst nur
aus einem zulässigen lokalen Datensatz oder aus deiner eigenen
Beobachtung beim Annehmen einer Quest. Sonst wird ausschließlich der
Questwegpunkt angezeigt, der NICHT der Questgeber sein muss.
Die "Weltkarte"-Schaltfläche öffnet außerhalb des Kampfes die Blizzard-
Weltkarte auf der betreffenden Zone; zusätzliche Weltkarten-Pins sind
noch nicht implementiert.

WoWHead: Der Button "Link kopieren (Strg+C)" markiert den Link im Textfeld.
Danach STRG+C im Spiel drücken, im Browser STRG+V. Aus dem Addon heraus
kann kein Browser direkt geöffnet oder die Windows-Zwischenablage
automatisch beschrieben werden. Für Forever-exklusive Quests kann
WoWHead keine passende Seite haben. Der Link verwendet Classic/quest=ID.

WAS ALPHA 0.0.1 TATSÄCHLICH MACHT
- UI im freigegebenen dunklen/goldenen Stil, ohne Fremdbibliotheken.
- Frei bewegliches und größenveränderbares Fenster; Speicherung pro Charakter.
- Questsuche aus Questlog, bekannten Questtiteln und lokalem Katalog.
- Abgeschlossene Quests aus dem Forever-API, soweit abrufbar.
- Schon vorher abgeschlossene Questtitel werden, sofern verfügbar,
  begrenzt nachgeladen (maximal 80 Anfragen pro Spielsitzung).
- Questbeschreibung und Ziele aus dem Questlog, wenn verfügbar.
- Questreihen aus C_QuestLine, wenn der Client sie meldet.
- Eingebettete echte Kartenkacheln aus dem Forever-Client.
- Beim Annehmen neuer Quests: gemessener Annahmeort, ggf. beobachteter
  NPC-Name; NICHT immer ein verifizierter universeller Questgeber.
- Bei abgegebenen Quests: tatsächliche XP und zeitlicher Abstand
  zwischen Annahme und Abgabe (einschließlich Pausen, Offlinezeit).
- Zwei Reihen mit genau sechs kompakten Infoboxen.
- WoWHead-URL zu Quest-ID mit kopierbarem Textfeld.

NOCH NICHT IMPLEMENTIERT / NICHT VORGETÄUSCHT
- Vollständige externe Questdatenbank für alle noch ungesehenen Quests.
- Universell bestätigte Questgeber-, Abgabe- und NPC-Koordinaten.
- Verlässliche Spiellevel-optimierte XP-Berechnung.
- Vorhersage des Zeitaufwands und der Solo/Gruppe-Machbarkeit.
- Summen über unbekannte oder unvollständige Questketten.
- Zusätzliche Marker direkt auf der Blizzard-Weltkarte.
- Vollständige alternative / sich gegenseitig ausschließende Questpfade.
- Bilder/Portraits und detailreiche Belohnungs-Tooltips wie im Designbild.
Die entsprechenden Felder zeigen ehrlich "–" / "unbekannt".

DATENQUELLEN UND RECHTE
- Verwendet ausschließlich Informationen aus dem Spielclient,
  eigene lokale Beobachtungen und gegebenenfalls künftig ausdrücklich
  genehmigte Questdatensätze.
- Keine WoWHead-Daten ausgelesen, kopiert oder mitgeliefert.
- Keine Webzugriffe aus dem Addon, keine externen Abhängigkeiten.
- Die Originalgrafiken des Spiels werden vom Spielclient geladen.
- Eigenständiger neuer Lua-Code von Blackiron / Quest Compendium Forever.

BEKANNTE EINSCHRÄNKUNGEN
- Es wurde kein Test im echten Forever-Client ausgeführt. Alpha-Test!
- Questdaten können vorübergehend fehlen, wenn der Client sie noch
  nicht geladen hat. Die Anzeige wird nach relevanten Events aktualisiert.
- Bei kurzen Quests ist die Zeitmessung durch Rundung relativ ungenau;
  sie misst keine reine Kampf- oder Laufzeit.
- Die Empfehlung Solo? ist lediglich eine unsichere Einschätzung anhand
  der Gruppenangabe des Questlogs, keine Klassensimulation.
- Der Questreihen-Gesamtwert bleibt leer, wenn Daten fehlen.
- Nach Patches kann sich die Interface-Version ändern. Im Spiel prüfen:
  /run print(select(4, GetBuildInfo()))

FEHLER MELDEN
Im Chat /console scriptErrors 1 eingeben, dann /reload.
Bei einem Fehler bitte den genauen Wortlaut und die Aktion mitteilen.
Keine vertraulichen Zugangsdaten mitsenden.
