addCommandHandler("pay", function(player, cmd, arg1, arg2)
	if not arg1 or not arg2 then
		exports.notifications:add(player, "Użyj: /pay [id] [kwota]", "info", 3000)
		return
	end
	local who = exports.playerUtils:getByID(tonumber(arg1))
	if not who then
		exports.notifications:add(player, "Podany gracz nie jest zalogowany!", "danger", 3000)
		return
	end
	local money = tonumber(arg2)
	if money < 0 or money > player.money then
		exports.notifications:add(player, "Nie masz tyle pieniędzy!", "danger", 3000)
		return
	end
	if(getDistanceBetweenPoints3D(player.position, who.position) > 5) then
		exports.notifications:add(player, "Jesteś za daleko od gracza!", "danger", 3000)
		return
	end
	player.money = player.money - money
	who.money = who.money + money
	exports.chat:me(player, "przekazuje pieniądze ".. exports.playerUtils:formatName(who.name) ..".")
end)