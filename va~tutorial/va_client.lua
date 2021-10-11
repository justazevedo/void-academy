local screenW, screenH = guiGetScreenSize()
local browser = guiCreateBrowser( 0, 0, screenW, screenH, true, true, true )
local nui = guiGetBrowser( browser )
local link = "http://mta/local/nui/index.html"
guiSetVisible( browser, false )

addEventHandler( "onClientBrowserCreated", nui,
    function( )
        loadBrowserURL( source, link )
    end
)

function openTutorial()
    if getElementData( localPlayer, "va.newPlayer" ) then
        guiSetVisible( browser, true )
        showCursor( true )
        exports["va~interface"]:setInterface( false )
    else
        guiSetVisible( browser, false )
        showCursor( false )
        exports["va~groups"]:showGroups()
    end
end

function endTutorial()
    guiSetVisible( browser, false )
    showCursor( false )
    setElementData( localPlayer, "va.newPlayer", false )
    exports["va~notify"]:createNotify( localPlayer, "success", "Você terminou o mini-tutorial.")
    exports["va~groups"]:showGroups()
end
addEvent( "va.endTutorial", true )
addEventHandler( "va.endTutorial", root, endTutorial )