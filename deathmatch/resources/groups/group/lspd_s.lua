addCommandHandler("skuj", function(player, cmd, whoid)
	if not isOnDutyOfType(player, groupType.police) then
		exports.notifications:add(player, "Nie masz uprawnień do tej komendy!", "danger", 3000)
		return
	end
	if not whoid then
		exports.notifications:add(player, "Użyj: /skuj [id]", "info", 3000)
		return
	end
	local who = exports.playerUtils:getByID(tonumber(whoid))
	if not who then
		exports.notifications:add(player, "Podany gracz nie znajduje się w grze!", "danger", 3000)
		return
	end
	if getDistanceBetweenPoints3D(player.position, who.position) < 5 then
		if not who:getData("cuffedBy") then
			who:setData("cuffedBy", player)
			exports.notifications:add(player, string.format("Skułeś gracza %s(ID: %d)", 
				exports.playerUtils:formatName(who.name), who:getData("ID")), "info", 3000)
			exports.notifications:add(player, string.format("Zostałeś skuty przez gracza %s(ID: %d)", 
				exports.playerUtils:formatName(player.name), player:getData("ID")), "info", 3000)
		else
			who:setData("cuffedBy", nil)
			exports.notifications:add(player, string.format("Rozkułeś gracza %s(ID: %d)", 
				exports.playerUtils:formatName(who.name), who:getData("ID")), "info", 3000)
			exports.notifications:add(player, string.format("Zostałeś rozkuty przez gracza %s(ID: %d)", 
				exports.playerUtils:formatName(player.name), player:getData("ID")), "info", 3000)
		end
	end
end)