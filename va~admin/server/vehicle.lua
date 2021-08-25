function createVehicle( sourcePlayer, commandName, ... )
    if ( sourcePlayer ) then
        --if ( tonumber( getElementData( sourcePlayer, "va.adminlevel" ) ) >= 1 ) then
            local vehicleName = table.concat({...}, " ")
            local carid = getVehicleNameFromModel( vehicleName )
            if carid then
                local x, y, z = getElementPosition( sourcePlayer )
                local rx, ry, rz = getElementRotation( sourcePlayer )
                local thecar = createVehicle( carid, x, y, z )
                if not thecar then
                    return print( false )
                end
                warpPedIntoVehicle( sourcePlayer, thecar )
                setElementData( thecar, "va.ownerCar", getPlayerName( sourcePlayer ) )
                exports["va~main"]:sendLogs( 'voidAcademy - Logs', "16750848", "O administrador **".. getPlayerName( sourcePlayer ) .." ID:".. getElementData( sourcePlayer, "va.sourcePlayerID" ).. " criou um veiculo **Nome: ".. carname .." ID:".. carid .."**", 'Desenvolvido por azarado bugs' )
            else
                return exports["va~notify"]:createNotifyS( sourcePlayer, "error", "Use: /".. commandName .." [Nome do Veiculo]." )
            end
        --else
            --return exports["va~notify"]:createNotifyS( sourcePlayer, "error", "Você não pode usar /".. commandName .."." )
        --end
    end
end
addCommandHandler( commandsAdmin.createvehicle[1], createVehicle )

function destroyVehicle( player, commandName )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 1 ) then
        local vehicles = exports["va~main"]:getNearestElement( player, "vehicle", 1 )
        if vehicles then
            destroyElement( vehicles )
        end
    else
        return exports["va~notify"]:createNotifyS( player, "error", "Você não pode usar /".. commandName .."." )
    end
end
addCommandHandler( commandsAdmin.destroyvehicle[1], destroyVehicle )

function infosVehicle( player, commandName )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 10 ) then
        local vehicles = exports["va~main"]:getNearestElement( player, "vehicle", 1 )
        if vehicles then
            local ownerCar = getElementData( vehicles, "va.ownerCar" ) or "voidAcademy"
            if not ownerCar == "voidAcademy" then
                ownerID = getElementData( ownerCar, "va.playerID" )
            else
                ownerID = "N/A"
            end
            exports["va~notify"]:createNotifyS( player, "info", "Dono: ".. ownerCar .." ID: ".. ownerID .."<br>Nome do Veiculo: ".. getVehicleNameFromModel( getElementModel( vehicles ) ) .."<br>ID do veiculo:" .. getElementModel( vehicles ) .."")
        end
    else
        return exports["va~notify"]:createNotifyS( player, "error", "Você não pode usar /".. commandName .."." )
    end
end
addCommandHandler( commandsAdmin.infosvehicle[1], infosVehicle )