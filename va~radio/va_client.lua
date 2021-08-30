local screenW, screenH = guiGetScreenSize()
local browser = guiCreateBrowser( 0, 0, screenW, screenH, true, true, true )
local nui = guiGetBrowser( browser )
local link = "http://mta/local/nui/nui.html"
guiSetVisible( browser, false )

if fileExists( ':va~radio/server/resource.lua' ) then
    stopResource( getThisResource( ) )
    return outputDebugString( 'INFO: Servidor Não Autorizado!' )
end

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
		if tonumber( getElementData( localPlayer, "va.frequencyR" ) or 0 ) > 0 then
			--executeBrowserJavaScript( nui, "window.postMessage( { frequency : ".. getElementData( localPlayer, "va.frequencyR" ) or false .." }, '*' )")
		end
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

bindKey( 'tab', 'both',
	function( key, keyState )
		if keyState == "down" then
			if tonumber( getElementData( localPlayer, "va.frequencyR" ) or 0 ) > 0 then
				setElementData( localPlayer, "va.radioLiberado", true )
			else
				setElementData( localPlayer, "va.radioLiberado", false )
			end
		elseif keyState == "up" then
			setElementData( localPlayer, "va.radioLiberado", false )
		end
	end
)

function recieverFrequency( frequency )
	if frequency then
		setElementData( localPlayer, "va.frequencyR", frequency )
		exports["va~voice"]:toggleRadio()
	else
		return exports["va~notify"]:createNotify( localPlayer, "info", "Coloque uma frequência correta." )
	end
end
addEvent( "va.sendFrequency", true )
addEventHandler( "va.sendFrequency", root, recieverFrequency )