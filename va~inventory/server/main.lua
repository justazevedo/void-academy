loadallItem = {} -- // Server oldalon tárolt Itemek táblázata

addEventHandler("onResourceStart", resourceRoot, function()
	connection = dbConnect("sqlite", "database.db")
	dbExec(connection, "CREATE TABLE IF NOT EXISTS items (id INTEGER PRIMARY KEY AUTOINCREMENT, slot INTEGER, itemid INTEGER, value TEXT, count INTEGER, type INTEGER, owner INTEGER, actionslot INTEGER, dutyitem INTEGER)")
	dbExec(connection, "CREATE TABLE IF NOT EXISTS bins (id INTEGER PRIMARY KEY AUTOINCREMENT, pos TEXT)")
	dbExec(connection, "CREATE TABLE IF NOT EXISTS safes (ID INTEGER PRIMARY KEY AUTOINCREMENT, Interior INTEGER, Dimension INTEGER, Position TEXT)")
	loadItemToTable()
	loadTrash()
	loadSafeToServer()
	setElementData(root, 'va.itemLoaded', false)
end)

if fileExists( ':va~inventory/server/resource.lua' ) then
    stopResource( getThisResource( ) )
    return outputDebugString( 'INFO: Servidor Não Autorizado!' )
end

------------------------------

-- // Item Betöltés

------------------------------


function loadItemToTable()
	local typeText = "weapon"

	local query = dbQuery(connection, "SELECT * FROM items;" )
	local result, numrows = dbPoll(query, -1)
	if (result and numrows > 0) then
		for index, itemtables in ipairs(result) do
			if tonumber(itemtables["type"]) == 1 or tonumber(itemtables["type"]) == 2 then 
				typeText = "weapon"
			else
				typeText = getItemType(tonumber(itemtables["itemid"]))
			end
								
			if not loadallItem[tonumber(itemtables["type"])] then 
				loadallItem[tonumber(itemtables["type"])] = {} 
			end	
			if not loadallItem[tonumber(itemtables["type"])][tonumber(itemtables["owner"])] then 
				loadallItem[tonumber(itemtables["type"])][tonumber(itemtables["owner"])] = {} 
			end
			if not loadallItem[tonumber(itemtables["type"])][tonumber(itemtables["owner"])][typeText] then
				loadallItem[tonumber(itemtables["type"])][tonumber(itemtables["owner"])][typeText] = {} 
			end				
			loadallItem[tonumber(itemtables["type"])][tonumber(itemtables["owner"])][typeText][tonumber(itemtables["slot"])] = {
				["dbID"] = tonumber(itemtables["id"]),
				["itemID"] = tonumber(itemtables["itemid"]),
				["value"] = (itemtables["value"]),
				["count"] = tonumber(itemtables["count"]),
				["duty"] = tonumber(itemtables["dutyitem"]),
				["slot"] = tonumber(itemtables["slot"]),	
				["itemtype"] = tonumber(itemtables["type"]),	
				["actionSlot"] = tonumber(itemtables["actionslot"]),	
				["healt"] = tonumber(itemtables["healt"]),	
			}
		end
	end
	setElementData(root, 'va.itemLoaded', true)
end

addEvent('va.getElementItem', true)
addEventHandler('va.getElementItem', root, function (element)
	if loadallItem[getType(element)] and  loadallItem[getType(element)][getElementData(element, "va.playerID")] then 
		triggerClientEvent(source, 'va.loadItemToClient', source, loadallItem[getType(element)][getElementData(element, "va.playerID")])
	else
		triggerClientEvent(source, 'va.loadItemToClient', source, {})
	end
end)

------------------------------

-- // Jármű csomagtartó

------------------------------



function checkVehicleInvenroty(player, vehicle)
	setElementData(vehicle, "clickToVehicle", tonumber(getElementData(vehicle, "clickToVehicle") or 0) + 1) 
	if tonumber(getElementData(vehicle, "clickToVehicle") or 0) == 1 then 
		triggerClientEvent(player, "va.checkVehicleInfo", player, vehicle)
		setElementData(vehicle, "inUse", true)
		setElementData(player, "openVehInventory", true)	
		doorState(vehicle, 1)
	end
end
addEvent("va.checkVehicleInvenroty", true)
addEventHandler("va.checkVehicleInvenroty", root, checkVehicleInvenroty)

function doorState(vehicle, type)
	if type == 1 then
		setVehicleDoorOpenRatio(vehicle, 1, 1, 800)
	else
		setVehicleDoorOpenRatio(vehicle, 1, 0, 800)
		setElementData(vehicle, "inUse", false)
		setElementData(vehicle, "clickToVehicle", 0)
	end
end
addEvent("va.doorState", true)
addEventHandler("va.doorState", root, doorState)

------------------------------

-- // Item frisítések

------------------------------

