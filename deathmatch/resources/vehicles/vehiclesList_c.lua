local screenWidth, screenHeight = guiGetScreenSize()

local vehiclesWindow = nil
local showVehicles = false

addEventHandler("onClientResourceStart", root, function()
	vehiclesWindow = GuiBrowser(screenWidth / 2 - 250, screenHeight / 2 - 150, 500, 300, true, true, false)
	addEventHandler("onClientBrowserCreated", vehiclesWindow, function()
		vehiclesWindow:getBrowser():loadURL("http://mta/local/playerVehicles.html")
		guiSetVisible(vehiclesWindow, showVehicles)
	end)
	addEvent("spawnPlayerVehicle", true)
	addEventHandler("spawnPlayerVehicle", vehiclesWindow:getBrowser(), function(UID)
		hide()
		triggerServerEvent("spawnVehicleByPlayer", localPlayer, UID)
	end)
	addEvent("findVehicle", true)
	addEventHandler("findVehicle", vehiclesWindow:getBrowser(), function(UID)
		hide()
		triggerServerEvent("findVehicleByPlayer", localPlayer, UID)
	end)
end)

function show()
	triggerServerEvent("loadPlayerVehicles", localPlayer)
	showVehicles = true
	guiSetVisible(vehiclesWindow, true)
	showCursor(true, false)
	toggleControl("fire", false)
end

function hide()
	showVehicles = false
	guiSetVisible(vehiclesWindow, false)
	showCursor(false)
	toggleControl("fire", true)
end

function updateVehicles()
	local charVehicles = localPlayer:getData("charVehicles")
	vehiclesWindow:getBrowser():executeJavascript('clearVehicles();')
	for i,v in ipairs(charVehicles) do
		vehiclesWindow:getBrowser():executeJavascript('addVehicle('..v['UID']..',"'..getVehicleNameFromModel(v['model'])..'");')
	end
	vehiclesWindow:getBrowser():executeJavascript('updateVehicles();')
end

addEvent("onPlayerVehiclesLoaded", true)
addEventHandler("onPlayerVehiclesLoaded", root, function()
	if showVehicles == true then
		updateVehicles()
	end
end)

addCommandHandler("v", function()
	if showVehicles then
		hide()
	else
		show()
	end
end)