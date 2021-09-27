teamStaff = createTeam( "Staff", 155, 155, 155 )

if not fileExists( ':'.. getResourceName( getThisResource( ) ) ..'/server/resource.lua' ) then
    stopResource( getThisResource( ) )
    return outputDebugString( 'INFO: Servidor Não Autorizado!' )
end

function adminDuty( player, commandName )
    local time = getRealTime()
	local hours = time.hour
	local minutes = time.minute
	local seconds = time.second
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 1 ) then
        if not getElementData( player, "va.onDuty" ) or false then
            exports["va~main"]:batePonto( 'voidAcademy - Staffs', "16750848", "O staff **".. getPlayerName( player ) .."** **ID:".. getElementData( player, "va.playerID" ) .."** entrou em serviço as **".. hours ..":".. minutes ..":".. seconds .."**", 'Desenvolvido por azarado bugs' )
            exports["va~notify"]:createNotifyS( player, "success", "Você entrou em serviço" )
            setElementData( player, "va.onDuty", true )
            setElementHealth( player, 100 )
            setPedArmor( player, 100 )
            setPlayerTeam( player, teamStaff )
        else
            if ( exports["va~freecam"]:isPlayerFreecamEnabled( player ) ) then
                exports["va~freecam"]:setPlayerFreecamDisabled( player )
                setElementAlpha( player, 255 )
                setElementFrozen( player, false )
            end
            exports["va~main"]:batePonto( 'voidAcademy - Staffs', "16750848", "O staff **".. getPlayerName( player ) .."** **ID:".. getElementData( player, "va.playerID" ) .."** saiu de serviço as **".. hours ..":".. minutes ..":".. seconds .."**", 'Desenvolvido por azarado bugs' )
            exports["va~notify"]:createNotifyS( player, "info", "Você saiu de serviço" )
            setElementData( player, "va.onDuty", false )
            setElementHealth( player, 100 )
            setPedArmor( player, 100 )
            setPlayerTeam( player, nil )
            triggerClientEvent( player, 'va.justShow', player )
        end
    else
        return exports["va~notify"]:createNotifyS( player, "error", "Você não pode usar /".. commandName .."." )
    end
end
addCommandHandler( commandsAdmin.adminDuty["commandName"], adminDuty )

