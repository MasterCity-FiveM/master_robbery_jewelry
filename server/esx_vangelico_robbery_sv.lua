local rob = false
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

ESX.RegisterServerCallback('master_robbery_jewelry:canRob', function(source, cb, store)
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
	local source = source
	local xPlayers = ESX.GetPlayers()
	rob = false
	
	TriggerClientEvent('master_robbery_jewelry:msgPolice', source, 'cancel')
	TriggerClientEvent('master_robbery_jewelry:robberycomplete', source)
end)

RegisterServerEvent('master_robbery_jewelry:endrob')
AddEventHandler('master_robbery_jewelry:endrob', function(robb)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem('jewels', math.random(Config.MinJewels, Config.MaxJewels))
	TriggerClientEvent("pNotify:SendNotification", source, { text = "سرقت شما به پایان رسید، تا دزدیی دیگر خدانگهدار!", type = "success", timeout = 4000, layout = "bottomCenter"})
	TriggerClientEvent('master_robbery_jewelry:robberycomplete', source)
end)

RegisterServerEvent('master_robbery_jewelry:rob')
AddEventHandler('master_robbery_jewelry:rob', function(robb)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	
	if Stores[robb] then

		local store = Stores[robb]

		if (os.time() - store.lastrobbed) < Config.SecBetwNextRob and store.lastrobbed ~= 0 then
			return
		end

		if rob == false then
			rob = true
			TriggerClientEvent('master_robbery_jewelry:msgPolice', source, 'start')
			TriggerClientEvent("pNotify:SendNotification", source, { text = "دزدگیر فعال شد!", type = "error", timeout = 4000, layout = "bottomCenter"})
			TriggerClientEvent('master_robbery_jewelry:currentlyrobbing', source, robb)
            --CancelEvent()
			Stores[robb].lastrobbed = os.time()
		end
	end
end)
