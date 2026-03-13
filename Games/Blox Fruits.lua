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
    local level = lvl -- your level
	
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
    local level = lvl --player.Data.Level.Value -- change if your level path is different

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


local v1 = game:GetService("UserInputService")
local v2 = game:GetService("ReplicatedStorage")
local v3 = game:GetService("RunService")
local v4 = require(v2.Modules.Net)
local v5 = require(v2.Modules.CombatUtil)
require(v2.Modules.WeaponData)
local v6 = require(v2.Util.CameraShaker.Main)
local v7 = require(v2.Util.CameraShaker)
local v8 = require(v2.Modules.PlayAnimationSequence)
local v9 = require(game.ReplicatedStorage.Controllers.UI.MobileUIController)
local v10 = require(game.ReplicatedStorage.Controllers.UI.CustomCursor)
local v11 = require(game.ReplicatedStorage.Modules.LastInput)
local v12 = require(v2.Modules.Util.Trove)
require(v2.Modules.Flags)
local v13 = game.Players.LocalPlayer
local v14 = workspace.CurrentCamera
local v15 = v13:GetMouse()
v5:GetComboPaddingTime()
v5:GetHitDetectionParams()
local v16 = v5:GetAttackCancelMultiplier()
local v18 = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
local v22 = false

local v28 = nil
local v33 = 0
local v34 = 0

local Test = debug.getupvalues(CombatController.Equip)
local v20 = Test[18]
local v21 = 0

function v43(p42)
	v5:AttackStart(p42, v21)
end

local function v57(p56)
	v5:RunHitDetection(p56, v21, v28)
end

local UniTime = 0.05
function attackMelee(p131)
	local v132 = v18
	if v132 then
		v132 = v18.RootPart
	end
	if v132 then
		v132 = v132.Parent
	end
	if v31 or _G.mobileSelectionFrame then
		return
	else
		local v133 = v5:GetMovesetAnimCache(v18)
		if v133 then
			local v134 = v5:GetWeaponName(p131)
			local v135 = v5:GetWeaponData(v134)
			local v136 = v135.WeaponType
			local v137 = v135.Moveset
			if true then -- v132:CanAttack(v13.Character, v153)
				task.defer(function()
					v5:GetWeaponName(p131)
					local v138 = p131.LocalEquippedWeaponPointer.Value
					local v139 = v138 and v20[v138]
					if v139 then
						v139:cancel()
						v20[v138] = nil
					end
				end)
				if v22 and v28 then
					v28:Stop()
				end
				v22 = true
				v33 = 0
				v34 = os.clock()
				v21 = v21 + 1
				if v21 > #v137.Basic then
					v21 = 1
				end
				local v140 = v133[v5:GetPureWeaponName(v134) .. "-basic" .. v21]
				v4:RemoteEvent("RegisterAttack"):FireServer(v140.Length / (v140:GetAttribute("SpeedMult") or 1)) -- v140.Length / (v140:GetAttribute("SpeedMult") or 1)
				local v141 = p131 and p131.Parent and (p131.Parent:GetAttribute("AttackSpeedMultiplier") or 1) or 1
				-- v140:Play(0.05, 1, 0.4 * (v140:GetAttribute("SpeedMult") or 1) * v141) -- 1 * (v140:GetAttribute("SpeedMult") or 1) * v141
                v140:Play(UniTime+0.02, 1, 1 * (v140:GetAttribute("SpeedMult") or 1) * v141) -- 1 * (v140:GetAttribute("SpeedMult") or 1) * v141
                task.delay(UniTime+0.01, function() -- v140.Length / (v140:GetAttribute("SpeedMult") or 1) * v16 / v141
					v140:Stop()
				end)
				v31 = true
				task.delay(UniTime, function() -- v140.Length / (v140:GetAttribute("SpeedMult") or 1) * v16 / v141
					v31 = false
				end)
				v28 = v140
				pcall(function()
					task.spawn(v43, p131, v21)
				end)
				task.spawn(v57, p131, v135)
				-- v7:Shake(v6.Presets.CombatBump)
				local v142 = false
				local function v145()
					if not v142 then
						v142 = true
						local v143 = p131.LocalEquippedWeaponPointer.Value
						if v143 then
							for _, v144 in v143:GetDescendants() do
								if v144:IsA("Trail") then
									v144.Enabled = false
								end
							end
						end
					end
				end
				local v146 = v21
				local v147 = true
				local v148 = nil
				v148 = p131.AncestryChanged:Connect(function()
					v148:Disconnect()
					v148 = nil
					v147 = false
				end)
				task.delay(UniTime, function()
					if v147 and v21 == v146 then
						v145()
						v28 = nil
						v22 = false
						v21 = 0
						if v148 and v148.Connected then
							v148:Disconnect()
							v148 = nil
						end
					end
				end)
				if v21 == #v137.Basic then
					task.delay(UniTime, function() -- v140.Length / (v140:GetAttribute("SpeedMult") or 1) * 0.7
						if v21 == v146 then
							v145()
						end
					end)
				end
			end
		else
			return
		end
	end
end

