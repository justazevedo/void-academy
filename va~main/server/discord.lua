function callBack()
end

function sendLogs( embed, color, description, textFooter )
    local webhook = exports["va~librarys"]:Webhook( discordLogs, 'voidAcademy - Logs' )
    webhook = exports["va~librarys"]:WHSetEmbed( webhook, embed )
    webhook = exports["va~librarys"]:WHESetColor( webhook, color )
    webhook = exports["va~librarys"]:WHESetDescription( webhook, description )
    webhook = exports["va~librarys"]:WHESetFooter(
        webhook,
        textFooter,
        "https://cdn.discordapp.com/icons/849662970802864188/a004b7914e56a9f6d51e1a91902203d4.png"
    )
    webhook = exports["va~librarys"]:WHSend( webhook, false )
end

function batePonto( embed, color, description, textFooter )
    local webhook = exports["va~librarys"]:Webhook( discordPontos, 'voidAcademy - Logs' )
    webhook = exports["va~librarys"]:WHSetEmbed( webhook, embed )
    webhook = exports["va~librarys"]:WHESetColor( webhook, color )
    webhook = exports["va~librarys"]:WHESetDescription( webhook, description )
    webhook = exports["va~librarys"]:WHESetFooter(
        webhook,
        textFooter,
        "https://cdn.discordapp.com/icons/849662970802864188/a004b7914e56a9f6d51e1a91902203d4.png"
    )
    webhook = exports["va~librarys"]:WHSend( webhook, false )
end