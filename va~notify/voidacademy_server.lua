function createNotifyS( player, type, message )
    triggerClientEvent( player, "va.notify", player, player, type, message )
end
