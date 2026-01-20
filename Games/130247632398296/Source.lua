------------ // Anime Fighting Simulator \\ ------------








------------------------------------------------------------
--///////////////////////SOURCE\\\\\\\\\\\\\\\\\\\\\\\\\\\--
------------------------------------------------------------ 

if game:GetService("ReplicatedStorage").Assets:FindFirstChild("ImpactFrame") then
    game:GetService("ReplicatedStorage").Assets:FindFirstChild("ImpactFrame"):Destroy()
end

if not getgenv().Remove_IShowSpeed_Sound then
    getgenv().Remove_IShowSpeed_Sound = true
    spawn(function()
    while task.wait() do
        if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ImpactFrame") then
            game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("ImpactFrame"):Destroy()
        end
    end
end)
end

------------------------------------------------------------
--//////////////////////Variabels\\\\\\\\\\\\\\\\\\\\\\\\\--
------------------------------------------------------------
local Claim_Quest = false
local Quest_Target = "Boom"
local Tranings = {
    "Strength",
    "Durability",
    "Chakra",
    "Sword",
    "Agility",
    "Speed"
}
local Colors = {
    ["0.705882, 0.501961, 1"] = "Chakra",
    ["1, 0.690196, 0"] = "Agility",
    ["1, 0.333333, 0"] = "Speed",
    ["1, 0, 0"] = "Strength",
    ["0, 0.768627, 1"] = "Durability",
    ["0, 0.654902, 0"] = "Sword",
    ["1, 0.886275, 0"] = "Kill"
}

if game.Workspace:FindFirstChild("Sword_Traning_Place_mana") then
    game.Workspace:FindFirstChild("Sword_Traning_Place_mana"):Destroy()
end

local Sword_Traning_Place = Instance.new("Part")
Sword_Traning_Place.Parent = game.Workspace
Sword_Traning_Place.Name = "Sword_Traning_Place_mana"
Sword_Traning_Place.CFrame = CFrame.new(5000, 700, 500)
Sword_Traning_Place.Anchored = true
Sword_Traning_Place.CanCollide = false



------------------------------------------------------------
--//////////////////////FUNCTIONS\\\\\\\\\\\\\\\\\\\\\\\\\--
------------------------------------------------------------

function Quest_Givers()
    local Quest_Givers = {"None"}
    for i,v in pairs(workspace.Scriptable.NPC.Quest:GetChildren()) do
        if v:IsA("Model") then
            table.insert(Quest_Givers, v.Name)
        end
    end
    return Quest_Givers
end

function ConvertToNumber(string_number)
    local Suffixes = {
        K   = 1e3,
        M   = 1e6,
        B   = 1e9,
        T   = 1e12,
        QD  = 1e15, -- Quadrillion (ADDED)
        QA  = 1e15,
        QN  = 1e18, -- Quintillion (ADDED)
        QI  = 1e18,
        SX  = 1e21,
        SP  = 1e24,
        OC  = 1e27,
        NO  = 1e30,
        DC  = 1e33,
        UD  = 1e36,
        DD  = 1e39,
        TG  = 1e42,
        QG  = 1e45,
        SXQ = 1e48,
        SPQ = 1e51,
        OQ  = 1e54,
        NQ  = 1e57,
        DCQ = 1e60,
        SQX = 1e63
    }

    local function ConvertNumber(input)
        input = tostring(input):upper()

        local numberPart, suffixPart = input:match("([%d%.]+)(%a*)")

        if not numberPart then
            return nil
        end

        local number = tonumber(numberPart)
        if not number then
            return nil
        end

        if suffixPart ~= "" then
            local multiplier = Suffixes[suffixPart]
            if not multiplier then
                warn("Unknown suffix: " .. suffixPart)
                return nil
            end
            number = number * multiplier
        end

        return number
    end

    local numPart, unitPart = string_number:match("(%S+)%s*(.*)")
    local fullNumber = ConvertNumber(numPart)
    return fullNumber
end

function GetAllAreas()
    local Areas = {}
    for i,v in pairs(workspace.Scriptable.TrainingAreas:GetChildren()) do
        table.insert(Areas, v)
    end
    return Areas
