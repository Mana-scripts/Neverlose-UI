

local UtilityModule = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Mana-scripts/Neverlose-UI/refs/heads/main/Utility.lua"))()

UtilityModule:Discord("7wZ7vEgWXR")

local Library = UtilityModule.Library()

local Window = Library:Window(
    UtilityModule.HubName,
    "Blox Fruits",
    UtilityModule.Loader
)

if not getgenv().Qyrix_Loaded then
    getgenv().Qyrix_Loaded = {
        Loaded = true,
    }
else
    for i,v in pairs(getgenv().Qyrix_Loaded) do
        print("Function "..i.." Already Loaded!")
    end
end



UtilityModule:Notify({
    Title = "Welcome!",
    Description = "Hello "..game.Players.LocalPlayer.Name.."!",
    Duration = 5
})

local AutoFarm = Window:Tab("Autofarm")
local Misc = Window:Tab("Misc")

local Config = Window:Tab("Config")
Library:ConfigTab(Config)

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Replica = game:GetService("ReplicatedStorage")
local Remotes = Replica:WaitForChild("Remotes")
local FakeLevel, Level = 0, game:GetService("Players").LocalPlayer.Data.Level

local Quests = require(game:GetService("ReplicatedStorage").Quests)
local QuestController = require(game:GetService("ReplicatedStorage").Controllers.QuestController)
local success, CombatController = pcall(function()
    return require(game.ReplicatedStorage.Controllers.CombatController)
end)
-- local CombatController = require(game.ReplicatedStorage.Controllers.CombatController)

local CombatUtil = require(game:GetService("ReplicatedStorage").Modules.CombatUtil)
local CamShake = require(game:GetService("ReplicatedStorage").Util.CameraShaker)

function GetQuestPlace(lvl)
    local Navigation = require(game:GetService("ReplicatedStorage").GuideModule)
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    local pos = character.HumanoidRootPart.Position
    local level = lvl
	
    local npcData = Navigation:GetNearestNPC(pos, level)

    local Data = nil

    -- print(".---------------")
    if npcData then
		return {
			NPCPos = npcData[1],
			NPCName = npcData[2],
			Island = npcData[3],
			NPCHRP = npcData[4]
		}
    end

    return Data
end


function GetQuestData(lvl)
    local player = Players.LocalPlayer
    local level = lvl

    local QuestData = nil
    local QuestName = nil
    local QuestIndex = nil
    local bestLevel = -1

    for i, quest in pairs(Quests) do
		for i2,v in pairs(quest) do
			local requiredLevel = v.LevelReq
			if requiredLevel <= level then
				local validTask = false
				for _, amount in pairs(v.Task) do
					if amount > 1 then
						validTask = true
						break
					end
				end

				if validTask then
					if requiredLevel > bestLevel then
						bestLevel = requiredLevel
						QuestData = v
                        QuestName = i
						QuestIndex = i2
					end
				end
			end
		end
    end
    
    return {
		QuestData = QuestData,
		QuestName = QuestName,
		QuestIndex = QuestIndex,
	}
end

-- local questGroup = "BuggyQuest1"
-- local questName = "Pirates"

-- local questData = QuestController:GetQuest(questGroup, questName)


-- local FastAttack_Func = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Mana-scripts/Neverlose-UI/refs/heads/main/Games/BloxFruitModules/FastAttack.lua"))()


local HitDelayEnabled = true

local originalConstants = {}
local originalAOE
local aoeHook

for i,v in pairs(debug.getconstants(CombatUtil.RunHitDetection)) do
    if tonumber(v) and math.abs(v - 0.13) < 0.01 then
        originalConstants[i] = v
    end
end

originalAOE = CombatUtil.GetDefaultAOEDelay

local CombatUtil = require(game:GetService("ReplicatedStorage").Modules.CombatUtil)
CombatUtil.CanAttack = function() return true end

