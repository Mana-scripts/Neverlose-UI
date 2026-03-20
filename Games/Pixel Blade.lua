------------ // Pixel Blade \\ ------------

------------------------------------------------------------
--/////////////////////////GUI\\\\\\\\\\\\\\\\\\\\\\\\\\\\--
------------------------------------------------------------ 

local UtilityModule = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Mana-scripts/Neverlose-UI/refs/heads/main/Utility.lua"))()

UtilityModule:Discord("7wZ7vEgWXR")

local TweenService = game:GetService("TweenService")

local Library = UtilityModule.Library() --loadstring(game:HttpGetAsync("https://rawscripts.net/raw/Universal-Script-woof-gui-16777"))()

local Window = Library:Window(
    UtilityModule.HubName,
    "Pixel Blade",
    UtilityModule.Loader
)

local Combat = Window:Tab("Combat")
local Legit = Window:Tab("Legit")
local Quest = Window:Tab("Quest")
local Credits = Window:Tab("Credits")
local Config = Window:Tab("Config")
Library:ConfigTab(Config)

Credits:Button("Mana", function()
    UtilityModule:Discord("7wZ7vEgWXR")
end)

for i, v in pairs(workspace:GetChildren()) do
    if string.find(v.Name, "Rig") then
        v:Destroy()
    end
end

local questData = require(game:GetService("ReplicatedStorage").constants.questData)


function ClaimQuest(num, num2)
    game:GetService("ReplicatedStorage").remotes.dailyQuestEvent:FireServer("Claim", "Quest_"..num, num2)
    task.wait(0.1)
end

function ClaimAchievement(ID)
	game:GetService("ReplicatedStorage").remotes.dailyQuestEvent:FireServer("Claim", ID, true)
    task.wait(0.1)
end

Combat:Toggle("Kill Aura", false, function(t)
    KillAura = t
end)

local GlobalFailSafe = false

-- workspace.KoriBossFight.Crossbow1 | Just a test to see if its fucking with the game.
spawn(function()
    while task.wait() do
        if KillAura then
            pcall(function()
                if workspace.inCutscene.Value then return end
                for i, v in pairs(workspace:GetChildren()) do
                    if v ~= game.Players.LocalPlayer.Character and
                    v:FindFirstChild("Health")
                    and v.Health.Value > 0 and v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") and (v:GetPivot().Position - game.Players.LocalPlayer.Character:GetPivot().Position).magnitude < 30 then
                        if GlobalFailSafe then
                            -- repeat task.wait() until not GlobalFailSafe
                        else
                            if v.Name == "Akuma" and v:FindFirstChild("HealForceFieldFolder") and not v:FindFirstChild("HealForceFieldFolder"):FindFirstChildOfClass("Part") then
                                print("ForceField Up!")
                                game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("onHit"):FireServer(v.Humanoid, -math.huge, {}, 0)
                                return
                            end

                            game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("onHit"):FireServer(v.Humanoid, -math.huge, {}, 0)
                            print("Normal")
                            print(v.Name)
                            --end
                        end
                    end
                end
            end)
        end
    end
end)

Combat:line()


local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

function getClosestEnemy()
    local closestPart = nil
    local shortestDistance = math.huge
    for i, v in pairs(workspace:GetChildren()) do
        if v ~= player.Character and v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Health") and v.Health.Value ~= 0 then
            local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPart = v.HumanoidRootPart
            end
        end
    end

    return closestPart
end


function walkToPart(targetPart)
    if not targetPart then print("no targetpart found!") return end

    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        AgentJumpHeight = 10,
        AgentMaxSlope = 45,
    })

    path:ComputeAsync(rootPart.Position, targetPart.Position)
    local waypoints = path:GetWaypoints()

    for _, waypoint in ipairs(waypoints) do
        if waypoint.Action == Enum.PathWaypointAction.Jump then
            humanoid.Jump = true
        end
        humanoid:MoveTo(waypoint.Position)
        local reached = humanoid.MoveToFinished:Wait()
        if not reached then
            print("Cant reach the destination!")
            break
        end
    end
