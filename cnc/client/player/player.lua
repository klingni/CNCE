local isRoundGoingOn
local spawnRadius = 50
playerInfos = {}

--[[ RegisterNetEvent("CNC:setPlayerWeapons")
AddEventHandler("CNC:setPlayerWeapons", function(PlayerSetting)

    TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:setPlayerWeapons', PlayerSetting)

    Citizen.Wait(0)
    Citizen.Trace('setPlayer Weapons')

    --GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("weapon_pistol"), 100, false)
    for k,v in pairs(PlayerSetting['weapons']) do
        Citizen.Trace('weapon:' .. v['type'])
        GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(v['type']), v['ammo'],true, v['equipt'])
        Citizen.Wait(100)
    end


end) ]]

RegisterNetEvent('CNC:ClientUpdate')
AddEventHandler('CNC:ClientUpdate', function(PlayerInfos)

    TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:ClientUpdate', PlayerInfos)

    playerInfos = PlayerInfos
end)


RegisterNetEvent('CNC:StartRound')
AddEventHandler('CNC:StartRound', function(PlayerInfos)

    TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:StartRound', PlayerInfos)

    isRoundGoingOn = true
    playerInfos = PlayerInfos
end)

RegisterNetEvent('CNC:StopRound')
AddEventHandler('CNC:StopRound', function()
	isRoundGoingOn = false
	TriggerEvent('CNC:setTeam', 0)
end)



RegisterNetEvent("CNC:setTeam")
AddEventHandler("CNC:setTeam", function(team)

    TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:setTeam', team)

    Citizen.Trace('Team: ' .. tostring(team))

    NetworkSetVoiceChannel(tonumber(team))
    SetPlayerTeam(PlayerId(), tonumber(team))
    --TriggerEvent('CNC:showNotification', "Team:" .. GetPlayerTeam(PlayerId()))
end)



RegisterNetEvent("CNC:getTeam")
AddEventHandler("CNC:getTeam", function()
	--TriggerEvent('CNC:showNotification', "Team:" .. getTeam())
	
end)

function getTeam()
	return GetPlayerTeam(PlayerId())
end

-- RegisterNetEvent("CNC:eventSetPlayerPosRespawn")
-- AddEventHandler("CNC:eventSetPlayerPosRespawn", function(coord)

--     TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:eventSetPlayerPosRespawn', coord)

--     Citizen.Trace('SetPlayerPosRespawn')
    
--     spawnRadius = 150
--     spawnX = coord.x
--     spawnY = coord.y
--     spawnZ = 0

--     Citizen.Trace("X:" .. spawnX)
--     Citizen.Trace("Y:" .. spawnY)
--     Citizen.Trace("Z:" .. spawnZ)
    
--     i = 0
--     j = 0
--     k = 0

--     FreezeEntityPosition(GetPlayerPed(PlayerId()), true)
--     SetEntityCoords(GetPlayerPed(PlayerId()), coord.x, coord.y, coord.z + 100, 1, 0, 0, 1)
    

    
--     repeat
--         i = i + 1
--         if i > 100 then
--             spawnRadius = spawnRadius + 100
--             i = 0
--             Citizen.Trace("Durchlauf: " .. i .. "Radius: " .. spawnRadius)
--         end
--         Citizen.Trace("SpawnRadius: " .. spawnRadius)
        
--         repeat
            
--             Citizen.Wait(1)
--             spawnX = coord.x + math.random(-spawnRadius, spawnRadius)
--             spawnY = coord.y + math.random(-spawnRadius, spawnRadius)
            
            
--             _,spawnZ = GetGroundZFor_3dCoord(spawnX+.0, spawnY+.0, 99999.0, 1)
            
--             TriggerServerEvent('Debug', 'spawnX:' .. spawnX .. ' spawnY:' .. spawnY .. ' spawnZ:' .. spawnZ)
--            -- j = j + 1 
            
-- --[[             if j > 10 then
--                 j = 0
--                 break
--             end ]]

--         until spawnZ ~= 0

--         --j = 0

--         -- NEU START
--         if GetWaterHeight(spawnX, spawnY, spawnZ) then
--             k = k + 1
--             if k > 50 then
--                 i = 100
--                 k = 0
--             end
--         end
--         -- NEU ENDE

--     until --[[ IsPointOnRoad(spawnX, spawnY, spawnZ)  and ]]  not GetWaterHeight(spawnX, spawnY, spawnZ)

--     spawnZ = spawnZ + 1

--     --FreezeEntityPosition(GetPlayerPed(PlayerId()), true)

--     Citizen.Trace('SetPlayerCoords')
--     SetEntityCoords(GetPlayerPed(PlayerId()), spawnX, spawnY, spawnZ, 1, 0, 0, 1)
--     --TriggerServerEvent('Debug', spawnZ)
    
--     Citizen.Wait(3000)
--     FreezeEntityPosition(GetPlayerPed(PlayerId()), false)
-- end)