end

function Traning(train)
    if train == "Strength" then
        return 1
    elseif train == "Durability" then
        return 2
    elseif train == "Chakra" then
        return 3
    elseif train == "Sword" then
        return 4
    elseif train == "Agility" then
        return 5
    elseif train == "Speed" then
        return 6
    end
    return nil
end

function GetTraningData()
    local Data = {}
    for i,v in pairs(game:GetService("Players").LocalPlayer.Stats:GetChildren()) do
        if v.Name == "1" then
            Data["Strength"] = v.Value
        end

        if v.Name == "2" then
            Data["Durability"] = v.Value
        end

        if v.Name == "3" then
            Data["Chakra"] = v.Value
        end

        if v.Name == "4" then
            Data["Sword"] = v.Value
        end

        if v.Name == "5" then
            Data["Agility"] = v.Value
        end

        if v.Name == "6" then
            Data["Speed"] = v.Value
        end

    end
    return Data
end

function GetBestArea(area_name)
    local BestArea = {
        Strength = {["Number"] = nil, ["Place"] = nil},
        Durability = {["Number"] = nil, ["Place"] = nil},
        Chakra = {["Number"] = nil, ["Place"] = nil},
        ["Sword"] = {["Number"] = nil, ["Place"] = Sword_Traning_Place},
        Speed = {["Number"] = nil, ["Place"] = nil},
        Agility = {["Number"] = nil, ["Place"] = nil}
    }

    local TrainingData = GetTraningData()

    for i, v in pairs(workspace.Scriptable.TrainingAreas:GetChildren()) do
        for i2, v2 in pairs(v:GetChildren()) do
            if v2:IsA("Part") then
                local text = v2.Display.Requires.Text

                -- Strength
                if string.find(text, "Strength") then
                    local Number = ConvertToNumber(text)

                    -- Player can train
                    if Number and TrainingData.Strength >= Number then
                        -- Store highest
                        if not BestArea.Strength["Number"] or Number > BestArea.Strength["Number"] then
                            BestArea.Strength = {["Number"] = Number, ["Place"] = v2.Parent}
                        end
                    end
                end

                -- Durability
                if string.find(text, "Durability") then
                    local Number = ConvertToNumber(text)
                    
                    -- Player can train
                    if Number and TrainingData.Durability >= Number then
                        -- Store highest
                        if not BestArea.Durability["Number"] or Number > BestArea.Durability["Number"] then
                            BestArea.Durability = {["Number"] = Number, ["Place"] = v2.Parent}
                        end
                    end
                end

                -- Chakra
                if string.find(text, "Chakra") then
                    local Number = ConvertToNumber(text)
                    
                    -- Player can train
                    if Number and TrainingData.Chakra >= Number then
                        -- Store highest
                        if not BestArea.Chakra["Number"] or Number > BestArea.Chakra["Number"] then
                            BestArea.Chakra = {["Number"] = Number, ["Place"] = v2.Parent}
                        end
                    end
                end

                -- Sword
                if string.find(text, "Sword Skill") then
                    local Number = ConvertToNumber(text)
                    
                    -- Player can train
                    if Number and TrainingData["Sword"] >= Number then
                        -- Store highest
                        if not BestArea["Sword"]["Number"] or Number > BestArea["Sword"]["Number"] then
                            BestArea["Sword"] = {["Number"] = Number, ["Place"] = Sword_Traning_Place}
                        end
                    end
                end

                -- Speed
                if string.find(text, "Speed") then
                    local Number = ConvertToNumber(text)
                    
                    -- Player can train
                    if Number and TrainingData.Speed >= Number then
                        -- Store highest
                        if not BestArea.Speed["Number"] or Number > BestArea.Speed["Number"] then
                            BestArea.Speed = {["Number"] = Number, ["Place"] = v2.Parent}
                        end
                    end
                end

                -- Agility
                if string.find(text, "Agility") then
                    local Number = ConvertToNumber(text)
                    
                    -- Player can train
                    if Number and TrainingData.Agility >= Number then
                        -- Store highest
                        if not BestArea.Agility["Number"] or Number > BestArea.Agility["Number"] then
                            BestArea.Agility = {["Number"] = Number, ["Place"] = v2.Parent}
                        end
                    end
                end


            end
        end
    end

    return BestArea
