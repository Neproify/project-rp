local offerWindow = nil
local showingInfo = false
local screenWidth, screenHeight = guiGetScreenSize()

addEventHandler("onClientResourceStart", resourceRoot, function()
	offerWindow = GuiBrowser(screenWidth / 2 - 200, screenHeight - 300, 400, 200, true, true, false)
	addEventHandler("onClientBrowserCreated", offerWindow.browser, function()
		offerWindow.browser:loadURL("http://mta/local/offerInfo.html")
		offerWindow.visible = false
	end)
end)

addEvent("onOffer", true)
addEventHandler("onOffer", root, function()
    local offerInfo = localPlayer:getData("offerInfo")
    offerWindow.browser:executeJavascript("$('#name').html('Oferta od: ".. exports.playerUtils:formatName(offerInfo.from.name) .."');")
    local description = string.format("Typ: %d, koszt: $%d", offerInfo.type, offerInfo.price)
    offerWindow.browser:executeJavascript("$('#description').html('".. description .."');")
    offerWindow.visible = true
    bindKey("[", "down", "o", "akceptuj")
    bindKey("]", "down", "o", "anuluj")
end)

addEvent("onOfferHide", true)
addEventHandler("onOfferHide", root, function()
    offerWindow.visible = false
    unbindKey("[", "down", "o")
    unbindKey("]", "down", "o")
end)