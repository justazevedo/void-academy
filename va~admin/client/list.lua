local screenW, screenH = guiGetScreenSize()
local browser = guiCreateBrowser( 0, 0, screenW, screenH, true, true, true )
local nui = guiGetBrowser( browser )
local link = "http://mta/local/html/index.html"
guiSetVisible( browser, false )

addEventHandler( "onClientBrowserCreated", nui,
    function( )
        loadBrowserURL( source, link )
    end
)

i = 0

function openList( commandName )
    if ( tonumber( getElementData( localPlayer, "va.adminlevel" ) ) >= 1 ) then
        if not guiGetVisible( browser ) then
            guiSetVisible( browser, true )
            if exports["va~interface"]:getHud() then
                exports["va~interface"]:setInterface( false )
            end
            showCursor( true )
            for index, value in pairs( commandsAdmin ) do
                executeBrowserJavascript( nui, "window.postMessage( { name : '".. value["commandName"] .."', description : '".. value["description"] .."', close : false }, '*' )" )
            end
        else
            executeBrowserJavascript( nui, "window.postMessage( { close : true }, '*')" )
            guiSetVisible( browser, false )
            if not exports["va~interface"]:getHud() then
                exports["va~interface"]:setInterface( true )
            end
            showCursor( false )
        end
    else
        return exports["va~notify"]:createNotify( localPlayer, "error", "Você não pode usar /".. commandName .."." )
    end
end
addCommandHandler( 'ahelp', openList )

bindKey( 'backspace', 'down',
    function()
        if guiGetVisible( browser ) then
            executeBrowserJavascript( nui, "window.postMessage( { close : true }, '*')" )
            guiSetVisible( browser, false )
            if not exports["va~interface"]:getHud() then
                exports["va~interface"]:setInterface( true )
            end
            showCursor( false )
        end
    end
)