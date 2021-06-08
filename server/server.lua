local rob = false
ESX = nil
local RobberID = 0

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

ESX.RegisterServerCallback('master_robbery_jewelry:get_times', function(cb)
	-- ESX.RunCustomFunction("anti_ddos", source, 'master_robbery_jewelry:get_times', {})
	local status = 0
	if (os.time() - Stores["jewelry"].lastrobbed) < Config.SecBetwNextRob and Stores["jewelry"].lastrobbed ~= 0 then
		status = Config.SecBetwNextRob - (os.time() - Stores["jewelry"].lastrobbed)
	end
	cb(status)
end)

ESX.RegisterServerCallback('master_robbery_jewelry:canRob', function(source, cb, store)
	ESX.RunCustomFunction("anti_ddos", source, 'master_robbery_jewelry:canRob', {store = store})
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.get('paintball') then
		cb('paintball')
		return
	end
	
    local cops = 0
	TriggerEvent('esx_service:GetServiceCount',  function(cops)
		if cops >= Stores[store].cops then
			if (os.time() - Stores[store].lastrobbed) < Config.SecBetwNextRob and store.lastrobbed ~= 0 then
				cb(false)
			else
				cb(true)
			end
		else
			cb('no_cops')
		end
	end, 'police')
end)

RegisterServerEvent('master_robbery_jewelry:toofar')
AddEventHandler('master_robbery_jewelry:toofar', function(robb)
	ESX.RunCustomFunction("anti_ddos", source, 'master_robbery_jewelry:toofar', {robb = robb})
	local source = source
	local xPlayers = ESX.GetPlayers()
	rob = false
	RobberID = 0
	TriggerClientEvent('master_robbery_jewelry:msgPolice', source, 'cancel')
	TriggerClientEvent('master_robbery_jewelry:robberycomplete', source)
end)

RegisterServerEvent('master_robbery_jewelry:endrob')
AddEventHandler('master_robbery_jewelry:endrob', function(robb)
	ESX.RunCustomFunction("anti_ddos", source, 'master_robbery_jewelry:endrob', {robb = robb})
	if Stores[robb] then
		local store = Stores[robb]

		if store.lastrobbed == 0 or os.time() < store.lastrobbed + 120 then
			return
		end
	else
		return
	end
	
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	RobberID = 0
	xPlayer.addInventoryItem('jewels', math.random(Config.MinJewels, Config.MaxJewels))
	TriggerClientEvent("pNotify:SendNotification", source, { text = "سرقت شما به پایان رسید، تا دزدیی دیگر خدانگهدار!", type = "success", timeout = 4000, layout = "bottomCenter"})
	TriggerClientEvent('master_robbery_jewelry:robberycomplete', source)
end)

RegisterServerEvent('master_robbery_jewelry:rob')
AddEventHandler('master_robbery_jewelry:rob', function(robb)
	ESX.RunCustomFunction("anti_ddos", source, 'master_robbery_jewelry:rob', {robb = robb})
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	
	if Stores[robb] then

		local store = Stores[robb]

		if (os.time() - store.lastrobbed) < Config.SecBetwNextRob and store.lastrobbed ~= 0 then
			return
		end

		if rob == false then
			rob = true
			RobberID = source
			ESX.RunCustomFunction("discord", source, 'robstart', 'Jewelry Robbery', "")
			TriggerClientEvent('master_robbery_jewelry:msgPolice', source, 'start')
			TriggerClientEvent("pNotify:SendNotification", source, { text = "دزدگیر فعال شد!", type = "error", timeout = 4000, layout = "bottomCenter"})
			TriggerClientEvent('master_robbery_jewelry:currentlyrobbing', source, robb)
            --CancelEvent()
			Stores[robb].lastrobbed = os.time()
		end
	end
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	if source == RobberID then
		rob = false
		RobberID = 0
	end
end)