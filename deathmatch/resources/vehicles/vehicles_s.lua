local db = exports.db

addCommandHandler("fixVeh", function(plr, cmd, UID)
	if not UID then
		if plr.vehicle then
			plr.vehicle:fix()
		end
	else
		veh = getVehicleByUID(tonumber(UID))
		veh:fix()
	end
end)

addCommandHandler("tpto", function(plr, cmd, UID)
	plr.position = getVehicleByUID(tonumber(UID)).position
end)

addCommandHandler("fuel", function(plr, cmd, UID, fuel)
	local veh = getVehicleByUID(tonumber(UID))
	local vehInfo = veh:getData("vehInfo")
	vehInfo.fuel = tonumber(fuel)
	veh:setData("vehInfo", vehInfo)
end)

addCommandHandler("flip", function(plr)
	plr.vehicle.rotation = Vector3(0, 0, 0)
end)

addCommandHandler("handling", function(plr, cmd, name, value)
	plr.vehicle:setHandling(name, value)
end)

addCommandHandler("model", function(plr, cmd, model)
	plr.vehicle.model = model
end)

addCommandHandler("flip", function(plr, cmd)
	plr.vehicle.rotation = Vector3(0, 0, 0)
end)

function spawnVehicle(UID)
	local vehInfo = db:fetch("SELECT * FROM `rp_vehicles` WHERE `UID`=?", UID)
	if not vehInfo then
		return false
	end
	vehInfo = vehInfo[1]
	local veh = Vehicle(vehInfo.model, vehInfo.parkX, vehInfo.parkY, vehInfo.parkZ,
		vehInfo.parkRX, vehInfo.parkRY, vehInfo.parkRZ,
		"LS "..vehInfo.UID, false)
	veh:setData("vehInfo", vehInfo)
	veh.health = vehInfo.health
	local vehColorsTemp = string.explode(vehInfo.color, ",")
	local vehColors = {}
	for i,v in ipairs(vehColorsTemp) do
		vehColors[i] = tonumber(v)
	end
	veh:setColor(unpack(vehColors))
	local panelStates = string.explode(vehInfo.panelStates, ",")
	for i,v in ipairs(panelStates) do
		veh:setPanelState(i-1, tonumber(v))
	end
	local doorStates = string.explode(vehInfo.doorStates, ",")
	for i,v in ipairs(doorStates) do
		veh:setDoorState(i-1, tonumber(v))
	end
	local wheelStates = string.explode(vehInfo.wheelStates, ",")
	veh:setWheelStates(tonumber(wheelStates[1]), tonumber(wheelStates[2]), tonumber(wheelStates[3]), tonumber(wheelStates[4]))
	veh.overrideLights = 1
	veh.locked = true
	veh:setData("vehicleEngine", false)
	-- hamulec ręczny
	veh:setData("handbrake", true)
	setTimer(function()
		veh.frozen = true
	end, 1000, 1)
	return true
end

function saveVehicle(UID)
	local veh = getVehicleByUID(UID)
	if not veh then return false end
	local vehInfo = veh:getData("vehInfo")
	if not vehInfo then return false end
	local vehicleColor = {}
	vehicleColor[1], vehicleColor[2], vehicleColor[3],
		vehicleColor[4], vehicleColor[5], vehicleColor[6],
		vehicleColor[7], vehicleColor[8], vehicleColor[9],
		vehicleColor[10], vehicleColor[11], vehicleColor[12] = veh:getColor(true)
	vehicleColor = table.concat(vehicleColor, ",")
	local panelStates = {}
	for i=0,6 do
		table.insert(panelStates, veh:getPanelState(i))
	end
	panelStates = table.concat(panelStates, ",")
	local doorStates = {}
	for i=0,5 do
		table.insert(doorStates, veh:getDoorState(i))
	end
	doorStates = table.concat(doorStates, ",")
	local wheelStates = {}
	wheelStates[1], wheelStates[2], wheelStates[3], wheelStates[4] = veh:getWheelStates()
	wheelStates = table.concat(wheelStates, ",")
	db:query([[UPDATE `rp_vehicles` SET `model`=?, 
		`health`=?, `panelStates`=?, `doorStates`=?, `wheelStates`=?, 
		`color`=?, `fuel`=?, `mileage`=?, 
		`ownerType`=?, `owner`=?, `parkX`=?, `parkY`=?, `parkZ`=?, 
		`parkRX`=?,`parkRY`=?,`parkRZ`=? WHERE `UID`=?]], 
		veh.model, veh.health, panelStates, doorStates, wheelStates, 
		vehicleColor, vehInfo.fuel, vehInfo.mileage, 
		vehInfo.ownerType, vehInfo.owner, vehInfo.parkX, vehInfo.parkY, vehInfo.parkZ,
		vehInfo.parkRX, vehInfo.parkRY, vehInfo.parkRZ, UID)
end

function unspawnVehicle(UID)
	saveVehicle(UID)
	local veh = getVehicleByUID(UID)
	veh:destroy()
end

function getVehicleByUID(UID)
	local vehicle = nil
	for i,v in ipairs(Element.getAllByType("vehicle")) do
		local vehInfo = v:getData("vehInfo")
		if vehInfo.UID == UID then
			return v
		end
	end
	return false
end

--[[addEventHandler("onResourceStart", resourceRoot, function()
	local vehicles = db:fetch("SELECT `UID` FROM `rp_vehicles`")
	for i,v in ipairs(vehicles) do
		spawnVehicle(v.UID)
	end
end)--]]

