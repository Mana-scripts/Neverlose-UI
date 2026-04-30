
------------ // Pixel Blade \\ ------------

------------------------------------------------------------
--/////////////////////////GUI\\\\\\\\\\\\\\\\\\\\\\\\\\\\--
------------------------------------------------------------ 

local Library = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Mana-scripts/Neverlose-UI/refs/heads/main/UI/Smart-UI.lua"))()

local HubName = getgenv().UtilityModule.HubName

local Accent = Color3.fromRGB(34, 43, 140)
local Gradient = Color3.fromRGB(72, 46, 178)

-- Library.Theme.Accent = Accent
-- Library.Theme.AccentGradient = Gradient
Library:ChangeTheme("Accent", Accent)
Library:ChangeTheme("AccentGradient", Gradient)

local Window = Library:Window({
    Name = HubName,
    SubName = "Pixel Blade",
    Logo = "116342860199829",
    Folders = {
        Directory = HubName,
        Configs = HubName .. "/Configs",
        Assets = HubName .. "/Assets",
        Utility = HubName .. "/Utility",
        LastLoaded = HubName .. "/Utility/LastLoaded"
    }
})

local KeybindList = Library:KeybindList("Keybinds")

Window:Category("Main")

local AutoFarm = Window:Page({Name = "AutoFarm", Icon = "138827881557940"})
local Upgrades = Window:Page({Name = "Upgrades", Icon = ""})

local Combat
local Legit
local Fishing

local Patched_Combat = false
local Spawn_Destroyed = false
local Lobby_Game_Id = 18172550962

local Chests_Section = Upgrades:Section({Name = "Chests", Side = 1})
local Weapon_Upgrades_Section = Upgrades:Section({Name = "Weapon Upgrades", Side = 2})
local Armor_Upgrades_Section = Upgrades:Section({Name = "Armor Upgrades", Side = 1})
local Potions_Section = Upgrades:Section({Name = "Potions", Side = 2})
local Misc_Section = Upgrades:Section({Name = "Misc", Side = 1})


Window:Category("Settings")
local SettingsPage = Library:CreateSettingsPage(Window, KeybindList)


Library:Watermark({
    "QYRIX",
    game.Players.LocalPlayer.Name,
    116342860199829
})

