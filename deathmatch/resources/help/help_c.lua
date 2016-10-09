local helpWindow = nil
local screenWidth, screenHeight = guiGetScreenSize()

local isGUIReady = false

addEventHandler("onClientResourceStart", resourceRoot, function()
	helpWindow = GuiBrowser(screenWidth / 2 - 250, screenHeight / 2 - 250, 500, 500, true, true, false)
	addEventHandler("onClientBrowserCreated", helpWindow.browser, function()
		helpWindow.browser:loadURL("http://mta/local/help.html")
		helpWindow:setVisible(false)
		addEventHandler("onClientBrowserDocumentReady", helpWindow.browser, function(url)
			bindKey("F1", "down", toggleHelp)
		end)
	end)
end)

function toggleHelp()
    if helpWindow.visible == false then
	    helpWindow:setVisible(true)
		addEventHandler("onClientKey", root, onKey)
    else
        helpWindow:setVisible(false)
		removeEventHandler("onClientKey", root, onKey)
    end
end

function onKey(button)
	if button == "mouse_wheel_down" then
		helpWindow.browser:injectMouseWheel(-40, 0)
	elseif button == "mouse_wheel_up" then
		helpWindow.browser:injectMouseWheel(40, 0)
	end
end