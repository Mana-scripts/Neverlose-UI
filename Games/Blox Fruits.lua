local UtilityModule = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Mana-scripts/Neverlose-UI/refs/heads/main/Utility.lua"))()

UtilityModule:Discord("7wZ7vEgWXR")

local Library = UtilityModule.Library()

local Window = Library:Window(
    UtilityModule.HubName,
    "Blox Fruits",
    UtilityModule.Loader
)

local AutoFarm = Window:Tab("Autofarm")

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Replica = game:GetService("ReplicatedStorage")
local Remotes = Replica:WaitForChild("Remotes")
local FakeLevel, Level = 0, game:GetService("Players").LocalPlayer.Data.Level

local Quests = require(game:GetService("ReplicatedStorage").Quests)
local QuestController = require(game:GetService("ReplicatedStorage").Controllers.QuestController)
local CombatController = require(game.ReplicatedStorage.Controllers.CombatController)
local CombatUtil = require(game:GetService("ReplicatedStorage").Modules.CombatUtil)

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
    local level = lvl --player.Data.Level.Value

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


local FastAttack_Func = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Mana-scripts/Neverlose-UI/refs/heads/main/Games/BloxFruitModules/FastAttack.lua"))()


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

function ToggleHitDelay(state)
    HitDelayEnabled = state

    for index,orig in pairs(originalConstants) do
        if HitDelayEnabled then
            debug.setconstant(CombatUtil.RunHitDetection, index, 0.005)
        else
            debug.setconstant(CombatUtil.RunHitDetection, index, orig)
        end
    end

    if HitDelayEnabled then
        if not aoeHook then
            aoeHook = hookfunction(CombatUtil.GetDefaultAOEDelay,function(...)
                return 0.005
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

sethiddenproperty(game.Players.LocalPlayer,"MaximumSimulationRadius",math.huge)
sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)

function Attack()
    local player = Players.LocalPlayer

    local tool = player.Character:FindFirstChildOfClass("Tool")

    local input = {
        UserInputType = Enum.UserInputType.MouseButton1,
        UserInputState = Enum.UserInputState.Begin
    }

    CombatController:Attack(tool, input)
end

AutoFarm:Toggle("Autofarm", false, function(t)
    Autofarm = t
end)

AutoFarm:Toggle("Fast Attack [BETA]", false, function(t)
    FastAttack = t
	ToggleHitDelay(FastAttack)
    if FastAttack then
        CombatController.Attack = FastAttack_Func
    else
        CombatController.Attack = getgenv().FastAttack_original
    end
end)

spawn(function()
    while task.wait() do
        if Autofarm then
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

spawn(function()
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
				print("------------------------")
				table.foreach(Quest, print)
				print("- UpdatedQuest -")
				table.foreach(UpdatedQuest, print)
                if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
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

					print("Done")
					
                elseif not workspace.Enemies:FindFirstChild(Quest.QuestData.Name) and game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
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
								{CFrame = FortBuilderReplicatedSpawnPositionsFolder[Quest.QuestData.Name].CFrame}
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

					print("Found Enemy!")

                else
                    for i,v in pairs(workspace.Enemies:GetChildren()) do
                        local Enemy = v
                        if Enemy and Enemy.Name == Quest.QuestData.Name and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 and Enemy:FindFirstChild("HumanoidRootPart") then
							
							repeat task.wait()
								local Distance = (Enemy.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
								local Speed = 300
								if Distance <= 900 then
									Speed = 9e9
								else
									Speed = 300
								end
								local Tween_ = TweenService:Create(
									game.Players.LocalPlayer.Character.HumanoidRootPart,
									TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),
									{CFrame = Enemy.HumanoidRootPart.CFrame}
								)
								Tween_:Play()
								task.wait(Distance/Speed)
                                -- task.spawn(function()
                                --     Attack()
                                --     task.wait()
                                -- end)
                            until not Autofarm or Enemy.Humanoid.Health <= 0 or not Enemy:FindFirstChild("HumanoidRootPart") or not Enemy:FindFirstChild("Humanoid") or not workspace.Enemies:FindFirstChild(Quest.QuestData.Name)
							print("Enemy Dead!")
						end
                    end
                end



                -- table.foreach(UpdatedQuest, print)
            end)
            if not success then
                warn("Autofarm - ", err)
            end
        end
    end
end)
