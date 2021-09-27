local connection = dbConnect("sqlite", "database.db")

function energy_can( player )
    if tonumber( getElementData( player, "va.energy" ) or 0 ) > 0 then
        return --exports["va~notify"]:createNotifyS( player, "error", "Você já está com o efeito do energético." )
    else
        local playerX, playerY, playerZ = getElementPosition( player )
        local energy_can = createObject( 2647, playerX, playerY, playerZ )
        setPedAnimation( player, "vending", "vend_drink2_p", 1000, true, true, false )
        exports["va~bone_attach"]:attachElementToBone( energy_can, player, 11, 0, 0, 0.06, 90, 60 )
        setTimer( function( )
            setPedAnimation( player, nil )
            setElementData( player, "va.energy", 100 )
            destroyElement( energy_can )
            triggerClientEvent( player, "va.drink_energy", player )
        end, 5000, 1)
    end
end
addEvent( 'va.energy_can', true )
addEventHandler( 'va.energy_can', root, energy_can )