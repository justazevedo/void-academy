monitorSize = {guiGetScreenSize()} -- // Képernyőlekérdése
margin = 4 -- // 2 slot között lévő hely
local curentCraft = 1 -- // Kiválasztott Craft Sor
local nextPage = 0 -- // Görgetés
local selectedAmount = 0 -- // Move DB
local scroll = 0 -- // Görgetés
local craftTick = 0 -- // craft Tick
local currentCraftItem = 0 -- // Craft kiválasztása
local currentCraftItemTable = {} -- // Craft ItemTabe
local currentActionBarSlot = 0 -- // actionBarSlot
itemSize = 40 -- // Itemkép méret
local width, height = itemSize*column + margin*(column+1), itemSize * row + (1+row)*margin+60 -- // Háttér(Szélesség, Magasság)
local showInventory = false -- // Inventory Státusz
local inventoryElement = localPlayer -- // Inventory Element
local activeInvState = 'weapon' -- // Kiválasztott Almanü
itemTable = {} -- // Itemtáblázat (element)
actionBarTable = {} -- // Actionbar tábla (element)
local playerItemTable = {} -- // Itemtáblázat (player)
local localInventoryLoad = false -- // Player inv betöltése
local moveTime = false -- // Move time
local startCraft = false -- // startTick
local isMove = false -- // Moveolás
local cursorinInventory = false -- // Cursor in Inventory
local cursorinActionbar = false -- // Cursor in Actionbar
local bodySearch = true -- // Motozáskor nem tudja clickni az itemet
local panelX, panelY = monitorSize[1]-width-10, monitorSize[2]/2-height/2 -- // Panel helyzete
local itemData = nil -- // Lerakott item táblák
local showActionbar = true -- // Actionbar mutatása
local cursorInSlot = {} -- // Jelenlegi Slot
local movedItem = {} -- // Moveolt itemek
local currentSlot = {} -- // Elengedett slot
local font = dxCreateFont('files/Calibri.ttf', 10, false) -- // Font
local font1 = dxCreateFont('files/Calibri.ttf', 8, false) -- // Font
local comy = dxCreateFont('files/Calibri.ttf', 12, false) -- // Font
actionbarSlot = 6 
actionWidth, actionHeight = itemSize*(actionbarSlot)+margin*(actionbarSlot+1), itemSize+margin*2
actionPosX, actionPosY = monitorSize[1]/2-actionWidth/2, monitorSize[2]-actionHeight-10
setElementData(localPlayer, "playerInUse", false)
setElementData(localPlayer,"va.showedItem",{false,nil,nil,nil,nil})
for i=1, actionbarSlot do 
	actionBarTable[i] = { 
		['itemID'] = -1,
	}
end

local blockedItem = {
}

bindKey('i', 'down', function ()
	if isPedDead(localPlayer) or getElementData( localPlayer, 'va.invTimedOut' ) or false then
		return
	end	
    toggleInventory( localPlayer )
end)

function toggleInventory( target )
    if not showInventory then
        showInventory = true 
        cursorInSlot = {-1, -1, -1, -1}
        movedItem = {-1, -1, -1, -1}
        openInventory( target )
		showCursor( true )
        activeInvState = 'weapon'
        playSound( "files/sounds/open.mp3", false )
        setTimer(function()
            removeEventHandler('onClientRender', root, drawInventory)
            addEventHandler('onClientRender', root, drawInventory, true, 'low-5')						
        end, 50, 1)
    else
        bodySearch = true
		showInventory = false
		cursorinInventory = false
		isMove = false
		cursorInSlot = {-1, -1, -1, -1}
		movedItem = {-1, -1, -1, -1}
		itemTable = playerItemTable
		showCursor( false )
		playSound("files/sounds/close.mp3", false)
		setElementData(target, "playerInUse", false)
		setElementData(target, 'char >> element', false)
		removeEventHandler('onClientRender', root, drawInventory)
		if getElementType(inventoryElement) == 'vehicle' then 
			setElementData(inventoryElement, "clickToVehicle", 0)
			setElementData(inventoryElement, "inUse", false)
			triggerServerEvent('va.doorState', inventoryElement, inventoryElement, 0)
		end
        inventoryElement = target
    end
end

addEventHandler('onClientResourceStart', resourceRoot, function()
	triggerServerEvent('va.getElementItem', localPlayer, localPlayer)
end)

addEventHandler("onClientElementDataChange", getRootElement(), function(dataName)
	if source and getElementType(source) == "player" and source == localPlayer and dataName == "loggedin" then
		setTimer(function()
			triggerServerEvent('va.getElementItem', localPlayer, localPlayer)
		end, 1000, 1)
	end
end)

function openInventory( element )
	inventoryElement = element
	triggerServerEvent('va.getElementItem', localPlayer, element )
end

addEvent('va.loadItemToClient', true)
addEventHandler('va.loadItemToClient', root, function(itemTableData)
	itemTable = {}
	itemTable = itemTableData	
	
	if (inventoryElement and getElementType(inventoryElement) == "player" and inventoryElement == localPlayer) or (inventoryElement==nil) then
		playerItemTable = itemTableData
		for i = 1, row * column do
			for index, value in ipairs (inventoryElem) do 
				if(playerItemTable[value] and playerItemTable[value][i] and tonumber(playerItemTable[value][i]['itemID'] or -1) > 0 and tonumber(playerItemTable[value][i]['actionSlot'] or -1) > 0)then
					actionBarTable[tonumber(playerItemTable[value][i]['actionSlot'])] = {
						['slot'] = tonumber(playerItemTable[value][i]['slot']), 
						['itemID'] = tonumber(playerItemTable[value][i]['itemID']), 
						['count'] = tonumber(playerItemTable[value][i]['count']), 
						['value'] = playerItemTable[value][i]['value'],
						['tpyes'] = getItemType(tonumber(playerItemTable[value][i]['itemID'])),
					}
				end
			end
		end
	end
	isMove = false
	cursorInSlot = {-1, -1, -1, -1}
	movedItem = {-1, -1, -1, -1}
end)


