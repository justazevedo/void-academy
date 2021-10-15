function damagePlayerHandler( attacker, weapon, bodypart )
    local onDuty = getElementData( source, 'va.onDuty') or false
    local onSafe = getElementData( source, 'va.onSafeZone') or false
    if onDuty or onSafe then
        cancelEvent()
    end
end
addEventHandler( 'onClientPlayerDamage', getLocalPlayer(), damagePlayerHandler )

-- Binds

for index, bind in ipairs( bindsKey ) do
    bindKey( bindsKey[index].binds, 'down', bindsKey[index].commands )
end