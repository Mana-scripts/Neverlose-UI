------------ // Anime Card Collection \\ ------------

------------------------------------------------------------
--/////////////////////////GUI\\\\\\\\\\\\\\\\\\\\\\\\\\\\--
------------------------------------------------------------ 

local Conversions = require(game:GetService("ReplicatedStorage").Modules.Utils.Conversions)
local suffixes = require(game:GetService("ReplicatedStorage").Modules.Utils.Conversions.Suffixes)

local suffixLookup = {}
for i, suffix in ipairs(suffixes) do
	suffixLookup[suffix:lower()] = i
end

Conversions.BigNumToNumber = function(value)
	value = tostring(value)
	value = value:gsub("%s+", "")
	value = value:gsub("%$", "")
	value = value:gsub(",", "")

	local isNegative = value:sub(1,1) == "-"
	if isNegative then
		value = value:sub(2)
	end

    local numberPart, suffix = value:match("^([%d%.]+)([a-zA-Z]*)$")
	if not numberPart then
		return tonumber(value) or 0
	end

	local number = tonumber(numberPart)
	if not number then
		return 0
	end

	suffix = suffix:lower()
	local index = suffixLookup[suffix]

	if not index then
		return isNegative and -number or number
	end

	local multiplier = 10^(3 * (index - 1))
	local result = number * multiplier

	return isNegative and -result or result
end

-- print(Conversions.BigNumToNumber("$1.1K"))
-- print(Conversions.BigNumToNumber("-$5M"))
-- print(Conversions.BigNumToNumber("$1,200K"))
-- print(Conversions.BigNumToNumber("1k"))

local Loaded = false
if getgenv().UtilityModule then
   getgenv().UtilityModule:waitForCondition(11, function()
      return Loaded == true
   end)
end

local Library = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Mana-scripts/Neverlose-UI/refs/heads/main/UI/Woof.lua"))()

Loaded = true

local Window = Library:Window(
    getgenv().UtilityModule.HubName,
    "Anime Card Collection",
    getgenv().UtilityModule.Loader
)

getgenv().UtilityModule:Discord("7wZ7vEgWXR")

local AutoFarm = Window:Tab("Autofarm")
local GradingTab = Window:Tab("Grading")
local UpgradeTab = Window:Tab("Upgrades")
local TowerTab = Window:Tab("Tower")
local Market = Window:Tab("Market")
local Easter = Window:Tab("Easter")
local Config = Window:Tab("Config")
Library:ConfigTab(Config)


local TweenService = game:GetService("TweenService")
local CardRemote = game:GetService("ReplicatedStorage").Remotes.Card
local CardConfigModule = require(game:GetService("ReplicatedStorage").Modules.Config.Core.CardConfig)
local CardOpening = require(game:GetService("ReplicatedStorage").Client.UI.CardHandler.CardOpening)
local TowerHandler = require(game:GetService("ReplicatedStorage").Client.UI.TowerHandler)
local TowerConfig = require(game:GetService("ReplicatedStorage").Modules.Config.Core.TowerConfig)
local GradeHandler = require(game:GetService("ReplicatedStorage").Client.UI.GradeHandler)

function DataModule()
    return debug.getupvalues(GradeHandler.Init)[1] -- ReplicatedData.ReplicatedData
end

function GetPlot()
    return tostring(game.Players.LocalPlayer:GetAttribute("Plot"))
end

if not getgenv().OldOpeningAnimation then
    getgenv().OldOpeningAnimation = CardOpening.OpenCard
end

if not getgenv().FastTower then
    getgenv().FastTower = TowerHandler.Attack
    getgenv().UpdateFasterTower = TowerHandler.UpdateFasterTower
end

TowerHandler.UpdateFasterTower = function() return end

