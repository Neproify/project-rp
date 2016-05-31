local groupsWindow = nil
local groupsShow = false

local openedGroup = nil

local screenWidth, screenHeight = guiGetScreenSize()

addEventHandler("onClientResourceStart", root, function()
	groupsWindow = GuiBrowser(screenWidth / 2 - 250, screenHeight / 2 - 150, 500, 300, true, true, false)
	addEventHandler("onClientBrowserCreated", groupsWindow, function()
		groupsWindow:getBrowser():loadURL("http://mta/local/playerGroups.html")
		guiSetVisible(groupsWindow, groupsShow)
		addEvent("openGroupPanel", true)
		addEventHandler("openGroupPanel", groupsWindow:getBrowser(), function(UID)
			openedGroup = tonumber(UID)
			groupsWindow:getBrowser():loadURL("http://mta/local/group.html")
		end)
		addEvent("toggleDuty", true)
		addEventHandler("toggleDuty", groupsWindow:getBrowser(), function()
			triggerServerEvent("toggleDuty", localPlayer, openedGroup)
		end)
		addEventHandler("onClientBrowserDocumentReady", groupsWindow:getBrowser(), function(url)
			local charGroups = localPlayer:getData("charGroups")
			if url == "http://mta/local/group.html" then
				for i,v in ipairs(charGroups) do
					if v.groupInfo.UID == openedGroup then
						groupsWindow:getBrowser():executeJavascript("$('#name').html('"..v.groupInfo.name.."');")
						break
					end
				end
			end
			if url == "http://mta/local/groupMembers.html" then
				for i,v in ipairs(charGroups) do
					if v.groupInfo.UID == openedGroup then
						groupsWindow:getBrowser():executeJavascript("$('#name').html('"..v.groupInfo.name.."');")
						break
					end
				end
			end
			if url == "http://mta/local/playerGroups.html" then
				if not localPlayer:getData("charInfo") then
					return
				end
				triggerServerEvent("loadPlayerGroups", localPlayer)
			end
		end)
	end)
end)

function show()
	groupsShow = true
	if not localPlayer:getData("charGroups") then
		groupsWindow:getBrowser():loadURL("http://mta/local/playerGroups.html")
	end
	guiSetVisible(groupsWindow, true)
	showCursor(true, false)
	toggleControl("fire", false)
end

function hide()
	groupsShow = false
	guiSetVisible(groupsWindow, false)
	showCursor(false)
	toggleControl("fire", true)
end

addCommandHandler("g", function()
	if groupsShow == true then
		hide()
	else
		show()
	end
end)

addEvent("onPlayerGroupsLoaded", true)
addEventHandler("onPlayerGroupsLoaded", root, function()
	if groupsWindow:getBrowser():getURL() == "http://mta/local/playerGroups.html" then
		local charGroups = localPlayer:getData("charGroups")
		groupsWindow:getBrowser():executeJavascript("clearGroups();")
		for i,v in ipairs(charGroups) do
			groupsWindow:getBrowser():executeJavascript("addGroup("..v.groupInfo.UID..",'"..v.groupInfo.name.."');")
		end
		groupsWindow:getBrowser():executeJavascript("updateGroups();")
	end
end)