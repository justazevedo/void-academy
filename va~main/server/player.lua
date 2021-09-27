if not fileExists( ':'.. getResourceName( getThisResource( ) ) ..'/server/resources.lua' ) then
    stopResource( getThisResource( ) )
    return outputDebugString( 'INFO: Servidor Não Autorizado!' )
end

function spawn( player, x, y, z, rot, model, int, dim, team )
    spawnPlayer( player, x, y, z, rot, model, int, dim )
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

for index, teams in ipairs( getElementsByType( "team" ) ) do
    if ( getTeamFriendlyFire( teams ) == false ) then
        setTeamFriendlyFire( teams, true )
    end
end