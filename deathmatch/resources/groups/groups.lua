--[[
	Typy grup:
	1 - Rząd
	2 - PD
	3 - EC(Emergency Center)
	4 - Radio(?)
	5 - Warsztat
	6 - Restauracja
]]--

groupType = {}
groupType.government = 1
groupType.police = 2
groupType.emergency = 3
groupType.news = 4
groupType.workshop = 5
groupType.restaurant = 6

function getGroupTypes()
	return groupType
end

--[[
	Uprawnienia pracowników:
]]--

groupMemberPermission = {}
groupMemberPermission.membersManagment = 1

function getGroupMemberPermissions()
	return groupMemberPermission
end

--[[
	Uprawnienia specjalne grup:
	1 - megafon
]]--

groupSpecialPermission = {}
groupSpecialPermission.megaphone = 1

function getGroupSpecialPermissions()
	return groupSpecialPermission
end