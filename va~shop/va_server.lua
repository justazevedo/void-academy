function buyItem( player, itemID, itemPrice, itemAmount )
    if itemPrice and itemPrice then
        local playerMoney = getPlayerMoney( player )
        if playerMoney >= itemPrice then
            if exports["va~inventory"]:giveItem( player, itemID, itemAmount, itemAmount, 0, true ) then
                takePlayerMoney( player, itemPrice )
                exports["va~notify"]:createNotifyS( player, "success", "Você comprou x".. itemAmount .." do item ".. exports["va~inventory"]:getItemName( itemID ) .."." )
            else
                return exports["va~notify"]:createNotifyS( player, "error", "Ocorreu algum erro tente novamente!" )
            end
        else
            return exports["va~notify"]:createNotifyS( player, "error", "Você não possue dinheiro suficiente." )
        end
    else
        return exports["va~notify"]:createNotifyS( player, "error", "Ocorreu algum erro tente novamente!" )
    end
end
addEvent( 'va.buyItem', true )
addEventHandler( 'va.buyItem', root, buyItem )