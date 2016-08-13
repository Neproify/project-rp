-- Chodzenie bez wciskania alta

addEventHandler("onClientResourceStart", resourceRoot, function()
	toggleControl("forwards", false)
	toggleControl("backwards", false)
	toggleControl("left", false)
	toggleControl("right", false)
	toggleControl("walk", false)
	toggleControl("sprint", false)
	addEventHandler("onClientRender", root, walking)
end)

local run = false
local sprint = false

function walking()
	if getKeyState("w") then
		setControlState("forwards", true)
	else
		setControlState("forwards", false)
	end
	if getKeyState("s") then
		setControlState("backwards", true)
	else
		setControlState("backwards", false)
	end
	if getKeyState("a") then
		setControlState("left", true)
	else
		setControlState("left", false)
	end
	if getKeyState("d") then
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