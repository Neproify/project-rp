local db = exports.db
local ownerTypes = exports.core:getOwnerTypes()

addEventHandler("usePlayerItem", root, function(item, player)
	if not client then client = player end
	local charInfo = client:getData("charInfo")
	if not charInfo then
		return
	end
	if canUseItem(client, item) then
		local itemInfo = item:getData("itemInfo")
		if itemInfo.type == 1 then
			if itemInfo.used == false then
				if client:getWeapon(getSlotFromWeapon(itemInfo.properties[1])) == 0 then
					local ammoClip = nil
					for i,v in ipairs(itemsOwnedBy[ownerTypes.character][charInfo.UID]) do
						local vItemInfo = v:getData("itemInfo")
						if vItemInfo.type == 2 and vItemInfo.used == true and vItemInfo.properties[1] == itemInfo.properties[1] then
							ammoClip = v
						end
					end
					if ammoClip then
						local ammoClipInfo = ammoClip:getData("itemInfo")
						if canUseItem(client, ammoClip) then
							if ammoClipInfo.properties[1] == itemInfo.properties[1] then
								itemInfo.properties[2] = tonumber(itemInfo.properties[2]) + tonumber(ammoClipInfo.properties[2])
								item:setData("itemInfo", itemInfo)
								exports.notifications:add(client, "Uzupełniłeś magazynek w broni ".. itemInfo.name ..".", "info", 3000)
								exports.chat:outputMe(client, "uzupełnia magazynek w broni.")
								client:setData("usingAmmoClip", 0)
								deleteItem(ammoClip)
								loadPlayerItems(client)
							end
						end
					end
					if tonumber(itemInfo.properties[2]) < 1 then
						exports.notifications:add(client, "Skończyła ci się amunicja. Nie możesz użyć tej broni!", "danger", 3000)
						return
					end
					client:giveWeapon(itemInfo.properties[1], itemInfo.properties[2], true)
					exports.chat:outputMe(client, "wyciąga ".. itemInfo.name .. ".")
					itemInfo.used = true
					item:setData("itemInfo", itemInfo)
				else
					exports.notifications:add(client, "Używasz już broni tego typu.", "danger", 3000)
				end
			else
				itemInfo.properties[2] = client:getTotalAmmo(getSlotFromWeapon(itemInfo.properties[1]))
				client:takeWeapon(itemInfo.properties[1])
				exports.chat:outputMe(client, "chowa ".. itemInfo.name ..".")
				itemInfo.used = false
				item:setData("itemInfo", itemInfo)
			end
		elseif itemInfo.type == 2 then
			if itemInfo.used == false then
				for i,v in ipairs(itemsOwnedBy[1][charInfo.UID]) do
					local vItemInfo = v:getData("itemInfo")
					if vItemInfo.type == 2 and vItemInfo.used == true then
						vItemInfo.used = false
						v:setData("itemInfo", vItemInfo)
					end
				end
				itemInfo.used = true
				item:setData("itemInfo", itemInfo)
				exports.notifications:add(client, "Aby uzupełnić amunicję w broni wyciągnij ją z ekwipunku.", "info", 5000)
			else
				itemInfo.used = false
				item:setData("itemInfo", itemInfo)
			end
		end
	end
end)

addEvent("onWeaponEndOfAmmo", true)
addEventHandler("onWeaponEndOfAmmo", root, function(weapon)
	local charInfo = client:getData("charInfo")
	for i,v in ipairs(itemsOwnedBy[1][charInfo.UID]) do
		local itemInfo = v:getData("itemInfo")
		if itemInfo.properties[1] == weapon then
			itemInfo.properties[2] = 0
			itemInfo.used = false
			client:takeWeapon(itemInfo.properties[1])
			v:setData("itemInfo", itemInfo)
			exports.notifications:add(client, "Nie masz już amunicji! Wymień magazynek.", "danger", 3000)
			break
		end
	end
end)