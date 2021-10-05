local screenW, screenH = guiGetScreenSize()
local browser = createBrowser( screenW, screenH, true, true )
local link = "http://mta/local/nui/nui.html"
local hud
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

function browserRender()
    dxDrawImage( 0, 0, screenW, screenH, browser, 0, 0, 0, tocolor(255, 255, 255, 255) )
end

addEventHandler( "onClientPlayerVoiceStart", root,
    function( )
        setElementData( localPlayer, "va.voiceStats", 1 )
    end
)

addEventHandler( "onClientPlayerVoiceStop", root,
    function( )
        setElementData( localPlayer, "va.voiceStats", 0 )
    end
)

addEventHandler("onClientBrowserCreated", browser, 
	function()
		loadBrowserURL( source, link )
        outputDebugString( "Loading weblink interface!")
        outputDebugString( "Interface startup!")
        hud = true
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
    local voice = getElementData( localPlayer, "va.voiceStats" ) or 0
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
        hud = true
        executeBrowserJavascript( browser, "window.postMessage( { opacity : 1 }, '*' )" )
        if not isEventHandlerAdded( 'onClientRender', root, browserRender ) then
            addEventHandler( "onClientRender", root, browserRender )
        end
        statsPlayer = setTimer( playerStats, 100, 0 )
        setElementData( localPlayer, "va.actionbar", true )
        showChat( true )
    else
        hud = false
        if isTimer( statsPlayer ) then
            killTimer( statsPlayer )
        end
        setElementData( localPlayer, "va.actionbar", false )
        showChat( false )
        executeBrowserJavascript( browser, "window.postMessage( { opacity : 0 }, '*' )" )
        setTimer( function( )
            if isEventHandlerAdded( 'onClientRender', root, browserRender ) then
                removeEventHandler( "onClientRender", root, browserRender )
            end
        end, 300, 1 )
    end
end

function getHud()
    return hud
end