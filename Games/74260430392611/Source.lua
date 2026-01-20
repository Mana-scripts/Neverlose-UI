
local function Get_Game_Services(name)
    local name = name or nil
    local Services = require(game:GetService("ReplicatedStorage").Packages.Knit.KnitClient)

    local GetService_Table = debug.getupvalues(Services.GetService)
    if name then
        return GetService_Table[1][name]
    end
    return GetService_Table[1]
end

local function Get_Game_Controllers(name)
    local name = name or nil
    local Controllers = require(game:GetService("ReplicatedStorage").Packages.Knit.KnitClient)

    local GetController_Table = debug.getupvalues(Controllers.GetController)
    if name then
        return GetController_Table[1][name]
    end
    return GetController_Table[1]
end

function Get_Pet_Inventory()
    local Pet_Inventory = {}

    table.foreach(Get_Game_Controllers("DataController").data, function(i,v)
        if string.lower(i) == "inventory" then
            table.foreach(v.pet, function(i,v)
                Pet_Inventory[i] = v
            end)
        end
    end)

    return Pet_Inventory
end

function SafeRun(func, ...)
    local success, err = pcall(func, ...)
    if not success then
        warn(err)
    end
end

local function fireproximitypromptfunc(Obj, Amount, Skip)
    if Obj.ClassName == "ProximityPrompt" then 
        Amount = Amount or 1
        local PromptTime = Obj.HoldDuration
        if Skip then 
            Obj.HoldDuration = 0
        end
        for i = 1, Amount do 
            Obj:InputHoldBegin()
            if not Skip then 
                wait(Obj.HoldDuration)
            end
            Obj:InputHoldEnd()
        end
        Obj.HoldDuration = PromptTime
        Obj.RequiresLineOfSight = false
    else 
        error("userdata<ProximityPrompt> expected")
    end
end

if not getgenv().Loaded_getgenv then
    getgenv().Eggs = math.huge
    getgenv().Egg_Name = "Forest"

    local mt = getrawmetatable(game)
    setreadonly(mt, false)

    local nc = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        
        if getnamecallmethod() == "FireServer" and args[1] == getgenv().Egg_Name then
            args[2] = getgenv().Eggs
            return nc(self, unpack(args))
        end
        
        return nc(self, ...)
    end)
end


local HatchController = require(game:GetService("Players").LocalPlayer.PlayerScripts.Client.Controllers.HatchingController)
local UIController = require(game:GetService("Players").LocalPlayer.PlayerScripts.Client.Controllers.UIController)

spawn(function()
    setreadonly(UIController, false)
    setreadonly(HatchController, false)
    UIController.hideHUD = function() return false end
    if not getgenv().Loaded_getgenv then
        getgenv().OldEggAnimation = HatchController.playEggAnimation
    end
end)


if not getgenv().Loaded_getgenv then
    getgenv().Loaded_getgenv = true
end
local Library = loadstring(game:HttpGetAsync("https://rawscripts.net/raw/Universal-Script-woof-gui-16777"))()

local Window = Library:Window(
    "Symphony",
    "Rebirth Champions"
)

local AutoFarm = Window:Tab("Autofarm")
local Eggs = Window:Tab("Eggs")
local Crafting = Window:Tab("Crafting")

AutoFarm:Toggle("Auto Tap", false, function(t)
    Auto_Tap = t
end)

AutoFarm:line()

AutoFarm:Slider("Rebith Amount", 1, 3, 1, function(v)
    Rebith_Amount = v
end)

AutoFarm:Toggle("Auto Rebirth", false, function(t)
    Auto_Rebirth = t
end)

AutoFarm:line()

AutoFarm:Toggle("Auto Collect Mini Chests", false, function(t)
    Auto_Collect_Mini_Chests = t
end)

AutoFarm:Toggle("Auto Collect Orbs", false, function(t)
    Auto_Collect_Orbs = t
end)

function Get_Eggs()
    local Eggs_Module = require(game:GetService("ReplicatedStorage").Shared.List.Pets.Eggs)
    local Eggs = {}
    for i,v in pairs(Eggs_Module) do
        table.insert(Eggs, i)
    end
    return Eggs
end

Eggs:Dropdown("Select Egg", Get_Eggs(), function(t)
    getgenv().Egg_Name = t
end)

Eggs:Toggle("Auto Open Egg", false, function(t)
    Auto_Open_Egg = t
end)

Eggs:Toggle("Remove Egg Animation", false, function(t)
    if t then
        HatchController.playEggAnimation = function() return false end
    else
        HatchController.playEggAnimation = getgenv().OldEggAnimation
    end
end)

function Click()
    Get_Game_Services("ClickService").click._re:FireServer()
    task.wait(0.1)
end

function Rebirth(Amount)
    Get_Game_Services("RebirthService"):rebirth(Amount)
    task.wait()
end

function Collect_Orbs()
    for i,v in pairs(workspace.Debris.Orbs:GetChildren()) do
        if v:IsA("Part") then
            v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            task.wait(0.01)
        end
    end
end

function Collect_Mini_Chests()
    for i,v in pairs(workspace.Game.Maps:GetDescendants()) do
        if v:IsA("Model") and v.Name == "MiniChest" and v:FindFirstChild("Touch") then
            local PromptDistance = v.Touch.ProximityPrompt.MaxActivationDistance
            v.Touch.ProximityPrompt.MaxActivationDistance = 9e9
            fireproximitypromptfunc(v.Touch.ProximityPrompt, 1, true)
            v.Touch.ProximityPrompt.MaxActivationDistance = PromptDistance
        end
    end
    task.wait(10)
end

function Open_Egg(Egg_Name)
    Get_Game_Services("EggService").openEgg._re:FireServer(Egg_Name, math.huge)
    task.wait(0.1)
end

function AutoGold(pet_names, amount)
    if not pet_names then return end
    local PetService = Get_Game_Services().PetService
    for i,v in pairs(Get_Pet_Inventory()) do
        if table.find(pet_names, v.nm) then
            PetService:craft({i}, false, amount)
        end
    end
end

function Get_PetNames()
    local Pets_List = Get_Pet_Inventory()
    local Pets = {}
    for i,v in pairs(Pets_List) do
        table.insert(Pets, v.nm)
    end
    return Pets
end

local Owned_Pets = Crafting:Checklist("Select Pets", "ownedpet", Get_PetNames(), function(t)
    Selected_Pets = t
end)

Crafting:Button("Refresh Owned Pets", function()
    Owned_Pets:Refresh(Get_PetNames())
end)

Crafting:Slider("Golden Amount", 1, 10, 1, function(v)
    Golden_Amount = v
end)

Crafting:Toggle("Craft Golden Pets", false, function(t)
    Craft_Golden_Pets = t
end)

spawn(function()
    while task.wait() do
        if Auto_Tap then
            SafeRun(Click)
        end
    end
end)

spawn(function()
    while task.wait() do
        if Auto_Rebirth then
            SafeRun(Rebirth, Rebith_Amount)
        end
    end
end)

spawn(function()
    while task.wait() do
        if Auto_Collect_Orbs then
            SafeRun(Collect_Orbs)
        end
    end
end)

spawn(function()
    while task.wait() do
        if Auto_Collect_Mini_Chests then
            SafeRun(Collect_Mini_Chests)
        end
    end
end)

spawn(function()
    while task.wait() do
        if Auto_Open_Egg then
            SafeRun(Open_Egg, getgenv().Egg_Name)
        end
    end
end)

spawn(function()
    while task.wait() do
        if Craft_Golden_Pets then
            SafeRun(AutoGold, Selected_Pets, Golden_Amount)
        end
    end
end)

