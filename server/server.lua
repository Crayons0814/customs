local QBCore = exports['qb-core']:GetCoreObject()
local function IsVehicleOwned(plate)
    local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        return true
    end
    return false
end

RegisterServerEvent('qbx-customs:server:buyRepair', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local money = Player.Functions.GetMoney(Config.Money)
    local price = Config.Prices["repair"]
    if money >= price then
        Player.Functions.RemoveMoney(Config.Money, price, "bennys")
        TriggerClientEvent("qbx-customs:client:repairVehicle", src)
    else
        TriggerClientEvent('qbx-customs:client:purchaseFail', src)
    end
end)

RegisterServerEvent("qbx-customs:server:buyCart", function(cart)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local money = Player.Functions.GetMoney(Config.Money)
    local total = cart.total
    local plate = cart.plate
    local mods = cart.mods
    if money >= total then
        Player.Functions.RemoveMoney(Config.Money, total, "bennys")
        TriggerClientEvent('qbx-customs:client:buyCart', data)
    else
        TriggerClientEvent('qbx-customs:client:purchaseFail', src)
    end
    if not IsVehicleOwned(plate) then return end
    MySQL.update.await('UPDATE player_vehicles SET mods = ? WHERE plate = ?', {json.encode(mods), plate})
end)