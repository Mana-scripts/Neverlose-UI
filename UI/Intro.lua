-- loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Mana-scripts/Neverlose-UI/refs/heads/main/Utility.lua"))()

function LoadGui(options)
    local KeySystem = options.KeySystem or false
    local Load = options.Load or true
    local Key = options.Key
    local KeyPath = options.KeyPath
    local Can_Load = false
    local oldkey

    if not Load then return end

    if game.CoreGui:FindFirstChild("Animation") then
        game.CoreGui.Animation:Destroy()
    end

    local Animation = Instance.new("ScreenGui")
    local HolderFrame = Instance.new("Frame")
    local Frame1 = Instance.new("ImageLabel")
    local LoadButton = Instance.new("TextButton")
    LoadButton.Visible = false
    local LoadButtonCorner = Instance.new("UICorner")
    local LoadButtonTextSizeConstraint = Instance.new("UITextSizeConstraint")
    local LoadingLine = Instance.new("Frame")
    local LoadingLineCorner = Instance.new("UICorner")
    local LoadingLineIndicator = Instance.new("Frame")
    local LoadingLineIndicatorCorner = Instance.new("UICorner")
    local UIGradient = Instance.new("UIGradient")
    local UIGradient_2 = Instance.new("UIGradient")
    local UICorner = Instance.new("UICorner")
    local Frame2 = Instance.new("ImageLabel")
    local UIGradient_3 = Instance.new("UIGradient")
    local UICorner_2 = Instance.new("UICorner")

    local TweenService = game:GetService("TweenService")

    
    if not isfile(KeyPath) then
        writefile(KeyPath, "")
        oldkey = ""
    else
        oldkey = readfile(KeyPath)
    end

    Animation.Name = "Animation"
    Animation.Parent = game.CoreGui
    Animation.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    HolderFrame.Name = "HolderFrame"
    HolderFrame.Parent = Animation
    HolderFrame.BackgroundColor3 = Color3.fromRGB(0, 16, 35)
    HolderFrame.BackgroundTransparency = 1
    HolderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    HolderFrame.BorderSizePixel = 0
    HolderFrame.ClipsDescendants = true
    HolderFrame.Position = UDim2.new(0.384467274, 0, 0.265765756, 0)
    HolderFrame.Size = UDim2.new(0, 432, 0, 278)
    HolderFrame.ZIndex = 999999999

    Frame1.Name = "Frame1"
    Frame1.Parent = HolderFrame
    Frame1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame1.BackgroundTransparency = 1.000
    Frame1.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame1.BorderSizePixel = 0
    Frame1.Position = UDim2.new(-0.9, 0, 0, 0)
    Frame1.Size = UDim2.new(0, 432, 0, 265)
    Frame1.ZIndex = 5
    Frame1.Image = "rbxassetid://116342860199829"

    if KeySystem then
        local KeyBox = Instance.new("TextBox")
        local UICorner = Instance.new("UICorner")
        local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
        KeyBox.Name = "KeyBox"
        KeyBox.Parent = Frame1
        KeyBox.BackgroundColor3 = Color3.fromRGB(6, 0, 52)
        KeyBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
        KeyBox.BorderSizePixel = 0 --UDim2.new(0.291815996, 0, 0.791022062, 0)
        KeyBox.Position = UDim2.new(0.268518507, 0, 0.791022062, 0)
        KeyBox.Size = UDim2.new(0, 200, 0, 37)
        KeyBox.Font = Enum.Font.SourceSans
        KeyBox.PlaceholderColor3 = Color3.fromRGB(127, 127, 127)
        KeyBox.PlaceholderText = "Paste Key Here!"
        KeyBox.Text = ""
        KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        KeyBox.TextScaled = true
        KeyBox.TextSize = 14.000
        KeyBox.TextWrapped = true

        UICorner.CornerRadius = UDim.new(0, 3)
        UICorner.Parent = KeyBox

        UITextSizeConstraint.Parent = KeyBox
        UITextSizeConstraint.MaxTextSize = 17

        function Unload_Key_Holder()
            TweenService:Create(
                KeyBox,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 1}
            ):Play()

            TweenService:Create(
                KeyBox,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad),
                {TextTransparency = 1}
            ):Play()
        end

        if string.lower(oldkey) == Key:lower() then
            HolderFrame.BackgroundTransparency = 1
            Unload_Key_Holder()
            task.wait(0.5)
            Can_Load = true
        end

        KeyBox:GetPropertyChangedSignal("Text"):Connect(function()
            local Value = string.lower(KeyBox.Text)
            if (Value == tostring(Key:lower()) or KeyBox.Text == tostring(Key)) and not Can_Load then
                writefile(KeyPath, Key:lower())
                Unload_Key_Holder()
                task.wait(0.5)
                Can_Load = true
            end
        end)
        
        KeyBox.FocusLost:Connect(function(ep)
            local Value = string.lower(KeyBox.Text)
            print("Hi", Value)
            if Value ~= tostring(Key:lower()) and not Can_Load then
                getgenv().UtilityModule:Notify({
                    Title = "Key System",
                    Duration = 5,
                    Description = "Incorrect Key Please get key from https://discord.gg/8TnBzn63sJ",
                    Gradient = {
                        Color1 = Color3.fromRGB(73, 203, 243),
                        Color2 = Color3.fromRGB(194, 102, 238)
                    }
                })
                KeyBox.Text = "https://discord.gg/8TnBzn63sJ"
                spawn(function()
                    KeyBox.ClearTextOnFocus = false
                    task.wait(4)
                    KeyBox.ClearTextOnFocus = true
                end)
                setclipboard("https://discord.gg/8TnBzn63sJ")
            end
        end)

    else
        Can_Load = true
    end

    LoadButton.Name = "LoadButton"
    LoadButton.Parent = Frame1
    LoadButton.BackgroundColor3 = Color3.fromRGB(6, 0, 52)
    LoadButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LoadButton.BorderSizePixel = 0
    LoadButton.Position = UDim2.new(0.381123006, 0, 0.855709553, 0)
    LoadButton.Size = UDim2.new(0, 101, 0, 30)
    LoadButton.AutoButtonColor = false
    LoadButton.Font = Enum.Font.SourceSans
    LoadButton.Text = "LOAD"
    LoadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadButton.TextScaled = true
    LoadButton.TextSize = 14.000
    LoadButton.TextWrapped = true

    LoadButton.BackgroundTransparency = 1
    LoadButton.TextTransparency = 1

    LoadButtonCorner.CornerRadius = UDim.new(0, 5)
    LoadButtonCorner.Name = "LoadButtonCorner"
    LoadButtonCorner.Parent = LoadButton

    LoadButtonTextSizeConstraint.Name = "LoadButtonTextSizeConstraint"
    LoadButtonTextSizeConstraint.Parent = LoadButton
    LoadButtonTextSizeConstraint.MaxTextSize = 20

    LoadingLine.Name = "LoadingLine"
    LoadingLine.Parent = Frame1
    LoadingLine.BackgroundColor3 = Color3.fromRGB(6, 0, 52)
    LoadingLine.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LoadingLine.BorderSizePixel = 0
    LoadingLine.Position = UDim2.new(0.291815996, 0, 0.791022062, 0)
    LoadingLine.Size = UDim2.new(0, 179, 0, 3)
    LoadingLine.BackgroundTransparency = 1

    LoadingLineCorner.CornerRadius = UDim.new(0, 10)
    LoadingLineCorner.Name = "LoadingLineCorner"
    LoadingLineCorner.Parent = LoadingLine

    LoadingLineIndicator.Name = "LoadingLineIndicator"
    LoadingLineIndicator.Parent = LoadingLine
    LoadingLineIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LoadingLineIndicator.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LoadingLineIndicator.BorderSizePixel = 0
    LoadingLineIndicator.Position = UDim2.new(-6.81957033e-07, 0, 0, 0)
    LoadingLineIndicator.Size = UDim2.new(0, 0, 1, 0)

    LoadingLineIndicatorCorner.CornerRadius = UDim.new(0, 10)
    LoadingLineIndicatorCorner.Name = "LoadingLineIndicatorCorner"
    LoadingLineIndicatorCorner.Parent = LoadingLineIndicator

    UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(73, 203, 243)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(194, 102, 238))}
    UIGradient.Parent = LoadingLineIndicator

    UIGradient_2.Rotation = 45
    UIGradient_2.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(0.50, 0.00), NumberSequenceKeypoint.new(0.50, 1.00), NumberSequenceKeypoint.new(1.00, 1.00)}
    UIGradient_2.Parent = Frame1

    UICorner.CornerRadius = UDim.new(0, 3)
    UICorner.Parent = Frame1

    Frame2.Name = "Frame2"
    Frame2.Parent = HolderFrame
    Frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame2.BackgroundTransparency = 1.000
    Frame2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame2.BorderSizePixel = 0
    Frame2.Position = UDim2.new(0.9, 0, 0, 0)
    Frame2.Size = UDim2.new(0, 432, 0, 265)
    Frame2.Image = "rbxassetid://116342860199829"

    UIGradient_3.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(0.33, Color3.fromRGB(234, 234, 234)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(234, 234, 234))}
    UIGradient_3.Rotation = 45
    UIGradient_3.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(0.50, 1.00), NumberSequenceKeypoint.new(0.50, 0.00), NumberSequenceKeypoint.new(1.00, 0.00)}
    UIGradient_3.Parent = Frame2

    UICorner_2.CornerRadius = UDim.new(0, 3)
    UICorner_2.Parent = Frame2
        
    Frame1.ImageTransparency = 1
    Frame2.ImageTransparency = 1
    -- Frame1.Size = UDim2.new(0,0,0,265)

    -- Frame2.Size = UDim2.new(0,0,0,265)
    -- Frame2.Position = UDim2.new(0.662, 0, 0.266, 0)

    for i,v in pairs(Frame1:GetChildren()) do
        if not v:IsA("UIGradient") and not v:IsA("UICorner") then
            v.Visible = false
        end
    end

    --{0.624, 0},{0.266, 0} -- Start Frame2 Pos
    --{0.385, 0},{0.266, 0} -- End Frame2 Pos
    spawn(function()
        local Speed = 0.4
        task.wait(0.15)
        TweenService:Create(
            Frame2,
            TweenInfo.new(Speed, Enum.EasingStyle.Quad),
            {ImageTransparency = 0}
        ):Play()

        TweenService:Create(
            Frame1,
            TweenInfo.new(Speed, Enum.EasingStyle.Quad),
            {ImageTransparency = 0}
        ):Play()
    end)

    local Speed = 0.5

    -- TweenService:Create(
    --     Frame1,
    --     TweenInfo.new(Speed, Enum.EasingStyle.Quad),
    --     {Size = UDim2.new(0, 432, 0, 265)}
    -- ):Play()

    -- -- task.wait(0.4)

    -- local Tween = TweenService:Create(
    --     Frame2,
    --     TweenInfo.new(Speed, Enum.EasingStyle.Quad),
    --     {Size = UDim2.new(0, 432, 0, 265)}
    -- )

    -- Tween:Play()
    local Tween = TweenService:Create(
        Frame2,
        TweenInfo.new(Speed, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
        {Position = UDim2.new(0, 0, 0, 0)}
    )
    Tween:Play()

    TweenService:Create(
        Frame1,
        TweenInfo.new(Speed, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
        {Position = UDim2.new(0, 0, 0, 0)}
    ):Play()

    -- task.wait(0.2)

    -- spawn(function()
    --     task.wait(0.1)
    --     TweenService:Create(
    --         HolderFrame,
    --         TweenInfo.new(0.3, Enum.EasingStyle.Quad),
    --         {BackgroundTransparency = 0}
    --     ):Play()
    -- end)

    Tween.Completed:Wait()

    for i,v in pairs(Frame1:GetChildren()) do
        if not v:IsA("UIGradient") and not v:IsA("UICorner") then
            v.Visible = true
        end
    end

    LoadButton.Visible = false

    function LoadLine()
        TweenService:Create(
            LoadingLine,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad),
            {BackgroundTransparency = 0}
        ):Play()
        TweenService:Create(
            LoadingLineIndicator,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad),
            {Size = UDim2.new(0.33, 0, 1, 0)}
        ):Play()
        task.wait(0.8)
        TweenService:Create(
            LoadingLineIndicator,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad),
            {Size = UDim2.new(0.33+0.33, 0, 1, 0)}
        ):Play()
        task.wait(0.4)
        local Tween_Line = TweenService:Create(
            LoadingLineIndicator,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad),
            {Size = UDim2.new(1, 0, 1, 0)}
        )
        Tween_Line:Play()
        Tween_Line.Completed:Wait()
        TweenService:Create(
            LoadButton,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad),
            {BackgroundTransparency = 0}
        ):Play()

        TweenService:Create(
            LoadButton,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad),
            {TextTransparency = 0}
        ):Play()
    end

    repeat task.wait() until Can_Load == true

    LoadLine()

    function Unload()
        HolderFrame.ClipsDescendants = false
        TweenService:Create(
            LoadButton,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad),
            {BackgroundTransparency = 1}
        ):Play()

        TweenService:Create(
            LoadButton,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad),
            {TextTransparency = 1}
        ):Play()

        TweenService:Create(
            LoadingLine,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad),
            {BackgroundTransparency = 1}
        ):Play()

        TweenService:Create(
            LoadingLineIndicator,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad),
            {BackgroundTransparency = 1}
        ):Play()

        task.wait(0.3)

        local Speed = 0.6

        local Tween = TweenService:Create(
            Frame2,
            TweenInfo.new(Speed, Enum.EasingStyle.Back),
            {Position = UDim2.new(0.3, 0, 0, 0)}
        )

        TweenService:Create(
            Frame1,
            TweenInfo.new(Speed, Enum.EasingStyle.Back),
            {Position = UDim2.new(-0.3, 0, 0, 0)}
        ):Play()

        Tween:Play()

        TweenService:Create(
            Frame1,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad),
            {ImageTransparency = 1}
        ):Play()

        TweenService:Create(
            Frame2,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad),
            {ImageTransparency = 1}
        ):Play()

        Tween.Completed:Wait()

        Animation:Destroy()
    end
    -- local Loading = false
    -- LoadButton.MouseButton1Click:Connect(function()
    --     Loading = true
    --     Unload()
    -- end)

    task.wait(.2)
    Unload()
    
    spawn(function()
        task.wait(6.7)
        if Loading then return end
        Unload()
    end)

    repeat task.wait() until not game.CoreGui:FindFirstChild("Animation")

end

local Example = false

if Example then
    LoadGui({
        Load = Example,
        Key = "Hello",
        KeyPath = "Qyrix/Utility/Key.txt"
    })
end

return function(options)
    LoadGui(options)
end
