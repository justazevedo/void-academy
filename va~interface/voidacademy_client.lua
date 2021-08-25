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

function browserRender()
    dxDrawImage( 0, 0, screenW, screenH, browser, 0, 0, 0, tocolor(255, 255, 255, 255) )
end

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
