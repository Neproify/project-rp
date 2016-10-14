function getByCharUID(UID)
	local player = false
	for i, v in ipairs(getElementsByType("player")) do
		if(v:getData("charInfo")["UID"] == UID) then
			player = v
			break
		end
	end
	return player
end