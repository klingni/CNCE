resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

resource_type "gametype" {name = "Cops and Crooks Alpha"}
description "Cops and Crooks V"

client_script {
    "@NativeUI/NativeUI.lua",
    "client/client.lua",
    "client/helper.lua",
    "client/player/player.lua",
    "client/player/player-blip.lua",
    "client/player/player-blip_neu.lua",
    "client/vehicles/vehicles.lua",
    "client/vehicles/spawner.lua",
    "client/vehicles/getaway.lua",
    "client/pickups/pickups.lua",
    "client/gui/notifications.lua",
    "client/gui/menu/main.lua",
    "client/gui/scoreboard/scoreboard.lua"
}

server_script {
    "server/server.lua",
    "server/helper/helper.lua",
    "server/pickups/nethandler.lua",
    "server/gameplay/player.lua",
    "server/helper/commands.lua",
    "server/gameplay/score.lua",
    "server/vehicles/getaway.lua",
    "server/vehicles/spawner.lua",
    "server/vehicles/vehicle.lua"
}

dependencies {
    "NativeUI",
    "switcher",
    "bob74_ipl",
    "vSync",
    "blacklist",
    "cnc_chat",
    "chat-theme-gtao"
}

loadscreen "misc/loadscreen/index.html"
ui_page 'client/gui/scoreboard/scoreboard.html'


files {
    -- LOADSCREEN
    "misc/loadscreen/index.html",
    "misc/loadscreen/keks.css",
    "misc/loadscreen/bankgothic.ttf",
    "misc/loadscreen/loadscreen.jpg",
    "misc/loadscreen/cnc5.png",
    
    -- SCOREBOARD
    'client/gui/scoreboard/scoreboard.html',
    'client/gui/scoreboard/style.css',
    'client/gui/scoreboard/reset.css',
    'client/gui/scoreboard/listener.js',
    'client/gui/scoreboard/res/futurastd-medium.css',
    'client/gui/scoreboard/res/futurastd-medium.eot',
    'client/gui/scoreboard/res/futurastd-medium.woff',
    'client/gui/scoreboard/res/futurastd-medium.ttf',
    'client/gui/scoreboard/res/futurastd-medium.svg',
    'client/gui/scoreboard/res/cnc-logo.png',
}
