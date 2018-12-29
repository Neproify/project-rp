adminLevels = {}
adminLevels.none = 0
adminLevels.support = 1
adminLevels.gamemaster = 2
adminLevels.admin = 3
adminLevels.owner = 4

adminPermissions = {}
adminPermissions.players = 1
adminPermissions.money = 10
adminPermissions.vehicles = 100
adminPermissions.buildings = 1000
adminPermissions.groups = 10000
adminPermissions.items = 100000

function hasPlayerAdminPermissionTo(player, permission)
	local globalInfo = player:getData("globalInfo")
	if not globalInfo then
		return false
	end
	if bitTest(globalInfo.adminPermissions, permission) then
		return true
	end

	return false
end

function isPlayerAdminLevelEqualOrMore(player, level)
	local globalInfo = player:getData("globalInfo")
	if not globalInfo then
		return false
	end

	if globalInfo.admin >= level then
		return true
	end

	return false
end