isRoundOngoing  = false
BossID = 0
isBossInGetaway = false
PlayerInfos ={}

GetawayCoord = {x=0,y=0,z=0}
Getaway = {}
net_Getaway = 0
net_Spawner = {}
net_Vehicles = {}

local RoundCounter = 0
local RoundsToPlay = 2
local countPlayerResponse = 0
local currentFolder = "resources//[cnc]//cnc-map//"

local ChoosenMap
map ={}
local CopHint = false
local RndTeam = false
local TrafficDensity = 0.5
local PedDensity = 0.5




function getPlayerInfos( )
    return PlayerInfos
end


function getBossInfo( )
    for i,playerInfo in ipairs(PlayerInfos) do
        if playerInfo.player == BossID then
            return playerInfo
        end
    end
    --return BossInfo
end


function DoesRoundIsGoingOn( )
    return isRoundOngoing
end


function getGlobalMapSettings()
    file = io.open(currentFolder .. "GlobalMap.json", "r")
    local content = file:read("*a")
    file:close()
    local testObj, pos, testErro = json.decode(content)
    return testObj
end


function getPlayerSettings(team)
    TriggerEvent('Log', 'getPlayerSettings', team)

    file = io.open(currentFolder .. "Player.json", "r")
    local content = file:read("*a")
    file:close()
    local testObj, pos, testErro = json.decode(content)
    return testObj[team]
end


