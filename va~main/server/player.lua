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

function playerDamage( attacker, weapon, bodypart, loss )
    if getElementData( source, "va.onDuty" ) then
        cancelEvent()
    end
end

for index, teams in ipairs( getElementsByType( "team" ) ) do
    if ( getTeamFriendlyFire( teams ) == true ) then
        setTeamFriendlyFire( teams, false )
    end
end