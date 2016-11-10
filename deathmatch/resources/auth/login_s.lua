local db = exports.db

addEvent("onLoginRequest", true)
addEventHandler("onLoginRequest", root, function(login, password)
	if not client then
		return
	end

	local result = {}

	if not login or not password or login == "" or password == "" then
		local result = {}
		result.success = false
		result.message = "Musisz podać login i hasło!"
		triggerClientEvent(client, "onLoginResult", root, result)
		return
	end
	
	local globalInfoTemp = db:fetchOne("SELECT * FROM `ipb_core_members` WHERE `name`=? LIMIT 1;", login)
	
	if not globalInfoTemp then
		result.success = false
		result.message = "Podane konto nie istnieje w bazie danych. Sprawdź czy wpisany login jest poprawny."
		triggerClientEvent(client, "onLoginResult", root, result)
		return
	end
	
	if not bcrypt_verify(password, globalInfoTemp["members_pass_hash"]) then
		result.success = false
		result.message = "Podałeś nieprawidłowy login i/lub hasło."
		triggerClientEvent(client, "onLoginResult", root, result)
		exports.logs:addLog(exports.logs:getLogTypes().auth, client.ip, globalInfoTemp["member_id"], -1, "0")
		return
	end

	local globalInfo = {}
	globalInfo["UID"] = globalInfoTemp["member_id"]
	globalInfo["name"] = globalInfoTemp["name"]
	globalInfo["score"] = globalInfoTemp["game_score"]
	globalInfo["admin"] = globalInfoTemp["game_admin"]
	globalInfo["adminPermissions"] = globalInfoTemp["game_admin_permissions"]
	if isPlayerAlreadyLogged(globalInfo["UID"]) then -- zabezpieczenie przed logowaniem na jedno konto przez kilka osób
		client:kick("Próba logowania na jedno konto przez kilka osób.")
		exports.logs:addLog(exports.logs:getLogTypes().auth, client.ip, globalInfoTemp["member_id"], -1, "2")
		return
	end
	client:setData("globalInfo", globalInfo)
	result.success = true
	result.message = "Zalogowałeś się na swoje konto. Wybierz postać."
	triggerClientEvent(client, "onLoginResult", root, result)
	exports.logs:addLog(exports.logs:getLogTypes().auth, client.ip, globalInfoTemp["member_id"], -1, "1")
	return
end)

function isPlayerAlreadyLogged(gID)
	for i,v in ipairs(Element.getAllByType("player")) do
		local globalInfo = v:getData("globalInfo")
		if globalInfo then
			if globalInfo["UID"] == gID then
				return true
			end
		end
	end
	return false
end