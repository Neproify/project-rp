--[[
	ownerType:
	1 - gracz
	2 - świat(przedmiot wyrzucony)
--]]

--[[
	Typ przedmiotu:
	1 - broń, podtypy: id broni, ilość kul
	2 - magazynek do broni, podtypy: id broni, ilość kul
	3 - kluczyk do auta, podtypy: id auta, typ(1 - zwykły kluczyk)
	4 - dokument, podtypy: typ dokumentu, ważny do
	[
		1 - dowód osobisty
		2 - prawo jazdy
	]
--]]
local db = exports.db

itemsOwnedBy = {}
itemsOwnedBy[0] = {}
itemsOwnedBy[1] = {}
itemsOwnedBy[2] = {}

function loadItem(v) -- Jeżeli dostanie tablice to stworzy z niej przedmiot, jeżeli numer to wczyta z bazy danych
	if type(v) == "table" then
		local item = Element.getByID("item-".. v.UID) -- szukamy czy już istnieje, jeśli tak to aktualizujemy
		if not item then
			item = Element("item", "item-".. v.UID)
		end
		v.properties = explodeProperties(v.properties)
		v.used = false
		item:setData("itemInfo", v)

		if not itemsOwnedBy[v.ownerType][v.owner] or #itemsOwnedBy[v.ownerType][v.owner] == 0 then
			itemsOwnedBy[v.ownerType][v.owner] = {}
		end

		table.insert(itemsOwnedBy[v.ownerType][v.owner], item)

		if v.ownerType == 2 then
			local object = Object(getItemObjectModel(item), Vector3(v.posX, v.posY, v.posZ), Vector3(0, 0, 0), false)
			object:setData("item", item)
			item:setData("groundObject", object)
		end
		return item
	elseif type(v) == "number" then
		local item = db:fetchOne("SELECT * FROM `rp_items` WHERE `UID` = ?", v)
		if item then
			return loadItem(item)
		end
	end
end

function loadItems()
	local items = db:fetch("SELECT * FROM `rp_items`")
	for i,v in ipairs(items) do
		loadItem(v)
	end
end

function saveItem(item)
	local itemInfo = item:getData("itemInfo")
		db:query("UPDATE `rp_items` SET `name` = ?, `ownerType` = ?, `owner` = ?, `type` = ?, `properties` = ?, `posX` = ?, `posY` = ?, `posZ` = ? WHERE `UID` = ?",
			itemInfo.name, itemInfo.ownerType, itemInfo.owner, itemInfo.type, packProperties(itemInfo.properties), itemInfo.posX, itemInfo.posY, itemInfo.posZ, itemInfo.UID)
end

function saveItems()
	local items = Element.getAllByType("item")
	for i,v in ipairs(items) do
		saveItem(v)
	end
end

addEventHandler("onResourceStart", resourceRoot, function()
	loadItems()
end)

addEventHandler("onResourceStop", resourceRoot, function()
	saveItems()
end)

function createItem(name, ownerType, owner, type, properties)
	properties = packProperties(properties)
	local result, affected, UID = db:fetch("INSERT INTO `rp_items` SET `name`=?, `ownerType`=?, `owner`=?, `type`=?, `properties`=?", name, ownerType, owner, type, properties)
	local item = loadItem(UID)
	return item
end

function deleteItem(item)
	local itemInfo = item:getData("itemInfo")
	db:query("DELETE FROM `rp_items` WHERE `UID`=?", itemInfo.UID)
	for i,v in ipairs(itemsOwnedBy[itemInfo.ownerType][itemInfo.owner]) do
		if v == item then
			table.remove(itemsOwnedBy[itemInfo.ownerType][itemInfo.owner], i)
			break
		end
	end
	item:destroy()
end

function setItemOwner(item, ownerType, owner)
	local itemInfo = item:getData("itemInfo")
	
	if not itemsOwnedBy[itemInfo.ownerType][itemInfo.owner] then
		itemsOwnedBy[itemInfo.ownerType][itemInfo.owner] = {}
	end
	
	for i, v in ipairs(itemsOwnedBy[itemInfo.ownerType][itemInfo.owner]) do
		if v == item then
			table.remove(itemsOwnedBy[itemInfo.ownerType][itemInfo.owner], i)
		end
	end

	local playerThatNeedItemsReload = nil

	if itemInfo.ownerType == 1 then
		local player = exports.playerUtils:getByCharUID(tonumber(itemInfo.owner))
		if player then
			playerThatNeedItemsReload = player
			if itemInfo.used == true then
				triggerEvent("usePlayerItem", root, item, player)
			end
		end
	end

	itemInfo.ownerType = ownerType
	itemInfo.owner = owner

	item:setData("itemInfo", itemInfo)
	saveItem(item)
	loadItem(itemInfo.UID)

	if playerThatNeedItemsReload ~= nil then
		loadPlayerItems(playerThatNeedItemsReload)
	end

	if itemInfo.ownerType == 1 then
		local player = exports.playerUtils:getByCharUID(tonumber(itemInfo.owner))
		if player then
			loadPlayerItems(player)
		end
	end
end

function setItemName(item, name)
	local itemInfo = item:getData("itemInfo")
	itemInfo.name = name
	item:setData("itemInfo", itemInfo)
	saveItem(item)
end

function setItemType(item, itemType)
	local itemInfo = item:getData("itemInfo")
	itemInfo.type = itemType
	item:setData("itemInfo", itemInfo)
	saveItem(item)
end

function setItemProperties(item, properties)
	local itemInfo = item:getData("itemInfo")
	itemInfo.properties = properties
	item:setData("itemInfo", itemInfo)
	saveItem(item)
end

function explodeProperties(properties)
	return properties:explode('|')
end

function packProperties(properties)
	local packedProperties = ""
	for i,v in ipairs(properties) do
		packedProperties = packedProperties .. v .. "|"
	end
	if packedProperties:sub(-1, -1) == "|" then
		packedProperties = packedProperties:sub(1, -2)
	end
	return packedProperties
end

function string.explode(self, separator)
	Check("string.explode", "string", self, "ensemble", "string", separator, "separator")
 
	if (#self == 0) then return {} end
	if (#separator == 0) then return { self } end
 
	return loadstring("return {\""..self:gsub(separator, "\",\"").."\"}")()
end

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