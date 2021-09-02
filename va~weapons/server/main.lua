if not fileExists( ':'.. getResourceName( getThisResource( ) ) ..'/server/resource.lua' ) then
    stopResource( getThisResource( ) )
    return outputDebugString( 'INFO: Servidor Não Autorizado!' )
end

function setTexture( element, name, texture )
    if element and name and texture then
        triggerClientEvent( root, "va.applyTexture", root, element, name, texture )
    end
end
addEvent( "va.setTexture", true )
addEventHandler( "va.setTexture", root, setTexture )

function destroyTextureS( element )
    if element then
        triggerClientEvent( root, "destroyTexture", root, element )
    end
end