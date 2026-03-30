return function(Load)
    if not Load then return end
    if game.CoreGui:FindFirstChild("Animation") then
        game.CoreGui.Animation:Destroy()
    end

    local Animation = Instance.new("ScreenGui")
    local Frame1 = Instance.new("ImageLabel")
    local LoadButton = Instance.new("TextButton")
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

    Animation.Name = "Animation"
    Animation.Parent = game.CoreGui
    Animation.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Frame1.Name = "Frame1"
    Frame1.Parent = Animation
    Frame1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame1.BackgroundTransparency = 1.000
    Frame1.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame1.BorderSizePixel = 0
    Frame1.Position = UDim2.new(0.384999961, 0, 0.266000003, 0)
    Frame1.Size = UDim2.new(0, 432, 0, 265)
    Frame1.ZIndex = 5
    Frame1.Image = "rbxassetid://116342860199829"

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
    Frame2.Parent = Animation
    Frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame2.BackgroundTransparency = 1.000
    Frame2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame2.BorderSizePixel = 0
    Frame2.Position = UDim2.new(0.384999961, 0, 0.266000003, 0)
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
    Frame1.Size = UDim2.new(0,0,0,265)

    Frame2.Size = UDim2.new(0,0,0,265)
    Frame2.Position = UDim2.new(0.662, 0, 0.266, 0)

    for i,v in pairs(Frame1:GetChildren()) do
        if not v:IsA("UIGradient") and not v:IsA("UICorner") then
            v.Visible = false
        end
    end

    task.wait(1.5)

    local TweenService = game:GetService("TweenService")
    --{0.624, 0},{0.266, 0} -- Start Frame2 Pos
    --{0.385, 0},{0.266, 0} -- End Frame2 Pos

    local Speed = 1

    TweenService:Create(
        Frame1,
        TweenInfo.new(Speed, Enum.EasingStyle.Quad),
        {Size = UDim2.new(0, 432, 0, 265)}
    ):Play()

    -- task.wait(0.4)

    local Tween = TweenService:Create(
        Frame2,
        TweenInfo.new(Speed, Enum.EasingStyle.Quad),
        {Size = UDim2.new(0, 432, 0, 265)}
    )

    Tween:Play()
    TweenService:Create(
        Frame2,
        TweenInfo.new(Speed, Enum.EasingStyle.Quad),
        {Position = UDim2.new(0.385, 0, 0.266, 0)}
    ):Play()

    task.wait(0.2)

    TweenService:Create(
        Frame2,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad),
        {ImageTransparency = 0}
    ):Play()

    TweenService:Create(
        Frame1,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad),
        {ImageTransparency = 0}
    ):Play()


    Tween.Completed:Wait()

    for i,v in pairs(Frame1:GetChildren()) do
        if not v:IsA("UIGradient") and not v:IsA("UICorner") then
            v.Visible = true
        end
    end

    function LoadLine()
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

    LoadLine()

    LoadButton.MouseButton1Click:Connect(function()
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

        TweenService:Create(
            Frame1,
            TweenInfo.new(Speed, Enum.EasingStyle.Quad),
            {Size = UDim2.new(0,0,0,265)}
        ):Play()

        -- task.wait(0.4)

        local Tween = TweenService:Create(
            Frame2,
            TweenInfo.new(Speed, Enum.EasingStyle.Quad),
            {Size = UDim2.new(0,0,0,265)}
        )

        Tween:Play()
        TweenService:Create(
            Frame2,
            TweenInfo.new(Speed, Enum.EasingStyle.Quad),
            {Position = UDim2.new(0.662, 0, 0.266, 0)}
        ):Play()

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
    end)

    repeat task.wait() until not game.CoreGui:FindFirstChild("Animation")
end
