local QBCore = exports['qb-core']:GetCoreObject()

local AlarmActivated = false

local function IsWhitelisted(CitizenId)
    local retval = false
    for _, cid in pairs(Config.AdminJaill) do
        if cid == CitizenId then
            retval = true
            break
        end
    end
    local Player = QBCore.Functions.GetPlayerByCitizenId(CitizenId)
    local Perms = QBCore.Functions.GetPermission(Player.PlayerData.source)
    if Perms == "admin" or Perms == "god" then
        retval = true
    end
    return retval
end

local function IsWhitelisteds(CitizenId)
    local retval = false
    for _, cid in pairs(Config.AdminJaills) do
        if cid == CitizenId then
            retval = true
            break
        end
    end
    local Player = QBCore.Functions.GetPlayerByCitizenId(CitizenId)
    local Perms = QBCore.Functions.GetPermission(Player.PlayerData.source)
    if Perms == "admin" or Perms == "god" then
        retval = true
    end
    return retval
end

RegisterNetEvent('AdminJail:server:SetJailStatus', function(jailTime)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.SetMetaData("injaila", jailTime)
    if jailTime > 0 then
        if Player.PlayerData.job.name ~= "test" then
            Player.Functions.SetJob("test")
        end
    end
end)

RegisterNetEvent('AdminJail:server:CheckRecordStatus', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local CriminalRecord = Player.PlayerData.metadata["criminalrecords"]
    local currentDate = os.date("*t")

    if (CriminalRecord["dates"].month + 1) == 13 then
        CriminalRecord["dates"].month = 0
    end

    if CriminalRecord["hasRecords"] then
        if currentDate.month == (CriminalRecord["dates"].month + 1) or currentDate.day == (CriminalRecord["date"].day - 1) then
            CriminalRecord["hasRecords"] = false
            CriminalRecord["dates"] = nil
        end
    end
end)

RegisterNetEvent('eihents:server:JailPlayer', function(playerId, time, iemsls)
local src = source
local Player = QBCore.Functions.GetPlayer(src)
local OtherPlayer = QBCore.Functions.GetPlayer(playerId)  
local currentDate = os.date("*t")
if currentDate.day == 31 then
    currentDate.day = 30
end

if IsWhitelisted(Player.PlayerData.citizenid) then
    if OtherPlayer then
        OtherPlayer.Functions.SetMetaData("injaila", time, iemsls)
        OtherPlayer.Functions.SetMetaData("criminalrecords", {
            ["hasRecords"] = true,
            ["dates"] = currentDate
        })
        TriggerClientEvent("eihents:client:SendToJail", OtherPlayer.PlayerData.source, time, iemsls)
        TriggerClientEvent('QBCore:Notify', src, Lang:t("info.sent_jail_for", {time = time, iemsls = iemsls}))
    end
end
end)

QBCore.Commands.Add("adminj", 'Tikai admini!', {{name = "id", help = 'ID'}, {name = "time", help = 'Laiks'}, {name = "iemsls", help = 'iemsls'}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if IsWhitelisted(Player.PlayerData.citizenid) then
        local playerId = tonumber(args[1])
        local time = tonumber(args[2])
        if time > 0 then
            TriggerClientEvent("eihents:client:JailCommand", src, playerId, time, iemsls)
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t('info.jail_time_no'), 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'Tikai administrācija', 'error')
    end
end)

QBCore.Commands.Add("adminu", 'Tikai admini!', {{name = "id", help = 'ID'}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if IsWhitelisteds(Player.PlayerData.citizenid) then
        local playerId = tonumber(args[1])
        TriggerClientEvent("AdminJail:client:UnjailPerson", playerId)
    else
        TriggerClientEvent('QBCore:Notify', src, 'Tikai administrācija', 'error')
    end
end)



