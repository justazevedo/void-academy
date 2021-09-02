if not fileExists( ':'.. getResourceName( getThisResource( ) ) ..'/resource.lua' ) then
    stopResource( getThisResource( ) )
    return outputDebugString( 'INFO: Servidor Não Autorizado!' )
end

function createNotifyS( player, type, message )
    triggerClientEvent( player, "va.notify", player, player, type, message )
end
