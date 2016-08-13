local db = exports.db

addEventHandler("onCharacterSelected", root, function(player)
	loadPlayerGroups(player)
end)

function loadPlayerGroups(player)
	local charInfo = player:getData("charInfo")
	local charGroups = {}
	local groups = db:fetch("SELECT * FROM `rp_groups_members` WHERE `charUID`=?", charInfo.UID)
	for i,v in ipairs(groups) do
		local groupInfo = db:fetch("SELECT * FROM `rp_groups` WHERE `UID`=?", v.groupUID)
		local info = {}
		info.groupInfo = groupInfo[1]
		info.memberInfo = v
		table.insert(charGroups, info)
	end
	if #charGroups < 1 then
		charGroups = nil
	end
	player:setData("charGroups", charGroups)
	triggerClientEvent(player, "onPlayerGroupsLoaded", root)
end

function getGroupType(UID)
	local groupInfo = db:fetchOne("SELECT * FROM `rp_groups` WHERE `UID`=?", UID)
	return groupInfo["type"]
end

function getGroupInfo(UID)
	local groupInfo = db:fetchOne("SELECT * FROM `rp_groups` WHERE `UID`=?", UID)
	return groupInfo
end

function getPlayerRankInGroup(player, gID)
	local charInfo = player:getData("charInfo")
	if not charInfo then
		return false
	end
	local temp = db:fetchOne("SELECT * FROM `rp_groups_members` WHERE `charUID`=? AND `groupUID`=?", 
		charInfo["UID"], gID)
	if not temp then
		return false end
	local rank = db:fetchOne("SELECT * FROM `rp_groups_ranks` WHERE `UID`=?", temp["rank"])
	return rank or false
end

function isOnDutyOfType(player, type)
	if not player or not type then
	 	return false
	end
	local group = player:getData("groupDuty")
	if not group then
		return false
	end
	
	if getGroupType(group) == type then
		return true
	end
	
	return false
end

function haveGroupSpecialPermission(UID, permission)
	local groupInfo = getGroupInfo(UID)
	if bitTest(groupInfo["specialPermissions"], permission) then
		return true
	end
	return false
end

function havePlayerGroupSpecialPermission(player, permission)
	local group = player:getData("groupDuty")
	if not group then
		return false
	end
	return haveGroupSpecialPermission(group, permission)
end

function havePlayerPermissionInGroup(player, UID, permission)
	local charInfo = player:getData("charInfo")
	if not charInfo then
		return false
	end
	local rank = getPlayerRankInGroup(player, UID)
	if not rank then
		return false
	end
	if bitTest(rank["permissions"], permission) then
		return true
	end
	return false
end

addEvent("loadPlayerGroups", true)
addEventHandler("loadPlayerGroups", root, function()
	loadPlayerGroups(client)
end)

addEvent("toggleDuty", true)
addEventHandler("toggleDuty", root, function(UID)
	if not UID then return end
	local currentDuty = client:getData("groupDuty")
	if not currentDuty then
		-- zaczynamy duty DO ZROBIENIA SPRAWDZANIE UPRAWNIEŃ, CZY JEST W GRUPIE, ITD!!!
		client:setData("groupDuty", UID)
		local time = getRealTime()
		client:setData("groupDutyStarted", time.timestamp)
		exports.notifications:add(client, "Rozpocząłeś pracę.", "info", 3000)
	else
		if currentDuty == UID then
			local charInfo = client:getData("charInfo")
			local time = getRealTime()
			local dutyTime = time.timestamp - client:getData("groupDutyStarted")
			client:setData("groupDuty", nil)
			exports.notifications:add(client, "Skończyłeś pracę. Przepracowałeś: ".. math.floor(dutyTime / 60) .. " min.", "info", 3000)
			exports.db:query("UPDATE `rp_groups_members` SET `dutyTime` = `dutyTime` + ? WHERE `groupUID`=? AND `charUID`=? LIMIT 1;", dutyTime, UID, charInfo["UID"])
		else
			exports.notifications:add(client, "Pracujesz już w innej grupie!", "error", 3000)
		end
	end
end)