function getByID(ID)
	local players = Element:getAllByType("player")
	for i,v in ipairs(players) do
		if v:getData("ID") == ID then return v end
	end
	return false
end

function getByName(name)
	local name = name and name:gsub("#%x%x%x%x%x%x", ""):lower() or nil
	if name then
		for _, player in ipairs(getElementsByType("player")) do
			local name_ = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""):lower()
			if name_:find(name, 1, true) then
				return player
			end
		end
	end
	return false
end