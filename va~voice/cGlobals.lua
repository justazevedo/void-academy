SETTINGS_REFRESH = 2000 -- Interval in which team channels are refreshed, in MS.
bShowChatIcons = true

voicePlayers = {}
globalMuted = {}

falandoRadio = {}
falandoRadioP = false

addEventHandler ( "onClientPlayerVoiceStart", root, 
function() 
    if (source and isElement(source) and getElementType(source) == "player") and localPlayer ~= source then 
        local sX, sY, sZ = getElementPosition(localPlayer) 
        local rX, rY, rZ = getElementPosition(source) 
        local distance = getDistanceBetweenPoints3D(sX, sY, sZ, rX, rY, rZ) 
        if distance <= 4 then 
            voicePlayers[source] = true 
		elseif falandoRadio[source] and getElementData( localPlayer,"va.frequencyR" ) == getElementData( source,"va.frequencyR" ) then
			if getElementData( localPlayer,"va.frequencyR" ) == nil or getElementData( source,"va.frequencyR" ) == nil then
				cancelEvent()
				return
			end
			if not sound then
			local sound = playSound("audio/start.wav")
			setSoundVolume(sound, 0.1)
			end 
			voicePlayers[source] = true
		else 
			cancelEvent()--This was the shit 
		end 
    end 
end 
)

addEvent("toggleRadioForPlayer", true)
addEventHandler ( "toggleRadioForPlayer", root,
    function()
        if falandoRadio[source] then
            falandoRadio[source] = nil
        else
		    table.insert( falandoRadio, source )
		    falandoRadio[source] = true
		end
    end
)

function toggleRadio( )
	triggerServerEvent( "onClientToggleRadio", localPlayer )
	falandoRadioP = not falandoRadioP
	if falandoRadioP then
		print( 'speak in radio' )
	else
	end
end

addEventHandler ( "onClientPlayerVoiceStop", root,
	function()
		voicePlayers[source] = nil
	end
)

addEventHandler ( "onClientPlayerQuit", root,
	function()
		voicePlayers[source] = nil
	end
)
---

function checkValidPlayer ( player )
	if not isElement(player) or getElementType(player) ~= "player" then
		outputDebugString ( "is/setPlayerVoiceMuted: Bad 'player' argument", 2 )
		return false
	end
	return true
end

---

setTimer ( 
	function()
		bShowChatIcons = getElementData ( resourceRoot, "show_chat_icon", show_chat_icon )
	end,
SETTINGS_REFRESH, 0 )
