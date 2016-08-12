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
--]]
local db = exports.db

function getItemInfo(UID)
	local item = db:fetch("SELECT * FROM `rp_items` WHERE `UID`=?", UID)
	return item[1]
end

function createItem(name, ownerType, owner, type, properties)
    local result, affected, UID = db:fetch("INSERT INTO `rp_items` SET `name`=?, `ownerType`=?, `owner`=?, `type`=?, `properties`=?", name, ownerType, owner, type, properties)
    if ownerType == 1 then
        local player = exports.playerUtils:getByCharUID(owner)
        if player then
            loadPlayerItems(player)
        end
    end
    return UID
end

function deleteItem(UID)
    db:query("DELETE FROM `rp_items` WHERE `UID`=?", UID)
end

function updateItemProperties(UID, properties)
    db:query("UPDATE `rp_items` SET `properties`=? WHERE `UID`=?", properties, UID)
end

function markItemAsUsed(UID, used)
    db:query("UPDATE `rp_items` SET `used`=? WHERE `UID`=?", used, UID)
end

function isItemUsed(UID)
    local itemInfo = getItemInfo(UID)
    if itemInfo.used == 1 then
        return true
    else
        return false
    end
end

function setItemOwnerType(UID, ownerType)
    db:query("UPDATE `rp_items` SET `ownerType`=? WHERE `UID`=?", ownerType, UID)
end

function setItemOwner(UID, owner)
    db:query("UPDATE `rp_items` SET `owner`=? WHERE `UID`=?", owner, UID)
end

function setItemPosition(UID, x, y, z)
    db:query("UPDATE `rp_items` SET `posX`=?, `posY`=?, `posZ`=? WHERE `UID`=?", x, y, z, UID)
end

function setItemName(UID, name)
    db:query("UPDATE `rp_items` SET `name`=? WHERE `UID`=?", name, UID)
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

-- kilka komend do testów.

addCommandHandler("giveitem", function(plr, cmd, name, type, properties)
    if not name or not type or not properties then
        exports.notifications:add(plr, "Użyj: /giveitem nazwa typ właściwości.", "info", 5000)
        return
    end
    local charInfo = plr:getData("charInfo")
    local UID = createItem(name, 1, charInfo['UID'], type, properties)
end)

addCommandHandler("deleteitem", function(plr, cmd, UID)
    if not UID then
        exports.notifications:add(plr, "Użyj: /deleteitem UID", "info", 5000)
        return
    end
    deleteItem(UID)
end)

addCommandHandler("deleteallitems", function()
    db:query("DELETE FROM `rp_items`")
end)