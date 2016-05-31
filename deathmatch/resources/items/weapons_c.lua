addEventHandler("onClientPlayerWeaponFire", localPlayer, function(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
	if ammo == 0 then
		triggerServerEvent("onWeaponEndOfAmmo", localPlayer, weapon)
	end
end)