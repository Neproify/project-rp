local db = exports.db
local ownerTypes = exports.core:getOwnerTypes()

addCommandHandler("apojazd", function(player, cmd, arg1, arg2, arg3, arg4, arg5, ...)
	if not hasPlayerAdminPermissionTo(player, adminPermissions.vehicles) then
		exports.notifications:add(player, "Nie masz uprawnień administratora do zarządzania pojazdami!", "danger", 3000)
		return
	end

	if arg1 == "stworz" then
		_, _, insertedID = db:fetch("INSERT INTO `rp_vehicles` (`model`) VALUES ('400');")
		exports.notifications:add(player, "Stworzyłeś pojazd. Jego UID to: ".. insertedID ..".", "info", 10000)
		return
	end

	if arg1 == "spawn" then
		if not arg2 then
			exports.notifications:add(player, "Użyj: /apojazd spawn [UID]")
			return
		end
		local vehicle = Element.getByID("vehicle-"..arg2)
		if vehicle then
			exports.notifications:add(player, "Podany pojazd jest już zespawnowany!", "danger")
			return
		end
		exports.vehicles:spawnVehicle(arg2)
		exports.notifications:add(player, "Zespawnowałeś pojazd.")
		return
	end

	if arg1 == "unspawn" then
		if not arg2 then
			exports.notifications:add(player, "Użyj: /apojazd unspawn [UID]")
			return
		end
		local vehicle = Element.getByID("vehicle-"..arg2)
		if not vehicle then
			exports.notifications:add(player, "Podany pojazd nie jest zespawnowany!", "danger")
			return
		end
		exports.vehicles:unspawnVehicle(arg2)
		exports.notifications:add(player, "Odspawnowałeś pojazd.")
		return
	end

	if arg1 == "napraw" then
		if not arg2 then
			exports.notifications:add(player, "Użyj: /apojazd napraw [UID]")
			return
		end
		local vehicle = Element.getByID("vehicle-"..arg2)
		if not vehicle then
			exports.notifications:add(player, "Podany pojazd nie jest zespawnowany!", "danger")
			return
		end
		vehicle:fix()
		exports.notifications:add(player, "Naprawiłeś pojazd")
		return
	end

	if arg1 == "hp" then
		if not arg2 or not arg3 then
			exports.notifications:add(player, "Użyj: /apojazd hp [UID] [hp]")
			return
		end
		local vehicle = Element.getByID("vehicle-"..arg2)
		if not vehicle then
			exports.notifications:add(player, "Podany pojazd nie jest zespawnowany!", "danger")
			return
		end
		vehicle.health = arg3
		exports.notifications:add(player, "Zmieniłeś hp pojazdu.")
		return
	end

	if arg1 == "otworz" then
		if not arg2 then
			exports.notifications:add(player, "Użyj: /apojazd otworz [UID]")
			return
		end
		local vehicle = Element.getByID("vehicle-"..arg2)
		if not vehicle then
			exports.notifications:add(player, "Podany pojazd nie jest zespawnowany!", "danger")
			return
		end
		vehicle.locked = false
		exports.notifications:add(player, "Otworzyłeś pojazd.")
		return
	end

	if arg1 == "zamknij" then
		if not arg2 then
			exports.notifications:add(player, "Użyj: /apojazd zamknij [UID]")
			return
		end
		local vehicle = Element.getByID("vehicle-"..arg2)
		if not vehicle then
			exports.notifications:add(player, "Podany pojazd nie jest zespawnowany!", "danger")
			return
		end
		vehicle.locked = true
		exports.notifications:add(player, "Zamknąłeś pojazd.")
		return
	end

	if arg1 == "silnik" then
		if not arg2 then
			exports.notifications:add(player, "Użyj: /apojazd silnik [UID]")
			return
		end
		local vehicle = Element.getByID("vehicle-"..arg2)
		if not vehicle then
			exports.notifications:add(player, "Podany pojazd nie jest zespawnowany!", "danger")
			return
		end
		vehicle:setData("vehicleEngine", not vehicle:getData("vehicleEngine"))
		vehicle.engineState = vehicle:getData("vehicleEngine")
		if not vehicle.engineState then
			exports.notifications:add(player, "Zgasiłeś silnik w pojeździe.")
		else
			exports.notifications:add(player, "Odpaliłeś silnik w pojeździe.")
		end
		return
	end

	if arg1 == "model" then
		if not arg2 or not arg3 then
			exports.notifications:add(player, "Użyj: /apojazd model [UID] [model]")
			return
		end
		local vehicle = Element.getByID("vehicle-"..arg2)
		if not vehicle then
			exports.notifications:add(player, "Podany pojazd nie jest zespawnowany!", "danger")
			return
		end
		vehicle.model = arg3
		exports.notifications:add(player, "Zmieniłeś model pojazdu.")
		return
	end

	if arg1 == "kolor" then
		if not arg2 or not arg3 or not arg4 or not arg5 then
			exports.notifications:add(player, "Użyj: /apojazd kolor [UID] [czerwony] [zielony] [niebieski]")
			return
		end
		local vehicle = Element.getByID("vehicle-"..arg2)
		if not vehicle then
			exports.notifications:add(player, "Podany pojazd nie jest zespawnowany!", "danger")
			return
		end
		local extraColors = {...}
		if not extraColors then
			vehicle:setColor(arg3, arg4, arg5)
		else
			vehicle:setColor(arg3, arg4, arg5, unpack(extraColors))
		end
		exports.notifications:add(player, "Przemalowałeś pojazd.")
		return
	end

	if arg1 == "wlasciciel" then
		if not arg2 or not arg3 or not arg4 then
			exports.notifications:add(player, "Użyj: /apojazd wlasciciel [UID pojazdu] [gracz] [UID wlasciciela]")
			return
		end
		local vehicle = Element.getByID("vehicle-"..arg2)
		if not vehicle then
			exports.notifications:add(player, "Podany pojazd nie jest zespawnowany!", "danger")
			return
		end
		local ownerType = ownerTypes.none
		if arg3 == "gracz" then
			ownerType = ownerTypes.character
		end
		exports.vehicles:setVehicleOwner(vehicle, ownerType, arg4)
		exports.notifications:add(player, "Zmieniłeś właściciela pojazdu.")
		return
	end

	if arg1 == "tpto" then
		if not arg2 then
			exports.notifications:add(player, "Użyj: /apojazd tpto [UID]")
			return
		end
		local vehicle = Element.getByID("vehicle-"..arg2)
		if not vehicle then
			exports.notifications:add(player, "Podany pojazd nie jest zespawnowany!", "danger")
			return
		end
		player.position = vehicle.position
		return
	end

	if arg1 == "tphere" then
		if not arg2 then
			exports.notifications:add(player, "Użyj: /apojazd tphere [UID]")
			return
		end
		local vehicle = Element.getByID("vehicle-"..arg2)
		if not vehicle then
			exports.notifications:add(player, "Podany pojazd nie jest zespawnowany!", "danger")
			return
		end
		vehicle.position = player.position
		return
	end

	if arg1 == "parkuj" then
		if not arg2 then
			exports.notifications:add(player, "Użyj: /apojazd parkuj [UID]")
			return
		end
		local vehicle = Element.getByID("vehicle-"..arg2)
		if not vehicle then
			exports.notifications:add(player, "Podany pojazd nie jest zespawnowany!", "danger")
			return
		end
		local vehInfo = vehicle:getData("vehInfo")
		vehInfo.parkX, vehInfo.parkY, vehInfo.parkZ = vehicle.position.x, vehicle.position.y, vehicle.position.z
		vehInfo.partRX, vehInfo.parkRY, vehInfo.parkRZ = vehicle.rotation.x, vehicle.rotation.y, vehicle.rotation.z
		vehicle:setData("vehInfo", vehInfo)
		exports.notifications:add(player, "Przeparkowałeś pojazd.")
		return
	end

	exports.notifications:add(player, "Użyj: /apojazd [stworz, spawn, unspawn, napraw, hp, otworz, zamknij, silnik, model, kolor, wlasciciel, tpto, tphere, parkuj]")
end)