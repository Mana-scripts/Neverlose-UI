------------ // TAP SIMULATOR \\ ------------

function ConvertToSuffix(number)
    local Suffixes = {
        {1e63, "SQX"},
        {1e60, "DCQ"},
        {1e57, "NQ"},
        {1e54, "OQ"},
        {1e51, "SPQ"},
        {1e48, "SXQ"},
        {1e45, "QG"},
        {1e42, "TG"},
        {1e39, "DD"},
        {1e36, "UD"},
        {1e33, "DC"},
        {1e30, "NO"},
        {1e27, "OC"},
        {1e24, "SP"},
        {1e21, "SX"},
        {1e18, "QI"},
        {1e15, "QD"},
        {1e12, "T"},
        {1e9, "B"},
        {1e6, "M"},
        {1e3, "K"}
    }

    number = tonumber(number)
    if not number then return nil end

    for _, pair in ipairs(Suffixes) do
        local value, suffix = pair[1], pair[2]
        if number >= value then
            local formatted = number / value
            -- Remove unnecessary decimals if it's an integer after division
            if formatted % 1 == 0 then
                formatted = string.format("%.0f", formatted)
            else
                formatted = string.format("%.2f", formatted)
            end
            return formatted .. suffix
        end
    end

    return tostring(number) -- If smaller than 1000, just return the number
end



------------------------------------------------------------
--/////////////////////////GUI\\\\\\\\\\\\\\\\\\\\\\\\\\\\--
------------------------------------------------------------ 

local Neverlose_Main = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Mana-scripts/Neverlose-UI/refs/heads/main/Main.lua"))()

local Win = Neverlose_Main:Window({
    Title = "NEVERLOSE",
    CFG = "Neverlose",
    Key = Enum.KeyCode.H,
    External = {
        KeySystem = false,
        Key = {
            "",
            "Beta"
        }
    }
})
-- // Tab Sections \\ --
local TabSection1 = Win:TSection("Main")

-- // AutoFarm \\ --
local Main_Tab = TabSection1:Tab("AutoFarm")
--
local AutoFarm_Section = Main_Tab:Section("AutoFarm")
local Auto_Open_Section = Main_Tab:Section("Eggs")
local Auto_Rebirth_Section = Main_Tab:Section("Rebirth")
local Auto_Gold_Section = Main_Tab:Section("Auto Craft Golden Pets")
local Misc_Section = Main_Tab:Section("Misc")

local TweenService = game:GetService("TweenService")

local BlacklistedNames = {
    "ChristmasAdminAbuse",
    "Content",
    "Folder",
    "Game",
    "Hidden Pets",
    "Modules"
}
-- Rename Remotes!
for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
    if v:IsA("Folder") and not table.find(BlacklistedNames, v.Name) then
        for i,v in pairs(v:GetChildren()) do
            for i,v in pairs(v:GetChildren()) do
                v.Name = i
            end
        end
    end
end

local function GetModule(from, Module)
    local from = from or "Modules"
    local Module = game:GetService("ReplicatedStorage"):WaitForChild(from):WaitForChild(Module)
    if Module then
        return require(Module)
    end
    return nil
end

local Network = GetModule("Modules", "Network")
local Eggs = GetModule("Game", "Eggs")
local GameData = GetModule("Game", "Replication")
local PetStats = GetModule("Game", "PetStats")

function GetEggs()
    local Eggs_Table = {}
    for i,v in pairs(Eggs) do
        if not table.find(Eggs_Table, i) then
            table.insert(Eggs_Table, i)
        end
    end
    return Eggs_Table
end

function GetRebirths()
    local Rebirth_Module = GetModule("Game", "Rebirths")
    local Rebirth_Numbers = debug.getupvalues(Rebirth_Module.fromIndex)
    local Rebirths = {}
    for i,v in pairs(Rebirth_Numbers[1]) do
        if not table.find(Rebirths, v) then
            table.insert(Rebirths, v)
        end
    end
    return Rebirths
end

AutoFarm_Section:Toggle("Auto Tap", function(t)
    Auto_Tap = t
end)

AutoFarm_Section:Line()

