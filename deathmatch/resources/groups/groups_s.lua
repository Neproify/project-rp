local db = exports.db

addEventHandler("onCharacterSelected", root, function(player)
	loadPlayerGroups(player)
end)

function loadPlayerGroups(player)
	local charInfo = player:getData("charInfo")
	if not charInfo then
		return
	end
	local charGroups = {}
	local groups = db:fetch("SELECT * FROM `rp_groups_members` WHERE `charUID`=?", charInfo.UID)
	if not groups then
		charGroups = nil
	else
		for i,v in ipairs(groups) do
			local groupInfo = db:fetch("SELECT * FROM `rp_groups` WHERE `UID`=?", v.groupUID)
			local info = {}
			info.groupInfo = groupInfo[1]
			info.memberInfo = v
			table.insert(charGroups, info)
		end
	end
	if #charGroups < 1 then
		charGroups = nil
	end
	player:setData("charGroups", charGroups)
	triggerClientEvent(player, "onPlayerGroupsLoaded", root)
end

function getPlayerGroup(player)
	local group = player:getData("groupDuty")
	if not group then
		return false
	end
	return group
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

function getGroupMoney(UID)
	local groupInfo = getGroupInfo(UID)
	if groupInfo then
		return groupInfo["bank"]
	end
	return false
end

function giveMoneyForGroup(UID, money)
	local groupMoney = getGroupMoney(UID)
	if not groupMoney then
		return false
	end
	db:query("UPDATE `rp_groups` SET `bank`=? WHERE `UID`=?", groupMoney + money, UID)
	return true
end

function isPlayerInGroup(player, gID) -- hacky
	if getPlayerRankInGroup(player, gID) ~= false then
		return true
	end
	return false
end

function getAllPlayersOfGroupOnDuty(gID)
	local players = {}
	for i,v in ipairs(Element.getAllByType("player")) do
		if v:getData("groupDuty") == gID then
			table.insert(players, v)
		end
	end
	return players
end

function getGroupMembers(gID)
	local members = db:fetch("SELECT * FROM `rp_groups_members` WHERE `groupUID`=?", gID)
	return members
end

function getGroupRanks(gID)
	local ranks = db:fetch("SELECT * FROM `rp_groups_ranks` WHERE `groupID`=?", gID)
	return ranks
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
		if not isPlayerInGroup(client, UID) then
			return
		end
		client:setData("groupDuty", UID)
		client:setData("groupDutyInfo", getGroupInfo(UID))
		local time = getRealTime()
		client:setData("groupDutyStarted", time.timestamp)
		exports.notifications:add(client, "Rozpocząłeś pracę.", "info", 3000)
	else
		if currentDuty == UID then
			local charInfo = client:getData("charInfo")
			local time = getRealTime()
			local dutyTime = time.timestamp - client:getData("groupDutyStarted")
			client:setData("groupDuty", nil)
			client:setData("groupDutyInfo", nil)
			exports.notifications:add(client, "Skończyłeś pracę. Przepracowałeś: ".. math.floor(dutyTime / 60) .. " min.", "info", 3000)
			exports.db:query("UPDATE `rp_groups_members` SET `dutyTime` = `dutyTime` + ? WHERE `groupUID`=? AND `charUID`=? LIMIT 1;", dutyTime, UID, charInfo["UID"])
		else
			exports.notifications:add(client, "Pracujesz już w innej grupie!", "danger", 3000)
		end
	end
end)

addEvent("loadMembersOfGroup", true)
addEventHandler("loadMembersOfGroup", root, function(UID)
	if not UID then return end
	if not isPlayerInGroup(client, UID) then
		return
	end

	local members = getGroupMembers(UID)
	local ranks = getGroupRanks(UID)

	local queryString = db:prepareString("SELECT * FROM `rp_characters` WHERE `UID`=0")
	for i,v in ipairs(members) do
		queryString = queryString .. db:prepareString(" OR `UID`=?", v.charUID)
	end
	local charInfos = db:fetch(queryString)
	for i,v in ipairs(charInfos) do
		for i2,v2 in ipairs(members) do
			if v2.charUID == v.UID then
				members[i2]['name'] = v.name
				break
			end
		end
	end
	triggerClientEvent(client, "onMembersOfGroupLoaded", root, members, ranks)
end)

addEvent("saveGroupMember", true)
addEventHandler("saveGroupMember", root, function(gID, charID, rankID)
	if not havePlayerPermissionInGroup(client, gID, groupMemberPermission.membersManagment) then
		exports.notifications:add(client, "Nie masz uprawnień do zarządzania pracownikami w grupie!", "danger", 3000)
		return
	end

	local groupRanks = getGroupRanks(gID)
	local isInGroup = false

	for i,v in ipairs(groupRanks) do
		if v.UID == tonumber(rankID) then
			isInGroup = true
			break
		end
	end

	if not isInGroup then -- Grr, that hacker! :)
		return
	end

	db:query("UPDATE `rp_groups_members` SET `rank` = ? WHERE `groupUID` = ? AND `charUID` = ?", rankID, gID, charID)
	exports.notifications:add(client, "Pracownik został edytowany.", "info", 3000)

	local editedPlayer = exports.playerUtils:getByCharUID(tonumber(charID))
	if editedPlayer then
		exports.notifications:add(editedPlayer, "Twoje uprawnienia w jednej z grup do której należysz zostały zmienione.", "info", 3000)
	end
end)

addEvent("kickGroupMember", true)
addEventHandler("kickGroupMember", root, function(gID, charID)
	if not havePlayerPermissionInGroup(client, gID, groupMemberPermission.membersManagment) then
		exports.notifications:add(client, "Nie masz uprawnień do zarządzania pracownikami w grupie!", "danger", 3000)
		return
	end

	db:query("DELETE FROM `rp_groups_members` WHERE `groupUID` = ? AND `charUID` = ?", gID, charID)

	exports.notifications:add(client, "Wyrzuciłeś pracownika z grupy.", "info", 3000)

	local editedPlayer = exports.playerUtils:getByCharUID(tonumber(charID))
	if editedPlayer then
		exports.notifications:add(editedPlayer, "Zostałeś wyrzucony z jednej z grup.", "info", 3000)
	end
end)