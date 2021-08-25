local weaponSkins = {
    [30] = "ak",
    [23] = "Five_Seven",
	[29] = "mp5lng",
	[24] = "deagle",
	[31] = "m4a1t",
	[28] = "uzi",
	[34] = "9f257c2f",
	[25] = "m870t",
	[32] = "Tec9BodyTex",
	[4] = "kabar",
	[22] = "mesh1",
}

local validSkins = {
    ["ak_flamengo"] = true,
    ["awp_flamengo"] = true,
    ["m16_flamengo"] = true,

    ["ak_gold"] = true,
    ["awp_gold"] = true,
    ["m16_gold"] = true,

    ["ak_imperador"] = true,
    ["awp_imperador"] = true,
    ["m16_imperador"] = true,

    ["ak_natal"] = true,
    ["awp_natal"] = true,
    ["m16_natal"] = true,

    ["ak_neonrider"] = true,
    ["awp_neonrider"] = true,
    ["m16_neonrider"] = true,

    ["five_akatsuki"] = true,
    ["five_alerkina"] = true,
    ["five_banana"] = true,
    ["five_bobesponja"] = true,
    ["five_coringa"] = true,
    ["five_flamengo"] = true,
    ["five_glitch"] = true,
    ["five_gold"] = true,
    ["five_macaco"] = true,
    ["five_rainbow"] = true,
    ["five_reddrango"] = true,
    ["five_rickandmorty"] = true,
    ["five_rosa"] = true,
    ["five_roxa"] = true,
    ["five_trovao"] = true,
}

function getWeaponWeaponShaderName( wep )
    if wep then
        if weaponSkins[wep] then
            return weaponSkins[wep]
        end
    end
    return false
end

function isStickerValid( value )
    if value then
        if validSkins[value] then
            return true
        end
    end
    return false
end