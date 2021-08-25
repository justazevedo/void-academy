

function banPlayer( player, commandName, id, timeBan, reasonBan )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 3 ) then
        id = tonumber( id )
        timeBan = tonumber( timeBan )
        if id and timeBan then
            local targetPlayer = exports["va~main"]:getPlayerID( id )
            if targetPlayer then
                exports["va~main"]:sendLogs( 'voidAcademy - Logs', "16750848", "O administrador **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ).. "** baniu o jogador **".. getPlayerName( targetPlayer ) .." ID:".. getElementData( targetPlayer, "va.playerID" ).. "** pelo motivo **".. reason or "Undefined" .."**", 'Desenvolvido por azarado bugs' )
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
addCommandHandler( commandsAdmin.banPlayer[1], banPlayer )

function setHealth( player, commandName, id, health )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 1 ) then
        id = tonumber( id )
        health = tonumber( health )
        if id and health then
            local targetPlayer = exports["va~main"]:getPlayerID( id )
            if targetPlayer then
                setElementHealth( targetPlayer, health )
                exports["va~main"]:sendLogs( 'voidAcademy - Logs', "16750848", "O administrador **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ).. "** setou a vida do jogador **".. getPlayerName( targetPlayer ) .." ID:".. getElementData( targetPlayer, "va.playerID" ).. "** para **".. health .."%**", 'Desenvolvido por azarado bugs' )
                exports["va~notify"]:createNotifyS( player, "info", "Sua vida foi setada para ".. health .."%, pelo administrador ".. getPlayerName( player ) .."." )
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
addCommandHandler( commandsAdmin.sethealth[1], setHealth )

function setArmor( player, commandName, id, armor )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 1 ) then
        id = tonumber( id )
        armor = tonumber( armor )
        if id and armor then
            local targetPlayer = exports["va~main"]:getPlayerID( id )
            if targetPlayer then
                setPedArmor( targetPlayer, armor )
                exports["va~main"]:sendLogs( 'voidAcademy - Logs', "16750848", "O administrador **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ).. "** setou o colete do jogador **".. getPlayerName( targetPlayer ) .." ID:".. getElementData( targetPlayer, "va.playerID" ).. "** para **".. armor .."%**", 'Desenvolvido por azarado bugs' )
                exports["va~notify"]:createNotifyS( player, "info", "Seu colete foi setada para ".. armor .."%, pelo administrador ".. getPlayerName( player ) .."." )
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
addCommandHandler( commandsAdmin.setarmor[1], setArmor )

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
                exports["va~notify"]:createNotifyS( player, "info", "Você foi setado de adminLevel: ".. adminlevel .." pelo administrador ".. getPlayerName( player ) .."." )
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
addCommandHandler( commandsAdmin.setadmin[1], setAdmin )

function givePlayerItem( player, commandName, id, itemID, amountItem )
    id = tonumber( id )
    itemID = tonumber( itemID )
    amountItem = tonumber( amountItem )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 5 ) then
        if id and itemID and amountItem then
            local targetPlayer = exports["va~main"]:getPlayerID( id )
            if targetPlayer then
                triggerEvent( "va.inventoryGiveItem", player, targetPlayer, itemID, amountItem, 1 )
                exports["va~main"]:sendLogs( 'voidAcademy - Logs', "16750848", "O administrador **".. getPlayerName( player ) .." ID:".. getElementData( player, "va.playerID" ).. "** setou o item de **ID:".. itemID .."** para o jogador **".. getPlayerName( targetPlayer ) .." ID:".. getElementData( targetPlayer, "va.playerID" ).. "** Quantia: **".. amountItem .."**", 'Desenvolvido por azarado bugs' )
                exports["va~notify"]:createNotifyS( targetPlayer, "info", "O administrador ".. getPlayerName( player ) .." setou algum item para você." )
                exports["va~notify"]:createNotifyS( player, "success", "Item setado com sucesso." )
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
addCommandHandler( commandsAdmin.giveitem[1], givePlayerItem )

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
addCommandHandler( commandsAdmin.verinv[1], showPlayerInventory )

function noClip( player, commandName )
    if ( tonumber( getElementData( player, "va.adminlevel" ) ) >= 1 ) then
        if ( not exports["va~freecam"]:isPlayerFreecamEnabled( player ) ) then
            if isPedInVehicle( player ) then
                removePedFromVehicle( player )
            end
            local x, y, z = getElementPosition( player )
            exports["va~freecam"]:setPlayerFreecamEnabled( player, x, y, z )
            setElementPosition( player, x, y, z - 10 )
            setElementFrozen( player, true )
            setElementAlpha( player, 0 )
            exports["va~notify"]:createNotifyS( player, "info", "Você entrou no modo noClip." )
        else
            local x, y, z = getCameraMatrix( player )
            exports["va~freecam"]:setPlayerFreecamDisabled( player )
            setElementPosition( player, x, y, z )
            setElementFrozen( player, false )
            setElementAlpha( player, 255 )
            setCameraTarget( player )
            exports["va~notify"]:createNotifyS( player, "info", "Você saiu do modo noClip." )
        end
    else
        return exports["va~notify"]:createNotifyS( player, "error", "Você não pode usar /".. commandName .."." )
    end
end
addCommandHandler( commandsAdmin.noclip[1], noClip )