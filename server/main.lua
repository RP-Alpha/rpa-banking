-- Server logic (Abstract Framework)
local function GetPlayer(source)
    local fw = exports['rpa-lib']:GetFramework()
    local fwName = exports['rpa-lib']:GetFrameworkName()
    
    if fwName == 'qb-core' then
        return fw.Functions.GetPlayer(source)
    elseif fwName == 'qbox' then
        return exports.qbx_core:GetPlayer(source)
    end
    -- OX Core implementation would differ (Classes)
    return nil
end

RegisterNetEvent('rpa-banking:server:requestOpen', function()
    local src = source
    local player = GetPlayer(src)
    if not player then return end

    local data = {
        name = "Unknown Driver",
        balance = 0
    }

    local fwName = exports['rpa-lib']:GetFrameworkName()
    if fwName == 'qb-core' then
        data.name = player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname
        data.balance = player.Functions.GetMoney('bank')
    elseif fwName == 'qbox' then
        data.name = player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname
        data.balance = player.Functions.GetMoney('bank')
    end

    TriggerClientEvent('rpa-banking:client:openBank', src, data)
end)

RegisterNetEvent('rpa-banking:server:deposit', function(amount)
    local src = source
    local player = GetPlayer(src)
    if not player then return end

    if player.Functions.RemoveMoney('cash', amount) then
        player.Functions.AddMoney('bank', amount)
        exports['rpa-lib']:Notify(src, "Deposited $"..amount, "success")
        -- Refresh UI
        TriggerEvent('rpa-banking:server:requestOpen') -- Lazy refresh
    else
        exports['rpa-lib']:Notify(src, "Not enough cash!", "error")
    end
end)

RegisterNetEvent('rpa-banking:server:withdraw', function(amount)
    local src = source
    local player = GetPlayer(src)
    if not player then return end

    if player.Functions.RemoveMoney('bank', amount) then
        player.Functions.AddMoney('cash', amount)
        exports['rpa-lib']:Notify(src, "Withdrew $"..amount, "success")
        -- Refresh UI
        TriggerEvent('rpa-banking:server:requestOpen') -- Lazy refresh
    else
        exports['rpa-lib']:Notify(src, "Not enough in bank!", "error")
    end
end)
