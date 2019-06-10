local pickupInfos = {}
local isThreadActive = false
local threadCheckAttempts = 0
local visiblePickups = {}




RegisterNetEvent("CNC:clearPickups")
AddEventHandler("CNC:clearPickups", function()
    Citizen.Trace('clearPickups Handler')
    clearPickups()
end)

Citizen.CreateThread(function ( )
    function clearPickups( )
        Citizen.Trace('clearPickup')
        while #pickupInfos > 0 do
            Citizen.Wait(0)
            for i,pickupInfo in ipairs(pickupInfos) do
                TriggerEvent('removePickup', pickupInfo)
            end
        end
    end
end)



Citizen.CreateThread(function ( )
    RegisterNetEvent("createPickup")
    AddEventHandler("createPickup", function(pickupInfo)
        Citizen.Trace('createPickup')
        pickupInfo.spawnedBlip = false
        table.insert( pickupInfos, pickupInfo)
    end)



    RegisterNetEvent("CNC:createMuliiplePickups")
    AddEventHandler("CNC:createMuliiplePickups", function(PickupInfos)
        Citizen.Trace('CNC:createMuliiplePickups')
        
        -- wait for Pickups are cleaned up
        while #pickupInfos ~= 0 do
            Citizen.Wait(500)
        end
        
        if #pickupInfos == 0 then
            pickupInfos = PickupInfos
            for i,pickupInfo in ipairs(pickupInfos) do
                pickupInfo.spawnedBlip = false
            end
        end
    end)
    



    RegisterNetEvent("removePickup")
    AddEventHandler("removePickup", function(pickupInfo)
        Citizen.Trace('removePickup Handler')
        for i,pickup in ipairs(pickupInfos) do
            
            if pickup.x == pickupInfo.x and pickup.y == pickupInfo.y and pickup.z == pickupInfo.z then
                table.remove(pickupInfos, i)
                --Citizen.Trace("BLIP: " .. pickup.blip)

                while DoesBlipExist(pickup.blip) do
                    Citizen.Wait(1)
                    --Citizen.Trace("try to delete Blip")
                    RemoveBlip(pickup.blip)
                end
                --Citizen.Trace("BLIP DELETED: " .. pickup.blip)
				TriggerEvent("deletePickup", pickup.pickup)
			end
        end
    end)
    
    
    RegisterNetEvent("deletePickup")
    AddEventHandler("deletePickup", function(pickup)
        Citizen.Trace('deletePickup Handler')
        DeletePickup(pickup)
    end) 
    

    function DeletePickup( pickup )
        Citizen.Trace('deletePickup Funktion')       
        while (DoesPickupExist(pickup) == 1 or DoesPickupExist(pickup) == true) do
            Citizen.Wait(1)
            --Citizen.Trace('try to delete Pickup')
            SetEntityAsNoLongerNeeded(pickup)
            RemovePickup(pickup)
        end

        Citizen.Trace('DELATED PICKUP')
        return true
    end

end)

RegisterNetEvent("createLootThread")
AddEventHandler("createLootThread", function()
    createLootThread(true)
end)

-- Collect pickups thread
Citizen.CreateThread(function ( )
    while loaded == true do
        Citizen.Wait(1)

        -- local posX,posY,posZ = table.unpack(GetEntityCoords(PlayerPedId(), true))
        for i, pickupInfo in pairs(pickupInfos) do

            if pickupInfo.spawnedBlip then
                DrawLightWithRange(pickupInfo.x, pickupInfo.y, pickupInfo.z - 0.5, 255, 0, 0, 3.0, 50.0)

				if HasPickupBeenCollected(pickupInfo.pickup) --[[ and DistanceBetweenCoords(posX,posY,posZ,pickupInfo.x,pickupInfo.y,pickupInfo.z) < 2.5 ]] then
                    Citizen.Trace("pickup was collected\n")
                    
                    pickupInfo.spawnedBlip = false
                    --table.insert(respawnPickups, pickupInfo)
                    --TriggerEvent('CNC:showNotification', 'Pickup: ' .. pickupInfo.pickupName)
                    TriggerEvent('removePickup', pickupInfo) --Importent to fix delay to Server
                    TriggerServerEvent("CNC:removePickup", pickupInfo, "pickup was collected\n")
					break
				end
			end
		end
    end
end)


