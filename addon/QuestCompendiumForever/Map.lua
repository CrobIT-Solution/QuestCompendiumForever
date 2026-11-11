local addonName, QCF = ...
QCF.Map = {}
local Map = QCF.Map

local GOLD = { 0.78, 0.58, 0.24, 1 }
local DARK = { 0.055, 0.065, 0.075, 1 }

local function Paint(parent, layer, r, g, b, a)
    local tex = parent:CreateTexture(nil, layer or "BACKGROUND")
    tex:SetColorTexture(r, g, b, a or 1)
    tex:SetAllPoints()
    return tex
end

local function Label(parent, size, color, justify)
    local fs = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fs:SetFont("Fonts\\FRIZQT__.TTF", size, "OUTLINE")
    fs:SetTextColor(unpack(color or GOLD))
    fs:SetJustifyH(justify or "LEFT")
    return fs
end

function Map.Create(parent)
    local self = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    self:SetBackdrop({ edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 14,
        insets = { left = 3, right = 3, top = 3, bottom = 3 } })
    self:SetBackdropBorderColor(0.62, 0.42, 0.16, 1)
    Paint(self, "BACKGROUND", unpack(DARK))
    self.currentRecord = nil
    self.mapID = nil
    self.markerPosition = nil

    self.title = Label(self, 13, { 1, 0.83, 0.46, 1 })
    self.title:SetPoint("TOPLEFT", 12, -11)
    self.title:SetPoint("TOPRIGHT", -10, -11)
    self.title:SetHeight(18)
    self.title:SetText("Karte (Questgeber)")

    self.openWorld = CreateFrame("Button", nil, self, "UIPanelButtonTemplate")
    self.openWorld:SetSize(105, 24)
    self.openWorld:SetPoint("TOPRIGHT", -8, -31)
    self.openWorld:SetText("Weltkarte")
    self.openWorld:SetScript("OnClick", function()
        if type(InCombatLockdown) == "function" and InCombatLockdown() then
            QCF.Notice("Weltkarte bitte außerhalb des Kampfes öffnen.")
            return
        end
        if C_Map and C_Map.OpenWorldMap then
            QCF.SafeCall(C_Map.OpenWorldMap, self.mapID)
        else
            QCF.Notice("Weltkarte ist in diesem Client nicht verfügbar.")
        end
    end)

    self.zoneName = Label(self, 11, { 0.93, 0.86, 0.68, 1 })
    self.zoneName:SetPoint("TOPLEFT", 12, -35)
    self.zoneName:SetPoint("RIGHT", self.openWorld, "LEFT", -8, 0)
    self.zoneName:SetHeight(18)
    self.zoneName:SetText("Gebiet unbekannt")

    self.canvas = CreateFrame("Frame", nil, self)
    self.canvas:SetPoint("TOPLEFT", 8, -63)
    self.canvas:SetPoint("BOTTOMRIGHT", -8, 56)
    if self.canvas.SetClipsChildren then self.canvas:SetClipsChildren(true) end
    Paint(self.canvas, "BACKGROUND", 0.09, 0.11, 0.10, 1)
    self.tiles = {}

    self.hint = Label(self.canvas, 12, { 1, 0.84, 0.48, 1 }, "CENTER")
    self.hint:SetPoint("CENTER", self.canvas, "CENTER")
    self.hint:SetWidth(260)
    self.hint:SetText("Keine Kartendaten verfügbar")

    self.marker = CreateFrame("Button", nil, self.canvas)
    self.marker:SetSize(28, 28)
    self.marker.icon = self.marker:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    self.marker.icon:SetAllPoints()
    self.marker.icon:SetFont("Fonts\\FRIZQT__.TTF", 24, "OUTLINE")
    self.marker.icon:SetText("!")
    self.marker.icon:SetTextColor(1, 0.78, 0.12, 1)
    self.marker:SetScript("OnEnter", function(btn)
        if not self.markerPosition then return end
        GameTooltip:SetOwner(btn, "ANCHOR_RIGHT")
        GameTooltip:SetText(self.positionLabel or "Questposition")
        GameTooltip:AddLine(string.format("%.1f / %.1f", self.markerPosition.x * 100,
            self.markerPosition.y * 100), 1, 0.82, 0.3)
        GameTooltip:Show()
    end)
    self.marker:SetScript("OnLeave", function() GameTooltip:Hide() end)
    self.marker:Hide()

    self.coord = Label(self, 11, { 0.95, 0.84, 0.62, 1 })
    self.coord:SetPoint("BOTTOMLEFT", 12, 31)
    self.coord:SetPoint("BOTTOMRIGHT", -12, 31)
    self.coord:SetHeight(17)
    self.coord:SetText("Position noch unbekannt")

    self.source = Label(self, 10, { 0.78, 0.76, 0.70, 1 })
    self.source:SetPoint("BOTTOMLEFT", 12, 12)
    self.source:SetPoint("BOTTOMRIGHT", -12, 12)
    self.source:SetHeight(15)
    self.source:SetText("Keine Questgeberkoordinaten gespeichert")

    self:SetScript("OnSizeChanged", function() Map.Render(self) end)
    self.canvas:SetScript("OnSizeChanged", function() Map.Render(self) end)
    return self
