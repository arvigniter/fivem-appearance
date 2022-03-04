
local outfitNames
local outfits = {}

local function getOutfitNames()
	outfitNames = nil
	TriggerServerEvent('fivem-appearance:loadOutfitNames')
	repeat Wait(0) until outfitNames
end

local function getOutfit(slot)
	if not outfits[slot] then
		TriggerServerEvent('fivem-appearance:loadOutfit', slot)
		repeat Wait(0) until outfits[slot]
	end

	return outfits[slot]
end

if ESX then
	RegisterNetEvent('esx:playerLoaded', function()
		outfitNames = nil
		outfits = {}
	end)
end

RegisterNetEvent('fivem-appearance:outfitNames', function(data)
	outfitNames = data
end)

RegisterNetEvent('fivem-appearance:outfit', function(slot, data)
	outfits[slot] = data
end)

RegisterCommand('outfits', function(source, args, raw)
	if not outfitNames then
		getOutfitNames()
	end
	print(json.encode(outfitNames, {indent=true}))
end)

RegisterCommand('saveoutfit', function(source, args, raw)
	local slot = tonumber(args[1])

	if type(slot) == 'number' then
		if not outfitNames then
			getOutfitNames()
		end

		local appearance = client.getAppearance()
		outfitNames[slot] = args[2]
		outfits[slot] = appearance

		TriggerServerEvent('fivem-appearance:saveOutfit', appearance, slot, outfitNames)
	end
end)

RegisterCommand('outfit', function(source, args, raw)
	local slot = tonumber(args[1])

	if type(slot) == 'number' then
		local appearance = getOutfit(slot)

		if not appearance.model then appearance.model = 'mp_m_freemode_01' end
		client.setPlayerAppearance(appearance)
	end
end)