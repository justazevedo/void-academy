function playerDamage( attacker, weapon, bodypart )
    if getElementData( source, "va.onDuty" ) then
        cancelEvent()
    end
end
addEventHandler( 'onClientPlayerDamage', getLocalPlayer(), playerDamage )
