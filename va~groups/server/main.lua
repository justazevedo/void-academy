function onStartup( )
    for index, value in ipairs( groups ) do
        teams = createTeam( string.gsub( groups[index].name, "_", " "), groups[index].color[1], groups[index].color[2], groups[index].color[3] )
    end
end
addEventHandler( "onResourceStart", resourceRoot, onStartup )

function spawnPlayer( player, x, y, z, model, team )
    team = getTeamFromName( team )
    setPlayerTeam( player, team )
    exports["va~main"]:spawn( player, x, y, z, 0, model, 0, 0, team )
    setCameraTarget( player )
    triggerClientEvent( player, 'va.closeGroups', player )
end
addEvent( 'va.spawnGroups', true )
addEventHandler( 'va.spawnGroups', root, spawnPlayer )