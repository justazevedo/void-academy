if not fileExists( ':'.. getResourceName( getThisResource( ) ) ..'/server/resource.lua' ) then
    stopResource( getThisResource( ) )
    return outputDebugString( 'INFO: Servidor Não Autorizado!' )
end

function onStartup( )
    for index, value in ipairs( groups ) do
        teams = createTeam( string.gsub( groups[index].name, "_", " " ), groups[index].color[1], groups[index].color[2], groups[index].color[3] )
    end
end
addEventHandler( "onResourceStart", resourceRoot, onStartup )

function spawnPlayer( player, x, y, z, model, team )
    team = getTeamFromName( team )
    setPlayerTeam( player, team )
    exports["va~main"]:spawn( player, x, y, z, 0, model, 0, 0, team )
    setCameraTarget( player )
    setTimer( 
        function()
            triggerClientEvent( player, 'va.closeGroups', player )
        end, 1000, 1
    )
end
addEvent( 'va.spawnGroups', true )
addEventHandler( 'va.spawnGroups', root, spawnPlayer )

local playerRespawn = 7

function playerWasted( ammo, attacker, weapon, bodypart )
    local playerPremium = getElementData( source, "va.deathFast" ) or false
    if playerPremium then
        playerRespawn = 2
    else
        playerRespawn = 5
    end
    exports["va~notify"]:createNotifyS( source, "info", "Você morreu aguarde ".. playerRespawn .." Segundos, para reviver" )
    setTimer( relivePlayer, playerRespawn * 1000, 1, source )
end
addEventHandler( "onPlayerWasted", root, playerWasted )

function relivePlayer( player )
    local playerModel = getElementModel( player )
    local gangID = getElementData( player, "va.gangID" ) or 0
    if gangID > 0 then
        exports["va~main"]:spawn( player, groups[gangID].spawn[1], groups[gangID].spawn[2], groups[gangID].spawn[3], 0, playerModel, 0, 0, teamName )
    else
        triggerClientEvent( player, "va.justShow", player )
    end
end
