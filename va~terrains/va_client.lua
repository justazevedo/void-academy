for index, value in ipairs( terrains ) do
    terrains[index].name_collisions = createColRectangle( terrains[index].positions[1], terrains[index].positions[2], terrains[index].sizes[1], terrains[index].sizes[2] )
    terrains[index].name_areas = createRadarArea( terrains[index].positions[1], terrains[index].positions[2], terrains[index].sizes[1], terrains[index].sizes[2], 155, 155, 155, 255 )
    setElementData( terrains[index].name_collisions, "va.terrains", terrains[index].name )
    setElementData( terrains[index].name_collisions, "va.terrainsON", false )
    setElementData( terrains[index].name_areas, "va.areasname", terrains[index].name )
    setElementData( terrains[index].name_collisions, "va.ownerby", 'Unknown' )
end

function startDominations()
    for i = 1, #terrains do
        if isElementWithinColShape( localPlayer, terrains[i].name_collisions ) then
            if not getElementData( terrains[i].name_collisions, "va.terrainsON" ) then
                if getElementData( terrains[i].name_collisions, "va.ownerby" ) ~= getTeamName( getPlayerTeam( localPlayer ) ) then
                    local playersOnTeam = getPlayersInTeam( getPlayerTeam( localPlayer ) )
                    exports["va~notify"]:createNotify( playersOnTeam, "info", "Seu membro de equipe ".. getPlayerName( localPlayer ) .." começou a dominar o território de ".. getElementData( terrains[i].name_collisions, "va.terrains" ) ..", ajude-o.")
                    exports["va~notify"]:createNotify( root, "warning", "A equipe ".. getTeamName( getPlayerTeam( localPlayer ) ) .." está dominando o território ".. getElementData( terrains[i].name_collisions, "va.terrains" ) .."." )
                    setElementData( terrains[i].name_collisions, "va.terrainsON", true )
                    setRadarAreaFlashing( terrains[i].name_areas, true )
                    dominations_timer = setTimer( 
                        function()
                            if getElementData( terrains[i].name_collisions, "va.terrainsON" ) then
                                exports["va~notify"]:createNotify( playersOnTeam, "success", "Seu membro de equipe ".. getPlayerName( localPlayer ) .." conseguiu dominar o território de ".. getElementData( terrains[i].name_collisions, "va.terrains" ) ..", e todos do time recebeu V$".. payments )
                                local playerTeam = getPlayerTeam( localPlayer )
                                setElementData( terrains[i].name_collisions, "va.terrainsON", false )
                                setRadarAreaFlashing( terrains[i].name_areas, false )
                                setElementData( terrains[i].name_collisions, "va.ownerby", getTeamName( playerTeam ) )
                                local r, g, b = getTeamColor( playerTeam )
                                setRadarAreaColor( terrains[i].name_areas, r, g, b )
                                triggerServerEvent( 'va.giveMoneyTeam', localPlayer, getTeamName( playerTeam ), payments )
                            end
                        end, timer_to_dominations * 1000, 1
                    )
                else
                    return exports["va~notify"]:createNotify( localPlayer, "error", "Esse território já está dominado pela sua equipe!" )
                end
            else
                return exports["va~notify"]:createNotify( localPlayer, "error", "Alguém já está tentando dominar esse território!" )
            end
        end
    end
end
addCommandHandler( 'dominar', startDominations )

function cancelDominations( theElement, matchingDimension )
    if ( theElement == localPlayer ) then
        for i = 1, #terrains do
            if getElementData( source, "va.terrainsON" ) then
                local playersOnTeam = getPlayersInTeam( getPlayerTeam( localPlayer ) )
                if isTimer( dominations_timer ) then
                    killTimer( dominations_timer )
                end
                setElementData( source, "va.terrainsON", false )
                setRadarAreaFlashing( terrains[i].name_areas, false )
                exports["va~notify"]:createNotify( root, "warning", "A equipe ".. getTeamName( getPlayerTeam( localPlayer ) ) .." não conseguiu dominar o território ".. getElementData( terrains[i].name_collisions, "va.terrains" ) .."." )
                exports["va~notify"]:createNotify( playersOnTeam, "warning", "Seu membro de equipe ".. getPlayerName( localPlayer ) .." não conseguiu dominar o território de ".. getElementData( terrains[i].name_collisions, "va.terrains" ) )
                if not getElementData( source, "va.ownerby" ) == 'Unknown' then
                    local r, g, b = getTeamColor( getTeamFromName( getElementData( source, "va.ownerby" ) ) )
                    setRadarAreaColor( terrains[i].name_areas, r, g, b )
                else
                    setRadarAreaColor( terrains[i].name_areas, 155, 155, 155 )
                end
            else
                return
            end
        end
    end
end
addEventHandler( 'onClientColShapeLeave', root, cancelDominations )