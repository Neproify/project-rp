addEventHandler("onClientVehicleEnter", root, function(plr, seat)
	if plr == localPlayer and seat == 0 then
		addEventHandler("onClientPreRender", root, fuelCount)
	end
end)

addEventHandler("onClientVehicleExit", root, function(plr, seat)
	if plr == localPlayer and seat == 0 then
		removeEventHandler("onClientPreRender", root, fuelCount)
	end
end)

function fuelCount(deltaTime)
	if not localPlayer.vehicle then
		return
	end
	local velocity = localPlayer.vehicle.velocity
	local speed = (velocity.x ^ 2 + velocity.y ^ 2 + velocity.z ^ 2)^(0.5)
	speed = speed * 180 -- kilometry na godzinę
	local vehInfo = localPlayer.vehicle:getData("vehInfo")
	local multiplier = (1 / 60 / 60 * (deltaTime / 1000))
	if speed <= 1 then
	elseif speed > 1 and speed <= 10 then
		vehInfo.fuel = vehInfo.fuel - (1 * multiplier)
	elseif speed > 10 and speed <= 30 then
		vehInfo.fuel = vehInfo.fuel - (2 * multiplier)
	elseif speed > 30 and speed <= 50 then
		vehInfo.fuel = vehInfo.fuel - (3 * multiplier)
	elseif speed > 50 and speed <= 70 then
		vehInfo.fuel = vehInfo.fuel - (4 * multiplier)
	elseif speed > 70 and speed <= 90 then
		vehInfo.fuel = vehInfo.fuel - (5 * multiplier)
	elseif speed > 90 and speed <= 120 then
		vehInfo.fuel = vehInfo.fuel - (6 * multiplier)
	elseif speed > 120 and speed <= 150 then
		vehInfo.fuel = vehInfo.fuel - (7 * multiplier)
	elseif speed > 150 then
		vehInfo.fuel = vehInfo.fuel - (8 * multiplier)
	end
	localPlayer.vehicle:setData("vehInfo", vehInfo)
end