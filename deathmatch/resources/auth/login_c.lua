local loginWindow = nil
local screenWidth, screenHeight = guiGetScreenSize()

local processingLogin = false

addEventHandler("onClientResourceStart", resourceRoot, function()
	if localPlayer:getData("globalInfo") and localPlayer:getData("charInfo") then
		return
	end
	setPlayerHudComponentVisible("all", false)
	

	if not localPlayer:getData("charInfo") and localPlayer:getData("globalInfo") then
		triggerEvent("onLoginResult", localPlayer, {success = true})
		return
	end
	
	loginWindow = GuiBrowser(screenWidth / 2 - 150, screenHeight / 2 - 100, 300, 200, true, true, false)
	addEventHandler("onClientBrowserCreated", loginWindow, function()
		addEventHandler("onClientBrowserDocumentReady", root, function(url)
			if url ~= "http://mta/local/login.html" then return end
			Camera.fade(true)
			Camera.setMatrix(1489.8495, -1690.1045, 14.5469, 1484.8495, -1694.1045, 14.5469)
			showChat(false)
			showCursor(true)
			guiSetInputEnabled(true)
			loginWindow:bringToFront(true)
			addEvent("onLoginForm", true)
			addEventHandler("onLoginForm", loginWindow:getBrowser(), function(login, password)
				if processingLogin == true then
					return
				end
				processingLogin = true
				triggerServerEvent("onLoginRequest", root, login, password)
			end)
		end)
		loginWindow:getBrowser():loadURL("http://mta/local/login.html")
	end)
end)

addEvent("onLoginResult", true)
addEventHandler("onLoginResult", root, function(result)
	processingLogin = false
	if not result.success then
		exports.notifications:add(result.message, "danger", 5000)
		return
	end
	if loginWindow then loginWindow:destroy() end
	exports.notifications:add(result.message, "success", 5000)
	triggerServerEvent("fetchCharacters", root)
end)