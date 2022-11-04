QBCore = exports['qb-core']:GetCoreObject() -- Used Globally
inJail = false
jailTime = 0
currentJob = "electrician"
iemsls = " "
CellsBlip = nil
TimeBlip = nil
ShopBlip = nil
iemslsBlip = nil
PlayerJob = {}

function DrawText3D(x, y, z, text) -- Used Globally
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end


local function CreateCellsBlip()
	if CellsBlip ~= nil then
		RemoveBlip(CellsBlip)
	end
	CellsBlip = AddBlipForCoord(Config.Locations["yard"].coords.x, Config.Locations["yard"].coords.y, Config.Locations["yard"].coords.z)

	SetBlipSprite (CellsBlip, 238)
	SetBlipDisplay(CellsBlip, 4)
	SetBlipScale  (CellsBlip, 0.8)
	SetBlipAsShortRange(CellsBlip, true)
	SetBlipColour(CellsBlip, 4)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Cellen")
	EndTextCommandSetBlipName(CellsBlip)

	if TimeBlip ~= nil then
		RemoveBlip(TimeBlip)
	end
	TimeBlip = AddBlipForCoord(Config.Locations["freedom"].coords.x, Config.Locations["freedom"].coords.y, Config.Locations["freedom"].coords.z)

	SetBlipSprite (TimeBlip, 466)
	SetBlipDisplay(TimeBlip, 4)
	SetBlipScale  (TimeBlip, 0.8)
	SetBlipAsShortRange(TimeBlip, true)
	SetBlipColour(TimeBlip, 4)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("AdminJail laiks")
	EndTextCommandSetBlipName(TimeBlip)

	if ShopBlip ~= nil then
		RemoveBlip(ShopBlip)
	end
	ShopBlip = AddBlipForCoord(Config.Locations["shop"].coords.x, Config.Locations["shop"].coords.y, Config.Locations["shop"].coords.z)

	SetBlipSprite (ShopBlip, 52)
	SetBlipDisplay(ShopBlip, 4)
	SetBlipScale  (ShopBlip, 0.5)
	SetBlipAsShortRange(ShopBlip, true)
	SetBlipColour(ShopBlip, 0)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Veikals")
	EndTextCommandSetBlipName(ShopBlip)

	if iemslsBlip ~= nil then
		RemoveBlip(iemslsBlip)
	end
	iemslsBlip = AddBlipForCoord(Config.Locations["iemsls"].coords.x, Config.Locations["iemsls"].coords.y, Config.Locations["iemsls"].coords.z)

	SetBlipSprite (iemslsBlip, 52)
	SetBlipDisplay(iemslsBlip, 4)
	SetBlipScale  (iemslsBlip, 0.5)
	SetBlipAsShortRange(iemslsBlip, true)
	SetBlipColour(iemslsBlip, 0)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Darbs")
	EndTextCommandSetBlipName(iemslsBlip)
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	QBCore.Functions.GetPlayerData(function(PlayerData)
		if PlayerData.metadata["injaila"] > 0 then
			TriggerEvent("AdminJail:client:Enter", PlayerData.metadata["injaila"])
		end
	end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
	inJail = false
	currentJob = nil
	RemoveBlip(currentBlip)
end)