function ToggleHitDelay(state)
    HitDelayEnabled = state

    for index,orig in pairs(originalConstants) do
        if HitDelayEnabled then
            debug.setconstant(CombatUtil.RunHitDetection, index, 0)
        else
            debug.setconstant(CombatUtil.RunHitDetection, index, orig)
        end
    end

    if HitDelayEnabled then
        if not aoeHook then
            aoeHook = hookfunction(CombatUtil.GetDefaultAOEDelay,function(...)
                return 0
            end)
        end
    else
        if aoeHook then
            hookfunction(CombatUtil.GetDefaultAOEDelay, originalAOE)
            aoeHook = nil
        end
    end
end

-- local TeleportService = game:GetService("TeleportService")
-- local Players = game:GetService("Players")

-- local player = Players.LocalPlayer
-- local placeId = game.PlaceId

-- TeleportService:Teleport(placeId, player)

local OldNameCall = nil
OldNameCall = hookmetamethod(game, "__namecall", function(self, ...)
    local Args = {...}
    local Self = Args[1]
    if self.Name == "RE/ReceivedHit" then
        return "  ___XP DE KEY"
    end
    return OldNameCall(self, ...)
end)

if not getgenv().Qyrix_Loaded.FastAttack_original then
    getgenv().Qyrix_Loaded.FastAttack_original = CombatController.Attack
end

function IsAlive(Model)
    return Model and Model:FindFirstChild("Humanoid") and Model.Humanoid.Health > 0
end

function Attack()
    local player = Players.LocalPlayer

    local tool = player.Character:FindFirstChildOfClass("Tool")

    local input = {
        UserInputType = Enum.UserInputType.MouseButton1,
        UserInputState = Enum.UserInputState.Begin
    }
    pcall(function()
        CombatController:Attack(tool, input)
    end)
    
    task.wait()
end

AutoFarm:Toggle("Auto Equip Weapon", false, function(t)
    Auto_Equip_Weapon = t
end)

function GetWeapons()
    local Weapons = {}

    for i,v in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") and v.Name ~= "Tool" then
            table.insert(Weapons, v.Name)
        end
    end

    return Weapons
end

local Weapons_Drop = AutoFarm:Dropdown("Select Weapon", GetWeapons(), function(t)
    Selected_Weapon = t
end)

AutoFarm:Button("Refresh Weapons", function()
    Weapons_Drop:Refresh(GetWeapons())
end)

function EquipWeapon(Weapon)
    if not game.Players.LocalPlayer.Character:FindFirstChild(Weapon) then
        local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(Weapon)
        task.wait()
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
    end
end

AutoFarm:line()

AutoFarm:Toggle("Autofarm", false, function(t)
    Autofarm = t
end)

AutoFarm:Slider("Distance X", -20, 20, 0, function(t)
    Distance_X = t
end)

AutoFarm:Slider("Distance Y", -20, 20, 0, function(t)
    Distance_Y = t
end)

AutoFarm:Slider("Distance Z", -20, 20, 0, function(t)
    Distance_Z = t
end)

AutoFarm:line()


if not getgenv().Qyrix_Loaded.FastDMGHitFuncTest then
	getgenv().Qyrix_Loaded.ValuesDMGHit = {}
    getgenv().Qyrix_Loaded.FastDMGHitFuncTest = true
    print("-------------------")
	for i,v in pairs(getgc()) do
		if typeof(v) == "function" and getfenv(v).script == game:GetService("ReplicatedStorage").Modules.CombatUtil then
			for i2,v2 in pairs(debug.getconstants(v)) do
				if type(v2) == "number" then
					getgenv().Qyrix_Loaded.ValuesDMGHit[i2] = {v, v2}
				end
			end
		end
	end
end

if not getgenv().Qyrix_Loaded.FastHitFuncTest then
	getgenv().Qyrix_Loaded.ValuesHit = {}
    getgenv().Qyrix_Loaded.FastHitFuncTest = true
    print("-------------------")
    for i,v in pairs(getgc()) do
        if typeof(v) == "function" and getfenv(v).script == game.ReplicatedStorage.Controllers.CombatController then
            for i2,v2 in pairs(debug.getupvalues(v)) do
                if type(v2) == "number" then
                    getgenv().Qyrix_Loaded.ValuesHit[i2] = {v, v2}
                end
            end
        end
    end