addEventHandler('onClientRender', root, function()
	if isPedDead(localPlayer) or not showActionbar then
		return
	end	
	if getElementData( localPlayer, "va.actionbar" ) then
		dxDrawRectangle(actionPosX, actionPosY, actionWidth, actionHeight, tocolor(224, 128, 14, 155))
		
		if isMouseInPosition(actionPosX, actionPosY, actionWidth, actionHeight) then
			cursorinActionbar = true
		else
			cursorinActionbar = false
		end
		for i=1, actionbarSlot do 
			dxDrawRectangle(actionPosX+margin-(itemSize+margin)+i*(itemSize+margin), actionPosY+margin, itemSize, itemSize, tocolor(255, 255, 255, 60))
			if isMouseInPosition(actionPosX+margin-(itemSize+margin)+i*(itemSize+margin), actionPosY+margin, itemSize, itemSize) then
				currentActionBarSlot = i 
				if actionBarTable and actionBarTable[i] and (actionBarTable[i]['itemID'] or -1) > -1 and (playerItemTable[actionBarTable[i]['tpyes']][actionBarTable[i]['slot']]['itemID'] or -1) > 0 then 
					tooltip_items(getSpecialItemName(actionBarTable[i]['itemID'], actionBarTable[i]['value'], actionBarTable[i]['count']))
				end
				dxDrawRectangle(actionPosX+margin-(itemSize+margin)+i*(itemSize+margin), actionPosY+margin, itemSize, itemSize, tocolor(224, 128, 14, 200)) -- // ActionBar Item Hover
			else
			end
			if getKeyState(i) and not isCursorShowing() and not isChatBoxInputActive() or (actionBarTable[i] and actionBarTable[i]['itemID'] > -1 and getElementData(localPlayer, 'va.weaponGettin'..actionBarTable[i]['tpyes']..actionBarTable[i]['slot']) or false) then
				dxDrawRectangle(actionPosX+margin-(itemSize+margin)+i*(itemSize+margin), actionPosY+margin, itemSize, itemSize, tocolor(224, 128, 14, 200)) -- // ActionBar Item Hover
			end
			if actionBarTable and actionBarTable[i] and actionBarTable[i]['itemID'] > -1 then 
				if (playerItemTable[actionBarTable[i]['tpyes']][actionBarTable[i]['slot']]['itemID'] or -1) > 0 then 
					dxDrawImage(actionPosX+margin-(itemSize+margin)+i*(itemSize+margin)+2, actionPosY+margin+2, itemSize-4, itemSize-4, getItemImg(actionBarTable[i]['itemID']), 0, 0, 0, tocolor(255,255,255,255), false) --Item
					if playerItemTable[actionBarTable[i]['tpyes']] and (playerItemTable[actionBarTable[i]['tpyes']][actionBarTable[i]['slot']]['count'] or 0) > 1 then 
						dxDrawText(playerItemTable[actionBarTable[i]['tpyes']][actionBarTable[i]['slot']]['count'], actionPosX+margin-(itemSize+margin)+i*(itemSize+margin)+5, actionPosY+margin+itemSize-17, itemSize, itemSize, tocolor(0, 0, 0, 255), 1, font, "left", "top", false, false, false, true)
						dxDrawText(playerItemTable[actionBarTable[i]['tpyes']][actionBarTable[i]['slot']]['count'], actionPosX+margin-(itemSize+margin)+i*(itemSize+margin)+3, actionPosY+margin+itemSize-18, itemSize, itemSize, tocolor(255, 255, 255, 255), 1, font, "left", "top", false, false, false, true)
					end
				else
					dxDrawImage(actionPosX+margin-(itemSize+margin)+i*(itemSize+margin)+2, actionPosY+margin+2, itemSize-4, itemSize-4, 'img/no.png', 0, 0, 0, tocolor(255, 255, 255, 180), false) --Item
				end
			end
		end
	end
end, true, 'low-5')

for i=1, actionbarSlot do
	bindKey(i, "down", function()	
		if isPedDead(localPlayer) then
			return
		end
		
		if isTimer(timer) then return end
		if not isCursorShowing() and not isChatBoxInputActive() and not isConsoleActive() then
			if inventoryElement == localPlayer then 
				timer = setTimer(function() end, 500, 1) --- spam védelem
				if actionBarTable[i] and tonumber(actionBarTable[i]['itemID']) > -1 then 
					if hasItem(localPlayer, actionBarTable[i]['itemID']) then
						--if getItemNeedLevel(playerItemTable[actionBarTable[i]['tpyes']][actionBarTable[i]['slot']]['itemID']) <= exports.btc_level:getPlayerLevel(localPlayer) then
							if not getElementData(localPlayer, 'charCuff') or false or not getElementData(localPlayer, 'charFollow') or false then 
								useItem(
										playerItemTable[actionBarTable[i]['tpyes']][actionBarTable[i]['slot']]['dbID'], 
										actionBarTable[i]['slot'],
										playerItemTable[actionBarTable[i]['tpyes']][actionBarTable[i]['slot']]['itemID'],
										playerItemTable[actionBarTable[i]['tpyes']][actionBarTable[i]['slot']]['value'],
										playerItemTable[actionBarTable[i]['tpyes']][actionBarTable[i]['slot']]['count']
										)
							end
						--else
						--	outputChatBox("#D24D57[SKY~Items] #ffffffVocê não tem níveis suficientes #F7CA18(".. getItemNeedLevel(actionBarTable[i]['itemID']) ..")", 255, 255, 255, true)
						--end	
					else
						if not hasItem(localPlayer, actionBarTable[i]['itemID']) then
							actionBarTable[i] = {
								['itemID'] = -1, 
								['count'] = -1, 
								['value'] = -1,
							}
						end
					end
				end
			end
		end	
	end)
end

