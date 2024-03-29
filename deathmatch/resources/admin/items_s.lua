local db = exports.db
local ownerTypes = exports.core:getOwnerTypes()

addCommandHandler("aprzedmiot", function(player, cmd, arg1, ...)
	if not hasPlayerAdminPermissionTo(player, adminPermissions.items) then
		exports.notifications:add(player, "Nie masz uprawnień administratora do zarządzania przedmiotami!", "danger", 3000)
		return
	end

	if arg1 == "stworz" then
		if not {...} then
			exports.notifications:add(player, "Użyj: /aprzedmiot stworz [nazwa]")
			return
		end
		local item = exports.items:createItem(table.concat({...}, " "), 0, 0, 0, {})
		exports.notifications:add(player, "Stworzyłeś przedmiot. Jego UID to: ".. item:getData("itemInfo")["UID"] ..".", "info", 10000)
		return
	end

	if arg1 == "wlasciciel" then
		if #{...} ~= 3 then
			exports.notifications:add(player, "Użyj: /aprzedmiot wlasciciel [UID przedmiotu] [nikt, gracz, swiat] [UID właściciela]")
			return
		end
		local args = {...}
		local item = Element.getByID("item-".. args[1])
		local ownerType = 0
		
		if args[2] == "nikt" then ownerType = ownerTypes.none
		elseif args[2] == "gracz" then ownerType = ownerTypes.character
		elseif args[2] == "swiat" then ownerType = ownerTypes.world
		end

		local owner = args[3]
		exports.items:setItemOwner(item, ownerType, owner)
		exports.notifications:add(player, "Zmieniłeś właściciela przedmiotu ".. args[1] .. ".")
		return
	end

	if arg1 == "nazwa" then
		if #{...} < 2 then
			exports.notifications:add(player, "Użyj: /aprzedmiot nazwa [UID przedmiotu] [nazwa]")
			return
		end
		local args = {...}
		local item = Element.getByID("item-".. args[1])
		local name = table.concat(args, " ", 2)
		exports.items:setItemName(item, name)
		exports.notifications:add(player, "Zmieniłeś nazwę przedmiotu ".. args[1] .. " na: " .. name .. ".")
		return
	end

	if arg1 == "typ" then
		if #{...} ~= 2 then
			exports.notifications:add(player, "Użyj: /aprzedmiot typ [UID przedmiotu] [typ]")
			return
		end
		local args = {...}
		local item = Element.getByID("item-".. args[1])
		local itemType = tonumber(args[2])
		exports.items:setItemType(item, itemType)
		exports.notifications:add(player, "Zmieniłeś typ przedmiotu ".. args[1] .. " na: " .. itemType .. ".")
		return
	end

	if arg1 == "wlasciwosci" then
		if #{...} < 2 then
			exports.notifications:add(player, "Użyj: /aprzedmiot wlasciwosci [UID przedmiotu] [wlasciwosci...]")
			return
		end
		local args = {...}
		local item = Element.getByID("item-".. args[1])
		local itemID = args[1]
		table.remove(args, 1) -- hacky
		local itemProperties = args
		exports.items:setItemProperties(item, itemProperties)
		exports.notifications:add(player, "Zmieniłeś wlasciwosci przedmiotu ".. itemID .. " na: " .. exports.items:packProperties(itemProperties) .. ".")
		return
	end

	exports.notifications:add(player, "Użyj: /aprzedmiot [stworz, wlasciciel, nazwa, typ, wlasciwosci]")
end)