addEventHandler("onResourceStart", resourceRoot, function()
	root:setData("newsText", "Trwa blok reklamowy...")
end)

addCommandHandler("news", function(player, cmd, ...)
	local msg = {...}
	msg = table.concat(msg, " ")
	if not isOnDutyOfType(player, groupType.news) then
		exports.notifications:add(player, "Nie masz uprawnień do tej komendy!", "danger", 3000)
		return
	end
	if #msg < 3 then
		exports.notifications:add(player, "Użyj: /news [tekst]", "info", 3000)
		return
	end
	local text = exports.playerUtils:formatName(player.name) .. ": " .. msg
	root:setData("newsText", text)
end)

addCommandHandler("clearnews", function(player, cmd)
	if not isOnDutyOfType(player, groupType.news) then
		exports.notifications:add(player, "Nie masz uprawnień do tej komendy!", "danger", 3000)
		return
	end
	root:setData("newsText", "Trwa blok reklamowy...")
end)