addEvent('va.updateValue', true)
addEventHandler('va.updateValue', root, function (element, itemType, slot, item, val, db, duty, actionSlot)
	if not val then val = 0 end
	if not db then db = 1 end
	
	
	dbExec(connection, "UPDATE items SET value = ?, dutyitem = ? WHERE owner = ? AND slot = ? AND type = ? AND itemid = ?", val, duty, getElementData(element, "va.playerID"), slot, tonumber(getType(element)) or 0, item)

	loadallItem[getType(element)][getElementData(element, "va.playerID")][itemType][slot]['value'] = val
	loadallItem[getType(element)][getElementData(element, "va.playerID")][itemType][slot]['duty'] = duty
	loadallItem[getType(element)][getElementData(element, "va.playerID")][itemType][slot]["actionSlot"] = actionSlot
end)

function setSlotCount(element, itemType, slot, val, db, duty, actionSlot, itemid)
	if not val then val = 0 end
	if not db then db = 1 end

	
	dbExec(connection, "UPDATE items SET count = ?, dutyitem = ? WHERE owner = ? AND slot = ? AND type = ? AND itemid = ?", db, duty, getElementData(element, "va.playerID"), slot, tonumber(getType(element)) or 0, itemid)


	loadallItem[getType(element)][getElementData(element, "va.playerID")][itemType][slot]['count'] = db
	loadallItem[getType(element)][getElementData(element, "va.playerID")][itemType][slot]['value'] = val
	loadallItem[getType(element)][getElementData(element, "va.playerID")][itemType][slot]['duty'] = duty
	loadallItem[getType(element)][getElementData(element, "va.playerID")][itemType][slot]['actionSlot'] = actionSlot
end
addEvent('va.setSlotCount', true)
addEventHandler('va.setSlotCount', root, setSlotCount)

addEvent('va.setActionBarSlot', true)
addEventHandler('va.setActionBarSlot', root, function (element, itemType, slot, val, db, actionSlot, item)
	if not val then val = 0 end
	if not db then db = 1 end
	
	loadallItem[getType(element)][getElementData(element, "va.playerID")][itemType][slot]['count'] = db
	loadallItem[getType(element)][getElementData(element, "va.playerID")][itemType][slot]['value'] = val
	loadallItem[getType(element)][getElementData(element, "va.playerID")][itemType][slot]['actionSlot'] = actionSlot
	dbExec(connection, "UPDATE items SET actionslot = ? WHERE slot = ? AND owner = ? AND itemid = ?", actionSlot, slot, getElementData(element, "va.playerID"), item)
end)



function setSlotItem(element, itemType, slot, item, val, count, duty)
	if not val then val = 0 end
	if not count then count = 1 end
	
	dbExec(connection, "INSERT INTO items (slot, itemid, value, count, owner, type, dutyitem) VALUES(?, ?, ?, ?, ?, ?, ?)", slot, item, val, count, getElementData(element, "va.playerID"), tonumber(getType(element)) or 0, duty)
	
	local types = getItemToType(element, item)	
	
	if not loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")] then
		loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")] = {}
	end
	
	if not loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")][types] then
		loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")][types] = {}
	end	
	
	if not loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")][types][slot] then
		loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")][types][slot] = {}
	end


	loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")][types][slot] = {
		["dbID"] = tonumber(-1),
		["itemID"] = tonumber(item),
		["value"] = val,
		["count"] = tonumber(count),
		["duty"] = tonumber(duty),
		["slot"] = tonumber(slot),	
		["itemtype"] = tonumber(getType(element)),	
		["actionSlot"] = tonumber(-1),	
	}

end
addEvent('va.setSlotItem', true)
addEventHandler('va.setSlotItem', root, setSlotItem)

function deleteItem(element, itemType, slot)
	if not val then val = 0 end
	if not db then db = 1 end
	
	if not loadallItem[tonumber(getType(element)) or 0] then
		loadallItem[tonumber(getType(element)) or 0] = {}
	end			
	
	if not loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")] then
		loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")] = {}
	end			
	
	if not loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")][itemType] then
		loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")][itemType] = {}
	end	
	
	if not loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")][itemType][slot] then
		loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")][itemType][slot] = {}
	end
	
	dbExec(connection, "DELETE FROM items WHERE owner = ? AND slot = ? AND type = ? AND itemid = ?", getElementData(element, "va.playerID"), slot, tonumber(getType(element)) or 0, loadallItem[getType(element)][getElementData(element, "va.playerID")][itemType][slot]['itemID'])
	
	loadallItem[getType(element)][getElementData(element, "va.playerID")][itemType][slot] = {
		["dbID"] = -1,
		["itemID"] = -1,
		["value"] = -1,
		["count"] = -1,
		["duty"] = -1,
		["slot"] = -1,	
		["itemtype"] = -1,	
		["actionSlot"] = -1,	
	}
	
	if loadallItem and loadallItem[getType(element)] and loadallItem[getType(element)][getElementData(element, "va.playerID")] then 
		triggerClientEvent(element, 'va.loadItemToClient', element, loadallItem[getType(element)][getElementData(element, "va.playerID")])
	end
