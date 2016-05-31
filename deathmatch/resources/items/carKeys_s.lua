local db = exports.db

addEventHandler("usePlayerItem", root, function(UID)
	local charInfo = client:getData("charInfo")
	if not charInfo then
		return
	end
	if canUseItem(client, UID) then
		local itemInfo = getItemInfo(UID)
		if itemInfo.type == 3 then
			local properties = explodeProperties(itemInfo.properties)
			local vehicle = exports.vehicles:getVehicleByUID(tonumber(properties[1]))
			if not vehicle then
				return
			end
			local range = 0
			if tonumber(properties[2]) == 1 then
				range = 4
			end
			if getDistanceBetweenPoints3D(vehicle.position, client.position) < range then
				vehicle.locked = not vehicle.locked
				if vehicle.locked == true then
					if vehicle.overrideLights == 1 then
						vehicle.overrideLights = 2
						Timer(setVehicleOverrideLights, 3000, 1, vehicle, 1)
					end
				else
					if vehicle.overrideLights == 1 then
						vehicle.overrideLights = 2
						Timer(setVehicleOverrideLights, 1000, 1, vehicle, 1)
					end
				end
			end
		end
	end
end)