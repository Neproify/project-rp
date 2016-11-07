addCommandHandler("przetrzymaj", function(player, cmd, arg1)
    if not isOnDutyOfType(player, groupType.police) then
        exports.notifications:add(player, "Nie masz uprawnień do tej komendy!", "danger", 3000)
        return
    end

    local building = exports.buildings:getPlayerCurrentBuilding(player)

    if not building then
        exports.notifications:add(player, "Nie znajdujesz się w żadnym budynku!", "danger", 3000)
        return
    end

    local buildingInfo = building:getData("buildingInfo")
    local groupDutyInfo = player:getData("groupDutyInfo")

    if buildingInfo.ownerType ~= 2 then
        exports.notifications:add(player, "Ten budynek nie należy do żadnej grupy!", "danger", 3000)
        return
    end

    if groupDutyInfo.UID ~= buildingInfo.owner then
        exports.notifications:add(player, "Grupa na której jesteś służbie nie jest właścicielem tego budynku!", "danger", 4000)
        return
    end

    if not arg1 then
        exports.notifications:add(player, "Użyj: /przetrzymaj [gracz]")
        return
    end

    local targetPlayer = exports.playerUtils:getByID(tonumber(arg1))
    if not targetPlayer then
        exports.notifications:add(player, "Nie znaleziono gracza o podanym ID!", "danger", 3000)
        return
    end

    if getDistanceBetweenPoints3D(player.position, targetPlayer.position) > 5 or player.dimension ~= targetPlayer.dimension then
        exports.notifications:add(player, "Gracz nie znajduje się obok ciebie!", "danger", 3000)
        return
    end

    local charInfo = targetPlayer:getData("charInfo")
    if charInfo.jailBuilding then
        charInfo.jailX = nil
        charInfo.jailY = nil
        charInfo.jailZ = nil
        charInfo.jailBuilding = nil
        targetPlayer:setData("charInfo", charInfo)
        exports.notifications:add(player, "Uwolniłeś gracza z budynku.")
        exports.notifications:add(targetPlayer, "Nie jesteś już przetrzymywany w tym budynku.")
        return
    end

    charInfo.jailX = targetPlayer.position.x
    charInfo.jailY = targetPlayer.position.y
    charInfo.jailZ = targetPlayer.position.z
    charInfo.jailBuilding = buildingInfo.UID
    targetPlayer:setData("charInfo", charInfo)

    exports.notifications:add(player, "Przetrzymujesz gracza w tym budynku.")
    exports.notifications:add(targetPlayer, "Jesteś przetrzymywany w tym budynku.")
end)