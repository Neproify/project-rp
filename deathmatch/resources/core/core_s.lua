addEventHandler("onResourceStart", resourceRoot, function()
	local realtime = getRealTime()
 
    setTime(realtime.hour, realtime.minute)
    setMinuteDuration(60000)

    for i,v in ipairs(getElementsByType("player")) do
		v.nametagShowing = false
	end
end)

addEventHandler("onPlayerJoin", root, function()
	source.nametagShowing = false
end)