function startResources( )
    for resourceIndex, resourceName in ipairs( listResources ) do
        --135.148.31.105
        if getServerIP() ~= "auto" then
            local resource = getResourceFromName( "va~".. resourceName )
            stopResource( resource )
            return outputDebugString( 'INFO: Servidor Não Autorizado!' )
        else
            setTimer( function( )
                local resource = getResourceFromName( "va~".. resourceName )
                outputDebugString( "starting resource NAME: ".. getResourceName( resource ) or "Unknown" .. ", AUTHOR: ".. getResourceInfo( resource, "author" ) or "Unknown" ..", VERSION: ".. getResourceInfo( resource, "version" ) or "0.0.0" )
                startResource( resource )
            end, 5000, 1 )
        end
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

function getServerIP()
    return getServerConfigSetting("serverip")
end