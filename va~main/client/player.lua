function playerDamage( attacker, weapon, bodypart )
    if getElementData( source, "va.onDuty" ) or getElementData( source, "va.onSafeZone" ) then
        cancelEvent()
    end
end
addEventHandler( 'onClientPlayerDamage', getLocalPlayer(), playerDamage )
