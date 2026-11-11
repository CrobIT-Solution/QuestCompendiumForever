# Einmaliger Import in GitHub

**Diese Anleitung ist keine Aufforderung zur Änderung am bestehenden Addon.**

1. In GitHub innerhalb der Organisation `CrobIT-Solution` ein neues Repository `QuestCompendiumForever` anlegen, **Private** wählen, Defaultbranch `main`; wenn möglich ohne README/.gitignore/Lizenzdatei initialisieren, weil diese bereits im Importpaket enthalten sind.
2. Importpaket `QuestCompendiumForever_Repository_Import_Paket.zip` **lokal entpacken**. Nicht die unveränderte Alpha-ZIP entpacken und ersetzen! Die Alpha-ZIP bleibt im Ordner `archive/` als Original erhalten.
3. Im neuen GitHub-Repository auf `Add file` → `Upload files` gehen. Die Dateien und Ordner aus `QuestCompendiumForever_Repository_Import/` mit erhaltener Ordnerstruktur übernehmen (per Drag-and-drop der entpackten Inhalte, je nach Browser). Alternativ nach lokalem `git init` und Commit pushen.
4. Vor Bestätigung des Imports kontrollieren, dass `addon/`, `archive/`, `design/references/`, `demo/` und `docs/` unter den richtigen Pfaden liegen.
5. Nach Import die **Private**-Sichtbarkeit überprüfen. Keine Workflows/Actions aktivieren, keine Releases auslösen, keine Deployment-/Kostenoptionen konfigurieren.
6. Original-ZIP-SHA-256: `1fa0564dd82598f88ccf6b6120ae6a3d96228b556a769c3cfbb0020a20f7e9b1`.
7. Prüfsummen der drei Designvorlagen in `SHA256SUMS.txt` kontrollieren. Für die Textdateien ist die Original-ZIP der maßgebliche Byte-Nachweis.

**Wichtig:** Das Hochladen der ZIP-Datei alleine importiert die enthaltene Repository-Struktur nicht nach GitHub; sie muss vorher lokal entpackt werden.
