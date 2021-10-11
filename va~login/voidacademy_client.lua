local screenW, screenH = guiGetScreenSize()
local browser = guiCreateBrowser( 0, 0, screenW, screenH, true, true, true )
local nui = guiGetBrowser( browser )
local link = "http://mta/local/nui/nui.html"
guiSetVisible( browser, false )

addEventHandler( "onClientBrowserCreated", nui,
    function( )
        loadBrowserURL( source, link )
    end
)

function loginPanel( player, event )
    if event == "show" then
        guiSetVisible( browser, true )
        showChat( false )
        showCursor( true )
        executeBrowserJavascript( nui, "window.postMessage( { hide : 0 }, '*' )" )
        setElementData( player, "va.loggedin", false )
        toggleAllControls( false )
        setElementPosition( player, 0, 0, -3 )
        setElementFrozen( player, true )
        setTimer( function()
            exports["va~interface"]:setInterface( false )
        end, 2000, 1 )
    elseif event == "hide" then
        executeBrowserJavascript( nui, "window.postMessage( { hide : 1 }, '*' )" )
        setTimer( function()
            guiSetVisible( browser, false )
            showCursor( false )
            showChat( true )
            toggleAllControls( true )
            setElementFrozen( player, false )
        end, 1500, 1 )
    end
end
addEvent( "va.loginPanel", true )
addEventHandler( "va.loginPanel", root, loginPanel )

function logIn( )
    setElementData( localPlayer, "va.loggedin", true )
    loginPanel( localPlayer, "hide" )
    if getElementData( localPlayer, "va.newPlayer" ) then
        exports["va~tutorial"]:openTutorial()
    else
        setTimer( function()
            exports["va~groups"]:showGroups()
        end, 1500, 1 )
    end
end
addEvent( "va.logIn", true )
addEventHandler( "va.logIn", root, logIn )

-- to Javascript with mta.triggerEvent

function javaCode( event, username, password )
    if event == "logIn" then
        triggerServerEvent( "va.eventsLogIn", localPlayer, localPlayer, "logIn", username, password )
    elseif event == "register" then
        triggerServerEvent( "va.eventsLogIn", localPlayer, localPlayer, "register", username, password )
    end
end
addEvent( "va.javaCode", true )
addEventHandler( "va.javaCode", root, javaCode )