end

function TPToTarget(target, otherFrame)
    if not target then warn("no target found!") return end
    otherFrame = otherFrame or CFrame.new(0,0,-5)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.CFrame * otherFrame
end

function TweenToTarget(target)
    if not target then warn("no target found!") return end
    local Distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - target.Position).Magnitude
    local Speed = 100
    -- local Tween = TweenService:Create(
    --     game.Players.LocalPlayer.Character.HumanoidRootPart,
    --     TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),
    --     {CFrame = target.CFrame * CFrame.new(0,30,-5)}
    -- ):Play()

    return Distance, Speed
end


Combat:Dropdown("Farm Method", {"Legit (Not Working)", "Rage"}, function(t)
    FarmMethod = t
end)

Combat:Toggle("Autofarm", false, function(t)
    Autofarm = t
end)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer

function KeepAwayFromAkuma()
    local Akuma = workspace:FindFirstChild("Akuma")
    local Character = Player.Character
    if not Akuma or not Character then return end

    local AkumaHumanoidRootPart = Akuma:FindFirstChild("HumanoidRootPart")
    local ChHumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if not AkumaHumanoidRootPart or not ChHumanoidRootPart then return end
    
    local dist = (ChHumanoidRootPart.Position - AkumaHumanoidRootPart.Position).Magnitude

    if dist < 15 then
        print("Too Close!")
        local dir = (ChHumanoidRootPart.Position - AkumaHumanoidRootPart.Position)
        if dir.Magnitude == 0 then
            dir = Vector3.new(0,0,1)
        end

        dir = dir.Unit
        local safePos = AkumaHumanoidRootPart.Position + dir * 15

        ChHumanoidRootPart.CFrame = CFrame.new(safePos.X, ChHumanoidRootPart.Position.Y, safePos.Z)
    end
end
-- workspace.Nekros.entrance
function CheckBoss()
    for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.gameUI.Enemy:GetChildren()) do
        if v:IsA("Frame") and v.Name ~= "Healthbar" and v.Visible then
            return true, v.Name
        end
    end
    return false, nil
end

function CheckBoss2()
    for i,v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("entrance") then
            return true, v
        end
    end
    return false, nil
end

local EnemyNotAlive, FailSafe = true, false

local lastEnemyTime = tick()
function FailSafeFunc(time) -- Default 5 sec
    time = time or 5
    if tick() - lastEnemyTime >= time then
        FailSafe = true -- "Activated"
    end
end