function gBan( player, commandName, id, timeBan, ... )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 3 ) then
        id = tonumber( id )
        timeBan = tonumber( timeBan )
        if id and timeBan then
            local reasonBan = table.concat( { ... }, " " )
            local targetPlayer = exports["va~main"]:getPlayerID( id )
            if targetPlayer then
                exports["va~notify"]:createNotifyS( targetPlayer, "info", "Você banido!" )
                exports["va~notify"]:createNotifyS( player, "success", "Você baniu o jogador ".. getPlayerName( targetPlayer ) .." ID:".. id .."." )
                setTimer( function()
                    banPlayer( targetPlayer, true, true, true, getPlayerName( player ), reasonBan or "Unknown", timeBan )
                end, 3000, 1 )
                exports["va~main"]:sendLogs( 'voidAcademy - Logs', "16750848", "O administrador **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ).. "** baniu o jogador **".. getPlayerName( targetPlayer ) .." ID:".. getElementData( targetPlayer, "va.playerID" ) .."** pelo motivo **".. reasonBan or "Undefined" .."**", 'Desenvolvido por azarado bugs' )
            else
                return exports["va~notify"]:createNotifyS( player, "error", "Jogador não encontrado!" )
            end
        else
            return exports["va~notify"]:createNotifyS( player, "error", "Use: /".. commandName .." [ID] [Tempo] [Motivo]." )
        end
    else
        return exports["va~notify"]:createNotifyS( player, "error", "Você não pode usar /".. commandName .."." )
    end
end
addCommandHandler( commandsAdmin.banPlayer["commandName"], gBan )

function gKick( player, commandName, id, ... )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 1 ) then
        id = tonumber( id )
        if id then
            local reasonKick = table.concat( { ... }, " " )
            local targetPlayer = exports["va~main"]:getPlayerID( id )
            if targetPlayer then
                exports["va~notify"]:createNotifyS( targetPlayer, "info", "Você foi kickado!" )
                exports["va~notify"]:createNotifyS( player, "success", "Você kickou o jogador ".. getPlayerName( targetPlayer ) .." ID:".. id .."." )
                setTimer( function()
                    kickPlayer( targetPlayer, player, reasonKick or "Unknown" )
                end, 3000, 1 )
                exports["va~main"]:sendLogs( 'voidAcademy - Logs', "16750848", "O administrador **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ) .."** kickou o jogador **".. getPlayerName( targetPlayer ) .." ID:".. getElementData( targetPlayer, "va.playerID" ).. "** pelo motivo **".. reasonKick or "Undefined" .."**", 'Desenvolvido por azarado bugs' )
            else
                return exports["va~notify"]:createNotifyS( player, "error", "Jogador não encontrado!" )
            end
        else
            return exports["va~notify"]:createNotifyS( player, "error", "Use: /".. commandName .." [ID] [Motivo]." )
        end
    else
        return exports["va~notify"]:createNotifyS( player, "error", "Você não pode usar /".. commandName .."." )
    end
end
addCommandHandler( commandsAdmin.kickPlayer["commandName"], gKick )

function tptoPlayer( player, commandName, id )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 1 ) then
        id = tonumber( id )
        if id then
            local targetPlayer = exports["va~main"]:getPlayerID( id )
            if targetPlayer then
                if ( not exports["va~freecam"]:isPlayerFreecamEnabled( player ) ) then
                    local targetX, targetY, targetZ = getElementPosition( targetPlayer )
                    setElementPosition( player, targetX, targetY, targetZ )
                    exports["va~main"]:sendLogs( 'voidAcademy - Logs', "16750848", "O administrador **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ).. "** teletransportou para o jogador ".. getPlayerName( targetPlayer ) .." ID:".. getElementData( targetPlayer, "va.playerID" ).. "**", 'Desenvolvido por azarado bugs' )
                    exports["va~notify"]:createNotifyS( player, "success", "Você se teletransportou para o jogador ".. getPlayerName( targetPlayer ) ..", ID: ".. id .."." )
                else
                    local targetCX, targetCY, targetCZ, targetC2X, targetC2Y, targetC2Z, roll, fov = getCameraMatrix( targetPlayer )
                    setCameraMatrix( player, targetCX, targetCY, targetCZ, targetC2X, targetC2Y, targetC2Z, roll, fov )
                    exports["va~main"]:sendLogs( 'voidAcademy - Logs', "16750848", "O administrador **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ).. "** teletransportou para o jogador ".. getPlayerName( targetPlayer ) .." ID:".. getElementData( targetPlayer, "va.playerID" ).. "**", 'Desenvolvido por azarado bugs' )
                    exports["va~notify"]:createNotifyS( player, "success", "Você se teletransportou para o jogador ".. getPlayerName( targetPlayer ) ..", ID: ".. id .."." )
                end
            else
                return exports["va~notify"]:createNotifyS( player, "error", "Jogador não encontrado!" )
            end
        else
            return exports["va~notify"]:createNotifyS( player, "error", "Use: /".. commandName .." [ID]." )
        end
    else
        return exports["va~notify"]:createNotifyS( player, "error", "Você não pode usar /".. commandName .."." )
    end
end
addCommandHandler( commandsAdmin.warpPlayer["commandName"], tptoPlayer )

function tptoMePlayer( player, commandName, id )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 1 ) then
        id = tonumber( id )
        if id then
            local targetPlayer = exports["va~main"]:getPlayerID( id )
            if targetPlayer then
                if ( not exports["va~freecam"]:isPlayerFreecamEnabled( targetPlayer ) ) then
                    local targetX, targetY, targetZ = getElementPosition( player )
                    setElementPosition( targetPlayer, targetX, targetY, targetZ )
                    exports["va~main"]:sendLogs( 'voidAcademy - Logs', "16750848", "O administrador **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ).. "** puxou para si mesmo o jogador ".. getPlayerName( targetPlayer ) .." ID:".. getElementData( targetPlayer, "va.playerID" ).. "**", 'Desenvolvido por azarado bugs' )
                    exports["va~notify"]:createNotifyS( targetPlayer, "success", "Você foi teletransportado para o staff ".. getPlayerName( player ) ..", ID: ".. getElementData( player, "va.playerID" ) .."." )
                else
                    local targetCX, targetCY, targetCZ, targetC2X, targetC2Y, targetC2Z, roll, fov = getCameraMatrix( targetPlayer )
                    setCameraMatrix( player, targetCX, targetCY, targetCZ, targetC2X, targetC2Y, targetC2Z, roll, fov )
                    exports["va~main"]:sendLogs( 'voidAcademy - Logs', "16750848", "O administrador **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ).. "** puxou para si mesmo o jogador ".. getPlayerName( targetPlayer ) .." ID:".. getElementData( targetPlayer, "va.playerID" ).. "**", 'Desenvolvido por azarado bugs' )
                    exports["va~notify"]:createNotifyS( targetPlayer, "success", "Você foi teletransportado para o staff ".. getPlayerName( player ) ..", ID: ".. getElementData( player, "va.playerID" ) .."." )
                end
            else
                return exports["va~notify"]:createNotifyS( player, "error", "Jogador não encontrado!" )
            end
        else
            return exports["va~notify"]:createNotifyS( player, "error", "Use: /".. commandName .." [ID]." )
        end
    else
        return exports["va~notify"]:createNotifyS( player, "error", "Você não pode usar /".. commandName .."." )
    end
end
addCommandHandler( commandsAdmin.warpPlayerToMe["commandName"], tptoMePlayer )

function tpPlayerToTarget( player, commandName, id, ntarget )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 1 ) then
        id = tonumber( id )
        ntarget = tonumber( ntarget )
        if id and ntarget then
            local playerSelected = exports["va~main"]:getPlayerID( id )
            local target = exports["va~main"]:getPlayerID( ntarget )
            local targetX, targetY, targetZ = getElementPosition( target )
            if playerSelected and target then
                if ( not exports["va~freecam"]:isPlayerFreecamEnabled( playerSelected ) ) then
                    setElementPosition( playerSelected, targetX, targetY, targetZ )
                    exports["va~main"]:sendLogs( 'voidAcademy - Logs', "16750848", "O administrador **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ).. "** telenstranportou o jogador ".. getPlayerName( playerSelected ) .." ID:".. getElementData( playerSelected, "va.playerID" ).. "** para o jogador **".. getPlayerName( target ) .." ID:".. getElementData( target, "va.playerID" ) .."**", 'Desenvolvido por azarado bugs' )
                    exports["va~notify"]:createNotifyS( playerSelected, "success", "Você foi teletransportado para o jogador ".. getPlayerName( playerSelected ) ..", ID: ".. getElementData( playerSelected, "va.playerID" ) .."." )
                else
                    local targetCX, targetCY, targetCZ, targetC2X, targetC2Y, targetC2Z, roll, fov = getCameraMatrix( target )
                    setCameraMatrix( playerSelected, targetCX, targetCY, targetCZ, targetC2X, targetC2Y, targetC2Z, roll, fov )
                    exports["va~main"]:sendLogs( 'voidAcademy - Logs', "16750848", "O administrador **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ).. "** telenstranportou o jogador ".. getPlayerName( playerSelected ) .." ID:".. getElementData( playerSelected, "va.playerID" ).. "** para o jogador **".. getPlayerName( target ) .." ID:".. getElementData( target, "va.playerID" ) .."**", 'Desenvolvido por azarado bugs' )
                    exports["va~notify"]:createNotifyS( playerSelected, "success", "Você foi teletransportado para o jogador ".. getPlayerName( playerSelected ) ..", ID: ".. getElementData( playerSelected, "va.playerID" ) .."." )
                end
            else
                return exports["va~notify"]:createNotifyS( player, "error", "Jogador(es) não encontrado!" )
            end
        else
            return exports["va~notify"]:createNotifyS( player, "error", "Use: /".. commandName .." [ID] [ID]." )
        end
    else
        return exports["va~notify"]:createNotifyS( player, "error", "Você não pode usar /".. commandName .."." )
    end
end
addCommandHandler( commandsAdmin.warpPlayerTo["commandName"], tpPlayerToTarget )

function godPlayer( player, commandName, id )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 1 ) then
        id = tonumber( id )
        if id then
            local targetPlayer = exports["va~main"]:getPlayerID( id )
            if targetPlayer then
                setElementHealth( targetPlayer, 100 )
                setPedArmor( targetPlayer, 100 )
                exports["va~main"]:sendLogs( 'voidAcademy - Logs', "16750848", "O administrador **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ).. "** usou o **/".. commandName .."** no jogador **".. getPlayerName( targetPlayer ) .." ID:".. getElementData( targetPlayer, "va.playerID" ).. "**", 'Desenvolvido por azarado bugs' )
                exports["va~notify"]:createNotifyS( targetPlayer, "info", "O administrador ".. getPlayerName( player ) .." usou o /".. commandName .." em você." )
                exports["va~notify"]:createNotifyS( player, "success", "Você usou o /".. commandName .." no jogador ".. getPlayerName( targetPlayer ) .."." )
            else
                return exports["va~notify"]:createNotifyS( player, "error", "Jogador não encontrado!" )
            end
        else
            setElementHealth( player, 100 )
            setPedArmor( player, 100 )
            exports["va~main"]:sendLogs( 'voidAcademy - Logs', "16750848", "O administrador **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ).. "** usou o /".. commandName, 'Desenvolvido por azarado bugs' )
        end
    else
        return exports["va~notify"]:createNotifyS( player, "error", "Você não pode usar /".. commandName .."." )
    end
end
addCommandHandler( commandsAdmin.godPlayer["commandName"], godPlayer )

function setHealth( player, commandName, id, health )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 1 ) then
        id = tonumber( id )
        health = tonumber( health )
        if id and health then
            local targetPlayer = exports["va~main"]:getPlayerID( id )
            if targetPlayer then
                setElementHealth( targetPlayer, health )
                exports["va~main"]:sendLogs( 'voidAcademy - Logs', "16750848", "O administrador **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ).. "** setou a vida do jogador **".. getPlayerName( targetPlayer ) .." ID:".. getElementData( targetPlayer, "va.playerID" ).. "** para **".. health .."%**", 'Desenvolvido por azarado bugs' )
                exports["va~notify"]:createNotifyS( targetPlayer, "info", "Sua vida foi setada para ".. health .."%, pelo administrador ".. getPlayerName( player ) .."." )
                exports["va~notify"]:createNotifyS( player, "success", "Você setou a vida do jogador ".. getPlayerName( targetPlayer ) ..", ".. health .."%." )
            else
                return exports["va~notify"]:createNotifyS( player, "error", "Jogador não encontrado!" )
            end
        else
            return exports["va~notify"]:createNotifyS( player, "error", "Use: /".. commandName .." [ID] [Quantia]." )
        end
    else
        return exports["va~notify"]:createNotifyS( player, "error", "Você não pode usar /".. commandName .."." )
    end
end
addCommandHandler( commandsAdmin.sethealth["commandName"], setHealth )

function setArmor( player, commandName, id, armor )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 1 ) then
        id = tonumber( id )
        armor = tonumber( armor )
        if id and armor then
            local targetPlayer = exports["va~main"]:getPlayerID( id )
            if targetPlayer then
                setPedArmor( targetPlayer, armor )
                exports["va~main"]:sendLogs( 'voidAcademy - Logs', "16750848", "O administrador **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ).. "** setou o colete do jogador **".. getPlayerName( targetPlayer ) .." ID:".. getElementData( targetPlayer, "va.playerID" ).. "** para **".. armor .."%**", 'Desenvolvido por azarado bugs' )
                exports["va~notify"]:createNotifyS( targetPlayer, "info", "Seu colete foi setada para ".. armor .."%, pelo administrador ".. getPlayerName( player ) .."." )
                exports["va~notify"]:createNotifyS( player, "success", "Você setou o colete do jogador ".. getPlayerName( targetPlayer ) ..", ".. armor .."%." )
            else
                return exports["va~notify"]:createNotifyS( player, "error", "Jogador não encontrado!" )
            end
        else
            return exports["va~notify"]:createNotifyS( player, "error", "Use: /".. commandName .." [ID] [Quantia]." )
        end
    else
        return exports["va~notify"]:createNotifyS( player, "error", "Você não pode usar /".. commandName .."." )
    end
end
addCommandHandler( commandsAdmin.setarmor["commandName"], setArmor )

function setAdmin( player, commandName, id, adminlevel )
    id = tonumber( id )
    adminlevel = tonumber( adminlevel )
    local accName = getAccountName( getPlayerAccount ( player ) )
    if isObjectInACLGroup( "user.".. accName, aclGetGroup( 'Admin' ) ) then
        if id and adminlevel then
            local targetPlayer = exports["va~main"]:getPlayerID( id )
            if targetPlayer then
                setElementData( targetPlayer, "va.adminlevel", adminlevel )
                exports["va~main"]:sendLogs( 'voidAcademy - Logs', "16750848", "O administrador **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ).. "** setou o level admin do jogador **".. getPlayerName( targetPlayer ) .." ID:".. getElementData( targetPlayer, "va.playerID" ).. "** para **".. adminlevel .."**", 'Desenvolvido por azarado bugs' )
                exports["va~notify"]:createNotifyS( targetPlayer, "info", "Você foi setado de adminLevel: ".. adminlevel .." pelo administrador ".. getPlayerName( player ) .."." )
                exports["va~notify"]:createNotifyS( player, "success", "Você setou o jogador ".. getPlayerName( targetPlayer ) .." como adminLevel: ".. adminlevel .."." )
            else
                return exports["va~notify"]:createNotifyS( player, "error", "Jogador não encontrado!" )
            end
        else
            return exports["va~notify"]:createNotifyS( player, "error", "Use: /".. commandName .." [ID] [Level]." )
        end
    else
        return exports["va~notify"]:createNotifyS( player, "error", "Você não pode usar /".. commandName .."." )
    end
end
addCommandHandler( commandsAdmin.setadmin["commandName"], setAdmin )

function givePlayerItem( player, commandName, id, itemID, amountItem )
    id = tonumber( id )
    itemID = tonumber( itemID )
    amountItem = tonumber( amountItem )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 5 ) then
        if id and itemID and amountItem then
            local targetPlayer = exports["va~main"]:getPlayerID( id )
            if targetPlayer then
                if exports["va~inventory"]:giveItem( targetPlayer, itemID, amountItem, amountItem, 0, true ) then
                    triggerEvent( "va.inventoryGiveItem", player, targetPlayer, itemID, amountItem, 1 )
                    exports["va~main"]:sendLogs( 'voidAcademy - Logs', "16750848", "O administrador **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ).. "** setou o item de **Nome:".. exports["va~inventory"]:getItemName(itemID) .." e ID:".. itemID .."** para o jogador **".. getPlayerName( targetPlayer ) .." ID:".. getElementData( targetPlayer, "va.playerID" ).. "** Quantia: **".. amountItem .."**", 'Desenvolvido por azarado bugs' )
                    exports["va~notify"]:createNotifyS( targetPlayer, "info", "O administrador ".. getPlayerName( player ) .." setou algum item para você." )
                    exports["va~notify"]:createNotifyS( player, "success", "Item setado com sucesso." )
                else
                    return exports["va~notify"]:createNotifyS( player, "error", "Ocorreu algum erro tente novamente!" )
                end
            else
                return exports["va~notify"]:createNotifyS( player, "error", "Jogador não encontrado!" )
            end
        else
            return exports["va~notify"]:createNotifyS( player, "error", "Use: /".. commandName .." [ID] [ID do Item] [Quantia]." )
        end
    else
        return exports["va~notify"]:createNotifyS( player, "error", "Você não pode usar /".. commandName .."." )
    end
end
addCommandHandler( commandsAdmin.giveitem["commandName"], givePlayerItem )

function showPlayerInventory( player, commandName, id )
    id = tonumber( id )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 5 ) then
        if id then
            local targetPlayer = exports["va~main"]:getPlayerID( id )
            if targetPlayer then
                triggerClientEvent( player, 'va.exportShowInventory', player, targetPlayer )
            else
                return exports["va~notify"]:createNotifyS( player, "error", "Jogador não encontrado!" )
            end
        else
            return exports["va~notify"]:createNotifyS( player, "error", "Use: /".. commandName .." [ID]." )
        end
    else
        return exports["va~notify"]:createNotifyS( player, "error", "Você não pode usar /".. commandName .."." )
    end
end
addCommandHandler( commandsAdmin.verinv["commandName"], showPlayerInventory )

function noClip( player, commandName )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 1 ) then
        if ( not exports["va~freecam"]:isPlayerFreecamEnabled( player ) ) then
            if isPedInVehicle( player ) then
                removePedFromVehicle( player )
            end
            local x, y, z = getElementPosition( player )
            exports["va~freecam"]:setPlayerFreecamEnabled( player, x, y, z )
            setElementPosition( player, x, y, z - 10 )
            toggleControl( player, "walk", false )
            setElementAlpha( player, 0 )
            exports["va~notify"]:createNotifyS( player, "info", "Você entrou no modo noClip." )
        else
            local x, y, z = getCameraMatrix( player )
            exports["va~freecam"]:setPlayerFreecamDisabled( player )
            setElementPosition( player, x, y, z )
            toggleControl( player, "walk", true )
            setElementAlpha( player, 255 )
            setCameraTarget( player )
            exports["va~notify"]:createNotifyS( player, "info", "Você saiu do modo noClip." )
        end
    else
        return exports["va~notify"]:createNotifyS( player, "error", "Você não pode usar /".. commandName .."." )
    end
end
addCommandHandler( commandsAdmin.noclip["commandName"], noClip )