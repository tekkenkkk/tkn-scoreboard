fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'https://tekken.dev/'
description 'FiveM Scoreboard'

shared_script '@es_extended/imports.lua'

client_scripts {
    'client/functions.lua',
    'client/main.lua',
    'client/lib.lua'
}

server_scripts {
    'server/functions.lua',
    'server/main.lua'
}

files {
    'web/assets/*.*',
    'web/index.html'
}

ui_page 'web/index.html'