spawn(function()

    local Tween = nil
    local direction = 1
    local index = 1

    -- CrimsonAbyss

    while task.wait() do
        if not Autofarm then
            continue
        end

        if workspace.inCutscene.Value then continue end

        KeepAwayFromAkuma()

        local ClosestEnemy = math.huge
        local Enemy = nil

        -- Find closest enemy
        for _,v in pairs(workspace:GetChildren()) do
            if v ~= Player.Character
            and v:IsA("Model")
            and v:FindFirstChild("Health")
            and v.Health.Value > 0
            and v:FindFirstChild("HumanoidRootPart") then

                local dist = (Player.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude

                if dist < ClosestEnemy then
                    ClosestEnemy = dist
                    Enemy = v
                end
            else
                EnemyNotAlive = true
            end
        end
        
        if Enemy and not FailSafe then
            if EnemyNotAlive then
                -- print("Enemy Alive")
                lastEnemyTime = tick()
                EnemyNotAlive = false
                --FailSafe = false
            end
            
            pcall(function()
                if FarmMethod == "Rage" then
                    
                    repeat task.wait()
                        if GlobalFailSafe or FailSafe then
                            --TPToTarget(game.Players.LocalPlayer.Character.HumanoidRootPart, CFrame.new(0,30,0))
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart * CFrame.new(0,30,0)
                            repeat task.wait()
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart
                            until not Autofarm or not GlobalFailSafe or not FailSafe
                        else
                            FailSafeFunc(workspace.worldType.Value == "CrimsonAbyss" and 3 or 5) -- "Activated"
                            -- if Enemy.Name == "Akuma" and v:FindFirstChild("HealForceFieldFolder") and not v:FindFirstChild("HealForceFieldFolder"):FindFirstChildOfClass("Part") then
                            local IsBoss, Boss = CheckBoss2()
                            if IsBoss then
                                game:GetService("Players").LocalPlayer.PlayerGui.gameUI.Enemy.Healthbar.Visible = true
                                -- repeat task.wait() until not Autofarm or game:GetService("Players").LocalPlayer.PlayerGui.gameUI.Enemy.Healthbar.Visible
                            end
                            if workspace:FindFirstChild("Akuma") then
                                local IsBoss, Boss = CheckBoss2()
                                print("Wating 5 sec")
                                task.wait(IsBoss and 5 or 1)
                                print("Waited 5 sec")
                                print("Trying to Target Akumas subordinates")
                                for i,v in pairs(workspace:GetChildren()) do
                                    if v ~= Player.Character and v.Name ~= "Akuma"
                                    and v:IsA("Model")
                                    and v:FindFirstChild("Health")
                                    and v.Health.Value ~= 0
                                    and v:FindFirstChild("HumanoidRootPart") then
                                        repeat task.wait()
                                            TPToTarget(v.HumanoidRootPart, CFrame.new(0,7,0))
                                            FailSafeFunc(7)
                                        until not Autofarm or v.Health.Value == 0 or FailSafe
                                    end
                                end
                                if not workspace.Akuma:FindFirstChild("HealForceFieldFolder"):FindFirstChildOfClass("Part") then
                                    TPToTarget(workspace.Akuma.HumanoidRootPart, CFrame.new(0,0,10))
                                end

                            elseif workspace:FindFirstChild("InfestedBeast") then -- Bee Boss (can not be regular Enemies!)
                                TPToTarget(workspace:FindFirstChild("InfestedBeast").HumanoidRootPart, CFrame.new(0,0,10))

                                local IsBoss, Boss = CheckBoss2()
                                print("Wating 5 sec")
                                task.wait(IsBoss and 5 or 1)
                                print("Waited 5 sec")
                                repeat task.wait() until not Autofarm or FailSafe or game:GetService("Players").LocalPlayer.PlayerGui.gameUI.Enemy.Healthbar.Visible
                                repeat task.wait()
                                    TPToTarget(workspace:FindFirstChild("InfestedBeast").HumanoidRootPart, CFrame.new(0,0,10))
                                    FailSafeFunc(7)
                                until not Autofarm or FailSafe or not workspace:FindFirstChild("InfestedBeast") or not workspace:FindFirstChild("InfestedBeast"):FindFirstChild("HumanoidRootPart")
                            -- workspace.Maneater

                            
                            
                            elseif workspace:FindFirstChild("Atticus") then -- Bee Boss (can not be regular Enemies!)
                                TPToTarget(workspace.Vault.ClydeSpawn, CFrame.new(0,0,10))
                                local IsBoss, Boss = CheckBoss2()
                                print("Wating 5 sec")
                                task.wait(IsBoss and 5 or 1)
                                print("Waited 5 sec")
                                -- repeat task.wait() until not Autofarm or FailSafe or game:GetService("Players").LocalPlayer.PlayerGui.gameUI.Enemy.Healthbar.Visible
                                repeat task.wait()
                                    TPToTarget(workspace:FindFirstChild("Atticus").HumanoidRootPart, CFrame.new(0,0,10))
                                    FailSafeFunc(7)
                                until not Autofarm or FailSafe or not workspace:FindFirstChild("Atticus")


                            elseif workspace:FindFirstChild("ThroneRoom") and workspace:FindFirstChild("ThroneRoom"):FindFirstChild("TheDamned") then
                                -- workspace.ThroneRoom.BookHand
                                print("Wating 5 sec")
                                task.wait(IsBoss and 5 or 1)
                                print("Waited 5 sec")
                                if workspace.ThroneRoom.BookHand:FindFirstChild("basehitbox") and workspace.ThroneRoom.BookHand:FindFirstChild("Humanoid") then
                                    TPToTarget(workspace.ThroneRoom.BookHand.basehitbox, CFrame.new(0,0,10))
                                    for i,v in pairs(workspace.ThroneRoom:GetChildren()) do
                                        if v.Name == "BookHand" and v.Health.Value ~= 0 then
                                            game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("onHit"):FireServer(v.Humanoid, -math.huge, {}, 0)
                                        end
                                    end
                                end
                                
                                TPToTarget(Enemy.HumanoidRootPart, CFrame.new(0,0,25))
                            else
                                TPToTarget(Enemy.HumanoidRootPart, CFrame.new(0,math.random(0, 10),math.random(-15, 15)))
                            end
                        end
                    until not Autofarm or Enemy.Health.Value == 0 or FailSafe or not Enemy:FindFirstChild("HumanoidRootPart")
                    
                elseif FarmMethod == "Legit (Not Working)" then
                    walkToPart(Enemy.HumanoidRootPart)
                end
            end)
        else
                for _,v in pairs(workspace:GetDescendants()) do
                    if v:FindFirstChild("ExitZoneEnemyBarrier") and v:FindFirstChild("fightZone") then
                        if game:GetService("Players").LocalPlayer.PlayerGui.gameUI.HUD.stageMarker.stageUpdate.Visible or FailSafe then
                            TPToTarget(v.ExitZoneEnemyBarrier, CFrame.new(math.random(-30, 30),-1,math.random(-30, 30)))
                            task.wait(0.02)
                            TPToTarget(v.fightZone, CFrame.new(0,0,0))
                            task.wait(0.4)
                        else
                            TPToTarget(v.ExitZoneEnemyBarrier, CFrame.new(0,-1,0))
                            --task.wait(0.07)
                        end
                    end
                    if v:FindFirstChild("clydeStart") then -- Sand World Boss Start!
                        TPToTarget(v.clydeStart, CFrame.new(0,0,0))
                    end
                    if v:FindFirstChild("TheDamned") then -- workspace:FindFirstChild("ThroneRoom"):FindFirstChild("TheDamned")
                        TPToTarget(v.TheDamned, CFrame.new(0,0,0))
                    end
                end
                FailSafe = false -- "Deactivated"
                -- task.wait(0.4)
            -- end
        end
    end
end)

Combat:Toggle("Auto Collect Breakables", false, function(t)
    AutoCollectBreakables = t
end)

spawn(function()
    while task.wait() do
        if AutoCollectBreakables then
            pcall(function()
                for i,v in pairs(workspace:GetChildren()) do
                    if string.find(v.Name:lower(), "breakable") and (v:FindFirstChildOfClass("Part") or v:FindFirstChildOfClass("MeshPart")) then
                        game:GetService("ReplicatedStorage").remotes.onHit:FireServer(v.Humanoid,-math.huge,{},0)
                    end
                end
            end)
        end
    end
end)

Combat:line()

Combat:Toggle("Auto Upgrade", false, function(t)
    AutoUpgrade = t
end)

function disableUpgradePopUps(bool)
    if bool then
        game:GetService("Lighting").deathBlur.Size = 0
        game:GetService("Players").LocalPlayer.PlayerGui.gameUI.upgradeFrame.Position = UDim2.new(0, 0, -1.1, 0)
    end
end

spawn(function()
    while task.wait() do
        if AutoUpgrade then
            pcall(function()
                repeat task.wait() until not AutoUpgrade or not GlobalFailSafe or game:GetService("Players").LocalPlayer.PlayerGui.gameUI.upgradeFrame.Visible
                local Event = game:GetService("ReplicatedStorage").remotes.plrUpgrade
                Event:FireServer(
                    math.random(1,3)
                )
                --task.wait(0.3)
            end)
        end
    end
end)

spawn(function()
    while task.wait() do
        if AutoUpgrade then
            pcall(function()
                disableUpgradePopUps(true)
            end)
        end
    end
end)

Combat:Toggle("NoClip", false, function(t)
    NoClip = t
end)

function DestroyDoors()
    for i,v in pairs(workspace:GetDescendants()) do
        -- if v ~= game.Players.LocalPlayer.Character and v.ClassName == "Part" then
        --     v.CanCollide = false
        -- end
        if v.ClassName == "Part"  then
            v.CanCollide = false
        end
    end
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character

function setNoclip(state)
	if state then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	else
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
	end
end

spawn(function()
    while task.wait() do
        if NoClip then
            pcall(function()
                setNoclip(NoClip)
                task.wait(3)
            end)
        end
    end
end)

Legit:Toggle("Hitbox", false, function(t)
    HitBox = t
end)

Legit:Slider("Hitbox Size", 1, 50, 4, function(t)
    HitBoxSize = t
end)

Legit:Toggle("Show Hitbox", false, function(t)
    ShowHitBox = t
end)

spawn(function()
    while task.wait() do
        if HitBox then
            pcall(function()
                for i, v in pairs(workspace:GetChildren()) do
                    if v ~= game.Players.LocalPlayer.Character and v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        if v.Name == "Akuma" and v:FindFirstChild("basehitbox") and v:FindFirstChild("HealForceFieldFolder"):FindFirstChildOfClass("Part") then
                            v.basehitbox.Size = Autofarm and Vector3.new(0,0,0) or Vector3.new(4,4,4)
                            v.basehitbox.Transparency = ShowHitBox and 0.7 or 1
                        else
                            if v:FindFirstChild("basehitbox") then
                                v.basehitbox.Size = Vector3.new(HitBoxSize,HitBoxSize,HitBoxSize)
                                v.basehitbox.Transparency = ShowHitBox and 0.7 or 1
                            end
                        end
                    end
                end
            end)
        end
    end
end)


Quest:Toggle("Auto Claim Quests", false, function(t)
    AutoClaimQuests = t
end)

Quest:Toggle("Auto Claim Achievements", false, function(t)
    AutoClaimAchievements = t
end)

spawn(function()
    while task.wait() do
        if AutoClaimQuests then
            pcall(function()
                for i = 1,3 do
                    ClaimQuest(i, 1)
                    ClaimQuest(i, 2)
                    ClaimQuest(i, 3)
                end
            end)
        end
    end
end)

spawn(function()
    while task.wait() do
        if AutoClaimAchievements then
            pcall(function()
                for i,v in pairs(questData.Achievements) do
                    ClaimAchievement(v.id)
                end
            end)
        end
    end
end)


-- FAIL SAFE --

spawn(function()
    while task.wait() do
        if KillAura or Autofarm or AutoUpgrade then
            pcall(function()
                for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.gameUI.Enemy:GetChildren()) do
                    if v:IsA("Frame") and v.Name ~= "Healthbar" and v.Visible and game:GetService("Players").LocalPlayer.PlayerGui.gameUI.HUD.stageMarker.stageUpdate.Visible then
                        GlobalFailSafe = true
                        repeat task.wait() until not v.Visible or not game:GetService("Players").LocalPlayer.PlayerGui.gameUI.HUD.stageMarker.stageUpdate.Visible
                        GlobalFailSafe = false
                    end
                end
            end)
        end
    end
end)