TowerTab:Toggle("Auto Battle", false, function(t)
    AutoBattle = t
    if AutoBattle then
        TowerHandler.Attack = function(v81, v82)
            local v83 = 0.075
            local v84 = 0.1
            local v85 = 0.125
            local v86 = 0.1
            v15.VS.Visible = false
            local v87 = tonumber(v81)
            local v88 = tonumber(v82)
            local v89 = v87 / v30
            local v90 = math.clamp(v89, 0, 1)
            local v91 = v88 / v31
            local v92 = math.clamp(v91, 0, 1)
            v2:Create(v15.Player, TweenInfo.new(v83, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ["Position"] = UDim2.fromScale(0.4, 0.529)
            }):Play()
            v2:Create(v15.Enemy, TweenInfo.new(v83, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ["Position"] = UDim2.fromScale(0.6, 0.529)
            }):Play()
            task.wait(v83)
            v15.Player.Whiteout.BackgroundTransparency = 0
            v15.Enemy.Whiteout.BackgroundTransparency = 0
            v15.Player.Whiteout.Visible = true
            v15.Enemy.Whiteout.Visible = true
            v2:Create(v15.Player.Whiteout, TweenInfo.new(v84, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                ["BackgroundTransparency"] = 1
            }):Play()
            v2:Create(v15.Enemy.Whiteout, TweenInfo.new(v84, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                ["BackgroundTransparency"] = 1
            }):Play()
            v2:Create(v15.Player, TweenInfo.new(v84, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ["Position"] = UDim2.fromScale(0.3, 0.529)
            }):Play()
            v2:Create(v15.Enemy, TweenInfo.new(v84, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ["Position"] = UDim2.fromScale(0.7, 0.529)
            }):Play()
            if v25 ~= true then
                v3.Assets.Sounds.Tower.Clash:Play()
            end
            task.wait(v84)
            v15.Player.Whiteout.Visible = false
            v15.Enemy.Whiteout.Visible = false
            v15.Player.Health.Bar.Size = UDim2.fromScale(v90, 1)
            v15.Enemy.Health.Bar.Size = UDim2.fromScale(v92, 1)
            local v93 = v8.Conversions.Abbreviate(math.max(v87, 0), 2)
            local v94 = v8.Conversions.Abbreviate(math.max(v88, 0), 2)
            v15.Player.Health.HealthDisplay.Text = ("%*/%*"):format(v93, (v8.Conversions.Abbreviate(v30, 2)))
            v15.Enemy.Health.HealthDisplay.Text = ("%*/%*"):format(v94, (v8.Conversions.Abbreviate(v31, 2)))
            task.delay(v85, function()
                v2:Create(v15.Player.Health.Back, TweenInfo.new(v83, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                    ["Size"] = UDim2.fromScale(v90, 1)
                }):Play()
                v2:Create(v15.Enemy.Health.Back, TweenInfo.new(v83, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                    ["Size"] = UDim2.fromScale(v92, 1)
                }):Play()
                if 9e9+9e9 <= 0 and v25 ~= true then
                    v3.Assets.Sounds.Tower.PlayerDefeated:Play()
                end
                if v92 <= 0 and v25 ~= true then
                    v3.Assets.Sounds.Tower.EnemyDefeated:Play()
                end
                task.wait(v86)
                v37:FireServer("AttackDone")
            end)
        end
    else
        TowerHandler.Attack = getgenv().FastTower
    end
end)

local v1 = game:GetService("Players")
local v2 = game:GetService("TweenService")
local v3 = game:GetService("ReplicatedStorage")
require(v3.Modules.GameUtils.Types)
local v4 = require(v3.Modules.Config.Core.CardConfig)
local v5 = require(v3.Modules.Config.Core.TowerConfig)
local v6 = require(v3.Modules.GameUtils.Configuration)
local v7 = {}
local v8 = DataModule()
local v9 = {}
local v13 = v1.LocalPlayer
local v14 = v13.PlayerGui
local v15 = v14.Tower.Frame
local v25 = false
local v26 = false
local v30 = 0
local v31 = 0
v7.InBattle = false
local v37 = v3.Remotes.Tower

