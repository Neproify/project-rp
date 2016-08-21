local db = exports.db

addEvent("loadPlayerVehicles", true)
addEventHandler("loadPlayerVehicles", root, function()
	loadPlayerVehicles(client)
end)

addEventHandler("onCharacterSelected", root, function(player)
	loadPlayerVehicles(player)
end)

function loadPlayerVehicles(player) -- NOTE: używać po edycji pojazdu który posiada gracz
	local charInfo = player:getData("charInfo")
	if not charInfo then
		return
	end
	local vehicles = db:fetch("SELECT * FROM `rp_vehicles` WHERE `ownerType`=1 AND `owner`=?", charInfo["UID"])
	if #vehicles < 1 then
		vehicles = nil
	end
	player:setData("charVehicles", vehicles)
	triggerClientEvent(player, "onPlayerVehiclesLoaded", root)
end