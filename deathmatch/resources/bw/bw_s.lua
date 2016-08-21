addEventHandler("onPlayerWasted", root, function()
	source:spawn(source.position, 0, source.model, source.interior, source.dimension)
	source:setData("bw", getTickCount() + (1000 * 60 * 5))
	source:setAnimation("ped", "BIKE_fall_off", -1, false)
	source.health = 5
	exports.notifications:add(source, "Straciłeś przytomność. Odzyskasz ją za 5 minut...", "info", 5000)
end)

function timerFunction()
	for i, v in ipairs(Element.getAllByType("player")) do
		if v:getData("bw") then
			if v:getData("bw") < getTickCount() then
				unBWPlayer(v)
			end
		end
	end
end
Timer(timerFunction, 30000, 0)

function unBWPlayer(player)
	player:setData("bw", nil)
	exports.notifications:add(player, "Odzyskałeś przytomność. Pamiętaj o odegraniu obrażeń.", "info", 5000)
	player:setAnimation(false)
end