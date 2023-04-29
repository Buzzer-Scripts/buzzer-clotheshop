ESX = exports['es_extended']:getSharedObject()
DefaultClothes = {
	[0] = {
		sex = 0,
		tshirt_1 = 15,
		tshirt_2 = 0,
		torso_1 = 0,
		torso_2 = 4,
		decals_1 = 0,
		decals_2 = 0,
		arms = 15,
		arms_2 = 0,
		pants_1 = 64,
		pants_2 = 10,
		shoes_1 = 16,
		shoes_2 = 0,
		mask_1 = 0,
		mask_2 = 0,
		bproof_1 = 0,
		bproof_2 = 0,
		chain_1 = 0,
		chain_2 = 0,
		helmet_1 = -1,
		helmet_2 = 0,
		ears_1 = -1,
		ears_2 = 0,
		glasses_1 = -1,
		glasses_2 = 0,
		watches_1 = -1,
		watches_2 = 0,
		bracelets_1 = -1,
		bracelets_2 = 0,
		bags_1 = 0,
		bags_2 = 0,
	},
	[1] = {
		sex = 1,
		tshirt_1 = 15,
		tshirt_2 = 0,
		torso_1 = 0,
		torso_2 = 7,
		decals_1 = 0,
		decals_2 = 0,
		arms = 15,
		arms_2 = 0,
		pants_1 = 12,
		pants_2 = 7,
		shoes_1 = 16,
		shoes_2 = 0,
		mask_1 = 0,
		mask_2 = 0,
		bproof_1 = 0,
		bproof_2 = 0,
		chain_1 = 0,
		chain_2 = 0,
		helmet_1 = -1,
		helmet_2 = 0,
		ears_1 = -1,
		ears_2 = 0,
		glasses_1 = -1,
		glasses_2 = 0,
		watches_1 = -1,
		watches_2 = 0,
		bracelets_1 = -1,
		bracelets_2 = 0,
		bags_1 = 0,
		bags_2 = 0,
	}
}
CurrentClothes = {}
WorkingClothes = nil
OutfitIndexs = {}
OutfitKeys = {}
Arms = {}
Citizen.CreateThread(function()
	while not ESX.IsPlayerLoaded() do 
		Wait(100)
	end

	OutfitIndexs = ESX.GetConfig().OutfitIndexs
	OutfitKeys =  ESX.GetConfig().OutfitKeys
	Arms = {
		[0] = ESX.GetConfig().Outfit.male_torsos,
		[1] = ESX.GetConfig().Outfit.female_torsos,
	}



	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		local first = true 
		if  skin == nil then skin = {} end

		for k,v in pairs(skin) do 
			first = false 
			break
		end 

		if first then
			TriggerEvent("hm_character:CreateCharacter")
			TriggerEvent("hm_location:showCreatorFirst")
			skin = { sex = 0 }
		end

		TriggerEvent("skinchanger:loadSkin", skin)
		CurrentClothes.sex = skin.sex
		ReloadOutfit()
	end)
end)



AddEventHandler('skinchanger:reloadClothes', function(sex)
	LoadClothes(sex)
end)

RegisterNetEvent("hm_core:onChangeOutfit")
AddEventHandler('hm_core:onChangeOutfit', function()
	ReloadOutfit()
end)



exports("setClothes", function(...)
	return SetClothes(...)
end)

exports("setWorking", function(...)
	return SetWorking(...)
end)


exports("getWorking", function(...)
	return WorkingClothes
end)

function SetWorking(skin)

	if not skin then
		WorkingClothes = nil
	else
		if WorkingClothes then 
			return false
		end

		WorkingClothes = skin
	end

	LoadClothes()
	return true
end
function SetClothes(name, value)
	CurrentClothes[name] = value 
	LoadClothes()
end

