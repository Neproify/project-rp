local logType = {}
logType.auth = 1
-- details: success
logType.authCharacter = 2
logType.chatNormal = 3
logType.chatShout = 4
logType.chatWhisper = 5
logType.chatMe = 6
logType.chatDo = 7
logType.chatPrivate = 8
logType.itemUse = 9
logType.itemDrop = 10
logType.itemPick = 11

local db = exports.db

function getLogTypes()
	return logType
end

function addLog(logType, ipAddress, gID, cID, details)
	if not logType then
		return
	end
	if not ipAddress then
		ipAddress = "undefined"
	end
	if not gID then
		gID = -1
	end
	if not cID then
		cID = -1
	end
	if not details or details == "" then
		details = "undefined"
	end
	if type(details) == "table" then
		details = packDetails(details)
	end
	db:query("INSERT INTO `rp_logs` SET `type`=?, `ipAddress`=?, `globalID`=?, `charID`=?, `details`=?", logType, 
		ipAddress, gID, cID, details)
end

function explodeDetails(details)
	return details:explode('|')
end

function packDetails(details)
    local packedDetails = ""
    for i,v in ipairs(details) do
        packedDetails = packedDetails .. v .. "|"
    end
    if packedDetails:sub(-1, -1) == "|" then
        packedDetails = packedDetails:sub(1, -2)
    end
    return packedDetails
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