local screenWidth, screenHeight = guiGetScreenSize()

function showInteractionCircle()
	dxDrawCircle(screenWidth / 2, screenHeight / 2 - 150, 6, 1.5, 0.2, 0, 360, tocolor(180, 0, 0))
end

function showInteraction()
	addEventHandler("onClientRender", root, showInteractionCircle)
end

function endInteraction()
	removeEventHandler("onClientRender", root, showInteractionCircle)
	x, y, z = getCameraMatrix()
	x2, y2, z2 = getWorldFromScreenPosition(screenWidth / 2, screenHeight / 2 - 150, 10)
	hit, hitX, hitY, hitZ, hitElement, normalX, normalY, normalZ, material, lighting, piece = processLineOfSight(x, y, z, x2, y2, z2 - 1.5, true, true, true, true, true, true, false, true, localPlayer, false, true)
	if hit then
		if hitElement then
			if hitElement.type == "vehicle" then
				if piece == 2 then -- bagażnik
					if hitElement:getDoorOpenRatio(1) > 0 then
						if not hitElement.locked then
							hitElement:setDoorOpenRatio(1, 0, 1000)
						end
					else
						if not hitElement.locked then
							hitElement:setDoorOpenRatio(1, 1, 1000)
						end
					end
				elseif piece == 3 then -- maska
					if hitElement:getDoorOpenRatio(0) > 0 then
						if not hitElement.locked then
							hitElement:setDoorOpenRatio(0, 0, 1000)
						end
					else
						if not hitElement.locked then
							hitElement:setDoorOpenRatio(0, 1, 1000)
						end
					end
				end
			elseif hitElement.type == "object" then
				if hitElement:getData("itemInfo") then -- przedmiot
					local itemInfo = hitElement:getData("itemInfo")
					triggerServerEvent("pickItemByPlayer", localPlayer, itemInfo.UID)
				end
			end
		end
	end
end

bindKey("z", "down", showInteraction)
bindKey("z", "up", endInteraction)

--funkcja do rysowania "kółek"

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