--[[ -- spawn Getaway
RegisterNetEvent("CNC:allToGetaway")
AddEventHandler("CNC:allToGetaway", function(getaway)
    Citizen.Trace('allToGetaway')
    FreezeEntityPosition(GetPlayerPed(PlayerId()), true)
    SetEntityCoords(GetPlayerPed(PlayerId()), getaway.coord.x, getaway.coord.y, getaway.coord.z + 10.0 , 1, 0, 0, 1)
end)

RegisterNetEvent("CNC:eventSetPlayerPos")
AddEventHandler("CNC:eventSetPlayerPos", function(coord)

    TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:eventSetPlayerPos', coord)
    
    FreezeEntityPosition(GetPlayerPed(PlayerId()), true)
    SetEntityCoords(GetPlayerPed(PlayerId()), coord.x, coord.y, coord.z, 1, 0, 0, 1)
    Citizen.Wait(3000)
    FreezeEntityPosition(GetPlayerPed(PlayerId()), false)
end) ]]


--[[ RegisterNetEvent("CNC:setModel")
AddEventHandler("CNC:setModel", function(PlayerSetting)

    Citizen.Trace(PlayerSetting['model'])
    
    TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:setModel', PlayerSetting)
    
    local model = GetHashKey(PlayerSetting['model'])
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
    
    
    if HasModelLoaded(model) then
        --print('ID:' .. PlayerId())
        SetPlayerModel(PlayerId(), model)
    else
        print("Couldn't load skin!")
    end
end) ]]




RegisterNetEvent("CNC:killPlayer")
AddEventHandler("CNC:killPlayer", function(PlayerSetting)

    --TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:killPlayer', PlayerSetting)

    SetEntityHealth(PlayerPedId(), 1)
end)


AddEventHandler('playerSpawned', function(spawn)

    TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - playerSpawned', spawn)

	if isRoundGoingOn then
        TriggerServerEvent('CNC:Respawn')
	else
		TriggerEvent('CNC:setTeam', 0)
		Citizen.Trace('Player spawned Trigger')
	end
end)



RegisterNetEvent("CNC:getPlayerPosition")
AddEventHandler("CNC:getPlayerPosition", function()

    TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:getPlayerPosition')

    local px, py, pz = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    coord = {x = px, y=py, z=pz}
    Citizen.Trace("getPlayerPosition - X: " .. px .. " / Y: " .. py)

    TriggerServerEvent('CNC:sendPlayerCoord', coord)
end)


RegisterNetEvent("CNC:getPos")
AddEventHandler("CNC:getPos", function()

    TriggerServerEvent('Log', '['.. PlayerId() .. ']' .. GetPlayerName(PlayerId()) .. ' - CNC:getPos')

    local px, py, pz = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    coord = {x = px, y=py, z=pz}
    Citizen.Trace("getPlayerPosition - X: " .. px .. " / Y: " .. py .. " / Z: " .. pz)
end)

Citizen.CreateThread(function ( )
    while true do
        Citizen.Wait(1000)
        local px, py, pz = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
        coord = {x = px, y=py, z=pz}

        TriggerServerEvent('CNC:sendPlayerCoord', coord)
    end
end)

