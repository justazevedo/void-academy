local screenW, screenH = guiGetScreenSize()
local browser = guiCreateBrowser( 0, 0, screenW, screenH, true, true, true )
local nui = guiGetBrowser( browser )
local connect = false
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
addEvent( 'va.toggleRadio', true )
addEventHandler( 'va.toggleRadio', root, toggleRadio )

addCommandHandler( 'Fechar o radio',
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

function freeRadio()
	if tonumber( getElementData( localPlayer, "va.frequencyR" ) or 0 ) > 0 then
		local radioFree = getElementData( localPlayer, "va.radioLiberado" )
		if radioFree then
			setElementData( localPlayer, "va.radioLiberado", false )
		else
			setElementData( localPlayer, "va.radioLiberado", true )
		end
	else
		return
	end
end
addCommandHandler( 'Liberar para falar no radio', freeRadio )

function voicePlayer()
	if connect then
		local frequency = tonumber( getElementData( localPlayer, "va.frequencyR" ) )
		if frequency and frequency > 0 and frequency < 1000 then
			if getElementData( localPlayer, "va.radioLiberado" ) then
				playSound( ':va~voice/audio/voice.wav' )
				setElementData( localPlayer, "va.speakingRadio", true )
				addEventHandler( 'onClientPedsProcessed', root, playerAnimation )
			else
				cancelEvent()
			end
		end
	end
end
bindKey( 'z', 'down', voicePlayer )

function voicePlayerUp()
	if connect then
		setElementData( localPlayer, "va.speakingRadio", false )
		removeEventHandler( 'onClientPedsProcessed', root, playerAnimation )
	else
		return false
	end
end
bindKey( 'z', 'up', voicePlayerUp )

function playerAnimation()
	setElementBoneRotation(localPlayer, 32, 0, -30, 50)
	setElementBoneRotation(localPlayer, 33, 80, 30, -175)
	setElementBoneRotation(localPlayer, 34, -20, 0, 0)
	updateElementRpHAnim(localPlayer)
end

function recieverFrequency( frequency )
	if frequency then
		if not connect then
			triggerServerEvent( 'va.setChannel', localPlayer, frequency )
			playSound( ':va~voice/audio/startup.mp3' )
			setElementData( localPlayer, "va.inCall", true )
			setElementData( localPlayer, "va.frequencyR", frequency )
			connect = true
			object_radio( connect )
		else
			executeBrowserJavascript( nui, "window.postMessage( { frequency : '' }, '*' )")
			triggerServerEvent( 'va.removeChannel', localPlayer, frequency )
			playSound( ':va~voice/audio/offline.mp3' )
			setElementData( localPlayer, "va.inCall", false )
			setElementData( localPlayer, "va.frequencyR", 0 )
			connect = false
			object_radio( connect )
		end
	else
		return exports["va~notify"]:createNotify( localPlayer, "info", "Coloque uma frequência correta." )
	end
end
addEvent( "va.sendFrequency", true )
addEventHandler( "va.sendFrequency", root, recieverFrequency )

local radio_obj

function object_radio( state )
	if state then
		local playerX, playerY, playerZ = getElementPosition( localPlayer )
		radio_obj = createObject( 2663, playerX, playerY, playerZ )
		exports["va~bone_attach"]:attachElementToBone( radio_obj, localPlayer, 5, -0.05, 0.05, 0.19, 10, 90, -315 )
	else
		if isElement( radio_obj ) then
			destroyElement( radio_obj )
		end
	end
end