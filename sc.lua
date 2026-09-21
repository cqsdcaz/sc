-- ============================================================
-- SERVICES / LOCALS
-- ============================================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MainGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Create Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 480)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Title (also the drag handle)
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
Title.BackgroundTransparency = 0.1
Title.Text = "ESP Menu  (drag me)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.SourceSansBold
Title.Active = true
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- ============ DRAG LOGIC ============
local dragging = false
local dragStart = nil
local startPos = nil

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
-- ============ END DRAG ============

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
CloseButton.BackgroundTransparency = 0.3
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 20
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)

-- ESP Toggle
local ESPLabel = Instance.new("TextLabel")
ESPLabel.Size = UDim2.new(0.8, 0, 0, 30)
ESPLabel.Position = UDim2.new(0.1, 0, 0.12, 10)
ESPLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
ESPLabel.BackgroundTransparency = 0.5
ESPLabel.Text = "ESP: OFF"
ESPLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPLabel.TextSize = 16
ESPLabel.Font = Enum.Font.SourceSans
ESPLabel.Parent = MainFrame

local ESPCorner = Instance.new("UICorner")
ESPCorner.CornerRadius = UDim.new(0, 5)
ESPCorner.Parent = ESPLabel

local ESPButton = Instance.new("TextButton")
ESPButton.Size = UDim2.new(0.8, 0, 0, 30)
ESPButton.Position = UDim2.new(0.1, 0, 0.12, 10)
ESPButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.BackgroundTransparency = 1
ESPButton.Text = ""
ESPButton.Parent = MainFrame

local espEnabled = false

-- ESP Color Picker
local ColorLabel = Instance.new("TextLabel")
ColorLabel.Size = UDim2.new(0.4, 0, 0, 30)
ColorLabel.Position = UDim2.new(0.1, 0, 0.22, 15)
ColorLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
ColorLabel.BackgroundTransparency = 0.5
ColorLabel.Text = "ESP Color"
ColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ColorLabel.TextSize = 16
ColorLabel.Font = Enum.Font.SourceSans
ColorLabel.Parent = MainFrame

local ColorCorner = Instance.new("UICorner")
ColorCorner.CornerRadius = UDim.new(0, 5)
ColorCorner.Parent = ColorLabel

local ColorFrame = Instance.new("Frame")
ColorFrame.Size = UDim2.new(0.35, 0, 0, 30)
ColorFrame.Position = UDim2.new(0.55, 0, 0.22, 15)
ColorFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
ColorFrame.BackgroundTransparency = 0.5
ColorFrame.Parent = MainFrame

local ColorCorner2 = Instance.new("UICorner")
ColorCorner2.CornerRadius = UDim.new(0, 5)
ColorCorner2.Parent = ColorFrame

local colorOptions = {
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(0, 150, 255),
    Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(170, 0, 255),
    Color3.fromRGB(255, 170, 0)
}

local selectedColor = colorOptions[1]
local colorIndex = 1

local ColorDisplay = Instance.new("Frame")
ColorDisplay.Size = UDim2.new(0.8, 0, 0.7, 0)
ColorDisplay.Position = UDim2.new(0.1, 0, 0.15, 0)
ColorDisplay.BackgroundColor3 = selectedColor
ColorDisplay.Parent = ColorFrame

local ColorCorner3 = Instance.new("UICorner")
ColorCorner3.CornerRadius = UDim.new(0, 5)
ColorCorner3.Parent = ColorDisplay

local ColorButton = Instance.new("TextButton")
ColorButton.Size = UDim2.new(1, 0, 1, 0)
ColorButton.Position = UDim2.new(0, 0, 0, 0)
ColorButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ColorButton.BackgroundTransparency = 1
ColorButton.Text = ""
ColorButton.Parent = ColorFrame

ColorButton.MouseButton1Click:Connect(function()
    colorIndex = colorIndex % #colorOptions + 1
    selectedColor = colorOptions[colorIndex]
    ColorDisplay.BackgroundColor3 = selectedColor
end)

-- ============ CUSTOM SPEED CONTROL ============
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.25, 0, 0, 30)
SpeedLabel.Position = UDim2.new(0.1, 0, 0.32, 20)
SpeedLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
SpeedLabel.BackgroundTransparency = 0.5
SpeedLabel.Text = "Speed:"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.TextSize = 16
SpeedLabel.Font = Enum.Font.SourceSans
SpeedLabel.Parent = MainFrame

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 5)
SpeedCorner.Parent = SpeedLabel

local SpeedInput = Instance.new("TextBox")
SpeedInput.Size = UDim2.new(0.25, 0, 0, 30)
SpeedInput.Position = UDim2.new(0.32, 0, 0.32, 20)
SpeedInput.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
SpeedInput.BackgroundTransparency = 0.5
SpeedInput.Text = "250"
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedInput.TextSize = 16
SpeedInput.Font = Enum.Font.SourceSans
SpeedInput.PlaceholderText = "Speed"
SpeedInput.ClearTextOnFocus = false
SpeedInput.Parent = MainFrame

