description 'Scoreboard'

-- temporary!
ui_page 'html/hud.html'

client_script 'hud.lua'

files {
    'html/hud.html',
    'html/style.css',
    'html/listener.js',
}

export 'updateHudMapName'