local db = exports.db
local ownerTypes = exports.core:getOwnerTypes()

addEvent("loadPlayerItems", true)
addEventHandler("loadPlayerItems", root, function()
	loadPlayerItems(client)
end)

addEvent("dropPlayerItem", true)
addEventHandler("dropPlayerItem", root, function(item)
	if canUseItem(client, item) then
		local itemInfo = item:getData("itemInfo")
		if itemInfo.used == true then
			return
		end
		local charInfo = client:getData("charInfo")
		itemInfo.ownerType = ownerTypes.world
		itemInfo.owner = 0
		itemInfo.posX = client.position.x
		itemInfo.posY = client.position.y
		itemInfo.posZ = client.position.z - 0.9
		item:setData("itemInfo", itemInfo)
		for i,v in ipairs(itemsOwnedBy[ownerTypes.character][charInfo.UID]) do
			if v == item then
				table.remove(itemsOwnedBy[ownerTypes.character][charInfo.UID], i)
				break
			end
		end
		saveItem(item)
		loadItem(itemInfo.UID)
		loadPlayerItems(client)
		local details = {}
		details[1] = itemInfo.UID
		details[2] = client.position.x
		details[3] = client.position.y
		details[4] = client.position.z
		exports.logs:addLog(exports.logs:getLogTypes().itemDrop, client.ip, client:getData("globalInfo")["UID"], client:getData("charInfo")["UID"], details)
	end
end)

addEvent("pickItemByPlayer", true)
addEventHandler("pickItemByPlayer", root, function(item)
	local itemInfo = item:getData("itemInfo")
	local charInfo = client:getData("charInfo")
	if itemInfo.ownerType == ownerTypes.world then
		local pos = client.position
		local pos2 = Vector3(itemInfo.posX, itemInfo.posY, itemInfo.posZ)
		if getDistanceBetweenPoints3D(pos, pos2) < 5 then
			local itemSphere = ColShape.Sphere(pos2, 3)
			local groundObject = item:getData("groundObject")
			groundObject:destroy()
			itemInfo.ownerType = ownerTypes.character
			itemInfo.owner = charInfo.UID
			for i,v in ipairs(itemsOwnedBy[2][0]) do
				if v == item then
					table.remove(itemsOwnedBy[2][0], i)
					break
				end
			end
			item:setData("itemInfo", itemInfo)
			saveItem(item)
			loadItem(itemInfo.UID)
			loadPlayerItems(client)
			local details = {}
			details[1] = UID
			exports.logs:addLog(exports.logs:getLogTypes().itemPick, client.ip, client:getData("globalInfo")["UID"], client:getData("charInfo")["UID"], details)
		end
	end
end)

addEvent("usePlayerItem", true)
addEventHandler("usePlayerItem", root, function(item, player)
	if not client then client = player end
	local charInfo = client:getData("charInfo")
	if not charInfo then
		return
	end
	if canUseItem(client, item) then
		local details = {}
		local itemInfo = item:getData("itemInfo")
		details[1] = itemInfo.UID
		exports.logs:addLog(exports.logs:getLogTypes().itemUse, client.ip, client:getData("globalInfo")["UID"], charInfo["UID"], details)
	end
end)

function loadPlayerItems(player) -- NOTE: Używać po zmianie zawartości ekwipunku gracza
	local charInfo = player:getData("charInfo")
	if not charInfo then
		return
	end
	local items = itemsOwnedBy[1][charInfo.UID]
	if not items or #items == 0 then
		items = nil
	end
	player:setData("charItems", items)
	triggerClientEvent(player, "onPlayerItemsLoaded", root)
end

addEventHandler("onCharacterSelected", root, function(player)
	loadPlayerItems(player)
end)

function canUseItem(player, item)
	if not player or not item then
		return false
	end
	local charInfo = player:getData("charInfo")
	if not charInfo then
		return false
	end
	local itemInfo = item:getData("itemInfo")
	if itemInfo.ownerType == ownerTypes.character and itemInfo.owner == charInfo.UID then
		return true
	end
	return false
end

-- function givePlayerItemForPlayer(from, to, UID)
-- 	if isItemUsed(UID) then
-- 		triggerEvent("usePlayerItem", root, UID, from)
-- 	end
-- 	setItemOwner(UID, to:getData("charInfo")["UID"])
-- end

function givePlayerItemForPlayer(from, to, item)
	if not item then
		return
	end

	local itemInfo = item:getData("itemInfo")
	if not itemInfo then
		return
	end

	if itemInfo.ownerType ~= ownerTypes.character or itemInfo.owner ~= from:getData("charInfo").UID then
		return
	end

	if itemInfo.used == true then
		triggerEvent("usePlayerItem", root, item, from)
		return givePlayerItemForPlayer(from, to, item)
	end

	itemInfo.owner = to:getData("charInfo").UID
	item:setData("itemInfo", itemInfo)
	for i,v in ipairs(itemsOwnedBy[ownerTypes.character][from:getData("charInfo").UID]) do
		if v == item then
			table.remove(itemsOwnedBy[ownerTypes.character][from:getData("charInfo").UID], i)
			break
		end
	end
	saveItem(item)
	loadItem(itemInfo.UID)
	loadPlayerItems(from)
	loadPlayerItems(to)
end