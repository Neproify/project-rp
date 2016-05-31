local itemsWindow = nil
local screenWidth, screenHeight = guiGetScreenSize()
local showItems = false
local lastItemUse = 0

addEventHandler("onClientResourceStart", root, function()
	itemsWindow = GuiBrowser(screenWidth - 300, screenHeight / 2 - 100, 300, 300, true, true, false)
	addEventHandler("onClientBrowserCreated", itemsWindow, function()
		itemsWindow:getBrowser():loadURL("http://mta/local/playerItems.html")
		guiSetVisible(itemsWindow, showItems)
		addEvent('usePlayerItem', true)
		addEventHandler('usePlayerItem', itemsWindow:getBrowser(), function(UID)
			if lastItemUse + 50 > getTickCount() then
				return
			end
			hide()
			lastItemUse = getTickCount()
			triggerServerEvent("usePlayerItem", localPlayer, UID)
		end)
		addEvent("dropPlayerItem", true)
		addEventHandler("dropPlayerItem", itemsWindow:getBrowser(), function(UID)
			hide()
			triggerServerEvent("dropPlayerItem", localPlayer, UID)
		end)
	end)
end)

function show()
	showItems = true
	triggerServerEvent("loadPlayerItems", localPlayer)
	guiSetVisible(itemsWindow, true)
	showCursor(true, false)
	toggleControl("fire", false)
end

function hide()
	showItems = false
	guiSetVisible(itemsWindow, false)
	showCursor(false)
	toggleControl("fire", true)
end

function toggle()
	if showItems then
		hide()
	else
		show()
	end
end

function updateItems()
	local charItems = localPlayer:getData("charItems")
	itemsWindow:getBrowser():executeJavascript('clearItems();')
	for i,v in ipairs(charItems) do
		itemsWindow:getBrowser():executeJavascript('addItem('..v['UID']..',"'..v["name"]..'",'..v["used"]..');')
	end
	itemsWindow:getBrowser():executeJavascript('updateItems();')
end
bindKey("p", "down", toggle)

addEvent("onPlayerItemsLoaded", true)
addEventHandler("onPlayerItemsLoaded", root, function()
	if showItems == true then
		updateItems()
	end
end)