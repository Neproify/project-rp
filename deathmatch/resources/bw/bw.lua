function isPlayerBrutallyWounded(player)
	local bw = player:getData("bw")
	if not bw then
		return false
	end
	if getTickCount() < bw then
		return true
	end
	return false
end