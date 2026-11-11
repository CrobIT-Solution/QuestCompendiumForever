local addonName, QCF = ...
local UI = {}
QCF.UI = UI

local C = {
    gold = { 1, 0.82, 0.39, 1 },
    pale = { 0.96, 0.91, 0.78, 1 },
    gray = { 0.72, 0.74, 0.74, 1 },
    green = { 0.28, 0.95, 0.37, 1 },
    blue = { 0.28, 0.68, 1, 1 },
    violet = { 0.78, 0.4, 1, 1 },
    parchment = { 0.93, 0.84, 0.64, 1 },
}

local function Label(parent, size, color, justify)
    local fs = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fs:SetFont("Fonts\\FRIZQT__.TTF", size or 12, "OUTLINE")
    local rgba = color or C.pale
    fs:SetTextColor(unpack(rgba))
    fs:SetJustifyH(justify or "LEFT")
    fs:SetJustifyV("MIDDLE")
    fs:SetWordWrap(true)
    return fs
end

local function Panel(parent, light)
    local frame = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    if light then
        frame:SetBackdropColor(0.49, 0.38, 0.22, 0.96)
        frame:SetBackdropBorderColor(0.79, 0.60, 0.30, 1)
    else
        frame:SetBackdropColor(0.05, 0.06, 0.07, 0.97)
        frame:SetBackdropBorderColor(0.57, 0.41, 0.21, 1)
    end
    return frame
end

local function Button(parent, text, onClick)
    local b = CreateFrame("Button", nil, parent, "BackdropTemplate")
    b:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 13,
        insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    b:SetBackdropColor(0.10, 0.12, 0.13, 0.98)
    b:SetBackdropBorderColor(0.46, 0.35, 0.20, 1)
    b.label = Label(b, 11, C.pale, "CENTER")
    b.label:SetPoint("TOPLEFT", 6, -3)
    b.label:SetPoint("BOTTOMRIGHT", -6, 3)
    b.label:SetText(text or "")
    b:SetScript("OnClick", onClick)
    b:SetScript("OnEnter", function(self)
        self:SetBackdropBorderColor(1, 0.83, 0.35, 1)
    end)
    b:SetScript("OnLeave", function(self)
        self:SetBackdropBorderColor(0.46, 0.35, 0.20, 1)
    end)
    return b
end

local function FormatXP(n)
    if type(n) ~= "number" then return "–" end
    return tostring(math.floor(n + 0.5))
end

local function HumanDuration(m)
    if not m then return "–" end
    if m < 60 then return tostring(m) .. " Min." end
    return tostring(math.floor(m / 60)) .. "h " .. tostring(m % 60) .. "m"
end

local function ClearAnchor(widget)
    widget:ClearAllPoints()
end