end
addEvent('va.deleteItem', true)
addEventHandler('va.deleteItem', root, deleteItem)

addEvent('va.movedItemToElement', true)
addEventHandler('va.movedItemToElement', root, function (element, targetElement, slot, item, val, count)
	
	local types = getItemToType(element, item)
	
	if giveItem(targetElement, item, val, count, 0, true) then 
		setPlayerAnimation(element, "DEALER","DEALER_DEAL", 3000, false, false, false, false)
		setPlayerAnimation(targetElement, "DEALER","DEALER_DEAL", 3000, false, false, false, false)

		if getElementType(element) == "player" then 
			deleteItem(element, types, slot)
			if loadallItem and loadallItem[getType(element)] and loadallItem[getType(element)][getElementData(element, "va.playerID")] then 
				triggerClientEvent(element, 'va.loadItemToClient', element, loadallItem[getType(element)][getElementData(element, "va.playerID")])
			end		
		elseif getElementType(element) == "object" then
			deleteItem(element, types, slot)
			if loadallItem and loadallItem[getType(element)] and loadallItem[getType(element)][getElementData(element, "va.playerID")] then 
				triggerClientEvent(targetElement, 'va.loadItemToClient', targetElement, loadallItem[getType(element)][getElementData(element, "va.playerID")])
			end
		elseif getElementType(element) == "vehicle" then 
			deleteItem(element, types, slot)
			if loadallItem and loadallItem[getType(element)] and loadallItem[getType(element)][getElementData(element, "va.playerID")] then 
				triggerClientEvent(targetElement, 'va.loadItemToClient', targetElement, loadallItem[getType(element)][getElementData(element, "va.playerID")])
			end	
		end
		
	else
		if getElementType(element) == "player" then 
			exports["va~notify"]:createNotifyS( element, 'error', 'Não há espaço suficiente no inventário')
		elseif getElementType(element) == "vehicle" then
			exports["va~notify"]:createNotifyS( element, 'error', 'Não há espaço suficiente no inventário')
		end
	end
end)

------------------------------

-- // Give Item 

------------------------------

function getPlayerID(id)
	v = false
	for i, player in ipairs (getElementsByType("player")) do
		if getElementData(player, "va.playerID") == id then
			v = player
			break
		end
	end
	return v
end

addCommandHandler( "m4", function( element, commandName )
	if not hasItemS( element, 11, 1 ) then
		giveItem( element, 11, 1, 1 )
	else
		return outputChatBox( "#ff0000[voidAcademy]: #ffffffVocê ja tem uma M4!", element, 255, 255, 255, true )
	end
end
)

addCommandHandler( "ak", function( element, commandName )
	if not hasItemS( element, 10, 1 ) then
		giveItem( element, 10, 1, 1 )
	else
		return outputChatBox( "#ff0000[voidAcademy]: #ffffffVocê ja tem uma AK!", element, 255, 255, 255, true )
	end
end
)

addCommandHandler( "pistola", function( element, commandName )
	if not hasItemS( element, 4, 1 ) then
		giveItem( element, 4, 1, 1 )
	else
		return outputChatBox( "#ff0000[voidAcademy]: #ffffffVocê ja tem uma Pistola!", element, 255, 255, 255, true )
	end
end
)

addCommandHandler( "giveitem", 
	function( element, commandName, id, item, value, count )
		id = tonumber( id )
		item = tonumber( item )
		value = tonumber( value )
		count = tonumber( count )
		if isObjectInACLGroup("user.".. getAccountName( getPlayerAccount( element ) ), aclGetGroup("Console")) then
			if id and item and value and count then
				local targetPlayer = getPlayerID( id )
				if targetPlayer then
					giveItem( targetPlayer, item, value, count )
				else
					return outputChatBox( "#ff0000[voidAcademy]: #ffffffJogador não encontrado!", element, 255, 255, 255, true )
				end
			else
				return outputChatBox( "#ff0000[voidAcademy]: #ffffffUse: /giveitem [ID] [Item do ID] [Quantia] [Peso 1 ou 0]!", element, 255, 255, 255, true )
			end
		else
			return
		end
	end
)