end

function GetCurrentQuests()
    local CurrentQuests = {}
    local Objectives = {}
    for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Main.Frames.Quests.Container.List:GetChildren()) do 
        if v:IsA("Frame") then
            CurrentQuests[v.Name] = ""
            for i2,v2 in pairs(v:GetChildren()) do
                for i3,v3 in pairs(v.Bars:GetChildren()) do
                    -- print(v.Name) 
                    if v3:IsA("Frame") and string.find(v.Name, Quest_Target) then
                        -- Check_Objective
                        if v2:IsA("TextLabel") then
                            if string.find(v.Name, Quest_Target) then
                                if v2:IsA("TextLabel") and v2.Name == "Objective" and v3.Progress.Text ~= "Completed" then
                                    CurrentQuests[v.Name] = v2.Text
                                    table.insert(Objectives, Colors[tostring(v3.Bar.BackgroundColor3)])
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return Objectives
end

function GetAttackForms()
    local Attack_Forms = {}
    for i,v in pairs(game:GetService("Players").LocalPlayer.Specials:GetChildren()) do
        table.insert(Attack_Forms, v.Name)
    end
    return Attack_Forms
end

function collect_quests()
    local Quest_Table = {}

    local QuestList = game:GetService("Players").LocalPlayer
        .PlayerGui.Main.Frames.Quests.Container.List

    for _, v in pairs(QuestList:GetChildren()) do
        if v:IsA("Frame") then
            Quest_Table[v.Name] = {}

            for i2, v2 in pairs(v:GetChildren()) do
                if v2:IsA("Folder") then
                    for i3, v3 in pairs(v2:GetChildren()) do
                        if v3:FindFirstChild("Progress") then
                            table.insert(Quest_Table[v.Name], v3.Progress.Text)
                        end
                    end
                end
            end
        end
    end

    return Quest_Table
end

function Check_Quest()
    local quests = collect_quests()
    local Completed = {}

    for i, v in pairs(quests) do
        local allCompleted = true

        if #v == 0 then
            allCompleted = false
        end

        for i2, v2 in pairs(v) do
            if v2 ~= "Completed" then
                allCompleted = false
                break
            end
        end

        if allCompleted then
            table.insert(Completed, i)
        end
    end

    return Completed
end

function Chams_ESP_Setting(option)
    local Chams_Color = option.Chams_Color
    local Fill_Transparency_ESP = option.Fill_Transparency_ESP
    local OutLine_Transparency_ESP = option.OutLine_Transparency_ESP
    local OutLine_ESP = option.OutLine_ESP
    local Outline_Color = option.Outline_Color
    local Chams_ESP = option.Chams_ESP
    for i,v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character then
            if not v.Character:FindFirstChild("Chams_Highligt") then
                local Chams_Highligt = Instance.new("Highlight")
                Chams_Highligt.Name = "Chams_Highligt"
                Chams_Highligt.Parent = v.Character
                Chams_Highligt.FillColor = Chams_Color
                Chams_Highligt.FillTransparency = Fill_Transparency_ESP
                Chams_Highligt.OutlineTransparency = OutLine_Transparency_ESP
                Chams_Highligt.OutlineColor = Outline_Color
                Chams_Highligt.Enabled = Chams_ESP
            else
                local Chams_Highligt = v.Character.Chams_Highligt
                Chams_Highligt.FillColor = Chams_Color
                Chams_Highligt.FillTransparency = Fill_Transparency_ESP
                Chams_Highligt.OutlineTransparency = OutLine_Transparency_ESP
                Chams_Highligt.OutlineColor = Outline_Color
                Chams_Highligt.Enabled = Chams_ESP
            end
        end
    end
end

