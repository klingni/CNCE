resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"
resource_type 'gametype' { name = 'Cops and Crooks EDITOR Alpha' }


client_script {
    '@NativeUI/NativeUI.lua',
    'client/map/globMap.lua',
    'client/map/vehicles.lua',
    'client/gui/notifications.lua',
    'client/gui/Input.lua',
    'client/map/map.lua',
    --'client/menue/main.lua',
    --'client/menue/map.lua',
    --'client/menue/globMap.lua',
    --'client/menue/time.lua',
    'client/gui/menu/main.lua',
    'client/client.lua'
    
}

server_script {
    'server/server.lua',
    'server/helper/helper.lua',
    'server/map/map.lua',
    'server/map/globMap.lua'   
}

dependencies {
    'NativeUI',
    'editorhud',
    'vMenu'
  }