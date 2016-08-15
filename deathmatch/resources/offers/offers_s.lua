--[[
	Typy ofert:
	1 - przedmiot
	2 - naprawa
	3 - lakierowanie
	4 - leczenie
--]]

addCommandHandler("o", function(player, cmd, arg1, arg2, arg3, arg4, arg5, arg6)
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
		elseif offerInfo.type == 2 then
			if offerInfo.to.money < offerInfo.price then
				return
			end
			
			if not offerInfo.to.vehicle then
				return
			end
			
			offerInfo.to.vehicle:fix()
			
			offerInfo.from.money = offerInfo.from.money + offerInfo.price
			offerInfo.to.money = offerInfo.to.money - offerInfo.price
		elseif offerInfo.type == 3 then
			if offerInfo.to.money < offerInfo.price then
				return
			end
			
			if not offerInfo.to.vehicle then
				return
			end
			
			offerInfo.to.vehicle:setColor(offerInfo.red, offerInfo.green, offerInfo.blue)
			
			offerInfo.from.money = offerInfo.from.money + offerInfo.price
			offerInfo.to.money = offerInfo.to.money - offerInfo.price
		elseif offerInfo.type == 4 then
			offerInfo.to.health = 100
		elseif offerInfo.type == 5 then
			if offerInfo.to.money < offerInfo.price then
				return
			end
			local group = exports.groups:getPlayerGroup(offerInfo.from)
			exports.groups:giveMoneyForGroup(group, offerInfo.price)
			offerInfo.to.money = offerInfo.to.money - offerInfo.price
		end
		exports.notifications:add(offerInfo.from, string.format("%s zaakceptował ofertę.", 
			exports.playerUtils:formatName(offerInfo.to.name)), "info", 3000)
		exports.notifications:add(offerInfo.from, string.format("Zaakceptowałeś ofertę od %s.", 
			exports.playerUtils:formatName(offerInfo.from.name)), "info", 3000)
		return
	end
	if arg1 == "anuluj" then
		 local offerInfo = player:getData("offerInfo")
		 if not offerInfo then return end
		 exports.notifications:add(offerInfo.from, string.format("%s anulował ofertę.", 
			exports.playerUtils:formatName(player.name)), "info", 3000)
		 exports.notifications:add(offerInfo.to, string.format("%s anulował ofertę.", 
			exports.playerUtils:formatName(player.name)), "info", 3000)
		 offerInfo.from:setData("offerInfo", nil)
		 offerInfo.to:setData("offerInfo", nil)
		 return
	end
	if not arg1 or not arg2 then
		exports.notifications:add(player, "Użyj: /o(feruj) [id] [przedmiot, naprawa, lakierowanie, leczenie, mandat]", "info", 5000)
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
		
		offerInfo.type = 1
		offerInfo.itemUID = tonumber(arg3)
		offerInfo.price = tonumber(arg4)
	elseif arg2 == "naprawa" then
		if not arg3 then
			exports.notifications:add(player, "Użyj: /o(feruj) ".. arg1 .." naprawa [cena]")
			return
		end
		
		if not exports.groups:isOnDutyOfType(player, exports.groups:getGroupTypes().workshop) then
			exports.notifications:add(player, "Nie pracujesz w warsztacie!", "danger", 3000)
			return
		end
		
		offerInfo.type = 2
		offerInfo.price = tonumber(arg3)
	elseif arg2 == "lakierowanie" then
		 if not arg3 and not arg4 and not arg5 and not arg6 then
		 	exports.notifications:add(player, "Użyj: /o(feruj) ".. arg1 .." lakierowanie [cena] [czerwony] [zielony] [niebieski]")
		 	return
		end
		
		if not exports.groups:isOnDutyOfType(player, 5) then
			exports.notifications:add(player, "Nie pracujesz w warsztacie!", "danger", 3000)
			return
		end
		
		offerInfo.type = 3
		offerInfo.price = tonumber(arg3)
		offerInfo.red = tonumber(arg4)
		offerInfo.green = tonumber(arg5)
		offerInfo.blue = tonumber(arg6)
	elseif arg2 == "leczenie" then
		if not exports.groups:isOnDutyOfType(player, exports.groups:getGroupTypes().emergency) then
			exports.notifications:add(player, "Nie pracujesz w szpitalu!", "danger", 3000)
			return
		end
		offerInfo.type = 4
		offerInfo.price = 0
	elseif arg2 == "mandat" then
		if not exports.groups:isOnDutyOfType(player, exports.groups:getGroupTypes().police) then
			exports.notifications:add(player, "Nie pracujesz w policji!", "danger", 3000)
			return
		end
		if not arg3 then
			exports.notifications:add(player, "Użyj: /o(feruj) ".. arg1 .." mandat [cena]")
			return
		end
		offerInfo.type = 5
		offerInfo.price = tonumber(arg3)
	end
	
	if not offerInfo then return end
	
	if offerInfo.price < 0 then
		return
	end
	
	offerInfo.from = player
	offerInfo.to = secondPlayer
	
	player:setData("offerInfo", offerInfo)
	secondPlayer:setData("offerInfo", offerInfo)
		
	exports.notifications:add(player, "Wysłałeś ofertę(cena: $".. offerInfo.price .. ") do ".. exports.playerUtils:formatName(secondPlayer.name), "info", 5000)
	
	triggerClientEvent(secondPlayer, "onOffer", root)
end)