addEventHandler("onResourceStop", resourceRoot, function()
	for i,v in ipairs(Element.getAllByType("vehicle")) do
		local vehInfo = v:getData("vehInfo")
		saveVehicle(vehInfo.UID)
	end
end)

-- zapobiegamy eksplozji
addEventHandler("onVehicleDamage", root, function(loss)
	if source.health - loss < 300 then
		source.health = 300
		source:setData("vehicleEngine", false)
		source.engineState = false
	end
end)

-- hack na automatyczne włączanie silnika
addEventHandler("onVehicleEnter", root, function(player, seat, jacked)
	if seat == 0 then
		source.engineState = source:getData("vehicleEngine")
	end
end)

addEvent("toggleVehicleEngineByPlayer", true)
addEventHandler("toggleVehicleEngineByPlayer", root, function()
	if client.vehicle and client.vehicleSeat == 0 then
		if client.vehicle:getData("vehicleEngine") == true then
			client.vehicle:setData("vehicleEngine", false)
			client.vehicle.engineState = false
		else
			if client.vehicle.health <= 300 then
				return
			end
			client.vehicle:setData("vehicleEngine", true)
			client.vehicle.engineState = true
		end
	end
end)

addEvent("toggleVehicleLightsByPlayer", true)
addEventHandler("toggleVehicleLightsByPlayer", root, function()
	if client.vehicle and client.vehicleSeat == 0 then
		if client.vehicle.overrideLights == 1 then
			client.vehicle.overrideLights = 2
		elseif client.vehicle.overrideLights == 2 then
			client.vehicle.overrideLights = 1
		end
	end
end)

addEvent("toggleVehicleHandbrakeByPlayer", true)
addEventHandler("toggleVehicleHandbrakeByPlayer", root, function()
	if client.vehicle and client.vehicleSeat == 0 then
		client.vehicle:setData("handbrake", not client.vehicle:getData("handbrake"))
		client.vehicle.frozen = client.vehicle:getData("handbrake")
	end
end)

addEvent("spawnVehicleByPlayer", true)
addEventHandler("spawnVehicleByPlayer", root, function(UID)
	if not getVehicleByUID(tonumber(UID)) then
		exports.notifications:add(client, "Zespawnowałeś swój pojazd.", "info", 3000)
		spawnVehicle(tonumber(UID))
	else
		exports.notifications:add(client, "Odspawnowałeś swój pojazd.", "info", 3000)
		unspawnVehicle(tonumber(UID))
	end
end)

addEvent("findVehicleByPlayer", true)
addEventHandler("findVehicleByPlayer", root, function(UID)
	local veh = getVehicleByUID(tonumber(UID))
	if not veh then
		exports.notifications:add(client, "Nie możesz namierzyć tego pojazdu. Najpierw go zespawnuj.", "danger", 3000)
	end

	for i,v in ipairs(Element.getAllByType("blip")) do
		local vehInfo = v:getData("vehInfo")
		if vehInfo.UID == tonumber(UID) then
			v:destroy()
			return
		end
	end

	local blip = Blip(veh.position, 0, 2, 255, 0, 0, 255, 0, 99999, client)
	blip:setData("vehInfo", veh:getData("vehInfo"))
	exports.notifications:add(client, "Twój pojazd został zaznaczony na mapie.", "info", 3000)
end)

-- kilka funkcji

function Check(funcname, ...)
    local arg = {...}
 
    if (type(funcname) ~= "string") then
        error("Argument type mismatch at 'Check' ('funcname'). Expected 'string', got '"..type(funcname).."'.", 2)
    end
    if (#arg % 3 > 0) then
        error("Argument number mismatch at 'Check'. Expected #arg % 3 to be 0, but it is "..(#arg % 3)..".", 2)
    end
 
    for i=1, #arg-2, 3 do
        if (type(arg[i]) ~= "string" and type(arg[i]) ~= "table") then
            error("Argument type mismatch at 'Check' (arg #"..i.."). Expected 'string' or 'table', got '"..type(arg[i]).."'.", 2)
        elseif (type(arg[i+2]) ~= "string") then
            error("Argument type mismatch at 'Check' (arg #"..(i+2).."). Expected 'string', got '"..type(arg[i+2]).."'.", 2)
        end
 
        if (type(arg[i]) == "table") then
            local aType = type(arg[i+1])
            for _, pType in next, arg[i] do
                if (aType == pType) then
                    aType = nil
                    break
                end
            end
            if (aType) then
                error("Argument type mismatch at '"..funcname.."' ('"..arg[i+2].."'). Expected '"..table.concat(arg[i], "' or '").."', got '"..aType.."'.", 3)
            end
        elseif (type(arg[i+1]) ~= arg[i]) then
            error("Argument type mismatch at '"..funcname.."' ('"..arg[i+2].."'). Expected '"..arg[i].."', got '"..type(arg[i+1]).."'.", 3)
        end
    end
end

function string.explode(self, separator)
    Check("string.explode", "string", self, "ensemble", "string", separator, "separator")
 
    if (#self == 0) then return {} end
    if (#separator == 0) then return { self } end
 
    return loadstring("return {\""..self:gsub(separator, "\",\"").."\"}")()
end

function isVehicleOnRoof(vehicle)
        local rx,ry=getElementRotation(vehicle)
        if (rx>90 and rx<270) or (ry>90 and ry<270) then
                return true
        end
        return false
end