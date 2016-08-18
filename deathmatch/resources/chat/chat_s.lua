addEventHandler("onPlayerChat", root, function(msg, msgType)
	cancelEvent()
	local charInfo = source:getData("charInfo")
	local globalInfo = source:getData("globalInfo")
	if not charInfo then
		return
	end
	msg = string.gsub(msg, "#%x%x%x%x%x%x", "")
	if msgType == 0 then -- normalny chat
		local pos = source.position
		local chatSphere = ColShape.Sphere(pos, 15)
		local nearbyPlayers = chatSphere:getElementsWithin("player")
		for text in string.gmatch(msg, "%b<>") do
			msg = string.gsub(msg, text, "#C2A2DA*".. string.gsub(string.gsub(text, ">", ""), "<", "") .. "*#FFFFFF")
		end
		local name = exports.playerUtils:formatName(source.name)
		for i,v in ipairs(nearbyPlayers) do
			v:outputChat("#FFFFFF"..name.." mówi: "..msg, 0, 0, 0, true)
		end
	elseif msgType == 1 then -- /me
		me(source, msg)
	end
end)

function outputMe(player, text)
	local chatSphere = ColShape.Sphere(player.position, 20)
	local nearbyPlayers = chatSphere:getElementsWithin("player")
	local name = exports.playerUtils:formatName(player.name)
	for i,v in ipairs(nearbyPlayers) do
		v:outputChat("#C2A2DA* "..name.." "..text, 0, 0, 0, true)
	end
end

function outputOOC(player, text)
	local chatSphere = ColShape.Sphere(player.position, 15)
	local nearbyPlayers = chatSphere:getElementsWithin("player")
	local name = exports.playerUtils:formatName(player.name)
	for i,v in ipairs(nearbyPlayers) do
		v:outputChat("#FFFFFF(("..name.."("..player:getData("ID").."): "..text.."))", 0, 0, 0, true)
	end
end

function outputDo(player, text)
	local chatSphere = ColShape.Sphere(player.position, 20)
	local nearbyPlayers = chatSphere:getElementsWithin("player")
	local name = exports.playerUtils:formatName(player.name)
	for i,v in ipairs(nearbyPlayers) do
		v:outputChat("#9A9CCD* "..text.. " (("..name.."))", 0, 0, 0, true)
	end
end

addCommandHandler("OOC", function(player, cmd, ...)
	local msg = {...}
	msg = table.concat(msg, " ")
	outputOOC(player, msg)
end)

addCommandHandler("do", function(player, cmd, ...)
	local msg = {...}
	msg = table.concat(msg, " ")
	outputDo(player, msg)
end)

addCommandHandler("sprobuj", function(player, cmd, ...)
	local msg = {...}
	msg = table.concat(msg, " ")
	local pos = player.position
	local chatSphere = ColShape.Sphere(pos, 15)
	local nearbyPlayers = chatSphere:getElementsWithin("player")
	local name = exports.playerUtils:formatName(player.name)
	local random = math.random(1, 2)
	if random == 1 then -- nie
		for i,v in ipairs(nearbyPlayers) do
			v:outputChat("#C2A2DA* "..name.." poległ próbując "..msg, 0, 0, 0, true)
		end
	elseif random == 2 then
		for i,v in ipairs(nearbyPlayers) do
			v:outputChat("#C2A2DA* "..name.." odniósł sukces próbując "..msg, 0, 0, 0, true)
		end
	end
end)

addCommandHandler("w", function(player, cmd, id, ...)
	if not id then return end
	id = tonumber(id)
	local msg = {...}
	msg = table.concat(msg, " ")
	local target = nil
	for i,v in ipairs(Element.getAllByType("player")) do
		if v:getData("ID") == id then
			target = v
			break
		end
	end
	if not target then return end
	player:outputChat("#99FFAA(( << ".. target.name .."(".. target:getData("ID") .."): ".. msg .. "))", 255, 0, 0, true)
	target:outputChat("#78DEAA(( >> ".. player.name .."(".. player:getData("ID") .."): ".. msg .. "))", 255, 0, 0, true)
end)

addCommandHandler("k", function(player, cmd, ...)
	local msg = {...}
	msg = table.concat(msg, " ")
	local chatSphere = ColShape.Sphere(player.position, 20)
	local nearbyPlayers = chatSphere:getElementsWithin("player")
	local name = exports.playerUtils:formatName(player.name)
	for i,v in ipairs(nearbyPlayers) do
		v:outputChat("#FFFFFF".. name .. " krzyczy: ".. msg, 0, 0, 0, true)
	end
end)

addCommandHandler("s", function(player, cmd, ...)
	local msg = {...}
	msg = table.concat(msg, " ")
	local chatSphere = ColShape.Sphere(player.position, 5)
	local nearbyPlayers = chatSphere:getElementsWithin("player")
	local name = exports.playerUtils:formatName(player.name)
	for i,v in ipairs(nearbyPlayers) do
		v:outputChat("#FFFFFF".. name .. " szepcze: ".. msg, 0, 0, 0, true)
	end
end)

function Player:clearChat()
	local i = 0
	while i < 200 do
		self:outputChat("")
		i = i + 1
	end
end

-- clearChat export
function clearChat(plr)
	plr:clearChat()
end