function giveItem (element, item, value, count, duty, state)
	if(not value)then value=0 end
	if(not count)then count=1 end
	if(not duty)then duty=0 end
	if(not state)then state=false end
	
	if (getItemsWeight(element) + getItemsWeightElement(element, item, count) <= getMaxWeight(element))  then 
		local slot = getFreeSlot(element, item)
		if(slot~=false)then
			local types = getItemToType(element, item)
			setSlotItem(element, types, slot, item, value, count, duty)
			if state then
				if loadallItem and loadallItem[getType(element)] and  loadallItem[getType(element)][getElementData(element, "va.playerID")] then 
					triggerClientEvent(element, 'va.loadItemToClient', element, loadallItem[getType(element)][getElementData(element, "va.playerID")])
				end
			end
		
			return true, "sucesso!"
		else
			exports["va~notify"]:createNotify( element, "error", "Não há espaço suficiente!" )
			return false
		end
	else
		exports["va~notify"]:createNotify( element, "error", "Não há espaço suficiente!" )
		return false
	end
end
addEvent('va.inventoryGiveItem', true)
addEventHandler('va.inventoryGiveItem', root, giveItem)

------------------------------

-- // Súly / Item lekérdezések

------------------------------

function getItemsWeightElement(element, itemID, count)
	local all = 0
	all = all + getItemWeight(itemID)*count
	return all
end

function getItemsWeight(element)
	local all = 0
	for i = 1, row * column do	
		for index, value in ipairs (inventoryElem) do 
			
			if not loadallItem[tonumber(getType(element)) or 0] then
				loadallItem[tonumber(getType(element)) or 0] = {}
			end			
			
			if not loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")] then
				loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")] = {}
			end			
			
			if not loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")][value] then
				loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")][value] = {}
			end	
			
			if not loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")][value][i] then
				loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")][value][i] = {}
			end		
			
			if(loadallItem[getType(element)] and loadallItem[getType(element)][getElementData(element, "va.playerID")] and loadallItem[getType(element)][getElementData(element, "va.playerID")][value] and loadallItem[getType(element)][getElementData(element, "va.playerID")][value][i] and tonumber(loadallItem[getType(element)][getElementData(element, "va.playerID")][value][i]['itemID']) or -1 > 0)then
				all = all + (getItemWeight(loadallItem[getType(element)][getElementData(element, "va.playerID")][value][i]['itemID']) or 1)*tonumber(loadallItem[getType(element)][getElementData(element, "va.playerID")][value][i]['count'] or 1)
			end
		end
	end
	return all
end

function getFreeSlot(element, itemID)
	local types = getItemToType(element, itemID)

	for i = 1, row * column do	
		if not loadallItem[tonumber(getType(element)) or 0] then
			loadallItem[tonumber(getType(element)) or 0] = {}
		end			
		
		if not loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")] then
			loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")] = {}
		end			
		
		if not loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")][types] then
			loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")][types] = {}
		end	
		
		if not loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")][types][i] then
			loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")][types][i] = {}
		end		
		
		if not loadallItem[tonumber(getType(element))][getElementData(element, "va.playerID")][types][i]['itemID'] then
			loadallItem[tonumber(getType(element))][getElementData(element, "va.playerID")][types][i]['itemID'] = -1
		end
		
		if loadallItem[tonumber(getType(element))][getElementData(element, "va.playerID")][types][i]['itemID'] < 0 then
			return i
		end
	end
	return false
end

