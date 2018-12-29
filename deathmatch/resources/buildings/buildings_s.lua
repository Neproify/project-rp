local db = exports.db

function loadBuildings()
	local buildings = db:fetch("SELECT * FROM `rp_buildings`")
	for i,v in ipairs(buildings) do
		local building = Element("building", "building-".. v.UID)

		local enterPickup = Pickup(Vector3(v.enterX, v.enterY, v.enterZ), 3, 1239)
		addEventHandler("onPickupHit", enterPickup, function() cancelEvent() end)
		enterPickup.dimension = v.enterDimension
		enterPickup:setData("building", building)
		building:setData("enterPickup", enterPickup)

		local exitPickup = Pickup(Vector3(v.exitX, v.exitY, v.exitZ), 3, 1239)
		addEventHandler("onPickupHit", exitPickup, function() cancelEvent() end)
		exitPickup.dimension = v.UID + 10000
		exitPickup:setData("building", building)
		building:setData("exitPickup", exitPickup)

		building:setData("locked", true)

		building:setData("buildingInfo", v)

		local objects = db:fetch("SELECT * FROM `rp_objects` WHERE `ownerType`=1 AND `owner`=?", v.UID)
		for i,v in ipairs(objects) do
			local object = Object(v.model, Vector3(v.posX, v.posY, v.posZ), Vector3(v.rotX, v.rotY, v.rotZ))
			object.dimension = v.owner + 10000
			object:setData("objectInfo", v)
		end
	end
end

function getBuildingNearbyToPlayer(player)
	local sphere = ColShape.Sphere(player.position, 3)
	local pickupsInSphere = sphere:getElementsWithin("pickup")
	for i,v in ipairs(pickupsInSphere) do
		if v.dimension == player.dimension then
			local building = v:getData("building")
			if building then
				return building
			end
		end
	end
	return nil
end

function havePlayerPermissionToOpenBuilding(player, building)
	local buildingInfo = building:getData("buildingInfo")
	if not buildingInfo then return false end
	local charInfo = player:getData("charInfo")
	if buildingInfo.ownerType == 1 and buildingInfo.owner == charInfo.UID then
		return true
	end
	if buildingInfo.ownerType == 2 then
		local groupDutyInfo = player:getData("groupDutyInfo")
		if groupDutyInfo then
			if buildingInfo.owner == groupDutyInfo.UID then
				return true
			end
		end
	end
	return false
end

function havePlayerPermissionToEditBuilding(player, building)
	local buildingInfo = building:getData("buildingInfo")
	if not buildingInfo then return false end
	local charInfo = player:getData("charInfo")
	if buildingInfo.ownerType == 1 and buildingInfo.owner == charInfo.UID then
		return true
	end
	return false
end

function getPlayerCurrentBuilding(player)
	local building = player:getData("inBuilding")
	if building then
		local buildingInfo = building:getData("buildingInfo")
		if buildingInfo.UID + 10000 == player.dimension then
			return building
		end
	end
	return nil
end

addEvent("useDoor", true)
addEventHandler("useDoor", root, function(pickup)
	local building = pickup:getData("building")
	if building:getData("locked") == true then
		exports.notifications:add(client, "Te drzwi są zamknięte!", "danger", 3000)
		return
	end
	local charInfo = client:getData("charInfo")
	if charInfo.jailBuilding then
		exports.notifications:add(client, "Jesteś przetrzymywany w budynku. Nie możesz wyjść.", "danger", 5000)
		return
	end
	if pickup == building:getData("enterPickup") then -- poza budynkiem
		client.position = building:getData("exitPickup").position
		client.dimension = building:getData("exitPickup").dimension
		client:setData("inBuilding", building)
	else -- w budynku
		client.position = building:getData("enterPickup").position
		client.dimension = building:getData("enterPickup").dimension
		client:setData("inBuilding", nil)
	end
end)

addEventHandler("onResourceStart", resourceRoot, function()
	loadBuildings()
end)

addEvent("saveBuildingEdit", true)
addEventHandler("saveBuildingEdit", root, function(building, name, description)
	if not building or not name or not description then return end
	if not havePlayerPermissionToEditBuilding(client, building) then
		exports.notifications:add(client, "Nie możesz edytować tych drzwi!", "danger", 3000)
		return
	end

	local buildingInfo = building:getData("buildingInfo")
	buildingInfo.name = name
	buildingInfo.description = description
	building:setData("buildingInfo", buildingInfo)
	exports.notifications:add(client, "Zmieniłeś ustawienia budynku.")
end)

addCommandHandler("drzwi", function(player, cmd, arg1)
	if arg1 == "zamknij" then
		local building = getBuildingNearbyToPlayer(player)
		if not building then
			exports.notifications:add(player, "W pobliżu nie ma żadnych drzwi!", "danger", 3000)
			return
		end
		if not havePlayerPermissionToOpenBuilding(player, building) then
			exports.notifications:add(player, "Nie masz klucza do tych drzwi!", "danger", 3000)
			return
		end
		if building:getData("locked") then
			building:setData("locked", false)
			exports.notifications:add(player, "Otworzyłeś drzwi.")
		else
			building:setData("locked", true)
			exports.notifications:add(player, "Zamknąłeś drzwi.")
		end
		return
	end
	if arg1 == "opcje" then
		local building = getBuildingNearbyToPlayer(player)
		if not building then
			exports.notifications:add(player, "W pobliżu nie ma żadnych drzwi!", "danger", 3000)
			return
		end
		if not havePlayerPermissionToEditBuilding(player, building) then
			exports.notifications:add(player, "Nie możesz edytować tych drzwi!", "danger", 3000)
			return
		end
		triggerClientEvent(player, "openBuildingEditMenu", root, building)
		return
	end
	exports.notifications:add(player, "Użyj: /drzwi [zamknij, opcje]")
	return
end)