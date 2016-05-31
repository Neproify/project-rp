local db = exports.db

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
	player:setData("charGroups", charGroups)
	triggerClientEvent(player, "onPlayerGroupsLoaded", root)
end

addEvent("loadPlayerGroups", true)
addEventHandler("loadPlayerGroups", root, function()
	loadPlayerGroups(client)
end)