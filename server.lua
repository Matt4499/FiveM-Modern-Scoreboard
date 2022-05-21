RegisterNetEvent("scoreboard:getAllPlayers")
AddEventHandler("scoreboard:getAllPlayers", function()
    local players = GetPlayers()
    local playerNames = {}
    for _, i in ipairs(players) do
        playerNames[i] = GetPlayerName(i)
    end
    TriggerClientEvent("scoreboard:updatePlayers", source, players)
    TriggerClientEvent("scoreboard:updatePlayerNames", source, playerNames)
end)