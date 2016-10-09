local notificationsWindow = nil
local screenWidth, screenHeight = guiGetScreenSize()

addEventHandler("onClientResourceStart", resourceRoot, function()

	notificationsWindow = GuiBrowser(screenWidth / 2 - 300, 0, 600, 400, true, true, false)
	addEventHandler("onClientBrowserCreated", notificationsWindow.browser, function()
		notificationsWindow.browser:loadURL("http://mta/local/notifications.html")
	end)
end)

function add(msg, msgType, msgDelay)
	if not msg then
		return
	end
	if not msgType then
		msgType = "info"
	end
	if not msgDelay then
		msgDelay = 5000
	end
	notificationsWindow.browser:executeJavascript("addNotification('"..msg.."','"..msgType.."', "..msgDelay..");")
end

addEvent("notifications:add", true)
addEventHandler("notifications:add", root, function(msg, msgType, msgDelay)
	add(msg, msgType, msgDelay)
end)