local holdingup = false
local store = ""
local vetrineRotte = 0 
local isDead = false

local vetrine = {
	{x = 147.085, y = -1048.612, z = 29.346, heading = 70.326, isOpen = false},--
	{x = -626.735, y = -238.545, z = 38.057, heading = 214.907, isOpen = false},--
	{x = -625.697, y = -237.877, z = 38.057, heading = 217.311, isOpen = false},--
	{x = -626.825, y = -235.347, z = 38.057, heading = 33.745, isOpen = false},--
	{x = -625.77, y = -234.563, z = 38.057, heading = 33.572, isOpen = false},--
	{x = -627.957, y = -233.918, z = 38.057, heading = 215.214, isOpen = false},--
	{x = -626.971, y = -233.134, z = 38.057, heading = 215.532, isOpen = false},--
	{x = -624.433, y = -231.161, z = 38.057, heading = 305.159, isOpen = false},--
	{x = -623.045, y = -232.969, z = 38.057, heading = 303.496, isOpen = false},--
	{x = -620.265, y = -234.502, z = 38.057, heading = 217.504, isOpen = false},--
	{x = -619.225, y = -233.677, z = 38.057, heading = 213.35, isOpen = false},--
	{x = -620.025, y = -233.354, z = 38.057, heading = 34.18, isOpen = false},--
	{x = -617.487, y = -230.605, z = 38.057, heading = 309.177, isOpen = false},--
	{x = -618.304, y = -229.481, z = 38.057, heading = 304.243, isOpen = false},--
	{x = -619.741, y = -230.32, z = 38.057, heading = 124.283, isOpen = false},--
	{x = -619.686, y = -227.753, z = 38.057, heading = 305.245, isOpen = false},--
	{x = -620.481, y = -226.59, z = 38.057, heading = 304.677, isOpen = false},--
	{x = -621.098, y = -228.495, z = 38.057, heading = 127.046, isOpen = false},--
	{x = -623.855, y = -227.051, z = 38.057, heading = 38.605, isOpen = false},--
	{x = -624.977, y = -227.884, z = 38.057, heading = 48.847, isOpen = false},--
	{x = -624.056, y = -228.228, z = 38.057, heading = 216.443, isOpen = false},--
}

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while not ESX.GetPlayerData().job do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
	
	local blip = AddBlipForCoord(-629.99, -236.542, 38.05)
	SetBlipSprite(blip, 439)
	SetBlipScale(blip, 0.8)
	SetBlipColour(blip, 46)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Javaheri')
	EndTextCommandSetBlipName(blip)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job) ESX.PlayerData.job = job end)

function DrawText3D(x, y, z, text, scale)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 215)

	AddTextComponentString(text)
	DrawText(_x, _y)
end

local underdisplaymessage = false
function DisplayHelpText(str)
	if not underdisplaymessage then
		Citizen.CreateThread(function() 
			underdisplaymessage = true
			exports.pNotify:SendNotification({text = str, type = "info", timeout = 3000})	
			Citizen.Wait(3200)
			underdisplaymessage = false
		end)
	end
end

function loadAnimDict(dict)  
    while(not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end 

RegisterNetEvent('master_robbery_jewelry:currentlyrobbing')
AddEventHandler('master_robbery_jewelry:currentlyrobbing', function(robb)
	holdingup = true
	store = robb
end)

RegisterNetEvent('master_robbery_jewelry:robberycomplete')
AddEventHandler('master_robbery_jewelry:robberycomplete', function(robb)
	holdingup = false
	robbingName = ""
	incircle = false
end)

animazione = false
incircle = false
soundid = GetSoundId()

function drawTxt(x, y, scale, text, red, green, blue, alpha)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextScale(0.44, 0.44)
	SetTextColour(red, green, blue, alpha)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
    DrawText(0.175, 0.935)
end

RegisterNetEvent('master_robbery_jewelry:msgPolice')
AddEventHandler('master_robbery_jewelry:msgPolice', function(messagetype)
	local playerPed = PlayerPedId()
	PedPosition		= GetEntityCoords(playerPed)
	local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }
	
	message1 = "شما از دزدی منصرف شدید!"
	message2 = 'سارق از دزدی منصرف شد!'
	
	if messagetype == 'start' then
		message1 = "سیستم های امنیتی، گزارش دزدی شما را برای پلیس ارسال کرده، عجله کنید!"
		message2 = 'دزدی از جواهری گزارش شده است!'
	end
	
	exports.pNotify:SendNotification({text = message1, type = "error", timeout = 4000})

    TriggerServerEvent('esx_addons_gcphone:startCall', 'police', message2, PlayerCoords, {
		PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z },
	})
end)

