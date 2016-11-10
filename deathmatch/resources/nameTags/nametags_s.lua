addCommandHandler("opis", function(player, cmd, ...)
	local description = {...}
	description = table.concat(description, " ")
	if description == "usun" then
		player:setData("description", nil)
		exports.notifications:add(player, "Usunąłeś opis.")
		return
	end
	player:setData("description", description)
	exports.notifications:add(player, string.format("Ustawiłeś opis na: \"%s\". Aby usunąć wpisz: /opis usun.", description))
end)