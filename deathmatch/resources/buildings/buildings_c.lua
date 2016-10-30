local pickup = nil

local buildingWindow = nil
local showingInfo = false
local screenWidth, screenHeight = guiGetScreenSize()

addEventHandler("onClientResourceStart", resourceRoot, function()
	buildingWindow = GuiBrowser(screenWidth / 2 - 300, screenHeight - 200, 600, 200, true, true, false)
	addEventHandler("onClientBrowserCreated", buildingWindow.browser, function()
		buildingWindow.browser:loadURL("http://mta/local/buildingInfo.html")
		guiSetVisible(buildingWindow, false)
	end)
end)

addEventHandler("onClientPickupHit", root, function(player, matchingDimension)
	if player == localPlayer then
		local building = source:getData("building")
		if building then
			local buildingInfo = building:getData("buildingInfo")
			pickup = source
			buildingWindow.browser:executeJavascript("$('#name').html('"..buildingInfo.name.."');")
			buildingWindow.browser:executeJavascript("$('#description').html('"..buildingInfo.description.."');")
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
		if source:getData("building") then
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