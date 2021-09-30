if not fileExists( ':'.. getResourceName( getThisResource( ) ) ..'/resource.lua' ) then
    stopResource( getThisResource( ) )
    return outputDebugString( 'INFO: Servidor Não Autorizado!' )
end


function giveMoneyTeam( team, amount )
    local teamPlayer = getTeamFromName( team )
    local playerTeams = getPlayersInTeam( teamPlayer )
    for _, players in ipairs( playerTeams ) do
        local targetPlayer = getPlayerFromName( getPlayerName( players ) )
        givePlayerMoney( targetPlayer, amount )
    end
end
addEvent( 'va.giveMoneyTeam', true )
addEventHandler( 'va.giveMoneyTeam', root, giveMoneyTeam )