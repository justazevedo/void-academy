-- // Create Area and Collision

local table

for index, value in ipairs( safezones ) do
    table = safezones[index]
    safezones[index].name_Collision = createColRectangle( table.positions[1], table.positions[2], table.sizes[1], table.sizes[2] )
    Area = createRadarArea( table.positions[1], table.positions[2], table.sizes[1], table.sizes[2], table.color[1], table.color[2], table.color[3], table.color[4] )
    setElementData( safezones[index].name_Collision, "va.safezone", table.name )
end

function enableProtectionPlayer( theElement, matchingDimension )
    for i = 1, #safezones do
        if isElementWithinColShape( theElement, safezones[i].name_Collision ) then
            if getElementType( theElement ) == "player" then
                notifyElement( theElement, "warning", "Você entrou em uma safezone!" )
                setElementData( theElement, "va.onSafeZone", true )
                takeAllWeapons( theElement )
                setElementData( theElement, "va.weaponInHand", { -1, -1, -1 } )
			    setElementData( theElement, "va.weaponGettin" .. getElementData( theElement, "va.weaponIdData" ) .. getElementData( theElement, "va.weaponSlotData" ), false )
                for _, commands in ipairs( commandsDisable ) do
                    toggleControl( theElement, commands, false )
                end
            else
                setVehicleDamageProof( theElement, true )
                setElementData( theElement, "va.onSafeZone", true )
            end
        end
    end
end
addEventHandler( 'onColShapeHit', root, enableProtectionPlayer )

function disableProtectionPlayer( leaveElement, matchingDimension )
    if getElementType( leaveElement ) == "player" then
        setElementData( leaveElement, "va.onSafeZone", false )
        notifyElement( leaveElement, "warning", "Você saiu de uma safezone!" )
        --for _, commands in ipairs( commandsDisable ) do
            --toggleControl( leaveElement, commands, true )
        --end
    else
        setVehicleDamageProof( leaveElement, false )
        setElementData( leaveElement, "va.onSafeZone", false )
    end
end
addEventHandler( 'onColShapeLeave', root, disableProtectionPlayer )

function notifyElement( player, type, message )
    exports["va~notify"]:createNotifyS( player, type, message )
end