TowerTab:line()

local Traits = {}
for i,v in pairs(TowerConfig.Traits) do
	if not table.find(Traits, i) then
        table.insert(Traits, i)
    end
end

function Cards(Extra)
    Extra = Extra or nil
    local Cards = {}
    if Extra ~= nil then
        Cards = {Extra}
    end
    for i,v in pairs(CardConfigModule.Packs) do
        for i,v in pairs(v.List) do
            if not table.find(Cards, i) then
                table.insert(Cards, i)
            end
        end
    end
    return Cards
end

local Trait_Tokens = TowerTab:Label("Trait Tokens: Loading...")

spawn(function()
    while task.wait() do
        pcall(function()
            Trait_Tokens:Refresh("Trait Tokens: "..game:GetService("Players").LocalPlayer.PlayerGui.Traits.Frame.PlayerTokens.Amount.Text)
        end)
    end
end)

TowerTab:Checklist("Select Card", "Trait_Card", Cards("All"), function(t)
    TraitCard = t
end)

TowerTab:Checklist("Select Trait", "Traits_Items", Traits, function(t)
    Selected_Traits = t
end)

TowerTab:Toggle("Auto Trait", false, function(t)
    AutoTrait = t
end)

spawn(function()
    while task.wait(0.1) do
        if AutoTrait and TraitCard and Selected_Traits then
            pcall(function()
                if table.find(TraitCard, "All") then
                    for i, v in pairs(Cards()) do
                        local cardData = DataModule().ReplicatedData.GetData("Cards", v)
                        local currentTrait = cardData and cardData.Trait
                        
                        if not currentTrait or not (table.find(Selected_Traits, currentTrait)) then
                            game:GetService("ReplicatedStorage").Remotes.Tower:FireServer("Roll", v)
                            print("Rolling", v, currentTrait)
                            task.wait(0.005)
                        end
                    end
                else
                    for i, v in pairs(TraitCard) do
                        local cardData = DataModule().ReplicatedData.GetData("Cards", v)
                        local currentTrait = cardData and cardData.Trait

                        if not currentTrait or not (table.find(Selected_Traits, currentTrait)) then
                            game:GetService("ReplicatedStorage").Remotes.Tower:FireServer("Roll", v)
                            print("Rolling", v, currentTrait)
                            task.wait(0.005)
                        end
                    end
                end
            end)
        end
    end
end)

spawn(function()
    while task.wait() do
        if AutoBattle then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.Tower:FireServer(
                    "EquipBest"
                )
                task.wait(0.1)
                game:GetService("ReplicatedStorage").Remotes.Tower:FireServer(
                    "StartTower"
                )
                repeat task.wait() until not game:GetService("Players").LocalPlayer.PlayerGui.Tower.Frame.Visible or not AutoBattle
            end)
        end
    end
end)

spawn(function()
    while task.wait() do
        if AutoBattle then
            pcall(function()
                local Event = game:GetService("ReplicatedStorage").Remotes.Tower
                Event:FireServer(
                    "AttackDone"
                )
            end)
        end
    end
end)

function fireproximitypromptfunc(Obj, Amount, Skip, Distance)
    if Obj.ClassName == "ProximityPrompt" then 
        Amount = Amount or 1
        Distance = Distance or 20
        Obj.MaxActivationDistance = Distance
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

AutoFarm:Toggle("Auto Collect", false, function(t)
    AutoCollect = t
end)

-- AutoFarm:Slider("Collect Time", 0, 10, function(t)
--     AutoCollect_Wait = t
-- end)

AutoFarm:Toggle("Auto Collect Tokens", false, function(t)
    AutoCollect_Tokens = t
end)

AutoFarm:Toggle("Auto Collect Potions/Travel Tokens", false, function(t)
    AutoCollect_Potions_TravelToken = t
end)