end

local FastAttack_Func = {}

local Characters_F = workspace:WaitForChild("Characters")
local Enemies_F = workspace:WaitForChild("Enemies")

function FastAttack_Func:Target(Enemies, Folder, Distance)
    local BasePart = nil
    for _, Enemy in Folder:GetChildren() do
        local Head = Enemy:FindFirstChild("Head")
        if Head and Enemy.Humanoid.Health > 0 and game.Players.LocalPlayer:DistanceFromCharacter(Head.Position) < tonumber(Distance) then
            if Enemy ~= game.Players.LocalPlayer.Character then
                table.insert(Enemies, { Enemy, Head })
                BasePart = Head
            end
        end
    end
    return BasePart
end

function FastAttack_Func:Attack(Distance)
    local Enemies = {}
    local E_Mob = self:Target(Enemies, Enemies_F, Distance)
    local E_plr = self:Target(Enemies, Characters_F, Distance)
    if #Enemies > 0 then
        if not (E_Mob or E_plr) or #Enemies == 0 then return end
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterAttack"):FireServer(0)
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterHit"):FireServer(E_Mob or E_plr, Enemies)
    end
end

AutoFarm:Toggle("Fast Attack", false, function(t)
    FastAttack = t
	-- ToggleHitDelay(FastAttack)
    -- if FastAttack then
    --     for i,v in pairs(getgenv().Qyrix_Loaded.ValuesHit) do
    --         if tonumber(debug.getupvalue(v[1], i)) == 0.8 then
    --             print(i,v)
    --             debug.setupvalue(v[1], i, 0)
    --         end
    --     end

    --     for i,v in pairs(getgenv().Qyrix_Loaded.ValuesDMGHit) do
    --         if tonumber(debug.getconstant(v[1], i)) == 0.13 then
    --             debug.setconstant(v[1], i, 0)
    --         end
    --     end
    --     -- CombatController.Attack = FastAttack_Func
    -- else
    --     for i,v in pairs(getgenv().Qyrix_Loaded.ValuesHit) do
    --         debug.setupvalue(v[1], i, v[2])
    --     end

    --     for i,v in pairs(getgenv().Qyrix_Loaded.ValuesDMGHit) do
    --         debug.setconstant(v[1], i, v[2])
    --     end
    --     -- CombatController.Attack = getgenv().Qyrix_Loaded.FastAttack_original
    -- end
end)

AutoFarm:Toggle("Stop Camera Shake", false, function(t)
    if t then
        CamShake:Stop()
    else
        CamShake:Start()
    end
end)

AutoFarm:Toggle("Bring Mobs", false, function(t)
    BringMobs = t
end)

AutoFarm:Slider("Bring Mobs Radius", 0, 400, 50, function(t)
    BringMobsRadius = t
end)

local Allow_Attack = false

