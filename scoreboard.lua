local listOn = false
local playerList = {}
local playerNamesClient = {}
Citizen.CreateThread(function()
    listOn = false
    while true do
        Wait(0)
        if IsControlPressed(0, 27) then
            if not listOn then
                local players = {}
                for _, i in ipairs(playerList) do
                    r, g, b = GetPlayerRgbColour(i)
                    table.insert(players,
                        '<tr style=\"color: rgb(' .. r .. ', ' .. g .. ', ' .. b .. ')\">\n<td>' ..
                            sanitize(playerNamesClient[i]) .. '</td><td>' .. i .. '</td>')
                end
                SendNUIMessage({
                    text = table.concat(players)
                })
                listOn = true
                while listOn do
                    Wait(0)
                    if (IsControlPressed(0, 27) == false) then
                        listOn = false
                        SendNUIMessage({
                            meta = 'close'
                        })
                        break
                    end
                end
            end
        end
    end
end)

function sanitize(txt)
    local replacements = {
        ['&'] = '&amp;',
        ['<'] = '&lt;',
        ['>'] = '&gt;',
        ['\n'] = '<br/>'
    }
    return txt:gsub('[&<>\n]', replacements):gsub(' +', function(s)
        return ' ' .. ('&nbsp;'):rep(#s - 1)
    end)
end
RegisterNetEvent("scoreboard:updatePlayers")
AddEventHandler("scoreboard:updatePlayers", function(players)
    playerList = players
end)

RegisterNetEvent("scoreboard:updatePlayerNames")
AddEventHandler("scoreboard:updatePlayerNames", function(playernames)
    playerNamesClient = playernames
end)

Citizen.CreateThread(function() 
    while true do
        TriggerServerEvent("scoreboard:getAllPlayers")
        Citizen.Wait(1000)
    end
end)
