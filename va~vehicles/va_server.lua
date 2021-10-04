
vehicles_created = {}
vehicles_owners = {}
vehicles_destroy = {}

for index, value in ipairs( vehicles ) do
    createVehicles = setTimer(
        function()
            local r, g, b = getTeamColor( getTeamFromName( vehicles[index].name ) )
            vehicles_teams = createVehicle( vehicles[index].idVehicle, vehicles[index].spawn[1], vehicles[index].spawn[2], vehicles[index].spawn[3] + 1, 0, 0, vehicles[index].spawn[4] )
            vehicles_created[vehicles_teams] = { vehicles[index].idVehicle, vehicles[index].spawn[1], vehicles[index].spawn[2], vehicles[index].spawn[3] + 1, 0, 0, vehicles[index].spawn[4], vehicles[index].name }
            if vehicles_teams then
                vehicles[index].spawn[1] = vehicles[index].spawn[1] - vehicles[index].spawn[5]
                vehicles[index].spawn[2] = vehicles[index].spawn[2] - vehicles[index].spawn[6]
                vehicles[index].color[1] = r
                vehicles[index].color[2] = g
                vehicles[index].color[3] = b
                setElementData( vehicles_teams, "va.vehiclesTeam", vehicles[index].name )
                setVehicleDamageProof( vehicles_teams, true )
                setElementFrozen( vehicles_teams, true )
                setVehicleColor( vehicles_teams, vehicles[index].color[1], vehicles[index].color[2], vehicles[index].color[3] )
            else
                if isTimer( createVehicles ) then
                    killTimer( createVehicles )
                end
            end
        end, 1000, vehicles[index].amountVehicles
    )
end

local function onEnter( player )
    local teamPlayer = getPlayerTeam( player )
    local teamName = getTeamName( teamPlayer )
    if getElementData( source, "va.vehiclesTeam" ) == teamName then
        setVehicleDamageProof( source, false )
        setElementFrozen( source, false )
        local vehicleData = vehicles_created[source]
        setTimer( createNewVehicle, vehicles_respawn_timer * 1000, 1, vehicleData )
        vehicles_created[source] = nil
        if not vehicles_owners[player] then
            vehicles_owners[player] = {}
        end
        table.insert( vehicles_owners, source )
        removeEventHandler( 'onVehicleEnter', source, onEnter )
    else
        return cancelEvent(), exports["va~notify"]:createNotifyS( player, "warning", "Esse veículo não pertence a seu time" )
    end
end

local function destroyVehicle( vehicle )
    if vehicle and isElement( vehicle ) and getElementType( vehicle ) == "vehicle" then
        destroyElement( vehicle )
    end
end

local function destroyTimer()
    if vehicles_destroy[source] and isTimer( vehicles_destroy[source] ) then
        killTimer( vehicles_destroy[source] )
    end
end

function createNewVehicle( vehicleData )
    local model, vehicleX, vehicleY, vehicleZ, vehicleRX, vehicleRY, vehicleRZ, vehicleTeamName = unpack( vehicleData )
    local r, g, b = getTeamColor( getTeamFromName( vehicleTeamName ) )
    local newVehicle = createVehicle( model, vehicleX, vehicleY, vehicleZ, vehicleRX, vehicleRY, vehicleRZ )
    setElementData( newVehicle, "va.vehiclesTeam", vehicleTeamName )
    setVehicleColor( newVehicle, r, g, b )
    setVehicleDamageProof( newVehicle, true )
    setElementFrozen( newVehicle, true )
    vehicles_created[newVehicle] = vehicleData
    addEventHandler( 'onVehicleStartEnter', newVehicle, onEnter )
end

local function onExit()
    vehicles_destroy[source] = setTimer( destroyVehicle, vehicles_destroy_timer * 1000, 1, source )
    addEventHandler( 'onVehicleEnter', source, destroyTimer )
end
addEventHandler( 'onVehicleStartEnter', root, onEnter )
addEventHandler( 'onVehicleExit', root, onExit )