function drawInventory ()		
	if isPedDead(localPlayer) then
		return
	end
	
	dxDrawRectangle(panelX, panelY, width, height, tocolor(224, 128, 14, 155)) -- BackGround
	dxDrawRectangle(panelX, panelY, width, 33, tocolor(0, 0, 0, 200))
	if not bodySearch then 
	end
	dxDrawRectangle(panelX+width-66, panelY-21, 64, 19, tocolor(0, 0, 0, 200))
	dxDrawRectangle(panelX+width-64, panelY-19, 60, 15, tocolor(255, 255, 255, 60))
	
	
	if isElement(btn_edit) then
		countText = guiGetText(btn_edit)
		if countText == "" then
			countText = ""
		end
		if tonumber(countText) then
			selectedAmount = math.floor(countText)
			dxDrawText(countText, panelX+width-66+64/2, panelY-21+19/2, panelX+width-66+64/2, panelY-21+19/2, tocolor(255, 255, 255, 255), 1, font1, "center", "center", false, false, false, true)
		else
			selectedAmount = 0
			dxDrawText("Apenas numero", panelX+width-66+64/2, panelY-21+19/2, panelX+width-66+64/2, panelY-21+19/2, tocolor(255, 255, 255, 255), 1, font1, "center", "center", false, false, false, true)
		end
	end
	
	if(isMouseInPosition(panelX, panelY, width, height))then
		cursorinInventory = true
	else
		cursorinInventory = false
	end	
	
	for index, value in ipairs(inventoryElem) do 
		if isMouseInPosition(panelX+width-index*30, panelY+5, 25, 25) or value == activeInvState then 
			dxDrawImage(panelX+width-index*30, panelY+5, 25, 25, 'img/' .. value .. '.png', 0, 0, 0, tocolor(255, 255, 255, 255)) -- 40, 48
		else
			dxDrawImage(panelX+width-index*30, panelY+5, 25, 25, 'img/' .. value .. '.png', 0, 0, 0, tocolor(255, 255, 255, 180)) -- 40, 48
		end
	end
	
	dxDrawRectangle(panelX+5, panelY+height-20, width-10, 16, tocolor(255, 255, 255, 200)) -- // Súly Background
	local weight = (width-10)*getItemsWeight()/getMaxWeight(inventoryElement)
	if weight <= (width-10) then 
		dxDrawRectangle(panelX+5, panelY+height-20, weight, 16, tocolor(124, 197, 118, 255)) -- // Súly
	else
		dxDrawRectangle(panelX+5, panelY+height-20, width-10, 16, tocolor(124, 197, 118, 255)) -- // Súly
	end
	dxDrawText(getItemsWeight() .. " / " .. tostring(getMaxWeight(inventoryElement)) .. "KG", panelX+width/2, panelY+height-20+16/2, panelX+width/2, panelY+height-20+16/2, tocolor(0, 0, 0, 255), 1, font, 'center', 'center', false, false, false, true)

	if activeInvState ~= 'craft' then
		if getElementType(inventoryElement) == "player" then
			dxDrawText("#FFFFFFvoidAcademy ("..getPlayerName(inventoryElement)..")",panelX+10, panelY+35/2, width, panelY+35/2, tocolor(255, 255, 255, 255), 1, font, 'left', 'center', false, false, false, true)
		elseif getElementType(inventoryElement) == "Vehicle" then
			dxDrawText("#FFFFFFvoidAcademy -#00FF00veículo",panelX+10, panelY+35/2, width, panelY+35/2, tocolor(255, 255, 255, 255), 1, font, 'left', 'center', false, false, false, true)
		elseif getElementType(inventoryElement) == "Object" then
			dxDrawText("#FFFFFFvoidAcademy -#00FF00Baú",panelX+10, panelY+35/2, width, panelY+35/2, tocolor(255, 255, 255, 255), 1, font, 'left', 'center', false, false, false, true)
		end

		local drawRow = 0
		local drawColumn = 0
		
		isMove = false
		
		local itemDbid = 0
		local itemID = 0
		local itemCount = 0
		local slot = 0
		local value = 0
		
		for i = 1, row * column do
			dxDrawRectangle(panelX + drawColumn*itemSize + (drawColumn+1)*margin, panelY + (drawRow+1)*margin + drawRow*itemSize + 30, itemSize, itemSize, tocolor(0, 0, 0, 60)) -- // Item BackGround
			
			if (itemTable[activeInvState]) then 
				itemData = itemTable[activeInvState][i]
			end
			
			if isMouseInPosition(panelX + drawColumn*itemSize + (drawColumn+1)*margin, panelY + (drawRow+1)*margin + drawRow*itemSize + 30, itemSize, itemSize) then 
				if itemData and getItemSlot(i) > 0 then
					tooltip_items(getSpecialItemName(itemData["itemID"], itemData["value"], itemData["count"]))
				end
				dxDrawRectangle(panelX + drawColumn*itemSize + (drawColumn+1)*margin, panelY + (drawRow+1)*margin + drawRow*itemSize + 30, itemSize, itemSize, tocolor(224, 128, 14, 200)) -- // Item Hover
			end
			if not isMove and getElementData(inventoryElement, 'va.weaponGettin'..activeInvState..i) or false and getElementType(inventoryElement) == 'player' then 
				dxDrawRectangle(panelX + drawColumn*itemSize + (drawColumn+1)*margin, panelY + (drawRow+1)*margin + drawRow*itemSize + 30, itemSize, itemSize, tocolor(224, 128, 14, 200)) -- // Item Hover
			end
			
			
			if (itemData) then
				itemDbid = getItemIndex(i)
				itemID = getItemSlot(i)
				itemCount = getItemCount(i)
				slot = getSlot(i)
				value = getItemValue(i)
				
				if itemID > -1 then 
					isMove = clickDown and movedItem[2] and ( getTickCount( ) - clickDown >= 130 )
					if(not(isMove and movedItem[2]==itemID and movedItem[1]==i)) then
						dxDrawImage(panelX + drawColumn*itemSize + (drawColumn+1)*margin+2, panelY + (drawRow+1)*margin + drawRow*itemSize + 30+2, itemSize-4, itemSize-4, getItemImg(tonumber(itemID)), 0, 0, 0, tocolor(255, 255, 255, 255))
						if itemCount > 1 then 
							dxDrawText(itemCount, panelX + drawColumn*itemSize + (drawColumn+1)*margin+5, panelY + (drawRow+1)*margin + drawRow*itemSize + 30+itemSize-17, itemSize-4, itemSize-4, tocolor(0, 0, 0, 255), 1, font, "left", "top", false, false, false, true)
							dxDrawText(itemCount, panelX + drawColumn*itemSize + (drawColumn+1)*margin+4, panelY + (drawRow+1)*margin + drawRow*itemSize + 30+itemSize-18, itemSize-4, itemSize-4, tocolor(255, 255, 255, 255), 1, font, "left", "top", false, false, false, true)
						end
					end
				end
			end
			
			if isMouseInPosition(panelX + drawColumn*itemSize + (drawColumn+1)*margin, panelY + (drawRow+1)*margin + drawRow*itemSize + 30, itemSize, itemSize) then 
				cursorInSlot = {-1, -1, -1, -1}
				cursorInSlot = {i, getItemSlot(i), getItemValue(i), getItemCount(i)}
			end
			
			drawColumn = drawColumn + 1
			if (drawColumn == column) then
				drawColumn = 0
				drawRow = drawRow + 1
			end
		end
		if(isMove and (movedItem[2] and movedItem[2] > 0 ) and inventoryElement  == localPlayer ) then
			if isMouseInPosition(panelX+width/2-64/2, panelY-64, 64, 64) then 
				dxDrawImage(panelX+width/2-64/2, panelY-64, 64, 64, 'img/eye.png', 0, 0, 0, tocolor(255, 255, 255, 255))
			else
				dxDrawImage(panelX+width/2-64/2, panelY-64, 64, 64, 'img/eye.png', 0, 0, 0, tocolor(255, 255, 255, 180))
			end
		end
	else
		return
	end
	if(isMove and  movedItem[1]>-1 and movedItem[2]>-1 ) then
		local x,y = getCursorPosition( )
		local x,y = x * monitorSize[1]-itemSize/2, y * monitorSize[2]-itemSize/2
		dxDrawImage(x, y, itemSize, itemSize, getItemImg(movedItem[2]), 0, 0, 0, tocolor(255, 255, 255, 255)) -- // Item Move
	end
end

------------------------------

-- // Anti bug cuccok 

------------------------------

function packetLossCheck()
    local packet = getNetworkStats()["packetlossLastSecond"]   
	if (packet > 15) then
		local random = math.random(5, 10)
		packetTimer = setTimer(function() end, 1000*random, 1) --- spam védelem
    	if showInventory then
			bodySearch = true
			showInventory = false
			cursorinInventory = false
			isMove = false
			cursorInSlot = {-1, -1, -1, -1}
			movedItem = {-1, -1, -1, -1}
			itemTable = playerItemTable
			playSound("files/sounds/close.mp3", false)
			setElementData(localPlayer, "playerInUse", false)
			setElementData(localPlayer, 'char >> element', false)
			removeEventHandler('onClientRender', root, drawInventory)
			if getElementType(inventoryElement) == 'vehicle' then 
				setElementData(inventoryElement, "clickToVehicle", 0)
				setElementData(inventoryElement, "inUse", false)
				triggerServerEvent('va.doorState', inventoryElement, inventoryElement, 0)
			end
			toggleControl ("fire", true)
			inventoryElement = localPlayer
			setElementFrozen(localPlayer, false)
		end
    end
end
setTimer(packetLossCheck, 50, 0)

