local itemsWindow = nil
local screenWidth, screenHeight = guiGetScreenSize()
local showItems = false
local lastItemUse = 0

local isGUIReady = false

addEventHandler("onClientResourceStart", resourceRoot, function()
	itemsWindow = GuiBrowser(screenWidth - 300, screenHeight / 2 - 100, 300, 300, true, true, false)
	addEventHandler("onClientBrowserCreated", itemsWindow.browser, function()
		itemsWindow.browser:toggleDevTools(false)
		triggerServerEvent("loadPlayerItems", localPlayer)
		itemsWindow.browser:loadURL("http://mta/local/playerItems.html")
		guiSetVisible(itemsWindow, showItems)
		addEventHandler("onClientBrowserDocumentReady", itemsWindow.browser, function(url)
			isGUIReady = true
		end)
		addEvent('usePlayerItem', true)
		addEventHandler('usePlayerItem', itemsWindow.browser, function(UID)
			if lastItemUse + 50 > getTickCount() then
				return
			end
			hide()
			lastItemUse = getTickCount()
			local item = Element.getByID("item-"..UID)
			triggerServerEvent("usePlayerItem", localPlayer, item)
		end)
		addEvent("dropPlayerItem", true)
		addEventHandler("dropPlayerItem", itemsWindow.browser, function(UID)
			hide()
			local item = Element.getByID("item-"..UID)
			triggerServerEvent("dropPlayerItem", localPlayer, item)
		end)
	end)
end)

function show()
	if isGUIReady == true then
		if not localPlayer:getData("charItems") then
			exports.notifications:add("Nie posiadasz żadnych przedmiotów!", "danger", 5000)
			return
		end
		showItems = true
		updateItems()
		itemsWindow:setVisible(true)
		showCursor(true, false)
		toggleControl("fire", false)
	end
end

function hide()
	showItems = false
	itemsWindow:setVisible(false)
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
	itemsWindow.browser:executeJavascript('clearItems();')
	for i,v in ipairs(charItems) do
		local itemInfo = v:getData("itemInfo")
		local used = "false"
		if itemInfo["user"] == true then
			used = "true"
		end
		itemsWindow.browser:executeJavascript('addItem('..itemInfo['UID']..',"'..itemInfo["name"]..'",'..used..');')
	end
	itemsWindow.browser:executeJavascript('updateItems();')
end
bindKey("p", "down", toggle)

addEvent("onPlayerItemsLoaded", true)
addEventHandler("onPlayerItemsLoaded", root, function()
	if showItems == true then
		updateItems()
		itemsWindow.visible = true
		showCursor(true, false)
		toggleControl("fire", false)
	end
end)