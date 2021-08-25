function startResources( )
    for resourceIndex, resourceName in ipairs( listResources ) do
        local resource = getResourceFromName( "va~".. resourceName )
        outputDebugString( "starting resource NAME: ".. getResourceName( resource ) .. ", AUTHOR: ".. getResourceInfo( resource, "author" ) ..", VERSION: ".. getResourceInfo( resource, "version" ) )
        startResource( resource )
    end
end
addEventHandler( "onResourceStart", resourceRoot, startResources )