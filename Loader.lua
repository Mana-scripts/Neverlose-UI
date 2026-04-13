
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
	-- [[Pixel Blade]] --
	[18172550962] = EncodeSpaces("Pixel Blade.lua"), -- Spawn
	[18172553902] = EncodeSpaces("Pixel Blade.lua"),
	[133884972346775] = EncodeSpaces("Pixel Blade.lua"),

	-- [[Anime Fighting Simulator]] --
	[130247632398296] = EncodeSpaces("Anime Fighting Simulator.lua"),

	-- [[Anime Card Collection]] --
	[76285745979410] = EncodeSpaces("Anime Card Collection.lua"),

	-- [[Tap Simulator]] --
	[75992362647444] = EncodeSpaces("Tap Simulator.lua"),
	[111187356770616] = EncodeSpaces("Tap Simulator.lua"), 

	-- [[Rebirth Champions Ultimate]] --
	[74260430392611] = EncodeSpaces("Rebirth Champions Ultimate.lua"),

	-- [[Blox Fruits]] --
	[2753915549] = EncodeSpaces("Blox Fruits.lua"), -- World 1
	[4442272183] = EncodeSpaces("Blox Fruits.lua"), -- World 2
	[7449423635] = EncodeSpaces("Blox Fruits.lua"), -- World 3

	-- [[Anime Final Quest]] --
	[70768610276749] = EncodeSpaces("Anime Final Quest.lua"), -- Wave3
	[73019180051115] = EncodeSpaces("Anime Final Quest.lua"), -- Endless1
	[73912821025828] = EncodeSpaces("Anime Final Quest.lua"), -- Raid2
	[77367808280910] = EncodeSpaces("Anime Final Quest.lua"), -- DivineGeneral
	[81100481912247] = EncodeSpaces("Anime Final Quest.lua"), -- Cracker Land
	[92577188734435] = EncodeSpaces("Anime Final Quest.lua"), -- Endless3
	[95240177479580] = EncodeSpaces("Anime Final Quest.lua"), -- DIO
	[95996380540192] = EncodeSpaces("Anime Final Quest.lua"), -- Endless2
	[100744519298647] = EncodeSpaces("Anime Final Quest.lua"), -- [AIZEN] Anime Final Quest (Lobby)
	[112175864208911] = EncodeSpaces("Anime Final Quest.lua"), -- Cursed Realm Endless
	[113644871968832] = EncodeSpaces("Anime Final Quest.lua"), -- AFK
	[113963744934619] = EncodeSpaces("Anime Final Quest.lua"), -- Boss
	[120826799896677] = EncodeSpaces("Anime Final Quest.lua"), -- Admin Room
	[126889338150949] = EncodeSpaces("Anime Final Quest.lua"), -- Agris Evolve
	[127316980657672] = EncodeSpaces("Anime Final Quest.lua"), -- Wave2
	[129369781546936] = EncodeSpaces("Anime Final Quest.lua"), -- Manipulator
	[130426042808804] = EncodeSpaces("Anime Final Quest.lua"), -- Cursed Realm
	[132561514935233] = EncodeSpaces("Anime Final Quest.lua"), -- MetroStation1
	[136683944064056] = EncodeSpaces("Anime Final Quest.lua"), -- Wave1
	
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