function MakeBox(Parent)
    local NewBox = Instance.new("BillboardGui")
    NewBox.Adornee = Parent
    NewBox.Parent = Parent
    NewBox.Active = true
    NewBox.Size = UDim2.new(6, 0, 6, 0)
    NewBox.Name = "BOX_ESP"
    NewBox.AlwaysOnTop = true
    NewBox.Enabled = false
    
    local Box = Instance.new("Frame")
    Box.Parent = NewBox
    Box.Name = "Box"
    Box.Size = UDim2.new(0.8,0,1,0)
    Box.BackgroundTransparency = 0
    Box.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Box.AnchorPoint = Vector2.new(0.5, 0.5)
    Box.Position = UDim2.new(0.5, 0, 0.6, 0)

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.Parent = Box
    BoxCorner.CornerRadius = UDim.new(0.1, 0)

    local BoxOutline = Instance.new("UIStroke")
    BoxOutline.Parent = Box
    BoxOutline.Color = Color3.fromRGB(255,255,255)
    BoxOutline.Enabled = true

    local BoxItems = Instance.new("Frame")
    BoxItems.Parent = NewBox
    BoxItems.Name = "BoxItems"
    BoxItems.Size = UDim2.new(1,0,1,0)
    BoxItems.Position = UDim2.new(-0.2, 0, 0.6, 0)
    BoxItems.BackgroundTransparency = 1
    BoxItems.BackgroundColor3 = Color3.fromRGB(255,255,255)
    BoxItems.AnchorPoint = Vector2.new(0.5, 0.5)

    local BoxItemsList = Instance.new("UIListLayout")
    BoxItemsList.Parent = BoxItems
    BoxItemsList.Padding = UDim.new(0, 5)
    BoxItemsList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local Distance = Instance.new("TextLabel")
    Distance.Text = "500m"
    Distance.Name = "Distance"
    Distance.Parent = BoxItems
    Distance.Size = UDim2.new(0.8,0,0.2,0)
    Distance.TextXAlignment = Enum.TextXAlignment.Left
    Distance.BackgroundTransparency = 1
    Distance.TextColor3 = Color3.fromRGB(0,0,0)
    Distance.TextScaled = false
    Distance.TextSize = 10

   local Total_Power = Instance.new("TextLabel")
    Total_Power.Text = "Power: "
    Total_Power.Name = "TotalPower"
    Total_Power.Parent = BoxItems
    Total_Power.Size = UDim2.new(0.8,0,0.2,0)
    Total_Power.TextXAlignment = Enum.TextXAlignment.Left
    Total_Power.BackgroundTransparency = 1
    Total_Power.TextColor3 = Color3.fromRGB(0,0,0)
    Distance.TextScaled = false
    Total_Power.TextSize = 10

    return NewBox
end

function ToggleChams(bool)
    for i,v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character then
            if not v.Character:FindFirstChild("Chams_Highligt") then
                local Chams_Highligt = Instance.new("Highlight")
                Chams_Highligt.Name = "Chams_Highligt"
                Chams_Highligt.Parent = v.Character
                Chams_Highligt.Enabled = bool
            else
                local Chams_Highligt = v.Character.Chams_Highligt
                Chams_Highligt.Enabled = bool
            end
        end
    end
end

function ToggleBox(bool)
    for i,v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character then
            if not v.Character:FindFirstChild("BOX_ESP") then
                local BOX_ESP = MakeBox(v.Character)
                BOX_ESP.Name = "BOX_ESP"
                BOX_ESP.Enabled = bool
            else
                local BOX_ESP = v.Character.BOX_ESP
                BOX_ESP.Enabled = bool
            end
        end
    end
end

