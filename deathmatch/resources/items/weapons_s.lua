local db = exports.db

addEventHandler("usePlayerItem", root, function(UID, player)
	if not client then client = player end
	local charInfo = client:getData("charInfo")
	if not charInfo then
		return
	end
	if canUseItem(client, UID) then
		local itemInfo = getItemInfo(UID)
		if itemInfo.type == 1 then
			local properties = explodeProperties(itemInfo.properties)
			if itemInfo.used == 0 then
				if client:getWeapon(getSlotFromWeapon(properties[1])) == 0 then
					if client:getData("usingAmmoClip") and client:getData("usingAmmoClip") ~= 0 then
						local ammoClipInfo = getItemInfo(client:getData("usingAmmoClip"))
						if canUseItem(client, ammoClipInfo.UID) then
							local ammoClipProperties = explodeProperties(ammoClipInfo.properties)
							if ammoClipProperties[1] == properties[1] then
								properties[2] = tonumber(properties[2]) + tonumber(ammoClipProperties[2])
								updateItemProperties(UID, packProperties(properties))
								exports.notifications:add(client, "Uzupełniłeś magazynek w broni ".. itemInfo.name ..".", "info", 3000)
								exports.chat:outputMe(client, "uzupełnia magazynek w broni.")
								client:setData("usingAmmoClip", 0)
								deleteItem(ammoClipInfo.UID)
							end
						end
					end
					if tonumber(properties[2]) < 1 then
						exports.notifications:add(client, "Skończyła ci się amunicja. Nie możesz użyć tej broni!", "danger", 3000)
						return
					end
					client:giveWeapon(properties[1], properties[2], true)
					exports.chat:outputMe(client, "wyciąga ".. itemInfo.name .. ".")
					markItemAsUsed(UID, true)
				else
					exports.notifications:add(client, "Używasz już broni tego typu.", "danger", 3000)
				end
			else
				local properties = explodeProperties(itemInfo.properties)
				properties[2] = client:getTotalAmmo(getSlotFromWeapon(properties[1]))
				updateItemProperties(UID, packProperties(properties))
				client:takeWeapon(properties[1])
				exports.chat:outputMe(client, "chowa ".. itemInfo.name ..".")
				markItemAsUsed(UID, false)
			end
		elseif itemInfo.type == 2 then
			local properties = explodeProperties(itemInfo.properties)
			if itemInfo.used == 0 then
				local charItems = client:getData("charItems")
				for i,v in ipairs(charItems) do
					if v.type == 2 and v.used == true then
						markItemAsUsed(v.UID, false)
						client:setData("usingAmmoClip", 0)
					end
				end
				client:setData("usingAmmoClip", UID)
				markItemAsUsed(UID, true)
				exports.notifications:add(client, "Aby uzupełnić amunicję w broni wyciągnij ją z ekwipunku.", "info", 5000)
			else
				markItemAsUsed(UID, false)
				client:setData("usingAmmoClip", 0)
			end
		end
	end
end)

addEvent("onWeaponEndOfAmmo", true)
addEventHandler("onWeaponEndOfAmmo", root, function(weapon)
	local charInfo = client:getData("charInfo")
	local items = db:fetch("SELECT * FROM `rp_items` WHERE `ownertype`=1 AND `owner`=? AND `used`=1 AND `type`=1", charInfo.UID)
	for i,v in ipairs(items) do
		local properties = explodeProperties(v.properties)
		if tonumber(properties[1]) == weapon then
			properties[2] = 0
			updateItemProperties(v.UID, packProperties(properties))
			client:takeWeapon(properties[1])
			markItemAsUsed(v.UID, false)
			exports.notifications:add(client, "Nie masz już amunicji! Wymień magazynek.", "danger", 3000)
			break
		end
	end
end)