local screenW, screenH = guiGetScreenSize()
local browser = createBrowser( screenW, screenH, true, true )
local link = "http://mta/local/nui/nui.html"

function browserRender()
    dxDrawImage( 0, 0, screenW, screenH, browser, 0, 0, 0, tocolor(255, 255, 255, 255), true )
end

addEventHandler("onClientBrowserCreated", browser, 
	function()
		loadBrowserURL( source, link )
        outputDebugString( "Loading weblink notify!")
        outputDebugString( "Notify startup!")
        addEventHandler( "onClientRender", root, browserRender )
	end
)

function createNotify( player, type, message )
    executeBrowserJavascript( browser, "window.postMessage( { type : '".. type .."', message : '".. message .."' }, '*' )" )
end
addEvent( "va.notify", true )
addEventHandler( "va.notify", root, createNotify)