function enterVehicle ( player, seat, jacked ) --when a player enters a vehicle
	if player == localPlayer then 
	if showInventory then
		bodySearch = true
		showInventory = false
		cursorinInventory = false
		isMove = false
		cursorInSlot = {-1, -1, -1, -1}
		movedItem = {-1, -1, -1, -1}
		itemTable = playerItemTable
		playSound("files/sounds/close.mp3", false)
		setElementData(localPlayer, "playerInUse", false)
		setElementData(localPlayer, 'char >> element', false)
		removeEventHandler('onClientRender', root, drawInventory)
		if getElementType(inventoryElement) == 'vehicle' then 
			setElementData(inventoryElement, "clickToVehicle", 0)
			setElementData(inventoryElement, "inUse", false)
			triggerServerEvent('va.doorState', inventoryElement, inventoryElement, 0)
		end
		toggleControl ("fire", true)
		inventoryElement = localPlayer
		setElementFrozen(localPlayer, false)
	end
end
end
addEventHandler ( "onClientVehicleStartEnter", getRootElement(), enterVehicle ) 



------------------------------

-- // Klikkelés 

------------------------------

function clickInventory(button, state, _, _, _, _, _, element)
	if button == 'left' and state == 'down' and (not showInventory or showInventory) and (not cursorinInventory and cursorinActionbar) then
		if(currentActionBarSlot > 0 and (actionBarTable[currentActionBarSlot]['itemID'] or -1) > 0) and (inventoryElement and inventoryElement == localPlayer) or not inventoryElement then
			triggerServerEvent('va.setActionBarSlot', localPlayer, localPlayer, getItemToType(localPlayer, tonumber(actionBarTable[currentActionBarSlot]['itemID'])), tonumber(actionBarTable[currentActionBarSlot]['slot']), actionBarTable[currentActionBarSlot]['value'], actionBarTable[currentActionBarSlot]['count'], 0, actionBarTable[currentActionBarSlot]['itemID'])
			itemTable[getItemToType(localPlayer, tonumber(actionBarTable[currentActionBarSlot]['itemID']))][actionBarTable[currentActionBarSlot]['slot']]['actionSlot'] = tonumber(-1)
			
			actionBarTable[currentActionBarSlot] = { ['itemID'] = -1 }
		end
	elseif button == 'left' and state == 'down' and showInventory then 
		if isMouseInPosition(panelX+width-54, panelY-19, 50, 15) then 
			createEditFunction("create")
			if guiEditSetCaretIndex(btn_edit, string.len(guiGetText(btn_edit))) then
				guiBringToFront(btn_edit)
			end
		else
		end
		if getElementType(inventoryElement) == 'player' then 
			for index, value in ipairs(inventoryElem) do 
				if isMouseInPosition(panelX+width-index*30, panelY+5, 25, 25) then 
					activeInvState = inventoryElem[index]
					cursorInSlot = {-1, -1, -1, -1}
					movedItem = {-1, -1, -1, -1}
				end
			end
		end
		if (cursorInSlot[2]>-1) and cursorinInventory and bodySearch then -- // Move Start
			if isTimer(timers1) then movedItem = {} return end
			timers1 = setTimer(function() end, 2000, 1) --- spam védelem
			movedItem = {cursorInSlot[1], cursorInSlot[2], cursorInSlot[3], cursorInSlot[4]} -- {i, getItemSlot(i), getItemValue(i), getItemCount(i)}
			clickDown = getTickCount( )
		end
	elseif button == 'left' and state == 'up' and showInventory then 
		if isTimer(timer) then movedItem = {} return end
		timer = setTimer(function() end, 1000, 1) --- spam védelem
		if #movedItem > 0 then  -- // Move Finish
			if isMouseInPosition(panelX+width/2-64/2, panelY-64, 64, 64) and inventoryElement  == localPlayer then 
				local startTime = getTickCount()
				setElementData(localPlayer,"va.showedItem",{ true, movedItem[2], getItemName(movedItem[2]), getItemDescription(movedItem[2]), getTickCount()})
				setTimer(function()
					setElementData(localPlayer,"va.showedItem",{false,nil,nil,nil,nil})
				end,5000,1)
			end
			currentSlot = {cursorInSlot[1], cursorInSlot[2], cursorInSlot[3], cursorInSlot[4]}	
			if(cursorinInventory and movedItem[1] > -1 and movedItem[2] > 0 and currentSlot[2] < 0 and currentSlot[2] ~= movedItem[2] and currentSlot[1] ~= movedItem[1] and currentSlot[1] > -1 and tonumber(selectedAmount) < 1  and bodySearch ) then 
				if getItemActionBar(movedItem[1]) then
					if not getElementData(inventoryElement, 'va.weaponGettin'..getItemType(movedItem[2])..movedItem[1]) or false then 
						setSlot(currentSlot[1], movedItem[2], movedItem[3], movedItem[4], getItemDuty(movedItem[1]))
						delSlot(movedItem[1])
						playSound("files/sounds/click.mp3", false)
						movedItem = {}
					else
						movedItem = {}
						exports["va~notify"]:createNotify( element, 'error', 'Você não pode mover um item em uso!')
					end
				else
					movedItem = {}
					exports["va~notify"]:createNotify( element, 'error', 'Você não pode mover um item na barra de ação!')
				end
			elseif((cursorinInventory) and movedItem[1]>-1 and movedItem[2]>0 and currentSlot[1]~=movedItem[1] and currentSlot[1] > -1 and currentSlot[2] < 1 and tonumber(selectedAmount) < movedItem[4] and tonumber(selectedAmount) > 0 and currentSlot[2]~=movedItem[2] and itemLists[movedItem[2]].stack)then
				if getItemActionBar(movedItem[1]) then  
					newCount = movedItem[4] - tonumber(selectedAmount)
					setSlotCount(movedItem[1], newCount, movedItem[2], getItemDuty(movedItem[1]))
					setSlot(currentSlot[1], movedItem[2], movedItem[3], tonumber(selectedAmount), getItemDuty(movedItem[1]))
					setSlotValue(movedItem[1], movedItem[2], movedItem[3], newCount, getItemDuty(movedItem[1]))
					createEditFunction("remove")
					playSound("files/sounds/click.mp3", false)
					movedItem = {}
				else
					movedItem = {}
					exports["va~notify"]:createNotify( element, 'error', 'Você não pode mover um item na barra de ação!')
				end
			elseif((cursorinInventory) and movedItem[1]>-1 and currentSlot[1]~=movedItem[1] and movedItem[2]>0 and currentSlot[1] > -1 and currentSlot[2]==movedItem[2] and getItemDuty(movedItem[1]) == getItemDuty(currentSlot[1]) and bodySearch )then
				if itemLists[movedItem[2]].stack then
					if getItemActionBar(movedItem[1]) then  
						newCounts = currentSlot[4] + movedItem[4]
						setSlotCount(currentSlot[1], newCounts, currentSlot[2], getItemDuty(movedItem[1]))
						setSlotValue(currentSlot[1], movedItem[2], movedItem[3], newCounts, getItemDuty(movedItem[1]) or -1)
						delSlot(movedItem[1])
						playSound("files/sounds/click.mp3", false)
						movedItem = {}
						createEditFunction("remove")
					else
						movedItem = {}
						exports["va~notify"]:createNotify( element, 'error', 'Você não pode mover um item na barra de ação!')
					end
				else
					movedItem = {}
					createEditFunction("remove")
				end
			elseif((not cursorinInventory and cursorinActionbar) and currentActionBarSlot > 0 and movedItem[1]>-1 and movedItem[2]>0 and bodySearch)then
				if inventoryElement == localPlayer then 
					if getItemActionBar(movedItem[1]) then
						playSound("files/sounds/click.mp3", false)
						createEditFunction("remove")
						if (actionBarTable[currentActionBarSlot]['itemID'] or -1) < 1 then
							actionBarTable[currentActionBarSlot] = {
								['slot'] = tonumber(movedItem[1]), 
								['itemID'] = tonumber(movedItem[2]), 
								['count'] = tonumber(movedItem[4]), 
								['value'] = movedItem[3],
								['tpyes'] = getItemToType(localPlayer, tonumber(movedItem[2])),
							}
							itemTable[getItemToType(localPlayer, tonumber(movedItem[2]))][movedItem[1]]['actionSlot'] = tonumber(currentActionBarSlot)
							triggerServerEvent('va.setActionBarSlot', inventoryElement, inventoryElement, getItemToType(localPlayer, tonumber(movedItem[2])), tonumber(movedItem[1]), movedItem[3], movedItem[4], currentActionBarSlot, movedItem[2])
							movedItem = {}
						else
							movedItem = {}
							exports["va~notify"]:createNotify( element, 'error', 'Já existe um item neste slot na barra de ação!')
						end
					else
						movedItem = {}
						createEditFunction("remove")
						exports["va~notify"]:createNotify( element, 'error', 'Você não pode mover um objeto na barra de ação!')
					end
				end
			elseif((cursorinInventory) and currentSlot[2]==movedItem[2] and currentSlot[1] == movedItem[1] and bodySearch )then
				movedItem = {}			
			elseif((not cursorinInventory and not cursorinActionbar) and not element or (getElementType(inventoryElement) == "player") and element == localPlayer)then
					movedItem = {}
			elseif(movedItem[1] > -1 and movedItem[2] > 0 and movedItem[3] and element ~= inventoryElement and isElement(element) and tostring(getElementType(element)) ~= "false" and not cursorinInventory)then
				if (getElementType(element) == "player" or getElementType(element) == "vehicle" or (getElementType(element) == "object" and getElementModel(element) == 2332 )) then
					if blockedItem[movedItem[2]] then movedItem = {} return end
					if isTimer(timers) then movedItem = {} return end
					timers = setTimer(function() end, 2000, 1) --- spam védelem
					local x, y, z = getElementPosition(inventoryElement)
					local x2, y2, z2 = getElementPosition(element)
					if getDistanceBetweenPoints3D( x, y, z, x2, y2, z2 ) < 5 then
						if getItemActionBar(movedItem[1]) then 
							if getItemDuty(movedItem[1]) < 1 then
								if not getElementData(inventoryElement, 'va.weaponGettin'..getItemType(movedItem[2])..movedItem[1]) or false then 
									if getItemsWeight() <= baseWeight or (tonumber(movedItem[2]) ~= tonumber(oneLevelBagID) and movedItem[2] ~= tonumber(premiumLevelBagID)) then
										if getElementType(element) == "vehicle" and (getOwnerID(element) or -1)>0 then 											
											if getElementType(element) == "vehicle" and getElementType(inventoryElement) == "player" then 
												if getVehicleType ~= 'Bike' or getVehicleType ~= 'BMX' or getVehicleType ~= 'Quad' then 

													if not (isVehicleLocked(element)) then
														if not getElementData(element, "inUse") or false then 

														 if not vehicleWeight[getElementModel(element)] then
															return exports["va~notify"]:createNotify( element, 'error', 'Veiculo está lotado!' )
														 else
															--triggerServerEvent('va.movedItemToElement', inventoryElement, inventoryElement, element, movedItem[1], movedItem[2], movedItem[3], movedItem[4])
														 end														

														else
															exports["va~notify"]:createNotify( element, 'error', 'O inventário está em uso!' )
														end
													else
														exports["va~notify"]:createNotify( element, 'error', 'O porta mals está fechado!' )
													end
												end
											end
										elseif getElementType(element) == "player" and getElementType(inventoryElement) == "player" then
											--[[exports["va~notify"]:createNotify( element, 'info', 'Aguarde um minuto.' )
											packetTimer = setTimer(function() end, 1000, 1) --- spam védelem
											if showInventory then
												showInventory = false
												removeEventHandler('onClientRender', root, drawInventory)
												cursorinInventory = false
												cursorInSlot = {-1, -1, -1, -1}
												itemTable = playerItemTable
												toggleControl ("fire", true)
												inventoryElement = localPlayer
												setElementFrozen(localPlayer, false)
											end
											setTimer(function(movedItem)
												if not getElementData(element, "playerInUse") or false then 
													if hasItem(localPlayer, movedItem[2]) then 
														triggerServerEvent('va.movedItemToElement', inventoryElement, inventoryElement, element, movedItem[1], movedItem[2], movedItem[3], movedItem[4])
													else
														exports["va~notify"]:createNotify( element, 'error', 'Não existe tal coisa com você.' )
													end
												else
													exports["va~notify"]:createNotify( element, 'error', 'Este jogador está usando o inventario.' )
												end
											end, 1000, 1, movedItem)]]
										--[[elseif getElementType(element) =="object" and getElementModel(element) == 2332 and bodySearch and getElementData(element, "va.safeID") or 0 > 0 then 
											if hasItem(localPlayer, 19, getElementData(element, "va.safeID")) then 
												if movedItem[2] ~= 19 and movedValue ~= getElementData(element, "va.safeID") then
													triggerServerEvent('va.movedItemToElement', inventoryElement, inventoryElement, element, movedItem[1], movedItem[2], movedItem[3], movedItem[4])
												else
													outputChatBox("#D24D57[BRP~Items] #ffffffVocê não pode colocar uma chave no cofre.", 255, 255, 255, true)
												end
											end	]]
										elseif getElementType(inventoryElement) == "vehicle" and getElementType(element) == "player" and element == localPlayer then
											--triggerServerEvent('va.movedItemToElement', inventoryElement, inventoryElement, element, movedItem[1], movedItem[2], movedItem[3], movedItem[4])
										elseif getElementType(inventoryElement) == "object" and getElementType(element) == "player" and element == localPlayer then
											--triggerServerEvent('va.movedItemToElement', inventoryElement, inventoryElement, element, movedItem[1], movedItem[2], movedItem[3], movedItem[4])
										end
									else
										exports["va~notify"]:createNotify( element, 'error', 'Você está muito pesado '.. baseWeight ..'kg.' )
									end
								else
									exports["va~notify"]:createNotify( element, 'error', 'Você não pode mover um item em uso.' )
								end
								movedItem = {}
							else
								exports["va~notify"]:createNotify( element, 'error', 'Você não pode entregar itens de serviço.' )
								movedItem = {}
							end
						else
							exports["va~notify"]:createNotify( element, 'error', 'Você não pode mover um item na barra de ação.' )
							movedItem = {}
						end
						createEditFunction("remove")
					end
				--[[elseif(getElementType(element)=="ped" and getElementData(element,"isUseLottery") ) then
					if movedItem[2] == 110 then
						exports["btcLotto"]:getCheckedPlayer(movedItem[3],movedItem[1])
					end]]
				elseif(getElementType(element)=="object" and getElementModel(element)==1359) then
					if blockedItem[movedItem[2]] then movedItem = {} return end
					local x,y,z = getElementPosition(inventoryElement)
					local x2,y2,z2 = getElementPosition(element)
					if getDistanceBetweenPoints3D( x, y, z, x2, y2, z2 ) < 5 then
						if not getElementData(inventoryElement, 'va.weaponGettin'..getItemType(movedItem[2])..movedItem[1]) or false then 
							if getItemActionBar(movedItem[1]) then 
								if getItemsWeight() <= baseWeight or (tonumber(movedItem[2]) ~= tonumber(oneLevelBagID) and movedItem[2] ~= tonumber(premiumLevelBagID)) then
									delSlot(movedItem[1])
									movedItem = {}
								else
									exports["va~notify"]:createNotify( element, 'error', 'Você está muito pesado '.. baseWeight ..'kg.' )
									movedItem = {}
								end
							else
								exports["va~notify"]:createNotify( element, 'error', 'Você não pode mover um item na barra de ação.' )
								movedItem = {}
							end
						else 
							exports["va~notify"]:createNotify( element, 'error', 'Você não pode mover um item em uso.' )
							movedItem = {}
						end
					end
				end
			end
			movedItem = {}
		end
		movedItem = {}
	elseif button == 'right' and state == 'down' and not showInventory and element then 
		--[[if getElementType(element) == "vehicle" and not cursorinInventory and not isMove and getElementData(element, "va.ownerCar") == getElementData(localPlayer, "va.id") or getElementData( localPlayer, "va.adminlevel" ) or 0 > 5  then --tonumber(getElementData(element, "dbid")) or -1 > 0 then
			if isTimer(packetTimer) then return end
			local x,y,z = getElementPosition(localPlayer)
			local x2,y2,z2 = getElementPosition(element)
			if getDistanceBetweenPoints3D( x, y, z, x2, y2, z2 ) < 5 then
				if (not getElementData(element, "inUse")) or false or (getElementData(element, "clickToVehicle") or 0) == 0  then 
					if not isPedInVehicle(localPlayer) then 
						if not isVehicleLocked(element) then 
							if isTimer(timer) then return end ---------- 
							timer = setTimer(function() end, 1000, 1) -- spam Védelem
							triggerServerEvent("va.checkVehicleInvenroty", localPlayer, localPlayer, element)
						else
							exports["va~notify"]:createNotify( element, 'error', 'O porta malas está fechado!' )
						end
					else
						exports["va~notify"]:createNotify( element, 'error', 'Você não pode abrir o inventário em seu carro.' )
					end
				else
					exports["va~notify"]:createNotify( element, 'error', 'O inventário selecionado já está em uso.' )
				end
			end
		end]]
		--[[elseif getElementType(element) == "vehicle" and not cursorinInventory and not isMove then
		if (getElementData(localPlayer, "va.adminlevel") or 0) >= 4 or getElementData(getLocalPlayer(), "va.dutyfaction") == 17 or getElementData(getLocalPlayer(), "va.dutyfaction") == 16 or getElementData(getLocalPlayer(), "va.dutyfaction") == 22  or getElementData(getLocalPlayer(), "va.dutyfaction") == 11 or getElementData(getLocalPlayer(), "va.dutyfaction") == 2 or getElementData(getLocalPlayer(), "va.dutyfaction") == 6 or getElementData(getLocalPlayer(), "va.dutyfaction") == 5 or getElementData(getLocalPlayer(), "va.dutyfaction") == 19 or getElementData(getLocalPlayer(), "va.dutyfaction") == 20 or getElementData(getLocalPlayer(), "va.dutyfaction") == 21 or getElementData(getLocalPlayer(), "va.dutyfaction") == 24 then
			local x,y,z = getElementPosition(localPlayer)
			local x2,y2,z2 = getElementPosition(element)
			if getDistanceBetweenPoints3D( x, y, z, x2, y2, z2 ) < 5 then
				if (not getElementData(element, "inUse")) or false or (getElementData(element, "clickToVehicle") or 0) == 0  then 
					if not isPedInVehicle(localPlayer) then 
						if not isVehicleLocked(element) then 
							if not getElementData(element, "va.ownerCar") then
								exports["va~notify"]:createNotify( element, 'error', 'Este veiculo não possui um inventário.' )
								return
							end
								if isTimer(timer) then return end ---------- 
								timer = setTimer(function() end, 1000, 1) -- spam Védelem
									triggerServerEvent("va.checkVehicleInvenroty", localPlayer, localPlayer, element)
								else
									outputChatBox("#D24D57[BRP~Items] #ffffffMala de veículo fechado#ffffff tem!", 255, 255, 255, true)
								end
							else
								outputChatBox("#D24D57[BRP~Items] #ffffffVocê não pode abrir o inventário em seu carro#ffffff.", 255, 255, 255, true)
							end
						else
							outputChatBox("#D24D57[BRP~Items] #ffffffO inventário selecionado já está em uso!", 255, 255, 255, true)
						end
					end
				end]]
		--[[elseif(getElementType(element)=="object" and getElementModel(element) == 2332 or getElementModel(element) == 1829 and (getElementData(element, "va.safeID") or 0) >= 1) then
			if hasItem(localPlayer, 19, getElementData(element, "va.safeID"))  then 
				if isTimer(timers) then movedItem = {} return end
				timers = setTimer(function() end, 2000, 1)
				if not startCraft then 
					if not showInventory then 
						showInventory = true
					end
					setElementData(localPlayer, "playerInUse", true)
					toggleControl ("fire", false)
					openInventory(element)
					activeInvState = 'weapon'
					removeEventHandler("onClientRender", root, drawInventory)
					addEventHandler("onClientRender", root, drawInventory)
				else
					outputChatBox("#D24D57[BRP~Items] #ffffffVocê não pode abrir o inventário do veículo em Crafting!", 255, 255, 255, true)
				end
			else
				outputChatBox("#D24D57[BRP~Items] #ffffffNenhuma chave para o cofre!!", 255, 255, 255, true)
			end
		end]]
	elseif button == 'right' and state == 'down' and showInventory and bodySearch then
		if inventoryElement == localPlayer then 
			if cursorInSlot[2] > 0 then 
				if not isMove and cursorInSlot[1] > 0  then
					useItem(itemTable[getItemType(cursorInSlot[2])][cursorInSlot[1]]['dbID'], cursorInSlot[1], cursorInSlot[2], cursorInSlot[3], cursorInSlot[4])
				end	
			end
		end
	end
