local screenW, screenH = guiGetScreenSize()
local showing_discord = false

function discord_panel()
    dxDrawLine((screenW * 0.8229) - 1, (screenH * 0.3713) - 1, (screenW * 0.8229) - 1, screenH * 0.6315, tocolor(211, 120, 1, 250), 1, false)
    dxDrawLine(screenW * 0.9443, (screenH * 0.3713) - 1, (screenW * 0.8229) - 1, (screenH * 0.3713) - 1, tocolor(211, 120, 1, 250), 1, false)
    dxDrawLine((screenW * 0.8229) - 1, screenH * 0.6315, screenW * 0.9443, screenH * 0.6315, tocolor(211, 120, 1, 250), 1, false)
    dxDrawLine(screenW * 0.9443, screenH * 0.6315, screenW * 0.9443, (screenH * 0.3713) - 1, tocolor(211, 120, 1, 250), 1, false)
    dxDrawRectangle(screenW * 0.8229, screenH * 0.3713, screenW * 0.1214, screenH * 0.2602, tocolor(1, 1, 1, 144), false)
    dxDrawImage(screenW * 0.8281, screenH * 0.3537, screenW * 0.1068, screenH * 0.2130, ":va~interface/nui/images/logo.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    dxDrawRectangle(screenW * 0.8469, screenH * 0.5593, screenW * 0.0703, screenH * 0.0269, tocolor(211, 120, 1, 250), false)
    dxDrawText("COPIAR ", screenW * 0.8708, screenH * 0.5667, screenW * 0.9703, screenH * 0.6639, tocolor(255, 255, 255, 255), 1.00, "sans", "left", "top", false, false, false, false, false)
end

function open_panel_discord()
    if not showing_discord then
        open_discord()
    else
        close_discord()
    end
end
addCommandHandler( "discord", open_panel_discord )

function copy_discord( _, state )
    if showing_discord then
        if state == "down" then
            if isCursorOnElement( screenW * 0.8469, screenH * 0.5593, screenW * 0.0703, screenH * 0.0269 ) then
                setClipboard( "https://discord.gg/zsWcDBTvtA" )
                exports["va~notify"]:createNotify( localPlayer, "success", "Link copiado com sucesso" )
                close_discord()
            end
        end
    end
end
addEventHandler( "onClientClick", root, copy_discord )

function open_discord()
    showCursor( true )
    addEventHandler( "onClientRender", root, discord_panel )
    showing_discord = true
end

function close_discord()
    showCursor( false )
    removeEventHandler( "onClientRender", root, discord_panel )
    showing_discord = false
end

function isCursorOnElement(x,y,w,h)
    local mx,my = getCursorPosition ()
    local fullx,fully = guiGetScreenSize()
    cursorx,cursory = mx*fullx,my*fully
    if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
        return true
    else
        return false
    end
end