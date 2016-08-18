local font14 = dxCreateFont("myriadproregular.ttf", 14, false, "cleartype")
local font12 = dxCreateFont("myriadproregular.ttf", 12, false, "cleartype")

local showLocalPlayer = true

addEventHandler("onClientRender", root, function()
	local players = Element.getAllByType("player")
	for i, v in ipairs(players) do
		if v:getData("charInfo") and localPlayer.dimension == v.dimension then
			local dist = getDistanceBetweenPoints3D(localPlayer.position, v.position)
			if dist < 15 then
				if isLineOfSightClear(localPlayer.position, v.position, true, false, false, true, false, false, false) then
					local bx, by, bz = v:getBonePosition(8)
					local x, y = getScreenFromWorldPosition(bx, by, bz + 0.25)
					if x and y then
						if localPlayer == v and not showLocalPlayer then
						else
							local text = exports.playerUtils:formatName(v.name) .. " (" .. v:getData("ID") .. ")\n"
							local offset = 0
							dxDrawText(text, x, y, x, y, tocolor(186, 117, 255), 1, font14, "center", "center")
							offset = offset + font14:getHeight(1) + 10
							if v:getData("groupDuty") then
								local groupDutyInfo = v:getData("groupDutyInfo")
								if groupDutyInfo then
									text = "[" .. groupDutyInfo["name"] .. "]\n"
									dxDrawText(text, x, y + offset, x, y, tocolor(186, 117, 255), 1, font12, "center", "center")
									offset = offset + font12:getHeight(1)
								end
							end
						end
					end
				end
			end
		end
	end
end)