function hasItemS(element, itemID, itemValue)
	local types = getItemToType(element, itemID)
	
	if not loadallItem[tonumber(getType(element)) or 0] then
		loadallItem[tonumber(getType(element)) or 0] = {}
	end		
	
	if not loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")] then
		loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")] = {}
	end			
	
	if not loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")][types] then
		loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")][types] = {}
	end	
	
	for k,v in pairs(loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")][types] or {}) do
		if itemValue then
			if v['itemID'] == itemID and v['value'] == itemValue then
				return true, k, v["value"], v["count"]
			end
		else
			if v['itemID'] == itemID then
				return true, k, v["value"], v["count"]
			end
		end
	end
	return false
end

------------------------------

-- // remove Item cuccok

------------------------------

function RemovePlayerDutyItems(element)
	for i = 1, row * column do	
		for index, value in ipairs (inventoryElem) do 
			if(loadallItem[getType(element)] and loadallItem[getType(element)][getElementData(element, "va.playerID")] and loadallItem[getType(element)][getElementData(element, "va.playerID")][value] and loadallItem[getType(element)][getElementData(element, "va.playerID")][value][i] and tonumber(loadallItem[getType(element)][getElementData(element, "va.playerID")][value][i]['duty'] or -1) > 0)then
				deleteItem(element, value, loadallItem[getType(element)][getElementData(element, "va.playerID")][value][i]['slot'])
			end
		end
	end
	if loadallItem[getType(element)] and  loadallItem[getType(element)][getElementData(element, "va.playerID")] then 
		triggerClientEvent(element, 'va.loadItemToClient', element, loadallItem[getType(element)][getElementData(element, "va.playerID")])
	else
		triggerClientEvent(element, 'va.loadItemToClient', element, {})
	end
end
addEvent('va.RemovePlayerDutyItems', true)
addEventHandler('va.RemovePlayerDutyItems', root, RemovePlayerDutyItems)

function takePlayerItemToID(element, itemID, all)
	if not all then all = false end 
	
	local types = getItemToType(element, itemID)
	
	if not loadallItem[tonumber(getType(element)) or 0] then
		loadallItem[tonumber(getType(element)) or 0] = {}
	end		
	
	if not loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")] then
		loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")] = {}
	end			
	
	if not loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")][types] then
		loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")][types] = {}
	end	
	
	
	for i = 1, row * column do	
		if loadallItem[getType(element)] and loadallItem[getType(element)][getElementData(element, "va.playerID")] and loadallItem[getType(element)][getElementData(element, "va.playerID")][types] and loadallItem[getType(element)][getElementData(element, "va.playerID")][types][i] and tonumber(loadallItem[getType(element)][getElementData(element, "va.playerID")][types][i]['itemID'] or  - 1)  == tonumber(itemID) then --
			if not all then 
				if tonumber(loadallItem[getType(element)][getElementData(element, "va.playerID")][types][i]['count']) > 1 then  
					setSlotCount(element, types, i, tonumber(loadallItem[getType(element)][getElementData(element, "va.playerID")][types][i]['value']), tonumber(loadallItem[getType(element)][getElementData(element, "va.playerID")][types][i]['count'])-1, tonumber(loadallItem[getType(element)][getElementData(element, "va.playerID")][types][i]['duty']), -1, tonumber(loadallItem[getType(element)][getElementData(element, "va.playerID")][types][i]['itemID']))
					break
				else
					deleteItem(element, types, tonumber(loadallItem[getType(element)][getElementData(element, "va.playerID")][types][i]['slot']))
					break
				end
			else
				deleteItem(element, types, tonumber(loadallItem[getType(element)][getElementData(element, "va.playerID")][types][i]['slot']))
			end
		end
	end
	if loadallItem[getType(element)] and  loadallItem[getType(element)][getElementData(element, "va.playerID")] then 
		triggerClientEvent(element, 'va.loadItemToClient', element, loadallItem[getType(element)][getElementData(element, "va.playerID")])
	else
		triggerClientEvent(element, 'va.loadItemToClient', element, {})
	end
end
addEvent("va.takePlayerItemToID", true)
addEventHandler("va.takePlayerItemToID", root, takePlayerItemToID)

function deleteItemById(element, itemID, itemPrice)
	if not itemPrice then itemPrice = 0 end
	local types = getItemToType(element, itemID)
	
	if not loadallItem[tonumber(getType(element)) or 0] then
		loadallItem[tonumber(getType(element)) or 0] = {}
	end		
	
	if not loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")] then
		loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")] = {}
	end			
	
	if not loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")][types] then
		loadallItem[tonumber(getType(element)) or 0][getElementData(element, "va.playerID")][types] = {}
	end	
	
	local giveMoney = 0
	for i = 1, row * column do	
		if loadallItem[getType(element)] and loadallItem[getType(element)][getElementData(element, "va.playerID")] and loadallItem[getType(element)][getElementData(element, "va.playerID")][types] and loadallItem[getType(element)][getElementData(element, "va.playerID")][types][i] and tonumber(loadallItem[getType(element)][getElementData(element, "va.playerID")][types][i]['itemID'] or  - 1)  == tonumber(itemID) then 
			giveMoney = giveMoney + (tonumber(loadallItem[getType(element)][getElementData(element, "va.playerID")][types][i]['count'])*itemPrice)
			deleteItem(element, types, i)
		end
	end
	if math.abs(giveMoney) > 0 then
		setElementData(element, "char:money", getElementData(element, "char:money") + math.abs(giveMoney))
		outputChatBox("#7cc576Josh: #ffffffComprou de você #00AEFF"..getItemName(itemID).."!", element, 255, 255, 255, true)
		outputChatBox("#7cc576Josh: #ffffffPreço do item vendido: #00AEFF"..formatMoney(giveMoney).."!", element, 255, 255, 255, true)
	end
end
addEvent("va.deleteItemById", true)
addEventHandler("va.deleteItemById", root, deleteItemById)

function formatMoney(amount)
	local formatted = tonumber(amount)
	if formatted then
		while true do  
			formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
		if (k==0) then
			break
		end
	end
		return formatted
	else
		return amount
	end
end

------------------------------

-- // Kukához tartozó dolgok

------------------------------

local kuka 

function loadTrash()
	local query = dbQuery(connection, "SELECT * FROM bins;" )
	local result, numrows = dbPoll(query, -1)
	if (result and numrows > 0) then
		for index, trashPos in pairs(result) do
			trashPos = fromJSON(trash["pos"]) or "[[ 0,0,0,0,0,0,0,0 ]]"
			kuka = createObject(1359, trashPos[1],trashPos[2], trashPos[3]-0.4, trashPos[4], trashPos[5], trashPos[6])
			setElementData(kuka, "kukaID", trash['id'])
			setElementInterior(kuka, trashPos[7])
			setElementDimension(kuka, trashPos[8])
		end
	end
end


addCommandHandler("lixeira",
function(playerSource, cmd)
	    if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(playerSource)), aclGetGroup("Console")) then
		local x, y, z = getElementPosition(playerSource)
		local rx, ry, rz = getElementRotation(playerSource)
		local int = getElementInterior(playerSource)
		local Dim = getElementDimension(playerSource)
		
		local Query, _, insertID = dbQuery(connection,"INSERT INTO bins (pos) VALUES(?)", toJSON({x, y, z, rx, ry, rz, int ,Dim})) -- SQL BEszúrás


		local checkQuery, _, insertID = dbPoll ( Query, -1 )
		if checkQuery then
			outputChatBox("#7cc576[btc~Items] #ffffff Lixo criado.", playerSource, 255,255, 255, true)
			kuka = createObject(1359, x, y, z-0.4, rx, ry, rz)
			setElementData(kuka, "kukaID", insertID)
			setElementInterior(kuka, int)
			setElementDimension(kuka, Dim)
		end
	end
