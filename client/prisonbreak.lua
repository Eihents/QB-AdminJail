local currentGate = 0
local requiredItemsShowed = false
local requiredItems = {}
local inRange = false
local securityLockdown = false

-- Functions

-- Events


-- Threads






local function JobDone()
    if math.random(1, 1) <= 1 then
        QBCore.Functions.Notify(Lang:t("success.time_cut"))
        jailTime = jailTime + math.random(5, 5)
    end
end


CreateThread(function()
	while true do
		Wait(1)
		local pos = GetEntityCoords(PlayerPedId(), true)
        if #(pos - vector3(Config.Locations["middle"].coords.x, Config.Locations["middle"].coords.y, Config.Locations["middle"].coords.z)) > 6 and inJail then
            TriggerServerEvent("AdminJail:server:SecurityLockdown")
            -- TriggerServerEvent("AdminJail:server:SetJailStatus", 0)
            TriggerServerEvent("QBCore:Server:SetMetaData", "jailitems", {})
            QBCore.Functions.Notify(Lang:t("error.escaped"), "error")
            disableCombat = true
            local RandomStartPosition = Config.Locations.spawns[math.random(1, #Config.Locations.spawns)]
            SetEntityCoords(PlayerPedId(), RandomStartPosition.coords.x, RandomStartPosition.coords.y, RandomStartPosition.coords.z - 0.0, 0, 0, 0, false)
            SetEntityHeading(PlayerPedId(), RandomStartPosition.coords.w)
            JobDone()
            Wait(1000)
        else
            Wait(1000)
		end
	end
end)


-- RegisterNetEvent('AdminJail:client:iemsls')
-- AddEventHandler("AdminJail:client:iemsls", function()
--     QBCore.Functions.Progressbar("pedras", "AdminJail Darbs", 2500, false, true, {
--         disableMovement = true,
--         disableCarMovement = true,
--         disableMouse = false,
--         disableCombat = true,
--     }, {
--         animDict = " ",
--         anim = "base",
--         flags = 16,
--     }, {}, {}, function() 
--         local playerPed = PlayerPedId()
--         local success = exports['qb-lock']:StartLockPickCircle(15,17)
--    if success then
--         StopAnimTask(ped, dict, "base", 1.0)
--         TriggerServerEvent("AdminJail:client:iemsls")
--         ClearPedTasks(playerPed)
-- 		JobDone()
--     else
--         ClearPedTasks(playerPed)
-- 		JobDones()
--         end
--     end)
-- end)