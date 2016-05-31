local db = exports.db

addEvent("loadPlayerVehicles", true)
addEventHandler("loadPlayerVehicles", root, function()
	loadPlayerVehicles(client)
end)

function loadPlayerVehicles(player) -- reload?
	local charInfo = player:getData("charInfo")
	if not charInfo then
		return
	end
	local vehicles = db:fetch("SELECT * FROM `rp_vehicles` WHERE `ownerType`=1 AND `owner`=?", charInfo["UID"])
	player:setData("charVehicles", vehicles)
	triggerClientEvent(player, "onPlayerVehiclesLoaded", root)
end