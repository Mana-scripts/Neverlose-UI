local Module = {}

function Module:Discord(code)
    local req = (syn and syn.request) or (http and http.request) or http_request
    pcall(function()
        if req then
            req({
                Url = 'http://127.0.0.1:6463/rpc?v=1',
                Method = 'POST',
                Headers = {
                    ['Content-Type'] = 'application/json',
                    Origin = 'https://discord.com'
                },
                Body = game:GetService('HttpService'):JSONEncode({
                    cmd = 'INVITE_BROWSER',
                    nonce = game:GetService('HttpService'):GenerateGUID(false),
                    args = {code = code}
                })
            })
        else
            if setclipboard then
                setclipboard(tostring(code))
            end
        end
    end)
end

Module.HubName = "Qyrix"
Module.Loader = false

Module.Library = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Mana-scripts/Neverlose-UI/refs/heads/main/UI/Woof.lua"))
Module.Visual_Loader = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Mana-scripts/Neverlose-UI/refs/heads/main/UI/Intro.lua"))

function Module:waitForCondition(time, conditionFunc)
    spawn(function()
        local waited = 0
        local success = false

        -- Wait up to 5 seconds
        while waited < time do
            if conditionFunc() then
                success = true
                break
            end
            task.wait(0.1)  -- check every 0.1s
            waited = waited + 0.1
        end

        if success then
            -- Condition became true
            getgenv().UtilityModule:Notify({
                Title = "Success",
                Duration = 3,
                Description = "Condition met!"
            })
        else
            getgenv().UtilityModule:Notify({
                Title = "Error",
                Duration = 3,
                Description = "Rejoining Game: HttpError"
            })
            task.wait(3.1)
            -- Condition never became true → Rejoin the game
            game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
        end
    end)
end

function Module:TapSimulatorRemoteBypass()
    local tables = {}
    for _, obj in pairs(getgc(true)) do
        if typeof(obj) == "table" then
            table.insert(tables, obj)
        end
    end
    print("-------------------------------- \n")
    local EventsFolder, FunctionsFolder, Remotes = nil, nil, {}
    for i, v in pairs(tables) do
        local success, err = pcall(function()
            if v.OpenEgg and type(v) == "table" then
                for i, v in pairs(v) do
                    if v.Remote and v.Name and typeof(v.Remote) == "Instance" and type(v) == "table" then
                        if v.Folder.Name == "Functions" then
                            v.Remote.Name = v.Name
                            FunctionsFolder = v.Folder
                        end
                        
                        if v.Folder.Name == "Events" then
                            v.Remote.Name = v.Name
                            EventsFolder = v.Folder
                        end

                        for i,v in pairs(v.Folder:GetChildren()) do
                            Remotes[v.Name] = v
                        end
                    end
                end
            end
        end)
        if not success then
            -- print(err)
        end
    end
    
    for i,v in pairs(Remotes) do
        print(i,v)
    end
    Remotes.Tap:FireServer(true, nil, true)

  return EventsFolder, FunctionsFolder, Remotes
end


local NotificationsFrame
local NotificationsGUI

if not game.CoreGui:FindFirstChild("NotificationsGUI") then
    NotificationsGUI = Instance.new("ScreenGui")
    NotificationsGUI.Name = "NotificationsGUI"
    NotificationsGUI.Parent = game.CoreGui
    local UIListLayout = Instance.new("UIListLayout")
    NotificationsFrame = Instance.new("Frame")
    NotificationsFrame.Name = "NotificationsFrame"
    NotificationsFrame.Parent = NotificationsGUI
    NotificationsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NotificationsFrame.BackgroundTransparency = 1.000
    NotificationsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NotificationsFrame.BorderSizePixel = 0
    NotificationsFrame.Position = UDim2.new(0.796178341, 0, 0.0210396033, 0)
    NotificationsFrame.Size = UDim2.new(0.200000003, 0, 0.95792079, 0)

    UIListLayout.Parent = NotificationsFrame
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

