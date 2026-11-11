local addonName, QCF = ...
QCF.version = "0.0.1-alpha"
QCF.records = {}
QCF.active = {}
QCF.completed = {}
QCF.completedCount = 0
QCF.completedIDs = {}
QCF.completedNameCursor = 1
QCF.selected = nil
QCF.search = ""
QCF.filter = "all"
QCF.nameRequests = 0
QCF.maxNameRequests = 80
QCF.warned = {}

local function SafeCall(func, ...)
    if type(func) ~= "function" then return nil end
    local ok, a, b, c = pcall(func, ...)
    if ok then return a, b, c end
    return nil
end
QCF.SafeCall = SafeCall

local function Now()
    return (type(time) == "function" and time()) or 0
end

function QCF.Notice(msg)
    if DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage("|cffffd46b[Quest Compendium]|r " .. tostring(msg))
    end
end

function QCF.Database()
    return QuestCompendiumForeverDB
end

function QCF.Character()
    return QuestCompendiumForeverChar
end

function QCF.Remember(id, fields)
    id = tonumber(id)
    if not id or id <= 0 then return nil end
    local key = tostring(id)
    local db = QuestCompendiumForeverDB
    local rec = db.records[key] or { id = id }
    for k, v in pairs(fields or {}) do
        if v ~= nil then rec[k] = v end
    end
    db.records[key] = rec
    return rec
end

function QCF.GetRecord(id)
    if not id then return nil end
    id = tonumber(id)
    local own = (QuestCompendiumForeverDB and QuestCompendiumForeverDB.records[tostring(id)]) or {}
    local external = QCF.Catalog[id] or {}
    local rec = { id = id }
    for k, v in pairs(external) do rec[k] = v end
    for k, v in pairs(own) do rec[k] = v end
    local live = QCF.active[id]
    if live then
        for k, v in pairs(live) do rec[k] = v end
    end
    if not rec.title and C_QuestLog and C_QuestLog.GetTitleForQuestID then
        rec.title = SafeCall(C_QuestLog.GetTitleForQuestID, id)
    end
    rec.title = rec.title or ("Quest #" .. tostring(id))
    rec.active = live ~= nil
    rec.completed = QCF.completed[id] == true
    return rec
end

function QCF.IsCompleted(id)
    if not id then return false end
    if QCF.completed[id] then return true end
    if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
        return SafeCall(C_QuestLog.IsQuestFlaggedCompleted, id) == true
    end
    return false
end

function QCF.RefreshCompleted()
    wipe(QCF.completed)
    QCF.completedCount = 0
    local ids = C_QuestLog and SafeCall(C_QuestLog.GetAllCompletedQuestIDs)
    if type(ids) ~= "table" then return end
    QCF.completedIDs = ids
    for _, id in ipairs(ids) do
        QCF.completed[id] = true
        QCF.completedCount = QCF.completedCount + 1
    end
end

function QCF.RefreshQuests()
    wipe(QCF.active)
    if C_QuestLog and C_QuestLog.GetNumQuestLogEntries and C_QuestLog.GetInfo then
        local count = SafeCall(C_QuestLog.GetNumQuestLogEntries) or 0
        for i = 1, count do
            local info = SafeCall(C_QuestLog.GetInfo, i)
            if info and not info.isHeader and type(info.questID) == "number" and info.questID > 0 then
                local id = info.questID
                local r = {
                    id = id,
                    title = info.title,
                    level = info.level,
                    group = info.suggestedGroup or 0,
                    logIndex = i,
                }
                QCF.active[id] = r
                QCF.Remember(id, { title = info.title, level = info.level, group = info.suggestedGroup })
            end
        end
    end
    QCF.RefreshCompleted()
    if QCF.UI and QCF.UI.RefreshAll then QCF.UI.RefreshAll() end
end

function QCF.RetrieveName(id)
    if not id or not C_QuestLog then return end
    local old = QuestCompendiumForeverDB.records[tostring(id)]
    if old and old.title then return end
    local title = SafeCall(C_QuestLog.GetTitleForQuestID, id)
    if title and title ~= "" then
        QCF.Remember(id, { title = title })
    elseif QCF.nameRequests < QCF.maxNameRequests and C_QuestLog.RequestLoadQuestByID then
        if not QCF.warned[id] then
            QCF.warned[id] = true
            QCF.nameRequests = QCF.nameRequests + 1
            SafeCall(C_QuestLog.RequestLoadQuestByID, id)
        end
    end
end