end
addEventHandler('onClientClick', root, clickInventory)

------------------------------

-- // Item lekérdezések

------------------------------

function getHaveItems(itemsWant)
	local have = 0
	for index, value in pairs(itemsWant) do
		local hasState, slot = hasItem(localPlayer, value[1])
		if hasState then
			local types = getItemToType(localPlayer, value[1])
			if playerItemTable[types][slot]['count'] >= value[2] then 
				have = have + 1
			end
		end
	end
	return have
end

function getSpecialItemName(item, itemValue, count)
	if specialItems[item] then
		return specialItems[item](item, itemValue,count)
	end
	name = getItemName(item)
	desc = getItemDescription(item)
	if itemLists.weaponID then
		return "#00FF00"..name .. "#FFFFFF\n" .. desc,"#FFA700(peso: "..getItemWeight(item).."kg)\n#FFFFFFNível requerido: #00AEFF"..getItemNeedLevel(item)
	else
		return "#00FF00"..name .. "#FFFFFF\n"..desc," #FFA700(peso: "..getItemWeight(item).."kg)"
	end	
end

function getItemSlot(slot)
	if itemTable[activeInvState] and itemTable[activeInvState][slot] and itemTable[activeInvState][slot]["itemID"] then 
		return itemTable[activeInvState][slot]["itemID"]
	else
		return -1
	end
