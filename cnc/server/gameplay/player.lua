local locmap

RegisterNetEvent("baseevents:onPlayerWasted")
RegisterNetEvent("baseevents:onPlayerDied")
RegisterNetEvent("baseevents:onPlayerKilled")

Citizen.CreateThread(
    function()
        AddEventHandler(
            "baseevents:onPlayerKilled",
            function(killerId)
                print("killed:" .. killerId)
                PlayerDied("killed", killerId)
            end
        )

        AddEventHandler(
            "baseevents:onPlayerWasted",
            function()
                print("wasted")
                PlayerDied("died")
            end
        )

        AddEventHandler(
            "baseevents:onPlayerDied",
            function()
                print("died")
                PlayerDied("died")
            end
        )
    end
)

RegisterNetEvent("CNC:Respawn")
AddEventHandler(
    "CNC:Respawn",
    function()
        for i, PlayerInfo in ipairs(PlayerInfos) do
            if tonumber(PlayerInfo.player) == tonumber(source) then
                respawnPlayer(PlayerInfo)
                break
            end
        end
    end
)

function spawnPlayers(map)
    locmap = map
    for i, PlayerInfo in ipairs(PlayerInfos) do
        if PlayerInfo.team ~= "lobby" then
            spawnPlayer(PlayerInfo)
        end
    end
end


function spawnPlayer(PlayerInfo)
    local teamID
    local coord
    TriggerEvent("Log", "spawnPlayer", PlayerInfo)

    print("PlayerInfoTeam:" .. PlayerInfo.team)

    if PlayerInfo.isBoss == true then
        PlayerSetting = getPlayerSettings("boss")
        print(PlayerInfo.playerName .. " is Boss")
    else
        PlayerSetting = getPlayerSettings(PlayerInfo.team)
    end

    rnd = math.random(1, #locmap[PlayerInfo.team]["spawnpoints"])
    coord = locmap[PlayerInfo.team]["spawnpoints"][rnd]

    if PlayerInfo.team == "crook" then
        teamID = 1
    elseif PlayerInfo.team == "cop" then
        teamID = 2
    elseif PlayerInfo.team == "lobby" then
        teamID = 0
    end

    TriggerClientEvent("CNC:newSpawnPlayer", PlayerInfo.player, teamID, coord, PlayerSetting, true, PlayerInfo)
end


function respawnPlayer(PlayerInfo)
    local teamID
    local coord
    TriggerEvent("Log", "respawnPlayer", PlayerInfo)

    print("Respawn Player")

    PlayerSetting = getPlayerSettings(PlayerInfo.team)
    TriggerEvent("Log", "respawnPlayer - frisch geholte Player Settings", PlayerSetting)

    if PlayerInfo.team == "crook" then
        teamID = 1
    elseif PlayerInfo.team == "cop" then
        teamID = 2
    elseif PlayerInfo.team == "lobby" then
        teamID = 0
    end

    -- Respawn Crooks in the near of the Boss
    if PlayerInfo.team == "crook" then
        -- Respawn Cops mean all Cops
        print("Respawn Player crook")
        Boss = getBossInfo()

        coord = {
            x = Boss.coord.x,
            y = Boss.coord.y,
            z = Boss.coord.z
        }
    elseif PlayerInfo.team == "cop" then
        print("Respawn Player cop")

        local CopXPos = {}
        local CopYPos = {}
        local count = 0

        for i, PlInfo in ipairs(PlayerInfos) do
            if tonumber(PlInfo.player) ~= tonumber(PlayerInfo.player) and PlInfo.team == "cop" then
                count = count + 1
                local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(PlInfo.player), false))
                table.insert(CopXPos, PlInfo.coord.x)
                table.insert(CopYPos, PlInfo.coord.y)
            end
        end

        if count > 0 then
            print("Other Cops")
            coord = {
                x = mean(CopXPos),
                y = mean(CopYPos),
                z = 0.0
            }
        else
            print("no Cops")
            Boss = getBossInfo()
            coord = {
                x = Boss.coord.x,
                y = Boss.coord.y,
                z = Boss.coord.z
            }
        end
    end

    TriggerClientEvent("CNC:newSpawnPlayer", PlayerInfo.player, teamID, coord, PlayerSetting, false, PlayerInfo)
end