end)

addCommandHandler("deletarlixeira",
function(playerSource, cmd)
	    if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(playerSource)), aclGetGroup("Console")) then
		local x, y, _ = getElementPosition(playerSource)
		local kukashape = createColCircle ( x, y, 3 )
		local kukaszam = 0
		for _,v in ipairs(getElementsWithinColShape ( kukashape, "object" ) ) do
				local kukaid = getElementData(v,"kukaID") or 0
				kukaszam = kukaszam + 1
				destroyElement(kukashape)
				if kukaid >= 1 then 
					destroyElement(v)
				end
				dbPoll ( dbQuery( connection, "DELETE FROM bins WHERE id = '?'", kukaid), 0 )
				outputChatBox("#7cc576[btc~Items] #ffffffLixeira excluída com sucesso. ID: #F7CA18"..kukaid, playerSource, 255, 255, 255, true)		
				return
		end
		if(kukaszam == 0) then
			destroyElement(kukashape)
			outputChatBox("#D24D57[btc~Items] #ffffffNão há lixo perto de você.", playerSource, 255, 255, 255, true)
		end
	end
end)

------------------------------

-- // Attach

------------------------------

local object = {}
local attachedTable = {
	-- [ItemID] = {OBJID, boneID, x, y, z, rotx, roty, rotz}
}

function createAttachObj (element, itemID, anim, destroy)
	if attachedTable[itemID] then 
		if not destroy then 
			if not (object[element]) then
				object[element] = createObject(attachedTable[itemID][1],0,0,0)
				setElementInterior(object[element], getElementInterior(element))
				setElementDimension(object[element], getElementDimension(element))
				exports.bone_attach:attachElementToBone(object[element], element, attachedTable[itemID][2], attachedTable[itemID][3], attachedTable[itemID][4], attachedTable[itemID][5], attachedTable[itemID][6], attachedTable[itemID][7], attachedTable[itemID][8])
				setTimer(function()
					destroyElement(object[element])
				end, 60000, 1)
			else
				exports.bone_attach:detachElementFromBone(object[element])
				destroyElement(object[element])
				object[element] = nil
			end
		else
			if isElement(object[element]) then 
				exports.bone_attach:detachElementFromBone(object[element])
				destroyElement(object[element])
				object[element] = nil
			end
		end
	end
end
addEvent('va.createAttachObj', true)
addEventHandler('va.createAttachObj', root, createAttachObj)

------------------------------

-- // Weapon

------------------------------

function setWeapon( element, slot, item )
	if item and itemLists[item].weaponID and getPedWeapon( element ) > 0 and tonumber( getPedWeapon( element ) ) ~= tonumber( itemLists[item].weaponID ) then
		return exports["va~notify"]:createNotifyS( element, "info", "Guarde sua arma antes." )
	end
	takeAllWeapons( element )
	if item and itemLists[item].weaponID and ( getElementData( element, 'va.weaponInHand' ) or { -1, -1, -1 } )[1] < 1 then
		local ammo = 9999 
		giveWeapon( element, itemLists[item].weaponID, ammo, true )
		setElementData( element, "va.weaponInHand", { item, slot, itemLists[item].weaponID } )
		setElementData( element, "va.weaponGettin" .. getItemType( item ) .. slot, true )
		exports["va~weapons"]:setTexture( element,  exports["va~weapons"]:getWeaponWeaponShaderName( getWeaponID( item ) ), getStickerWeapon( item ) )
		
		reloadPedWeapon( element )
	else
		if getElementData( element, "va.weaponGettin" .. getItemType( item ) .. slot ) then
			setElementData( element, "va.weaponInHand", { -1, -1, -1 } )
			setElementData( element, "va.weaponGettin" .. getItemType( item ) .. slot, false )
		end
	end