end

function getSlot(slot)
	if itemTable[activeInvState] and itemTable[activeInvState][slot] and itemTable[activeInvState][slot]["slot"] then 
		return itemTable[activeInvState][slot]["slot"]
	else
		return -1
	end
end

function getItemIndex(slot)
	if itemTable[activeInvState] and  itemTable[activeInvState][slot] and itemTable[activeInvState][slot]["dbID"] then 
		return itemTable[activeInvState][slot]["dbID"]
	else
		return -1
	end
end

function getItemValue(slot)
	if itemTable[activeInvState] and itemTable[activeInvState][slot] and itemTable[activeInvState][slot]["value"] then 
		return itemTable[activeInvState][slot]["value"]
	else
		return -1
	end
end

function getItemCount(slot)
	if itemTable[activeInvState] and itemTable[activeInvState][slot] and itemTable[activeInvState][slot]["count"] then 
		return itemTable[activeInvState][slot]["count"]
	else
		return -1
	end
end

function getItemDuty(slot)
	if itemTable[activeInvState] and itemTable[activeInvState][slot] and itemTable[activeInvState][slot]["duty"] then 
		return itemTable[activeInvState][slot]["duty"]
	else
		return -1
	end
end

function getItemActionBar(slot)
	if (itemTable[activeInvState][slot]["actionSlot"] or 0) < 1 then
		return true
	end
	return false
