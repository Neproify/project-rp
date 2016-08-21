local db = exports.db

addEvent("loadPlayerItems", true)
addEventHandler("loadPlayerItems", root, function()
	loadPlayerItems(client)
end)

addEvent("dropPlayerItem", true)
addEventHandler("dropPlayerItem", root, function(UID)
	if canUseItem(client, UID) then
		if isItemUsed(UID) then
			return
		end
		setItemOwnerType(UID, 2)
		setItemOwner(UID, 0)
		local pos = client.position
		setItemPosition(UID, pos.x, pos.y, pos.z - 0.9)
		loadPlayerItems(client)
		loadGroundItem(UID)
		local details = {}
		details[1] = UID
		details[2] = pos.x
		details[3] = pos.y
		details[4] = pos.z
		exports.logs:addLog(exports.logs:getLogTypes().itemDrop, client.ip, client:getData("globalInfo")["UID"], client:getData("charInfo")["UID"], details)
	end
end)

addEvent("pickItemByPlayer", true)
addEventHandler("pickItemByPlayer", root, function(UID)
	local itemInfo = getItemInfo(UID)
	local charInfo = client:getData("charInfo")
	if itemInfo.ownerType == 2 then
		local pos = client.position
		local pos2 = Vector3(itemInfo.posX, itemInfo.posY, itemInfo.posZ)
		if getDistanceBetweenPoints3D(pos, pos2) < 5 then
			local itemSphere = ColShape.Sphere(pos2, 3)
			local nearbyObjects = itemSphere:getElementsWithin("object")
			for i, v in ipairs(nearbyObjects) do
				if v:getData("itemInfo").UID == UID then
					v:destroy()
					break
				end
			end
			setItemOwnerType(UID, 1)
			setItemOwner(UID, charInfo.UID)
			loadPlayerItems(client)
			local details = {}
			details[1] = UID
			exports.logs:addLog(exports.logs:getLogTypes().itemPick, client.ip, client:getData("globalInfo")["UID"], client:getData("charInfo")["UID"], details)
		end
	end
end)

addEvent("usePlayerItem", true)
addEventHandler("usePlayerItem", root, function(UID, player)
	if not client then client = player end
	local charInfo = client:getData("charInfo")
	if not charInfo then
		return
	end
	if canUseItem(client, UID) then
		local details = {}
		local itemInfo = getItemInfo(UID)
		details[1] = UID
		exports.logs:addLog(exports.logs:getLogTypes().itemUse, client.ip, client:getData("globalInfo")["UID"], charInfo["UID"], details)
	end
end)

function loadPlayerItems(player) -- NOTE: Używać po zmianie zawartości ekwipunku gracza
	local charInfo = player:getData("charInfo")
	if not charInfo then
		return
	end
	local items = db:fetch("SELECT * FROM `rp_items` WHERE `ownerType`=1 AND `owner`=?", charInfo["UID"])
	if #items < 1 then
		items = nil
	end
	player:setData("charItems", items)
	triggerClientEvent(player, "onPlayerItemsLoaded", root)
end

addEventHandler("onCharacterSelected", root, function(player)
	loadPlayerItems(player)
end)

function canUseItem(player, UID)
	if not player or not UID then
		return false
	end
	local charInfo = player:getData("charInfo")
	if not charInfo then
		return false
	end
	local item = db:fetch("SELECT * FROM `rp_items` WHERE `ownerType`=1 AND `owner`=? AND `UID`=?", charInfo['UID'], UID)
	item = item[1] or nil
	if not item then
		return false
	end
	return true
end

function isOwnerOfItem(player, UID)
	return canUseItem(player, UID)
end

function givePlayerItemForPlayer(from, to, UID)
	if isItemUsed(UID) then
		triggerEvent("usePlayerItem", root, UID, from)
	end
	setItemOwner(UID, to:getData("charInfo")["UID"])
end