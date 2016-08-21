local font = nil

addEventHandler("onClientResourceStart", resourceRoot, function()
	if localPlayer:getData("charInfo") then
		font = exports.fonts:getFont("Lato-Regular.ttf", 12, false, "antialiased")
		addEventHandler("onClientRender", root, drawNews)
	end
	addEventHandler("onCharacterSelected", root, function()
		font = exports.fonts:getFont("Lato-Regular.ttf", 12, false, "antialiased")
		addEventHandler("onClientRender", root, drawNews)
	end)
end)

function drawNews()
	local screenWidth, screenHeight = guiGetScreenSize()
	local newsText = root:getData("newsText")
	dxDrawRectangle(5, screenHeight - font:getHeight() - 10, screenWidth - 10, font:getHeight(), tocolor(0, 0, 0, 128))
	dxDrawText(newsText, 10, screenHeight - font:getHeight() - 10, screenWidth - 15, screenHeight - 5, 
		tocolor(255, 255, 255), 1, font)
end