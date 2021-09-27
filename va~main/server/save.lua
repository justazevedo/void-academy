function playerLogin( thePreviousAccount, theCurrentAccount, autologin )
    if not ( isGuestAccount( getPlayerAccount( source ) ) ) then
        local accountData = getAccountData( theCurrentAccount, "va.money" )
        if ( accountData ) then
            local vaMoney = getAccountData( theCurrentAccount, "va.money" )
            local vaWanted = getAccountData( theCurrentAccount, "va.wanted" )
            local vaStaff = getAccountData( theCurrentAccount, "va.adminlevel" )
            setPlayerMoney( source, vaMoney )
            setElementModel( source, 0 )
            setPlayerWantedLevel( source, vaWanted )
            setElementData( source, "va.adminlevel", vaStaff )
            setElementData( source, "va.rangeVoice", "Falando" )
        else
            setPlayerMoney( source, 2500 )
            setPlayerWantedLevel( source, 0 )
            setElementModel( source, 0 )
            setElementData( source, "va.adminlevel", 0 )
        end
    else
        return
    end
end
addEventHandler( "onPlayerLogin", getRootElement( ), playerLogin )

function onLogout( )
    kickPlayer( source, "voidAcademy", "Feito." )
end
addEventHandler( "onPlayerLogout", getRootElement( ), onLogout )

function exitDuty( player )
    local time = getRealTime()
	local hours = time.hour
	local minutes = time.minute
	local seconds = time.second
    if getElementData( player, "va.onDuty" ) then
        exports["va~main"]:batePonto( 'voidAcademy - Staffs', "16750848", "O staff **".. getPlayerName( player ) .."** **ID:".. getElementData( player, "va.playerID" ) .."** saiu de serviço as **".. hours ..":".. minutes ..":".. seconds .."**", 'Desenvolvido por azarado bugs' )
        setElementData( player, "va.onDuty", false )
    end
end
addEventHandler( 'onPlayerExit', getRootElement(), exitDuty )

function playerSave( quitType, reason, responsibleElement )
    if not ( isGuestAccount ( getPlayerAccount ( source ) ) ) then
        account = getPlayerAccount( source )
        exitDuty( source )
        if ( account ) then
            setAccountData( account, "va.money", tostring( getPlayerMoney( source ) ) )
            setAccountData( account, "va.skin", tostring( getElementModel( source ) ) )
            setAccountData( account, "va.wanted", getPlayerWantedLevel( source ) )
            setAccountData( account, "va.adminlevel", getElementData( source, "va.adminlevel" ) )
        else
            return
        end
    else
        return
    end
end
addEventHandler( "onPlayerQuit", getRootElement( ), playerSave )