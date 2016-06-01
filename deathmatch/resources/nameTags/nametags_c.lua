local font = dxCreateFont("myriadproregular.ttf", 12, false, "cleartype")

addEventHandler("onClientRender", root, function()
	local players = Element.getAllByType("player")
	for i, v in ipairs(players) do
		if localPlayer.dimension == v.dimension then
			local dist = getDistanceBetweenPoints3D(localPlayer.position, v.position)
			if dist < 15 then
				if isLineOfSightClear(localPlayer.position, v.position, true, false, false, true, false, false, false) then
					local bx, by, bz = v:getBonePosition(8)
					local x, y = getScreenFromWorldPosition(bx, by, bz + 0.25)
					if x and y then
						--if localPlayer == v then
						if false then
						else
							local text = exports.playerUtils:formatName(v.name) .. " (" .. v:getData("ID") .. ")\n"
							--dxDrawText(text, x, y, x, y, tocolor(186, 117, 255), 0.85 + (15 - dist) * 0.08, font, "center", "center")
							dxDrawText(text, x, y, x, y, tocolor(186, 117, 255), 1, font, "center", "center")
						end
					end
				end
			end
		end
	end
end)