

local UtilityModule = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Mana-scripts/Neverlose-UI/refs/heads/main/Utility.lua"))()

UtilityModule:Discord("7wZ7vEgWXR")

local Library = UtilityModule.Library()

local Window = Library:Window(
    UtilityModule.HubName,
    "Blox Fruits",
    UtilityModule.Loader
)

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

if not getgenv().FastAttack_original then
    getgenv().FastAttack_original = CombatController.Attack
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
end

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


if not getgenv().FastDMGHitFuncTest then
	getgenv().ValuesDMGHit = {}
    getgenv().FastDMGHitFuncTest = true
    print("-------------------")
	for i,v in pairs(getgc()) do
		if typeof(v) == "function" and getfenv(v).script == game:GetService("ReplicatedStorage").Modules.CombatUtil then
			for i2,v2 in pairs(debug.getconstants(v)) do
				if type(v2) == "number" then
					getgenv().ValuesDMGHit[i2] = {v, v2}
				end
			end
		end
	end
end

if not getgenv().FastHitFuncTest then
	getgenv().ValuesHit = {}
    getgenv().FastHitFuncTest = true
    print("-------------------")
    for i,v in pairs(getgc()) do
        if typeof(v) == "function" and getfenv(v).script == game.ReplicatedStorage.Controllers.CombatController then
            for i2,v2 in pairs(debug.getupvalues(v)) do
                if type(v2) == "number" then
                    getgenv().ValuesHit[i2] = {v, v2}
                end
            end
        end
    end
end