spawn(function()
    while task.wait() do
        if AutoCollect then
            pcall(function()
                local Plot, Index = "1", "1"
                for i,v in pairs(workspace.Plots:GetChildren()) do
                    Plot = v.Name
                    for i,v in pairs(workspace.Plots[Plot].Map.Display:GetChildren()) do
                        if v:IsA("Model") and (v.Name == "Left" or v.Name == "Right") then
                            for i2,v2 in pairs(v:GetChildren()) do
                                Index = v2.Name
                                CardRemote:FireServer(
                                    "Collect",
                                    workspace.Plots[GetPlot()].Map.Display[v.Name][Index]
                                )
                            end
                        end
                    end
                    task.wait(0.1)
                end
                --task.wait(AutoCollect_Wait)
            end)
        end
    end
end)

local Page, Flip = 1, false
spawn(function()
    while task.wait() do
        if AutoCollect then
            pcall(function()
                local firstNumber = tonumber(workspace.Plots["1"].Map.Display.Page.Gui.Display.Display.Text:match("^%d+"))
                if Page >= 12 then
                    print(Page)
                    Page = 0
                    Flip = not Flip
                end

                if Flip then
                    CardRemote:FireServer(
                        "Page",
                        "LeftArrow"
                    )
                else
                    CardRemote:FireServer(
                        "Page",
                        "RightArrow"
                    )
                end

                Page = Page + 1

                task.wait(0.05)
                --task.wait(AutoCollect_Wait)
            end)
        end
    end
end)

spawn(function()
    while task.wait() do
        if AutoCollect_Tokens then
            pcall(function()
                for i,v in pairs(workspace.Items.Tokens.Server:GetChildren()) do
                    v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                end
            end)
        end
    end
end)

spawn(function()
    while task.wait() do
        if AutoCollect_Potions_TravelToken then
            pcall(function()
                for i,v in pairs(workspace.Items.Misc.Collectables:GetChildren()) do
                    v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                end
            end)
        end
    end
end)

AutoFarm:line()

local Packs = {}
for i,v in pairs(game:GetService("ReplicatedStorage").Assets.Packs:GetChildren()) do
    if not table.find(Packs, v.Name) then
        table.insert(Packs, v.Name)
    end
end

local Pack_Rarities = {"Regular"}
local Rarities = {"All", "Normal"}
local Rarities_AutoPlace = {"Normal"}
for i,v in pairs(require(game:GetService("ReplicatedStorage").Modules.Config.Core.PackExchange)) do
    if not table.find(Rarities, i) and i ~= "Downgrade" then
        table.insert(Rarities, i)
        table.insert(Rarities_AutoPlace, i)
        table.insert(Pack_Rarities, i)
    end
end

AutoFarm:Checklist("Packs", "Packs", Packs, function(t)
    Selected_Pack = t
end)

AutoFarm:Checklist("Rarities", "Rarities", Rarities, function(t)
    Selected_Rarities = t
end)

AutoFarm:Toggle("Auto Buy Packs", false, function(t)
    AutoBuy = t
end)

AutoFarm:line()

spawn(function()
    while task.wait() do
        if AutoBuy then
            pcall(function()
                for i,v in pairs(workspace.Client.Packs:GetChildren()) do
                    if table.find(Selected_Pack, v:FindFirstChildOfClass("MeshPart").Name) then
                            for i2,v2 in pairs(v:GetChildren()) do
                                for i3,v3 in pairs(v2:GetChildren()) do
                                    if v2:FindFirstChildOfClass("Part") then
                                        if table.find(Selected_Rarities, v3.Name) or table.find(Selected_Rarities, "All") then
                                            if DataModule().ReplicatedData.GetData("Cash") > Conversions.BigNumToNumber(v:FindFirstChildOfClass("MeshPart").ConveyorDisplay.Price.Text) then
                                                CardRemote:FireServer(
                                                    "BuyPack",
                                                    v.Name
                                                )
                                            end
                                        end
                                    else
                                        if table.find(Selected_Rarities, "Normal") or table.find(Selected_Rarities, "All") then
                                            if DataModule().ReplicatedData.GetData("Cash") > Conversions.BigNumToNumber(v:FindFirstChildOfClass("MeshPart").ConveyorDisplay.Price.Text) then
                                                CardRemote:FireServer(
                                                    "BuyPack",
                                                    v.Name
                                                )
                                            end
                                        end
                                    end
                                end
                            end
                    end
                    task.wait(0.02)
                end
            end)
        end
    end
end)

