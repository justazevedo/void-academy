SETTINGS_REFRESH = 2000 -- Interval in which team channels are refreshed, in MS.
bShowChatIcons = true

voicePlayers = {}
globalMuted = {}

---
--[[
addEventHandler ( "onClientPlayerVoiceStart", root,
	function()
		if isPlayerVoiceMuted ( source ) then
			cancelEvent()
			return
		end
		voicePlayers[source] = true
	end
)]]--

local range = 5

addEventHandler ( "onClientPlayerVoiceStart", root, 
function() 
    if (source and isElement(source) and getElementType(source) == "player") and localPlayer ~= source then 

		if getElementData(source, "inCall") == true then 
		voicePlayers[source] = true 
		
		else
	
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
) 


--[[
addEventHandler("onClientPreRender", root,
    function ()
       local players = getElementsByType("player", root, true) -- table of sounds which will be transformed into 3D
	   for k, v in ipairs(players) do 
	   if getElementData(v, "inCall") == false then 
		setSoundVolume(v, 10)
		setSoundPan(v, 0)
		end
		end
end
, false)
]]--

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
--[[
setTimer ( 
	function()
		bShowChatIcons = getElementData ( resourceRoot, "show_chat_icon", show_chat_icon )
	end,
SETTINGS_REFRESH, 0 )]]--