function QCF.HydrateCompletedNames()
    -- Pro Durchlauf nur wenige Questnamen anfordern; kein Massenabruf.
    local ids = QCF.completedIDs
    if not ids or QCF.completedNameCursor > #ids then return end
    local processed = 0
    while QCF.completedNameCursor <= #ids and processed < 15 do
        local id = ids[QCF.completedNameCursor]
        QCF.completedNameCursor = QCF.completedNameCursor + 1
        local rec = QuestCompendiumForeverDB.records[tostring(id)]
        if not rec or not rec.title then QCF.RetrieveName(id) end
        processed = processed + 1
    end
    if QCF.UI and QCF.UI.frame and QCF.UI.frame:IsShown() then
        QCF.UI.RefreshAll()
    end
end

function QCF.GetSortedQuests(search, filter)
    local combined = {}
    for id in pairs(QCF.Catalog) do combined[id] = true end
    for key in pairs(QuestCompendiumForeverDB.records) do combined[tonumber(key)] = true end
    for id in pairs(QCF.active) do combined[id] = true end
    local output = {}
    local s = string.lower(search or "")
    for id in pairs(combined) do
        local r = QCF.GetRecord(id)
        local name = string.lower(r.title or "")
        local match = (s == "") or string.find(name, s, 1, true) or string.find(tostring(id), s, 1, true)
        local isComplete = r.completed
        if match and (filter == "all" or (filter == "done" and isComplete) or
            (filter == "open" and not isComplete)) then
            r.sortRank = (s ~= "" and string.sub(name, 1, #s) == s) and 0 or 1
            output[#output + 1] = r
        end
    end
    table.sort(output, function(a, b)
        if a.sortRank ~= b.sortRank then return a.sortRank < b.sortRank end
        if a.completed ~= b.completed then return not a.completed end
        return (a.title or "") < (b.title or "")
    end)
    return output
end

function QCF.GetQuestLine(rec)
    if not rec then return {} end
    if rec.questline and #rec.questline > 0 then return rec.questline, rec.questLineName end
    if C_QuestLine and C_QuestLine.GetQuestLineInfo and C_QuestLine.GetQuestLineQuests then
        local info = SafeCall(C_QuestLine.GetQuestLineInfo, rec.id)
        if info and info.questLineID then
            local ids = SafeCall(C_QuestLine.GetQuestLineQuests, info.questLineID)
            if type(ids) == "table" and #ids > 0 then
                for i = 1, math.min(#ids, 8) do QCF.RetrieveName(ids[i]) end
                return ids, info.questLineName
            end
        end
    end
    return { rec.id }, nil
end

function QCF.GetPosition(rec)
    if rec.start and rec.start.mapID and rec.start.x and rec.start.y then
        return rec.start, "Questgeber (Datenbank)"
    end
    if rec.acceptedAt and rec.acceptedAt.mapID and rec.acceptedAt.x then
        return rec.acceptedAt, "Erfasster Annahmeort"
    end
    if rec.active and C_QuestLog and C_QuestLog.GetNextWaypoint then
        local mapID, x, y = SafeCall(C_QuestLog.GetNextWaypoint, rec.id)
        if mapID and x and y then
            return { mapID = mapID, x = x, y = y }, "Questwegpunkt (nicht zwingend Questgeber)"
        end
    end
    return nil, "Questgeberposition noch unbekannt"
end

function QCF.GetPlayerLocation()
    if not C_Map or not C_Map.GetBestMapForUnit or not C_Map.GetPlayerMapPosition then return nil end
    local mapID = SafeCall(C_Map.GetBestMapForUnit, "player")
    if not mapID then return nil end
    local pos = SafeCall(C_Map.GetPlayerMapPosition, mapID, "player")
    if not pos or not pos.GetXY then return nil end
    local x, y = pos:GetXY()
    if not x or not y then return nil end
    return { mapID = mapID, x = x, y = y }
end

function QCF.CaptureAcceptLocation(id)
    local pos = QCF.GetPlayerLocation()
    local giver = (type(UnitName) == "function" and UnitName("npc")) or nil
    local fields = {}
    if pos then fields.acceptedAt = pos end
    if giver and giver ~= "" then fields.observedNPC = giver end
    QCF.Remember(id, fields)
end

function QCF.GetXP(rec)
    if rec and rec.active and type(GetQuestLogRewardXP) == "function" then
        local xp = SafeCall(GetQuestLogRewardXP, rec.id)
        if type(xp) == "number" then return xp, "Questlog (aktuell)" end
    end
    if rec and type(rec.rewardXP) == "number" then
        return rec.rewardXP, "Katalogwert"
    end
    local hist = QuestCompendiumForeverChar and QuestCompendiumForeverChar.history[tostring(rec.id)]
    if hist and type(hist.actualXP) == "number" then
        return hist.actualXP, "Tatsächlich erhalten"
    end
    return nil, "Unbekannt"
end

function QCF.GetActualMinutes(id)
    local hist = QuestCompendiumForeverChar and QuestCompendiumForeverChar.history[tostring(id)]
    if hist and hist.duration and hist.duration > 0 then
        return math.ceil(hist.duration / 60)
    end
    return nil
end

function QCF.GetRecommendation(rec)
    if not rec then return "–" end
    if rec.group and rec.group > 1 then return rec.group .. " Spieler (Angabe)" end
    if rec.active then return "Solo? (Schätzung)" end
    return "Unbekannt"
end

function QCF.GetLineTotal(ids)
    if not ids or #ids < 2 then return nil, nil end
    local xpSum, minutesSum = 0, 0
    local xpKnown, timeKnown = true, true
    for _, id in ipairs(ids) do
        local rec = QCF.GetRecord(id)
        local xp = QCF.GetXP(rec)
        local mins = QCF.GetActualMinutes(id)
        if type(xp) == "number" then xpSum = xpSum + xp else xpKnown = false end
        if type(mins) == "number" then minutesSum = minutesSum + mins else timeKnown = false end
    end
    return xpKnown and xpSum or nil, timeKnown and minutesSum or nil
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("QUEST_LOG_UPDATE")
events:RegisterEvent("QUEST_ACCEPTED")
events:RegisterEvent("QUEST_TURNED_IN")
events:RegisterEvent("QUEST_DATA_LOAD_RESULT")
events:RegisterEvent("PLAYER_LEVEL_UP")

events:SetScript("OnEvent", function(_, event, arg1, arg2, arg3)
    if event == "ADDON_LOADED" then
        if arg1 ~= addonName then return end
        QuestCompendiumForeverDB = QuestCompendiumForeverDB or {}
        QuestCompendiumForeverDB.records = QuestCompendiumForeverDB.records or {}
        QuestCompendiumForeverChar = QuestCompendiumForeverChar or {}
        QuestCompendiumForeverChar.history = QuestCompendiumForeverChar.history or {}
        QuestCompendiumForeverChar.accepted = QuestCompendiumForeverChar.accepted or {}
        QuestCompendiumForeverChar.window = QuestCompendiumForeverChar.window or {}
        QCF.UI.Create()
        QCF.RefreshQuests()
        if C_Timer and C_Timer.NewTicker then
            C_Timer.NewTicker(2, function()
                if QuestCompendiumForeverDB then QCF.HydrateCompletedNames() end
            end)
        end
        return
    end
    if not QuestCompendiumForeverDB then return end
    if event == "QUEST_ACCEPTED" then
        local id = tonumber(arg1)
        if id then
            QuestCompendiumForeverChar.accepted[tostring(id)] = Now()
            QCF.CaptureAcceptLocation(id)
            QCF.RetrieveName(id)
        end
    elseif event == "QUEST_TURNED_IN" then
        local id = tonumber(arg1)
        if id then
            local accepted = QuestCompendiumForeverChar.accepted[tostring(id)]
            local duration = accepted and math.max(0, Now() - accepted) or nil
            QuestCompendiumForeverChar.history[tostring(id)] = {
                actualXP = type(arg2) == "number" and arg2 or nil,
                actualMoney = type(arg3) == "number" and arg3 or nil,
                duration = duration,
                ended = Now(),
            }
            QuestCompendiumForeverChar.accepted[tostring(id)] = nil
            QCF.completed[id] = true
            QCF.RetrieveName(id)
        end
    elseif event == "QUEST_DATA_LOAD_RESULT" then
        if arg2 and arg1 then
            local name = SafeCall(C_QuestLog.GetTitleForQuestID, arg1)
            if name and name ~= "" then QCF.Remember(arg1, { title = name }) end
        end
    end
    if event == "QUEST_LOG_UPDATE" or event == "PLAYER_ENTERING_WORLD" or event == "QUEST_ACCEPTED" or event == "QUEST_TURNED_IN" then
        QCF.RefreshQuests()
    elseif QCF.UI then
        QCF.UI.RefreshAll()
    end
end)

SLASH_QUESTCOMPENDIUMFOREVER1 = "/qcf"
SLASH_QUESTCOMPENDIUMFOREVER2 = "/questcompendium"
SlashCmdList.QUESTCOMPENDIUMFOREVER = function(msg)
    msg = string.lower(strtrim(msg or ""))
    if msg == "reset" then
        QuestCompendiumForeverChar.window = {}
        QCF.UI.ResetPosition()
        QCF.Notice("Fensterposition und -größe zurückgesetzt.")
    elseif msg == "status" then
        QCF.Notice("Alpha " .. QCF.version .. " | Questnamen bekannt: " ..
          tostring(#QCF.GetSortedQuests("", "all")) .. " | Abgeschlossen laut Spiel: " .. QCF.completedCount)
    else
        QCF.UI.Toggle()
    end
end
