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

function toggleShop()
    if guiGetVisible( browser ) then
        executeBrowserJavascript( nui, "window.postMessage( { close : true }, '*')" )
        guiSetVisible( browser, false )
        showCursor( false )
        exports["va~interface"]:setInterface( true )
    else
        setTimer( function()
            guiSetVisible( browser, true )
            exports["va~interface"]:setInterface( false )
        end, 500, 1 )
        showCursor( true )
        for index, value in ipairs( items ) do
            executeBrowserJavascript( nui, "window.postMessage( { name : '".. value['name'] .."', description : '".. value['description'] .."', price : ".. value['price'] ..", itemImg : ".. value['itemID'] ..", itemID : ".. value['itemID'] ..", close : false }, '*' )" )
        end
    end
end
bindKey( 'F2', 'down', toggleShop )

function requestBuy( itemID, itemPrice, itemAmount )
    itemID = tonumber( itemID ) itemPrice = tonumber( itemPrice ) itemAmount = tonumber( itemAmount )
    if not itemAmount then itemAmount = 1 end
    triggerServerEvent( 'va.buyItem', localPlayer, localPlayer, itemID, itemPrice, itemAmount )
end
addEvent( 'va.requestBuy', true )
addEventHandler( 'va.requestBuy', root, requestBuy )