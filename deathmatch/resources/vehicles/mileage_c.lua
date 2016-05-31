addEventHandler("onClientVehicleEnter", root, function(plr, seat)
	if plr == localPlayer and seat == 0 then
		addEventHandler("onClientPreRender", root, mileageCount)
	end
end)

addEventHandler("onClientVehicleExit", root, function(plr, seat)
	if plr == localPlayer and seat == 0 then
		removeEventHandler("onClientPreRender", root, mileageCount)
	end
end)

function mileageCount(deltaTime)
	if not localPlayer.vehicle then
		return
	end
	local velocity = localPlayer.vehicle.velocity
	local speed = (velocity.x ^ 2 + velocity.y ^ 2 + velocity.z ^ 2)^(0.5)
	speed = speed * 180 -- kilometry na godzinę
	local vehInfo = localPlayer.vehicle:getData("vehInfo")
	vehInfo.mileage = vehInfo.mileage + (speed / 60 / 60 * (deltaTime / 1000))
	localPlayer.vehicle:setData("vehInfo", vehInfo)
end