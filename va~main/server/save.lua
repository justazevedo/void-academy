function playerLogin( thePreviousAccount, theCurrentAccount, autologin )
    if not ( isGuestAccount( getPlayerAccount( source ) ) ) then
        local accountData = getAccountData( theCurrentAccount, "va.money" )
        if ( accountData ) then
            local vaMoney = getAccountData( theCurrentAccount, "va.money" )
            local vaSkin = getAccountData( theCurrentAccount, "va.skin" )
            local vaWanted = getAccountData( theCurrentAccount, "va.wanted" )
            local vaStaff = getAccountData( theCurrentAccount, "va.adminlevel" )
            setPlayerMoney( source, vaMoney )
            setElementModel( source, vaSkin )
            setPlayerWantedLevel( source, vaWanted )
            setElementData( source, "va.adminlevel", vaStaff )
        else
            setPlayerMoney( source, 2500 )
            setPlayerWantedLevel( source, 0 )
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

function playerSave( quitType, reason, responsibleElement )
    if not ( isGuestAccount ( getPlayerAccount ( source ) ) ) then
        account = getPlayerAccount( source )
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