AutoFarm:Toggle("Auto Open Packs", false, function(t)
    AutoOpen = t
end)

AutoFarm:Toggle("Remove Opening Animation", false, function(t)
    RemoveOpeningAnimation = t
    if RemoveOpeningAnimation then
        CardOpening.OpenCard = function() return end
    else
        CardOpening.OpenCard = getgenv().OldOpeningAnimation
    end
end)

AutoFarm:Toggle("Allow TP", false, function(t)
    PacksTp = t
end)

local Opening = false
local OldPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
spawn(function()
    while task.wait() do
        if AutoOpen then
            pcall(function()
                for i,v in pairs(workspace.Plots[GetPlot()].Packs:GetChildren()) do
                    for i,v in pairs(v:GetChildren()) do
                        if v:FindFirstChildOfClass("ProximityPrompt") and v.PackTimer.Timer.Text == "Ready!" then
                            if PacksTp then
                                Opening = true
                                OldPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0, 5, 0)
                                fireproximitypromptfunc(v.ProximityPrompt, 1, true, 9e9)
                                task.wait(.1)
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = OldPosition * CFrame.new(0,1,0)
                            end
                            task.wait()
                            fireproximitypromptfunc(v.ProximityPrompt, 1, true, 9e9)
                            Opening = false
                        end
                    end
                end
            end)
        end
    end
end)

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local plot = workspace.Plots[GetPlot()]
local floor = plot.Misc.Floor
local packs = plot.Packs
local misc = plot.Misc

local floorSize = floor.Size
local floorCFrame = floor.CFrame

local spacing = 8
local centerMultiplier = 0.4

local function isFarFromMisc(pos)
    for _, obj in pairs(misc:GetChildren()) do
        if obj ~= floor then
            if obj:IsA("Model") then
                local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    if (part.Position - pos).Magnitude < spacing then
                        return false
                    end
                end
            elseif obj:IsA("BasePart") then
                if (obj.Position - pos).Magnitude < spacing then
                    return false
                end
            end
        end
    end
    return true
end

-- check packs
local function isFarFromPacks(pos)
    for _, pack in pairs(packs:GetChildren()) do
        if pack:FindFirstChild("Bottom") then
            if (pack.Bottom.Position - pos).Magnitude < spacing then
                return false
            end
        end
    end
    return true
end

local function findPosition()
    local attempts = 0

    while attempts < 150 do
        attempts += 1

        local x = math.random(
            -floorSize.X * centerMultiplier,
             floorSize.X * centerMultiplier
        )

        local z = math.random(
            -floorSize.Z * centerMultiplier,
             floorSize.Z * centerMultiplier
        )

        local pos = (floorCFrame * CFrame.new(x, 2, z)).Position

        if isFarFromPacks(pos) and isFarFromMisc(pos) then
            return pos
        end
    end
end

function GetEquipedPack()
    return game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChildOfClass("Model").Name
end

-- AutoFarm:Checklist("Select Auto Place Pack", "AutoPlacePacks", Packs, function(t)
--     Selected_Auto_Pack = t
-- end)

AutoFarm:line()

AutoFarm:Dropdown("Auto Equip Pack", Packs, function(t)
    Selected_Auto_Pack = t
end)

AutoFarm:Dropdown("Pack Rarity", Rarities_AutoPlace, function(t)
    Rarity = t
end)

