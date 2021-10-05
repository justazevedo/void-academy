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