local function QuestText(rec)
    local desc = rec.description
    local obj = rec.objectives
    if rec.active and type(GetQuestLogQuestText) == "function" and rec.logIndex then
        local d, o = QCF.SafeCall(GetQuestLogQuestText, rec.logIndex)
        if d and d ~= "" then desc = d end
        if o and o ~= "" then obj = o end
    end
    local output = {}
    if desc and desc ~= "" then
        output[#output + 1] = desc
    else
        output[#output + 1] = "Questbeschreibung noch nicht in den lokalen Daten vorhanden."
    end
    if obj and obj ~= "" then
        output[#output + 1] = "\n|cffffdf83Ziele:|r\n" .. obj
    elseif rec.active and C_QuestLog and C_QuestLog.GetQuestObjectives then
        local objects = QCF.SafeCall(C_QuestLog.GetQuestObjectives, rec.id)
        if type(objects) == "table" and #objects > 0 then
            output[#output + 1] = "\n|cffffdf83Ziele:|r"
            for _, o in ipairs(objects) do
                if o.text then output[#output + 1] = "• " .. o.text end
            end
        end
    end
    return table.concat(output, "\n")
end

local function CreateStatRow(parent, title, captions)
    local row = Panel(parent, false)
    row.header = Label(row, 12, C.gold)
    row.header:SetPoint("TOPLEFT", 11, -5)
    row.header:SetHeight(19)
    row.header:SetText(title)
    row.boxes = {}
    for i = 1, 6 do
        local b = Panel(row, false)
        b.label = Label(b, 10, C.gray, "CENTER")
        b.label:SetPoint("TOPLEFT", 3, -4)
        b.label:SetPoint("TOPRIGHT", -3, -4)
        b.label:SetHeight(15)
        b.label:SetText(captions[i])
        b.value = Label(b, 13, C.gold, "CENTER")
        b.value:SetPoint("TOPLEFT", 2, -19)
        b.value:SetPoint("BOTTOMRIGHT", -2, 4)
        b.value:SetText("–")
        row.boxes[i] = b
    end
    function row:Layout(w, h)
        self:SetSize(w, h)
        local pad, gap = 7, 5
        local boxW = (w - pad * 2 - gap * 5) / 6
        for i, b in ipairs(self.boxes) do
            b:ClearAllPoints()
            b:SetPoint("TOPLEFT", self, "TOPLEFT", pad + (i - 1) * (boxW + gap), -26)
            b:SetSize(boxW, h - 31)
        end
    end
    function row:SetValues(values)
        for i = 1, 6 do self.boxes[i].value:SetText(tostring(values[i] or "–")) end
    end
    return row
end

function UI.Create()
    if UI.frame then return end
    local frame = Panel(UIParent, false)
    UI.frame = frame
    frame:SetFrameStrata("DIALOG")
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:SetResizable(true)
    frame:EnableMouse(true)
    if frame.SetResizeBounds then
        frame:SetResizeBounds(950, 620, 1800, 1100)
    elseif frame.SetMinResize then
        frame:SetMinResize(950, 620)
        frame:SetMaxResize(1800, 1100)
    end
    frame:Hide()

    local win = QuestCompendiumForeverChar.window
    local screenW, screenH = UIParent:GetWidth(), UIParent:GetHeight()
    local startW = math.min(win.width or 1300, math.max(950, screenW - 36))
    local startH = math.min(win.height or 790, math.max(620, screenH - 36))
    frame:SetSize(startW, startH)
    frame:SetPoint("CENTER", UIParent, "CENTER", win.x or 0, win.y or 0)

    UI.header = CreateFrame("Button", nil, frame)
    UI.header:SetPoint("TOPLEFT", 8, -7)
    UI.header:SetPoint("TOPRIGHT", -8, -7)
    UI.header:SetHeight(57)
    UI.header:EnableMouse(true)
    UI.header:RegisterForDrag("LeftButton")
    UI.header:SetScript("OnDragStart", function() frame:StartMoving() end)
    UI.header:SetScript("OnDragStop", function()
        frame:StopMovingOrSizing()
        UI.SaveWindow()
    end)

    UI.title = Label(UI.header, 24, C.gold, "CENTER")
    UI.title:SetPoint("TOPLEFT", 80, -4)
    UI.title:SetPoint("TOPRIGHT", -80, -4)
    UI.title:SetHeight(30)
    UI.title:SetText("Quest Compendium Forever")
    UI.subtitle = Label(UI.header, 11, C.pale, "CENTER")
    UI.subtitle:SetPoint("TOPLEFT", 80, -35)
    UI.subtitle:SetPoint("TOPRIGHT", -80, -35)
    UI.subtitle:SetHeight(16)
    UI.subtitle:SetText("Questsuche • Questketten • Belohnungen • Fortschritt")

    UI.close = Button(frame, "X", function() frame:Hide() end)
    UI.close:SetPoint("TOPRIGHT", -12, -18)
    UI.close:SetSize(34, 30)
    UI.reset = Button(frame, "R", function() UI.ResetPosition() end)
    UI.reset:SetPoint("RIGHT", UI.close, "LEFT", -7, 0)
    UI.reset:SetSize(30, 30)
    UI.reset:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        GameTooltip:SetText("Fenstergröße und Position zurücksetzen")
        GameTooltip:Show()
    end)
    UI.reset:SetScript("OnLeave", function(self) GameTooltip:Hide() end)

    UI.left = Panel(frame)
    UI.leftHeader = Label(UI.left, 14, C.gold)
    UI.leftHeader:SetPoint("TOPLEFT", 13, -9)
    UI.leftHeader:SetHeight(22)
    UI.leftHeader:SetText("Questsuche")

    UI.searchBackground = Panel(UI.left)
    UI.search = CreateFrame("EditBox", nil, UI.searchBackground)
    UI.search:SetAutoFocus(false)
    UI.search:SetFontObject("ChatFontNormal")
    UI.search:SetTextColor(0.98, 0.95, 0.83, 1)
    UI.search:SetPoint("TOPLEFT", 9, -4)
    UI.search:SetPoint("BOTTOMRIGHT", -9, 4)
    UI.search:SetMaxLetters(120)
    UI.search:SetScript("OnEscapePressed", function(e) e:ClearFocus() end)
    UI.search:SetScript("OnEnterPressed", function(e)
        e:ClearFocus()
        if UI.results and UI.results[1] then
            UI.SelectQuest(UI.results[1].id)
        else
            local id = tonumber(e:GetText())
            if id and id > 0 and id < 1000000 then
                QCF.Remember(id, {})
                QCF.RetrieveName(id)
                UI.SelectQuest(id)
                UI.RefreshList()
            end
        end
    end)
    UI.search:SetScript("OnTextChanged", function(e)
        QCF.search = e:GetText() or ""
        UI.listOffset = 0
        UI.RefreshList()
    end)
    UI.search:SetText("")

    UI.filters = {}
    for _, filter in ipairs({ { "Alle", "all" }, { "Offen", "open" }, { "Erledigt", "done" } }) do
        local b = Button(UI.left, filter[1], function()
            QCF.filter = filter[2]
            UI.listOffset = 0
            UI.RefreshList()
        end)
        UI.filters[#UI.filters + 1] = b
    end

    UI.list = CreateFrame("Frame", nil, UI.left)
    if UI.list.SetClipsChildren then UI.list:SetClipsChildren(true) end
    UI.list:EnableMouseWheel(true)
    UI.list:SetScript("OnMouseWheel", function(_, delta)
        UI.listOffset = math.max(0, math.min(UI.maxOffset or 0,
            (UI.listOffset or 0) - delta * 2))
        UI.RenderList()
    end)
    UI.listRows = {}
    for i = 1, 21 do
        local row = Button(UI.list, "", function(self)
            if self.questID then UI.SelectQuest(self.questID) end
        end)
        row.icon = Label(row, 16, C.gold, "CENTER")
        row.icon:SetPoint("LEFT", 8, 0)
        row.icon:SetSize(24, 25)
        row.questLabel = Label(row, 11, C.pale)
        row.questLabel:SetPoint("TOPLEFT", 37, -3)
        row.questLabel:SetPoint("TOPRIGHT", -6, -3)
        row.questLabel:SetHeight(16)
        row.levelLabel = Label(row, 9, C.gray)
        row.levelLabel:SetPoint("BOTTOMLEFT", 37, 5)
        row.levelLabel:SetPoint("BOTTOMRIGHT", -6, 5)
        row.levelLabel:SetHeight(11)
        row:EnableMouseWheel(true)
        row:SetScript("OnMouseWheel", function(_, delta)
            UI.list:GetScript("OnMouseWheel")(UI.list, delta)
        end)
        UI.listRows[i] = row
    end

    UI.listCount = Label(UI.left, 10, C.gray, "CENTER")
    UI.listCount:SetText("0 Quests")

    UI.legend = Panel(UI.left)
    UI.legendTitle = Label(UI.legend, 12, C.gold)
    UI.legendTitle:SetPoint("TOPLEFT", 11, -7)
    UI.legendTitle:SetHeight(16)
    UI.legendTitle:SetText("Legende / Status")
    UI.legendBody = Label(UI.legend, 11, C.pale)
    UI.legendBody:SetPoint("TOPLEFT", 11, -28)
    UI.legendBody:SetPoint("BOTTOMRIGHT", -11, 9)
    UI.legendBody:SetJustifyV("TOP")
    UI.legendBody:SetText("|cffffd250!|r  Nicht abgeschlossen\n|cff49acff●|r  Im Questlog\n|cff4bef58✓|r  Abgeschlossen\n|cffbbbbbb–|r  Noch nicht bekannt")

    UI.details = Panel(frame)
    UI.questTitle = Label(UI.details, 20, C.gold)
    UI.questTitle:SetText("Keine Quest ausgewählt")
    UI.questSubtitle = Label(UI.details, 11, C.pale)
    UI.questSubtitle:SetText("Wähle eine Quest aus der Suche")
    UI.questStatus = Label(UI.details, 12, C.green, "RIGHT")

    UI.description = Panel(UI.details, true)
    UI.descTitle = Label(UI.description, 14, C.gold)
    UI.descTitle:SetPoint("TOPLEFT", 13, -8)
    UI.descTitle:SetHeight(20)
    UI.descTitle:SetText("Beschreibung & Ziele")
    UI.descScroll = CreateFrame("ScrollFrame", nil, UI.description, "UIPanelScrollFrameTemplate")
    UI.descContent = CreateFrame("Frame", nil, UI.descScroll)
    UI.descScroll:SetScrollChild(UI.descContent)
    UI.descText = Label(UI.descContent, 11, C.pale)
    UI.descText:SetPoint("TOPLEFT", 0, 0)
    UI.descText:SetJustifyV("TOP")
    UI.descText:SetText("Noch keine Quest ausgewählt.")

    UI.giver = Panel(UI.details, true)
    UI.giverTitle = Label(UI.giver, 14, C.gold)
    UI.giverTitle:SetPoint("TOPLEFT", 11, -8)
    UI.giverTitle:SetHeight(20)
    UI.giverTitle:SetText("Questgeber / Abgabe")
    UI.giverStart = Label(UI.giver, 11, C.pale)
    UI.giverStart:SetJustifyV("TOP")
    UI.giverFinish = Label(UI.giver, 11, C.pale)
    UI.giverFinish:SetJustifyV("TOP")
    UI.showLocation = Button(UI.giver, "Questgeber auf Karte anzeigen", function()
        local r = QCF.GetRecord(QCF.selected)
        if r then QCF.Map.SetRecord(UI.map, r) end
    end)
    UI.rewardTitle = Label(UI.details, 13, C.gold)
    UI.rewardTitle:SetText("Belohnungen")
    UI.rewardText = Label(UI.details, 11, C.pale)
    UI.rewardText:SetText("–")

    UI.map = QCF.Map.Create(frame)
    UI.chain = Panel(frame)
    UI.chainTitle = Label(UI.chain, 13, C.gold)
    UI.chainTitle:SetText("Questreihe")
    UI.chainInfo = Label(UI.chain, 10, C.gray, "RIGHT")
    UI.chainButtons = {}
    UI.chainArrows = {}
    for i = 1, 6 do
        UI.chainButtons[i] = Button(UI.chain, "", function(self)
            if self.questID then UI.SelectQuest(self.questID) end
        end)
        if i < 6 then
            UI.chainArrows[i] = Label(UI.chain, 15, C.gold, "CENTER")
            UI.chainArrows[i]:SetText("→")
        end
    end
    UI.chainPrev = Button(UI.chain, "<", function()
        UI.chainOffset = math.max(0, (UI.chainOffset or 0) - 6)
        UI.RefreshChain()
    end)
    UI.chainNext = Button(UI.chain, ">", function()
        UI.chainOffset = math.min(UI.maxChainOffset or 0, (UI.chainOffset or 0) + 6)
        UI.RefreshChain()
    end)

    UI.singleStats = CreateStatRow(frame, "Ausgewählte Quest – Effizienz & Bewertung",
        { "Effizienz", "Zeitaufwand", "Optimales Level", "Empfehlung", "EP / Minute", "Quest-EP" })
    UI.lineStats = CreateStatRow(frame, "Gesamte Questreihe – Effizienz & Bewertung",
        { "Effizienz", "Gesamtzeit", "Levelbereich", "Empfehlung", "EP / Minute", "Gesamt-EP" })

    UI.footer = Panel(frame)
    UI.wowheadLabel = Label(UI.footer, 15, C.gold)
    UI.wowheadLabel:SetText("WoWHead")
    UI.url = CreateFrame("EditBox", nil, UI.footer, "BackdropTemplate")
    UI.url:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 12 })
    UI.url:SetBackdropColor(0.07, 0.08, 0.10, 1)
    UI.url:SetBackdropBorderColor(0.48, 0.48, 0.45, 1)
    UI.url:SetFontObject("ChatFontNormal")
    UI.url:SetTextColor(1, 1, 1, 1)
    UI.url:SetAutoFocus(false)
    UI.url:SetScript("OnEscapePressed", function(e) e:ClearFocus() end)
    UI.url:SetScript("OnEnterPressed", function(e) e:HighlightText(); e:ClearFocus() end)
    UI.url:SetScript("OnEditFocusGained", function(e) e:HighlightText() end)
    UI.url:SetText("")
    UI.copy = Button(UI.footer, "Link kopieren (Strg+C)", function()
        UI.url:SetFocus()
        UI.url:HighlightText()
        QCF.Notice("WoWHead-Adresse markiert. Jetzt Strg+C drücken.")
    end)
    UI.copy:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText("Der Spielclient erlaubt kein direktes Kopieren.")
        GameTooltip:AddLine("Klicke hier und drücke Strg+C, dann im Browser Strg+V.", 1, 1, 1, true)
        GameTooltip:Show()
    end)
    UI.copy:SetScript("OnLeave", function() GameTooltip:Hide() end)

    UI.resize = CreateFrame("Button", nil, frame)
    UI.resize:SetSize(25, 25)
    UI.resize:SetPoint("BOTTOMRIGHT", -2, 2)
    UI.resize:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    UI.resize:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    UI.resize:RegisterForDrag("LeftButton")
    UI.resize:SetScript("OnDragStart", function()
        frame:StartSizing("BOTTOMRIGHT")
    end)
    UI.resize:SetScript("OnDragStop", function()
        frame:StopMovingOrSizing()
        UI.SaveWindow()
    end)

    frame:SetScript("OnSizeChanged", function() UI.Layout() end)
    UI.listOffset = 0
    UI.chainOffset = 0
    UI.Layout()
    UI.RefreshAll()
end

function UI.SaveWindow()
    if not UI.frame or not QuestCompendiumForeverChar then return end
    local f = UI.frame
    local a, b = f:GetCenter()
    local c, d = UIParent:GetCenter()
    if a and b and c and d then
        QuestCompendiumForeverChar.window = {
            width = math.floor(f:GetWidth() + 0.5),
            height = math.floor(f:GetHeight() + 0.5),
            x = math.floor(a - c + 0.5),
            y = math.floor(b - d + 0.5),
        }
    end
end

function UI.ResetPosition()
    if not UI.frame then return end
    local screenW, screenH = UIParent:GetWidth(), UIParent:GetHeight()
    UI.frame:ClearAllPoints()
    UI.frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    UI.frame:SetSize(math.min(1300, screenW - 30), math.min(790, screenH - 30))
    UI.SaveWindow()
end

function UI.Layout()
    if not UI.frame or not UI.left then return end
    local f = UI.frame
    local w, h = f:GetWidth(), f:GetHeight()
    if not w or w < 100 or not h or h < 100 then return end
    local pad, gap = 9, 7
    local leftW = math.max(218, math.min(303, w * 0.225))
    local contentX = pad + leftW + gap
    local contentW = w - contentX - pad
    local footerH = 52
    local rowH = 75
    local chainH = 118
    local contentTop = 75
    local contentBottom = 8 + footerH + gap + rowH * 2 + gap * 3 + chainH
    local detailH = h - contentTop - contentBottom
    detailH = math.max(200, detailH)
    local mapW = math.max(300, contentW * 0.395)
    local detailW = contentW - mapW - gap

    UI.left:ClearAllPoints()
    UI.left:SetPoint("TOPLEFT", f, "TOPLEFT", pad, -contentTop)
    UI.left:SetSize(leftW, h - contentTop - pad)
    UI.searchBackground:ClearAllPoints()
    UI.searchBackground:SetPoint("TOPLEFT", UI.left, "TOPLEFT", 10, -37)
    UI.searchBackground:SetSize(leftW - 20, 33)
    local filterW = (leftW - 26) / 3
    for i, b in ipairs(UI.filters) do
        b:ClearAllPoints()
        b:SetPoint("TOPLEFT", UI.left, "TOPLEFT", 9 + (i - 1) * (filterW + 4), -76)
        b:SetSize(filterW, 26)
        local active = ({ "all", "open", "done" })[i] == QCF.filter
        b.label:SetTextColor(unpack(active and C.gold or C.pale))
    end
    UI.legend:ClearAllPoints()
    UI.legend:SetPoint("BOTTOMLEFT", UI.left, "BOTTOMLEFT", 8, 7)
    UI.legend:SetSize(leftW - 16, 128)
    UI.list:ClearAllPoints()
    UI.list:SetPoint("TOPLEFT", UI.left, "TOPLEFT", 9, -112)
    UI.list:SetPoint("BOTTOMRIGHT", UI.left, "BOTTOMRIGHT", -9, 160)
    UI.listCount:ClearAllPoints()
    UI.listCount:SetPoint("BOTTOMLEFT", UI.left, "BOTTOMLEFT", 12, 139)
    UI.listCount:SetPoint("BOTTOMRIGHT", UI.left, "BOTTOMRIGHT", -12, 139)
    UI.listCount:SetHeight(15)

    UI.details:ClearAllPoints()
    UI.details:SetPoint("TOPLEFT", f, "TOPLEFT", contentX, -contentTop)
    UI.details:SetSize(detailW, detailH)
    UI.map:ClearAllPoints()
    UI.map:SetPoint("TOPLEFT", f, "TOPLEFT", contentX + detailW + gap, -contentTop)
    UI.map:SetSize(mapW, detailH)
    UI.questTitle:ClearAllPoints()
    UI.questTitle:SetPoint("TOPLEFT", UI.details, "TOPLEFT", 11, -8)
    UI.questTitle:SetPoint("TOPRIGHT", UI.details, "TOPRIGHT", -12, -8)
    UI.questTitle:SetHeight(28)
    UI.questSubtitle:ClearAllPoints()
    UI.questSubtitle:SetPoint("TOPLEFT", UI.details, "TOPLEFT", 11, -38)
    UI.questSubtitle:SetPoint("TOPRIGHT", UI.details, "TOPRIGHT", -11, -38)
    UI.questSubtitle:SetHeight(16)
    UI.questStatus:ClearAllPoints()
    UI.questStatus:SetPoint("TOPLEFT", UI.details, "TOPLEFT", 11, -55)
    UI.questStatus:SetPoint("TOPRIGHT", UI.details, "TOPRIGHT", -11, -55)
    UI.questStatus:SetHeight(16)

    local bodyTop = 79
    local rewardH = 55
    local bodyH = math.max(90, detailH - bodyTop - rewardH - 9)
    local giverW = math.max(200, detailW * 0.40)
    local descW = detailW - giverW - 21
    UI.description:ClearAllPoints()
    UI.description:SetPoint("TOPLEFT", UI.details, "TOPLEFT", 7, -bodyTop)
    UI.description:SetSize(descW, bodyH)
    UI.giver:ClearAllPoints()
    UI.giver:SetPoint("TOPLEFT", UI.details, "TOPLEFT", 14 + descW, -bodyTop)
    UI.giver:SetSize(giverW, bodyH)
    UI.descScroll:ClearAllPoints()
    UI.descScroll:SetPoint("TOPLEFT", UI.description, "TOPLEFT", 12, -31)
    UI.descScroll:SetPoint("BOTTOMRIGHT", UI.description, "BOTTOMRIGHT", -22, 10)
    UI.descContent:SetWidth(math.max(80, descW - 42))
    UI.descText:SetWidth(math.max(80, descW - 44))
    UI.UpdateDescriptionHeight()

    UI.giverStart:ClearAllPoints()
    UI.giverStart:SetPoint("TOPLEFT", UI.giver, "TOPLEFT", 11, -33)
    UI.giverStart:SetPoint("TOPRIGHT", UI.giver, "TOPRIGHT", -11, -33)
    UI.giverStart:SetHeight(math.max(35, bodyH * 0.28))
    UI.giverFinish:ClearAllPoints()
    UI.giverFinish:SetPoint("TOPLEFT", UI.giverStart, "BOTTOMLEFT", 0, -3)
    UI.giverFinish:SetPoint("TOPRIGHT", UI.giverStart, "BOTTOMRIGHT", 0, -3)
    UI.giverFinish:SetHeight(math.max(32, bodyH * 0.24))
    UI.showLocation:ClearAllPoints()
    UI.showLocation:SetPoint("BOTTOMLEFT", UI.giver, "BOTTOMLEFT", 10, 10)
    UI.showLocation:SetPoint("BOTTOMRIGHT", UI.giver, "BOTTOMRIGHT", -10, 10)
    UI.showLocation:SetHeight(28)
    UI.rewardTitle:ClearAllPoints()
    UI.rewardTitle:SetPoint("BOTTOMLEFT", UI.details, "BOTTOMLEFT", 12, 33)
    UI.rewardTitle:SetHeight(18)
    UI.rewardText:ClearAllPoints()
    UI.rewardText:SetPoint("BOTTOMLEFT", UI.details, "BOTTOMLEFT", 12, 12)
    UI.rewardText:SetPoint("BOTTOMRIGHT", UI.details, "BOTTOMRIGHT", -12, 12)
    UI.rewardText:SetHeight(18)

    local chainY = contentTop + detailH + gap
    UI.chain:ClearAllPoints()
    UI.chain:SetPoint("TOPLEFT", f, "TOPLEFT", contentX, -chainY)
    UI.chain:SetSize(contentW, chainH)
    UI.chainTitle:ClearAllPoints()
    UI.chainTitle:SetPoint("TOPLEFT", UI.chain, "TOPLEFT", 12, -8)
    UI.chainTitle:SetHeight(20)
    UI.chainInfo:ClearAllPoints()
    UI.chainInfo:SetPoint("TOPRIGHT", UI.chain, "TOPRIGHT", -40, -8)
    UI.chainInfo:SetHeight(20)
    UI.chainInfo:SetWidth(contentW * 0.55)
    local nodeGap, nodePad = 21, 37
    local nodeW = (contentW - nodePad * 2 - nodeGap * 5) / 6
    for i, b in ipairs(UI.chainButtons) do
        b:ClearAllPoints()
        b:SetPoint("TOPLEFT", UI.chain, "TOPLEFT", nodePad + (i - 1) * (nodeW + nodeGap), -38)
        b:SetSize(nodeW, 69)
        if i < 6 then
            local arrow = UI.chainArrows[i]
            arrow:ClearAllPoints()
            arrow:SetPoint("LEFT", b, "RIGHT", 2, 0)
            arrow:SetSize(nodeGap - 4, 20)
        end
    end
    UI.chainPrev:ClearAllPoints()
    UI.chainPrev:SetPoint("BOTTOMLEFT", UI.chain, "BOTTOMLEFT", 7, 12)
    UI.chainPrev:SetSize(25, 33)
    UI.chainNext:ClearAllPoints()
    UI.chainNext:SetPoint("BOTTOMRIGHT", UI.chain, "BOTTOMRIGHT", -7, 12)
    UI.chainNext:SetSize(25, 33)

    local statsY = chainY + chainH + gap
    UI.singleStats:ClearAllPoints()
    UI.singleStats:SetPoint("TOPLEFT", f, "TOPLEFT", contentX, -statsY)
    UI.singleStats:Layout(contentW, rowH)
    UI.lineStats:ClearAllPoints()
    UI.lineStats:SetPoint("TOPLEFT", f, "TOPLEFT", contentX, -(statsY + rowH + gap))
    UI.lineStats:Layout(contentW, rowH)

    UI.footer:ClearAllPoints()
    UI.footer:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", contentX, pad)
    UI.footer:SetSize(contentW, footerH)
    UI.wowheadLabel:ClearAllPoints()
    UI.wowheadLabel:SetPoint("LEFT", UI.footer, "LEFT", 12, 0)
    UI.wowheadLabel:SetWidth(91)
    UI.wowheadLabel:SetHeight(24)
    local buttonW = 170
    UI.copy:ClearAllPoints()
    UI.copy:SetPoint("RIGHT", UI.footer, "RIGHT", -10, 0)
    UI.copy:SetSize(buttonW, 32)
    UI.url:ClearAllPoints()
    UI.url:SetPoint("LEFT", UI.wowheadLabel, "RIGHT", 5, 0)
    UI.url:SetPoint("RIGHT", UI.copy, "LEFT", -10, 0)
    UI.url:SetHeight(29)
    UI.RenderList()
end

function UI.UpdateDescriptionHeight()
    if not UI.descText or not UI.descContent then return end
    local h = math.max(UI.descText:GetStringHeight() + 16, UI.descScroll:GetHeight())
    UI.descContent:SetHeight(h)
end

function UI.RefreshList()
    if not UI.frame or not QuestCompendiumForeverDB then return end
    UI.results = QCF.GetSortedQuests(QCF.search, QCF.filter)
    UI.RenderList()
end

function UI.RenderList()
    if not UI.list or not UI.results then return end
    local results = UI.results
    local listH = UI.list:GetHeight() or 400
    local visible = math.min(21, math.max(1, math.floor(listH / 40)))
    UI.maxOffset = math.max(0, #results - visible)
    UI.listOffset = math.max(0, math.min(UI.listOffset or 0, UI.maxOffset))
    for i, b in ipairs(UI.listRows) do
        if i <= visible and results[i + UI.listOffset] then
            local r = results[i + UI.listOffset]
            b.questID = r.id
            b:ClearAllPoints()
            b:SetPoint("TOPLEFT", UI.list, "TOPLEFT", 0, -(i - 1) * 40)
            b:SetSize(math.max(140, UI.list:GetWidth() - 1), 38)
            b.icon:SetText(r.completed and "✓" or (r.active and "●" or "!"))
            b.icon:SetTextColor(unpack(r.completed and C.green or (r.active and C.blue or C.gold)))
            b.questLabel:SetText(r.title or ("Quest #" .. r.id))
            b.levelLabel:SetText("Stufe " .. (r.level or "?") .. " • ID " .. r.id)
            if r.id == QCF.selected then
                b:SetBackdropColor(0.26, 0.19, 0.07, 0.95)
                b:SetBackdropBorderColor(0.95, 0.75, 0.31, 1)
            else
                b:SetBackdropColor(0.09, 0.10, 0.10, 0.93)
            end
            b:Show()
        else
            b.questID = nil
            b:Hide()
        end
    end
    UI.listCount:SetText(string.format("%d Treffer • %d–%d", #results,
        #results == 0 and 0 or UI.listOffset + 1, math.min(#results, UI.listOffset + visible)))
end

function UI.SelectQuest(id)
    if not id then return end
    if QCF.selected ~= id then UI.chainOffset = 0 end
    QCF.selected = id
    UI.RefreshDetails()
    UI.RenderList()
end

function UI.RefreshDetails()
    if not UI.details or not QCF.selected then return end
    local rec = QCF.GetRecord(QCF.selected)
    if not rec then return end
    UI.questTitle:SetText(rec.title or ("Quest #" .. rec.id))
    local zone = rec.zone or "Gebiet nicht erfasst"
    UI.questSubtitle:SetText("Quest-ID: " .. rec.id .. "  •  Stufe: " .. (rec.level or "?") .. "  •  " .. zone)
    UI.questStatus:SetText(rec.completed and "✓ Abgeschlossen (dieser Charakter)" or
        (rec.active and "● Aktuell im Questlog" or "! Nicht abgeschlossen / unbekannt"))
    UI.questStatus:SetTextColor(unpack(rec.completed and C.green or (rec.active and C.blue or C.gold)))
    UI.descText:SetText(QuestText(rec))
    UI.UpdateDescriptionHeight()
    UI.descScroll:SetVerticalScroll(0)

    local position, posSource = QCF.GetPosition(rec)
    local startName = (rec.start and rec.start.name) or
        (rec.observedNPC and (rec.observedNPC .. " (bei Annahme beobachtet)")) or "Unbekannt"
    UI.giverStart:SetText("|cffffd46bQuestbeginn:|r\n" .. startName .. "\n" ..
        (position and string.format("%.1f / %.1f", position.x * 100, position.y * 100)
            or "Koordinaten nicht bekannt"))
    local finishName = rec.finish and rec.finish.name or "Noch nicht bekannt"
    UI.giverFinish:SetText("|cffffd46bQuestabgabe:|r\n" .. finishName)
    local xp, source = QCF.GetXP(rec)
    local kind = (source == "Tatsächlich erhalten") and "erhalten" or "Belohnung"
    UI.rewardText:SetText("EP: " .. FormatXP(xp) .. " (" .. kind .. ")" ..
        "    •    Gold / Gegenstände: " .. (rec.rewardsText or "noch nicht verfügbar"))
    QCF.Map.SetRecord(UI.map, rec)
    UI.url:SetText("https://www.wowhead.com/classic/quest=" .. tostring(rec.id))
    UI.url:ClearFocus()
    UI.RefreshChain()
    UI.RefreshStats()
end

function UI.RefreshChain()
    if not QCF.selected or not UI.chain then return end
    local r = QCF.GetRecord(QCF.selected)
    local ids, lineName = QCF.GetQuestLine(r)
    UI.currentChain = ids
    UI.chainTitle:SetText("Questreihe: " .. (lineName or "Noch nicht vollständig bekannt"))
    UI.maxChainOffset = math.max(0, #ids - 6)
    UI.chainOffset = math.max(0, math.min(UI.chainOffset or 0, UI.maxChainOffset))
    -- Sicherstellen, dass die gewählte Quest beim ersten Öffnen sichtbar bleibt.
    if UI.chainOffset == 0 and #ids > 6 then
        for index, id in ipairs(ids) do
            if id == QCF.selected and index > 6 then
                UI.chainOffset = math.min(index - 4, UI.maxChainOffset)
                break
            end
        end
    end
    UI.chainInfo:SetText(#ids .. " Quests | " ..
        (lineName and "Questlinie aus Spiel-API / Katalog" or "Reihenfolge unbekannt"))
    for i, b in ipairs(UI.chainButtons) do
        local id = ids[i + UI.chainOffset]
        b.questID = id
        if id then
            local rec = QCF.GetRecord(id)
            b.label:SetText((QCF.IsCompleted(id) and "✓  " or "!  ") .. (rec.title or ("Quest #" .. id)))
            if id == QCF.selected then
                b:SetBackdropColor(0.34, 0.25, 0.09, 1)
                b:SetBackdropBorderColor(0.98, 0.78, 0.22, 1)
            elseif QCF.IsCompleted(id) then
                b:SetBackdropColor(0.08, 0.25, 0.12, 1)
                b:SetBackdropBorderColor(0.2, 0.68, 0.28, 1)
            else
                b:SetBackdropColor(0.08, 0.11, 0.13, 1)
                b:SetBackdropBorderColor(0.5, 0.5, 0.43, 1)
            end
            b:Show()
        else
            b:Hide()
        end
        if i < 6 then
            if ids[i + UI.chainOffset] and ids[i + UI.chainOffset + 1] then
                UI.chainArrows[i]:Show()
            else
                UI.chainArrows[i]:Hide()
            end
        end
    end
    UI.chainPrev:SetEnabled(UI.chainOffset > 0)
    UI.chainNext:SetEnabled(UI.chainOffset < UI.maxChainOffset)
end

function UI.RefreshStats()
    if not QCF.selected or not UI.singleStats then return end
    local rec = QCF.GetRecord(QCF.selected)
    local xp = QCF.GetXP(rec)
    local mins = QCF.GetActualMinutes(rec.id)
    local rate = xp and mins and mins > 0 and math.floor(xp / mins + 0.5) or nil
    local optimal = rec.optimalLevel and tostring(rec.optimalLevel) or "–"
    UI.singleStats:SetValues({
        rate and "Messwert" or "–", HumanDuration(mins), optimal,
        QCF.GetRecommendation(rec), FormatXP(rate), FormatXP(xp),
    })
    local ids = UI.currentChain or { rec.id }
    local totalXP, totalMinutes = QCF.GetLineTotal(ids)
    local totalRate = totalXP and totalMinutes and totalMinutes > 0 and
        math.floor(totalXP / totalMinutes + 0.5) or nil
    local minL, maxL, suggested = nil, nil, 0
    for _, id in ipairs(ids) do
        local r = QCF.GetRecord(id)
        if type(r.level) == "number" then
            minL = not minL and r.level or math.min(minL, r.level)
            maxL = not maxL and r.level or math.max(maxL, r.level)
        end
        suggested = math.max(suggested, tonumber(r.group) or 0)
    end
    local levelRange = (minL and maxL) and (minL .. "–" .. maxL) or "–"
    local lineGroup = suggested > 1 and (suggested .. " Spieler") or "–"
    UI.lineStats:SetValues({
        totalRate and "Messwert" or "–", HumanDuration(totalMinutes), levelRange,
        lineGroup, FormatXP(totalRate), FormatXP(totalXP),
    })
end

function UI.RefreshAll()
    if not UI.frame or not QuestCompendiumForeverDB then return end
    UI.RefreshList()
    if not QCF.selected then
        if UI.results and UI.results[1] then QCF.selected = UI.results[1].id end
    end
    UI.RefreshDetails()
end

function UI.Toggle()
    if not UI.frame then return end
    if UI.frame:IsShown() then
        UI.frame:Hide()
    else
        QCF.RefreshQuests()
        UI.frame:Show()
        if not QCF.selected and UI.results and UI.results[1] then
            UI.SelectQuest(UI.results[1].id)
        end
    end
end