AutoFarm:Toggle("Auto Place Packs", false, function(t)
    AutoPlace = t
end)

local OldPack = ""
spawn(function()
    while task.wait() do
        if AutoPlace then
            local success, err = pcall(function()
                local placePos = findPosition()
                if placePos then
                    if Opening then return end
                    if not player.Character.HumanoidRootPart:FindFirstChild(Rarity == "Normal" and Selected_Auto_Pack or Selected_Auto_Pack.."-"..Rarity) then
                        CardRemote:FireServer(
                            "Unequip",
                            GetEquipedPack()
                        )
                        task.wait(0.1)
                        CardRemote:FireServer(
                            "Equip",
                            Rarity == "Normal" and Selected_Auto_Pack or Selected_Auto_Pack.."-"..Rarity
                        )
                    end
                    player.Character.HumanoidRootPart.CFrame = CFrame.new(placePos)
                    task.wait(0.4)
                    -- CardRemote:FireServer("Place", GetEquipedPack())
                    CardRemote:FireServer("Place", Rarity == "Normal" and Selected_Auto_Pack or Selected_Auto_Pack.."-"..Rarity)

                end
            end)
            if not success then
                warn("AutoPlace: ", err)
            end
        end
    end
end)

local Gradings = {}
for i,v in pairs(require(game:GetService("ReplicatedStorage").Modules.Config.Core.Grades).List) do
    if not table.find(Gradings, v) then
        table.insert(Gradings, v)
    end
end

GradingTab:Checklist("Select Grade", "Grade", Gradings, function(t)
    Selected_Grade = t
end)

GradingTab:Checklist("Select Card", "Cards", Cards("All"), function(t)
    Selected_Card = t
end)

GradingTab:Toggle("Auto Grade", false, function(t)
    AutoGrade = t
end)

spawn(function()
    while task.wait() do
        if AutoGrade then
            pcall(function()
                local Cards = DataModule().ReplicatedData.GetData("Cards")
                if table.find(Selected_Card, "All") then
                    for i,v in pairs(Cards) do
                        if not table.find(Selected_Grade, v.Grade) then
                            game:GetService("ReplicatedStorage").Remotes.Grade:FireServer(
                                "Roll",
                                i --"Ichigo"
                            )
                            task.wait(0.05)
                        end
                    end
                else
                    for i,v in pairs(Selected_Card) do
                        if v and not table.find(Selected_Grade, DataModule().ReplicatedData.GetData("Cards", v).Grade) then
                            game:GetService("ReplicatedStorage").Remotes.Grade:FireServer(
                                "Roll",
                                v --"Ichigo"
                            )
                            task.wait(0.05)
                        end
                    end
                end
            end)
        end
    end
end)

local UpgradeModule = require(game:GetService("ReplicatedStorage").Modules.Config.Core.Upgrades)
local Upgrades = {}
for i,v in pairs(UpgradeModule) do
	if not table.find(Upgrades, i) then
        table.insert(Upgrades, i)
    end
end

UpgradeTab:Checklist("Select Upgrade", "Upgrade", Upgrades, function(t)
    Selected_Grade = t
end)

UpgradeTab:Toggle("Auto Upgrade", false, function(t)
    AutoUpgrade = t
end)

