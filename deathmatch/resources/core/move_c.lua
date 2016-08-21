-- Chodzenie bez wciskania alta
-- Podążanie za graczem który nas skuł

addEventHandler("onClientResourceStart", resourceRoot, function()
	toggleControl("forwards", false)
	toggleControl("backwards", false)
	toggleControl("left", false)
	toggleControl("right", false)
	toggleControl("walk", false)
	toggleControl("sprint", false)
	addEventHandler("onClientRender", root, onRender)
end)

local run = false
local sprint = false
local followingPlayer = nil
local lastCheck = 0

function onRender()
	if getTickCount() - lastCheck > 1000 then
		lastCheck = getTickCount()
		followingPlayer = localPlayer:getData("cuffedBy")
	end
	if followingPlayer then
		following()
	else
		walking()
	end
end

function walking()
	local stopWalking = false
	if isChatBoxInputActive() or isConsoleActive() or isMainMenuActive() or exports.bw:isPlayerBrutallyWounded(localPlayer) or followingPlayer then
		stopWalking = true
	end
	if getKeyState("w") and not stopWalking then
		setControlState("forwards", true)
	else
		setControlState("forwards", false)
	end
	if getKeyState("s") and not stopWalking then
		setControlState("backwards", true)
	else
		setControlState("backwards", false)
	end
	if getKeyState("a") and not stopWalking then
		setControlState("left", true)
	else
		setControlState("left", false)
	end
	if getKeyState("d") and not stopWalking then
		setControlState("right", true)
	else
		setControlState("right", false)
	end
	if not getKeyState("w") and not getKeyState("s") and not getKeyState("a") and not getKeyState("d") then
		run = false
	end
	if run == true then
		setControlState("walk", false)
		if sprint == true then
			setControlState("sprint", true)
		end
	else
		setControlState("walk", true)
	end
	if getControlState("sprint") == true and not sprint then
		setControlState("sprint", false)
	end
	if getKeyState("space") then
		run = true
		sprint = true
	else
		sprint = false
	end
	if getKeyState("lalt") then
		run = false
	end
end

function following()
	local distance = getDistanceBetweenPoints3D(localPlayer.position, followingPlayer.position)
	if distance < 2 then
		setControlState("forwards", false)
	else
		if not localPlayer.inVehicle then
			setControlState("forwards", true)
			if distance < 4 then
				setControlState("walk", true)
				setControlState("sprint", false)
			elseif distance < 6 then
				setControlState("walk", false)
				setControlState("sprint", false)
			else
				setControlState("walk", false)
				setControlState("sprint", true)
			end

			local pos1 = localPlayer.position
			local pos2 = followingPlayer.position

			local rotation = localPlayer.rotation
			rotation.z = findRotation(pos1.x, pos1.y, pos2.x, pos2.y)

			localPlayer.rotation = rotation
		end
	end
end

function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end