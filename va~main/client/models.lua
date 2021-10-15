energy_can_texture = engineLoadTXD( "models/energy_can.txd" )
energy_can_model = engineLoadDFF( "models/energy_can.dff" )
engineImportTXD( energy_can_texture, 2647 )
engineReplaceModel( energy_can_model, 2647 )

-- energy_can

energy_can_texture = engineLoadTXD( 'models/energy_can.txd' )
energy_can_model = engineLoadDFF( 'models/energy_can.dff' )
engineImportTXD( energy_can_texture, models['energy_can'] )
engineReplaceModel( energy_can_model, models['energy_can'] )

-- radio_comunicador

radio_comunicador_texture = engineLoadTXD( 'models/radio_comunicador.txd' )
radio_comunicador_model = engineLoadDFF( 'models/radio_comunicador.dff' )
engineImportTXD( radio_comunicador_texture, models['radio_comunicador'] )
engineReplaceModel( radio_comunicador_model, models['radio_comunicador'] )