AutoFarm_Section:Toggle("Farm World Chests", function(t)
    AutoFarm_WorldChests = t
end)

AutoFarm_Section:Toggle("Allow TP (Out Soon!)", function(t)
    AutoFarm_WorldChests_Allow_TP = nil
    Neverlose_Main:Notify({
        Title = "Script",
        Text = "Feature out soon.",
        Time = 4
    })
end)

function GetEggPrice(Egg)
    Egg = Eggs[Egg].Price
    return Egg
end

local EggPrice = Auto_Open_Section:Text("Egg Price: ")
Auto_Open_Section:Dropdown("Eggs", GetEggs(), function(t)
    Select_Egg = t
    EggPrice:Update("Egg Price: "..ConvertToSuffix(GetEggPrice(Select_Egg)))
end)

Auto_Open_Section:Dropdown("Eggs Amount", {1, 3, 8}, function(t)
    Select_Egg_Amount = t
end)

Auto_Open_Section:Toggle("Auto Open", function(t)
    Auto_Open = t
end)

Auto_Open_Section:Line()

local Rarities = require(game:GetService("ReplicatedStorage").Game.PetStats.Rarities)
local Rarities_Table = {}
for i,v in pairs(Rarities) do
    table.insert(Rarities_Table, i)
end

Auto_Open_Section:Checklist("Select Auto Delete", "Rarities", Rarities_Table, function(t)
    Select_AutoDelete = t
end)

Auto_Open_Section:Toggle("Auto Delete", function(t)
    Auto_Delete = t
end)

local function AutoDelete(Enabled, Selected)
    if not Enabled then return end
    if type(Selected) == "Number" then return end
    if Selected == nil then print("Please Select What to Delete!") return end

    for i2,v2 in pairs(GameData.Data.Pets) do
        local a = PetStats:GetRarity(v2.Name)
        if table.find(Selected, a) then
            Network:InvokeServer("DeletePet", tostring(v2.Id))
        end
    end
end

Auto_Open_Section:Line()

Auto_Open_Section:Toggle("Auto Equip Best Pets", function(t)
    AutoEquipBestPets = t
end)

Auto_Rebirth_Section:Dropdown("Rebirth Amount", GetRebirths(), function(t)
    Select_Rebirth_Amount = t
end)

Auto_Rebirth_Section:Toggle("Auto Rebirth", function(t)
    Auto_Rebirth = t
end)

local PetsModule = require(game:GetService("ReplicatedStorage").Game.PetStats.Pets)
local Pets_Table = {}
for i,v in pairs(PetsModule) do
    table.insert(Pets_Table, i)
end

table.sort(Pets_Table, function(a, b)
    return a:sub(1,1):lower() < b:sub(1,1):lower()
end)

Auto_Gold_Section:Dropdown("Select Pet", Pets_Table, function(t)
    Select_Pet_To_Craft = t
end)

Auto_Gold_Section:Slider("Pets Amount", 1, 6, 1, function(t)
    Select_Pet_Amount = t
end)

Auto_Gold_Section:Toggle("Auto Craft", function(t)
    Auto_Craft = t
end)

Misc_Section:Toggle("Infinite Jump", function(t)
    Inf_Jump = t
end)

function CorrectRebirth(num)
    local Rebirth_Module = GetModule("Game", "Rebirths")
    local Rebirth_Numbers = debug.getupvalues(Rebirth_Module.fromIndex)
    local Rebirths = {}
    for i,v in pairs(Rebirth_Numbers[1]) do
        if table.find(Rebirth_Numbers[1], num) then
            Rebirths[v] = i
        end
    end
    return Rebirths[num]
end

local function Tap(Enabled)
    if not Enabled then return end
    for i = 1,5 do
        Network:FireServer("Tap", true, nil, true)
    end
end

local function AutoEgg(Enabled, Egg, EggAmount)
    if not Enabled then return end
    Network:InvokeServer("OpenEgg", Egg, tonumber(EggAmount), {})
end

local function AutoRebirth(Enabled, Amount)
    if not Enabled then return end
    Network:InvokeServer("Rebirth", CorrectRebirth(Amount))
