addEventHandler("onPlayerJoin", root, function()
	assignID(source)
end)

function assignID(plr)
	local players = Element.getAllByType("player")
	local ids_table = {}
	for i,v in ipairs(players) do
		local ID = v:getData("ID")
		if ID then
			table.insert(ids_table, ID)
		end
	end
	table.sort(ids_table)
	local free_id = 0
	for i,v in ipairs(ids_table) do
		if v == free_id then free_id = free_id + 1 end
		if (v > free_id) then break end
	end
	plr:setData("ID", tonumber(free_id))
end