local loginWindow = nil
local screenWidth, screenHeight = guiGetScreenSize()

addEventHandler("onClientResourceStart", resourceRoot, function()
	if localPlayer:getData("globalInfo") and localPlayer:getData("charInfo") then
		return
	end
	setPlayerHudComponentVisible("all", false)

	if not localPlayer:getData("charInfo") and localPlayer:getData("globalInfo") then
		triggerEvent("onLoginResult", localPlayer, {success = true})
		return
	end

	loginWindow = GuiBrowser(screenWidth / 2 - 150, screenHeight / 2 - 150, 300, 300, true, true, false)
	addEventHandler("onClientBrowserCreated", loginWindow, function()
		loginWindow:getBrowser():loadURL("http://mta/local/login.html")
		Camera.fade(true)
		Camera.setMatrix(1489.8495, -1690.1045, 14.5469, 1484.8495, -1694.1045, 14.5469)
		showChat(false)
		showCursor(true)
		guiSetInputEnabled(true)
		addEvent("onLoginForm", true)
		addEventHandler("onLoginForm", loginWindow:getBrowser(), function(login, password)
			triggerServerEvent("onLoginRequest", root, login, password)
		end)
	end)
end)

addEvent("onLoginResult", true)
addEventHandler("onLoginResult", root, function(result)
	if not result.success then
		exports.notifications:add(result.message, "danger", 5000)
		return
	end
	if loginWindow then loginWindow:destroy() end
	exports.notifications:add(result.message, "success", 5000)
	triggerServerEvent("fetchCharacters", root)
end)