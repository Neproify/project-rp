local pickup = nil

local buildingWindow = nil
local showingInfo = false
local screenWidth, screenHeight = guiGetScreenSize()

addEventHandler("onClientResourceStart", resourceRoot, function()
	buildingWindow = GuiBrowser(screenWidth / 2 - 300, screenHeight - 200, 600, 200, true, true, false)
	addEventHandler("onClientBrowserCreated", buildingWindow, function()
		buildingWindow:getBrowser():loadURL("http://mta/local/buildingInfo.html")
		guiSetVisible(buildingWindow, false)
	end)
end)

addEventHandler("onClientPickupHit", root, function(player, matchingDimension)
	if player == localPlayer then
		local buildingInfo = source:getData("buildingInfo")
		if buildingInfo then
			pickup = source
			buildingWindow:getBrowser():executeJavascript("$('#name').html('"..buildingInfo.name.."');")
			buildingWindow:getBrowser():executeJavascript("$('#description').html('"..buildingInfo.description.."');")
			showingInfo = true
			Timer(function()
				if showingInfo == true then
					guiSetVisible(buildingWindow, true)
				end
			end, 100, 1)
		end
	end
end)

addEventHandler("onClientPickupLeave", root, function(player, matchingDimension)
	if player == localPlayer then
		if source:getData("buildingInfo") then
			pickup = nil
			guiSetVisible(buildingWindow, false)
			showingInfo = false
		end
	end
end)

function useDoor()
	if pickup then
		triggerServerEvent("useDoor", localPlayer, pickup)
		guiSetVisible(buildingWindow, false)
	end
end
bindKey("e", "down", useDoor)