function BringMobs_F(Enabled, Radius, Enemy)
    if Enabled then
        local success, err = pcall(function()
            for i,v in pairs(workspace.Enemies:GetChildren()) do
                local BringMobsDistance = (Enemy.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                local BringMobsSpeed = 300
                if BringMobsDistance <= Radius then -- isnetworkowner(v.PrimaryPart)
                    TweenService:Create(
                        v.HumanoidRootPart,
                        TweenInfo.new(BringMobsDistance/BringMobsSpeed, Enum.EasingStyle.Linear),
                        {CFrame = Enemy.HumanoidRootPart.CFrame}
                    ):Play()
                    v.HumanoidRootPart.CanCollide = false
                end
            end
            sethiddenproperty(game.Players.LocalPlayer,"MaximumSimulationRadius",math.huge)
            sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
        end)
        if not success then
            warn("BringMobs - ", err)
        end
    end
end

function GetLevel()
    local FakeLevel = 0
    if Level.Value >= 675 and game.PlaceId == 2753915549 then
        FakeLevel = 675
	elseif Level.Value >= 1450 and game.PlaceId == 4442272183 then
		FakeLevel = 1450
	elseif Level.Value >= 2700 and game.PlaceId == 7449423635 then
		FakeLevel = Level.Value
	else
        FakeLevel = Level.Value
    end
    return FakeLevel
end

task.spawn(function()
    while task.wait() do
        if Autofarm then
            local success, err = pcall(function()
                -- print("New Enemy!")
                local FakeLevel = GetLevel()
				local UpdatedQuest = GetQuestPlace(FakeLevel)
                local Quest = GetQuestData(FakeLevel)
				-- print("------------------------")
				-- table.foreach(Quest, print)
				-- print("- UpdatedQuest -")
				-- table.foreach(UpdatedQuest, print)

                for i,v in pairs(workspace.Enemies:GetChildren()) do
                    if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                        Allow_Attack = false
                        local Distance = (UpdatedQuest.NPCHRP.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        local Speed = 300
                        if Distance <= 900 then
                            Speed = 9e9
                        else
                            Speed = 300
                        end
                        local Tween_ = TweenService:Create(
                            game.Players.LocalPlayer.Character.HumanoidRootPart,
                            TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),
                            {CFrame = UpdatedQuest.NPCHRP.CFrame}
                        )
                        
                        repeat task.wait() 
                            Tween_:Play()
                            task.wait(Distance/Speed)
                            Remotes.CommF_:InvokeServer("StartQuest", Quest.QuestName, Quest.QuestIndex)
                        until not Autofarm or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible
                        
                    elseif not workspace.Enemies:FindFirstChild(GetQuestData(GetLevel()).QuestData.Name) and game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
                        Allow_Attack = false
                        local FortBuilderReplicatedSpawnPositionsFolder = game:GetService("ReplicatedStorage").FortBuilderReplicatedSpawnPositionsFolder
                        if FortBuilderReplicatedSpawnPositionsFolder:FindFirstChild(Quest.QuestData.Name) then
                            
                            repeat task.wait()
                                local Distance = (FortBuilderReplicatedSpawnPositionsFolder[Quest.QuestData.Name].Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude 
                                local Speed = 300
                                if Distance <= 900 then
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = FortBuilderReplicatedSpawnPositionsFolder[Quest.QuestData.Name].CFrame * CFrame.new(0, -30, 0)
                                else
                                    local Tween_ = TweenService:Create(
                                        game.Players.LocalPlayer.Character.HumanoidRootPart,
                                        TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),
                                        {CFrame = FortBuilderReplicatedSpawnPositionsFolder[Quest.QuestData.Name].CFrame * CFrame.new(0, -30, 0)}
                                    )
                                    Tween_:Play()
                                    task.wait(Distance/Speed)
                                end
                            until not Autofarm or workspace.Enemies:FindFirstChild(Quest.QuestData.Name) or not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible

                        else

                            repeat task.wait()
                                local Distance = (UpdatedQuest.Island.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude 
                                local Speed = 300
                                if Distance <= 900 then
                                    Speed = 9e9
                                else
                                    Speed = 300
                                end
                                local Tween_ = TweenService:Create(
                                    game.Players.LocalPlayer.Character.HumanoidRootPart,
                                    TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),
                                    {CFrame = UpdatedQuest.Island.CFrame * CFrame.new(0,-30,0)}
                                )
                                Tween_:Play()
                                task.wait(Distance/Speed)
                            until not Autofarm or workspace.Enemies:FindFirstChild(Quest.QuestData.Name) or not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible
                        end
                    else
                            local WentAllAround = false
                            local Enemy = v
                            if Enemy and Enemy.Name == Quest.QuestData.Name and IsAlive(Enemy) and Enemy:FindFirstChild("HumanoidRootPart") then
                                if not WentAllAround then
                                    for i,v in pairs(workspace.Enemies:GetChildren()) do
                                        if v.Name == Quest.QuestData.Name and IsAlive(v) and v:FindFirstChild("HumanoidRootPart") then
                                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(Distance_X, Distance_Y, Distance_Z)
                                            task.wait(0.1)
                                        end
                                    end
                                    WentAllAround = true
                                end
                                repeat task.wait()
                                    Allow_Attack = true
                                    EquipWeapon(Selected_Weapon)
                                    local Distance = (Enemy.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                                    local Speed = 300
                                    if Distance <= 900 then
                                        Speed = 9e9
                                        -- Enemy.HumanoidRootPart.Anchored = true
                                        Enemy.Humanoid.WalkSpeed = 0
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(Distance_X, Distance_Y, Distance_Z)
                                        task.spawn(BringMobs_F, BringMobs, BringMobsRadius, Enemy)
                                    else
                                        Speed = 300
                                        local Tween_ = TweenService:Create(
                                            game.Players.LocalPlayer.Character.HumanoidRootPart,
                                            TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),
                                            {CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(Distance_X, Distance_Y, Distance_Z)}
                                        )
                                        Tween_:Play()
                                        task.wait(Distance/Speed)
                                        task.spawn(BringMobs_F, BringMobs, BringMobsRadius, Enemy)
                                        
                                    end
                                until not Autofarm or not IsAlive(Enemy) or not Enemy:FindFirstChild("HumanoidRootPart") or not Enemy:FindFirstChild("Humanoid") or not workspace.Enemies:FindFirstChild(Quest.QuestData.Name)
                                WentAllAround = false
                            end
                        end
                    end
            end)
            if not success then
                warn("Autofarm - ", err)
            end
        end
    end
end)

AutoFarm:line()

AutoFarm:Toggle("Hitbox Expander", false, function(t)
    getgenv().Qyrix_Loaded.HitboxExpander = t
end)

AutoFarm:Slider("Hitbox Size", 0, 20, 5, function(t)
    getgenv().Qyrix_Loaded.HitboxMultiplier = t
end)

if not getgenv().Qyrix_Loaded.HitboxAlreadyFound then
    getgenv().Qyrix_Loaded.HitboxAlreadyFound = true

    local old
    old = hookmetamethod(game, "__namecall", newcclosure(function(self,...)
        local method = getnamecallmethod()
        local args = {...}

        if method == "GetPartBoundsInBox" and self == workspace then
            -- print(args[2])
            args[2] = getgenv().Qyrix_Loaded.HitboxExpander and args[2] * getgenv().Qyrix_Loaded.HitboxMultiplier or args[2] * 1
            return old(self, unpack(args))
        end

        return old(self,...)
    end))
end

task.spawn(function()
    while task.wait() do
        if Autofarm and Allow_Attack then
            local success, err = pcall(function()
                FastAttack_Func:Attack(getgenv().Qyrix_Loaded.HitboxExpander and getgenv().Qyrix_Loaded.HitboxMultiplier * 10 or 100)
                -- task.wait()
            end)
            if not success then
                warn("Auto Attack - ", err)
            end
        end
    end
end)

Misc:Toggle("Infinite Energy", false, function(t)
    Inf_Energy = t
end)

Misc:Toggle("No Dodge Cooldown", false, function(t)
    getgenv().Qyrix_Loaded.Dodge_Cooldown = t
end)

local Energy = game.Players.LocalPlayer.Character.Energy
local OldEnergyValue = Energy.Value
spawn(function()
    while task.wait() do
        if Inf_Energy then
            local success, err = pcall(function()
                Energy.Value = OldEnergyValue
            end)
            if not success then
                warn("Energy - ", err)
            end
        end
    end
end)

if not getgenv().Qyrix_Loaded.NoDGCD then
    getgenv().Qyrix_Loaded.NoDGCD = true
    for i,v in pairs(getgc()) do
        if game.Players.LocalPlayer.Character.Dodge then
            if typeof(v) == "function" and getfenv(v).script == game.Players.LocalPlayer.Character.Dodge then
                for i2,v2 in pairs(debug.getupvalues(v)) do
                    if tostring(v2) == "0.4" then
                        while getgenv().Qyrix_Loaded.Dodge_Cooldown == true do
                            task.wait(0.1)
                            debug.setupvalue(v, i2, 0)
                        end
                    end
                end
            end
        end
    end
end