end

function getItemsWeight()
	local all = 0
	for i = 1, row * column do
		for index, value in ipairs (inventoryElem) do 
			if(itemTable[value] and itemTable[value][i] and tonumber(itemTable[value][i]['itemID'] or -1) > 0)then
				all = all + getItemWeight(itemTable[value][i]['itemID'])*tonumber(itemTable[value][i]['count'] or 1)
			end
		end
	end
	return all
end

function hasItem(element, itemID, itemValue)
	if element == localPlayer then
		local types = getItemToType(element, itemID)
		for k,v in pairs(itemTable[types] or {}) do
			if itemValue then
				if v['itemID'] == itemID and tonumber(v['value']) == tonumber(itemValue) then
					return true, k, v["value"], v["count"]
				end
			else
				if v['itemID'] == itemID then
					return true, k, v["value"], v["count"]
				end
			end
		end
	end
	return false
end

------------------------------

-- // Item változások

------------------------------

function setSlotValue(slot, item, val, db, duty)
	if (not item) then item = 0 end
	if (not val) then val = 0 end
	if (not db) then db = 1 end
	local types = getItemToType(inventoryElement, item)
	itemTable[types][slot] = {['itemID'] = itemTable[types][slot]['itemID'] or -1, ['value'] = val, ['count'] = db, ["duty"] = duty or 0, ['actionSlot'] = -1}
	triggerServerEvent('va.setSlotCount', inventoryElement, inventoryElement, types, slot, item, db, duty or 0, -1)
end

function setSlot(slot, item, val, db, duty)
	if (not item) then item = 0 end
	if (not val) then val = 0 end
	if (not db) then db = 1 end
	local types = getItemToType(inventoryElement, item)
	itemTable[types][slot] = {['itemID'] = item, ['value'] = val, ['count'] = db, ['dbID'] = itemTable[types][movedItem[1]]['dbID'], ["slot"] = slot, ["duty"] = duty, ['actionSlot'] = itemTable[types][movedItem[1]]['actionSlot']}
	triggerServerEvent('va.setSlotItem', inventoryElement, inventoryElement, types, slot, item, val, db, duty, itemTable[types][movedItem[1]]['actionSlot'])
end

function setSlotCount(slot, db, item, duty)
	local types = ''
	if item then 
		types = getItemToType(inventoryElement, item)
	else
		types = activeInvState
	end
	itemTable[types][slot] = {['itemID'] = itemTable[types][slot]['itemID'] or -1, ['value'] = -1, ['count'] = db, ["duty"] = duty or 0, ['actionSlot'] = -1}
	triggerServerEvent('va.setSlotCount', inventoryElement, inventoryElement, types, slot, -1 or 0, db, duty or 0, -1, item)
end

function delSlot(slot, item)
	local types = ''
	if item then 
		types = getItemToType(inventoryElement, item)
	else
		types = activeInvState
	end
	itemTable[types][slot] = {['itemID'] = -1, ['value'] = -1, ['count'] = -1, ["duty"] = -1, ['actionSlot'] = -1}
	triggerServerEvent('va.deleteItem', inventoryElement, inventoryElement, types, slot)
end

-----------------------------

-- // KocsiBugfix

-----------------------------

function checkVehicleInfo(element)
	if not showInventory then 
		showInventory = true
	end
	toggleControl ("fire", false)
	openInventory(element)

	setElementData(source, 'playerInUse', true)
	activeInvState = 'weapon'
	removeEventHandler("onClientRender", root, drawInventory)
	addEventHandler("onClientRender", root, drawInventory)		
	setElementData(source, 'char >> element', element)
end
addEvent("va.checkVehicleInfo", true)
addEventHandler("va.checkVehicleInfo", getRootElement(), checkVehicleInfo)

function debugVehicle()
	for index, value in ipairs(getElementsByType('vehicle')) do 
		setElementData(value, "clickToVehicle" , 0)
		setElementData(value, "inUse", false)
	end

	for i = 1, row * column do	
		for index, value in ipairs (inventoryElem) do 
			setElementData(localPlayer, "va.weaponGettin"..value..i, false)
		end
	end

end
debugVehicle()

addEventHandler('onClientPlayerQuit', root, function ()
	if getElementData(source, 'char >> element') or false and getElementType(getElementData(source, 'char >> element')) == 'vehicle' then 
		setElementData(getElementData(source, 'char >> element'), "clickToVehicle", 0)
		setElementData(getElementData(source, 'char >> element'), "inUse", false)
		triggerServerEvent('va.doorState', getElementData(source, 'char >> element'), getElementData(source, 'char >> element'), 0)
	end
end)

------------------------------

-- // Panelhez való dolgok

------------------------------