end

function Map.Render(self)
    if not self or not self.canvas then return end
    local w, h = self.canvas:GetSize()
    if not w or w < 20 or not h or h < 20 then return end
    local mapID = self.mapID
    local layers = mapID and C_Map and C_Map.GetMapArtLayers and
        QCF.SafeCall(C_Map.GetMapArtLayers, mapID)
    local layer = layers and layers[1]
    local ids = layer and C_Map and C_Map.GetMapArtLayerTextures and
        QCF.SafeCall(C_Map.GetMapArtLayerTextures, mapID, 1)
    local valid = layer and type(ids) == "table" and #ids > 0 and
        layer.layerWidth and layer.layerHeight and layer.tileWidth and layer.tileHeight and
        layer.layerWidth > 0 and layer.layerHeight > 0
    for _, tex in ipairs(self.tiles) do tex:Hide() end
    if valid then
        local totalW, totalH = layer.layerWidth, layer.layerHeight
        local tw, th = layer.tileWidth, layer.tileHeight
        local cols = math.ceil(totalW / tw)
        for i, fileID in ipairs(ids) do
            if i > 128 then break end
            local tile = self.tiles[i]
            if not tile then
                tile = self.canvas:CreateTexture(nil, "ARTWORK")
                self.tiles[i] = tile
            end
            local col = (i - 1) % cols
            local row = math.floor((i - 1) / cols)
            local x0, y0 = col * tw, row * th
            local visibleW = math.min(tw, totalW - x0)
            local visibleH = math.min(th, totalH - y0)
            if visibleW > 0 and visibleH > 0 then
                tile:ClearAllPoints()
                tile:SetPoint("TOPLEFT", self.canvas, "TOPLEFT", x0 * w / totalW, -y0 * h / totalH)
                tile:SetSize(visibleW * w / totalW, visibleH * h / totalH)
                tile:SetTexture(fileID)
                tile:SetTexCoord(0, visibleW / tw, 0, visibleH / th)
                tile:Show()
            end
        end
        self.hint:Hide()
    else
        self.hint:Show()
        self.hint:SetText(mapID and "Für dieses Gebiet keine Kartenkacheln verfügbar"
            or "Noch keine Kartenposition bekannt")
    end
    if self.markerPosition and self.markerPosition.x and self.markerPosition.y and
        self.markerPosition.x >= 0 and self.markerPosition.x <= 1 and
        self.markerPosition.y >= 0 and self.markerPosition.y <= 1 then
        self.marker:ClearAllPoints()
        self.marker:SetPoint("CENTER", self.canvas, "TOPLEFT",
            self.markerPosition.x * w, -self.markerPosition.y * h)
        self.marker:Show()
    else
        self.marker:Hide()
    end
end

function Map.SetRecord(self, rec)
    self.currentRecord = rec
    local pos, source = QCF.GetPosition(rec)
    self.markerPosition = pos
    self.positionLabel = source
    self.mapID = pos and pos.mapID
    if not self.mapID and C_Map and C_Map.GetBestMapForUnit then
        self.mapID = QCF.SafeCall(C_Map.GetBestMapForUnit, "player")
    end
    local info = self.mapID and C_Map and C_Map.GetMapInfo and
        QCF.SafeCall(C_Map.GetMapInfo, self.mapID)
    self.zoneName:SetText((info and info.name) or (rec and rec.zone) or "Gebiet unbekannt")
    if pos then
        self.coord:SetText(string.format("Koordinaten: %.1f / %.1f", pos.x * 100, pos.y * 100))
        self.source:SetText(source)
    else
        self.coord:SetText("Questgeber-Koordinaten: noch unbekannt")
        self.source:SetText("Keine Position erfasst – siehe Questlog")
    end
    Map.Render(self)
end
