function useItem( DBID, itemSlot, itemID, itemValue, itemCount, itemType )
	if itemID == 1 then
		exports["va~radio"]:toggleRadio()
	elseif itemID == 108 then
		local energy = getElementData( localPlayer, "va.energy" ) or 0
		if energy > 0 then
			return exports["va~notify"]:createNotify( localPlayer, "error", "Você já está com o efeito do energético." )
		else
			triggerServerEvent( 'va.energy_can', localPlayer, localPlayer )
			checkItemToTake( 108, itemSlot )
		end
	end
	if getItemType( itemID ) == 'weapon' then
		if getElementData( localPlayer, "va.onSafeZone" ) then
			return exports["va~notify"]:createNotify( localPlayer, "warning", "Você está em uma safezone." )
		else
			triggerServerEvent( "va.setWeapon", localPlayer, localPlayer, itemSlot, itemID )
		end
	end
end

function drink_energy()
	if not isTimer( energy_timer ) then
		setGameSpeed( 1.1 )
		energy_timer = setTimer( energy_drink, 1000, 0 )
	else
		setGameSpeed( 1.1 )
	end
end
addEvent( "va.drink_energy", true )
addEventHandler( "va.drink_energy", root, drink_energy )	

function energy_drink()
	local energy = getElementData( localPlayer, "va.energy" )
	if energy > 0 then
		setElementData( localPlayer, "va.energy", energy - math.random( 1, 4 ) )
	else
		setElementData( localPlayer, "va.energy", 0 )
		setGameSpeed( 1 )
		if isTimer( energy_timer ) then
			killTimer( energy_timer )
		end
	end
end

function checkItemToTake( itemID, slot )
	local count = 0
	if tonumber(itemTable[getItemType(itemID)][slot]['count'] or 0) > 1 then
		count = tonumber(itemTable[getItemType(itemID)][slot]['count']) - 1
		triggerServerEvent("va.setSlotCount", getLocalPlayer(), getLocalPlayer(), getItemType(itemID), slot, itemTable[getItemType(itemID)][slot]['value'] or 0, itemTable[getItemType(itemID)][slot]['count'] or 0, itemTable[getItemType(itemID)][slot]['duty'] or 0, itemTable[getItemType(itemID)][slot]['actionSlot'] or 0, itemID)
		setSlotCount(slot, count, itemID, itemTable[getItemType(itemID)][slot]['duty'] or 0)
	else
		itemTable[getItemType(itemID)][slot] = {-1,-1,-1,-1}
		triggerServerEvent("va.deleteItem", getLocalPlayer(), getLocalPlayer(), getItemType(itemID), slot)
	end
end

function isInSlot(xS,yS,wS,hS)
	if(isCursorShowing()) then
		XY = {guiGetScreenSize()}
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*XY[1], cursorY*XY[2]
		if(dobozbaVan(xS,yS,wS,hS, cursorX, cursorY)) then
			return true
		else
			return false
		end
	end	
end

function checkCursor()
	if not guiGetInputEnabled() and not isMTAWindowActive() and isCursorShowing( ) then
		return true
	else
		return false
	end
end

function dxCreateBorder(x,y,w,h,color)
	dxDrawRectangle(x,y,w+1,1,color,true) -- Fent
	dxDrawRectangle(x,y+1,1,h,color,true) -- Bal Oldal
	dxDrawRectangle(x+1,y+h,w,1,color,true) -- Lent Oldal
	dxDrawRectangle(x+w,y+1,1,h,color,true) -- Jobb Oldal
end