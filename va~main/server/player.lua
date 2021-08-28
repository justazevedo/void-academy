function spawn( player, x, y, z, rot, int, dim, team )
    spawnPlayer( player, x, y, z, rot, getElementModel( source ), int, dim, team )
    setElementHealth( player, 100 )
    setPedArmor( player, 100 )
end
addEvent( "va.spawn", true )
addEventHandler( "va.spawn", root, spawn )

function playerID( thePreviousAccount, theCurrentAccount, autologin )
    if not ( isGuestAccount( getPlayerAccount( source ) ) ) then
        local playerID = getAccountID( theCurrentAccount )
        if ( playerID ) then
            setElementData( source, "va.playerID", playerID )
        else
            setElementData( source, "va.playerID", -1 )
            return
        end
    else
        return
    end
end
addEventHandler( "onPlayerLogin", getRootElement( ), playerID )