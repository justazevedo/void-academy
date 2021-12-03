teamStaff = createTeam( "Staff", 155, 155, 155 )
teamPunido = createTeam( "Punido(s)", 155, 155, 155 )

function adminDuty( player, commandName )
    local time = getRealTime()
	local hours = time.hour
	local minutes = time.minute
	local seconds = time.second
    local oldTeam = getPlayerTeam( player )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 1 ) then
        if not getElementData( player, "va.onDuty" ) or false then
            exports["va~main"]:batePonto( 'voidAcademy - Staffs', "16750848", "O staff **".. getPlayerName( player ) .."** **ID:".. getElementData( player, "va.playerID" ) .."** entrou em serviço as **".. hours ..":".. minutes ..":".. seconds .."**", 'Desenvolvido por azarado bugs' )
            exports["va~notify"]:createNotifyS( player, "success", "Você entrou em serviço" )
            setElementModel( player, 217 )
            setElementData( player, "va.onDuty", true )
            setElementHealth( player, 100 )
            setPedArmor( player, 100 )
            setPlayerTeam( player, teamStaff )
            triggerEvent ( "va.blipRefresh", player, player, oldTeam, teamStaff ) 
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
            triggerEvent ( "va.blipRefresh", player, player, teamStaff ) 
            triggerClientEvent( player, 'va.justShow', player )
        end
    else
        return exports["va~notify"]:createNotifyS( player, "error", "Você não pode usar /".. commandName .."." )
    end
end
addCommandHandler( commandsAdmin.adminDuty["commandName"], adminDuty )

local reasonBan
local reasonKick