function createLootThread( crashed )
    if crashed ~= nil then
        --Citizen.Trace("Loot fixed ...")
        --TriggerEvent('CNC:showNotification', "Loot fixed...")
    end
    
    Citizen.CreateThread(function ( )
        while loaded == true do
            Citizen.Wait(500)
            isThreadActive = true
            local counter = 0
            local posX,posY,posZ = table.unpack(GetEntityCoords(PlayerPedId(), true))

            for i,pickupInfo in ipairs(pickupInfos) do
                if pickupInfo.spawnedBlip == false then
                    local pickup = 0
                    local blip = AddBlipForCoord(pickupInfo.x, pickupInfo.y, pickupInfo.z)
                    SetBlipSprite(blip, pickupInfo.blipSpriteID)
                    SetBlipAsShortRange(blip, true)
                    SetBlipColour(blip, pickupInfo.blipColor)
                    SetBlipScale(blip, 0.8)

                    if (DoesBlipExist(blip) == 1 or DoesBlipExist(blip)== true) then
                        pickupInfos[i].blip = blip
                        pickupInfos[i].spawnedBlip = true
                    end
                end

               --DrawLightWithRange(pickupInfo.x, pickupInfo.y, pickupInfo.z + 0.1, 255, 255, 255, 3.0, 50.0)

                
                local dist = DistanceBetweenCoords2D(posX, posY, pickupInfo.x, pickupInfo.y)
                --local dist = 150

                --Citizen.Trace("SPAWNED DoesPIckupExist: " .. tostring(DoesPickupExist(pickupInfo.pickup)) )

                
                if dist < 250 then boolDist = true else boolDist = false end
                if DoesPickupExist(pickupInfo.pickup) then boolExist = true else boolExist = false end


                if boolDist and not boolExist then
                    --Citizen.Trace(" / EXIST: " .. tostring(DoesPickupExist(pickupInfo.pickup)))
--                    Citizen.Trace("PickupID: " .. pickupInfo.pickup .. " / EXIST: " .. tostring(DoesPickupExist(pickupInfo.pickup)))

                    pickup = CreatePickupRotate(pickupInfo.pickupName, pickupInfo.x, pickupInfo.y, pickupInfo.z + 1.0, 0.0, 0.0, 0.0, 512, pickupInfo.ammo, 24, 24, true, pickupInfo.pickupName)
                    pickupInfos[i].pickup = pickup
                    Citizen.Trace('SPAWN')
                end

                --Citizen.Trace("Dist: " .. dist)

                if not boolDist and boolExist then
                    RemovePickup(pickupInfo.pickup)
                    pickupInfo.pickup = 0
                    Citizen.Trace("DESPAWNED")
                end   


--                 if dist < 50 and not DoesPickupExist(pickupInfo.pickup) then
--                     --Citizen.Trace(" / EXIST: " .. tostring(DoesPickupExist(pickupInfo.pickup)))
-- --                    Citizen.Trace("PickupID: " .. pickupInfo.pickup .. " / EXIST: " .. tostring(DoesPickupExist(pickupInfo.pickup)))

--                     pickup = CreatePickupRotate(pickupInfo.pickupName, pickupInfo.x, pickupInfo.y, pickupInfo.z, 0.0, 0.0, 0.0, 512, pickupInfo.ammo, 24, 24, true, pickupInfo.pickupName)
--                     --DrawLightWithRangeAndShadow(pickupInfo.x, pickupInfo.y, pickupInfo.z + 0.1, 255, 255, 255, 3.0, 50.0, 5.0)
--                     pickupInfos[i].pickup = pickup
--                     Citizen.Trace('SPAWN')
--                 end

--                 --Citizen.Trace("Dist: " .. dist)

--                 if dist > 50 and DoesPickupExist(pickupInfo.pickup)then
--                     RemovePickup(pickupInfo.pickup)
--                     pickupInfo.pickup = 0
--                     Citizen.Trace("DESPAWNED")
--                 end   
                
                
             end
        end
    end)
end


-- Ligths
-- Citizen.CreateThread(function ( )
--     while loaded == true do
--         Citizen.Wait(1)
--         local posX,posY,posZ = table.unpack(GetEntityCoords(PlayerPedId(), true))

--         for i,pickupInfo in ipairs(pickupInfos) do   
--             local dist = DistanceBetweenCoords2D(posX, posY, pickupInfo.x, pickupInfo.y)
--             if dist < 250 then boolDist = true else boolDist = false end
--             if DoesPickupExist(pickupInfo.pickup) then boolExist = true else boolExist = false end
            
            
--             if boolDist and boolExist then
--                 DrawLightWithRange(pickupInfo.x, pickupInfo.y, pickupInfo.z - 0.5, 255, 0, 0, 3.0, 50.0)

--             end
--          end
--     end
-- end)


Citizen.CreateThread(function()
	while loaded == true do
		Citizen.Wait(1)
		if isThreadActive then
			threadCheckAttempts = 0
            isThreadActive = false

		else
			threadCheckAttempts = threadCheckAttempts + 1
			if threadCheckAttempts >= 1000 then
				threadCheckAttempts = 0
				TriggerEvent("createLootThread")
			end
		end
	end
end)

loaded = true
createLootThread()