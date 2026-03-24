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
local Misc = Window:Tab("Misc")
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

function CheckBoss()
    local BossTable = {}
    for i,v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("entrance") and v.Name ~= "LocalManeater" then
            return true, v
        end
    end
    BossTable["Name"] = ""
    return false, BossTable["Name"]
end

Combat:Toggle("Kill Aura", false, function(t)
    KillAura = t
end)

-- local KillAuraDistance = 30
local Test = Combat:Slider("KillAura Distance", 1, 100, 30, function(t)
    KillAuraDistance = t
end)

Test:Set(30)

local GlobalFailSafe = false
local Boss_Wait_Done = false

-- workspace.KoriBossFight.Crossbow1 | Just a test to see if its fucking with the game.
spawn(function()
    while task.wait() do
        if KillAura then
            local success, err = pcall(function()
                if workspace.inCutscene.Value then return end
                for i, v in pairs(workspace:GetChildren()) do
                    if v ~= game.Players.LocalPlayer.Character and
                    v:FindFirstChild("Health")
                    and v.Health.Value ~= 0 and
                    v:IsA("Model") and v:FindFirstChild("Humanoid") and
                    v:FindFirstChild("HumanoidRootPart")
                    and v.Name ~= "LocalManeater" 
                    and v:GetAttribute("hadEntrance")
                    and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude < KillAuraDistance 
                    and not string.find(v.Name, "Shroom")then
                            local IsBoss, Boss = CheckBoss()
                            if v.Name == "Akuma" and v:FindFirstChild("HealForceFieldFolder") and v:FindFirstChild("HealForceFieldFolder"):FindFirstChildOfClass("Part") then
                                return
                            else
                                if IsBoss and not Boss_Wait_Done then
                                    print("KA Boss")
                                    task.wait(3)
                                    Boss_Wait_Done = true
                                    repeat task.wait(0.02)
                                        print(v.Name)
                                        game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("onHit"):FireServer(v.Humanoid, -math.huge, {}, 0)
                                    until not KillAura or not IsBoss
                                    Boss_Wait_Done = false
                                end
                                game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("onHit"):FireServer(v.Humanoid, -math.huge, {}, 0)
                            end
                    end
                end
            end)
            if not success then
                print("[+] KillAura - ", err)
            end
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


local BossTitles = {
    Akuma = "akumaTitle",
    Atticus = "atticusTitle",
    Gatekeeper = "gatekeeperTitle",
    Giantgoblin = "giantgoblinTitle",
    InfestedBeast = "infestedBeastTitle",
    Kingslayer = "kingslayerTitle",
    Kori = "koriTitle",
    Korth = "korthTitle",
    Lumberjack = "lumberjackTitle",
    Maneater = "maneaterTitle",
    QueenSlime = "queenSlimeTitle",
    Nekros = "nekrosTitle",
    ShimBombo = "shimBomboTitle",
}

local EnemyNotAlive, FailSafe = true, false

local lastEnemyTime = tick()
function FailSafeFunc(time, allow) -- Default 5 sec
    allow = allow or false
    if allow then return end
    -- print("Fired")
    time = time or 5
    if tick() - lastEnemyTime >= time then
        FailSafe = true -- "Activated"
    end
end
local AllowDespawnSpawn = false
spawn(function()
    while task.wait() do
        if AllowDespawnSpawn == false then
            pcall(function()
                task.wait(10)
                print("Spawn Destroyed!")
                workspace.Spawn:Destroy()
                AllowDespawnSpawn = nil
            end)
        end
    end
end)

-- cs:GetTagged("station") Important



--[[ 
    Pixel Blade Raid Defense Data
    workspace.RaidArena.UpgradeVoting.playerZone2

    local Event = game:GetService("ReplicatedStorage").remotes.openWish
    local Result = Event:InvokeServer()

    local ExpectedResult = table.unpack({
        {
            {
                "Vaulted",
                "Vaulted",
                "Vaulted",
                "Vaulted",
                "Vaulted"
            },
            "Shamshir",
            1
        }
    })


]] 

spawn(function()
    while task.wait() do
        if Autofarm then
            local success, err = pcall(function()
                if game.PlaceId == 133884972346775 then
                    if game:GetService("Players").LocalPlayer.PlayerGui.gameUI.HUD.startInfo.TextTransparency == 0 then
                        TPToTarget(workspace.RaidArena.CrystalTree.Root, CFrame.new(0,0,0))
                        return
                    elseif workspace.RaidArena.UpgradeVoting.inVotePhase.Value then
                        local Chosen = math.random(1,3)
                        repeat task.wait()
                            TPToTarget(workspace.RaidArena.UpgradeVoting["playerZone"..tostring(Chosen)], CFrame.new(0,0,0))
                        until not Autofarm or workspace.RaidArena.UpgradeVoting.inVotePhase.Value == false
                        return
                    end
                    local ClosestEnemy = math.huge
                    for _,v in pairs(workspace:GetChildren()) do
                        if v ~= Player.Character
                        and v:IsA("Model")
                        and v:FindFirstChild("Health")
                        and v.Health.Value ~= 0
                        and v:FindFirstChild("HumanoidRootPart")
                        and not string.find(v.Name, "Shroom") then
                            repeat task.wait()
                                -- print(v.Name)
                                local dist = (Player.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                                if dist < ClosestEnemy then
                                    -- if FarmMethod == "Rage" then
                                        TPToTarget(v.HumanoidRootPart, CFrame.new(0,10,5))
                                    -- elseif FarmMethod == "Legit (Not Working)" then
                                        -- walkToPart(v.HumanoidRootPart)
                                    -- end
                                end
                            until not Autofarm or not v:FindFirstChild("HumanoidRootPart") or v.Health.Value == 0
                        end
                    end 
                    return
                end
                AllowDespawnSpawn = true
                local ClosestEnemy = math.huge
                local IsBoss, Boss = CheckBoss()
                for _,v in pairs(workspace:GetChildren()) do
                    if v ~= Player.Character
                    and v:IsA("Model")
                    and v:FindFirstChild("Health")
                    and v.Health.Value ~= 0
                    and v:FindFirstChild("HumanoidRootPart")
                    and v:GetAttribute("hadEntrance") then
                        
                        if IsBoss and Boss then
                            task.wait(0.5)
                            -- v.Name ~= "LocalManeater"
                            -- repeat task.wait()
                                IsBoss, Boss = CheckBoss()
                                local dist = (Player.Character.HumanoidRootPart.Position - Boss.HumanoidRootPart.Position).Magnitude
                                if dist < ClosestEnemy then
                                    if FarmMethod == "Rage" then
                                        -- print("Targeting Enemies")
                                        TPToTarget(v.HumanoidRootPart, CFrame.new(0,10,5))
                                    elseif FarmMethod == "Legit (Not Working)" then
                                        walkToPart(v.HumanoidRootPart)
                                    end
                                end
                            -- until not Autofarm or v.Health.Value == 0 or not v:FindFirstChild("HumanoidRootPart")
                        else
                            EnemyNotAlive = false
                        -- if v:GetAttribute("hadEntrance") then
                            repeat task.wait()
                                IsBoss, Boss = CheckBoss()
                                local dist = (Player.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                                if dist < ClosestEnemy then
                                    if FarmMethod == "Rage" then
                                        -- print("Targeting Enemies")
                                        TPToTarget(v.HumanoidRootPart, CFrame.new(0,10,5))
                                    elseif FarmMethod == "Legit (Not Working)" then
                                        walkToPart(v.HumanoidRootPart)
                                    end
                                end
                            until not Autofarm or v.Health.Value == 0 or not v:FindFirstChild("HumanoidRootPart")
                        end
                        -- else
                            -- EnemyNotAlive = true
                        -- end
                    else
                        EnemyNotAlive = true
                    end
                end

                if EnemyNotAlive then
                    IsBoss, Boss = CheckBoss()
                    for _,v in pairs(workspace:GetDescendants()) do
                        if IsBoss then
                            -- print("Boss")
                            -- if v:FindFirstChild("clydeStart") then -- Sand World Final Boss Start!
                            --     TPToTarget(v.clydeStart, CFrame.new(0,0,0))
                            -- end
                            -- if v:FindFirstChild("TheDamned") then -- workspace:FindFirstChild("ThroneRoom"):FindFirstChild("TheDamned")
                            --     TPToTarget(v.TheDamned, CFrame.new(0,0,0))
                            -- end
                            -- if v:FindFirstChild("ExitZoneEnemyBarrier") then
                            --     TPToTarget(v.ExitZoneEnemyBarrier, CFrame.new(0,-1,0))
                            -- end
                            -- task.wait(0.1)
                            if v:FindFirstChild("fightZone") then
                                task.wait(.2)
                                -- IsBoss, Boss = CheckBoss()
                                TPToTarget(v.fightZone, CFrame.new(0,-1,0))
                                return
                            end
                            -- return
                        else
                            if Boss.Name ~= "Atticus" and v:FindFirstChild("fightZone") and v:FindFirstChild("ExitZoneEnemyBarrier") then -- 
                                -- if game:GetService("Players").LocalPlayer.PlayerGui.gameUI.HUD.stageMarker.stageUpdate.Visible then
                                    TPToTarget(v.fightZone, CFrame.new(0,-1,0))
                                    task.wait(0.02) -- Trying to find max speed until it breaks lower than 0.00 is breakeable and should not be used!
                                    TPToTarget(v.ExitZoneEnemyBarrier, CFrame.new(0,-1,0))

                                    -- TPToTarget(v.fightZone, CFrame.new(0,0,0))
                                    -- task.wait(0.4)
                                -- end
                            end
                        end
                    end
                end
            end)
            if not success then
                warn(err)
            end
        end
    end
end)

-- spawn(function()
--     while task.wait() do
--         if not Autofarm2 then
--             continue
--         end
--         local success, err = pcall(function()
--         if workspace.inCutscene.Value then return end

--         KeepAwayFromAkuma()

--         local ClosestEnemy = math.huge
--         local Enemy = nil

--         for _,v in pairs(workspace:GetChildren()) do
--             if v ~= Player.Character
--             and v:IsA("Model")
--             and v:FindFirstChild("Health")
--             and v.Health.Value > 0
--             and v:FindFirstChild("HumanoidRootPart")
--             and v:GetAttribute("hadEntrance")
--             and v.Name ~= "LocalManeater" then

--                 local dist = (Player.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude

--                 if dist < ClosestEnemy then
--                     ClosestEnemy = dist
--                     Enemy = v
--                 end
--             else
--                 EnemyNotAlive = true
--             end
--         end
        
--         if Enemy and not FailSafe then
--             if EnemyNotAlive then
--                 -- print("Enemy Alive")
--                 lastEnemyTime = tick()
--                 EnemyNotAlive = false
--                 --FailSafe = false
--             end
            
--             local IsBoss, Boss = CheckBoss()
--             print(IsBoss)
--             -- FailSafeFunc(8, false) -- If things go really wrong
--             -- pcall(function()
--                 if FarmMethod == "Rage" then
--                     repeat task.wait()
--                         FailSafeFunc(workspace.worldType.Value == "CrimsonAbyss" and 3 or 5, IsBoss)
--                         if GlobalFailSafe or FailSafe then
--                             print("GlobalFailSafe: "..tostring(GlobalFailSafe),"FailSafe: "..tostring(FailSafe))
--                             --TPToTarget(game.Players.LocalPlayer.Character.HumanoidRootPart, CFrame.new(0,30,0))
--                             game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,30,0)
--                             repeat task.wait()
--                                 game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
--                             until not Autofarm or not GlobalFailSafe or not FailSafe
--                         else
--                             -- if Enemy.Name == "Akuma" and v:FindFirstChild("HealForceFieldFolder") and not v:FindFirstChild("HealForceFieldFolder"):FindFirstChildOfClass("Part") then
--                             IsBoss, Boss = CheckBoss()
--                             local EnemyHealthBar = game:GetService("Players").LocalPlayer.PlayerGui.gameUI.Enemy.Healthbar
--                             -- print(IsBoss, Boss)
--                             if IsBoss then
--                                 EnemyHealthBar.Visible = true
--                                 if Boss.Name == "Akuma" then
--                                     -- if Boss == BossTitles.Akuma then
--                                     TPToTarget(workspace.Akuma.HumanoidRootPart, CFrame.new(0,0,-40))
--                                     print("Wating 5 sec")
--                                     task.wait(IsBoss and 3 or 1)
--                                     -- KillAuraDistance = 55
--                                     print("Waited 5 sec")
--                                     print("Trying to Target Akumas subordinates")
--                                     for i,v in pairs(workspace:GetChildren()) do
--                                         if v ~= Player.Character and v.Name ~= "Akuma"
--                                         and v:IsA("Model")
--                                         and v:FindFirstChild("Health")
--                                         and v.Health.Value ~= 0
--                                         and v:FindFirstChild("HumanoidRootPart") then
--                                             repeat task.wait()
--                                                 TPToTarget(workspace.Akuma.HumanoidRootPart, CFrame.new(0,0,-50))
--                                                 FailSafeFunc(7)
--                                             until not Autofarm or v.Health.Value == 0 or FailSafe
--                                         end
--                                     end
--                                     if not workspace.Akuma:FindFirstChild("HealForceFieldFolder"):FindFirstChildOfClass("Part") then
--                                         TPToTarget(workspace.Akuma.HumanoidRootPart, CFrame.new(0,0,10))
--                                     end

--                                     elseif workspace:FindFirstChild("InfestedBeast") then -- Bee Boss (can not be regular Enemies!)
--                                         TPToTarget(workspace:FindFirstChild("InfestedBeast").HumanoidRootPart, CFrame.new(0,0,10))

--                                         print("Wating 5 sec")
--                                         task.wait(IsBoss and 5 or 1)
--                                         print("Waited 5 sec")
--                                         repeat task.wait() until not Autofarm or FailSafe or game:GetService("Players").LocalPlayer.PlayerGui.gameUI.Enemy.Healthbar.Visible
--                                         repeat task.wait()
--                                             TPToTarget(workspace:FindFirstChild("InfestedBeast").HumanoidRootPart, CFrame.new(0,0,10))
--                                             FailSafeFunc(7)
--                                         until not Autofarm or FailSafe or not workspace:FindFirstChild("InfestedBeast") or not workspace:FindFirstChild("InfestedBeast"):FindFirstChild("HumanoidRootPart")
--                                         -- workspace.Maneater

                                        
                                
--                                     -- elseif workspace:FindFirstChild("Atticus") then
--                                     elseif Boss.Name == "Atticus" then
--                                         print("#Atticus")
--                                         TPToTarget(workspace.Vault.ClydeSpawn, CFrame.new(0,0,10))
--                                         print("Wating 5 sec")
--                                         task.wait(IsBoss and 5 or 1)
--                                         print("Waited 5 sec")
--                                         repeat task.wait()
--                                             TPToTarget(workspace:FindFirstChild("Atticus").HumanoidRootPart, CFrame.new(0,0,10))
--                                             FailSafeFunc(15)
--                                         until not Autofarm or FailSafe or not workspace:FindFirstChild("Atticus")
                                    
--                                     elseif Boss.Name == "Maneater" then
--                                         TPToTarget(workspace.TheDen.introPositions.pos1_1, CFrame.new(0,5,0))
--                                         print("Wating 5 sec")
--                                         task.wait(IsBoss and 3 or 1)
--                                         print("Waited 5 sec")

--                                         repeat task.wait()
--                                             game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("onHit"):FireServer(Boss.Humanoid, -math.huge, {}, 0)
--                                             TPToTarget(Boss.HumanoidRootPart, CFrame.new(0,0,10))
--                                             FailSafeFunc(7)
--                                         until not Autofarm or FailSafe or not workspace:FindFirstChild(Boss.Name)


--                                     elseif workspace:FindFirstChild("ThroneRoom") and workspace:FindFirstChild("ThroneRoom"):FindFirstChild("TheDamned") then
--                                         -- workspace.ThroneRoom.BookHand
--                                         print("Wating 5 sec")
--                                         task.wait(IsBoss and 5 or 1)
--                                         print("Waited 5 sec")
--                                         if workspace.ThroneRoom.BookHand:FindFirstChild("basehitbox") and workspace.ThroneRoom.BookHand:FindFirstChild("Humanoid") then
--                                             TPToTarget(workspace.ThroneRoom.BookHand.basehitbox, CFrame.new(0,0,10))
--                                             for i,v in pairs(workspace.ThroneRoom:GetChildren()) do
--                                                 if v.Name == "BookHand" and v.Health.Value ~= 0 then
--                                                     game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("onHit"):FireServer(v.Humanoid, -math.huge, {}, 0)
--                                                 end
--                                             end
--                                         end
                                        
--                                         TPToTarget(Enemy.HumanoidRootPart, CFrame.new(0,0,25))
--                                 else
--                                     FailSafeFunc(workspace.worldType.Value == "CrimsonAbyss" and 3 or 5)
--                                     -- KillAuraDistance = KillAuraDistance or 30
--                                     -- TPToTarget(Enemy.HumanoidRootPart, CFrame.new(0,math.random(0, 10),math.random(-15, 15)))
--                                     TPToTarget(Enemy.HumanoidRootPart, CFrame.new(0,10,5))
--                                 end
--                             else
--                                 EnemyHealthBar.Visible = false
--                                 FailSafeFunc(workspace.worldType.Value == "CrimsonAbyss" and 3 or 5, IsBoss) -- "Active if no improvement after 5 sec"
--                                 -- KillAuraDistance = KillAuraDistance or 30
--                                 -- TPToTarget(Enemy.HumanoidRootPart, CFrame.new(0,math.random(0, 10),math.random(-15, 15)))
--                                 TPToTarget(Enemy.HumanoidRootPart, CFrame.new(0,10,5))
--                             end
--                         end
--                     until not Autofarm or Enemy.Health.Value == 0 or FailSafe or not Enemy:FindFirstChild("HumanoidRootPart")
                    
--                 elseif FarmMethod == "Legit (Not Working)" then
--                     walkToPart(Enemy.HumanoidRootPart)
--                 end
--             -- end)
--         else
--             IsBoss, Boss = CheckBoss()
--             -- if IsBoss and FailSafe then
--             --     print("Boss")
--             --     -- for i = 1,3 do
--             --         for _,v in pairs(workspace:GetDescendants()) do
--             --             if v:FindFirstChild("fightZone") then
--             --                 TPToTarget(v.fightZone, CFrame.new(math.random(-30, 30),math.random(-30, 30),math.random(-30, 30)))
--             --                 task.wait(0.1)
--             --             end
--             --         end
--             --     -- end
--             --     -- workspace.Vault.fightZone
--             --     FailSafe = false
--             --     return
--             -- end
--             -- print("NotBoss")
--                 for _,v in pairs(workspace:GetDescendants()) do
--                     if v:FindFirstChild("ExitZoneEnemyBarrier") and v:FindFirstChild("fightZone") then
--                         if game:GetService("Players").LocalPlayer.PlayerGui.gameUI.HUD.stageMarker.stageUpdate.Visible or FailSafe then
--                             TPToTarget(v.ExitZoneEnemyBarrier, CFrame.new(math.random(-30, 30),-1,math.random(-30, 30)))
--                             task.wait(0.02)
--                             TPToTarget(v.fightZone, CFrame.new(0,0,0))
--                             task.wait(0.4)
--                         else
--                             -- print("Stuff")
--                             FailSafeFunc(5, false)
--                             TPToTarget(v.ExitZoneEnemyBarrier, CFrame.new(0,-1,0))
--                             task.wait()
--                             TPToTarget(v.fightZone, CFrame.new(0,0,0))
--                             -- task.wait(0.07)
--                         end
--                     end
--                     if v:FindFirstChild("clydeStart") then -- Sand World Boss Start!
--                         TPToTarget(v.clydeStart, CFrame.new(0,0,0))
--                     end
--                     if v:FindFirstChild("TheDamned") then -- workspace:FindFirstChild("ThroneRoom"):FindFirstChild("TheDamned")
--                         TPToTarget(v.TheDamned, CFrame.new(0,0,0))
--                     end
--                 end
--                 FailSafe = false -- "Deactivated"
--                 -- task.wait(0.4)
--             -- end
--         end
--         end)
--         if not success then
--             warn("AutoFarm:", err)
--         end
--     end
-- end)

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


Misc:Toggle("Auto Claim Quests", false, function(t)
    AutoClaimQuests = t
end)

Misc:Toggle("Auto Claim Achievements", false, function(t)
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

Misc:line()

Misc:Toggle("Auto Open Chests", false, function(t)
    AutoOpenChests = t
end)

local LootStats = require(game:GetService("ReplicatedStorage").constants.lootStats)
local Rarity_Drops = {}
for i,v in pairs(LootStats.rarityDropValues) do
    table.insert(Rarity_Drops, i)
end

Misc:Checklist("Chest Rarity", "Chest_Rarity", Rarity_Drops, function(t)
    Rarity_Selected = t
end)

spawn(function()
    while task.wait() do
        if AutoOpenChests then
            pcall(function()
                for i,v in pairs(require(game:GetService("ReplicatedStorage").plrData):GetValue(game.Players.LocalPlayer, "ownedItems")) do
                    if game:GetService("ReplicatedStorage").remotes:FindFirstChild("openLoot") and string.find(i, "Chest") then
                        if table.find(Rarity_Selected, LootStats.values[i].rarity) and v.copies ~= 0 then
                            local Event = game:GetService("ReplicatedStorage").remotes.openLoot
                            Event:InvokeServer(
                                i,
                                v.copies
                            )
                            task.wait(0.02)
                            print("opend Chest!", i, v.copies)
                        end
                    end
                end
            end)
        end
    end
end)

Misc:line()

local function TypeText(Label, Text, Speed)
    Speed = Speed or 0.03

    -- erase current text
    local current = "Weapon Upgrades Comming Soon!"
    for i = #current, 1, -1 do
        Label:Refresh(current:sub(1, i))
        task.wait(Speed / 2)
    end

    Label:Refresh("")

    task.wait(0.4)

    -- type new text
    for i = 1, #Text do
        Label:Refresh(Text:sub(1, i))
        task.wait(Speed)
    end
end

local Update_Label = Misc:Label("Weapon Upgrades Comming Soon!")
task.spawn(function()
    while true do
        TypeText(Update_Label, "Weapon Upgrades Coming Soon!", 0.04)
        task.wait(1)
    end
end)

-- Update_Label:Refresh("Something new!")

-- Misc:Toggle("Upgrade Weapon", false, function(t)
--     UpgradeWeapon = t
-- end)

-- Misc:Checklist("Select Weapons", "Chest_Rarity", Rarity_Drops, function(t)
--     Selected_Weapon = t
-- end)

-- Misc:Slider("Upgrade Delay", 0, 100, 3, function(t)
--     Upgrade_Delay = t
-- end)

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
