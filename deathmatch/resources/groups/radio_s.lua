addCommandHandler("r", function(player, cmd, ...)
	local msg = {...}
	msg = table.concat(msg, " ")
	local group = getPlayerGroup(player)
	if not group then
		exports.notifications:add(player, "Nie jesteś na duty żadnej grupy!", "danger", 3000)
		return
	end
	if #msg < 3 then
		exports.notifications:add(player, "Użyj: /r [tekst]", "danger", 3000)
		return
	end
	local players = getAllPlayersOfGroupOnDuty(group)
	for i,v in ipairs(players) do
		v:outputChat(exports.playerUtils:formatName(player.name) .. "(radio): " .. msg, 30, 30, 230, false)
	end
end)