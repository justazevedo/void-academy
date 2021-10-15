function exportShowInventory( args )
    if args then
        exports["va~inventory"]:verinv( args )
    else
        return
    end
end
addEvent( 'va.exportShowInventory', true )
addEventHandler( 'va.exportShowInventory', root, exportShowInventory )

local Collision_Jail = createColRectangle( 1530.868, -1370.392, 30, 30 )

function StopWatch( )
    if getElementData( localPlayer, "va.jail" ) then
        Timer_Jail = getElementData( localPlayer, "va.timerJail" ) or 0
        if tonumber( Timer_Jail ) > 0 then
            Timer_Jail = Timer_Jail - 1
            setElementData( localPlayer, 'va.timerJail', tonumber( Timer_Jail ) )
            setElementData( localPlayer, "va.onSafeZone", true )
            if not isElementWithinColShape( localPlayer, Collision_Jail ) then
                if not getElementData( localPlayer, "va.inSelectedGroups" ) then
                    setElementPosition( localPlayer, 1544.029, -1353.064, 329.475 )
                else
                    setElementData( localPlayer, "va.gangID", 0 )
                    triggerEvent( 'va.spawnGroups', localPlayer, localPlayer, 1544.029, -1353.064, 329.475, 0, 'Punido(s)' )
                end
            end
        elseif tonumber( Timer_Jail ) <= 0 then
            setElementData( localPlayer, 'va.timerJail', 0 )
            setElementData( localPlayer, "va.jail", false )
            setElementData( localPlayer, "va.onSafeZone", false )
            triggerEvent( "va.justShow", localPlayer )
            Timer_Jail = 0
        end
    end
end
stopwatch_jail = setTimer( StopWatch, 1000, 0 )

function startNameTag( )
    visibleTick = getTickCount()
    counter = 0
    local players = getElementsByType( "player" )
    for _, players_values in ipairs( players ) do
        setPlayerNametagShowing( players_values, false )
    end
end
addEventHandler( 'onClientResourceStart', resourceRoot, startNameTag )

local nametag_font = dxCreateFont( ":va~interface/nui/fonts/Tomorrow-Medium.ttf", 10, true )
local drawDistance = 13.0

local sx, sy = guiGetScreenSize()
local px, py = 1366, 768
local SX, SY = ( sx / px ), ( sy / py )

function drawPlayerTags()
    if getElementData( localPlayer, "va.blipsOn" ) then
        local CameraX, CameraY, CameraZ, LookX, LookY, LookZ = getCameraMatrix()
        local players = getElementsByType( 'player', root, true )
        for _, players_value in ipairs( players ) do
            local boneX, boneY, boneZ = getPedBonePosition( players_value, 8 )
            local distance = getDistanceBetweenPoints3D( CameraX, CameraY, CameraZ, LookX, LookY, LookZ )
            if distance < drawDistance then
                if ( isLineOfSightClear( CameraX, CameraY, CameraZ, LookX, LookY, LookZ, true, false, false ) ) then
                    local screenX, screenY = getScreenFromWorldPosition( boneX, boneY, boneZ + 0.3 )
                    if ( screenX and screenY ) then
                        local idPlayer = getElementData( players_value, "va.playerID" ) or "N/A"
                        local namePlayer = getPlayerName( players_value )
                        local healthPlayer = math.floor( getElementHealth( players_value ) )
                        local armourPlayer = math.floor( getPedArmor( players_value ) )
                        local weapon_id = getPedWeapon( players_value )
                        local weaponInHands = getWeaponNameFromID( weapon_id )
                        local totalAmmo = getPedTotalAmmo( players_value )
                        local player_money = getPlayerMoney( players_value )
                        local player_team = getPlayerTeam( players_value )
                        local team_name = getTeamName( player_team )
                        local infosPlayer = "NAME : ".. namePlayer .." ID : ".. idPlayer .." │ Money : ".. player_money .." │ V : ".. healthPlayer .." │ C : ".. armourPlayer .." \n Weapon : ".. weaponInHands .." │ Ammo : " .. totalAmmo .." │ Team : ".. team_name ..""
                        local infosU = string.gsub( "NAME : ".. namePlayer .." ID : ".. idPlayer .." │ Money : ".. player_money .." │ V : ".. healthPlayer .." │ C : ".. armourPlayer .." \n Weapon : ".. weaponInHands .." │ Ammo : " .. totalAmmo .." │ Team : ".. team_name .."", "#%x%x%x%x%x%x", "" )
                        local scale = SY * 0.8
                        local w = dxGetTextWidth( infosU, scale, nametag_font )
                        local h = dxGetFontHeight( scale, nametag_font )
                        dxDrawText( infosPlayer, screenX - w / 2, screenY - h - 12, w, h, color, scale, nametag_font, "left", "top", false, false, false, true, false )
                    end
                end
            end
        end
    end
end

function onClientRender()
	drawPlayerTags()
end
addEventHandler( "onClientRender", root, onClientRender )