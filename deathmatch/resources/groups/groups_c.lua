local groupsWindow = nil
local groupsShow = false

local openedGroup = nil

local screenWidth, screenHeight = guiGetScreenSize()

addEventHandler("onClientResourceStart", resourceRoot, function()
	groupsWindow = GuiBrowser(screenWidth / 2 - 250, screenHeight / 2 - 150, 500, 300, true, true, false)
	addEventHandler("onClientBrowserCreated", groupsWindow.browser, function()
		groupsWindow.browser:loadURL("http://mta/local/playerGroups.html")
		triggerServerEvent("loadPlayerGroups", localPlayer)
		guiSetVisible(groupsWindow, groupsShow)
		addEvent("openGroupPanel", true)
		addEventHandler("openGroupPanel", groupsWindow.browser, function(UID)
			openedGroup = tonumber(UID)
			groupsWindow.browser:loadURL("http://mta/local/group.html")
		end)
		addEvent("toggleDuty", true)
		addEventHandler("toggleDuty", groupsWindow.browser, function()
			triggerServerEvent("toggleDuty", localPlayer, openedGroup)
		end)
		addEvent("saveGroupMember", true)
		addEventHandler("saveGroupMember", groupsWindow.browser, function(UID, rankUID)
			triggerServerEvent("saveGroupMember", localPlayer, openedGroup, UID, rankUID)
		end)
		addEvent("kickGroupMember", true)
		addEventHandler("kickGroupMember", groupsWindow.browser, function(UID)
			triggerServerEvent("kickGroupMember", localPlayer, openedGroup, UID)
		end)
		addEvent("addGroupMember", true)
		addEventHandler("addGroupMember", groupsWindow.browser, function(name)
			triggerServerEvent("addGroupMember", localPlayer, openedGroup, name)
		end)
		addEventHandler("onClientBrowserDocumentReady", groupsWindow.browser, function(url)
			local charGroups = localPlayer:getData("charGroups")
			if url == "http://mta/local/group.html" then
				for i,v in ipairs(charGroups) do
					if v.groupInfo.UID == openedGroup then
						groupsWindow.browser:executeJavascript("$('#name').html('"..v.groupInfo.name.."');")
						break
					end
				end
			end
			if url == "http://mta/local/groupMembers.html" then
				for i,v in ipairs(charGroups) do
					if v.groupInfo.UID == openedGroup then
						groupsWindow.browser:executeJavascript("$('#name').html('"..v.groupInfo.name.."');")
						triggerServerEvent("loadMembersOfGroup", localPlayer, openedGroup)
						break
					end
				end
			end
			if url == "http://mta/local/playerGroups.html" then
				if not localPlayer:getData("charInfo") then
					return
				end
				updateGroups()
			end
		end)
	end)
end)

function show()
	if not localPlayer:getData("charGroups") then
		groupsWindow.browser:loadURL("http://mta/local/playerGroups.html")
		exports.notifications:add("Nie jesteś członkiem żadnej grupy!", "danger", 5000)
		hide()
		return
	end
	groupsShow = true
	groupsWindow:setVisible(true)
	groupsWindow:bringToFront(true)
	showCursor(true, false)
	toggleControl("fire", false)
	if groupsWindow.browser.url == "http://mta/local/playerGroups.html" then
		updateGroups()
	end
end

function hide()
	groupsShow = false
	groupsWindow:setVisible(false)
	showCursor(false)
	toggleControl("fire", true)
end

function updateGroups()
	local charGroups = localPlayer:getData("charGroups") or {}
	groupsWindow.browser:executeJavascript("clearGroups();")
	for i,v in ipairs(charGroups) do
		groupsWindow.browser:executeJavascript("addGroup("..v.groupInfo.UID..",'"..v.groupInfo.name.."');")
	end
	groupsWindow.browser:executeJavascript("updateGroups();")
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
	if groupsWindow.browser:getURL() == "http://mta/local/playerGroups.html" then
		updateGroups()
	end
end)

addEvent("onMembersOfGroupLoaded", true)
addEventHandler("onMembersOfGroupLoaded", root, function(members, ranks)
	if groupsWindow.browser.url == "http://mta/local/groupMembers.html" then
		groupsWindow.browser:executeJavascript("cleanMembers();")
		for i,v in ipairs(members) do
			groupsWindow.browser:executeJavascript("addMember(".. v.UID ..", '".. exports.playerUtils:formatName(v.name) .."', ".. v.rank ..");")
		end
		groupsWindow.browser:executeJavascript("cleanRanks()")
		for i,v in ipairs(ranks) do
			groupsWindow.browser:executeJavascript("addRank(".. v.UID ..", '".. v.name .."');")
		end
		groupsWindow.browser:executeJavascript("updateMembers();")
	end
end)