RegisterNetEvent('AdminJail:client:Enter', function(time, iemsls)
	QBCore.Functions.Notify( Lang:t("error.injail", {Time = time, iemsls = iemsls}), "error")

	local playername = GetPlayerName(PlayerId())
	local player = PlayerPedId()
	
	TriggerEvent("chatMessage", "Adminjail", -1, ""..playername.. " Tika iemests adminjailā! Uz " ..time.." minūtēm!")
	DoScreenFadeOut(500)
	while not IsScreenFadedOut() do
		Wait(10)
	end
	local RandomStartPosition = Config.Locations.spawns[math.random(1, #Config.Locations.spawns)]
	SetEntityCoords(PlayerPedId(), RandomStartPosition.coords.x, RandomStartPosition.coords.y, RandomStartPosition.coords.z - 0.0, 0, 0, 0, false)
	SetEntityHeading(PlayerPedId(), RandomStartPosition.coords.w)
	Wait(500)

	inJail = true
	jailTime = time
	currentJob = "electrician"
	TriggerServerEvent("AdminJail:server:SetJailStatus", jailTime, iemsls)
	TriggerServerEvent("AdminJail:server:SaveJailItems", jailTime, iemsls)
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "jail", 0.5)
	CreateCellsBlip()
	Wait(5000)
	DoScreenFadeIn(2000)
    SetEntityMaxHealth(player, 200)
    SetEntityHealth(player, 200)
    TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", 100)
    TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", 100)
end)

RegisterNetEvent('AdminJail:client:Leave', function(iemsls)

	local playername = GetPlayerName(PlayerId())
	local player = PlayerPedId()

	if jailTime > 0 then
		QBCore.Functions.Notify( Lang:t("info.timeleft", {JAILTIME = jailTime, iemsls = iemsls}))
	else
		jailTime = 0
		TriggerServerEvent("AdminJail:server:SetJailStatus", 0)
		TriggerServerEvent("AdminJail:server:GiveJailItems")
		TriggerEvent("chatMessage", "Adminjail", -1, ""..playername.. " Tika ārā no AdminJail!")
		inJail = false
		RemoveBlip(currentBlip)
		RemoveBlip(CellsBlip)
		CellsBlip = nil
		RemoveBlip(TimeBlip)
		TimeBlip = nil
		RemoveBlip(ShopBlip)
		ShopBlip = nil
		RemoveBlip(iemslsBlip)
		iemslsBlip = nil
		QBCore.Functions.Notify(Lang:t("success.free_"))
		DoScreenFadeOut(500)
		while not IsScreenFadedOut() do
			Wait(10)
		end
		SetEntityCoords(PlayerPedId(), Config.Locations["outside"].coords.x, Config.Locations["outside"].coords.y, Config.Locations["outside"].coords.z, 0, 0, 0, false)
		SetEntityHeading(PlayerPedId(), Config.Locations["outside"].coords.w)

		Wait(500)

		DoScreenFadeIn(1000)
		SetEntityMaxHealth(player, 200)
		SetEntityHealth(player, 200)
		TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", 100)
		TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", 100)
	end
end)

local function JobDone()
    if math.random(1, 1) <= 1 then
        QBCore.Functions.Notify(Lang:t("success.time_cuts"))
        jailTime = jailTime - math.random(2, 5)
    end
end

RegisterNetEvent('AdminJail:client:iemsls', function(iemsls)
	local playername = GetPlayerName(PlayerId())

end)

RegisterNetEvent('AdminJail:client:iemsls')
AddEventHandler("AdminJail:client:iemsls", function()
    QBCore.Functions.Progressbar("pedras", "AdminJail Darbs", 1000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = " ",
        anim = "base",
        flags = 16,
    }, {}, {}, function() 
        local playerPed = PlayerPedId()
        local success = exports['qb-lock']:StartLockPickCircle(20,20)
   if success then
        StopAnimTask(ped, dict, "base", 1.0)
        ClearPedTasks(playerPed)
		JobDone()
		SetEntityMaxHealth(player, 200)
		SetEntityHealth(player, 200)
		TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", 100)
		TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", 100)
    else
        ClearPedTasks(playerPed)
		local RandomStartPosition = Config.Locationss.spawnss[math.random(1,7)]
		SetEntityCoords(PlayerPedId(), RandomStartPosition.coords.x, RandomStartPosition.coords.y, RandomStartPosition.coords.z - 0.0, 0, 0, 0, false)
		SetEntityHeading(PlayerPedId(), RandomStartPosition.coords.w)
		SetEntityMaxHealth(player, 200)
		SetEntityHealth(player, 200)
		TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", 100)
		TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", 100)
        end
    end)
end)

