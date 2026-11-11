local addonName, QCF = ...

-- Eine bewusst leere, erweiterbare Datenschnittstelle.
-- Hier werden KEINE Wowhead- oder anderen Daten ungefragt eingebunden.
-- Künftige rechtmäßig lizenzierte Datensätze können z. B. so aussehen:
-- QCF.Catalog[12345] = {
--   title = "...", level = 25, zone = "...", rewardXP = 1800,
--   start = { mapID = 47, x = 0.456, y = 0.612, name = "Questgeber" },
--   finish = { mapID = 47, x = 0.456, y = 0.612, name = "Abgabe" },
--   questline = { 12344, 12345, 12346 }
-- }
-- Koordinaten sind normalisiert (0 bis 1), nicht Prozentwerte.
QCF.Catalog = {}
