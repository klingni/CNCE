
--[[ RegisterNetEvent("CNC:getNetID")
AddEventHandler("CNC:getNetID", function(ID)
    print("NetworkID :" ..NetworkGetNetworkIdFromEntity(ID))
        
end) ]]

function DistanceBetweenCoords2D(x1,y1,x2,y2)
	local deltax = x1 - x2
	local deltay = y1 - y2

	dist = math.sqrt((deltax * deltax) + (deltay * deltay))

	return dist
end

-- Citizen.CreateThread(function (  )
-- 	while true do
-- 		Citizen.Wait(100)
-- 		local px, py, pz = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
-- 		Citizen.Trace(tostring(GetWaterHeight(px, py, pz)))
-- 	end
-- end)



RegisterNetEvent("CNC:teleport")
AddEventHandler("CNC:teleport",function()
    Citizen.Trace('teleport')
    local playerPed = GetPlayerPed(-1)
    local WaypointHandle = GetFirstBlipInfoId(8)
    if DoesBlipExist(WaypointHandle) then
        local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, WaypointHandle, Citizen.ResultAsVector())
        SetEntityCoords(playerPed, coord.x, coord.y, coord.z)
    end

end)



RegisterNetEvent("CNC:createSpawner")
AddEventHandler("CNC:createSpawner",function()

    Citizen.Trace("create Generator")

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    Citizen.Trace("X:" .. x .. "Y:" .. y  .. "Z:".. z)
    x = -773.311
    y = 160.610
    z = 67.500

    --x =1734.5612
    --y= 3258.1030
    --z= 41.2880



    local hash = GetHashKey("adder")
    RequestModel(hash)

    while not HasModelLoaded(hash) do
        Wait(0)
    end

    local carGen = CreateScriptVehicleGenerator(x, y, z, 120.0, 5.0, 3.0, hash, -1, -1, -1, -1, true, false, false, false, true, -1)
    
    --SetEntityRotation(carGen, 55.0, 0.0, 0.0, false, true)

    local vektor = GetEntityRotation(carGen, false)
    Citizen.Trace("X:" .. vektor.x .. " Y:" .. vektor.y .. " Z:" .. vektor.z)
    
    SetScriptVehicleGenerator(carGen, true)
    SetAllVehicleGeneratorsActive(true)

end)


RegisterNetEvent("getNWID")
AddEventHandler("getNWID",function()
    Citizen.Trace(NetworkGetNetworkIdFromEntity(GetPlayerPed(-1)))
end)

local Val = 0

RegisterNetEvent("CNC:setWeapon")
AddEventHandler("CNC:setWeapon",function(val)
    Citizen.Trace('SetPlayerWeaponDamageModifier:' .. val)
    Val = val
end)


-- Citizen.CreateThread(function (  )
--     while true do
--         Citizen.Wait(0)
--         SetPlayerWeaponDamageModifier(PlayerId(), Val)
-- 	end
-- end)


Citizen.CreateThread(function()

    local showSF = false

    
    AddEventHandler("CNC:SFTimer",function(time)
        Wait( tonumber(time))
        showSF = false
    end)

    RegisterNetEvent("CNC:showScaleform")
    AddEventHandler("CNC:showScaleform",function(HeadLine, Text, time)

        Citizen.Trace("HeadLine: " .. HeadLine)
        Citizen.Trace("Text: " .. Text)
        Citizen.Trace("Time: " .. time)

        showSF = true
        TriggerEvent("CNC:SFTimer", time)

        local scaleform = RequestScaleformMovie("mp_big_message_freemode")
        while not HasScaleformMovieLoaded(scaleform) do
            Citizen.Wait(0)
        end
        
        BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
        PushScaleformMovieMethodParameterString(HeadLine)
        PushScaleformMovieMethodParameterString(Text)
        PushScaleformMovieMethodParameterInt(5)
        EndScaleformMovieMethod()


        while showSF do
            Citizen.Wait(0)
            --Citizen.Trace('show')
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
        end
    end)
end)



RegisterNetEvent("CNC:createBlip")
AddEventHandler("CNC:createBlip",function(playerID)
    Citizen.Trace('createBlip')
    

        local new_blip = AddBlipForEntity(GetPlayerPed(tonumber(playerID)))




end)


RegisterNetEvent("CNC:showLocalPlayers")
AddEventHandler("CNC:showLocalPlayers",function()
    Citizen.Trace('shoeLocalPlayers')


        local players = {}
    
        for i = 0, 31 do
            if NetworkIsPlayerActive(i) then
                print('Player:' .. i)
            end
        end
end)


RegisterNetEvent("CNC:flipGeta")
AddEventHandler("CNC:flipGeta",function()
    Citizen.Trace('flipGeta')

    local result, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
    Citizen.Trace('entity:' .. entity)

    -- local rot = GetEntityRotation(entity, true)
    -- Citizen.Trace('x:' .. rot.x)
    -- Citizen.Trace('y:' .. rot.y)
    -- Citizen.Trace('z:' .. rot.z)

    

    SetVehicleOnGroundProperly(entity)

    --SetEntityRotation(entity , rot.x ,0.0, rot.z, false, true)

end)