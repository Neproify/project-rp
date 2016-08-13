addCommandHandler("m", function(player, cmd, ...)
	if not havePlayerGroupSpecialPermission(player, groupSpecialPermission.megaphone) then
		exports.notifications:add(player, "Nie masz uprawnień do tej komendy!", "danger", 3000)
		return
	end
	local text = table.concat({...}, " ")
	if #text < 3 then
		exports.notifications:add(player, "Użyj: /m [tekst]", "info", 3000)
		return
	end
	local chatSphere = ColShape.Sphere(player.position, 50)
	local nearbyPlayers = chatSphere:getElementsWithin("player")
	for i,v in ipairs(nearbyPlayers) do
		outputChatBox(string.format(">> %s: %s", exports.playerUtils:formatName(player.name), 
			text), v, 255, 255, 0)
	end
end)