local SpeedInputCorner = Instance.new("UICorner")
SpeedInputCorner.CornerRadius = UDim.new(0, 5)
SpeedInputCorner.Parent = SpeedInput

local ApplySpeedBtn = Instance.new("TextButton")
ApplySpeedBtn.Size = UDim2.new(0.2, 0, 0, 30)
ApplySpeedBtn.Position = UDim2.new(0.6, 0, 0.32, 20)
ApplySpeedBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
ApplySpeedBtn.BackgroundTransparency = 0.2
ApplySpeedBtn.Text = "Apply"
ApplySpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplySpeedBtn.TextSize = 14
ApplySpeedBtn.Font = Enum.Font.SourceSansBold
ApplySpeedBtn.Parent = MainFrame

local ApplySpeedCorner = Instance.new("UICorner")
ApplySpeedCorner.CornerRadius = UDim.new(0, 5)
ApplySpeedCorner.Parent = ApplySpeedBtn

local CurrentSpeedLabel = Instance.new("TextLabel")
CurrentSpeedLabel.Size = UDim2.new(0.8, 0, 0, 25)
CurrentSpeedLabel.Position = UDim2.new(0.1, 0, 0.40, 20)
CurrentSpeedLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
CurrentSpeedLabel.BackgroundTransparency = 0.5
CurrentSpeedLabel.Text = "Current Speed: 16"
CurrentSpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
CurrentSpeedLabel.TextSize = 14
CurrentSpeedLabel.Font = Enum.Font.SourceSans
CurrentSpeedLabel.Parent = MainFrame

local CurrentSpeedCorner = Instance.new("UICorner")
CurrentSpeedCorner.CornerRadius = UDim.new(0, 5)
CurrentSpeedCorner.Parent = CurrentSpeedLabel

local customSpeed = 250

local function applyCustomSpeed(speedValue)
    local num = tonumber(speedValue)
    if num and num > 0 and num <= 250 then
        customSpeed = num
        CurrentSpeedLabel.Text = "Current Speed: " .. string.format("%.1f", num)
        SpeedInput.Text = tostring(math.floor(num * 10) / 10)
        print("Speed set to: " .. num)
    else
        SpeedInput.Text = "Invalid!"
        task.wait(0.5)
        SpeedInput.Text = tostring(customSpeed)
    end
end

local presetSpeeds = {250, 25, 50, 100}
for i, speed in ipairs(presetSpeeds) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.18, 0, 0, 25)
    btn.Position = UDim2.new(0.06 + (i - 1) * 0.24, 0, 0.48, 20)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    btn.BackgroundTransparency = 0.3
    btn.Text = tostring(speed)
    btn.TextColor3 = Color3.fromRGB(200, 200, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = MainFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        applyCustomSpeed(speed)
    end)
end

local ResetSpeedBtn = Instance.new("TextButton")
ResetSpeedBtn.Size = UDim2.new(0.35, 0, 0, 25)
ResetSpeedBtn.Position = UDim2.new(0.32, 0, 0.56, 20)
ResetSpeedBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
ResetSpeedBtn.BackgroundTransparency = 0.2
ResetSpeedBtn.Text = "Reset to 16"
ResetSpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetSpeedBtn.TextSize = 12
ResetSpeedBtn.Font = Enum.Font.SourceSansBold
ResetSpeedBtn.Parent = MainFrame

local ResetSpeedCorner = Instance.new("UICorner")
ResetSpeedCorner.CornerRadius = UDim.new(0, 5)
ResetSpeedCorner.Parent = ResetSpeedBtn

ApplySpeedBtn.MouseButton1Click:Connect(function()
    applyCustomSpeed(SpeedInput.Text)
end)

SpeedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        applyCustomSpeed(SpeedInput.Text)
    end
end)

ResetSpeedBtn.MouseButton1Click:Connect(function()
    applyCustomSpeed(16)
end)

-- ============ TELEPORT TO MOUSE ============
local TeleportLabel = Instance.new("TextLabel")
TeleportLabel.Size = UDim2.new(0.8, 0, 0, 30)
TeleportLabel.Position = UDim2.new(0.1, 0, 0.62, 20)
TeleportLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
TeleportLabel.BackgroundTransparency = 0.5
TeleportLabel.Text = "Teleport: OFF"
TeleportLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportLabel.TextSize = 16
TeleportLabel.Font = Enum.Font.SourceSans
TeleportLabel.Parent = MainFrame

local TeleportCorner = Instance.new("UICorner")
TeleportCorner.CornerRadius = UDim.new(0, 5)
TeleportCorner.Parent = TeleportLabel

local TeleportButton = Instance.new("TextButton")
TeleportButton.Size = UDim2.new(0.8, 0, 0, 30)
TeleportButton.Position = UDim2.new(0.1, 0, 0.62, 20)
TeleportButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.BackgroundTransparency = 1
TeleportButton.Text = ""
TeleportButton.Parent = MainFrame