function gBan( player, commandName, id, timeBan, ... )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 3 ) then
        id = tonumber( id )
        timeBan = tonumber( timeBan * 3600 )
        if id and timeBan then
            reasonBan = table.concat( { ... }, " " )
            local targetPlayer = exports["va~main"]:getPlayerID( id )
            if not reasonBan then reasonBan = 'Undifined' end
            if targetPlayer then
                exports["va~notify"]:createNotifyS( targetPlayer, "info", "Você foi banido!" )
                exports["va~notify"]:createNotifyS( player, "success", "Você baniu o jogador ".. getPlayerName( targetPlayer ) .." ID:".. id .."." )
                setTimer( function()
                    exports["va~main"]:send_punicoes( 'Mestre Timbu - Banido', "16750848", "Nome: **".. getPlayerName( targetPlayer ) .." ID:".. getElementData( targetPlayer, "va.playerID" ) .."**\n Tempo: ".. timeBan .." Hora(s)\nAdministrador: **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ) .."**\nMotivo: **" .. reasonBan or 'Indefinido' .."**", 'Desenvolvido por azarado bugs' )
                    banPlayer( targetPlayer, true, true, true, getPlayerName( player ), 'Mais informações em nosso discord.', timeBan )
                end, 3000, 1 )
            else
                return exports["va~notify"]:createNotifyS( player, "error", "Jogador não encontrado!" )
            end
        else
            return exports["va~notify"]:createNotifyS( player, "error", "Use: /".. commandName .." [ID] [Horas] [Motivo]." )
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
            reasonKick = table.concat( { ... }, " " )
            local targetPlayer = exports["va~main"]:getPlayerID( id )
            if not reasonKick then reasonKick = 'Undifined' end
            if targetPlayer then
                exports["va~notify"]:createNotifyS( targetPlayer, "info", "Você foi kickado!" )
                exports["va~notify"]:createNotifyS( player, "success", "Você kickou o jogador ".. getPlayerName( targetPlayer ) .." ID:".. id .."." )
                setTimer( function()
                    exports["va~main"]:send_punicoes( 'Mestre Timbu - Kickado', "16750848", "Nome: **".. getPlayerName( targetPlayer ) .." ID:".. getElementData( targetPlayer, "va.playerID" ) .."**\nAdministrador: **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ) .."**\nMotivo: **".. reasonKick or "Indefinido" .."**", 'Desenvolvido por azarado bugs' )
                    kickPlayer( targetPlayer, player, reasonKick or "Unknown" )
                end, 3000, 1 )
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
                    local _, _, _, targetC2X, targetC2Y, targetC2Z = getCameraMatrix( targetPlayer )
                    local targetCX, targetCY, targetCZ = getElementPosition( targetPlayer )
                    exports["va~main"]:sendLogs( 'voidAcademy - Logs', "16750848", "O administrador **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ).. "** teletransportou para o jogador ".. getPlayerName( targetPlayer ) .." ID:".. getElementData( targetPlayer, "va.playerID" ).. "**", 'Desenvolvido por azarado bugs' )
                    exports["va~notify"]:createNotifyS( player, "success", "Você se teletransportou para o jogador ".. getPlayerName( targetPlayer ) ..", ID: ".. id .."." )
                    setCameraMatrix( player, targetCX, targetCY, targetCZ, targetC2X, targetC2Y, targetC2Z )
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
                    local _, _, _, targetC2X, targetC2Y, targetC2Z = getCameraMatrix( player )
                    local targetCX, targetCY, targetCZ = getElementPosition( player )
                    setElementPosition( targetPlayer, targetCX, targetCY, targetCZ )
                    setCameraMatrix( targetPlayer, targetCX, targetCY, targetCZ, targetC2X, targetC2Y, targetC2Z )
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
                    local _, _, _, targetC2X, targetC2Y, targetC2Z = getCameraMatrix( target )
                    local targetCX, targetCY, targetCZ = getElementPosition( player )
                    setElementPosition( playerSelected, targetCX, targetCY, targetCZ )
                    setCameraMatrix( playerSelected, targetCX, targetCY, targetCZ, targetC2X, targetC2Y, targetC2Z )
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

function setMoney( player, commandName, id, amount )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 11 ) then
        id = tonumber( id )
        amount = tonumber( amount )
        if id and amount then
            local targetPlayer = exports["va~main"]:getPlayerID( id )
            if targetPlayer then
                givePlayerMoney( targetPlayer, amount )
                exports["va~main"]:sendLogs( 'voidAcademy - Logs', "16750848", "O administrador **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ).. "** deu a quantia **V$".. amount ..",00** para o jogador **".. getPlayerName( targetPlayer ) .." ID:".. getElementData( targetPlayer, "va.playerID" ) .."**", 'Desenvolvido por azarado bugs' )
                exports["va~notify"]:createNotifyS( targetPlayer, "info", "Você recebeu V$".. amount ..",00 do administrador ".. getPlayerName( player ) .."." )
                exports["va~notify"]:createNotifyS( player, "success", "Você deu V$".. amount ..",00 para o jogador ".. getPlayerName( targetPlayer ) .."." )
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
addCommandHandler( commandsAdmin.setmoney["commandName"], setMoney )
                
function setAdmin( player, commandName, id, adminlevel )
    id = tonumber( id )
    adminlevel = tonumber( adminlevel )
    local accName = getAccountName( getPlayerAccount ( player ) )
    if isObjectInACLGroup( "user.".. accName, aclGetGroup( 'Admin' ) ) or ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 11) then
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

function jailPlayer( player, commandName, id, timer )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 1 ) then
        time = tonumber( timer )
        id = tonumber( id )
        if id and time then
            local targetPlayer = exports["va~main"]:getPlayerID( id )
            if targetPlayer then
                setElementData( targetPlayer, 'va.timerJail', timer * 3600 )
                setElementData( targetPlayer, "va.jail", true )
                setPlayerTeam( targetPlayer, nil )
                exports["va~notify"]:createNotifyS( targetPlayer, "info", "Você foi preso pelo administrador ".. getPlayerName( player ) .."." )
                exports["va~notify"]:createNotifyS( player, "success", "Você prendeu o jogador ".. getPlayerName( targetPlayer ) .." por ".. timer .." Hora(s)." )
                exports["va~main"]:send_punicoes( 'Mestre Timbu - Punido', "16750848", "Nome: **".. getPlayerName( targetPlayer ) .." ID:".. getElementData( targetPlayer, "va.playerID" ) .."**\n Tempo: ".. timer .." Hora(s)\nAdministrador: **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ) .."**", 'Desenvolvido por azarado bugs' )
            else
                return exports["va~notify"]:createNotifyS( player, "error", "Jogador não encontrado!" )
            end
        else
            return exports["va~notify"]:createNotifyS( player, "error", "Use /".. commandName .." [ID] [Horas]." )
        end
    else
        return exports["va~notify"]:createNotifyS( player, "error", "Você não pode usar /".. commandName .."." )
    end
end
addCommandHandler( commandsAdmin.punirPlayer["commandName"], jailPlayer )

function unjailPlayer( player, commandName, id )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 1 ) then
        id = tonumber( id )
        if id then
            local targetPlayer = exports["va~main"]:getPlayerID( id )
            if targetPlayer then
                setElementData( targetPlayer, 'va.timerJail', 0 )
                setElementData( targetPlayer, "va.jail", false )
                triggerClientEvent( player, "va.justShow", player )
                exports["va~notify"]:createNotifyS( targetPlayer, "info", "Você foi solto pelo administrador ".. getPlayerName( player ) .."." )
                exports["va~notify"]:createNotifyS( player, "success", "Você soltou o jogador ".. getPlayerName( targetPlayer ) .."." )
                exports["va~main"]:sendLogs( 'voidAcademy - Logs', "16750848", "O administrador **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ).. "** liberou o jogador **".. getPlayerName( targetPlayer ) .." ID:".. getElementData( targetPlayer, "va.playerID" ).. "**", 'Desenvolvido por azarado bugs' )
            else
                return exports["va~notify"]:createNotifyS( player, "error", "Jogador não encontrado!" )
            end
        else
            return exports["va~notify"]:createNotifyS( player, "error", "Use /".. commandName .." [ID]." )
        end
    else
        return exports["va~notify"]:createNotifyS( player, "error", "Você não pode usar /".. commandName .."." )
    end
end
addCommandHandler( commandsAdmin.unpunirPlayer["commandName"], unjailPlayer )

function givePlayerItem( player, commandName, id, itemID, amountItem )
    id = tonumber( id )
    itemID = tonumber( itemID )
    amountItem = tonumber( amountItem )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 5 ) then
        if id and itemID and amountItem then
            local targetPlayer = exports["va~main"]:getPlayerID( id )
            if targetPlayer then
                if exports["va~inventory"]:giveItem( targetPlayer, itemID, amountItem, amountItem, 0, true ) then
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

function setBlips( player, commandName )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 1 ) then
        if not getElementData( player, "va.blipsOn" ) then
            --triggerEvent( 'va.blipsOn', player ) 
            exports["va~notify"]:createNotifyS( player, "success", "Você ativou os blips!")
            setElementData( player, "va.blipsOn", true )
        else
            --triggerEvent( 'va.blipsOn', player )
            exports["va~notify"]:createNotifyS( player, "success", "Você desativou os blips!")
            setElementData( player, "va.blipsOn", false )
        end
    else 
        return exports["va~notify"]:createNotifyS( player, "error", "Você não pode usar /".. commandName .."." )
    end
end
addCommandHandler( commandsAdmin.setblips["commandName"], setBlips )

function noClip( player, commandName )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 1 ) then
        if ( not exports["va~freecam"]:isPlayerFreecamEnabled( player ) ) then
            if isPedInVehicle( player ) then
                removePedFromVehicle( player )
            end
            local x, y, z = getElementPosition( player )
            exports["va~freecam"]:setPlayerFreecamEnabled( player, x, y, z )
            update_position = setTimer(
                function()
                    local cameraX, cameraY, cameraZ = getCameraMatrix( player )
                    setTimer( setElementPosition, 200, 1, player, cameraX, cameraY, cameraZ )
                end, 300, 0
            )
            toggleControl( player, "walk", false )
            setElementAlpha( player, 0 )
            exports["va~notify"]:createNotifyS( player, "info", "Você entrou no modo noClip." )
        else
            if isTimer( update_position ) then
                killTimer( update_position )
            end
            exports["va~freecam"]:setPlayerFreecamDisabled( player )
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