AutoFarm:Toggle("Fast Attack", false, function(t)
    FastAttack = t
	-- ToggleHitDelay(FastAttack)
    if FastAttack then
        for i,v in pairs(getgenv().ValuesHit) do
            if tonumber(debug.getupvalue(v[1], i)) == 0.8 then
                print(i,v)
                debug.setupvalue(v[1], i, 0.05)
            end
        end

        for i,v in pairs(getgenv().ValuesDMGHit) do
            if tonumber(debug.getconstant(v[1], i)) == 0.13 then
                debug.setconstant(v[1], i, 0)
            end
        end
        -- CombatController.Attack = FastAttack_Func
    else
        for i,v in pairs(getgenv().ValuesHit) do
            debug.setupvalue(v[1], i, v[2])
        end

        for i,v in pairs(getgenv().ValuesDMGHit) do
            debug.setconstant(v[1], i, v[2])
        end
        -- CombatController.Attack = getgenv().FastAttack_original
    end
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
task.spawn(function()
    while task.wait() do
        if Autofarm and Allow_Attack then
            local success, err = pcall(function()
                Attack()
                task.wait()
            end)
            if not success then
                warn("Auto Attack - ", err)
            end
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if Autofarm then
            local success, err = pcall(function()
                -- print("New Enemy!")
                if Level.Value >= 675 and game.PlaceId == 2753915549 then
                    FakeLevel = 675
				elseif Level.Value >= 1450 and game.PlaceId == 4442272183 then
					FakeLevel = 1450
				elseif Level.Value >= 2700 and game.PlaceId == 7449423635 then
					FakeLevel = Level.Value
				else
                    FakeLevel = Level.Value
                end

				local UpdatedQuest = GetQuestPlace(FakeLevel)
                local Quest = GetQuestData(FakeLevel)
				-- print("------------------------")
				-- table.foreach(Quest, print)
				-- print("- UpdatedQuest -")
				-- table.foreach(UpdatedQuest, print)

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

					
                elseif not workspace.Enemies:FindFirstChild(Quest.QuestData.Name) and game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
                    Allow_Attack = false
					local FortBuilderReplicatedSpawnPositionsFolder = game:GetService("ReplicatedStorage").FortBuilderReplicatedSpawnPositionsFolder
					if FortBuilderReplicatedSpawnPositionsFolder:FindFirstChild(Quest.QuestData.Name) then

						repeat task.wait()
							local Distance = (FortBuilderReplicatedSpawnPositionsFolder[Quest.QuestData.Name].Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude 
							local Speed = 300
							if Distance <= 900 then
								Speed = 9e9
							else
								Speed = 300
							end
							local Tween_ = TweenService:Create(
								game.Players.LocalPlayer.Character.HumanoidRootPart,
								TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),
								{CFrame = FortBuilderReplicatedSpawnPositionsFolder[Quest.QuestData.Name].CFrame * CFrame.new(0, -10, 0)}
							)
							Tween_:Play()
							task.wait(Distance/Speed)
						until not Autofarm or workspace.Enemies:FindFirstChild(Quest.QuestData.Name)

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
								{CFrame = UpdatedQuest.Island.CFrame * CFrame.new(0,30,0)}
							)
							Tween_:Play()
							task.wait(Distance/Speed)
						until not Autofarm or workspace.Enemies:FindFirstChild(Quest.QuestData.Name)
					end
                else
                    for i,v in pairs(workspace.Enemies:GetChildren()) do
                        local Enemy = v
                        if Enemy and Enemy.Name == Quest.QuestData.Name and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 and Enemy:FindFirstChild("HumanoidRootPart") then
							
							repeat task.wait()
                                Allow_Attack = true
								local Distance = (Enemy.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
								local Speed = 300
								if Distance <= 900 then
									Speed = 9e9
									Enemy.HumanoidRootPart.Anchored = true
									game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(Distance_X, Distance_Y, Distance_Z)
                                    task.spawn(function()
                                        if BringMobs then
                                            local success, err = pcall(function()
                                                for i,v in pairs(workspace.Enemies:GetChildren()) do
                                                    local BringMobsDistance = (Enemy.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                                                    local BringMobsSpeed = 300
                                                    if BringMobsDistance <= BringMobsRadius then -- isnetworkowner(v.PrimaryPart)
                                                        TweenService:Create(
                                                            v.HumanoidRootPart,
                                                            TweenInfo.new(BringMobsDistance/BringMobsSpeed, Enum.EasingStyle.Linear),
                                                            {CFrame = Enemy.HumanoidRootPart.CFrame}
                                                        ):Play()
                                                        v.HumanoidRootPart.CanCollide = false
                                                    end
                                                end
                                            end)
                                            if not success then
                                                warn("BringMobs - ", err)
                                            end
                                        end
                                    end)

                                    sethiddenproperty(game.Players.LocalPlayer,"MaximumSimulationRadius",math.huge)
                                    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
								else
									Speed = 300
									local Tween_ = TweenService:Create(
										game.Players.LocalPlayer.Character.HumanoidRootPart,
										TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),
										{CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(Distance_X, Distance_Y, Distance_Z)}
									)
									Tween_:Play()
									task.wait(Distance/Speed)
								end
                            until not Autofarm or Enemy.Humanoid.Health <= 0 or not Enemy:FindFirstChild("HumanoidRootPart") or not Enemy:FindFirstChild("Humanoid") or not workspace.Enemies:FindFirstChild(Quest.QuestData.Name)
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

-- spawn(function()
--     while task.wait() do
--         if BringMobs then
--             local success, err = pcall(function()
--                 if Autofarm then
--                     for i,v in pairs(game.Workspace.Enemies:GetChildren()) do

--                     end
--                 end
--             end)
--             if not success then
--                 warn("BringMobs - ", err)
--             end
--         end
--     end
-- end)

AutoFarm:line()

AutoFarm:Toggle("Hitbox Expander", false, function(t)
    getgenv().HitboxExpander = t
end)

AutoFarm:Slider("Hitbox Size", 0, 20, 5, function(t)
    getgenv().HitboxMultiplier = t
end)

if not getgenv().HitboxAlreadyFound then
    getgenv().HitboxAlreadyFound = true

    local old
    old = hookmetamethod(game, "__namecall", newcclosure(function(self,...)
        local method = getnamecallmethod()
        local args = {...}

        if getgenv().HitboxExpander and method == "GetPartBoundsInBox" and self == workspace then
            -- print(args[2])
            args[2] = args[2] * getgenv().HitboxMultiplier
            return old(self, unpack(args))
        end

        return old(self,...)
    end))
end

function GetGarbage()
    print("Collected")
    local GC = {}
    for i,v in pairs(getgc(true)) do
        table.insert(GC, v)
    end
    return GC
end

if not getgenv().GarbageCollector then
    getgenv().GarbageCollector = GetGarbage()
end

Misc:Toggle("Infinite Energy", false, function(t)
    Inf_Energy = t
end)

Misc:Toggle("No Dodge Cooldown", false, function(t)
    getgenv().Dodge_Cooldown = t
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

if not getgenv().NoDGCD then
    getgenv().NoDGCD = true
    for i,v in pairs(getgenv().GarbageCollector) do
        if game.Players.LocalPlayer.Character.Dodge then
            if typeof(v) == "function" and getfenv(v).script == game.Players.LocalPlayer.Character.Dodge then
                for i2,v2 in pairs(debug.getupvalues(v)) do
                    if tostring(v2) == "0.4" then
                        while task.wait(0.1) do
                            if not getgenv().Dodge_Cooldown then
                                continue
                            end
                            debug.setupvalue(v, i2, 0)
                        end
                    end
                end
            end
        end
    end
end




