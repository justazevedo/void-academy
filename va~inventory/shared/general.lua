-- inventoryElem = { 'bag', 'weapon', 'key', 'craft'} -- // Inventory szétválasztások
inventoryElem = { 'weapon', 'bag' } -- // Inventory szétválasztások
row = 8 -- // Sor
column = 6 -- // Oszlop
baseWeight = 25 --// Alap peso
oneLevelBag = 50 -- // Sima táska
premiumLevelBag = 100 -- // Sima táska
oneLevelBagID = 106 -- // Sima táska ID
premiumLevelBagID = 107 -- // Prémium táska ID
maxCraftSlot = 16 -- // Craft slot
maxCraftRecipe = 9 -- // max Craft receptek

itemLists = {
	{name = "Radio", desc="Ferramenta de contato rápido.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'bag'}, --1
	{name = "Molotov", desc="Há um fogo forte quando você joga fora.", weight=0.4, stack = false, weaponID = 18, AmmoID = false, level=4, itemTypes= 'weapon'}, --2
	{name = "Desert Eagle", desc="Uma arma com risco de vida contendo munição forte.", weight=2.2, stack = false, weaponID = 24, AmmoID = 57, level=3, itemTypes= 'weapon'}, --3
	{name = "Five Seven", desc="Somente uma five.", weight=1, stack = false, weaponID = 23, AmmoID = false, level=0, itemTypes= 'weapon'}, --4
	{name = "Colt-45", desc="O menor pedaço de pistola.", weight=1.5, stack = false, weaponID = 22, AmmoID = 57, level=3, itemTypes= 'weapon'}, --5
	{name = "Espingarda shotgun espingarda", desc="Arma grande calibre que é muito perigoso.", weight=3, stack = false, weaponID = 26, AmmoID = 60, level=3, itemTypes= 'weapon'}, --6
	{name = "Combat shotgun", desc="Arma popular do terrorista.", weight=4, stack = false, weaponID = 27, AmmoID = 60, level=3, itemTypes= 'weapon'}, --7
	{name = "Micro Uzi", desc="A arma popular dos julgamentos.", weight=3.5, stack = false, weaponID = 28, AmmoID = 61, level=3, itemTypes= 'weapon'}, --8
	{name = "MP5", desc="Arma popular do terrorista.", weight=2.5, stack = false, weaponID = 29, AmmoID = 61, level=3, itemTypes= 'weapon'}, --9
	{name = "AK-47", desc="Arma grande calibre que é perigoso.", weight=4.1, stack = false, weaponID = 30, AmmoID = 58, level=3, itemTypes= 'weapon'}, --10
	{name = "M16", desc="Arma grande calibre que é perigoso.", weight=3.5, stack = false, weaponID = 31, AmmoID = 59, level=3, itemTypes= 'weapon'}, --11
	{name = "Tec-9", desc="A arma popular dos julgamentos.", weight=1.8, stack = false, weaponID = 32, AmmoID = 61, level=3, itemTypes= 'weapon'}, --12

	{name = "Estrutura interna AK-47", desc="Uma estrutura interna AK-47.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --13
	{name = "Tubo de AK-47", desc="Um tubo AK-47.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --14
	{name = "Garra AK-47", desc="Um aperto AK-47.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --15
	{name = "AK-47 Astúcia", desc="Um corpo de AK-47.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --16
	{name = "Biblioteca AK-47", desc="Um pacote AK-47.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --17
	{name = "Suporte de ombro AK-47", desc="Um suporte de ombro AK-47.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --18
	{name = "estrutura interna M16", desc="Uma estrutura interna M16.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --19
	{name = "Punho Do Tubo M16", desc="Um clipe de tubo M16.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --20
	{name = "Tubo M16", desc="Com um tubo M16.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --21
	{name = "Guiador M16", desc="Um aperto M16.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --22
	{name = "M16 Astúcia", desc="EM16 rima.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --23
	{name = "Alcatrão M16", desc="Uma tara M16.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --24
	{name = "Suporte de ombro M16", desc="Um suporte de ombro M16.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --25
	{name = "Estrutura Interna Desert Eagle", desc="A estrutura interna de uma Desert Eagle.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --26
	{name = "Desert Eagle repositório", desc="Um aperto Eagle Desert.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --27
	{name = "Desert Eagle manhoso", desc="Uma framboesa Águia do deserto.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --28
	{name = "Desert Eagle repositório", desc="Um repositório Desert Eagle.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --29
	{name = "Colt-45 Estrutura interna", desc="Uma estrutura interna de um Colt-45.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --30
	{name = "Colt-45 punho", desc="Um aperto Colt-45.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --31
	{name = "Colt-45 repositório", desc="Uma runa do Colt-45.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --32
	{name = "Alcatrão Colt-45", desc="Uma repositório Colt-45.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --33
	{name = "M40A1 Estrutura interna", desc="Uma estrutura interna de um M40A1.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --34
	{name = "Binóculos M40A1", desc="Um telescópio M40A1.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --35
	{name = "Tubo M40A1", desc="Um tubo M40A1.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --36
	{name = "M40A1 Astúcia", desc="Uma navalha de um M40A1.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --37
	{name = "Alcatrão M40A1", desc="Um pacote M40A1.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --38
	{name = "Suporte de ombro M40A1", desc="Um suporte de ombro M40A1.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --39
	{name = "Estrutura Interna MP5", desc="Uma estrutura interna de um MP5.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --40
	{name = "Tubo mp5", desc="um tubo MP5.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --41
	{name = "Guiador MP5", desc="Um aperto MP5.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --42
	{name = "MP5 Cunning", desc="Um ancinho MP5.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --43
	{name = "Suporte de ombro MP5", desc="Um suporte de ombro MP5.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --44
	{name = "Armazenamento MP5", desc="Uma tara MP5.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --45
	{name = "Micro Uzi Estrutura interna", desc="Uma estrutura interna de uma Micro Uzi.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --46
	{name = "Tubo Micro Uzi", desc="Um tubo Micro Uzi.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --47
	{name = "Punho de tubo micro Uzi", desc="Um aperto de tubo Micro Uzi.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --48
	{name = "Micro Uzi manhoso", desc="Um Micro Uzi Ravass.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --49
	{name = "Micro Uzi tara", desc="Uma tara Micro Uzi.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --50
	{name = "Suporte Micro Ombro Uzi", desc="Suporte de ombro Micro Uzi.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --51
	{name = "Estrutura Interior Shotgun", desc="Uma estrutura interna de uma espingarda.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --52
	{name = "Tubo de espingarda", desc="Um tubo de shotgun.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --53
	{name = "Estrutura de rolamento de espingarda", desc="Uma estrutura de enrolador de espingarda.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --54
	{name = "Espingarda espingarda", desc="Um, espingarda espingarda.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --55
	{name = "Suporte de Ombro de Espingarda", desc="Suporte de ombro de espingarda.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --56
	{name = "Tec9 Estrutura Interna", desc="Estrutura interna de um Tec9.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --57
	{name = "Tubo Tec9", desc="Um tubo Tec9.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --58
	{name = "Tec9 Markolat", desc="Um aperto Tec9.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --59
	{name = "Tec9 ravas", desc="Um Tec9 ravas.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --60
	{name = "Tec9 Tara", desc="Uma t9 Tec9.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --61
	{name = "Estrutura interna do Magnum Sniper", desc="A estrutura interna de um Magnum Sniper.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --62
	{name = "Binóculos Magnum Sniper", desc="Egy Magnum Sniper távcsőve.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --63
	{name = "Tubo de Atirador Magnum", desc="Um tubo magnum sniper.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --64
	{name = "Magnum Sniper Cute", desc="Uma investida de Magnum Sniper.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --65
	{name = "Magnum Sniper Store", desc="Um Magnum Sniper Tare.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --66
	{name = "Suporte Magnum Sniper Shoulder", desc="Suporte para Ombro Sniper Magnum.", weight=0.2, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --67

	{name = "Mascara de gas", desc="Mascara para camuflar", weight=1.5, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --68
	{name = "Palhaço", desc="Mascara para camuflar", weight=4, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --69
	{name = "Macaco", desc="Mascara para camuflar", weight=3.5, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --70
	{name = "Cavalo", desc="Mascara para camuflar", weight=2.5, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --71
	{name = "Caveira", desc="Mascara para camuflar", weight=4.1, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --72
	{name = "Coruja", desc="Mascara para camuflar", weight=3.5, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --73
	{name = "Boina policial", desc="Mascara para camuflar", weight=1.8, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'weapon'}, --74

	{name = "AK do Flamengo", desc="AK do Flamengo.", weight=4.1, stack = false, weaponID = 30, AmmoID = 58, level=3, itemTypes= 'weapon'}, --75
	{name = "AK-47 Gold", desc="AK Gold.", weight=4.1, stack = false, weaponID = 30, AmmoID = 58, level=3, itemTypes= 'weapon'}, --76
	{name = "AK-47 Imperador", desc="AK Imperador.", weight=4.1, stack = false, weaponID = 30, AmmoID = 58, level=3, itemTypes= 'weapon'}, --77
	{name = "AK-47 Natal", desc="AK de Natal.", weight=4.1, stack = false, weaponID = 30, AmmoID = 58, level=3, itemTypes= 'weapon'}, --78
	{name = "AK-47 NeonRider", desc="AK NeonRider.", weight=4.1, stack = false, weaponID = 30, AmmoID = 58, level=3, itemTypes= 'weapon'}, --79

	{name = "M16 do Flamengo", desc="M16 do Flamengo.", weight=4.1, stack = false, weaponID = 31, AmmoID = 58, level=3, itemTypes= 'weapon'}, --80
	{name = "M16 Gold", desc="M16 Gold.", weight=4.1, stack = false, weaponID = 31, AmmoID = 58, level=3, itemTypes= 'weapon'}, --81
	{name = "M16 Imperador", desc="M16 Imperador.", weight=4.1, stack = false, weaponID = 31, AmmoID = 58, level=3, itemTypes= 'weapon'}, --82
	{name = "M16 Natal", desc="M16 de Natal.", weight=4.1, stack = false, weaponID = 31, AmmoID = 58, level=3, itemTypes= 'weapon'}, --83
	{name = "M16 NeonRider", desc="M16 NeonRider.", weight=4.1, stack = false, weaponID = 31, AmmoID = 58, level=3, itemTypes= 'weapon'}, --84

	{name = "AWP do Flamengo", desc="AWP do Flamengo.", weight=4.1, stack = false, weaponID = 34, AmmoID = 58, level=3, itemTypes= 'weapon'}, --85
	{name = "AWP Gold", desc="AWP Gold.", weight=4.1, stack = false, weaponID = 34, AmmoID = 58, level=3, itemTypes= 'weapon'}, --86
	{name = "AWP Imperador", desc="AWP Imperador.", weight=4.1, stack = false, weaponID = 34, AmmoID = 58, level=3, itemTypes= 'weapon'}, --87
	{name = "AWP Natal", desc="AWP de Natal.", weight=4.1, stack = false, weaponID = 34, AmmoID = 58, level=3, itemTypes= 'weapon'}, --88
	{name = "AWP NeonRider", desc="AWP NeonRider.", weight=4.1, stack = false, weaponID = 34, AmmoID = 58, level=3, itemTypes= 'weapon'}, --89

	{name = "Five-Seven Akatsuki", desc="Akatsuki.", weight=1, stack = false, weaponID = 23, AmmoID = false, level=0, itemTypes= 'weapon'}, --90
	{name = "Five-Seven Arlekina", desc="Arlekina.", weight=1, stack = false, weaponID = 23, AmmoID = false, level=0, itemTypes= 'weapon'}, --91
	{name = "Five-Seven Banana", desc="Banana.", weight=1, stack = false, weaponID = 23, AmmoID = false, level=0, itemTypes= 'weapon'}, --92
	{name = "Five-Seven Coringa", desc="Coringa.", weight=1, stack = false, weaponID = 23, AmmoID = false, level=0, itemTypes= 'weapon'}, --93
	{name = "Five-Seven Flamengo", desc="Flamengo.", weight=1, stack = false, weaponID = 23, AmmoID = false, level=0, itemTypes= 'weapon'}, --94
	{name = "Five-Seven Glitch", desc="Glitch.", weight=1, stack = false, weaponID = 23, AmmoID = false, level=0, itemTypes= 'weapon'}, --95
	{name = "Five-Seven Gold", desc="Gold.", weight=1, stack = false, weaponID = 23, AmmoID = false, level=0, itemTypes= 'weapon'}, --96
	{name = "Five-Seven Macaco", desc="Macaco.", weight=1, stack = false, weaponID = 23, AmmoID = false, level=0, itemTypes= 'weapon'}, --97
	{name = "Five-Seven PatrickBob", desc="PatrickBob.", weight=1, stack = false, weaponID = 23, AmmoID = false, level=0, itemTypes= 'weapon'}, --98
	{name = "Five-Seven Rainbow", desc="Rainbow.", weight=1, stack = false, weaponID = 23, AmmoID = false, level=0, itemTypes= 'weapon'}, --99
	{name = "Five-Seven RedDragon", desc="RedDragon.", weight=1, stack = false, weaponID = 23, AmmoID = false, level=0, itemTypes= 'weapon'}, --100
	{name = "Five-Seven Rick", desc="Rick.", weight=1, stack = false, weaponID = 23, AmmoID = false, level=0, itemTypes= 'weapon'}, --101
	{name = "Five-Seven Rosa", desc="Rosa.", weight=1, stack = false, weaponID = 23, AmmoID = false, level=0, itemTypes= 'weapon'}, --102
	{name = "Five-Seven Roxa", desc="Roxa.", weight=1, stack = false, weaponID = 23, AmmoID = false, level=0, itemTypes= 'weapon'}, --103
	{name = "Five-Seven Simpson", desc="Simpson.", weight=1, stack = false, weaponID = 23, AmmoID = false, level=0, itemTypes= 'weapon'}, --104
	{name = "Five-Seven Trovao", desc="Trovao.", weight=1, stack = false, weaponID = 23, AmmoID = false, level=0, itemTypes= 'weapon'}, --105

	{name = "Bolsa", desc="Se você precisar de mais objetos, sempre vem bem.", weight=0.01, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'bag'}, --106
	{name = "Bolsa premium", desc="Se você precisar de mais objetos, sempre vem bem.", weight=0.01, stack = false, weaponID = false, AmmoID = false, level=0, itemTypes= 'bag'}, --107
	{name = "Monster Energy", desc="Use para ficar bem mais rapido.", weight=0.02, stack = true, weaponID = false, AmmoID = false, level=0, itemTypes= 'bag'}, --108

}

craftLists = {}

specialItems = {
	--[[[13] = function(item,value)
		name = getItemName(item)
		desc = getItemDescription(item)
		return "#7cc576"..name .. "#FFFFFF\n" .. desc,"#FFA700Faz um cigarro: ".. value .. ""]]
}

vehicleWeight = {

}

function getType(element)
	if(getElementType(element)=="player")then
		return 0
	elseif(getElementType(element)=="vehicle")then
		return 1
	elseif(getElementType(element)=="object") and (getElementModel(element) == 2332) then
		return 2
	end
end

function getOwnerID(element)
	if(getElementType(element)=="player")then
		return (getElementData(element, 'acc:id') or -1)  --tonumber(getElementData(element, 'acc:id') or -1)
	elseif(getElementType(element)=="vehicle")then
		--return tonumber(getElementData(element, 'veh:owner') or -1)
		return tonumber(getElementData(element, 'veh:id')+10000000 or -1)
	elseif(getElementType(element)=="object") and (getElementModel(element) == 2332) then
		return tonumber(getElementData(element, "safe->ID") or -1)
	end
end

function getItemName(id)
	if itemLists[id] then
		return itemLists[id].name
	end
end

function getItemWeight(id)
	if itemLists[id] then
		return itemLists[id].weight
	end
end

function getItemDescription(id)
	if itemLists[id] then
		return itemLists[id].desc
	end
end

function getItemType(id)
	if itemLists[id] then
		return itemLists[id].itemTypes
	end
end

function getItemWeaponID(id)
	if itemLists[id] then
		return itemLists[id].weaponID
	end
end

function getItemNeedLevel(item)
	if tonumber(itemLists[item].level) > 0 then
		return tonumber(itemLists[item].level)
	else
		return 0
	end
end

function getItemToType(element, items)
	local itemType = "bag"
	if items then 
		if tonumber(getType(element)) == 1 or tonumber(getType(element)) == 2 then 
			itemType = tostring('bag')
		else
			itemType = tostring(itemLists[tonumber(items)].itemTypes)
		end
	end
	return itemType
end

function getItemTable()
	return itemLists
end

function getItemImg(item)
	return fileExists(":va~inventory/files/items/"..item..".png") and ":va~inventory/files/items/"..item..".png" or ":va~inventory/files/items/0.png"
end

function getWeaponID(itemid)--ItemID-ről fegyo ID-re
	if itemLists[tonumber(itemid)].weapon then
		return itemLists[tonumber(itemid)].weapon
	else
		return 0
	end
end
function getWeaponAmmo(item)
	if itemLists[tonumber(item)].ammo then
		return itemLists[tonumber(item)].ammo
	else
		return 1
	end
end

function getItemsStackable(item)
	return itemLists[tonumber(item)].stack or false
end

function isReloadableWeapon(item)
	return itemLists[tonumber(item)].weapon
end

isStickerWeapon = {
	[75] = "ak_flamengo",
	[85] = "awp_flamengo",
	[80] = "m16_flamengo",

    [76] = "ak_gold",
    [86] = "awp_gold",
    [81] = "m16_gold",

    [77] = "ak_imperador",
    [87] = "awp_imperador",
    [82] = "m16_imperador",

    [78] = "ak_natal",
    [88] = "awp_natal",
    [83] = "m16_natal",

    [79] = "ak_neonrider",
    [89] = "awp_neonrider",
    [84] = "m16_neonrider",

	[90] = "five_akatsuki",
    [91] = "five_alerkina",
    [92] = "five_banana",
    [93] = "five_coringa",
    [94] = "five_flamengo",
    [95] = "five_glitch",
    [96] = "five_gold",
    [97] = "five_macaco",
    [98] = "five_bobesponja",
    [99] = "five_rainbow",
    [100] = "five_reddrango",
    [101] = "five_rickandmorty",
    [102] = "five_rosa",
    [103] = "five_roxa",
    [105] = "five_trovao",
}

function getStickerWeapon(itemID)
	return isStickerWeapon[itemID]
end

local itemIDtoWeapon = {
	[74] = 30,
	[80] = 31,
	[85] = 34,

    [75] = 30,
    [81] = 31,
    [86] = 34,

    [76] = 30,
    [82] = 31,
    [87] = 34,

    [77] = 30,
    [83] = 31,
    [88] = 34,

    [78] = 30,
    [84] = 31,
    [89] = 34,

	[90] = 23,
    [91] = 23,
    [92] = 23,
    [93] = 23,
    [94] = 23,
    [95] = 23,
    [96] = 23,
    [97] = 23,
    [98] = 23,
    [99] = 23,
    [100] = 23,
    [101] = 23,
    [102] = 23,
    [103] = 23,
    [105] = 23,
}

function getWeaponID(itemid)
	if itemIDtoWeapon[itemid] then
		return itemIDtoWeapon[itemid]
	else
		return 0
	end
end

function isWeapon(itemid)
	if itemIDtoWeapon[itemid] then
		return true
	else
		return false
	end
end
