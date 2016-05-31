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

	local salt = db:fetch("SELECT `salt` FROM `mybb_users` WHERE `username`=? LIMIT 1;", login)
	salt = salt[1]["salt"]
	if not salt then
		result.success = false
		result.message = "Podane konto nie istnieje w bazie danych. Sprawdź czy wpisany login jest poprawny."
		triggerClientEvent(client, "onLoginResult", root, result)
		return
	end

	local globalInfoTemp = db:fetch("SELECT `uid`, `username`, `score`, `admin`, `permissions` FROM `mybb_users` WHERE `username`=? AND `password`=md5(CONCAT(md5(?),md5(?))) LIMIT 1;", login, salt, password)
	globalInfoTemp = globalInfoTemp[1]
	if not globalInfoTemp then
		result.success = false
		result.message = "Podałeś nieprawidłowy login i/lub hasło."
		triggerClientEvent(client, "onLoginResult", root, result)
		return
	end

	local globalInfo = {}
	globalInfo["UID"] = globalInfoTemp["uid"]
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