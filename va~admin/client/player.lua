function exportShowInventory( args )
    if args then
        exports["va~inventory"]:verinv( args )
    else
        return
    end
end
addEvent( 'va.exportShowInventory', true )
addEventHandler( 'va.exportShowInventory', root, exportShowInventory )