function Box_ESP_Setting(option)
    local Box_ESP = option.Box_ESP
    local Box_Transparency_ESP = option.Box_Transparency_ESP
    local Box_Color = option.Box_Color

    local Box_Distance = option.Box_Distance
    local Total_Power2 = option.Total_Power

    local Box_Outline = option.Box_Outline
    local Box_Outline_Color = option.Box_Outline_Color
    local Box_Outline_Transparency = option.Box_Outline_Transparency
    local Box_Text_Color = option.Box_Text_Color

    for i,v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character then
            if not v.Character:FindFirstChild("BOX_ESP") then
                local BOX_ESP = MakeBox(v.Character)
                BOX_ESP.Enabled = Box_ESP
            else
                local BOX_ESP = v.Character.BOX_ESP
                BOX_ESP.Enabled = Box_ESP

                local Box = BOX_ESP.Box
                Box.BackgroundColor3 = Box_Color
                Box.BackgroundTransparency = Box_Transparency_ESP

                Box.UIStroke.Enabled = Box_Outline
                Box.UIStroke.Color = Box_Outline_Color
                Box.UIStroke.Transparency = Box_Outline_Transparency

                local Box_Items = BOX_ESP.BoxItems
                Box_Items.Visible = true

               local TotalPower = Box_Items.TotalPower
                TotalPower.Text = "Power: "..v.leaderstats["Total Power"].Value
                TotalPower.Visible = Total_Power2
                TotalPower.TextColor3 = Box_Text_Color

                local Distance = Box_Items.Distance
                Distance.Visible = Box_Distance
                Distance.TextColor3 = Box_Text_Color
                if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local Distance_calc = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude)
                    Distance.Text = "Distance"..Distance_calc.."m"
                else
                    Distance.Visible = false
                end
            end
        end
    end
end


for i,v in pairs(game.Players:GetPlayers()) do
    if v ~= game.Players.LocalPlayer and v.Character then
        if v.Character:FindFirstChild("BOX_ESP") then
            v.Character.BOX_ESP:Destroy()
        end
        if v.Character:FindFirstChild("Chams_Highligt") then
            v.Character.Chams_Highligt:Destroy()
        end
    end
end



------------------------------------------------------------
--/////////////////////////GUI\\\\\\\\\\\\\\\\\\\\\\\\\\\\--
------------------------------------------------------------ 

local Neverlose_Main = loadstring(game:HttpGetAsync("https://rawscripts.net/raw/Universal-Script-some-ui-83251"))()

local Win = Neverlose_Main:Window({
    Title = "NEVERLOSE",
    CFG = "Neverlose",
    Key = Enum.KeyCode.H,
    External = {
        KeySystem = false,
        Key = {
            "Test",
            "Beta"
        }
    }
})
-- // Tab Sections \\ --
local TabSection1 = Win:TSection("Main")


-- // AutoFarm \\ --
local Main_Tab = TabSection1:Tab("AutoFarm")
--
local AutoTrain_Section = Main_Tab:Section("Auto Train")
local Auto_Attack_Section = Main_Tab:Section("Auto Attack")
local Auto_Claim_Section = Main_Tab:Section("Auto Collect")
local Auto_Farm_Section = Main_Tab:Section("AutoFarm Mobs")

------------------------------------------------------------

local Quest_Target_Drop = AutoTrain_Section:Dropdown("Quest Target", Quest_Givers(), function(t)
    Quest_Target = t
end)

AutoTrain_Section:Button("Update Quest Givers", function()
    Quest_Target_Drop:Update(Quest_Givers())
end)

AutoTrain_Section:Line()

AutoTrain_Section:Dropdown("Select Training", Tranings, function(t)
    Select_Training = t
end)

AutoTrain_Section:Toggle("Auto Train", function(t)
    AutoTrain = t
    if AutoTrain == false then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
    end
end)

------------------------------------------------------------

Auto_Attack_Section:Dropdown("Attack Form", GetAttackForms(), function(t)
    Attack_Form = t
end)

Auto_Attack_Section:Toggle("Auto Attack", function(t)
    AutoAttack = t
end)

Auto_Attack_Section:Line()

Auto_Attack_Section:Dropdown("Select Mob", GetAttackForms(), function(t)
    Attack_Form = t
end)

Auto_Attack_Section:Toggle("Autofarm Mob", function(t)
    AutoAttack = t
end)

------------------------------------------------------------

Auto_Claim_Section:Toggle("Auto Claim Quest", function(t)
    Claim_Quest = t
end)

Auto_Claim_Section:Toggle("Auto Collect Chikara", function(t)
    AutoCollectChikara = t
end)

Auto_Claim_Section:Toggle("Auto Collect Fruits", function(t)
    AutoCollectFruits = t
end)

------------------------------------------------------------

