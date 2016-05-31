local loginPed = nil
local selectedChar = 1

local charInfoWindow = nil
local screenWidth, screenHeight = guiGetScreenSize()

addEvent("onCharactersFetched", true)
addEventHandler("onCharactersFetched", root, function()
	charInfoWindow = GuiBrowser(0, screenHeight - 200, 300, 200, true, true, false)
	addEventHandler("onClientBrowserCreated", charInfoWindow, function()
		charInfoWindow:getBrowser():loadURL("http://mta/local/charInfo.html")
		addEvent("previousCharacter", true)
		addEventHandler("previousCharacter", charInfoWindow:getBrowser(), function()
			previousChar()
		end)
		addEvent("selectCharacter", true)
		addEventHandler("selectCharacter", charInfoWindow:getBrowser(), function()
			selectChar()
		end)
		addEvent("nextCharacter", true)
		addEventHandler("nextCharacter", charInfoWindow:getBrowser(), function()
			nextChar()
		end)
		addEventHandler("onClientBrowserDocumentReady", charInfoWindow:getBrowser(), function()
			local characters = localPlayer:getData("characters")
			loginPed = createPed(characters[1]["skin"], 1484.8495, -1694.1045, 15.0469)
			loginPed.dimension = localPlayer:getData("ID") + 500000
			localPlayer.dimension = loginPed.dimension
			Camera.setMatrix(1484.8495, -1690.1045, 14.5469, 1484.8495, -1694.1045, 14.5469)
			updateCharInfo()
		end)
	end)
end)

function previousChar()
	local characters = localPlayer:getData("characters")
	selectedChar = selectedChar - 1
	if selectedChar < 1 then
		selectedChar = #characters
	end
	updateCharInfo()
end

function nextChar()
	local characters = localPlayer:getData("characters")
	selectedChar = selectedChar + 1
	if selectedChar > #characters then
		selectedChar = 1
	end
	updateCharInfo()
end

function selectChar()
	local characters = localPlayer:getData("characters")
	triggerServerEvent("selectCharacter", localPlayer, characters[selectedChar]["UID"])
end

function updateCharInfo()
	local characters = localPlayer:getData("characters")
	loginPed:setModel(characters[selectedChar]["skin"])
	charInfoWindow:getBrowser():executeJavascript("$('#charName').html('"..exports.playerUtils:formatName(characters[selectedChar]["name"]).."');")
	charInfoWindow:getBrowser():executeJavascript("$('#charMoney b').html('$"..characters[selectedChar]["money"].."');")
	charInfoWindow:getBrowser():executeJavascript("$('#charHealth b').html('"..characters[selectedChar]["health"].."');")
end

addEvent("onCharacterSelected", true)
addEventHandler("onCharacterSelected", root, function()
	local charInfo = localPlayer:getData("charInfo")
	local globalInfo = localPlayer:getData("globalInfo")
	if not charInfo then
		return
	end
	unbindKey("arrow_l", "down", previousChar)
	unbindKey("arrow_r", "down", nextChar)
	unbindKey("enter", "down", selectChar)
	loginPed:destroy()
	-- spawnujemy gracza, itd.
	localPlayer:setData("characters", nil)
	exports.chat:clearChat()
	if charInfoWindow then
		charInfoWindow:destroy()
	end
	showCursor(false)
	guiSetInputEnabled(false)
	showChat(true)
	showPlayerHudComponent("all", true)
	triggerServerEvent("spawnPlayer", localPlayer)
end)