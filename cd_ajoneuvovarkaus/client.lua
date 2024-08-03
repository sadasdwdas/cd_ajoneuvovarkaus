local function isNpc(ped)
    return DoesEntityExist(ped) and not IsPedAPlayer(ped)
end

local function getVehiclePlate(vehicle)
    return GetVehicleNumberPlateText(vehicle)
end

local function notifyPolice(data, vehicle)
    local vehiclePlate = getVehiclePlate(vehicle)
    
    TriggerServerEvent('cd_dispatch:AddNotification', {
        job_table = {'police'}, 
        coords = data.coords,
        title = 'Ajoneuvovarkaus',
        message = ''..data.sex..' varastaa ajoneuvoa kohteessa: '..data.street..'. Rekisterinumero: '..vehiclePlate, 
        flash = 0,
        unique_id = data.unique_id,
        sound = 1,
        blip = {
            sprite = 161, 
            scale = 1.2, 
            colour = 3,
            flashes = false, 
            text = 'Ajoneuvovarkaus',
            time = 5,
            radius = 0,
        }
    })
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        if IsPedJacking(playerPed) then
            local vehicle = GetVehiclePedIsTryingToEnter(playerPed)
            local driverPed = GetPedInVehicleSeat(vehicle, -1)
            
            if isNpc(driverPed) then
                local data = exports['cd_dispatch']:GetPlayerInfo()
                notifyPolice(data, vehicle)
                Citizen.Wait(60000)  -- Estet n toistuvat ilmoitukset minuutin ajan
            end
        end
    end
end)
