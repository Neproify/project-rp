local phoneWindow = nil
local screenWidth, screenHeight = guiGetScreenSize()
local showPhone = false

addEventHandler("onClientResourceStart", resourceRoot, function()
	phoneWindow = GuiBrowser(screenWidth / 2 - 270 , 0, 540, 1100, true, true, false)
	addEventHandler("onClientBrowserCreated", phoneWindow, function()
        phoneWindow:getBrowser():loadURL("http://mta/local/phone.html")
        guiSetVisible(phoneWindow, showPhone)
	end)
end)

function show()
	showPhone = true
    guiSetVisible(phoneWindow, true)
    showCursor(true)
    toggleControl("fire", false)
end

function hide()
	showPhone = false
	guiSetVisible(phoneWindow, false)
	showCursor(false)
	toggleControl("fire", true)
end

function toggle()
	if showPhone then
		hide()
	else
		show()
	end
end
bindKey("end", "down", toggle)