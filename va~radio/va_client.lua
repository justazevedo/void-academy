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

function toggleRadio( )
	if getElementData( localPlayer, "va.enabledRadio" ) or false then
		guiSetVisible( browser, false )
		setElementData( localPlayer, "va.enabledRadio", false )
		toggleAllControls( true )
		showCursor( false )
	else
		guiSetVisible( browser, true )
		setElementData( localPlayer, "va.enabledRadio", true )
		toggleAllControls( false )
		showCursor( true )
	end
end

bindKey( 'backspace', 'down',
	function( )
		if getElementData( localPlayer, "va.enabledRadio" ) then
			guiSetVisible( browser, false )
			setElementData( localPlayer, "va.enabledRadio", false )
			toggleAllControls( true )
			showCursor( false )
		else
			return
		end
	end
)

function recieverFrequency( frequency )
	if frequency then
		print( frequency )
	else
		print( frequency )
		return exports["va~notify"]:createNotify( localPlayer, "info", "Coloque uma frequência correta." )
	end
end
addEvent( "va.sendFrequency", true )
addEventHandler( "va.sendFrequency", root, recieverFrequency )