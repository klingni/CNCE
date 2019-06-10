local score = {}



RegisterNetEvent('CNC:initPoints')
AddEventHandler('CNC:initPoints', function()
    score = {
        cops = 0,
        crooks = 0
    }
    TriggerClientEvent('CNC:updateScore', -1, score)
end)


RegisterNetEvent('CNC:addPoints')
AddEventHandler('CNC:addPoints', function(team, points)
    score[team] = score[team] + points
    if score[team] < 0 then score[team] = 0 end
    TriggerClientEvent('CNC:updateScore', -1, score)
end)

RegisterNetEvent('CNC:switchPoints')
AddEventHandler('CNC:switchPoints', function()
    local scoreCops = score['cops']
    local scoreCrooks = score['crooks']

    score['cops'] = scoreCrooks
    score['crooks'] = scoreCops

    TriggerClientEvent('CNC:updateScore', -1, score)
end)