function PlayerDied(killtype, killerid)
    TriggerEvent("Log", "PlayerDied-type", killtype)
    TriggerEvent("Log", "PlayerDied-killerId", killerid)

    -- print("Player died")
    if isRoundOngoing then
        if killtype == "killed" then
            if killerid ~= -1 then
                for i, PlayerInfo in ipairs(PlayerInfos) do
                    --print(tonumber(source) .. '/' .. PlayerInfo.player)
                    if tonumber(source) == tonumber(PlayerInfo.player) then
                        --print(PlayerInfo.team)
                        if PlayerInfo.team == "cop" then
                            TriggerEvent("CNC:addPoints", "crooks", 100)
                        elseif PlayerInfo.team == "crook" then
                            TriggerEvent("CNC:addPoints", "cops", 100)
                        end
                    end
                end
            else
                for i, PlayerInfo in ipairs(PlayerInfos) do
                    --print(tonumber(source) .. '/' .. PlayerInfo.player)
                    if tonumber(source) == tonumber(PlayerInfo.player) then
                        --print(PlayerInfo.team)
                        if PlayerInfo.team == "cop" then
                            TriggerEvent("CNC:addPoints", "cops", -100)
                        elseif PlayerInfo.team == "crook" then
                            TriggerEvent("CNC:addPoints", "crooks", -100)
                        end
                    end
                end
            end

            if killerid ~= -1 then
                -- Victim
                local victim
                for i, PlayerInfo in ipairs(PlayerInfos) do
                    if tonumber(source) == tonumber(PlayerInfo.player) then
                        --print(PlayerInfo.team)
                        if PlayerInfo.team == "cop" then
                            victim = "~p~" .. PlayerInfo.playerName .. "~s~"
                        elseif PlayerInfo.team == "crook" then
                            victim = "~o~" .. PlayerInfo.playerName .. "~s~"
                        end
                    end
                end

                -- Killer
                local killer
                for i, PlayerInfo in ipairs(PlayerInfos) do
                    if tonumber(killerid) == tonumber(PlayerInfo.player) then
                        if PlayerInfo.team == "cop" then
                            killer = "~p~" .. PlayerInfo.playerName .. "~s~"
                        elseif PlayerInfo.team == "crook" then
                            killer = "~o~" .. PlayerInfo.playerName .. "~s~"
                        end
                    end
                end

                TriggerClientEvent("CNC:showNotification", -1, victim .. " has been murdered by " .. killer .. "!")
            else
                -- Killed by Ped
                local victim
                for i, PlayerInfo in ipairs(PlayerInfos) do
                    if tonumber(source) == tonumber(PlayerInfo.player) then
                        if PlayerInfo.team == "cop" then
                            victim = "~p~" .. PlayerInfo.playerName .. "~s~"
                        elseif PlayerInfo.team == "crook" then
                            victim = "~o~" .. PlayerInfo.playerName .. "~s~"
                        end
                    end
                end

                TriggerClientEvent("CNC:showNotification", -1, victim .. " has been murdered by aggro Ped~!")
            end
        elseif killtype == "died" then
            local victim
            for i, PlayerInfo in ipairs(PlayerInfos) do
                if tonumber(source) == tonumber(PlayerInfo.player) then
                    if PlayerInfo.team == "cop" then
                        TriggerEvent("CNC:addPoints", "cops", -100)
                        victim = "~p~" .. PlayerInfo.playerName .. "~s~"
                    elseif PlayerInfo.team == "crook" then
                        TriggerEvent("CNC:addPoints", "crooks", -100)
                        victim = "~o~" .. PlayerInfo.playerName .. "~s~"
                    end
                end
            end
            TriggerClientEvent("CNC:showNotification", -1, victim .. " committed suicide!")
        end

        if tonumber(source) == tonumber(BossID) then -- If Boss died
            TriggerClientEvent("CNC:showNotification", -1, "~r~ ~h~Boss died!")
            TriggerEvent("CNC:addPoints", "cops", 1000)
            copsWinsTheRound()
        else
            Citizen.Wait(5000)
        end
    end
end

function showPlayers()
    local ListAllPlayer = GetPlayers()
    for i, PlayerInfo in ipairs(ListAllPlayer) do
        print("ID: " .. PlayerInfo .. " / Name: " .. GetPlayerName(PlayerInfo))
    end
end

RegisterNetEvent("playerDropped")
AddEventHandler("playerDropped", function()
        local droppedPlayerID = tonumber(source)

        if droppedPlayerID == tonumber(BossID) then -- If Boss died
            TriggerClientEvent(
                "CNC:showNotification",
                -1,
                "BOSS(" .. GetPlayerName(droppedPlayerID) .. ") disconnected!"
            )
            copsWinsTheRound()
        else
            TriggerClientEvent("CNC:showNotification", -1, GetPlayerName(droppedPlayerID) .. " disconnected!")
            Citizen.Wait(5000)
        end

        -- remove Player to PlayerInfos-List
        for i, PlayerInfo in ipairs(PlayerInfos) do
            if tonumber(PlayerInfo.player) == droppedPlayerID then
                print("Remove Player: " .. PlayerInfo.player)
                table.remove(PlayerInfos, i)
            end
        end

        if isRoundOngoing then
            local copCount = 0
            for i, PlayerInfo in ipairs(PlayerInfos) do
                if PlayerInfo.team == "cop" then
                    copCount = copCount + 1
                end
            end

            if copCount == 0 then
                TriggerClientEvent("CNC:showNotification", -1, "All the cops have been suspended. The game ends.")
                StopGame(true)
            end
        end

        TriggerClientEvent("CNC:ClientUpdate", -1, PlayerInfos)
        TriggerEvent('chat:updatePlayerInfos', PlayerInfos)
    end
)
