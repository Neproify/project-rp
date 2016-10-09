local scoreboardWindow = nil
local screenWidth, screenHeight = guiGetScreenSize()

local isGUIReady = false

addEventHandler("onClientResourceStart", resourceRoot, function()
	scoreboardWindow = GuiBrowser(screenWidth / 2 - 250, screenHeight / 2 - 250, 500, 500, true, true, false)
	addEventHandler("onClientBrowserCreated", scoreboardWindow.browser, function()
		scoreboardWindow.browser:loadURL("http://mta/local/scoreboard.html")
		scoreboardWindow:setVisible(false)
		addEventHandler("onClientBrowserDocumentReady", scoreboardWindow.browser, function(url)
			reloadScoreboard()
			Timer(reloadScoreboard, 5000, 0)
			bindKey("tab", "down", showScoreboard)
			bindKey("tab", "up", hideScoreboard)
		end)
	end)
end)

function reloadScoreboard()
	scoreboardWindow.browser:executeJavascript("clearPlayers();")
	for i,v in ipairs(Element.getAllByType("player")) do
		scoreboardWindow.browser:executeJavascript("addPlayer(".. v:getData("ID") ..",'".. exports.playerUtils:formatName(v.name) .."');")
	end
	scoreboardWindow.browser:executeJavascript("updatePlayers();")
end

function showScoreboard()
	scoreboardWindow:setVisible(true)
	addEventHandler("onClientKey", root, onKey)
end

function hideScoreboard()
	scoreboardWindow:setVisible(false)
	removeEventHandler("onClientKey", root, onKey)
end

function onKey(button)
	if button == "mouse_wheel_down" then
		scoreboardWindow.browser:injectMouseWheel(-40, 0)
	elseif button == "mouse_wheel_up" then
		scoreboardWindow.browser:injectMouseWheel(40, 0)
	end
end