function FastAttack_Func (_, p149, p150, _)
	pcall(function()
		local v151 = v5:GetWeaponName(p149)
		local v152 = v5:GetWeaponData(v151)
		local v153 = v152.WeaponType
		local v154 = (v153 == "Sword" or v153 == "Melee") and true or v153 == "Demon Fruit"
		local v155 = v153 == "Gun"
		-- if not v5:CanAttack(v13.Character, v153) then
		-- 	return
		-- end
		if v154 then
			attackMelee(p149)
			return
		end
		if v155 then
			if v5:IsGunReloading(p149) or _G.mobileSelection then
				return
			end
			if v152.ShootStyle == "Gatling" then
				local v156 = v152.OverheatLimit
				if v156 <= p149:GetAttribute("LocalOverheat") then
					return
				end
				if p149:GetAttribute("IsAutoShooting") then
					return
				end
				local v157 = false
				local v158 = true
				local v159 = v12.new()
				local function v165()
					if p149.Parent == v13.Character then
						local v160 = v5:GetLoadedAnimsFor(v151, v18)
						v64(v160, "OffensiveIdle")
						v78(p149, v160)
					end
					while true do
						local v161 = task.wait()
						local v162 = p149:GetAttribute("LocalOverheat")
						if not p149.Parent or (v162 <= 0 or p149:GetAttribute("IsAutoShooting")) then
							-- break
							return
						end
						local v163 = p149
						local v164 = v162 - v161
						v163:SetAttribute("LocalOverheat", (math.max(v164, 0)))
					end
				end
				local function v171()
					p149.Enabled = false
					p149:SetAttribute("IsReloading_Client", true)
					local v166 = v152.OverheatCooldown
					local v167 = table.clone(v152.ReloadReticle)
					v167.ReloadTime = v152.OverheatCooldown
					v10:PlayReloadAnimation(v167)
					task.delay(v166, function()
						p149.Enabled = true
						p149:SetAttribute("IsReloading_Client", nil)
					end)
					local v168 = v18
					if v168 then
						v168 = v18.RootPart
					end
					local v169 = v168 and p149.LocalEquippedWeaponPointer.Value
					local v170 = v169 and (v169:FindFirstChild(v169:GetAttribute("CurrentShootAttachment") or "ShootAttachment", true) or v169:FindFirstChild("ShootAttachment1", true))
					if v170 then
						v24.new("Gun_M1.RequestM1"):play({
							["Type"] = "Dragonstorm",
							["OverheatTime"] = v166,
							["origin"] = v168.Position,
							["HRP"] = v168,
							["ShootAttachment"] = v170.Name
						})
					end
				end
				v159:Add(p150:GetPropertyChangedSignal("UserInputState"):Connect(function()
					if p150.UserInputState == Enum.UserInputState.End then
						v158 = false
					end
				end))
				v159:Add(p149.AncestryChanged:Connect(function()
					v157 = true
				end))
				local v172 = nil
				v172 = task.spawn(function()
					while task.wait() do
						if not v5:CanAttack(v13.Character, v153) then
							v157 = true
							-- break
							return
						end
					end
					v172 = nil
				end)
				v159:Add(function()
					if v172 then
						task.cancel(v172)
						v172 = nil
					end
				end)
				v159:Add(function()
					p149:SetAttribute("IsAutoShooting", nil)
					task.spawn(v165)
				end)
				local v173 = v152.Cooldown / (p149 and p149.Parent and (p149.Parent:GetAttribute("AttackSpeedMultiplier") or 1) or 1)
				task.defer(function()
					repeat
						task.wait()
					until p149:GetAttribute("IsAutoShooting")
					local _ = v152.BaseCursorRotationSpeed
					while p149:GetAttribute("IsAutoShooting") do
						local v174 = game.TweenService:GetValue(p149:GetAttribute("LocalOverheat") / v156, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
						local v175 = v152.BaseCursorRotationSpeed
						v10:StepRotate(v175 + (0 - v175) * v174)
						task.wait()
					end
					v10:ResetRotate()
				end)
				local v176 = v158
				local v177 = v157
				local v178 = false
				for _ = 1, 3 do
					v130(p149, p150)
					p149:SetAttribute("IsAutoShooting", true)
					local v179 = task.wait(v173)
					local v180 = p149:GetAttribute("LocalOverheat") + v179
					p149:SetAttribute("LocalOverheat", (math.min(v180, v156)))
					if v156 <= v180 then
						v178 = true
						-- break
						return
					end
					if v177 then
						-- break
						return
					end
				end
				task.spawn(function()
					if v178 or (v177 or not v176) then
						v159:Destroy()
						if v178 then
							v171()
						end
						return
					else
						local v181 = os.clock() - (v173 + 0.00001)
						local v182 = 0
						while true do
							local v183 = p149:GetAttribute("LocalOverheat")
							local v184 = v156 <= v183
							if v184 or (v177 or not v176) then
								-- break
								return
							end
							local v185 = os.clock() - v181
							if v173 < v185 then
								local v186 = p149
								local v187 = v183 + v185
								local v188 = v156
								v186:SetAttribute("LocalOverheat", (math.min(v187, v188)))
								local v189 = v182 + v185
								local v190 = v189 / v173
								local v191 = math.floor(v190)
								v182 = v189 % v173
								v181 = os.clock()
								p149:SetAttribute("IsAutoShooting", true)
								for _ = 1, v191 do
									v130(p149, p150)
								end
							end
							task.wait()
						end
						v159:Destroy()
						if v184 then
							v171()
						end
					end
				end)
				return
			end
			v130(p149, p150)
		end
	end)
end


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