-- // ESP \\ --
local Wall_Hack_Main_Tab = TabSection1:Tab("ESP")
--
local Chams_Section = Wall_Hack_Main_Tab:Section("Chams")
local Box_Section = Wall_Hack_Main_Tab:Section("ESP")
local Box_Addons_Section = Wall_Hack_Main_Tab:Section("ESP - Addons")

------------------------------------------------------------

Chams_Section:Toggle("Chams", function(t)
    Chams_ESP = t
    if not Chams_ESP then
        ToggleChams(Chams_ESP)
    end
end)

Chams_Section:Colorpicker("Chams Color", Color3.fromRGB(255, 255, 255), function(t)
    Chams_Color = t
end)

Chams_Section:Slider("Fill Transparency", 0, 100, 0, function(t)
    Fill_Transparency_ESP = t/100
end)

Chams_Section:Line()

Chams_Section:Toggle("OutLine", function(t)
    OutLine_ESP = t
end)

Chams_Section:Slider("Outline Transparency", 0, 100, 0, function(t)
    OutLine_Transparency_ESP = t/100
end)

Chams_Section:Colorpicker("Outline Color", Color3.fromRGB(255, 255, 255), function(t)
    Outline_Color = t
end)

------------------------------------------------------------

Box_Section:Toggle("Box", function(t)
    Box_ESP = t
    if not Box_ESP then
        ToggleBox(Box_ESP)
    end
end)

Box_Section:Slider("Box Transparency", 0, 100, 80, function(t)
    Box_Transparency_ESP = t/100
end)

Box_Section:Colorpicker("Box Color", Color3.fromRGB(255, 0, 0), function(t)
    Box_Color = t
end)

Box_Section:Line()

Box_Section:Toggle("Box Outline", function(t)
    Box_Outline = t
end)

Box_Section:Slider("Outline Transparency", 0, 100, 0, function(t)
    Box_Outline_Transparency = t/100
end)

Box_Section:Colorpicker("Outline Color", Color3.fromRGB(255, 0, 0), function(t)
    Box_Outline_Color = t
end)

------------------------------------------------------------

Box_Addons_Section:Toggle("Distance", function(t)
    Box_Distance = t
end)

Box_Addons_Section:Toggle("Total Power", function(t)
    Total_Power = t
end)

Box_Addons_Section:Line()

Box_Addons_Section:Colorpicker("Text Color", Color3.fromRGB(255, 0, 0), function(t)
    Box_Text_Color = t
end)

------------------------------------------------------------
--////////////////////////LOOPS\\\\\\\\\\\\\\\\\\\\\\\\\\\--
------------------------------------------------------------ 



