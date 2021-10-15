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

function joinIDHandler( _, theCurrentAccount, _ )
    if not ( isGuestAccount( getPlayerAccount( source ) ) ) then
        local idPlayer = getAccountID( theCurrentAccount )
        if ( idPlayer ) then
            setElementData( source, "va.playerID", idPlayer )
        else
            setElementData( source, "va.playerID", -10000 )
        end
    end
end
addEventHandler( 'onPlayerLogin', getRootElement(), joinIDHandler )

local blips = {}

function isPlayerInTeam(player, team)
    assert(isElement(player) and getElementType(player) == "player", "Bad argument 1 @ isPlayerInTeam [player expected, got " .. tostring(player) .. "]")
    assert((not team) or type(team) == "string" or (isElement(team) and getElementType(team) == "team"), "Bad argument 2 @ isPlayerInTeam [nil/string/team expected, got " .. tostring(team) .. "]")
    return getPlayerTeam(player) == (type(team) == "string" and getTeamFromName(team) or (type(team) == "userdata" and team or (getPlayerTeam(player) or true)))
end

local player_blip = {}

function onPlayerJoin( player )
    if not player then
        player = source
    end
    local R, G, B = 155, 155, 155
    player_blip[player] = createBlipAttachedTo( player, 0, 2, R, G, B )
    setElementVisibleTo( player_blip[player], root, false )
    setBlipColor( player_blip[player], R, G, B, 255 )
    setPlayerNametagShowing( player, false )
end
addEventHandler( 'onPlayerJoin', root, onPlayerJoin )

function allBlips()
    if getElementData( source, "va.onDuty" ) then
        if not getElementData( source, "va.blipsOn") then
            local players = getElementsByType( 'player' )
            for _, players_value in ipairs( players ) do
                setElementVisibleTo( player_blip[players_value], source, true )
            end
        else
            local players = getElementsByType( 'player' )
            for _, players_value in ipairs( players ) do
                setElementVisibleTo( player_blip[players_value], source, false )
            end
        end
    end
end
addEvent( 'va.blipsOn', true )
addEventHandler( 'va.blipsOn', root, allBlips )

function visibleBlip( player, oldTeam, newTeam )
    if not player then player = source end
    if not oldTeam then oldTeam = nil end
    if not newTeam then newTeam = nil end
    local team_name = getTeamName( newTeam )
    local team_members = getPlayersInTeam( getTeamFromName( team_name ) )
    for new_index, new_value in ipairs( team_members ) do
        print( new_index ..' index new team' )
        print( getPlayerName( new_value ) ..' players name new team' )
        local R, G, B = getTeamColor( newTeam )
        setElementVisibleTo( player_blip[new_value], player, true )
        setElementVisibleTo( player_blip[player], new_value, true )
        setBlipColor( player_blip[new_value], R, G, B, 255 )
        setBlipColor( player_blip[player], R, G, B, 255 )
    end
    if oldTeam ~= nil then
        local old_team_name = getTeamName( oldTeam )
        local old_team_members = getPlayersInTeam( getTeamFromName( old_team_name ) )
        for old_index, old_value in ipairs( old_team_members ) do
            print( old_index ..' index old team' )
            print( getPlayerName( old_value ) ..' players name old team' )
            setElementVisibleTo( player_blip[old_value], player, false )
            setElementVisibleTo( player_blip[player], old_value, false )
        end
    end
end
addEvent( 'va.blipRefresh', true )
addEventHandler( 'va.blipRefresh', root, visibleBlip )

function onPlayerQuit()
    if player_blip[source] and isElement( player_blip[source] ) then
        destroyElement( player_blip[source] )
    end
    if isTimer( refreshBlip ) then
        killTimer( refreshBlip )
    end
end
addEventHandler( 'onPlayerQuit', root, onPlayerQuit )