Citizen.CreateThread(function()
	while true do
		if ESX == nil or ESX.PlayerData == nil or ESX.PlayerData.job == nil or ESX.PlayerData.job.name == nil or (ESX.PlayerData.job.name ~= 'police' and ESX.PlayerData.job.name ~= 'sheriff') then
			local pos = GetEntityCoords(GetPlayerPed(-1), true)
			local letSleep = true
			
			for k,v in pairs(Stores) do
				local pos2 = v.position

				if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 15.0)then
					letSleep = false
					if not holdingup then
						DrawMarker(27, v.position.x, v.position.y, v.position.z-0.9, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 255, 0, 0, 200, 0, 0, 0, 0)

						if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 1.0)then
							if (incircle == false) then
								DisplayHelpText(_U('press_to_rob'))
							end
							incircle = true
							if IsPedShooting(GetPlayerPed(-1)) then
								local canRob = nil
								
								ESX.TriggerServerCallback('master_robbery_jewelry:canRob', function(cb)
									canRob = cb
								end, k)
								
								while canRob == nil do
									Wait(0)
								end
								
								if canRob == true then
									local hasBag = nil
									
									TriggerEvent('skinchanger:getSkin', function(skin)
										if skin['bags_1'] ~= nil and (skin['bags_1'] == 85 or skin['bags_1'] == 86 or skin['bags_1'] == 82 or skin['bags_1'] == 81 or skin['bags_1'] == 45 or skin['bags_1'] == 41 or skin['bags_1'] == 40) then
											hasBag = true
										else
											hasBag = false
										end
									end)
								
									while hasBag == nil do
										Wait(0)
									end
									
									if hasBag == true then
										 TriggerServerEvent('master_robbery_jewelry:rob', k)
										 PlaySoundFromCoord(soundid, "VEHICLES_HORNS_AMBULANCE_WARNING", pos2.x, pos2.y, pos2.z)
									else 
										exports.pNotify:SendNotification({text = "برو کیف بیار بابا، مگه فیلم هندیه؟!", type = "error", timeout = 4000})
										Wait(4500)
									end
								elseif canRob == 'no_cops' then
									exports.pNotify:SendNotification({text = "تعداد پلیس ها کم می باشد!", type = "error", timeout = 4000})
									Wait(4500)
								else
									exports.pNotify:SendNotification({text = "دیر رسیدی، اینجا خالی شده!", type = "info", timeout = 4000})
									Wait(4500)
								end
							end
						elseif(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 1.0)then
							incircle = false
						end		
					end
				end
			end

			if holdingup then
				letSleep = false
				drawTxt(0.3, 1.4, 0.45, _U('smash_case') .. ' :~r~ ' .. vetrineRotte .. '/' .. Config.MaxWindows, 185, 185, 185, 255)

				for i,v in pairs(vetrine) do 
					if(GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 10.0) and not v.isOpen and Config.EnableMarker then 
						DrawMarker(20, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 0.6, 0.6, 0.6, 0, 255, 0, 200, 1, 1, 0, 0)
					end
					if(GetDistanceBetweenCoords(pos, v.x, v.y, v.z, true) < 0.75) and not v.isOpen then 
						DrawText3D(v.x, v.y, v.z, '~w~[~g~E~w~] ' .. _U('press_to_collect'), 0.6)
						if IsControlJustPressed(0, 38) then
							animazione = true

							SetEntityCoords(GetPlayerPed(-1), v.x, v.y, v.z-0.95)
							SetEntityHeading(GetPlayerPed(-1), v.heading)
							v.isOpen = true 
							PlaySoundFromCoord(-1, "Glass_Smash", v.x, v.y, v.z, "", 0, 0, 0)
							
							if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
								RequestNamedPtfxAsset("scr_jewelheist")
							end
							
							while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
								Citizen.Wait(0)
							end
							
							SetPtfxAssetNextCall("scr_jewelheist")
							StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", v.x, v.y, v.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
							loadAnimDict("missheist_jewel") 
							TaskPlayAnim(GetPlayerPed(-1), "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0 ) 
							exports.pNotify:SendNotification({text = "برداشتن جواهر ...", type = "info", timeout = 4500})
							Citizen.Wait(5000)
							ClearPedTasksImmediately(GetPlayerPed(-1))
							PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
							vetrineRotte = vetrineRotte+1
							animazione = false

							if vetrineRotte == Config.MaxWindows then 
								for i,v in pairs(vetrine) do 
									v.isOpen = false
									vetrineRotte = 0
								end
								TriggerServerEvent('master_robbery_jewelry:endrob', store)
								holdingup = false
								StopSound(soundid)
							end
						end
					end	
				end

				local pos2 = Stores[store].position
				if isDead or (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -622.566, -230.183, 38.057, true) > 11.5 ) then
					TriggerServerEvent('master_robbery_jewelry:toofar', store)
					holdingup = false
					for i,v in pairs(vetrine) do 
						v.isOpen = false
						vetrineRotte = 0
					end
					StopSound(soundid)
				end
			end
			
			if letSleep then
				Citizen.Wait(2000)
			else
				Citizen.Wait(0)
			end
		else
			Citizen.Wait(10000)
		end
		
	end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)
