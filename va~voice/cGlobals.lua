SETTINGS_REFRESH = 2000 -- Interval in which team channels are refreshed, in MS.
bShowChatIcons = true

voicePlayers = {}
globalMuted = {}

local range = 8

addEventHandler ( "onClientPlayerVoiceStart", root, 
function() 
    if (source and isElement(source) and getElementType(source) == "player") and localPlayer ~= source then 
		if getElementData( source, "va.muteVoice") then
			cancelEvent()
		else
			if getElementData(source, "va.inCall") == true then 
				voicePlayers[source] = true 
			else
				local voiceRange = getElementData( localPlayer, "va.rangeVoice" )
				if voiceRange == "Falando" then
					range[source] = 8
				elseif voiceRange == "Gritando" then
					range[source] = 20
				elseif voiceRange == "Susurrando" then
					range[source] = 3
				end
				local sX, sY, sZ = getElementPosition(localPlayer) 
				local rX, rY, rZ = getElementPosition(source) 
				local distance = getDistanceBetweenPoints3D(sX, sY, sZ, rX, rY, rZ) 
				if distance <= range then 
					voicePlayers[source] = true 
				else 
					cancelEvent()
				end 
			end
		end
    end 
end     
) 

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