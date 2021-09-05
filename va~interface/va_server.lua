if not fileExists( ':'.. getResourceName( getThisResource( ) ) ..'/resource.lua' ) then
    stopResource( getThisResource( ) )
    return outputDebugString( 'INFO: Servidor Não Autorizado!' )
end