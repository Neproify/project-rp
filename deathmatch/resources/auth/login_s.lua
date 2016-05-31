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
	
	local globalInfoTemp = db:fetch("SELECT * FROM `forum_users` WHERE `username`=? LIMIT 1;", login)
	globalInfoTemp = globalInfoTemp[1]
	
	if not globalInfoTemp then
		result.success = false
		result.message = "Podane konto nie istnieje w bazie danych. Sprawdź czy wpisany login jest poprawny."
		triggerClientEvent(client, "onLoginResult", root, result)
		return
	end
	
	if not bcrypt_verify(password, globalInfoTemp["password"]) then
		result.success = false
		result.message = "Podałeś nieprawidłowy login i/lub hasło."
		triggerClientEvent(client, "onLoginResult", root, result)
		return
	end

	local globalInfo = {}
	globalInfo["UID"] = globalInfoTemp["id"]
	globalInfo["name"] = globalInfoTemp["username"]
	globalInfo["score"] = globalInfoTemp["score"]
	globalInfo["admin"] = globalInfoTemp["admin"]
	globalInfo["permissions"] = globalInfoTemp["permissions"]
	client:setData("globalInfo", globalInfo)
	result.success = true
	result.message = "Zalogowałeś się na swoje konto. Wybierz postać."
	triggerClientEvent(client, "onLoginResult", root, result)
	return
end)