local teleportEnabled = false
TeleportButton.MouseButton1Click:Connect(function()
    teleportEnabled = not teleportEnabled
    TeleportLabel.Text = "Teleport: " .. (teleportEnabled and "ON" or "OFF")
    print("[TP] Enabled:", teleportEnabled)
end)

local function getRoot(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("Torso")
end

local function teleportToMouse()
    if not teleportEnabled then
        print("[TP] Disabled")
        return
    end

    local char = LocalPlayer.Character
    if not char then return end

    local hrp = getRoot(char)
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid or humanoid.Health <= 0 then return end

    local camera = workspace.CurrentCamera
    if not camera then return end

    local mousePos = UserInputService:GetMouseLocation()
    local unitRay = camera:ViewportPointToRay(mousePos.X, mousePos.Y)

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {char}
    params.IgnoreWater = true

    local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 2000, params)

    local targetPos
    if result then
        targetPos = result.Position
        print("[TP] Hit:", result.Instance:GetFullName(), targetPos)
    else
        targetPos = unitRay.Origin + unitRay.Direction * 500
        print("[TP] No hit, using fallback:", targetPos)
    end

    local finalPos = targetPos + Vector3.new(0, 3, 0)

    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    hrp.CFrame = CFrame.new(finalPos)

    print("[TP] Moved to:", finalPos)
end
-- ============ END TELEPORT SECTION ============

-- ============ KEYBINDS ============
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

    -- Only block when the speed textbox is focused
    if gameProcessed and UserInputService:GetFocusedTextBox() then return end

    if input.KeyCode == Enum.KeyCode.R then
        teleportToMouse()
    elseif input.KeyCode == Enum.KeyCode.F1 then
        ScreenGui.Enabled = not ScreenGui.Enabled
        print("[GUI] Visible:", ScreenGui.Enabled)
    end
end)

-- ============ ESP SYSTEM ============
local espObjects = {}

local function createESP(player)
    if player == LocalPlayer then return end
    local character = player.Character
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    if espObjects[player] then return end

    local highlight = Instance.new("Highlight")
    highlight.FillColor = selectedColor
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = selectedColor
    highlight.OutlineTransparency = 0.3
    highlight.Adornee = character
    highlight.Parent = character

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.Adornee = head
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.Parent = head

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = selectedColor
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Parent = billboard

    espObjects[player] = {
        highlight = highlight,
        billboard = billboard,
        nameLabel = nameLabel
    }
end

local function removeESP(player)
    local esp = espObjects[player]
    if esp then
        if esp.highlight then esp.highlight:Destroy() end
        if esp.billboard then esp.billboard:Destroy() end
        espObjects[player] = nil
    end
end

local function updateAllESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if espEnabled and player.Character then
                if espObjects[player] then
                    local esp = espObjects[player]
                    if esp.highlight then
                        esp.highlight.FillColor = selectedColor
                        esp.highlight.OutlineColor = selectedColor
                    end
                    if esp.nameLabel then
                        esp.nameLabel.TextColor3 = selectedColor
                        local dist = 0
                        local myChar = LocalPlayer.Character
                        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                        local theirRoot = player.Character:FindFirstChild("HumanoidRootPart")
                        if myRoot and theirRoot then
                            dist = math.floor((myRoot.Position - theirRoot.Position).Magnitude)
                        end
                        esp.nameLabel.Text = player.Name .. " (" .. dist .. "m)"
                    end
                else
                    createESP(player)
                end
            else
                removeESP(player)
            end
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if espEnabled then
            task.wait(0.2)
            createESP(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

ESPButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ESPLabel.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    if not espEnabled then
        for player, _ in pairs(espObjects) do
            removeESP(player)
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                createESP(player)
            end
        end
    end
end)

ColorButton.MouseButton1Click:Connect(function()
    for _, esp in pairs(espObjects) do
        if esp.highlight then
            esp.highlight.FillColor = selectedColor
            esp.highlight.OutlineColor = selectedColor
        end
        if esp.nameLabel then
            esp.nameLabel.TextColor3 = selectedColor
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(0.5)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = customSpeed
        CurrentSpeedLabel.Text = "Current Speed: " .. string.format("%.1f", customSpeed)
    end
end)

RunService.RenderStepped:Connect(function()
    updateAllESP()

    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.WalkSpeed ~= customSpeed then
            humanoid.WalkSpeed = customSpeed
        end
    end
end)

-- Keybind indicator
local KeybindLabel = Instance.new("TextLabel")
KeybindLabel.Size = UDim2.new(1, 0, 0, 25)
KeybindLabel.Position = UDim2.new(0, 0, 1, -30)
KeybindLabel.BackgroundTransparency = 1
KeybindLabel.Text = "F1: hide/show | R: teleport | Drag title bar to move"
KeybindLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
KeybindLabel.TextSize = 11
KeybindLabel.Font = Enum.Font.SourceSans
KeybindLabel.Parent = MainFrame