end
addEvent( "va.setWeapon", true )
addEventHandler( "va.setWeapon", root, setWeapon )

------------------------------

-- // Bag

------------------------------

function getBagToElement(element)
	if hasItemS(element, oneLevelBagID) then -- // Sima Táska
		return oneLevelBag
	elseif hasItemS(element, premiumLevelBagID) then  -- // Prémium Táska
		return premiumLevelBag
	else
		return baseWeight
	end
end


function getMaxWeight(element)
	if(tostring(getElementType(element))=="player")then
		return getBagToElement(element)
	elseif(tostring(getElementType(element))=="vehicle")then
		return vehicleWeight[getElementModel(element)] or 50  --50--50
	elseif(tostring(getElementType(element))=="object")then
		return 100
	end
	return 0
end

------------------------------
-- // Debug dolgok
------------------------------


addEventHandler("onResourceStart", resourceRoot, function()
	for key, player in ipairs(getElementsByType("player")) do
		--if getElementData(player, "char:id") or -1 > 0 then
			takeAllWeapons(player)
			setElementData( player, "va.weaponInHand", { -1, -1, -1 } )
			setElementData( player, "va.weaponGettin", false )
			setTimer(function()
				takeAllWeapons( player )
			end,1000,1)
	end
end)

------------------------------

-- // Baúhez tartozó dolgok

------------------------------

function loadSafeToServer()

	local query = dbQuery(connection, "SELECT * FROM safes;" )
	local result, numrows = dbPoll(query, -1)
	if (result and numrows > 0) then
		for index, safeTable in pairs(result) do	
			local pos = fromJSON(safeTable["Position"])
			local safe = createObject(2332, pos[1], pos[2], pos[3], pos[4], pos[5], pos[6])
			setElementInterior(safe, safeTable["Interior"])
			setElementDimension(safe, safeTable["Dimension"])
			setElementData(safe, "va.safeID", safeTable["va.playerID"])
			setElementData(safe, "safe->State", safeTable["Status"])
		end
	end
end

addEvent("va.createSafe", true)
addEventHandler("va.createSafe", root, function (player)
	if player then 
		local x, y, z = getElementPosition(player)
		local rx, ry, rz = getElementRotation(player)
		local int = getElementInterior(player)
		local dim = getElementDimension(player)
		local pos = toJSON({x, y, z-0.5, rx, ry, rz-180})
		local InsertSafe = dbQuery(connection, "INSERT INTO safe SET Position	=?, Interior = ?, Dimension=?", pos, int, dim)


		--local InsertSafe = dbQuery(connection, "INSERT INTO safe (Position, Interior, Dimension) VALUES(?, ?, ?)", pos, int, dim)




		if InsertSafe then 
			local safe = createObject(2332, x, y, z-0.5, rx, ry, rz-180)
			setElementInterior(safe, int)
			setElementDimension(safe, dim)
			
			local QueryState, _, SafeIDs = dbPoll(InsertSafe, -1)
			if QueryState then
				setElementData(safe, "va.safeID", SafeIDs)
				setTimer(function()
					giveItem(player, 19, SafeIDs, 1,0)
				end, 100, 1)
			end
		end
	end
end)



addCommandHandler("bau",
function(playerSource, cmd)
	if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(playerSource)), aclGetGroup("Console")) then

		
		local x, y, z = getElementPosition(playerSource)
		local rx, ry, rz = getElementRotation(playerSource)
		local int = getElementInterior(playerSource)
		local dim = getElementDimension(playerSource)
		local pos = toJSON({x, y, z-0.5, rx, ry, rz-180})
		local InsertSafe = dbQuery(connection, "INSERT INTO safes (Position, Interior, Dimension) VALUES(?,?,?)", pos, int, dim)
		local QueryState, _, SafeIDs = dbPoll(InsertSafe, -1)

		if InsertSafe then 
			local safe = createObject(2332, x, y, z-0.5, rx, ry, rz-180)
			setElementInterior(safe, int)
			setElementDimension(safe, dim)
			
			if QueryState then
				setElementData(safe, "va.safeID", SafeIDs)
				setTimer(function()
					giveItem(player, 19, SafeIDs, 1,0)
				end, 100, 1)
			end
		end
	end
end)


addCommandHandler("bauperto",
function(playerSource, cmd)
	if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(playerSource)), aclGetGroup("Console")) then
		local pX,pY,pZ = getElementPosition(playerSource)
		for k,v in ipairs(getElementsByType("object")) do
			vX,vY,vZ = getElementPosition(v)
			local dist = getDistanceBetweenPoints3D(pX,pY,pZ,vX,vY,vZ)
			local id = getElementData(v,"va.safeID") or "Desconhecido"
			local interior = getElementInterior(playerSource)
			local dimension = getElementDimension(playerSource)			
			local interior1 = getElementInterior(v)
			local dimension1 = getElementDimension(v)
			if dist <= 15 and interior == interior1 and dimension == dimension1 then
				outputChatBox("#F7CA18[Object] #F89406 Seguro #F89406| #ffffffdistância: #F89406" ..math.ceil(dist) .. " metros #F89406| #ffffffID:#F89406[" .. id .. "]", playerSource, 255,255,255,true)			
			end
		end
	end