else
    NotificationsGUI = game.CoreGui:FindFirstChild("NotificationsGUI")
    NotificationsFrame = game.CoreGui.NotificationsGUI:FindFirstChild("NotificationsFrame")
end

function Module:Notify(options)
    local NotifyTabel = {Done = false}
    
    local optionsTitle = options.Title
	local optionsDuration = options.Duration
	local optionsDescription = options.Description

    local FakeNotificationFrame = Instance.new("Frame")
    local NotificationFrame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local Description = Instance.new("TextLabel")
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
    local Title = Instance.new("TextLabel")
    local UITextSizeConstraint_2 = Instance.new("UITextSizeConstraint")
    local Time = Instance.new("TextLabel")
    local UITextSizeConstraint_3 = Instance.new("UITextSizeConstraint")
    local TimeFrame = Instance.new("Frame")
    local UICorner_2 = Instance.new("UICorner")

    FakeNotificationFrame.Name = game:GetService("HttpService"):GenerateGUID(false) --"FakeNotificationFrame"
    FakeNotificationFrame.Parent = NotificationsFrame
    FakeNotificationFrame.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
    FakeNotificationFrame.BackgroundTransparency = 1.000
    FakeNotificationFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    FakeNotificationFrame.BorderSizePixel = 0
    FakeNotificationFrame.Position = UDim2.new(0.221116528, 0, 0, 0)
    FakeNotificationFrame.Size = UDim2.new(0.778883398, 0, 0.1, 0)
    local NotificationSize = FakeNotificationFrame.Size
    FakeNotificationFrame.Size = UDim2.new(0, 0, NotificationSize.Y.Scale, 0)

    NotificationFrame.Name = "NotificationFrame"
    NotificationFrame.Parent = FakeNotificationFrame
    NotificationFrame.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
    NotificationFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NotificationFrame.BorderSizePixel = 0
    NotificationFrame.Size = UDim2.new(1, 0, 0.875252903, 0)

    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = NotificationFrame

    Description.Name = "Description"
    Description.Parent = NotificationFrame
    Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Description.BackgroundTransparency = 1.000
    Description.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Description.BorderSizePixel = 0
    Description.Position = UDim2.new(0.0695570484, 0, 0.431457043, 0)
    Description.Size = UDim2.new(0.740449429, 0, 0.552676737, 0)
    Description.Font = Enum.Font.SourceSans
    Description.Text = "1/5M pet hatched. Sending to webhook"
    Description.TextColor3 = Color3.fromRGB(111, 111, 111)
    Description.TextScaled = true
    Description.TextSize = 14.000
    Description.TextWrapped = true
    Description.TextXAlignment = Enum.TextXAlignment.Left

    UITextSizeConstraint.Parent = Description
    UITextSizeConstraint.MaxTextSize = 14

    Title.Name = "Title"
    Title.Parent = NotificationFrame
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1.000
    Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Title.BorderSizePixel = 0
    Title.Position = UDim2.new(0.0656917691, 0, -0.0209217351, 0)
    Title.Size = UDim2.new(0.744314611, 0, 0.430012733, 0)
    Title.Font = Enum.Font.SourceSans
    Title.Text = "System"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextScaled = true
    Title.TextSize = 14.000
    Title.TextWrapped = true
    Title.TextXAlignment = Enum.TextXAlignment.Left

    UITextSizeConstraint_2.Parent = Title
    UITextSizeConstraint_2.MaxTextSize = 17

    Time.Name = "Time"
    Time.Parent = NotificationFrame
    Time.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Time.BackgroundTransparency = 1.000
    Time.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Time.BorderSizePixel = 0
    Time.Position = UDim2.new(0.892708302, 0, -0.0209217779, 0)
    Time.Size = UDim2.new(0.0942330807, 0, 0.318181932, 0)
    Time.Font = Enum.Font.SourceSans
    Time.Text = "1"
    Time.TextColor3 = Color3.fromRGB(111, 111, 111)
    Time.TextScaled = true
    Time.TextSize = 14.000
    Time.TextWrapped = true
    
    UITextSizeConstraint_3.Parent = Time
    UITextSizeConstraint_3.MaxTextSize = 17

    TimeFrame.Name = "TimeFrame"
    TimeFrame.Parent = NotificationFrame
    TimeFrame.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
    TimeFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TimeFrame.BorderSizePixel = 0
    TimeFrame.Position = UDim2.new(0, 0, 1.04999995, 0)
    TimeFrame.Size = UDim2.new(1, 0, 0, 11)
    TimeFrame.Visible = false

    UICorner_2.CornerRadius = UDim.new(0, 10)
    UICorner_2.Parent = TimeFrame

    -- Start Settings -- 

    NotificationFrame.BackgroundTransparency = 1
    Title.TextTransparency = 1
    Description.TextTransparency = 1
    Time.TextTransparency = 1
    print(optionsDescription, optionsTitle, optionsDuration)
    Description.Text = optionsDescription
    Title.Text = optionsTitle
    Time.Text = optionsDuration

    local TweenService = game:GetService("TweenService")

    spawn(function()
        TweenService:Create(
			NotificationFrame,
			TweenInfo.new(0.3, Enum.EasingStyle.Quad),
			{BackgroundTransparency = 0}
		):Play()
		TweenService:Create(
			FakeNotificationFrame,
			TweenInfo.new(0.3, Enum.EasingStyle.Quad),
			{Size = NotificationSize}
		):Play()
		for i,v in pairs(NotificationFrame:GetChildren()) do
			if v:IsA("TextLabel") then
				TweenService:Create(
					v,
					TweenInfo.new(0.3, Enum.EasingStyle.Quad),
					{TextTransparency = 0}
				):Play()
			end
		end
    end)

    spawn(function()
        repeat task.wait(1)
			Time.Text = optionsDuration
			optionsDuration = optionsDuration - 1
			if tonumber(Time.Text) < 0 then
				Time.Text = 0
				NotifyTabel.Done = true
			end
		until optionsDuration == optionsDuration - 1 or NotifyTabel.Done
		TweenService:Create(
			FakeNotificationFrame,
			TweenInfo.new(0.3, Enum.EasingStyle.Quad),
			{Size = UDim2.new(0, 0, FakeNotificationFrame.Size.Y.Scale, 0)}
		):Play()
		for i,v in pairs(NotificationFrame:GetChildren()) do
			if v:IsA("TextLabel") then
				TweenService:Create(
					v,
					TweenInfo.new(0.3, Enum.EasingStyle.Quad),
					{TextTransparency = 1}
				):Play()
			end
		end
		TweenService:Create(
			NotificationFrame,
			TweenInfo.new(0.3, Enum.EasingStyle.Quad),
			{BackgroundTransparency = 1}
		):Play()
		task.wait(0.3)
		TweenService:Create(
			FakeNotificationFrame,
			TweenInfo.new(0.3, Enum.EasingStyle.Quad),
			{Size = UDim2.new(0, 0, 0, -1)}
		):Play()
		
		repeat task.wait() until FakeNotificationFrame.Size == UDim2.new(0, 0, 0, -1)
		task.wait(0.2)
		FakeNotificationFrame:Destroy()
    end)

    function Example()
        Notify_Test:Notify({
            Title = "Test!",
            Duration = 5,
            Description = "Hello world!",
        })
    end

    -- Example()

    return {
        Tabel = NotifyTabel,
        Instance = FakeNotificationFrame
    }
end

if not getgenv().Qyrix_Loaded then
    getgenv().Qyrix_Loaded = {
        Loaded = true
    }
end

Module:Notify({
    Title = Module.HubName,
    Duration = 5,
    Description = "Welcome "..game.Players.LocalPlayer.Name.."!"
})

Module:Notify({
    Title = Module.HubName,
    Duration = 6,
    Description = "Loading Script!"
})

return Module