RegisterNetEvent('AdminJail:client:UnjailPerson', function()
	local playername = GetPlayerName(PlayerId())
	local player = PlayerPedId()

	if jailTime > 0 then
		TriggerServerEvent("AdminJail:server:SetJailStatus", 0)
		TriggerServerEvent("AdminJail:server:GiveJailItems")
		TriggerEvent("chatMessage", "Adminjail", -1, ""..playername.. " Tika izlaists no AdminJaila!")
		inJail = false
		RemoveBlip(currentBlip)
		RemoveBlip(CellsBlip)
		CellsBlip = nil
		RemoveBlip(TimeBlip)
		TimeBlip = nil
		RemoveBlip(ShopBlip)
		ShopBlip = nil
		RemoveBlip(iemslsBlip)
		iemslsBlip = nil
		QBCore.Functions.Notify(Lang:t("success.free_"))
		DoScreenFadeOut(500)
		while not IsScreenFadedOut() do
			Wait(10)
		end
		SetEntityCoords(PlayerPedId(), Config.Locations["outside"].coords.x, Config.Locations["outside"].coords.y, Config.Locations["outside"].coords.z, 0, 0, 0, false)
		SetEntityHeading(PlayerPedId(), Config.Locations["outside"].coords.w)
		Wait(500)
		DoScreenFadeIn(1000)
		SetEntityMaxHealth(player, 200)
		SetEntityHealth(player, 200)
		TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", 100)
		TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", 100)
	end
end)

-- Threads

