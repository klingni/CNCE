local currentFolder = "resources//[test]//cnc-map//"
local globalMap = {}
local currentMap = {}

RegisterNetEvent('CNCE:globMap:callLoadMap')
AddEventHandler('CNCE:globMap:callLoadMap', function ()
    if globalMap['vehicles'] == nil then
        globalMap = getGlobalMapSettings()
    end
    --print(#globalMap['pickups']['positions'])
    TriggerClientEvent('CNCE:globMap:createMap', -1, globalMap)
end)


function getGlobalMapSettings()
    file = io.open(currentFolder .. "GlobalMap.json", "r")
    local content = file:read("*a")
    file:close()
    local testObj, pos, testErro = json.decode(content)
    --print(testObj['pickups'])

    return testObj
end


RegisterNetEvent('CNCE:globMap:Pickup:forceAddPickup')
AddEventHandler('CNCE:globMap:Pickup:forceAddPickup', function (coord)
    table.insert( globalMap['pickups']['positions'], coord )
    --TriggerClientEvent('CNCE:globMap:Pickup:forceLoadPickups', -1)
    TriggerClientEvent('CNCE:globMap:forceCallLoadMap', -1)
end)


RegisterNetEvent('CNCE:globMap:Pickup:forceRemovePickup')
AddEventHandler('CNCE:globMap:Pickup:forceRemovePickup', function (i)
    table.remove( globalMap['pickups']['positions'], i )
    --TriggerClientEvent('CNCE:globMap:Pickup:forceLoadPickups', -1)
    TriggerClientEvent('CNCE:globMap:forceCallLoadMap', -1)
end)




RegisterNetEvent('CNCE:globMap:save')
AddEventHandler('CNCE:globMap:save', function ()
    savePickups(globalMap)
    TriggerClientEvent('CNC:showNotification', -1, 'saving was successful')
end)





function savePickups(globalMap)
        --print('getSettingsS')

        local text = json.encode(globalMap)

        print('start saving')
        
        file = io.open(currentFolder .. "GlobalMap.json", "w")
        file:write(text)
        file:close()

        date = os.date("*t")
        backupfile = io.open(currentFolder .. "GlobalMap_" .. date.year .. date.month .. date.day .."_" .. date.hour .. date.min .. date.sec .. ".json", "w")
        backupfile:write(text)
        backupfile:close()
        print('saving was successful')
end


RegisterNetEvent('CNCE:globMap:addVehicle')
AddEventHandler('CNCE:globMap:addVehicle', function ( VehicleInfo )

    print('Server add Vehicle')
    table.insert( globalMap['vehicles'] , VehicleInfo )

    TriggerClientEvent('CNCE:globMap:createMap', -1, globalMap)
end)