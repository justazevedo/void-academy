function playerJoin()
    fadeCamera( source, true, 5 )
    setCameraMatrix( source, 1335.1314697266, -1400.3842773438, 33.302700042725, 1334.1617431641, -1400.3864746094, 33.058326721191, 0, 90 )
    if triggerClientEvent( source, "va.loginPanel", source, source, "show" ) then
        if isTimer( timer ) then
            killTimer( timer )
        end
    else
        timer = setTimer( playerJoin, 2000, 0 )
    end
end
addEventHandler( "onPlayerJoin", root, playerJoin )

function panelFunctions( player, event, username, password )
    if event == "logIn" then
        if ( username ~= "" and username ~= nil or not string.len( username ) > 4 ) then
            if ( password ~= "" and password ~= nil or not string.len( password ) > 4 ) then
                local account = getAccount( username, password )
                if ( account ) then
                    logIn( player, account, password )
                    triggerClientEvent( player, "va.logIn", player )
                    if getElementData( player, "va.newPlayer" ) then
                        exports["va~notify"]:createNotifyS( player, "success", "Olá ".. getPlayerName( player ) ..",<br>Seja bem vindo ao Void Academy Gang X Gang." )
                        setElementData( player, "va.newPlayer", false )
                    else
                        exports["va~notify"]:createNotifyS( player, "success", "Bem vindo de volta ".. getPlayerName( player ) )
                    end
                else
                    exports["va~notify"]:createNotifyS( player, "error", "Essa conta não existe!" )
                    return
                end
            else
                return
            end
        else
            return
        end
    elseif event == "register" then
        if ( username ~= "" and username ~= nil or not string.len( username ) > 4 ) then
            if ( password ~= "" and password ~= nil or not string.len( password ) > 4 ) then
                local newAccount = addAccount( username, password )
                if ( newAccount ) then
                    setElementData( player, "va.newPlayer", true )
                    exports["va~notify"]:createNotifyS( player, "success", "Conta registrada!" )
                else
                    exports["va~notify"]:createNotifyS( player, "error", "Usúario ou senha invalida!" )
                    return
                end
            else
                return
            end
        else
            return
        end
    end
end
addEvent( "va.eventsLogIn", true )
addEventHandler( "va.eventsLogIn", root, panelFunctions )