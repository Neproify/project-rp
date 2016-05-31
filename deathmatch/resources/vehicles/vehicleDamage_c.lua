-- wyłączanie uszkodzeń od pięści, odwalacze
addEventHandler("onClientVehicleDamage", root, function(attacker, weapon, loss, x, y, z, tyre)
	if weapon == 0 then
		cancelEvent()
		source:setDamageProof(true)
		setTimer(function(source)
			source:setDamageProof(false)
		end, 200, 1, source)
	end
end)