CreateThread(function()
    TriggerEvent('AdminJail:client:JailAlarm', false)
	while true do
		Wait(7)
		if jailTime > 0 and inJail then
			Wait(1000 * 60)
			if jailTime > 0 and inJail then
				jailTime = jailTime - 1
				if jailTime <= 0 then
					jailTime = 0
					QBCore.Functions.Notify(Lang:t("success.timesup"), "success", 15000)
				end
				TriggerServerEvent("AdminJail:server:SetJailStatus", jailTime, iemsls)
			end
		else
			Wait(5000)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(1)
		if LocalPlayer.state.isLoggedIn then
			if inJail then
				local pos = GetEntityCoords(PlayerPedId())
				if #(pos - vector3(Config.Locations["freedom"].coords.x, Config.Locations["freedom"].coords.y, Config.Locations["freedom"].coords.z)) < 1.5 then
					DrawText3D(Config.Locations["freedom"].coords.x, Config.Locations["freedom"].coords.y, Config.Locations["freedom"].coords.z, "~g~E~w~ - Laiks")
					if IsControlJustReleased(0, 38) then
						TriggerEvent("AdminJail:client:Leave")
					end
				elseif #(pos - vector3(Config.Locations["freedom"].coords.x, Config.Locations["freedom"].coords.y, Config.Locations["freedom"].coords.z)) < 2.5 then
					DrawText3D(Config.Locations["freedom"].coords.x, Config.Locations["freedom"].coords.y, Config.Locations["freedom"].coords.z, "Laiks")
				end

				if #(pos - vector3(Config.Locations["iemsls"].coords.x, Config.Locations["iemsls"].coords.y, Config.Locations["iemsls"].coords.z)) < 1.5 then
					DrawText3D(Config.Locations["iemsls"].coords.x, Config.Locations["iemsls"].coords.y, Config.Locations["iemsls"].coords.z, "~g~E~w~ - Darbs")
					if IsControlJustReleased(0, 38) then
						TriggerEvent("AdminJail:client:iemsls")
					end
				elseif #(pos - vector3(Config.Locations["iemsls"].coords.x, Config.Locations["iemsls"].coords.y, Config.Locations["iemsls"].coords.z)) < 2.5 then
					DrawText3D(Config.Locations["iemsls"].coords.x, Config.Locations["iemsls"].coords.y, Config.Locations["iemsls"].coords.z, "AdminJail")
				end

				if #(pos - vector3(Config.Locations["shop"].coords.x, Config.Locations["shop"].coords.y, Config.Locations["shop"].coords.z)) < 1.5 then
					DrawText3D(Config.Locations["shop"].coords.x, Config.Locations["shop"].coords.y, Config.Locations["shop"].coords.z, "~g~E~w~ - Veikals")
					if IsControlJustReleased(0, 38) then
                        local ShopItems = {}
                        ShopItems.label = "AdminJail veikals"
                        ShopItems.items = Config.CanteenItems
                        ShopItems.slots = #Config.CanteenItems
                        TriggerServerEvent("inventory:server:OpenInventory", "shop", "AdminJail veikals"..math.random(1, 99), ShopItems)
					end
					DrawMarker(2, Config.Locations["shop"].coords.x, Config.Locations["shop"].coords.y, Config.Locations["shop"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 255, 55, 22, 222, false, false, false, 1, false, false, false)
				elseif #(pos - vector3(Config.Locations["shop"].coords.x, Config.Locations["shop"].coords.y, Config.Locations["shop"].coords.z)) < 2.5 then
					DrawText3D(Config.Locations["shop"].coords.x, Config.Locations["shop"].coords.y, Config.Locations["shop"].coords.z, "Canteen")
					DrawMarker(2, Config.Locations["shop"].coords.x, Config.Locations["shop"].coords.y, Config.Locations["shop"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 255, 55, 22, 222, false, false, false, 1, false, false, false)
				elseif #(pos - vector3(Config.Locations["shop"].coords.x, Config.Locations["shop"].coords.y, Config.Locations["shop"].coords.z)) < 10 then
					DrawMarker(2, Config.Locations["shop"].coords.x, Config.Locations["shop"].coords.y, Config.Locations["shop"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 255, 55, 22, 222, false, false, false, 1, false, false, false)
				end
			end
		else
			Wait(5000)
		end
	end
end)

RegisterNetEvent('eihents:client:JailCommand', function(playerId, time, iemsls, recruit)
    TriggerServerEvent("eihents:server:JailPlayer", playerId, tonumber(time))
	local playername = GetPlayerName(PlayerId())
    local playerid = GetPlayerServerId(PlayerId())
	-- local Target = QBCore.Functions.GetPlayer(PlayerId)
	TriggerServerEvent('qb-log:server:CreateLog', 'adminjail', 'AdminJail', 'green', string.format(playername..": ID: "..playerId.." Izmantoja komandu /jail un ielika personu uz "..time.." Minūtēm AdminJailā! Ieliktās personas vārds:".. (Target.PlayerData.charinfo.firstname .. ' ' .. Target.PlayerData.charinfo.lastname).." !", true))

end)

RegisterNetEvent('eihents:client:SendToJail', function(time, iemsls)
    TriggerServerEvent("eihents:server:SetHandcuffStatus", false)
    isHandcuffed = false
    isEscorted = false
    ClearPedTasks(PlayerPedId())
    DetachEntity(PlayerPedId(), true, false)
    TriggerEvent("AdminJail:client:Enter", time, iemsls)
end)

CreateThread(function()
	while true do
		Wait(7)
		if inJail then
            local ped = PlayerPedId()
            DisableControlAction(0, 24, true)
			DisableControlAction(0, 25, true)
			DisableControlAction(0, 45, true)
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 169, true)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(1)
		if jailTime > 0 and inJail then
            local ped = PlayerPedId()
			print("Tev vel jāpavada iekš AdminJaila "..jailTime.." Minūtes")
			Wait(5000)
		elseif jailTime == 0 and inJail then
			jailTime = 0
			TriggerEvent("AdminJail:client:Leave")
			inJail = false
		end
	end
end)


local function JobDonee()
    if math.random(1, 1) <= 1 then
        jailTime = jailTime + math.random(5, 5)
    end
end

CreateThread(function()
	while true do
		Wait(1)
		if jailTime > 0 and inJail then
			QBCore.Functions.Progressbar("pedras", "AdminJail Darbs", 100, false, true, {
				Wait(math.random(120000, 500000)),
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, {
				animDict = " ",
				anim = "base",
				flags = 16,
			}, {}, {}, function() 
				local playerPed = PlayerPedId()
				local success = exports['qb-lock']:StartLockPickCircle(1,20)
		   if success then
				StopAnimTask(ped, dict, "base", 1.0)
				ClearPedTasks(playerPed)
				SetEntityMaxHealth(player, 200)
				SetEntityHealth(player, 200)
				TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", 100)
				TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", 100)
			else
				ClearPedTasks(playerPed)
				-- local RandomStartPosition = Config.Locationss.spawnss[math.random(1,7)]
				-- SetEntityCoords(PlayerPedId(), RandomStartPosition.coords.x, RandomStartPosition.coords.y, RandomStartPosition.coords.z - 0.0, 0, 0, 0, false)
				-- SetEntityHeading(PlayerPedId(), RandomStartPosition.coords.w)
				JobDonee()
				print("Zaudēji automātiskajā MiniGame!")
				SetEntityMaxHealth(player, 200)
				SetEntityHealth(player, 200)
				TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", 100)
				TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", 100)
				end
			end)
		end
	end
end)


