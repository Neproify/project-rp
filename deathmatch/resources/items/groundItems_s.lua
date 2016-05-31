local db = exports.db

function loadGroundItems()
	local groundItems = db:fetch("SELECT * FROM `rp_items` WHERE `ownertype`=2")
	for i,v in ipairs(groundItems) do
		loadGroundItem(v.UID)
	end
end
addEventHandler("onResourceStart", resourceRoot, loadGroundItems)

function loadGroundItem(UID)
	local itemInfo = db:fetch("SELECT * FROM `rp_items` WHERE `UID`=?", UID)
	itemInfo = itemInfo[1]
	if not itemInfo then
		return
	end
	local item = Object(getItemObject(itemInfo.UID), Vector3(itemInfo.posX, itemInfo.posY, itemInfo.posZ), Vector3(0, 0, 0), false)
	item:setData("itemInfo", itemInfo)
end

function getItemObject(UID)
	local itemInfo = getItemInfo(UID)
	if not itemInfo then
		return false
	end
	local properties = explodeProperties(itemInfo.properties)
	local objectModel = false
	if itemInfo.type == 1 then -- broń
		--[[if tonumber(properties[1]) == 1 then
			objectModel = 331
		elseif tonumber(properties[1]) == 2 then
			objectModel = 333
		elseif tonumber(properties[1]) == 3 then
			objectModel = 334
		elseif tonumber(properties[1]) == 4 then
			objectModel = 335
		elseif tonumber(properties[1]) == 5 then
			objectModel = 336
		elseif tonumber(properties[1]) == 6 then
			objectModel = 337
		elseif tonumber(properties[1]) == 7 then
			objectModel = 338
		elseif tonumber(properties[1]) == 8 then
			objectModel = 339
		elseif tonumber(properties[1]) == 9 then
			objectModel = 341
		elseif tonumber(properties[1]) == 10 then
			objectModel = 321
		elseif tonumber(properties[1]) == 11 then
			objectModel = 322
		elseif tonumber(properties[1]) == 12 then
			objectModel = 323
		elseif tonumber(properties[1]) == 14 then
			objectModel = 325
		elseif tonumber(properties[1]) == 15 then
			objectModel = 326
		elseif tonumber(properties[1]) == 16 then
			objectModel = 342
		elseif tonumber(properties[1]) == 17 then
			objectModel = 343
		elseif tonumber(properties[1]) == 18 then
			objectModel = 344
		elseif tonumber(properties[1]) == 22 then
			objectModel = 346
		elseif tonumber(properties[1]) == 23 then
			objectModel = 347
		elseif tonumber(properties[1]) == 24 then
			objectModel = 348
		elseif tonumber(properties[1]) == 25 then
			objectModel = 349
		elseif tonumber(properties[1]) == 26 then
			objectModel = 350
		elseif tonumber(properties[1]) == 27 then
			objectModel = 351
		elseif tonumber(properties[1]) == 28 then
			objectModel = 352
		elseif tonumber(properties[1]) == 29 then
			objectModel = 353
		elseif tonumber(properties[1]) == 30 then
			objectModel = 355
		elseif tonumber(properties[1]) == 31 then
			objectModel = 356
		elseif tonumber(properties[1]) == 32 then
			objectModel = 372
		elseif tonumber(properties[1]) == 33 then
			objectModel = 357
		elseif tonumber(properties[1]) == 34 then
			objectModel = 358
		elseif tonumber(properties[1]) == 35 then
			objectModel = 359
		elseif tonumber(properties[1]) == 36 then
			objectModel = 360
		elseif tonumber(properties[1]) == 37 then
			objectModel = 361
		elseif tonumber(properties[1]) == 38 then
			objectModel = 362
		elseif tonumber(properties[1]) == 39 then
			objectModel = 363
		elseif tonumber(properties[1]) == 40 then
			objectModel = 364
		elseif tonumber(properties[1]) == 41 then
			objectModel = 365
		elseif tonumber(properties[1]) == 42 then
			objectModel = 366
		elseif tonumber(properties[1]) == 43 then
			objectModel = 367
		elseif tonumber(properties[1]) == 44 then
			objectModel = 368
		elseif tonumber(properties[1]) == 45 then
			objectModel = 369
		elseif tonumber(properties[1]) == 46 then
			objectModel = 371
		end-]]
		objectModel = 3014
	elseif itemInfo.type == 2 then -- todo
		objectModel = 3016
	elseif itemInfo.type == 3 then
		objectModel = 3016
	end
	return objectModel
end