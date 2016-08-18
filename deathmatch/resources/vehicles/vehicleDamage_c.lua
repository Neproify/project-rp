-- wyłączanie uszkodzeń od pięści, odwalacze
addEventHandler("onClientVehicleDamage", root, function(attacker, weapon, loss, x, y, z, tyre)
	if weapon == 0 then
		cancelEvent()
	end
end)