Citizen.CreateThread(function (  )
    while true do
    Citizen.Wait(100)
    	if GetPlayerWantedLevel(PlayerId()) ~= 0 then
			SetPlayerWantedLevel(PlayerId(), 0, false)
            SetPlayerWantedLevelNow(PlayerId(), false)
            SetEveryoneIgnorePlayer(PlayerId(), true)
        end
        ResetPlayerStamina(PlayerId())
    end
end)




RegisterNetEvent("CNC:newSpawnPlayer")
AddEventHandler("CNC:newSpawnPlayer", function(team, coord, PlayerSetting, firstSpawn, playerInfo)

    -- SET TEAM
    TriggerEvent('CNC:setTeam', team)


    -- SPAWN ON POSSITION

    if firstSpawn then
        FreezeEntityPosition(GetPlayerPed(PlayerId()), true)
        SetEntityCoords(GetPlayerPed(PlayerId()), coord.x, coord.y, coord.z, 1, 0, 0, 1)
        Citizen.Wait(500)
        FreezeEntityPosition(GetPlayerPed(PlayerId()), false)

        local option = {}

        if playerInfo.team == 'cop' then
            option = {
                layout = 'bottomCenter',
                type = 'cop',
                text = 'You are a cop, stop the boss from getting into the getaway vehicle.',
                theme = 'cnc'
            }
        elseif playerInfo.team == 'crook' then
            if playerInfo.isBoss then
                option = {
                    layout = 'bottomCenter',
                    type = 'crook',
                    text = 'You are the boss 👑, try to reach the getaway vehicle.',
                    theme = 'cnc'
                }
            else
                option = {
                    layout = 'bottomCenter',
                    type = 'crook',
                    text = 'You are a crook, help the boss get into the getaway vehicle.',
                    theme = 'cnc'
                }   
            end

        end
        TriggerEvent('pNotify:SendNotification',option)

    else
        spawnRadius = 150
        spawnX = coord.x
        spawnY = coord.y
        spawnZ = 0

        
        i = 0
        j = 0
        k = 0

        FreezeEntityPosition(GetPlayerPed(PlayerId()), true)
        SetEntityCoords(GetPlayerPed(PlayerId()), coord.x, coord.y, coord.z + 100, 1, 0, 0, 1)
        
        repeat
            i = i + 1
            if i > 100 then
                spawnRadius = spawnRadius + 100
                i = 0

            end

            
            repeat
                
                Citizen.Wait(1)
                spawnX = coord.x + math.random(-spawnRadius, spawnRadius)
                spawnY = coord.y + math.random(-spawnRadius, spawnRadius)
                
                _,spawnZ = GetGroundZFor_3dCoord(spawnX+.0, spawnY+.0, 99999.0, 1)
                
                TriggerServerEvent('Debug', 'spawnX:' .. spawnX .. ' spawnY:' .. spawnY .. ' spawnZ:' .. spawnZ)

            until spawnZ ~= 0

            --j = 0

            -- NEU START
            if GetWaterHeight(spawnX, spawnY, spawnZ) then
                k = k + 1
                if k > 50 then
                    i = 100
                    k = 0
                end
            end
            -- NEU ENDE

        until not GetWaterHeight(spawnX, spawnY, spawnZ)

        spawnZ = spawnZ + 0.2

        SetEntityCoords(GetPlayerPed(PlayerId()), spawnX, spawnY, spawnZ, 1, 0, 0, 1)

        
        Citizen.Wait(100)
        FreezeEntityPosition(GetPlayerPed(PlayerId()), false)

    end
 
    -- SET PLAYER MODEL
    local model = GetHashKey(PlayerSetting['model'])
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
    
    
    if HasModelLoaded(model) then
        --print('ID:' .. PlayerId())
        SetPlayerModel(PlayerId(), model)
    else
        print("Couldn't load skin!")
    end

    -- SET WEAPONS

    for k,v in pairs(PlayerSetting['weapons']) do
        GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(v['type']), v['ammo'],true, v['equipt'])
        Citizen.Wait(100)
    end
end)