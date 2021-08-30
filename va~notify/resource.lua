function protection( )
    local resource = getResourceFromName( "va~main" )
    local thisResource = getResourceName( getThisResource( ) )
    local resourceState = getResourceState( resource )
    if resourceState == "running" then
        return outputDebugString( 'INFO: Servidor Autorizado Para '.. thisResource )
    else
        stopResource( getThisResource( ) )
        return outputDebugString( 'INFO: Servidor Não Autorizado!' )
    end
end
addEventHandler( 'onResourceStart', resourceRoot, protection )