local screenWidth, screenHeight = guiGetScreenSize()

--[[local licznik = dxCreateTexture("img/licznik.png")
local wskazowka = dxCreateTexture("img/needle.png")

addEventHandler("onClientRender", root, function()
	dxDrawImage(screenWidth - 512, screenHeight - 256, 512, 256, licznik)
	dxDrawImage(screenWidth - 256 - 32 - 90, screenHeight - 256 - 64 + 90, 64, 256, wskazowka, -90)
end)--]]

function toggleEngine()
	if localPlayer.vehicle and localPlayer.vehicleSeat == 0 then
		triggerServerEvent("toggleVehicleEngineByPlayer", localPlayer)
	end
end
bindKey("k", "down", toggleEngine)

function toggleLights()
	if localPlayer.vehicle and localPlayer.vehicleSeat == 0 then
		triggerServerEvent("toggleVehicleLightsByPlayer", localPlayer)
	end
end
bindKey("l", "down", toggleLights)

function toggleHandbrake()
	if localPlayer.vehicle and localPlayer.vehicleSeat == 0 then
		local velocity = localPlayer.vehicle.velocity
		local speed = (velocity.x ^ 2 + velocity.y ^ 2 + velocity.z ^ 2)^(0.5)
		speed = speed * 180 -- kilometry na godzinę
		if speed > 1 then
			return
		end
		triggerServerEvent("toggleVehicleHandbrakeByPlayer", localPlayer)
	end
end
bindKey("b", "down", toggleHandbrake)