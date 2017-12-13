addCommandHandler("apomoc", function(player, cmd)
	if not isPlayerAdminLevelEqualOrMore(player, adminLevels.support) then
		return
	end
	output = "Dostępne komendy administracyjne: <br />"
	if hasPlayerAdminPermissionTo(player, adminPermissions.players) then
		output = output .. "/agracz <br />"
	end
	if hasPlayerAdminPermissionTo(player, adminPermissions.vehicles) then
		output = output .. "/apojazd <br />"
	end
	if hasPlayerAdminPermissionTo(player, adminPermissions.buildings) then
		output = output .. "/adrzwi <br />"
	end
	if hasPlayerAdminPermissionTo(player, adminPermissions.groups) then
		output = output .. "/agrupa <br />"
	end
	if hasPlayerAdminPermissionTo(player, adminPermissions.items) then
		output = output .. "/aprzedmiot <br />"
	end
	exports.notifications:add(player, output, "info", "10000")
end)