spawn(function()
    while task.wait() do
        if AutoUpgrade then
            pcall(function()
                for i,v in pairs(UpgradeModule) do
                    if table.find(Selected_Grade, i) then
                        CardRemote:FireServer(
                            "Upgrade",
                            i --"CardChance"
                        )
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
end)


Market:Toggle("Auto Buy Pet Packs", false, function(t)
    Auto_Buy_Pet_Packs = t
end)

local PetsConfig = require(game:GetService("ReplicatedStorage").Modules.Config.Core.PetConfig)
local PetPacks = {}
for i,v in pairs(PetsConfig.Eggs) do
    table.insert(PetPacks, i)
end

Market:Checklist("Pet Packs", "PetPacks", PetPacks, function(t)
    Selected_Pet_Packs = t
end)

spawn(function()
    while task.wait(0.5) do
        if Auto_Buy_Pet_Packs and Selected_Pet_Packs then
            pcall(function()
                for i,v in pairs(Selected_Pet_Packs) do
                    if PetsConfig.Eggs[v].Price > DataModule().ReplicatedData.GetData("PetTokens") then
                        game:GetService("ReplicatedStorage").Remotes.Pet:FireServer(
                            "Roll",
                            v
                        )
                    end
                end
            end)
        end
    end
end)

Market:line()

local MarketPack_Checklist, MarketPack_From_Checklist, MarketPack_To_Checklist
Market:Dropdown("Exchange Method", {"Upgrade", "Downgrade"}, function(t)
    ExchangeMethod = t
    -- if ExchangeMethod == "Upgrade" then
    --     MarketPack_Checklist:visibility(true)
    --     MarketPack_From_Checklist:visibility(false)
    --     MarketPack_To_Checklist:visibility(false)
    -- elseif ExchangeMethod == "Downgrade" then
    --     MarketPack_Checklist:visibility(false)
    --     MarketPack_From_Checklist:visibility(true)
    --     MarketPack_To_Checklist:visibility(true)
    -- end
end)

MarketPack_Checklist = Market:Checklist("Select Market Pack", "Packs_Market", Packs, function(t)
    Selected_Market_Pack = t
end)

Market:Checklist("Select Pack Rarity", "Pack_Rarities", Pack_Rarities, function(t)
    Selected_Pack_Rarities = t
end)

-- MarketPack_Checklist:visibility(true)

-- MarketPack_From_Checklist = Market:Checklist("Select From Pack", "Packs_Market", Cards(), function(t)
--     MarketPack_From_Pack = t
-- end)

-- MarketPack_To_Checklist = Market:Checklist("Select To Pack", "Packs_Market", Cards(), function(t)
--     MarketPack_To_Pack = t
-- end)

-- MarketPack_From_Checklist:visibility(false)
-- MarketPack_To_Checklist:visibility(false)

Market:Toggle("Pack Exchanging", false, function(t)
    Pack_Exchanging = t
end)

local PackExchangeConfig = require(game:GetService("ReplicatedStorage").Modules.Config.Core.PackExchange)
-- local PackExchange = {}
-- for i,v in pairs(PackExchange.Downgrade) do
--     table.insert(PetPacks, i)
-- end

spawn(function()
    while task.wait() do
        if Pack_Exchanging then -- and ExchangeMethod and Selected_Pack_Rarities and Selected_Market_Pack -- (Selected_Market_Pack or (MarketPack_From_Pack and MarketPack_To_Pack))
            pcall(function()
                if ExchangeMethod == "Upgrade" then
                    for i,v in pairs(Selected_Market_Pack) do
                        for i2, v2 in pairs(Selected_Pack_Rarities) do
                            if v2 == "Regular" then
                                game:GetService("ReplicatedStorage").Remotes.Card:FireServer(
                                    "Exchange",
                                    v,
                                    "Regular",
                                    "Gold"
                                )
                                task.wait(0.2)
                            else
                                game:GetService("ReplicatedStorage").Remotes.Card:FireServer(
                                    "Exchange",
                                    v,
                                    PackExchangeConfig.Downgrade[v2].Pack,
                                    v2
                                )
                                task.wait(0.2)
                            end
                        end
                    end
                elseif ExchangeMethod == "Downgrade" then
                    for i,v in pairs(Selected_Market_Pack) do
                        for i2, v2 in pairs(Selected_Pack_Rarities) do
                            game:GetService("ReplicatedStorage").Remotes.Card:FireServer(
                                "Downgrade",
                                v,
                                v2
                            )
                            task.wait(0.2)
                        end
                    end

                end
            end)
        end
        task.wait(0.5)
    end
end)



-- local Event = game:GetService("ReplicatedStorage").Remotes.Potion
-- Event:FireServer(
--     "Craft",
--     "Luck1"
-- )

Market:line()

local Consumables = require(game:GetService("ReplicatedStorage").Modules.Config.Core.Consumables)
local Potions = {}
for i,v in pairs(Consumables) do
    table.insert(Potions, i)
end

Market:Checklist("Select Potion", "Potions", Potions, function(t)
    Selected_Potions = t
end)

Market:Toggle("Auto Craft Potion", false, function(t)
    Auto_Craft_Potion = t
end)

function RemoveNotifications(text)
    for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Notifications.TopNotification:GetChildren()) do
        if v:IsA("Frame") and v:FindFirstChildOfClass("TextLabel") and v:FindFirstChild("Label") and v.Label.Text == text then
            v.Visible = false
        end
    end