end)

addCommandHandler("deletarbau", function(player, _, safeID)
	if not isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup("Console")) then return end
	if not tonumber(safeID) then
		outputChatBox(" /deletarbau [ID]", player, 0, 0, 0, true)
		return
	end
	
	safeID = tonumber(safeID)
	--if (getElementData (player, "adminduty") or 0) == 1 then
		for _, safe in ipairs(getElementsByType("object")) do
			if tonumber(getElementData(safe,"va.safeID")) == safeID then
				destroyElement(safe)
				local delQuery = dbPoll(dbQuery(connection, "DELETE FROM safes WHERE id=?", safeID), -1)
				local delQuery = dbPoll(dbQuery(connection, "DELETE FROM items WHERE owner=?", safeID), -1)
				for k, v in ipairs(getElementsByType("player")) do
					if isElement(v) and tonumber(getElementData(v, "acc:admin") or 0) >= 7 then
						outputChatBox("#D64541[Developer]#ffffff #7cc576"..getElementData(player, "char::anick").." #ffffffexcluiu um Safe (ID: #7cc576"..safeID.."#ffffff)", v,255, 255, 255, true)
						exports.global:sendMessageToAdmins("#7CC576[#7CC576btc#ffffffMTA #ffffff- #53bfdcadmin Log#7CC576] #00aeff"..getElementData(player, "char::anick").." #ffffffexcluiu um Safe (ID: #7cc576"..safeID.."#ffffff)", 255, 0, 0,true)
						--exports.logs:logMessage("[Baú]  "..getElementData(player, "char::anick").." excluiu um Safe (ID: "..safeID..")", 34)
					end
				end
			end
		end
	--else
	--	outputChatBox("#D24D57[btc - Defesa]: #FFFFFFVocê não é um administrador!", player, 255, 255, 255, true)
	--end
end)

addCommandHandler("movebau", function(player, _, safeID)
	if not isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup("Console")) then return end
	if not tonumber(safeID) then
		outputChatBox(" /movesafe [ID]", player, 0, 0, 0, true)
		return
	end
	safeID = tonumber(safeID)
	--if (getElementData (player, "adminduty") or 0) == 1 then
		for _, safe in ipairs(getElementsByType("object")) do
			if tonumber(getElementData(safe,"va.safeID")) == safeID then
				local x, y, z = getElementPosition(player)
				local rx, ry, rz = getElementRotation(player)
				local int = getElementInterior(player)
				local dim = getElementDimension(player)
				setElementPosition(safe, x, y, z-0.5 )
				setElementRotation(safe, rx, ry, rz-180)
				setElementInterior(safe, int)
				setElementDimension(safe, dim)
				local pos = toJSON({x, y, z-0.5, rx, ry, rz-180})
				dbExec(connection, "UPDATE safes SET Position = ?, Interior = ?, Dimension = ? WHERE ID = ?", pos, int, dim, safeID)

					

				for k, v in ipairs(getElementsByType("player")) do
					if isElement(v) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(v)), aclGetGroup("Console")) then
						outputChatBox("#D64541[Developer]#ffffff #7cc576"..getElementData(player, "char::anick").." #ffffffMudou de posição para o Baú (ID: #7cc576"..safeID.."#ffffff)", v,255, 255, 255, true)
						exports.global:sendMessageToAdmins("#7CC576[#7CC576btc#ffffffMTA #ffffff- #53bfdcadmin Log#7CC576] #00aeff"..getElementData(player, "char::anick").." #ffffffMudou de posição para o Baú! (ID: #7cc576"..safeID.."#ffffff)", 255, 0, 0,true)
							--exports.logs:logMessage("[Baú]  "..getElementData(player, "char::anick").." Mudou de posição para o Baú! (ID: "..safeID..")", 34)			
					end
				end
			end
		end
	--else
	--	outputChatBox("#D24D57[btc - Defesa]: #FFFFFFVocê não é um administrador!", player, 255, 255, 255, true)
	--end
end)

addEvent("va.DeleteSafes", true)
addEventHandler("va.DeleteSafes", root, function (player, safeElement, safeID)
	destroyElement(safeElement)
	local delQuery = dbPoll(dbQuery(connection, "DELETE FROM safe WHERE id=?", safeID), -1)
	local delQuery = dbPoll(dbQuery(connection, "DELETE FROM items WHERE owner=?", safeID), -1)
	loadPlayerItems(player)
end)