task.spawn(function()
    while true do
        local FPS = math.floor(1 / game:GetService("RunService").RenderStepped:Wait())
        Library:Watermark({
            "QYRIX",
            game.Players.LocalPlayer.Name,
            116342860199829,
            "FPS: " .. FPS
        })
        task.wait(0.5)
    end
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



if not Patched_Combat and game.PlaceId ~= Lobby_Game_Id then -- [[Autofarm Patched!]]
    if not Patched_Combat then
        Combat = AutoFarm:Section({Name = "Autofarm", Side = 1})
    end

    
    local Autofarm = false

    Combat:Toggle({
        Name = "Kill Aura",
        Flag = "Kill_Aura",
        Default = false,
        Callback = function(t)
            KillAura = t
        end
    })

    Combat:Slider({
        Name = "KillAura Distance",
        Flag = "KillAura_Distance",
        Min = 1,
        Max = 500,
        Default = 30,
        Suffix = "",
        Callback = function(Value)
            KillAuraDistance = Value
        end
    })
    
    local GlobalFailSafe = false
    local Boss_Wait_Done = false

    -- workspace.KoriBossFight.Crossbow1 | Just a test to see if its fucking with the game.
    task.spawn(function()
        while task.wait(0.15) do
            if KillAura and not Autofarm then
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
                        and not string.find(v.Name, "Shroom") then
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
                                    repeat task.wait(0.07)
                                        game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("onHit"):FireServer(v.Humanoid, -math.huge, {}, 0)
                                    until not KillAura or not v or v.Health.Value == 0
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


    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")

    local player = Players.LocalPlayer


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

    Combat:Toggle({
        Name = "Autofarm",
        Flag = "Autofarm",
        Default = false,
        Callback = function(t)
            Autofarm = t
        end
    })

    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local camera = workspace.CurrentCamera

    local function spectate(targetName)
        local target = workspace:FindFirstChild(targetName)
        if not target then return end
        
        if target and target:FindFirstChild("Humanoid") then
            camera.CameraSubject = target.Humanoid
            camera.CameraType = Enum.CameraType.Custom
        end
    end

    Combat:Toggle({
        Name = "Bring Mobs",
        Flag = "Bring_Mobs",
        Default = false,
        Callback = function(t)
            BringMobs = t
        end
    })

    Combat:Slider({
        Name = "Autofarm Distance",
        Flag = "Autofarm_Distance",
        Min = -50,
        Max = 50,
        Default = 10,
        Callback = function(t)
            Autofarm_Distance = t
        end
    })

    local Players = game:GetService("Players")

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

    function BringMobs_Function(Target)
        for _,v in pairs(workspace:GetChildren()) do
            if v ~= Player.Character
            and v:IsA("Model")
            and v:FindFirstChild("Health")
            and v.Health.Value ~= 0
            and v:FindFirstChild("HumanoidRootPart")
            and not string.find(v.Name, "Shroom") then
                local dist = (v.HumanoidRootPart.Position - Target.Position).Magnitude
                if BringMobs and dist < 200 then
                    v.HumanoidRootPart.CanCollide = false
                    TweenService:Create(
                        v.HumanoidRootPart,
                        TweenInfo.new(dist/200, Enum.EasingStyle.Linear),
                        {CFrame = Target.CFrame}
                    ):Play()
                end
            end
        end
    end

    function Attack(Humanoid)
        game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("onHit"):FireServer(Humanoid, -math.huge, {}, 0)
    end

    spawn(function()
        local NotSearching = false
        while task.wait(0.15) do
            if Autofarm then
                local success, err = pcall(function()
                    if game.PlaceId == 133884972346775 then
                        if game:GetService("Players").LocalPlayer.PlayerGui.gameUI.HUD.startInfo.TextTransparency == 0 then
                            TPToTarget(workspace.RaidArena.CrystalTree.Root, CFrame.new(0,0,0))
                            return
                        end
                        if workspace.RaidArena.UpgradeVoting.inVotePhase.Value then
                            local Chosen = math.random(1,3)
                            repeat task.wait()
                                TPToTarget(workspace.RaidArena.UpgradeVoting["playerZone"..tostring(Chosen)], CFrame.new(0,0,0))
                            until not Autofarm or not workspace.RaidArena.UpgradeVoting.inVotePhase.Value
                        end
                        local ClosestEnemy = math.huge
                        for _,v in pairs(workspace:GetChildren()) do
                            if v ~= Player.Character
                            and v:IsA("Model")
                            and v:FindFirstChild("Health")
                            and v.Health.Value ~= 0
                            and v:FindFirstChild("HumanoidRootPart")
                            and not string.find(v.Name, "Shroom") then
                                repeat task.wait(0.005)
                                    local dist = (Player.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                                    if dist < ClosestEnemy then
                                        local Target = v.HumanoidRootPart
                                        TPToTarget(v.HumanoidRootPart, CFrame.new(0,Autofarm_Distance or 10,5))
                                        task.spawn(BringMobs_Function, Target)
                                        task.spawn(Attack, v.Humanoid)
                                    end
                                until not Autofarm or not v:FindFirstChild("HumanoidRootPart") or v.Health.Value == 0
                            else
                                -- repeat task.wait(0.15)
                                    TPToTarget(workspace.RaidArena.CrystalTree.Root, CFrame.new(0,15,0))
                                -- until not Autofarm or v:FindFirstChild("HumanoidRootPart") or v
                            end
                        end 
                        -- TPToTarget(workspace.RaidArena.CrystalTree.Root, CFrame.new(0,15,0))
                        return
                    end

                    local IsBoss, Boss = CheckBoss()

                    function FarmBookHands()
                        if workspace:FindFirstChild("ThroneRoom") then
                            for i,v in pairs(workspace.ThroneRoom:GetChildren()) do
                                if v:IsA("Model") and v:FindFirstChild("Humanoid") and workspace:FindFirstChild("Korth") and workspace:FindFirstChild("Korth"):GetAttribute("hadEntrance") then
                                    task.spawn(Attack, v.Humanoid)
                                    task.wait(0.1)
                                end
                            end
                        end
                    end

                    for i,v in pairs(workspace:GetChildren()) do
                        if v ~= game.Players.LocalPlayer.Character
                        and v:IsA("Model")
                        and v:FindFirstChild("HumanoidRootPart")
                        and v:FindFirstChild("Humanoid")
                        and v:GetAttribute("hadEntrance") 
                        and v.Health.Value ~= 0
                        and v.Name ~= "Kori"
                        or v:GetAttribute("CrossbowFire") then
                            local Target = v.HumanoidRootPart
                            repeat task.wait(0.04)
                                NotSearching = false
                                task.spawn(FarmBookHands)
                                task.spawn(BringMobs_Function, Target)
                                task.spawn(spectate, Target.Parent.Name)
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, Autofarm_Distance or 10,5)
                                task.spawn(Attack, v.Humanoid)
                            until not Autofarm or v.Health.Value == 0
                        else
                            NotSearching = true
                        end
                    end

                end)
                if not success then
                    warn(err)
                end

                local success, err = pcall(function()
                    local Place = nil
                    if NotSearching then
                        for i,v in pairs(workspace:GetChildren()) do
                            if v:IsA("Model") then
                                if workspace:FindFirstChild("Spawn") then
                                    print("Spawn Destroyed!")
                                    workspace:FindFirstChild("Spawn"):Destroy()
                                end
                                for i,v in pairs(v:GetChildren()) do
                                    if (string.find(v.Name, "Exit") or string.find(v.Name, "fight")) and v:IsA("Part") and NotSearching then
                                        -- Place = v.CFrame
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(math.random(-3,3), math.random(-3,3), math.random(-3,3))
                                        task.wait(0.15)
                                    end
                                end
                            end
                        end
                    end
                    -- if NotSearching and Place ~= nil then
                    --     game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Place * CFrame.new(math.random(-3,3), math.random(-3,3), math.random(-3,3))
                    --     -- task.wait(0.15)
                    -- end
                end)

                if not success then
                    warn(err)
                end

            end
        end
    end)

    Combat:Toggle({
        Name = "Auto Collect Breakables",
        Flag = "AutoCollectBreakables",
        Default = false,
        Callback = function(t)
            AutoCollectBreakables = t
        end
    })

    spawn(function()
        while task.wait(0.15) do
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

    Combat:Toggle({
        Name = "Auto Replay",
        Flag = "AutoReplay",
        Default = false,
        Callback = function(t)
            AutoReplay = t
        end
    })

    spawn(function()
        while task.wait(0.15) do
            if AutoReplay then
                pcall(function()
                    if workspace.voting.Value then
                        game:GetService("ReplicatedStorage").remotes.gameEndVote:FireServer("replay")
                    end
                end)
            end
        end
    end)

    Combat:Toggle({
        Name = "Auto Upgrade",
        Flag = "AutoUpgrade",
        Default = false,
        Callback = function(t)
            AutoUpgrade = t
        end
    })

    function disableUpgradePopUps(bool)
        if bool then
            game:GetService("Lighting").deathBlur.Size = 0
            game:GetService("Players").LocalPlayer.PlayerGui.gameUI.upgradeFrame.Position = UDim2.new(0, 0, -1.1, 0)
        end
    end

    spawn(function()
        while task.wait(0.15) do
            if AutoUpgrade then
                local success, err = pcall(function()
                    repeat task.wait(0.15) until not AutoUpgrade or not GlobalFailSafe or game:GetService("Players").LocalPlayer.PlayerGui.gameUI.upgradeFrame.Visible
                    local Event = game:GetService("ReplicatedStorage").remotes.plrUpgrade
                    Event:FireServer(
                        math.random(1,3)
                    )
                    --task.wait(0.3)
                end)
                if not success then
                    warn("AutoUpgrade", err)
                end
            end
        end
    end)

    spawn(function()
        while task.wait(0.15) do
            if AutoUpgrade then
                pcall(function()
                    disableUpgradePopUps(true)
                end)
            end
        end
    end)

    Combat:Toggle({
        Name = "NoClip",
        Flag = "NoClip",
        Default = false,
        Callback = function(t)
            NoClip = t
        end
    })
    
else
    if Patched_Combat then
        getgenv().UtilityModule:Notify({
            Title = getgenv().UtilityModule.HubName,
            Duration = 5,
            Description = "Autofarming has been patched."
        })
    elseif game.PlaceId == Lobby_Game_Id then
        getgenv().UtilityModule:Notify({
            Title = getgenv().UtilityModule.HubName,
            Duration = 5,
            Description = "Autofarming has been Disabled."
        })
    end
end


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

function setNoclip(state)
	if state then
		for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	else
		for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
	end
end

spawn(function()
    while task.wait(0.15) do
        if NoClip then
            pcall(function()
                setNoclip(NoClip)
                task.wait(1)
            end)
        end
    end
end)

-- if not Patched_Combat and game.PlaceId ~= Lobby_Game_Id then

--     Legit = AutoFarm:Section({Name = "Legit", Side = 2})

--     Legit:Toggle({
--         Name = "Hitbox",
--         Flag = "Hitbox",
--         Default = false,
--         Callback = function(t)
--             Hitbox = t
--         end
--     })

--     Legit:Slider({
--         Name = "Hitbox Size",
--         Flag = "HitBoxSize",
--         Min = 1,
--         Max = 50,
--         Default = 4,
--         Callback = function(t)
--             HitBoxSize = t
--         end
--     })

--     function SmoothHitbox()
--         local HitboxCaster = require(game:GetService("ReplicatedStorage").RaycastHitboxV4.HitboxCaster)
--         local oldHitStart
--         local oldHitStop

--         oldHitStart = hookfunction(HitboxCaster.HitStart, function(self, duration)
--             self.HitboxActive = true
--             self.HitboxStopTime = 0
--             if self.HitboxHitList then
--                 table.clear(self.HitboxHitList)
--             end
--             return oldHitStart(self, -math.huge)
--         end)
        
--         oldHitStop = hookfunction(HitboxCaster.HitStop, function(self)
--             self.HitboxActive = true
--             self.HitboxStopTime = 0
--             if self.HitboxHitList then
--                 table.clear(self.HitboxHitList)
--             end
--             return
--         end)
--     end

--     spawn(function()
--         pcall(function()
--             local oldRaycast
--             oldRaycast = hookmetamethod(game, "__namecall", function(self, ...)
--                 local args = {...}
                
--                 if HitBox and getnamecallmethod() == "Raycast" and self == workspace then
                    
--                     local origin = args[1]
--                     local direction = args[2]
--                     local params = args[3]

--                     if typeof(direction) == "Vector3" then
                        
--                         local shouldExtend = false

--                         if params and params.FilterDescendantsInstances then
--                             for _, v in ipairs(params.FilterDescendantsInstances) do
--                                 if v:IsA("Model") then
--                                     local humanoid = v:FindFirstChildOfClass("LocalScript")
--                                     if humanoid then
--                                         shouldExtend = true
--                                         break
--                                     end
--                                 end
--                             end
--                         end
                        
--                         -- if shouldExtend then
--                         args[2] = direction.Unit * HitBoxSize
--                         -- end
--                     end

--                     return oldRaycast(self, unpack(args))
--                 end

--                 return oldRaycast(self, ...)
--             end)

--             local oldDelay
--             oldDelay = hookfunction(task.delay, function(time, func, ...)
--                 local info = debug.getinfo(func)
--                 if time == 0.14 and info and info.source and string.find(info.source, "RaycastHitbox") then
--                     time = 0
--                 end
--                 return oldDelay(time, func, ...)
--             end)

--             if not getgenv().Qyrix_Loaded.SmoothHitbox then
--                 SmoothHitbox()
--                 print("SmoothHitbox Loaded")
--                 getgenv().Qyrix_Loaded.SmoothHitbox = true
--             end
--         end)
--     end)
-- end


-- [[Stabalize]] --
-- local Stabalize_success, Stabalize_err = pcall(function()

    Fishing = AutoFarm:Section({Name = "Fishing", Side = 2})

    Fishing:Label("IMPORTANT! You need to catch 1 fish manualy before using this Autofarm!")

    Fishing:Toggle({
        Name = "Auto Catch Fish",
        Flag = "AutoCatchFish",
        Default = false,
        Callback = function(t)
            AutoCatchFish = t
        end
    })

    local FishingStats = require(game:GetService("ReplicatedStorage").constants.fishingStats)

    local LuckCircles = {}
    for i,v in pairs(FishingStats.enchantCircleRanges) do
        table.insert(LuckCircles, i)
    end

    Fishing:Dropdown({
        Name = "Targeted Luck Circles",
        Flag = "LuckCircles",
        Items = LuckCircles,
        Multi = true,
        Callback = function(t)
            TargetLuckCircles = t
        end
    })

    Fishing:Toggle({
        Name = "Disable Popups",
        Flag = "Disable_Popups",
        Default = false,
        Callback = function(t)
            DisablePopups = t
        end
    })


    local plrData = require(game:GetService("ReplicatedStorage").plrData)
    -- local LootStats = require(game:GetService("ReplicatedStorage").constants.lootStats)
    -- local Rarity_Drops = {}
    -- for i,v in pairs(LootStats.rarityDropValues) do
    --     table.insert(Rarity_Drops, i)
    -- end

    local success, fishCaught = pcall(function()
        return game:GetService("ReplicatedStorage").remotes.fishCaught
    end)

    spawn(function()
        while task.wait(0.15) do
            if AutoCatchFish then
                pcall(function()
                    for i,v in pairs(workspace.FishingCircles:GetChildren()) do
                        if v:IsA("Part") and v:FindFirstChildOfClass("Part") and table.find(TargetLuckCircles, v.Name) then
                            fishCaught:FireServer(
                                v.Position,
                                -math.huge
                            )
                            task.wait(0.005)
                        end
                    end
                end)
            end
        end
    end)

    spawn(function()
        while task.wait(0.15) do
            if DisablePopups then
                pcall(function()
                    game:GetService("Players").LocalPlayer.PlayerGui.gameUI.Enchant.BackgroundTransparency = 1
                    for i,v in pairs(workspace:GetChildren()) do
                        if v.Name == "BookReveal" then
                            v:Destroy()
                        end
                    end
                end)
            end
        end
    end)


    local fishingStats = require(game:GetService("ReplicatedStorage").constants.fishingStats)
    local plrData = require(game:GetService("ReplicatedStorage").plrData)
    local sellFishItem_success, sellFishItem = pcall(function()
        return game:GetService("ReplicatedStorage").remotes.sellFishItem
    end)

    local FishingDrops = {"All"}
    for i,v in pairs(fishingStats.drops) do
        table.insert(FishingDrops, i)
    end

    Fishing:Toggle({
        Name = "Auto Sell Fish",
        Flag = "AutoSellFish",
        Default = false,
        Callback = function(t)
            AutoSellFish = t
        end
    })

    Fishing:Dropdown({
        Name = "Select Fish/Items",
        Flag = "SelectFish",
        Items = FishingDrops,
        Multi = true,
        Callback = function(t)
            SelectFish_Items = t
        end
    })

    spawn(function()
        while task.wait(0.15) do
            if AutoSellFish then
                pcall(function()
                    for i,v in pairs(plrData:GetValue(game.Players.LocalPlayer, "fishStash")) do
                        if fishingStats.drops[i] and table.find(SelectFish_Items, i) or table.find(SelectFish_Items, "All") then
                            sellFishItem:FireServer(
                                i,
                                false
                            )
                        end
                    end
                end)
            end
        end
    end)

    -- Fishing:Toggle({
    --     Name = "Auto Sell Fish",
    --     Flag = "AutoSellFish",
    --     Default = false,
    --     Callback = function(t)
    --         AutoSellFish = t
    --     end
    -- })


    Misc_Section:Toggle({
        Name = "Auto Claim Quests",
        Flag = "AutoClaimQuests",
        Default = false,
        Callback = function(t)
            AutoClaimQuests = t
        end
    })

    Misc_Section:Toggle({
        Name = "Auto Claim Achievements",
        Flag = "AutoClaimAchievements",
        Default = false,
        Callback = function(t)
            AutoClaimAchievements = t
        end
    })

    spawn(function()
        while task.wait(0.15) do
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
        while task.wait(0.15) do
            if AutoClaimAchievements then
                pcall(function()
                    for i,v in pairs(questData.Achievements) do
                        ClaimAchievement(v.id)
                    end
                end)
            end
        end
    end)

    Misc_Section:Toggle({
        Name = "Auto Wish",
        Flag = "AutoWish",
        Default = false,
        Callback = function(t)
            AutoWish = t
        end
    })

    spawn(function()
        while task.wait(0.15) do
            if AutoWish then
                pcall(function()
                    game:GetService("ReplicatedStorage").remotes.openWish:InvokeServer()
                    task.wait(0.005)
                end)
            end
        end
    end)


    local plrData = require(game:GetService("ReplicatedStorage").plrData)
    local LootStats = require(game:GetService("ReplicatedStorage").constants).lootStats

    -- if type(LootStats) ~= "table" or type(LootStats.values) ~= "table" then
    --     LootStats = { values = {}, rarityDropValues = {} }
    -- end

    function Get_Rarity_Drops(Table)
        local Rarity_Drops = {}
        for i,v in pairs(Table.rarityDropValues) do
            table.insert(Rarity_Drops, i)
        end
        return Rarity_Drops
    end

    local Rarity_Drops_success, Rarity_Drops = pcall(function()
        local LootStats = require(game:GetService("ReplicatedStorage").constants.lootStats)
        return Get_Rarity_Drops(LootStats)
    end)

    if not Rarity_Drops_success then
        Rarity_Drops = {}
    end

    Chests_Section:Dropdown({
        Name = "Chest Rarity",
        Flag = "Chest_Rarity",
        Items = Rarity_Drops,
        Multi = true,
        Callback = function(t)
            Rarity_Selected = t
        end
    })

    Chests_Section:Toggle({
        Name = "Auto Open Chests",
        Flag = "AutoOpenChests",
        Default = false,
        Callback = function(t)
            AutoOpenChests = t
        end
    })


    -- local WpnStatssuccess, WpnStats = pcall(function()
    --     return require(game:GetService("ReplicatedStorage").constants.wpnStats)
    -- end)

    local WpnStats = require(game:GetService("ReplicatedStorage").constants).wpnStats

    -- if not WpnStatssuccess or type(WpnStats) ~= "table" or type(WpnStats.values) ~= "table" then
    --     warn("bad wpnStats:", WpnStats)
    --     WpnStats = { values = {} }
    -- end

    local FormatWeaponNames = {"All"}
    for i,v in pairs(WpnStats) do
        if not table.find(FormatWeaponNames, i) then
            table.insert(FormatWeaponNames, i)
        end
    end

    Weapon_Upgrades_Section:Dropdown({
        Name = "Select Weapons Rarity",
        Flag = "Weapons_Rarity",
        Items = Rarity_Drops,
        Multi = true,
        Callback = function(t)
            WeaponsRarity = t
        end
    })

    Weapon_Upgrades_Section:Dropdown({
        Name = "Select Weapons",
        Flag = "Weapons",
        Items = FormatWeaponNames,
        Multi = true,
        Callback = function(t)
            Weapons = t
        end
    })

    Weapon_Upgrades_Section:Toggle({
        Name = "Upgrade Weapon",
        Flag = "UpgradeWeapon",
        Default = false,
        Callback = function(t)
            UpgradeWeapon = t
        end
    })

    -- local armorStatssuccess, armorStats = pcall(function()
    --     return require(game:GetService("ReplicatedStorage").constants.armorStats)
    -- end)

    local armorStats = require(game:GetService("ReplicatedStorage").constants).armorStats

    -- if not armorStatssuccess or type(armorStats) ~= "table" or type(armorStats.values) ~= "table" then
    --     warn("bad armorStats:", armorStats)
    --     armorStats = { values = {} }
    -- end

    local FormatArmorNames = {"All"}

    for i,v in pairs(armorStats) do
        if not table.find(FormatArmorNames, i) and i ~= "none" then
            table.insert(FormatArmorNames, i)
        end
    end

    Armor_Upgrades_Section:Dropdown({
        Name = "Select Armor Rarity",
        Flag = "Armor_Rarity",
        Items = Rarity_Drops,
        Multi = true,
        Callback = function(t)
            ArmorRarity = t
        end
    })

    Armor_Upgrades_Section:Dropdown({
        Name = "Select Armors",
        Flag = "Armors",
        Items = FormatArmorNames,
        Multi = true,
        Callback = function(t)
            Armors = t
        end
    })

    Armor_Upgrades_Section:Toggle({
        Name = "Upgrade Armor",
        Flag = "UpgradeArmor",
        Default = false,
        Callback = function(t)
            UpgradeArmor = t
        end
    })

    Potions_Section:Toggle({
        Name = "Auto Buy Energy Flask",
        Flag = "EnergyFlask",
        Default = false,
        Callback = function(t)
            EnergyFlask = t
        end
    })

    Potions_Section:Toggle({
        Name = "Auto Buy Health Flask",
        Flag = "HealthFlask",
        Default = false,
        Callback = function(t)
            HealthFlask = t
        end
    })

    Potions_Section:Toggle({
        Name = "Auto Buy Dragon Flask",
        Flag = "DragonFlask",
        Default = false,
        Callback = function(t)
            DragonFlask = t
        end
    })

    local plrData = require(game:GetService("ReplicatedStorage").plrData)
    local WpnStats = require(game:GetService("ReplicatedStorage").constants.wpnStats)
    local requestPurchase_success, requestPurchase = pcall(function()
        return game:GetService("ReplicatedStorage").remotes.requestPurchase
    end)

    -- local armorStats = require(game:GetService("ReplicatedStorage").constants.armorStats)
    local shopStats = require(game:GetService("ReplicatedStorage").constants.shopStats)

    spawn(function()
        while task.wait(0.15) do
            if EnergyFlask then
                pcall(function()
                    requestPurchase:FireServer(
                        "EnergyFlask",
                        "potion"
                    )
                    task.wait(0.1)
                end)
            end
            if HealthFlask then
                pcall(function()
                    requestPurchase:FireServer(
                        "HealthFlask",
                        "potion"
                    )
                    task.wait(0.1)
                end)
            end
            if DragonFlask then
                pcall(function()
                    requestPurchase:FireServer(
                        "DragonFlask",
                        "potion"
                    )
                    task.wait(0.1)
                end)
            end
        end
    end)


    spawn(function()
        while task.wait(0.15) do
            if AutoOpenChests then
                pcall(function()
                    for i,v in pairs(plrData:GetValue(game.Players.LocalPlayer, "ownedItems")) do
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

    spawn(function()
        while task.wait(0.15) do
            if UpgradeArmor then
                local success, err = pcall(function()
                    for i,v in pairs(plrData:GetValue(game.Players.LocalPlayer, "ownedItems")) do
                        if armorStats.values[i] and v.copies > 0 then
                            if (table.find(Armors, i) or table.find(Armors, "All")) and table.find(ArmorRarity, armorStats.values[i].rarity) then
                                if v.copies >= shopStats.tierCopiesCost[armorStats.values[i].rarity][v.tier+1] then
                                    requestPurchase:FireServer(
                                        i,
                                        "itemUpgrade",
                                        {
                                            upgradeTier = v.tier+1
                                        }
                                    )
                                    print(i, " Old Tier: "..v.tier, " New Tier: "..v.tier+1, " Rarity: "..armorStats.values[i].rarity)
                                    task.wait(UpgradeWeapon and 0.3 or 0.2)
                                end
                            end
                        end
                    end
                end)
                if not success then
                    warn("Upgrade Armor: "..err)
                end
            end
        end
    end)

    spawn(function()
        while task.wait(0.15) do
            if UpgradeWeapon then
                local success, err = pcall(function()
                    for i,v in pairs(plrData:GetValue(game.Players.LocalPlayer, "ownedItems")) do
                        if WpnStats.values[i] then
                            if (table.find(Weapons, i) or table.find(Weapons, "All")) and table.find(WeaponsRarity, WpnStats.values[i].rarity) then
                                -- print(i, shopStats.tierCopiesCost[WpnStats.values[i].rarity][v.tier+1])
                                if v.copies >= shopStats.tierCopiesCost[WpnStats.values[i].rarity][v.tier+1] then
                                    requestPurchase:FireServer(
                                        i,
                                        "itemUpgrade",
                                        {
                                            upgradeTier = v.tier + 1
                                        }
                                    )
                                    print(i, " Old Tier: "..v.tier, " New Tier: "..v.tier+1, " Rarity: "..WpnStats.values[i].rarity)
                                    task.wait(UpgradeArmor and 0.3 or 0.2)
                                end
                            end
                        end
                    end
                end)
                if not success then
                    warn("Upgrade Weapon: "..err)
                end
            end
        end
    end)
-- end)

-- if not Stabalize_success then
--     warn("Stabalizer: ",Stabalize_err)
-- end

-- FAIL SAFE --

spawn(function()
    while task.wait(0.15) do
        if KillAura or Autofarm or AutoUpgrade then
            pcall(function()
                for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.gameUI.Enemy:GetChildren()) do
                    if v:IsA("Frame") and v.Name ~= "Healthbar" and v.Visible and game:GetService("Players").LocalPlayer.PlayerGui.gameUI.HUD.stageMarker.stageUpdate.Visible then
                        GlobalFailSafe = true
                        repeat task.wait(0.15) until not v.Visible or not game:GetService("Players").LocalPlayer.PlayerGui.gameUI.HUD.stageMarker.stageUpdate.Visible
                        GlobalFailSafe = false
                    end
                end
            end)
        end
    end
end)
