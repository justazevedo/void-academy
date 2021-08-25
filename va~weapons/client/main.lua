local shaders = {}
local textureCache = {}
local cache = {}

function applyTexture( element, name, texture )
    if element and name and texture then
        local texture = "skins/".. texture ..".jpg"
        cache[element] = { name, texture }
        destroyElement( element )
        if not fileExists( texture ) then
            return
        end
        if not textureCache[texture] then
            textureCache[texture] = dxCreateTexture( texture, 'dxt5' )
        end
        shaders[element] = dxCreateShader( "fx/tex_replace.fx", 0, 100, false, "all" )
        engineApplyShaderToWorldTexture( shaders[element], name, element )
        dxSetShaderValue( shaders[element], "gTexture", textureCache[texture] )
        addEventHandler( "onClientElementDestroy", element,
            function( )
                if source == element then
                    destroyTexture( element )
                end
            end
        )
    end
end
addEvent( "va.applyTexture", true )
addEventHandler( "va.applyTexture", root, applyTexture )

function destroyTexture( element )
    if isElement( element ) and shaders[element] then
        destroyElement( shaders[element] )
        shaders[element] = nil
    end
end
addEvent( "va.destroyTexture", true )
addEventHandler( "va.destroyTexture", root, destroyTexture )

addEventHandler( "onClientResourceStart", resourceRoot,
    function( )
        local data = getElementData( root, "va.stickercache" ) or {}
        for index, value in pairs( data ) do 
            if isElement( index ) and getElementType( index ) == "object" then
                applyTexture( index, value[1], value[2] )
            end
        end
    end
)

addEventHandler( "onClientResourceStop", resourceRoot,
    function( )
        setElementData( root, "va.stickercache", cache, false )
    end
)