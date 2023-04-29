ESX = exports['es_extended']:getSharedObject()

Citizen.CreateThread(function()
  ESX.RegisterServerCallback("buzzer_outfit:getPlayerOutfit", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then 
      cb(xPlayer.getOutfit())
    end
  end)

end)

