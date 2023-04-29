ESX = exports['es_extended']:getSharedObject()

RegisterServerEvent("buzzer_clotheshop:buyComponent")
AddEventHandler("buzzer_clotheshop:buyComponent", function( group, sex, component, value_1, value_2)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local price = GetPrice(group, sex, component, value_1, value_2) 

        if price then 
            if xPlayer.getMoney() >= price then 
                local added = xPlayer.addOutfit(group, sex, component, value_1, value_2)

                if not added then return xPlayer.showNotification("Bạn không đủ chỗ trong kho đồ") end    
                
                xPlayer.removeMoney(price)

                local tryEquip = nil 

                tryEquip = xPlayer.findOutfit(group, sex, component, value_1, value_2)
                if tryEquip then
                    if string.find(tryEquip, "slot_") then 
                        tryEquip = string.gsub(tryEquip, "slot_", "")
                        tryEquip = tonumber(tryEquip)
                        xPlayer.equipOutfit(tryEquip)
                    end
                end
            else
                xPlayer.showNotification("~o~Bạn không đủ tiền")
            end
        end
    end

end)