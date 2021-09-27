local screenW, screenH = guiGetScreenSize()
local browser = createBrowser( screenW, screenH, true, true )
local link = "http://mta/local/nui/nui.html"
local components = { "weapon", "ammo", "health", "clock", "money", "breath", "armour", "wanted", "radar", "area_name", "radio", "vehicle_name" }
weaponInHand = false

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

local voice = 0

function browserRender()
    dxDrawImage( 0, 0, screenW, screenH, browser, 0, 0, 0, tocolor(255, 255, 255, 255) )
end

addEventHandler( "onClientPlayerVoiceStart", root,
    function( )
        voice = 1
    end
)

addEventHandler( "onClientPlayerVoiceStop", root,
    function( )
        voice = 0
    end
)

addEventHandler("onClientBrowserCreated", browser, 
	function()
		loadBrowserURL( source, link )
        outputDebugString( "Loading weblink interface!")
        outputDebugString( "Interface startup!")
        addEventHandler( "onClientRender", root, browserRender )
        for _, component in ipairs( components ) do
            setPlayerHudComponentVisible( component, false )
        end
        if not isTimer( statsPlayer ) then
            statsPlayer = setTimer( playerStats, 100, 0 )
        end
	end
)

function playerStats( )
    local health = getElementHealth( localPlayer )
    local armour = getPedArmor( localPlayer )
    local money = getPlayerMoney( localPlayer )
    local weapon = getPedWeapon( localPlayer )
    local energy = getElementData( localPlayer, "va.energy" ) or 0
    local tRadio = tostring( getElementData( localPlayer, "va.radioLiberado" ) or false )
    local frequency = getElementData( localPlayer, "va.frequencyR" ) or 0
    local voiceRange = getElementData( localPlayer, "va.rangeVoice" )
    local clips = getPedAmmoInClip( localPlayer )
    if ( weapon ) then
        weaponInHand = clips
    else
        weaponInHand = false
    end
    executeBrowserJavascript( browser, "window.postMessage( { health: ".. health ..", armour : ".. armour ..", energy : ".. energy ..", voice : '".. voiceRange .."', frequency : ".. frequency ..", talking : ".. voice ..", talkingRadio : ".. tRadio ..", ammo : ".. weaponInHand ..", money : ".. money ..", opacity : 1 }, '*' )" )
end

function changeMode()
    local voiceRange = getElementData( localPlayer, "va.rangeVoice" )
    if voiceRange == "Falando" then
       setElementData( localPlayer, "va.rangeVoice", "Gritando" )
    elseif voiceRange == "Gritando" then
        setElementData( localPlayer, "va.rangeVoice", "Susurrando" )
    elseif voiceRange == "Susurrando" then
        setElementData( localPlayer, "va.rangeVoice", "Falando" )
    end
end
addCommandHandler( 'Mudar modo de falar', changeMode )

function setInterface( value )
    if value then
        if not isEventHandlerAdded( 'onClientRender', root, browserRender ) then
            addEventHandler( "onClientRender", root, browserRender )
        end
        if not isTimer( statsPlayer ) then
            statsPlayer = setTimer( playerStats, 100, 0 )
        end
        setElementData( localPlayer, "va.actionbar", true )
        showChat( true )
    else
        if isTimer( statsPlayer ) then
            killTimer( statsPlayer )
        end
        setElementData( localPlayer, "va.actionbar", false )
        showChat( false )
        executeBrowserJavascript( browser, "window.postMessage( { health: 0, armour : 0, opacity : 0 }, '*' )" )
        setTimer( function( )
            if isEventHandlerAdded( 'onClientRender', root, browserRender ) then
                removeEventHandler( "onClientRender", root, browserRender )
            end
        end, 2000, 1 )
    end
end
