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
local Quest = Window:Tab("Quest")

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

spawn(function()
    while task.wait() do
        if KillAura then
            pcall(function()
                for i, v in pairs(workspace:GetChildren()) do
                    if v ~= game.Players.LocalPlayer.Character and v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") and (v:GetPivot().Position - game.Players.LocalPlayer.Character:GetPivot().Position).magnitude < 30 then
                        game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("onHit"):FireServer(v.Humanoid, -math.huge, {}, 0)
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

function TPToTarget(target)
    if not target then warn("no target found!") return end
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.CFrame * CFrame.new(0,0,-5)
end


Combat:Dropdown("Farm Method", {"Legit (Not Working)", "Rage"}, function(t)
    FarmMethod = t
end)

Combat:Toggle("Autofarm", false, function(t)
    Autofarm = t
end)

Combat:Toggle("NoClip", false, function(t)
    NoClip = t
end)

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
                local Event = game:GetService("ReplicatedStorage").remotes.plrUpgrade
                Event:FireServer(
                    math.random(1,3)
                )
                task.wait(0.3)
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

spawn(function()
    while task.wait() do
        if Autofarm then
            pcall(function()
                for i, v in pairs(workspace:GetChildren()) do
                    if v ~= game.Players.LocalPlayer.Character and
                    v:IsA("Model") and
                    v:FindFirstChild("Health") and v.Health.Value > 0 and
                    v:FindFirstChild("HumanoidRootPart")
                    then
                        if FarmMethod == "Legit (Not Working)" then
                            walkToPart(v.HumanoidRootPart)
                            task.wait(0.1)
                        elseif FarmMethod == "Rage" then
                                TPToTarget(v.HumanoidRootPart)
                        end
                        
                        --game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("onHit"):FireServer(v.Humanoid, -math.huge, {}, 0)
                    end
                end
            end)
        end
    end
end)

Combat:line()

Combat:Slider("Hitbox Size", 1, 50, 4, function(t)
    HitBoxSize = t
end)

Combat:Toggle("Hitbox", false, function(t)
    HitBox = t
end)

Combat:Toggle("Show Hitbox", false, function(t)
    ShowHitBox = t
end)

spawn(function()
    while task.wait() do
        if HitBox then
            pcall(function()
                for i, v in pairs(workspace:GetChildren()) do
                    if v ~= game.Players.LocalPlayer.Character and v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        if v:FindFirstChild("basehitbox") then
                            v.basehitbox.Size = Vector3.new(HitBoxSize,HitBoxSize,HitBoxSize)
                            v.basehitbox.Transparency = ShowHitBox and 0.7 or 1
                        end

                        if v:FindFirstChild("HumanoidRootPart") then
                            v.HumanoidRootPart.Size = Vector3.new(HitBoxSize,HitBoxSize,HitBoxSize)
                            v.HumanoidRootPart.Transparency = ShowHitBox and 0.7 or 1
                        end
                    end
                end
            end)
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
