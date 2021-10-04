function makeVehicle( player, commandName, name )
    if ( tonumber( getElementData( player, "va.adminlevel" ) or 1 ) >= 1 ) then
        local carID = getVehicleModelFromName( name )
        if carID then
            local x, y, z = getElementPosition( player )
            local rx, ry, rz = getElementRotation( player )
            local thecar = createVehicle( carID, x, y, z, rx, ry, rz )
            if thecar then
                warpPedIntoVehicle( player, thecar )
                setElementData( thecar, "va.ownerCar", getPlayerName( player ) )
                setElementData( thecar, "va.ownerID", getElementData( player, "va.playerID" ) or "N/A" )
                exports["va~main"]:sendLogs( 'voidAcademy - Logs', "16750848", "O administrador **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ) .."** criou um veiculo **Nome: ".. name .." ID:".. carID .."**", 'Desenvolvido por azarado bugs' )
            else
                return exports["va~notify"]:createNotifyS( player, "error", "Não foi possivel spawnar este veículo." )
            end
        else
            return exports["va~notify"]:createNotifyS( player, "error", "Use: /".. commandName .." [Nome do Veículo]." )
        end
    else
        return exports["va~notify"]:createNotifyS( sourcePlayer, "error", "Você não pode usar /".. commandName .."." )
    end
end
addCommandHandler( commandsAdmin.createvehicle["commandName"], makeVehicle )

function destroyVehicle( player, commandName )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 1 ) then
        local vehicles = exports["va~main"]:getNearestElement( player, "vehicle", 4 )
        if vehicles then
            destroyElement( vehicles )
        end
    else
        return exports["va~notify"]:createNotifyS( player, "error", "Você não pode usar /".. commandName .."." )
    end
end
addCommandHandler( commandsAdmin.destroyvehicle["commandName"], destroyVehicle )

function infosVehicle( player, commandName )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 1 ) then
        local vehicles = exports["va~main"]:getNearestElement( player, "vehicle", 4 )
        if vehicles then
            local ownerCar = getElementData( vehicles, "va.ownerCar" ) or "voidAcademy"
            local ownerID = getElementData( vehicles, "va.ownerID" ) or 'N/A'
            exports["va~notify"]:createNotifyS( player, "info", "Dono: ".. ownerCar .." ID: ".. ownerID .."<br>Nome do Veiculo: ".. getVehicleNameFromModel( getElementModel( vehicles ) ) .."<br>ID do veiculo:" .. getElementModel( vehicles ) .."")
        end
    else
        return exports["va~notify"]:createNotifyS( player, "error", "Você não pode usar /".. commandName .."." )
    end
end
addCommandHandler( commandsAdmin.infosvehicle["commandName"], infosVehicle )

function fixTheVehicle( player, commandName, id )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 1 ) then
        id = tonumber( id )
        local vehicles = exports["va~main"]:getNearestElement( player, "vehicle", 4 )
        if not id and vehicles then
            local owner = getElementData( vehicles, "va.ownerCar" ) or 'voidAcademy'
            local ownerID = getElementData( vehicles, "va.ownerID" ) or 'N/A'
            exports["va~main"]:sendLogs( 'voidAcademy - Logs', "16750848", "O administrador **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ) .."** reparou um veículo de **Nome: ".. owner .." ID:".. ownerID .."**", 'Desenvolvido por azarado bugs' )
            fixVehicle( vehicles )
            local rotationX, rotationY, rotationZ = getVehicleRotation( vehicles )
			if ( rotationX > 110 ) and ( rotationX < 250 ) then
				local vehicleX, vehicleY, vehicleZ = getElementPosition( vehicles )
				setVehicleRotation ( vehicles, rotationX + 180, rotationY, rotationZ )
				setElementPosition ( vehicles, vehicleX, vehicleY, vehicleZ + 2 )
			end
        elseif id and not vehicles then
            local targetPlayer = exports["va~main"]:getPlayerID( id )
            if targetPlayer then
                local vehicle = getPedOccupiedVehicle( targetPlayer )
                local owner = getElementData( vehicle, "va.ownerCar" ) or 'voidAcademy'
                local ownerID = getElementData( vehicle, "va.ownerID" ) or 'N/A'
                exports["va~main"]:sendLogs( 'voidAcademy - Logs', "16750848", "O administrador **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ) .."** reparou um veículo de **Nome: ".. owner .." ID:".. ownerID .."**", 'Desenvolvido por azarado bugs' )
                fixVehicle( vehicle )
                local rotationX, rotationY, rotationZ = getVehicleRotation( vehicle )
                if ( rotationX > 110 ) and ( rotationX < 250 ) then
                    local vehicleX, vehicleY, vehicleZ = getElementPosition( vehicle )
                    setVehicleRotation ( vehicle, rotationX + 180, rotationY, rotationZ )
                    setElementPosition ( vehicle, vehicleX, vehicleY, vehicleZ + 2 )
                end
            else
                return exports["va~notify"]:createNotifyS( player, "error", "Jogador não encontrado." )
            end
        elseif id and vehicles then
            local targetPlayer = exports["va~main"]:getPlayerID( id )
            if targetPlayer then
                local vehicle = getPedOccupiedVehicle( targetPlayer )
                local owner = getElementData( vehicle, "va.ownerCar" ) or 'voidAcademy'
                local ownerID = getElementData( vehicle, "va.ownerID" ) or 'N/A'
                exports["va~main"]:sendLogs( 'voidAcademy - Logs', "16750848", "O administrador **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ) .."** reparou um veículo de **Nome: ".. owner .." ID:".. ownerID .."**", 'Desenvolvido por azarado bugs' )
                fixVehicle( vehicle )
                local rotationX, rotationY, rotationZ = getVehicleRotation( vehicle )
                if ( rotationX > 110 ) and ( rotationX < 250 ) then
                    local vehicleX, vehicleY, vehicleZ = getElementPosition( vehicle )
                    setVehicleRotation ( vehicle, rotationX + 180, rotationY, rotationZ )
                    setElementPosition ( vehicle, vehicleX, vehicleY, vehicleZ + 2 )
                end
            else
                return exports["va~notify"]:createNotifyS( player, "error", "Jogador não encontrado." )
            end
        end
    else
        return exports["va~notify"]:createNotifyS( player, "error", "Você não pode usar /".. commandName .."." )
    end
end
addCommandHandler( commandsAdmin.fixVehicle["commandName"], fixTheVehicle )

function nameVehicles( player, commandName )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 1 ) then
        for index, value in ipairs( vehicleNames ) do
            outputConsole( value, player )
        end
        exports["va~notify"]:createNotifyS( player, "info", "Pressione F8 para ver a lista de veículos")
    else
        return exports["va~notify"]:createNotifyS( player, "error", "Você não pode usar /".. commandName .."." )
    end
end
addCommandHandler( commandsAdmin.namevehicle["commandName"], nameVehicles )