function getMap( id )
    TriggerEvent('Log', 'getMap', id)

    print('getmap')
    file = io.open(currentFolder .. "Maps.json", "r")
    local content = file:read("*a")
    --print(content)
    file:close()
    local testObj, pos, testErro = json.decode(content)
    if id == 0 then
        id = math.random( 1, #testObj )
    end
    print("ID:" .. id)
    print("Objekte:" .. #testObj)
    return testObj[id]
end

function getAllMaps()
    TriggerEvent('Log', 'getAllMaps')
    print('getmaps')
    file = io.open(currentFolder .. "Maps.json", "r")
    local content = file:read("*a")
    --print(content)
    file:close()
    local testObj, pos, testErro = json.decode(content)
    --print("Objekte:" .. #testObj)
    return testObj
end

RegisterNetEvent('CNC:startRound')
AddEventHandler('CNC:startRound', function(choosenMap, copHint, rndTeam, pedDensity, trafficDensity)
    local PlayerID = source
    --print('Player: ' .. PlayerID)
    --print(tostring(isRoundOngoing))
    TriggerEvent('Log', 'CNC:startRound', choosenMap)
    TriggerEvent('Log', 'CNC:startRound', copHint)
    
    --print('Cophint: ' .. tostring(copHint) )

    
    if isRoundOngoing then
        for i,PlayerInfo in ipairs(PlayerInfos) do
            --print('PlayerInfo.player: ' .. PlayerInfo.player .. "==" .. 'Player: ' .. PlayerID)
            if tonumber(PlayerInfo.player) == tonumber(PlayerID) then
                if PlayerInfo.team == "lobby" then
                    print(PlayerInfo.player .. 'isLobby')
                    TriggerEvent('CNC:joinRunningRound', PlayerID)
                else
                    print(PlayerInfo.player .. 'NOTLobby')
                    TriggerClientEvent("CNC:showNotification", PlayerID, "~r~You can't join the game two times")
                end
            end
        end       
    else
        ChoosenMap = choosenMap
        CopHint = copHint
        RndTeam = rndTeam
        PedDensity = pedDensity
        TrafficDensity = trafficDensity
        startCNCRound(ChoosenMap)
    end
end)

-- Start Round
function startCNCRound(choosenMap)
    TriggerEvent('Log', 'startCNCRound' , choosenMap)
    local ListAllPlayer = GetPlayers()
    if (#ListAllPlayer<2) then
        print("Can´t start the Round, not enough Player")
        RconPrint("Can´t start the Round, not enough Player")
        --return
    end

    if isRoundOngoing then
        print("Round can't start, round is already running.")
        return
    end

    isRoundOngoing = true
    
    isBossInGetaway = false
    RoundCounter = RoundCounter + 1
    print("start Round " .. RoundCounter .. "!")

    if RoundCounter == 1 then
        print("RoundCounter 1")
        PlayerInfos = {}
        net_Getaway = nil
        --BossInfo = nil
        BossID = 0
        
        print("Count Players: " ..  #ListAllPlayer)
        for i,playerID in pairs(ListAllPlayer) do
            local PlayerInfo ={
                player = playerID,
                playerName = GetPlayerName(playerID);
                type = nil,
                team = nil,
                isBoss = false,
                coord = {
                    x = 0,
                    y = 0,
                    z = 0
                }
            }
            table.insert( PlayerInfos, PlayerInfo )
        end
        randomizeTeams(RndTeam)

        local copCount = 0
        local crookCount = 0

        for i,PlayerInfo in ipairs(PlayerInfos) do
            if PlayerInfo.team == 'crook' then crookCount = crookCount + 1
            elseif PlayerInfo.team == 'cop' then copCount = copCount +1
            end
        end

--[[         if crookCount < 1 then
            TriggerClientEvent("CNC:showNotification", -1, "No Player in the ~o~CROOK-Team ")
            RoundCounter = 0
            isRoundOngoing  = false
            return
        end
        if copCount < 1 then
            TriggerClientEvent("CNC:showNotification", -1, "No Player in the ~p~COP-Team ")
            isRoundOngoing  = false
            RoundCounter = 0
            return
        end ]]

        --print("nach Teams")
        TriggerEvent('CNC:initPoints')

    elseif RoundCounter ~= 1 then
        -- switch Team
        for i,playerInfo in ipairs(PlayerInfos) do
            if playerInfo.team == 'crook' then
                PlayerInfos[i].team = 'cop'
            elseif PlayerInfos[i].team == 'cop' then
                PlayerInfos[i].team = 'crook'
            end
        end
        -- switch Points
        TriggerEvent('CNC:switchPoints')

    end

    -- choose the Boss
    for i,playerInfo in pairs(PlayerInfos) do
        if playerInfo.team == "crook" then
            PlayerInfos[i]['isBoss'] = true
            BossID = PlayerInfos[i].player
            break
        end
    end
    
    map = getMap(choosenMap)
    local rndGetaway = math.random(1, #map['getaway'])
    --local rndGetaway = 1
    TriggerClientEvent('CNC:cleanAll', -1)

    Citizen.Wait(2000)
    TriggerEvent('CNC:StartRound')
    TriggerClientEvent('CNC:StartRound', -1, PlayerInfos)
    --TriggerEvent('chat:updatePlayerInfos', PlayerInfos)
    

    -- CREATE SPAWNER
    local globMap = getGlobalMapSettings()
    TriggerClientEvent('CNC:eventCreateSpawner', -1, globMap['vehicles'] )
    
    
    -- SPAWN PICKUPS
    if RoundCounter == 1 then
        TriggerEvent('CNC:startSpawnPickups', PlayerInfos[1].player)
    end
    
    TriggerClientEvent('CNC:eventCreateGetaway', BossID, map['getaway'][rndGetaway] )
    
    --TriggerClientEvent('CNC:eventCreateSpawner', BossID, globMap['vehicles'] )
    
    -- SPAWN PLAYERS
    Citizen.Wait(1000)
    spawnPlayers(map)
    
    -- SPAWN Vehicles
    Citizen.Wait(500)
    TriggerClientEvent('CNC:eventCreateVehicles', PlayerInfos[1].player, map['vehicle'] )
    
    -- Set Density
    TriggerClientEvent('CNC:setDensity', -1, PedDensity, TrafficDensity )


    if CopHint then
        print('Cophint: is true' )
        for i,player in ipairs(PlayerInfos) do
            if player.team == 'cop' then
                --print('Cophint: send to cop' )
                TriggerClientEvent('CNC:eventCreateCopHints', player.player, map )
            elseif player.team == 'crook' then
                TriggerClientEvent('CNC:eventCreateGetawayWaypoint', player.player, map['getaway'][rndGetaway] )
                
            end
        end
    end

    TriggerClientEvent("CNC:showScaleform", -1, map.infos.title, 'created by ' .. map.infos.autor, 7000)

    TriggerEvent('chat:updatePlayerInfos', PlayerInfos)
end




RegisterNetEvent('CNC:joinRunningRound')
AddEventHandler('CNC:joinRunningRound', function (playerID, team)

    team = team or ''
    local copCount = 0
    local crookCount = 0


    -- choose the Team
    for i,PlayerInfo in ipairs(PlayerInfos) do
        if PlayerInfo.team == 'cop' then
            copCount = copCount + 1
        elseif PlayerInfo.team == 'crook' then
            crookCount = crookCount + 1
        end
    end
    if team  == '' then
        if copCount >= crookCount then
            team = 'crook'
        else
            team = 'cop'
        end
    end


    --print(GetPlayerName(playerID))

    for i,PlayerInfo in ipairs(PlayerInfos) do
        if tonumber(PlayerInfo.player) == tonumber(playerID) then
            PlayerInfo.team = team
        end
    end

    TriggerClientEvent('CNC:StartRound', -1, PlayerInfos)
    TriggerEvent('chat:updatePlayerInfos', PlayerInfos)
    
    if team == 'cop' then
        TriggerClientEvent('CNC:eventCreateCopHints', playerID, map )
    end
    TriggerEvent('CNC:startSpawnPickupsJoiningPlayer', playerID )

    for i,PlayerInfo in ipairs(PlayerInfos) do
        if tonumber(PlayerInfo.player) == tonumber(playerID) then
            respawnPlayer(PlayerInfo)
        end
    end

    TriggerClientEvent('CNC:setDensity', -1, PedDensity, TrafficDensity )
end)






















Citizen.CreateThread(function (  )
    function startCoolDownThread( )
        local time = 30
        for i=1, time do
            if not isBossInGetaway then
                return
            end

            TriggerClientEvent('CNC:showNotification', -1, 'Round ends in: ' .. time - i)
            Citizen.Wait(1000)
        end
        TriggerEvent('CNC:addPoints','crooks', 1000)
        crooksWinsTheRound( )
    end
end)


function crooksWinsTheRound( )
    TriggerEvent('Log', 'crooksWinsTheRound')
    print('Crooks win the Round')
    TriggerClientEvent('CNC:showNotification', -1, 'Crooks wins the Round!')
    Citizen.Wait(5000)
    StopGame(false)
end


function copsWinsTheRound( )
    TriggerEvent('Log', 'copsWinsTheRound')
    print('Cops win the Round')
    TriggerClientEvent('CNC:showNotification', -1, 'Cops wins the Round!')
    Citizen.Wait(5000)
    StopGame(false)
end


function StopGame( hardReste )
    TriggerEvent('Log', 'StopGame')
    TriggerEvent('CNC:clearVehicles')
    isRoundOngoing = false
    isBossInGetaway = false
    net_Getaway = nil
    BossID = 0
    --BossInfo = nil

    for i,playerInfo in pairs(PlayerInfos) do
        PlayerInfos[i]['isBoss'] = false
        --PlayerInfos[i]['team'] = 'lobby'
    end

    TriggerClientEvent('CNC:SetRoundIsGoing', -1, false)
    TriggerClientEvent('CNC:StopRound', -1)
    TriggerClientEvent('CNC:killPlayer', -1)
    TriggerClientEvent('CNC:setTeam', -1, 0)

    TriggerEvent('CNC:showScoreboard')
    
    Citizen.Wait(5000)

    if hardReste then
        RoundCounter = 0
        TriggerClientEvent('CNC:clearPickups', -1)
        for i,playerInfo in pairs(PlayerInfos) do
            --PlayerInfos[i]['isBoss'] = false
            PlayerInfos[i]['team'] = 'lobby'
        end
        return
    end

    if RoundCounter < RoundsToPlay  then
        startNewRoundCoolDown()
    elseif RoundCounter == RoundsToPlay then
        RoundCounter = 0
        TriggerClientEvent('CNC:clearPickups', -1)
        for i,playerInfo in pairs(PlayerInfos) do
            --PlayerInfos[i]['isBoss'] = false
            PlayerInfos[i]['team'] = 'lobby'
        end
    end
end


function startNewRoundCoolDown()
    local time = 15
    --TriggerClientEvent('CNC:showSBA', -1,  true)
    for i=1, time do
        TriggerClientEvent('CNC:showNotification', -1, 'Next Round starts in: ' .. time - i)
        Citizen.Wait(1000)
    end
    --TriggerClientEvent('CNC:showSBA', -1,  false)
    startCNCRound(ChoosenMap)
end


function randomizeTeams(rnd)
    print("Randomize Teams")
    countPlayerResponse = 0

    if rnd then
        print('PlayerInfos:' .. #PlayerInfos)
        shuffle(PlayerInfos)
        local bool = true
        for i,playerInfo in ipairs(PlayerInfos) do
            if bool then
                PlayerInfos[i]['team'] = 'crook'
                bool = not bool
            elseif not bool then
                --PlayerInfos[i]['team'] = 'crook'
                PlayerInfos[i]['team'] = 'cop'
                bool = not bool
            end
        end
    else
        TriggerClientEvent('CNC:getSelectedTeam', -1)
        while (countPlayerResponse ~= #PlayerInfos) do
            Citizen.Wait(1000)
            print('waiting for Player')
        end
    end
end


Citizen.CreateThread(function ( )
    RegisterNetEvent('CNC:sendPlayerCoord')
    AddEventHandler('CNC:sendPlayerCoord', function (coord)
        for i,playerInfo in ipairs(PlayerInfos) do
            if tonumber(playerInfo.player) == tonumber(source) then
                PlayerInfos[i].coord = coord
            end
        end
    end)
end)

RegisterNetEvent('CNC:showScoreboard')
AddEventHandler('CNC:showScoreboard', function( )
    TriggerClientEvent('CNC:showSBA', -1,  true)
    Citizen.Wait(10000)
    TriggerClientEvent('CNC:showSBA', -1,  false)
end)

RegisterNetEvent('CNC:creatPlayerBlip')
AddEventHandler('CNC:creatPlayerBlip', function( )
    players = GetPlayers()
    TriggerClientEvent("CNC:createPlayerBlip", -1, players[2])
end)


RegisterNetEvent('CNC:registerTeam')
AddEventHandler('CNC:registerTeam', function( team )
    TriggerEvent('Log', 'CNC:registerTeam', team)
    --print('ID:' .. source .. ' / Team:' .. team)
    countPlayerResponse = countPlayerResponse + 1
    for i,PlayerInfo in ipairs(PlayerInfos) do
        if tonumber(PlayerInfo.player) == tonumber(source) then
            PlayerInfo.team = team
        end
    end
end)


RegisterNetEvent('CNC:showPlayerInfos')
AddEventHandler('CNC:showPlayerInfos', function( )
    for i,PlayerInfo in ipairs(PlayerInfos) do
        print('ID:' .. PlayerInfo.player .. ' / Team:' .. PlayerInfo.team)
    end
end)

RegisterNetEvent('CNC:Map:startInit')
AddEventHandler('CNC:Map:startInit', function ()
    local playerID = source
    
    print( GetPlayerName(playerID) .. ' joined' )
    TriggerClientEvent('CNC:showNotification', -1, '~g~' .. GetPlayerName(playerID) .. ' ~s~joined the Server')
    tmpMaps = getAllMaps()
    TriggerClientEvent('CNC:Map:init', -1, tmpMaps)



    local PlayerInfo ={
        player = playerID,
        playerName = GetPlayerName(playerID);
        type = nil,
        team = 'lobby',
        isBoss = false,
        coord = {
            x = 0,
            y = 0,
            z = 0
        }
    }
    table.insert( PlayerInfos, PlayerInfo )
    TriggerClientEvent('CNC:ClientUpdate', -1, PlayerInfos)
end)


RegisterNetEvent('CNC:Map:refreshMap')
AddEventHandler('CNC:Map:refreshMap', function ()
    local playerID = source
    
    tmpMaps = getAllMaps()
    TriggerClientEvent('CNC:Map:init', -1, tmpMaps)

end)

RegisterNetEvent('CNC:getPlayerInfos')
AddEventHandler('CNC:getPlayerInfos', function ()
    TriggerEvent('chat:updatePlayerInfos', PlayerInfos)
end)


