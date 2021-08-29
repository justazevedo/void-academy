function startResources( )
    for resourceIndex, resourceName in ipairs( listResources ) do
        local resource = getResourceFromName( "va~".. resourceName )
        outputDebugString( "starting resource NAME: ".. getResourceName( resource ) .. ", AUTHOR: ".. getResourceInfo( resource, "author" ) ..", VERSION: ".. getResourceInfo( resource, "version" ) )
        startResource( resource )
    end
end
addEventHandler( "onResourceStart", resourceRoot, startResources )

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end