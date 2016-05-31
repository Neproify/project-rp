local db = exports.db

function loadBuildings()
	local buildings = db:fetch("SELECT * FROM `rp_buildings`")
	for i,v in ipairs(buildings) do
		local enterPickup = Pickup(v.enterX, v.enterY, v.enterZ, 3, 1239)
		addEventHandler("onPickupHit", enterPickup, function() cancelEvent() end)
		enterPickup.dimension = v.enterDimension
		enterPickup:setData("buildingInfo", v)

		local exitPickup = Pickup(v.exitX, v.exitY, v.exitZ, 3, 1239)
		addEventHandler("onPickupHit", exitPickup, function() cancelEvent() end)
		exitPickup.dimension = v.UID + 10000
		exitPickup:setData("buildingInfo", v)

		local objects = db:fetch("SELECT * FROM `rp_objects` WHERE `ownerType`=1 AND `owner`=?", v.UID)
		for i,v in ipairs(objects) do
			local object = Object(v.model, Vector3(v.posX, v.posY, v.posZ), Vector3(v.rotX, v.rotY, v.rotZ))
			object.dimension = v.owner + 10000
			object:setData("objectInfo", v)
		end
	end
end

addEvent("useDoor", true)
addEventHandler("useDoor", root, function(pickup)
	local buildingInfo = pickup:getData("buildingInfo")
		if client.dimension == buildingInfo.enterDimension then -- poza budynkiem
			client.position = Vector3(buildingInfo.exitX, buildingInfo.exitY, buildingInfo.exitZ)
			client.dimension = buildingInfo.UID + 10000
		else -- w budynku
			client.position = Vector3(buildingInfo.enterX, buildingInfo.enterY, buildingInfo.enterZ)
			client.dimension = buildingInfo.enterDimension
		end
end)

addEventHandler("onResourceStart", resourceRoot, function()
	loadBuildings()
end)