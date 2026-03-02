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

print(Conversions.BigNumToNumber("$1.1K"))
print(Conversions.BigNumToNumber("-$5M"))
print(Conversions.BigNumToNumber("$1,200K"))
print(Conversions.BigNumToNumber("1k"))

local UtilityModule = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Mana-scripts/Neverlose-UI/refs/heads/main/Utility.lua"))()

UtilityModule:Discord("7wZ7vEgWXR")


local Library = loadstring(game:HttpGetAsync("https://rawscripts.net/raw/Universal-Script-woof-gui-16777"))()

local Window = Library:Window(
    "TBH",
    "Anime Card Collection",
    false
)

local AutoFarm = Window:Tab("Autofarm")
local GradingTab = Window:Tab("Grading")
local UpgradeTab = Window:Tab("Upgrades")

local TweenService = game:GetService("TweenService")
local CardRemote = game:GetService("ReplicatedStorage").Remotes.Card
local CardConfigModule = require(game:GetService("ReplicatedStorage").Modules.Config.Core.CardConfig)
local CardOpening = require(game:GetService("ReplicatedStorage").Client.UI.CardHandler.CardOpening)


function GetPlot()
    return tostring(game.Players.LocalPlayer:GetAttribute("Plot"))
end

function DataModule()
    local GradeHandler = require(game:GetService("ReplicatedStorage").Client.UI.GradeHandler)
    local ReplicatedData = debug.getupvalues(GradeHandler.Init)[1]

    return ReplicatedData -- ReplicatedData.ReplicatedData
end

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
                    local Event = game:GetService("ReplicatedStorage").Remotes.Card
                    Event:FireServer(
                        "Page",
                        "LeftArrow"
                    )
                else
                    local Event = game:GetService("ReplicatedStorage").Remotes.Card
                    Event:FireServer(
                        "Page",
                        "RightArrow"
                    )
                end

                Page = Page + 1

                task.wait(0.05)
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

local Rarities = {"All", "Normal"}
for i,v in pairs(require(game:GetService("ReplicatedStorage").Modules.Config.Core.PackExchange)) do
    if not table.find(Rarities, i) then
        table.insert(Rarities, i)
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
                                        if table.find(Selected_Rarities, "Normal") then
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

if not getgenv().OldOpeningAnimation then
    getgenv().OldOpeningAnimation = CardOpening.OpenCard
end

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

local OldPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
spawn(function()
    while task.wait() do
        if AutoOpen then
            pcall(function()
                for i,v in pairs(workspace.Plots[GetPlot()].Packs:GetChildren()) do
                    for i,v in pairs(v:GetChildren()) do
                        if v:FindFirstChildOfClass("ProximityPrompt") and v.PackTimer.Timer.Text == "Ready!" then
                            if PacksTp then
                                OldPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0, 2, 0)
                                fireproximitypromptfunc(v.ProximityPrompt, 1, true, 9e9)
                                task.wait(.1)
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = OldPosition
                            end
                            fireproximitypromptfunc(v.ProximityPrompt, 1, true, 9e9)
                        end
                    end
                end
            end)
        end
    end
end)

AutoFarm:Toggle("Auto Place Packs (Work in progress)", false, function(t)
    AutoPlace = t
end)

spawn(function()
    while task.wait() do
        if AutoPlace then
            pcall(function()
                for i,v in pairs(workspace.Plots[GetPlot()].Packs:GetChildren()) do
                    -- if v:IsA("Model") then
                        for i,v in pairs(v:GetChildren()) do
                            if v.Name ~= "Bottom" and v.Name ~= "Top" then
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0, 3, 6)
                                for i,v in pairs(CardConfigModule.List) do
                                    CardRemote:FireServer(
                                        "Place",
                                        v
                                    )
                                    task.wait(0.1)
                                end
                            end
                        end
                    -- end
                end
            end)
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

local Cards = {"All"}
for i,v in pairs(CardConfigModule.Packs) do
	for i,v in pairs(v.List) do
		if not table.find(Cards, i) then
            table.insert(Cards, i)
        end
	end
end

GradingTab:Checklist("Select Card", "Cards", Cards, function(t)
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
