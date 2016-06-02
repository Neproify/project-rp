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
		end
	end
end)

addEvent("usePlayerItem", true)

function loadPlayerItems(player) -- reload?
	local charInfo = player:getData("charInfo")
	if not charInfo then
		return
	end
	local items = db:fetch("SELECT * FROM `rp_items` WHERE `ownerType`=1 AND `owner`=?", charInfo["UID"])
	player:setData("charItems", items)
	triggerClientEvent(player, "onPlayerItemsLoaded", root)
end

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