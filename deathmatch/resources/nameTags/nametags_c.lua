local font14 = exports.fonts:getFont("Lato-Regular.ttf", 14, false, "antialiased")
local font12 = exports.fonts:getFont("Lato-Regular.ttf", 12, false, "antialiased")
local font10 = exports.fonts:getFont("Lato-Regular.ttf", 10, false, "antialiased")

local showLocalPlayer = false

addEventHandler("onClientRender", root, function()
	local players = Element.getAllByType("player")
	for i, v in ipairs(players) do
		if v:getData("charInfo") and localPlayer.dimension == v.dimension then
			local dist = getDistanceBetweenPoints3D(localPlayer.position, v.position)
			if dist < 15 then
				if isLineOfSightClear(localPlayer.position, v.position, true, false, false, true, false, false, false) then
					local bonePosition = v:getBonePosition(8)
					local x, y = getScreenFromWorldPosition(bonePosition.x, bonePosition.y, bonePosition.z + 0.25)
					local x2, y2 = getScreenFromWorldPosition(bonePosition.x, bonePosition.y, bonePosition.z - 0.25)
					if x and y then
						if localPlayer == v and not showLocalPlayer then
						else
							local text = exports.playerUtils:formatName(v.name) .. " (" .. v:getData("ID") .. ")\n"
							local offset = 0
							dxDrawText(text, x, y, x, y, tocolor(255, 255, 255), 1, font14, "center", "center")
							offset = offset + font14:getHeight(1) + 10
							if v:getData("groupDuty") then
								local groupDutyInfo = v:getData("groupDutyInfo")
								if groupDutyInfo then
									text = "[" .. groupDutyInfo["name"] .. "]\n"
									dxDrawText(text, x, y + offset, x, y, tocolor(255, 255, 255), 1, font12, "center", "center")
									offset = offset + font12:getHeight(1) + 10
								end
							end
							local state = "("
							local anyStateToShow = false
							if exports.bw:isPlayerBrutallyWounded(v) then
								anyStateToShow = true
								state = state .. "nieprzytomny, "
							end
							if anyStateToShow then
								state = state:sub(1, -3)
								state = state .. ")"
								dxDrawText(state, x, y + offset, x, y, tocolor(255, 255, 255), 1, font10, "center", "center")
								offset = offset + font10:getHeight(1) + 10
							end
							local description = v:getData("description")
							if description then
								dxDrawText(description, x2, y2, x2, y2, tocolor(255, 255, 255), 1, font10, "center", "center")
							end
						end
					end
				end
			end
		end
	end
end)