function LoadClothes(sex)

	if sex and CurrentClothes.sex ~= sex then 
		CurrentClothes.sex = sex 
		ResetClothes(true)
		TriggerServerEvent("buzzer_outfit:unEquiqAllOutfit")
		return 
	end 

	local clothes = {}

	for k,v in pairs(CurrentClothes) do 
		clothes[k] = v
	end

	if WorkingClothes and WorkingClothes[CurrentClothes.sex] then 
		for k,v in pairs(WorkingClothes[CurrentClothes.sex]) do 
			clothes[k] = v
		end
	end

	local playerPed = PlayerPedId()
	SetPedComponentVariation	(playerPed, 8,		clothes['tshirt_1'],		clothes['tshirt_2'], 2)					-- Tshirt
	SetPedComponentVariation	(playerPed, 11,		clothes['torso_1'],			clothes['torso_2'], 2)					-- torso parts
	SetPedComponentVariation	(playerPed, 3,		clothes['arms'],			clothes['arms_2'], 2)						-- Amrs
	SetPedComponentVariation	(playerPed, 10,		clothes['decals_1'],		clothes['decals_2'], 2)					-- decals
	SetPedComponentVariation	(playerPed, 4,		clothes['pants_1'],			clothes['pants_2'], 2)					-- pants
	SetPedComponentVariation	(playerPed, 6,		clothes['shoes_1'],			clothes['shoes_2'], 2)					-- shoes
	SetPedComponentVariation	(playerPed, 1,		clothes['mask_1'],			clothes['mask_2'], 2)						-- mask
	SetPedComponentVariation	(playerPed, 9,		clothes['bproof_1'],		clothes['bproof_2'], 2)					-- bulletproof
	SetPedComponentVariation	(playerPed, 7,		clothes['chain_1'],			clothes['chain_2'], 2)					-- chain
	SetPedComponentVariation	(playerPed, 5,		clothes['bags_1'],			clothes['bags_2'], 2)						-- Bag

	if clothes['ears_1'] == -1 then
		ClearPedProp(playerPed, 2)
	else
		SetPedPropIndex			(playerPed, 2,		clothes['ears_1'],			clothes['ears_2'], 2)						-- Ears Accessories
	end
	
	if clothes['helmet_1'] == -1 then
		ClearPedProp(playerPed, 0)
	else
		SetPedPropIndex			(playerPed, 0,		clothes['helmet_1'],		clothes['helmet_2'], 2)					-- Helmet
	end

	if clothes['glasses_1'] == -1 then
		ClearPedProp(playerPed, 1)
	else
		SetPedPropIndex			(playerPed, 1,		clothes['glasses_1'],		clothes['glasses_2'], 2)					-- Glasses
	end

	if clothes['watches_1'] == -1 then
		ClearPedProp(playerPed, 6)
	else
		SetPedPropIndex			(playerPed, 6,		clothes['watches_1'],		clothes['watches_2'], 2)					-- Watches
	end

	if clothes['bracelets_1'] == -1 then
		ClearPedProp(playerPed,	7)
	else
		SetPedPropIndex			(playerPed, 7,		clothes['bracelets_1'],		clothes['bracelets_2'], 2)				-- Bracelets
	end
	

end

function ResetClothes(load)
	for k,v in pairs(DefaultClothes[CurrentClothes.sex]) do
		CurrentClothes[k] = v
	end

	if load then 
		LoadClothes()
	end
end

function ReloadOutfit()
	ESX.TriggerServerCallback("buzzer_outfit:getPlayerOutfit", function(data)

		ResetClothes()
		for k,v in pairs(OutfitIndexs) do 
			local slot = "slot_"..v
			
			if data[slot] then 
				local outfitData = data[slot]
				local outfitConfig = OutfitKeys[outfitData.group][outfitData.component]

				if outfitData.group == "masks" or outfitData.group == "backpack" then 
					outfitConfig = OutfitKeys[outfitData.group]
				end

				CurrentClothes[outfitConfig.Key[1]] = outfitData.value_1
				CurrentClothes[outfitConfig.Key[2]] = outfitData.value_2

			end	
		end

		LoadClothes()
	end) 


end