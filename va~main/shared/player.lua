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

function getNearestElement(thePlayer, elementType, distance)
	local lastMinDis = distance-0.0001
	local nearestElement = false
	local px,py,pz = getElementPosition(thePlayer)
	local pInt = getElementInterior(thePlayer)
	local pDim = getElementDimension(thePlayer)
    
	for _,e in pairs(getElementsByType(elementType)) do
		local eInt,eDim = getElementInterior(e),getElementDimension(e)
		if eInt == pInt and eDim == pDim and e ~= thePlayer then
			local ex,ey,ez = getElementPosition(e)
			local dis = getDistanceBetweenPoints3D(px,py,pz,ex,ey,ez)
			if dis < distance then
				if dis < lastMinDis then
					lastMinDis = dis
					nearestElement = e
				end
			end
		end
	end
	return nearestElement
end