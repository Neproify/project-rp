local buildingEditWindow = nil
local screenWidth, screenHeight = guiGetScreenSize()
local editedBuilding = nil

addEventHandler("onClientResourceStart", resourceRoot, function()
	buildingEditWindow = GuiBrowser(screenWidth / 2 - 300, screenHeight / 2 - 200, 600, 400, true, true, false)
	addEventHandler("onClientBrowserCreated", buildingEditWindow.browser, function()
		buildingEditWindow.browser:loadURL("http://mta/local/buildingEdit.html")
		buildingEditWindow.visible = false

        addEvent("saveEdit", true)
        addEventHandler("saveEdit", buildingEditWindow.browser, function(name, description)
            if not editedBuilding then return end
            triggerServerEvent("saveBuildingEdit", localPlayer, editedBuilding, name, description)
        end)

        addEvent("cancelEdit", true)
		addEventHandler("cancelEdit", buildingEditWindow.browser, function()
            buildingEditWindow.visible = false
            showCursor(false)
            guiSetInputEnabled(false)
            editedBuilding = nil
		end)
	end)
end)

addEvent("openBuildingEditMenu", true)
addEventHandler("openBuildingEditMenu", root, function(building)
    editedBuilding = building
    local buildingInfo = building:getData("buildingInfo")
    buildingEditWindow.browser:executeJavascript("$('#name').val('".. buildingInfo.name .."');")
    buildingEditWindow.browser:executeJavascript("$('#description').val('".. buildingInfo.description .."');")
    buildingEditWindow.visible = true
    showCursor(true)
    guiSetInputEnabled(true)
	buildingEditWindow:bringToFront(true)
end)