task.spawn(function()
    while task.wait() do
        if AutoTrain then
            pcall(function()
                local CurrentQuest = GetCurrentQuests()[1]
                if Quest_Target == "None" then
                    local ohString1 = "Train"
                    local ohNumber2 = Traning(Select_Training)

                    game:GetService("ReplicatedStorage").Remotes.RemoteEvent:FireServer(ohString1, ohNumber2)
                else
                    if CurrentQuest ~= "Kill" then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = GetBestArea()[CurrentQuest]["Place"].CFrame * CFrame.new(0, 0, 0)
                        local ohString1 = "Train"
                        local ohNumber2 = Traning(CurrentQuest)

                        game:GetService("ReplicatedStorage").Remotes.RemoteEvent:FireServer(ohString1, ohNumber2)
                    elseif CurrentQuest == "Speed" or CurrentQuest == "Agility" then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = GetBestArea()[CurrentQuest]["Place"].CFrame * CFrame.new(0, 0, 0)
                        local ohString1 = "Train"
                        local ohNumber2 = math.random(5,6)

                        game:GetService("ReplicatedStorage").Remotes.RemoteEvent:FireServer(ohString1, ohNumber2)
                    end
                end

                if CurrentQuest == "Kill" then
                    local ohString1 = "Train"
                    local ohNumber2 = 1

                    game:GetService("ReplicatedStorage").Remotes.RemoteEvent:FireServer(ohString1, ohNumber2)
                    local Players = game:GetService("Players")
                    local LocalPlayer = Players.LocalPlayer
                    local safezone = workspace.Scriptable.Zones.Safezone
                    local radius = safezone.Size.Magnitude / 2

                    for _, v in pairs(Players:GetPlayers()) do
                        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                            if v.Character.PVPFolder.NewHealth.Value >= 0 then
                                local distance = (safezone.Position - v.Character.HumanoidRootPart.Position).Magnitude

                                if LocalPlayer.OtherData.TotalPower.Value > v.OtherData.TotalPower.Value and distance > radius then -- OUTSIDE safe zone
                                    
                                    LocalPlayer.Character.HumanoidRootPart.CFrame =
                                    v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 0)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if AutoAttack then
            local Attack_Enabled = game.Players.LocalPlayer.Character:FindFirstChild("PVPFolder").Special
            -- print(Attack_Enabled.Value)
            if Attack_Enabled.Value ~= "" and Attack_Enabled.Value ~= Attack_Form then
                local ohString1 = "SummonSpecial"
                local ohString2 = Attack_Enabled.Value

                game:GetService("ReplicatedStorage").Remotes.RemoteFunction:InvokeServer(ohString1, ohString2)
            end

            if Attack_Enabled.Value ~= Attack_Form then
                local ohString1 = "SummonSpecial"
                local ohString2 = Attack_Form

                game:GetService("ReplicatedStorage").Remotes.RemoteFunction:InvokeServer(ohString1, ohString2)
            end
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        pcall(function()
        if not Claim_Quest then
            return
        end

        local completedQuests = Check_Quest()
        if #completedQuests == 0 then
            return
        end

        for i, v in pairs(workspace.Scriptable.NPC.Quest:GetChildren()) do
            for i2, v2 in pairs(completedQuests) do
                if string.find(v2, v.Name) then
                    local clickBox = v:FindFirstChild("ClickBox")
                    if clickBox then
                        for i3, v3 in pairs(clickBox:GetChildren()) do
                            if v3:IsA("ClickDetector") then
                                fireclickdetector(v3)
                            end
                        end
                    end
                end
            end
        end
        end)
    end
end)

task.spawn(function()
    while task.wait() do
        if AutoCollectChikara then
            for i, v in pairs(workspace.Scriptable.ChikaraBoxes:GetChildren()) do
                local clickBox = v:FindFirstChild("ClickBox")
                if clickBox then
                    for i3, v3 in pairs(clickBox:GetChildren()) do
                        if v3:IsA("ClickDetector") then
                            fireclickdetector(v3)
                        end
                    end
                end
            end
            task.wait(60*2)
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if AutoCollectFruits then
            for i, v in pairs(workspace.Scriptable.Fruits:GetChildren()) do
                local clickBox = v:FindFirstChild("ClickBox")
                if clickBox then
                    for i3, v3 in pairs(clickBox:GetChildren()) do
                        if v3:IsA("ClickDetector") then
                            fireclickdetector(v3)
                        end
                    end
                end
            end
            task.wait(15)
        end
    end
end)

spawn(function()
    while task.wait() do
    if not Chams_ESP then continue end
        Chams_ESP_Setting({
            Chams_Color = Chams_Color,
            Fill_Transparency_ESP = Fill_Transparency_ESP,
            OutLine_Transparency_ESP = OutLine_Transparency_ESP,
            OutLine_ESP = OutLine_ESP,
            Outline_Color = Outline_Color,
            Chams_ESP = Chams_ESP
        })
    end
end)

spawn(function()
    while task.wait() do
    if not Box_ESP then continue end
        local err, success = pcall(function()
            Box_ESP_Setting({
                Box_ESP = Box_ESP,
                Box_Transparency_ESP = Box_Transparency_ESP,
                Box_Color = Box_Color,
                Box_Distance = Box_Distance,
                Box_Outline = Box_Outline,
                Box_Outline_Transparency = Box_Outline_Transparency,
                Box_Outline_Color = Box_Outline_Color,
                Total_Power = Total_Power,
                Box_Text_Color = Box_Text_Color,
            })
        end)
    end
end)
