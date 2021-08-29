local screenW, screenH = guiGetScreenSize()
local browser = createBrowser( screenW, screenH, true, true )
local link = "http://mta/local/nui/nui.html"
local components = { "weapon", "ammo", "health", "clock", "money", "breath", "armour", "wanted", "radar", "area_name", "radio", "vehicle_name" }

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

voice = 0

function browserRender()
    if tonumber( getElementData( localPlayer, "va.frequencyR" ) or 0 ) > 0 then
        if getElementData( localPlayer, "va.radioLiberado") and voice == 1 then
            dxDrawText("Frequencia: #fff000".. getElementData( localPlayer, "va.frequencyR" ) .."MHz", screenW * 0.8516, screenH * 0.9861, screenW * 0.9089, screenH * 1.0000, tocolor(155, 155, 155, 255), 1.00, "default", "left", "top", false, false, false, true, false)
        else
            dxDrawText("Frequencia: ".. getElementData( localPlayer, "va.frequencyR" ) .."MHz", screenW * 0.8516, screenH * 0.9861, screenW * 0.9089, screenH * 1.0000, tocolor(155, 155, 155, 255), 1.00, "default", "left", "top", false, false, false, true, false)
        end
    end
    if not getElementData( localPlayer, "va.radioLiberado") and voice == 1 then
        dxDrawText("Voice: #fff000Ativado", screenW * 0.9115, screenH * 0.9861, screenW * 0.9531, screenH * 1.0000, tocolor(155, 155, 155, 255), 1.00, "default", "left", "top", false, false, false, true, false)
    else
        dxDrawText("Voice: Desativado", screenW * 0.9050, screenH * 0.9861, screenW * 0.9531, screenH * 1.0000, tocolor(155, 155, 155, 255), 1.00, "default", "left", "top", false, false, false, true, false)
    end
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
    local clips = getPedAmmoInClip( localPlayer )
    if ( weapon ) then
        executeBrowserJavascript( browser, "window.postMessage( { health: ".. health ..", armour : ".. armour ..", ammo : ".. clips ..", money : ".. money ..", opacity : 1 }, '*' )" )
    else
        executeBrowserJavascript( browser, "window.postMessage( { health: ".. health ..", armour : ".. armour ..", ammo : false, money : ".. money ..", opacity : 1 }, '*' )" )
    end
end

function setInterface( value )
    if value then
        if not isEventHandlerAdded( 'onClientRender', root, browserRender ) then
            addEventHandler( "onClientRender", root, browserRender )
        end
        if not isTimer( statsPlayer ) then
            statsPlayer = setTimer( playerStats, 100, 0 )
        end
        setElementData( localPlayer, "va.actionbar", true )
    else
        if isTimer( statsPlayer ) then
            killTimer( statsPlayer )
        end
        setElementData( localPlayer, "va.actionbar", false )
        executeBrowserJavascript( browser, "window.postMessage( { health: 0, armour : 0, opacity : 0 }, '*' )" )
        setTimer( function( )
            if isEventHandlerAdded( 'onClientRender', root, browserRender ) then
                removeEventHandler( "onClientRender", root, browserRender )
            end
        end, 2000, 1 )
    end
end
