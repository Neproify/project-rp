addCommandHandler("agracz", function(player, cmd, arg1, arg2, arg3)
	if not hasPlayerAdminPermissionTo(player, adminPermissions.players) then
		exports.notifications:add(player, "Nie masz uprawnień administratora do zarządzania graczami!", "danger", 3000)
		return
	end

	if arg1 == "model" then
		if not arg2 or not arg3 then
			exports.notifications:add(player, "Użyj: /agracz model [ID gracza] [ID modelu]")
			return
		end
		local targetPlayer = exports.playerUtils:getByID(tonumber(arg2))
		if not targetPlayer then
			exports.notifications:add(player, "Nie znaleziono podanego gracza!", "danger")
			return
		end
		targetPlayer.model = arg3
		local charInfo = targetPlayer:getData("charInfo")
		charInfo.skin = arg3
		targetPlayer:setData("charInfo", charInfo)
		exports.notifications:add(player, "Zmieniłeś model gracza.")
		return
	end

	if arg1 == "hp" then
		if not arg2 or not arg3 then
			exports.notifications:add(player, "Użyj: /agracz hp [ID gracza] [ilość hp]")
			return
		end
		local targetPlayer = exports.playerUtils:getByID(tonumber(arg2))
		if not targetPlayer then
			exports.notifications:add(player, "Nie znaleziono podanego gracza!", "danger")
			return
		end
		targetPlayer.health = arg3
		exports.notifications:add(player, "Zmieniłeś ilość zdrowia gracza.")
		return
	end

	if arg1 == "unbw" then
		if not arg2 then
			exports.notifications:add(player, "Użyj: /agracz unbw [ID gracza]")
			return
		end
		local targetPlayer = exports.playerUtils:getByID(tonumber(arg2))
		if not targetPlayer then
			exports.notifications:add(player, "Nie znaleziono podanego gracza!", "danger")
			return
		end
		exports.bw:unBWPlayer(targetPlayer)
		exports.notifications:add(player, "Gracz znowu jest przytomny.")
		return
	end

	if arg1 == "money" then
		if not hasPlayerAdminPermissionTo(player, adminPermissions.money) then
			exports.notifications:add(player, "Nie masz uprawnień administratora do zarządzania pieniędzmi!", "danger", 3000)
			return
		end 

		if not arg2 or not arg3 then
			exports.notifications:add(player, "Użyj: /agracz money [ID gracza] [ilość kasy]")
			return
		end
		local targetPlayer = exports.playerUtils:getByID(tonumber(arg2))
		if not targetPlayer then
			exports.notifications:add(player, "Nie znaleziono podanego gracza!", "danger")
			return
		end
		targetPlayer.money = arg3
		exports.notifications:add(player, "Zmieniłeś ilość pieniędzy gracza.")
		return
	end

	exports.notifications:add(player, "Użyj: /agracz [model, hp, unbw, money]")
end)