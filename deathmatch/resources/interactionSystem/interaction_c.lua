local screenWidth, screenHeight = guiGetScreenSize()

local selectedElement = nil
local interactionActive = false
local interactionWindow = nil

addEventHandler("onClientResourceStart", resourceRoot, function()
	interactionWindow = GuiBrowser(0, 0, screenWidth, screenHeight, true, true, false)
	addEventHandler("onClientBrowserCreated", interactionWindow, function()
		interactionWindow:getBrowser():loadURL("http://mta/local/interaction.html")
		guiSetVisible(interactionWindow, interactionActive)
		bindKeysForPointer()
	end)
end)

function drawPointer()
	dxDrawCircle(screenWidth / 2, screenHeight / 2, 1, 3, 1, 0, 360, tocolor(255, 0, 0))
end

function interactionShowPointer()
	selectedElement = nil
	addEventHandler("onClientRender", root, drawPointer)
end

function interactionGetElement()
	removeEventHandler("onClientRender", root, drawPointer)
	getNearbyElementForInteraction()
	if not selectedElement then
		return
	end
	interactionActive = true
	guiSetVisible(interactionWindow, interactionActive)
	showCursor(true)
	bindKeysForMenu()
end

function cancelInteraction()
	interactionActive = false
	guiSetVisible(interactionWindow, interactionActive)
	bindKeysForPointer()
	showCursor(false)
end

function bindKeysForPointer()
	unbindKey("mouse2", "down", cancelInteraction)

	bindKey("1", "down", interactionShowPointer)
	bindKey("1", "up", interactionGetElement)
end

function bindKeysForMenu()
	unbindKey("1", "down", interactionShowPointer)
	unbindKey("1", "up", interactionGetElement)
	
	bindKey("mouse2", "down", cancelInteraction)
end

function getNearbyElementForInteraction()
	local px, py, pz = getCameraMatrix()
	local tx, ty, tz = getWorldFromScreenPosition(screenWidth / 2, screenHeight / 2, 10)
	hit, x, y, z, elementHit = processLineOfSight(px, py, pz, tx, ty, tz, true, true, true, true, true, false, false, false, localPlayer)
	if hit then
		if elementHit then
			selectedElement = elementHit
		else
			return false
		end
	else
		return false
	end
end

function dxDrawCircle( posX, posY, radius, width, angleAmount, startAngle, stopAngle, color, postGUI )
	if ( type( posX ) ~= "number" ) or ( type( posY ) ~= "number" ) then
		return false
	end
 
	local function clamp( val, lower, upper )
		if ( lower > upper ) then lower, upper = upper, lower end
		return math.max( lower, math.min( upper, val ) )
	end
 
	radius = type( radius ) == "number" and radius or 50
	width = type( width ) == "number" and width or 5
	angleAmount = type( angleAmount ) == "number" and angleAmount or 1
	startAngle = clamp( type( startAngle ) == "number" and startAngle or 0, 0, 360 )
	stopAngle = clamp( type( stopAngle ) == "number" and stopAngle or 360, 0, 360 )
	color = color or tocolor( 255, 255, 255, 200 )
	postGUI = type( postGUI ) == "boolean" and postGUI or false
 
	if ( stopAngle < startAngle ) then
		local tempAngle = stopAngle
		stopAngle = startAngle
		startAngle = tempAngle
	end
 
	for i = startAngle, stopAngle, angleAmount do
		local startX = math.cos( math.rad( i ) ) * ( radius - width )
		local startY = math.sin( math.rad( i ) ) * ( radius - width )
		local endX = math.cos( math.rad( i ) ) * ( radius + width )
		local endY = math.sin( math.rad( i ) ) * ( radius + width )
 
		dxDrawLine( startX + posX, startY + posY, endX + posX, endY + posY, color, width, postGUI )
	end
 
	return true
end