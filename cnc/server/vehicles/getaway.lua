
-- =========================================================================
-- ================================ GETAWAY ================================
-- =========================================================================



RegisterNetEvent('CNC:UpdateGetawayCoord')
AddEventHandler('CNC:UpdateGetawayCoord', function( getawayCoord )
    GetawayCoord = getawayCoord
end)


RegisterNetEvent('CNC:forceUpdateGetawayBlip')
AddEventHandler('CNC:forceUpdateGetawayBlip', function()
    Citizen.CreateThread(function ( )
        while isRoundOngoing do
            Citizen.Wait(10)
            for i,player in ipairs(PlayerInfos) do
                if player.team == 'crook' then
                    TriggerClientEvent("CNC:UpdateGetawayBlip", player.player, GetawayCoord)
                end
            end
        end
    end)
end)


-- create GetawayBlips
RegisterNetEvent('CNC:creatGetaway')
AddEventHandler('CNC:creatGetaway', function(net_getaway)

    TriggerEvent('Log', 'CNC:creatGetaway-NetGeta', net_getaway)


    net_Getaway = net_getaway
    TriggerClientEvent('CNC:findGetawayCoord', -1, net_Getaway)
    TriggerEvent('CNC:forceUpdateGetawayBlip')
end)


-- check Boss left the Getaway
RegisterNetEvent('baseevents:leftVehicle')
AddEventHandler('baseevents:leftVehicle', function(veh, seat, displayName,netId)
    if isRoundOngoing then
        --if tonumber(source) == tonumber(BossInfo.player) and veh == Getaway then
        if tonumber(source) == tonumber(BossID) and netId == net_Getaway then
            print("Boss left the GETA")
            TriggerClientEvent('CNC:showNotification', -1, '~r~Boss left the Getaway')
            isBossInGetaway = false
        end
    end

end)


-- check Boss entered the Getaway
RegisterNetEvent('baseevents:enteredVehicle')
AddEventHandler('baseevents:enteredVehicle', function(veh, seat, displayName, netId)

    TriggerEvent('Log', 'baseevents:enteredVehicle-veh', veh)
    TriggerEvent('Log', 'baseevents:enteredVehicle-netId', netId)

    if isRoundOngoing then
        print('netId: ' .. netId)
        print('netId_new: ' .. veh)
        print('net_Getaway: ' .. net_Getaway)
        TriggerClientEvent('CNC:id', source, veh)
        if tonumber(source) == tonumber(BossID) and netId == net_Getaway then
            print("Boss entered the GETA")
            TriggerClientEvent('CNC:showNotification', -1, '~r~Boss entered the Getaway')
            isBossInGetaway = true
            startCoolDownThread( )
        end
    end
end)