function createEditFunction(type)
	if type == "create" then 
		if isElement(btn_edit) then destroyElement(btn_edit) end 
		btn_edit = guiCreateEdit (-10000, -10000, 100, 20, "", false )
		guiEditSetMaxLength(btn_edit, 5)
	else
		if isElement(btn_edit) then destroyElement(btn_edit) selectedAmount = 0 end
	end
end

function tooltip_items( text, text2 )
	--if checkCursor() then
		local x,y = getCursorPosition( )
		local x,y = x * monitorSize[1], y * monitorSize[2]
		text = tostring( text )
		if text2 then
			text2 = tostring( text2 )
		end
		
		if text == text2 then
			text2 = nil
		end
		
		local width = dxGetTextWidth( text:gsub("#%x%x%x%x%x%x", ""), 1, font ) + 20
		if text2 then
			width = math.max( width, dxGetTextWidth( text2:gsub("#%x%x%x%x%x%x", ""), 1, font) + 20 )
			text = text .. "\n" .. text2
		end
		local height = 10 * ( text2 and 5 or 3 )
		x = math.max( 10, math.min( x, monitorSize[1] - width - 10 ) )
		y = math.max( 10, math.min( y, monitorSize[2] - height - 10 ) )
		
		dxDrawRectangle( x+10, y-10, width, height+22, tocolor(0, 0, 0, 200),true )
		dxDrawText( text, x+10+width/2, y, x+10+width/2, y + height, tooltip_text_color, 1, font, "center", "center", false, false, true, true )
	--end
end

function dxDrawRectangleBox(left, top, width, height, color)
	dxDrawRectangle(left-1, top, 1, height, color)
	dxDrawRectangle(left+width, top, 1, height, color)
	dxDrawRectangle(left, top-1, width, 1, color)
	dxDrawRectangle(left, top+height, width, 1, color)
end


function isMouseInPosition ( x, y, width, height ) 
    if ( not isCursorShowing ( ) ) then 
        return false 
    end 
  
    local sx, sy = guiGetScreenSize ( ) 
    local cx, cy = getCursorPosition ( ) 
    local cx, cy = ( cx * sx ), ( cy * sy ) 
    if ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) then 
        return true 
    else 
        return false 
    end 
end 

------------------------------

-- // Görgetés

------------------------------

bindKey("mouse_wheel_down", "down", 
	function() 
		if showInventory then
			if isMouseInPosition(panelX+width-220, panelY+36, 200, height-60) then 
				if scroll < #craftLists - maxCraftRecipe then
					scroll = scroll + 1	
				end
			end
		end
	end
)

bindKey("mouse_wheel_up", "down", 
	function() 
		if showInventory then
			if isMouseInPosition(panelX+width-220, panelY+36, 200, height-60) then 
				if scroll > 0 then
					scroll = scroll - 1		
				end
			end
		end
	end
)

------------------------------

-- // verInv

------------------------------

function verinv( id )
    if id then
        local targetPlayer = id
        if targetPlayer then
            showInventory = true 
            cursorInSlot = {-1, -1, -1, -1}
            movedItem = {-1, -1, -1, -1}
            openInventory(targetPlayer)
            activeInvState = 'weapon'
            setTimer(function()
                removeEventHandler('onClientRender', root, drawInventory)
                addEventHandler('onClientRender', root, drawInventory, true, 'low-5')						
            end, 50, 1)
            toggleControl ("fire", false)
            playSound("files/sounds/open.mp3", false)
            bodySearch = false
        else
            return
        end
    else
        return
    end
end

------------------------------

-- // Money format

------------------------------

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

-- // Itemlist

------------------------------

local showItemList = false
local lastClick = 0

local itemlist = {340, 575}--{500,575}
local itemlist2 = {500,75}
local itemlistP = {monitorSize[1]/2 - itemlist[1]/2,monitorSize[2]/2 - itemlist[2]/2}
local maxshow = 13
local gorget = 0

function drawItemList()
	dxDrawRectangle(itemlistP[1],itemlistP[2],itemlist[1],itemlist[2],tocolor(0,0,0,100))
	dxDrawRectangle(itemlistP[1],itemlistP[2],itemlist[1],35,tocolor(0,0,0,255))
	dxDrawText("Lista de items",monitorSize[1]/2,itemlistP[2]+7,monitorSize[1]/2,monitorSize[2]/2,tocolor(255,255,255,255),1,comy,"center","top",false,false,false,true)
	local elem = 0
	for k,v in ipairs(itemLists) do
		if (k > gorget and elem < maxshow) then
			elem = elem +1
			dxDrawRectangle(itemlistP[1],itemlistP[2]+41*elem,itemlist[1],40,tocolor(0,0,0,100))
			dxDrawImage(itemlistP[1]+5,itemlistP[2]+41*elem,40,40,"files/items/"..k..".png")
			dxDrawText("#00FF00[".. k .."]#FFFFFF "..v.name.." (#FFA700peso:"..v.weight.."kg#FFFFFF)",itemlistP[1]+50,itemlistP[2]+41*elem+8,0,0,tocolor(255,255,255,255),1,font1,"left","top",false,false,false,true)
			dxDrawText(v.desc,itemlistP[1]+50,itemlistP[2]+41*elem+22,0,0,tocolor(255,255,255,255),1,font1)
		end
	end
end

addCommandHandler('itemlist', 
	function( commandName )
		if getElementData( localPlayer, "va.adminlevel" ) >= 5 then
			addEventHandler( "onClientRender", getRootElement(), drawItemList )
			showItemList = true
			toggleAllControls( false )
			setElementData( localPlayer, "va.actionbar", false )
		else
			return exports["va~notify"]:createNotifyS( player, "error", "Você não pode usar /".. commandName .."." )
		end
	end
)

bindKey("backspace","down",function()
	if showItemList then
		showItemList = false
		toggleAllControls( true )
		setElementData( localPlayer, "va.actionbar", true )
		removeEventHandler( "onClientRender", getRootElement(), drawItemList )
	end
end)

function scroll_down_itemlist() 
	if showItemList then
		if gorget < #itemLists - maxshow then
			gorget = gorget + 1		
		end
	end
end
bindKey( "arrow_d", "down", scroll_down_itemlist )
bindKey( "mouse_wheel_down", "down", scroll_down_itemlist )

function scroll_up_itemlist() 
	if showItemList then
		if gorget >= 1 then
			gorget = gorget - 1		
		end
	end
end
bindKey( "arrow_u", "down", scroll_up_itemlist )
bindKey( "mouse_wheel_up", "down", scroll_up_itemlist )


------------------------------

-- // Bag

------------------------------

function getBagToElement(element)
	if hasItem(element, oneLevelBagID) then
		return oneLevelBag
	elseif hasItem(element, premiumLevelBagID) then
		return premiumLevelBag
	elseif not hasItem(element, oneLevelBagID) and not hasItem(element, premiumLevelBagID) then 
		return baseWeight
	end
end


function getMaxWeight(element)
	if(tostring(getElementType(element))=="player")then
		return getBagToElement(element)
	elseif(tostring(getElementType(element))=="vehicle")then
		return vehicleWeight[getElementModel(element)] or 50  --50
	elseif(tostring(getElementType(element))=="object")then
		return 100
	end
	return 0
end