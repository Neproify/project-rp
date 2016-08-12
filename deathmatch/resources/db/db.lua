local dbHandle

addEventHandler("onResourceStart", resourceRoot, function()
	dbHandle = Connection("mysql", "dbname="..dbName..";host="..dbAddress..";charset=utf8;", dbUser, dbPassword, "share=1")
	if dbHandle then
	else
		outputDebugLog("[DB] Error with database.")
	end
end)

function query(...)
	local qh = dbHandle:query(...)
	qh:free()
end

function fetch(...)
	local qh = dbHandle:query(...)
	local result, num_affected_rows, last_insert_id = qh:poll(-1)
	return result, num_affected_rows, last_insert_id
end

function fetchOne(...)
	local qh = dbHandle:query(...)
	local result, num_affected_rows, last_insert_id = qh:poll(-1)
	return result[1], num_affected_rows, last_insert_id
end

function getPrefix(type)
	if type == "game" then
		return dbGamePrefix
	elseif type == "forum" then
		return dbForumPrefix
	else
	end
end