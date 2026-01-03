local display = false

RegisterNetEvent('rpa-banking:client:openBank', function(data) {
    SetNuiFocus(true, true)
    display = true
    SendNUIMessage({
        action = 'openBox',
        data = data
    })
})

RegisterNUICallback('close', function(data, cb) {
    SetNuiFocus(false, false)
    display = false
    cb('ok')
})

RegisterNUICallback('deposit', function(data, cb) {
    TriggerServerEvent('rpa-banking:server:deposit', data.amount)
    cb('ok')
})

RegisterNUICallback('withdraw', function(data, cb) {
    TriggerServerEvent('rpa-banking:server:withdraw', data.amount)
    cb('ok')
})

-- Command to open bank (for testing)
RegisterCommand('bank', function()
    TriggerServerEvent('rpa-banking:server:requestOpen')
end)

-- Target integration
CreateThread(function()
    local bankModels = { 'prop_atm_01', 'prop_atm_02', 'prop_atm_03', 'prop_fleeca_atm' }
    
    exports['rpa-lib']:AddTargetModel(bankModels, {
        {
            label = "Access ATM",
            icon = "fas fa-money-bill",
            action = function(entity)
                TriggerServerEvent('rpa-banking:server:requestOpen')
            end
        }
    })
end)
