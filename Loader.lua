
local Loaded = false
if getgenv().UtilityModule then
   getgenv().UtilityModule:waitForCondition(16, function()
      return Loaded == true
   end)
end

local Data = {
	Owner = "Mana",
	Library = "Neverlose-UI"
}

local BaseURL = ("https://raw.githubusercontent.com/%s-scripts/%s/refs/heads/main/Games/"):format(Data.Owner, Data.Library)

local function EncodeSpaces(str)
	return BaseURL .. str:gsub(" ", "%%20")
end

local Games = {
	[18172550962] = EncodeSpaces("Pixel Blade.lua"), -- Spawn
	[18172553902] = EncodeSpaces("Pixel Blade.lua"),
	[133884972346775] = EncodeSpaces("Pixel Blade.lua"),
	[130247632398296] = EncodeSpaces("Anime Fighting Simulator.lua"),
	[76285745979410] = EncodeSpaces("Anime Card Collection.lua"),
	[75992362647444] = EncodeSpaces("Tap Simulator.lua"),
	[111187356770616] = EncodeSpaces("Tap Simulator.lua"), 
	[74260430392611] = EncodeSpaces("Rebirth Champions Ultimate.lua"),
	[2753915549] = EncodeSpaces("Blox Fruits.lua"), -- World 1
	[4442272183] = EncodeSpaces("Blox Fruits.lua"), -- World 2
	[7449423635] = EncodeSpaces("Blox Fruits.lua"), -- World 3
}

function LoadScript(id)
	local url = Games[id]

	if not url then
		warn("Game not supported:", id)
		return
	end
	
	print("Loading:", url)

	local scriptSource = game:HttpGetAsync(url)
	loadstring(scriptSource)()
	print("Welcome "..game.Players.LocalPlayer.Name.."!")

end

LoadScript(game.PlaceId)

getgenv().UtilityModule:Notify({
    Title = getgenv().UtilityModule.HubName,
    Duration = 5,
    Description = "Welcome "..game.Players.LocalPlayer.Name.."!"
})

getgenv().UtilityModule:Notify({
    Title = getgenv().UtilityModule.HubName,
    Duration = 6,
    Description = "Loading Script!"
})

Loaded = true

local function identifyExecutorName(small_name)
	small_name = small_name or false
	if identifyexecutor then
		return small_name == true and string.split(identifyexecutor(), " ")[1]:lower() or string.split(identifyexecutor(), " ")[1]
	end
	return "Unknown"
end

local Supported_Executors = {
	'wave',
	'volt',
	'potassium',
	'seliware'
}

if table.find(Supported_Executors, identifyExecutorName(true)) then
	task.wait(5)
	getgenv().UtilityModule:Notify({
		Title = "Executor Supported",
		Duration = 5,
		Description = tostring(identifyExecutorName()).." Supported!"
	})
else
	task.wait(5)
	getgenv().UtilityModule:Notify({
		Title = "Warning!",
		Duration = 5,
		Description = tostring(identifyExecutorName()).." may not be supported for this script."
	})
end

-- print(game.PlaceId)
-- setclipboard(tostring(game.PlaceId))