end

local function AutoEquipBestPets(Enabled)
    if not Enabled then return end
    Network:InvokeServer("EquipBest")
end

if workspace:FindFirstChild("Manas_Standplate1") then
    workspace:FindFirstChild("Manas_Standplate1"):Destroy()
end

if not workspace:FindFirstChild("Manas_Standplate2") then
    local StandPlate = Instance.new("Part")
    StandPlate.Parent = workspace
    StandPlate.Name = "Manas_Standplate2"
    StandPlate.Size = Vector3.new(20, 0.8, 20)
    StandPlate.Transparency = 0.8
    StandPlate.Anchored = true
    StandPlate.CanCollide = true
    StandPlate.CFrame = CFrame.new(-500, -500, -500)
end

local Player = game.Players.LocalPlayer
local HRP = Player.Character:WaitForChild("HumanoidRootPart")

local Reached_Destination = false
local IsRunning = false -- LOCK (prevents overlap)

local StartCFrame = CFrame.new(
    -152.722702, 214.259918, 258.30957,
    -0.960909963, 0, 0.276861131,
    0, 1, 0,
    -0.276861131, 0, -0.960909963
) -- Allow_TP

local EndCFrame = CFrame.new(
    3.14139509, 14717.7402, 367.142059,
    -0.537782848, 0, -0.843083382,
    0, 1, 0,
    0.843083382, 0, -0.537782848
) -- Allow_TP

local function TweenTo(cf)
    local distance = (HRP.Position - cf.Position).Magnitude
    local tween = TweenService:Create(
        HRP,
        TweenInfo.new(distance / 100, Enum.EasingStyle.Linear),
        { CFrame = cf }
    )

    tween:Play()
    tween.Completed:Wait()
end

local function FarmWorldChests(Enabled, Allow_TP)
    if not Enabled then return end

    -- World chests
    for _, v in ipairs(workspace.Game.WorldChests:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Hitbox") then
            firetouchinterest(HRP, v.Hitbox, 0)
            firetouchinterest(HRP, v.Hitbox, 1)
            -- task.wait(0.05)
        end
    end

    -- Island chests
    for _, island in ipairs(workspace.Island:GetChildren()) do
        if island:IsA("Model") and island:FindFirstChild("Props") then
            for _, prop in ipairs(island.Props:GetChildren()) do
                if prop.Name == "ClickerChest" and prop:FindFirstChild("Hitbox") then
                    firetouchinterest(HRP, prop.Hitbox, 0)
                    firetouchinterest(HRP, prop.Hitbox, 1)
                    -- task.wait(0.05)
                end
            end
        end
    end

end

function AutoGolden(Enabled, Selected_Amount, Selected_Pet)
    if not Enabled then return end
    local Amount = 0
    
    local Pets = {}
    for i,v in pairs(GameData.Data.Pets) do
        if v.Name == Selected_Pet and v.Tier == "Normal" then

            if Amount ~= Selected_Amount then
                Amount = Amount + 1
                table.insert(Pets, v.Id)
            else
                Network:InvokeServer("CraftPets", Pets)
            end
        end
    end
end

game:GetService("UserInputService").JumpRequest:connect(function()
    if not Inf_Jump then return end
    game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")       
end)

function SafeRun(func, ...)
    local success, err = pcall(func, ...)
    if not success then
        warn(err)
    end
end

spawn(function()
    while task.wait() do
        SafeRun(Tap, Auto_Tap)
        SafeRun(AutoEgg, Auto_Open, Select_Egg, Select_Egg_Amount)
        SafeRun(AutoRebirth, Auto_Rebirth, Select_Rebirth_Amount)
        SafeRun(AutoEquipBestPets, AutoEquipBestPets)
        SafeRun(AutoDelete, Auto_Delete, Select_AutoDelete)
        SafeRun(FarmWorldChests, AutoFarm_WorldChests, AutoFarm_WorldChests_Allow_TP)
        SafeRun(AutoGolden, Auto_Craft, Select_Pet_Amount, Select_Pet_To_Craft)
    end
end)
