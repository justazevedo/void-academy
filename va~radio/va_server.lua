function setChannel( channel )
    print( 'Radio System - The player '.. getPlayerName( source ) ..' has enter in frequency '.. channel .. 'MHz' )
    exports["va~voice"]:setPlayerChannel( source, channel )
    channelPlayer = exports["va~voice"]:getPlayersInChannel( channel )
    print( 'Radio System - Players in channel '.. channel ..'MHz' )
    iprint( channelPlayer )
end
addEvent( 'va.setChannel', true )
addEventHandler( 'va.setChannel', root, setChannel )

function removeChannel( channel )
    exports["va~voice"]:setPlayerChannel( source )
    print( 'Radio System - The player '.. getPlayerName( source ) ..' has exit in frequency '.. channel .. 'MHz' )
    channelPlayer = exports["va~voice"]:getPlayersInChannel( channel )
    print( exports["va~voice"]:getPlayerChannel( source ) )
    print( 'Radio System - Players in channel ' ..channel ..'MHz')
    iprint( channelPlayer )
    for index, value in ipairs( channelPlayer ) do
        setPlayerVoiceBroadcastTo( value, channelPlayer )
    end
end
addEvent( 'va.removeChannel', true )
addEventHandler( 'va.removeChannel', root, removeChannel )