function useItem(DBID, itemSlot, itemID, itemValue, itemCount, itemType )
	if itemID == 1 then
		exports["va~radio"]:toggleRadio()
	end
	if getItemType( itemID ) == 'weapon' then
		triggerServerEvent( "va.setWeapon", localPlayer, localPlayer, itemSlot, itemID )
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