--[[
	Typy ofert:
	1 - przedmiot
--]]

addCommandHandler("o", function(player, cmd, arg1, arg2, arg3, arg4)
	if arg1 == "akceptuj" then
		local offerInfo = player:getData("offerInfo")
		if not offerInfo then return end
		if getDistanceBetweenPoints3D(offerInfo.from.position, offerInfo.to.position) >= 5 then
			exports.notifications:add(player, "Jesteś za daleko, nie możesz zaakceptować oferty!", "danger", 3000)
			return
		end
		if offerInfo.type == 1 then
			if offerInfo.to.money < offerInfo.price then
				return
			end
			offerInfo.from.money = offerInfo.from.money + offerInfo.price
			offerInfo.to.money = offerInfo.to.money - offerInfo.price
			exports.items:givePlayerItemForPlayer(offerInfo.from, offerInfo.to, offerInfo.itemUID)
		end
		return
	end
	if arg1 == "anuluj" then
		 local offerInfo = player:getData("offerInfo")
		 if not offerInfo then return end
		 offerInfo.from:setData("offerInfo", nil)
		 offerInfo.to:setData("offerInfo", nil)
		 return
	end
	if not arg1 and not arg2 then
		exports.notifications:add(player, "Użyj: /o(feruj) [id] [przedmiot]", "info", 5000)
    	return
	end
	local charInfo = player:getData("charInfo")
	if not charInfo then
		return
	end
	local secondPlayer = exports.playerUtils:getByID(tonumber(arg1))
	if not secondPlayer then
		exports.notifications:add(player, "Gracz nie jest w grze!", "danger", 3000)
		return
	end
	
	if getDistanceBetweenPoints3D(player.position, secondPlayer.position) >= 5 then
		exports.notifications:add(player, "Jesteś za daleko, nie możesz nic zaoferować!", "danger", 3000)
		return
	end
	
	local offerInfo = {}
	
	if arg2 == "przedmiot" then
		if not arg3 and not arg4 then
			exports.notifications:add(player, "Użyj: /o(feruj) ".. arg1 .." przedmiot [UID] [cena]")
			return
		end
		
		if not exports.items:isOwnerOfItem(player, tonumber(arg3)) then
			exports.notifications:add(player, "Nie możesz dać komuś przedmiotu którego nie masz przy sobie!", "danger", 3000)
			return
		end
		
		offerInfo.from = player
		offerInfo.to = secondPlayer
		offerInfo.type = 1
		offerInfo.itemUID = tonumber(arg3)
		offerInfo.price = tonumber(arg4)
		
		if offerInfo.price < 0 then
			return
		end
	end
	
	if not offerInfo then return end
	
	player:setData("offerInfo", offerInfo)
	secondPlayer:setData("offerInfo", offerInfo)
		
	exports.notifications:add(player, "Wysłałeś ofertę(cena: $".. tonumber(arg4) .. ") do ".. exports.playerUtils:formatName(secondPlayer.name), "info", 5000)
	
	triggerClientEvent(secondPlayer, "onOffer", root)
end)