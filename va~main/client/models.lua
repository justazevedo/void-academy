energy_can_texture = engineLoadTXD( "models/energy_can.txd" )
energy_can_model = engineLoadDFF( "models/energy_can.dff" )
engineImportTXD( energy_can_texture, 2647 )
engineReplaceModel( energy_can_model, 2647 )