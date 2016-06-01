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

addEventHandler("onPlayerQuit", root, function()
	 local charInfo = source:getData("charInfo")
	 if not charInfo then return end -- nie zalogowany, nic nie robimy :)
	 exports.db:query("UPDATE `rp_characters` SET `skin`=? `money`=?, `health`=? WHERE `UID`=?", charInfo["skin"],
	 source.money, source.health, charInfo["UID"])
end)