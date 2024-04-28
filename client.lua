local QBCore = exports['qb-core']:GetCoreObject()

local nbrDisplaying = 1

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/me', 'Using emotes to indicate action.')
    TriggerEvent('chat:addSuggestion', '/do', 'Using emotes to indicate status.')
end)

RegisterCommand('me', function(source, args, raw)
    local text = string.sub(raw, 4)

    local playerPed = PlayerPedId()
    local players, nearbyPlayer = QBCore.Functions.GetPlayersFromCoords(GetEntityCoords(playerPed), 10.0)
    for i = 1, #players, 1 do
        TriggerServerEvent('3dme:shareDisplay', text, GetPlayerServerId(players[i]), '/me')
    end
    TriggerServerEvent('3dme:sendlog', '/me '..text)
end)

RegisterCommand('do', function(source, args, raw)
    local text = string.sub(raw, 4)
    local playerPed = PlayerPedId()
    local players, nearbyPlayer = QBCore.Functions.GetPlayersFromCoords(GetEntityCoords(playerPed), 10.0)
    for i = 1, #players, 1 do
        TriggerServerEvent('3dme:shareDisplay', text, GetPlayerServerId(players[i]), '/do')
    end
    TriggerServerEvent('3dme:sendlog', '/do '..text)
   
end)

RegisterCommand('ooc', function(source, args, raw)
    local text = string.sub(raw, 4)
    local playerPed = PlayerPedId()
    local players, nearbyPlayer = QBCore.Functions.GetPlayersFromCoords(GetEntityCoords(playerPed), 10.0)
    for i = 1, #players, 1 do
        TriggerServerEvent('3dme:shareDisplay', text, GetPlayerServerId(players[i]), '/ooc')
    end
    TriggerServerEvent('3dme:sendlog', '/ooc '..text)
end)

RegisterNetEvent('3dme:triggerDisplay')
AddEventHandler('3dme:triggerDisplay', function(text, source, type)
    local offset = 1.0 + (nbrDisplaying*0.15)
    Display(GetPlayerFromServerId(source), text, offset, type,160,240)
end)

function Display(mePlayer, text, offset, type,boxalpha,textalpha)
    local displaying = true
    Citizen.CreateThread(function()
        Citizen.Wait(2000)
        repeat
            Citizen.Wait(300)
            boxalpha = boxalpha - 4
            textalpha = textalpha - 6
            displaying = true
        until boxalpha <=  0 or textalpha <= 0
            displaying = false
            return false
    end)

    Citizen.CreateThread(function()
        nbrDisplaying = nbrDisplaying + 1
        while displaying do
            Wait(0)
            local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
            text = string.gsub(text,"ş","s")
            text = string.gsub(text,"ğ","g")
            text = string.gsub(text,"Ş","S")
            text = string.gsub(text,"Ğ","G")
            text = string.gsub(text,"İ","I")
            DrawText3D(coordsMe['x'], coordsMe['y'], coordsMe['z']+offset-1.200, text,type,boxalpha,textalpha)
        end
        nbrDisplaying = nbrDisplaying - 1
    end)
end

function DrawText3D(x, y, z, text, type,boxa,texta)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.5, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    if type == '/me' then
        SetTextColour(255, 255, 255, texta)
    else
        SetTextColour(30, 186, 218, texta)
    end
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 320
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, boxa)
end
