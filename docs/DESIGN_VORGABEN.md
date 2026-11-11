# Verbindliche Designvorgaben

**Freigabestand:** Gespräche vom 10./11.11.2026. Diese Vorgaben beziehen sich auf den angestrebten Designzustand, nicht auf eine implementierte Addon-Version.

## 1. Das Hauptfenster
- Schwarzer, metallischer Grundrahmen mit goldener WoW-/Fantasy-Ornamentik.
- Questsuche mit Vorschlägen und Filtern links; Karte inklusive Questgeber/Abgabe und Koordinaten rechts.
- Zwei Reihen **je sechs** kompakter Infoboxen: Einzelquest und vollständige Questreihe.
- Unten ein kopierbares WoWHead-Linkfeld. Im Addon kein freies HTTP/Browser-Öffnen behaupten.
- Fenster im Spiel frei verschiebbar und skalierbar; gespeicherte Position/Größe; Maximierung max. 80 % der jeweiligen Bildschirmdimension; Wiederherstellen und Schließen.

## 2. Questbaum & Details
- Stilvorlage: illustriertes Abenteuerjournal/aufgeschlagenes Buch mit Pergament, Wappen, altertümlichen Verzierungen, Questtafeln und goldenen Verbindungspfaden.
- Die **kombinierte** Referenzgrafik ist das maßgebliche Ziel. Keine flachen HTML-Clean-UI-Ersatzdesigns als Endergebnis.
- Questreihe als Baum; Auswahl einer Quest öffnet Details; Zurück-Navigation zur Questreihe.
- Vollständige Zweige, Voraussetzungen und erledigte Quests soweit reale Daten vorhanden. Alternativpfade bei Summen nicht doppelt zählen.
- Status und errechnete Werte als bestätigt/geschätzt/nicht verfügbar unterscheiden.

## 3. Referenzdateien
| Datei | Rolle |
| --- | --- |
| `01_Hauptfenster_Original.png` | Hauptfenster-Aufteilung |
| `02_Abenteuerchronik_Megaentwurf.png` | stilistische Grundlage der zwei Innenansichten |
| `03_Kombinierter_Referenzentwurf_VERBINDLICH.png` | **entscheidender visueller Zielentwurf** |

## 4. Vor dem nächsten Schritt
1. Echte grafische UI-Assets getrennt vom Questtext erstellen; nicht einfach die Gesamtgrafik als einzigen Hintergrund strecken.
2. Browser-Demo anhand des **kombinierten** Entwurfs visuell abgleichen.
3. Erst nach expliziter Nutzerfreigabe Änderungen am WoW-Addon/Alpha.