end

spawn(function()
    while task.wait() do
        if Auto_Craft_Potion then -- and ExchangeMethod and Selected_Pack_Rarities and Selected_Market_Pack -- (Selected_Market_Pack or (MarketPack_From_Pack and MarketPack_To_Pack))
            pcall(function()
                task.spawn(RemoveNotifications, "Requirements not met!")
                for i,v in pairs(Selected_Potions) do
                    for i2,v2 in pairs(Consumables[v].Requirements) do
                        if tonumber(DataModule().ReplicatedData.GetReplica().Data.Packs[tostring(i2)]) > v2 then
                            game:GetService("ReplicatedStorage").Remotes.Potion:FireServer(
                                "Craft",
                                v
                            )
                            task.wait(0.1)
                        end
                    end
                end
            end)
        end
    end
end)

local Easter_Eggs_Label = Easter:Label("Easter Eggs: 0")
-- Requirements not met! 
Easter:Toggle("Auto Collect Easter Eggs", false, function(t)
    Easter_Collect = t
end)

Easter:Toggle("Notify Collection", false, function(t)
    Notify_When_Collected = t
end)

spawn(function()
    local collect = 0
    while task.wait(0.5) do
        Easter_Eggs_Label:Refresh("Easter Eggs: "..DataModule().ReplicatedData.GetData("EasterEggs"))
        if Easter_Collect then
            pcall(function()
                for i,v in pairs(workspace.VFX:GetChildren()) do
                    if string.find(v.Name, "Egg") then
                        local number = v.Name:match("^(%d+)%-%a+$")
                        game:GetService("ReplicatedStorage").Remotes.Easter:FireServer(
                            "Collect",
                            tostring(number)
                        )
                        if Notify_When_Collected then
                            getgenv().UtilityModule:Notify({
                                Title = "Easter Eggs",
                                Duration = 3,
                                Description = "Collected a Easter Eggs!"
                            })
                        end
                    end
                end
            end)
        end
    end
end)

Easter:line()

local Easter_Module_Config = require(game:GetService("ReplicatedStorage").Modules.Config.Core.EasterConfig)
local Easter_Items = {}
for i,v in pairs(Easter_Module_Config) do
    table.insert(Easter_Items, i)
end

Easter:Checklist("Selected Easter Shop", "AutoBuyEaster", Easter_Items, function(t)
    Selected_Auto_Buy_Easter = t
end)

Easter:Toggle("Easter Auto Buy", false, function(t)
    Easter_Auto_Buy = t
end)

spawn(function()
    while task.wait() do
        if Easter_Auto_Buy then
            pcall(function()
                for i,v in pairs(Selected_Auto_Buy_Easter) do
                    if Easter_Module_Config[v].Price < DataModule().ReplicatedData.GetData("EasterEggs") then -- DataModule().ReplicatedData.GetReplica().Data.EasterEggs
                        game:GetService("ReplicatedStorage").Remotes.Easter:FireServer(
                            "Buy",
                            v
                        )
                    end
                end
            end)
        end
    end
end)

print("Hello world!")
