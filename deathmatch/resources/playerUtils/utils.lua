function getByCharUID(UID)
	local player = nil
	for i, v in ipairs(getElementsByType("player")) do
		if(v:getData("charInfo")["UID"] == UID) then
			player = v
			break
		end
	end
	return player
end