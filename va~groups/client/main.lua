local screenW, screenH = guiGetScreenSize()
local browser = guiCreateBrowser( 0, 0, screenW, screenH, true, true, true )
local nui = guiGetBrowser( browser )
local link = "http://mta/local/nui/nui.html"
guiSetVisible( browser, false )

addEventHandler( "onClientBrowserCreated", nui,
    function( )
        loadBrowserURL( source, link )
    end
)

function loadGroups( )
    setElementPosition( localPlayer, -1322.2653, 497.8862, 21.2533 )
    setElementRotation( localPlayer, -0, 0, 247.2734 )
    showChat( false )
    showCursor( true )
    exports["va~interface"]:setInterface( false )
    for index, value in ipairs( groups ) do
        name = groups[index].name
        executeBrowserJavascript( nui, "window.postMessage( { id : ".. index ..", name : '".. name .."', players : 0, vagas : ".. groups[index].vagas .." }, '*' )" )
        playerAt = setTimer( function( )
            local count = countPlayersInTeam( getTeamFromName( string.gsub( groups[index].name, "_", " " ) ) )
            if count > 0 then
                executeBrowserJavascript( nui, "window.postMessage( { editID : ".. index ..", editName : '".. groups[index].name .."', editPlayers : ".. count ..", editVagas : ".. groups[index].vagas .." }, '*' )" )
            else
            end
        end, 2000, 0 )
    end
end

function showGroups()
    guiSetVisible( browser, true )
    loadGroups()
    setCameraMatrix( -1317.0699462891, 496.16061401367, 23.030000686646, -1317.9978027344, 496.46878051758, 22.819860458374, 0, 90 )
end
addEvent( 'va.showGroups', true )
addEventHandler( 'va.showGroups', root, showGroups )

function justShow()
    showCursor( true )
    guiSetVisible( browser, true )
    setCameraMatrix( -1317.0699462891, 496.16061401367, 23.030000686646, -1317.9978027344, 496.46878051758, 22.819860458374, 0, 90 )
    setElementPosition( localPlayer, -1322.2653, 497.8862, 21.2533 )
    setElementRotation( localPlayer, -0, 0, 247.2734 )
    showChat( false )
    exports["va~interface"]:setInterface( false )
    --[[playerAt = setTimer( function( )
        local count = countPlayersInTeam( getTeamFromName( string.gsub( groups[index].name, "_", " " ) ) )
        if count > 0 then
            executeBrowserJavascript( nui, "window.postMessage( { editID : ".. index ..", editName : '".. groups[index].name .."', editPlayers : ".. count ..", editVagas : ".. groups[index].vagas .." }, '*' )" )
        else
        end
    end, 2000, 0 )]]
end
addCommandHandler( "trocartime", justShow )
addEvent( 'va.justShow', true )
addEventHandler( 'va.justShow', root, justShow )

function closeGroups()
    if isTimer( playerAt ) then
        killTimer( playerAt )
    end
    guiSetVisible( browser, false )
    exports["va~interface"]:setInterface( true )
    showChat( true )
    showCursor( false )
end
addEvent( 'va.closeGroups', true )
addEventHandler( 'va.closeGroups', root, closeGroups )

function setSkin( gangID, id )
    gangID = tonumber( gangID ) id = tonumber( id )
    if gangID and id then
        local skin = groups[gangID].skin[id]
        setElementModel( localPlayer, skin )
    else
        return exports["va~notify"]:createNotify( localPlayer, 'error', 'Ocorreu algum error contate um administrador' )
    end
end
addEvent( 'va.setSkin', true )
addEventHandler( 'va.setSkin', root, setSkin )

function errorMessage( event )
    if event == "lotado" then
        exports["va~notify"]:createNotify( localPlayer, 'error', 'Este grupo está lotado!' )
    end
end

function selectedSkin( gangID, id )
    gangID = tonumber( gangID ) id = tonumber( id )
    if gangID ~= 0 and groups[gangID].skin[id] then
        triggerServerEvent( 'va.spawnGroups', localPlayer, localPlayer, groups[gangID].spawn[1], groups[gangID].spawn[2], groups[gangID].spawn[3], groups[gangID].skin[id], string.gsub( groups[gangID].name, "_", " ") )
    else
        return exports["va~notify"]:createNotify( localPlayer, 'error', 'Ocorreu algum error contate um administrador' )
    end
end
addEvent( 'va.selectedSkin', true )
addEventHandler( 'va.selectedSkin', root, selectedSkin )