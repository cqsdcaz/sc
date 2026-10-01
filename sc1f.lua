-- Combined Script: Ultimate Hub [Fixed Speed Buttons & ESP]
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Services
local runService = game:GetService("RunService")
local lighting = game:GetService("Lighting")
local teleportService = game:GetService("TeleportService")
local userInputService = game:GetService("UserInputService")
local soundService = game:GetService("SoundService")
local httpService = game:GetService("HttpService")
local playersService = game:GetService("Players")

-- ============================================
-- CONFIGURATION & SAVE SYSTEM (SOUNDS)
-- ============================================
local CONFIG_FILE = "FruitFinder_Config.json"

local config = {
    SelectedSound = "Chime",
    Volume = 1.0
}

local soundOptions = {
    ["Chime"] = "rbxassetid://4590657391",
    ["Bell"] = "rbxassetid://129496339606661",
    ["Beep"] = "rbxassetid://232127900"
}

local function saveConfig()
    if writefile then
        pcall(function()
            writefile(CONFIG_FILE, httpService:JSONEncode(config))
        end)
    end
end

local function loadConfig()
    if readfile and pcall(function() readfile(CONFIG_FILE) end) then
        local success, result = pcall(function()
            return httpService:JSONDecode(readfile(CONFIG_FILE))
        end)
        if success and type(result) == "table" then
            if result.SelectedSound and soundOptions[result.SelectedSound] then
                config.SelectedSound = result.SelectedSound
            end
            if type(result.Volume) == "number" then
                config.Volume = math.clamp(result.Volume, 0.1, 2.0)
            end
        end
    end
end

loadConfig()

local function playAlertSound()
    local soundId = soundOptions[config.SelectedSound] or soundOptions["Chime"]
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = config.Volume
    sound.Parent = soundService
    sound:Play()
    
    task.delay(2, function()
        if sound then sound:Destroy() end
    end)
end

-- ============================================
-- FRUIT TARGET & ISLAND DEFINITIONS
-- ============================================
local OLD_FRUIT_NAME = "Fruit"

local targetFruitNames = {
    "Spin Fruit", "Rocket Fruit", "Blade Fruit", "Spring Fruit", "Bomb Fruit",
    "Smoke Fruit", "Spike Fruit", "Flame Fruit", "Ice Fruit", "Sand Fruit",
    "Dark Fruit", "Diamond Fruit", "Light Fruit", "Rubber Fruit", "Barrier Fruit",
    "Ghost Fruit", "Magma Fruit", "Quake Fruit", "Buddha Fruit", "Love Fruit",
    "Creation Fruit", "Spider Fruit", "Sound Fruit", "Phoenix Fruit", "Portal Fruit",
    "Pain Fruit", "Rumble Fruit", "Blizzard Fruit", "Gravity Fruit", "Mammoth Fruit",
    "T-Rex Fruit", "Dough Fruit", "Shadow Fruit", "Venom Fruit", "Control Fruit",
    "Gas Fruit", "Spirit Fruit", "Leopard Fruit", "Yeti Fruit", "Kitsune Fruit",
    "Dragon Fruit"
}

local islandDefinitions = {
    {Name = "Boat Castle", Path = "Boat Castle"},
    {Name = "CakeLoaf", Path = "CakeLoaf"},
    {Name = "CandyCane", Path = "CandyCane"},
    {Name = "ChocolateIsland", Path = "ChocolateIsland"},
    {Name = "Great Tree", Path = "Great Tree"},
    {Name = "Haunted Castle", Path = "Haunted Castle"},
    {Name = "Ice Cream Island", Path = "Ice Cream Island"},
    {Name = "Peanut Island", Path = "Peanut Island"},
    {Name = "Port", Path = "Port"},
    {Name = "TikiOutpost", Path = "TikiOutpost"},
    {Name = "Mansion", Path = "Map.Turtle.IslandModel.Mansion"},
    {Name = "Hot", Path = "Map.CircleIsland"},
    {Name = "Darkarena", Path = "Map.DarkbeardArena"},
    {Name = "Mainson", Path = "Map.Dressrosa"},
    {Name = "ForgottenIsland", Path = "Map.ForgottenIsland"},
    {Name = "GraveIsland", Path = "Map.GraveIsland"},
    {Name = "Dock3", Path = "Map.GreenBit"},
    {Name = "IceCastle", Path = "Map.IceCastle"},
    {Name = "SnowMountain", Path = "Map.SnowMountain"},
    {Name = "remote", Path = "Map.Mini1"}
}

-- ============================================
-- CREATE MASTER GUI & DRAGGABLE LOGIC
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MasterControlGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

local toggleGuiButton = Instance.new("TextButton")
toggleGuiButton.Size = UDim2.new(0, 50, 0, 50)
toggleGuiButton.Position = UDim2.new(0, 10, 0, 10)
toggleGuiButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
toggleGuiButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleGuiButton.Text = "⚙️"
toggleGuiButton.TextScaled = true
toggleGuiButton.Font = Enum.Font.GothamBold
toggleGuiButton.BackgroundTransparency = 0.2
toggleGuiButton.BorderSizePixel = 2
toggleGuiButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
toggleGuiButton.Parent = screenGui

local mainFrame = Instance.new("ScrollingFrame")
mainFrame.Size = UDim2.new(0, 440, 0, 750)
mainFrame.Position = UDim2.new(0.5, -220, 0.5, -375)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(100, 100, 150)
mainFrame.Active = true
mainFrame.ScrollBarThickness = 8
mainFrame.CanvasSize = UDim2.new(0, 0, 0, 1150)
mainFrame.Parent = screenGui

-- Custom Smooth Draggable Implementation
local dragging, dragInput, dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

userInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
titleLabel.BackgroundTransparency = 0.1
titleLabel.Text = "🍎 Ultimate Hub [F1 to Hide]"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

-- ============================================
-- SECTION 1: PLAYER UTILITIES (Speed, TP, Player ESP)
-- ============================================
local pHeader = Instance.new("TextLabel")
pHeader.Size = UDim2.new(0.9, 0, 0, 25)
pHeader.Position = UDim2.new(0.05, 0, 0, 48)
pHeader.BackgroundTransparency = 1
pHeader.Text = "--- Player Utilities & ESP ---"
pHeader.TextColor3 = Color3.fromRGB(150, 200, 255)
pHeader.TextScaled = true
pHeader.Font = Enum.Font.GothamBold
pHeader.Parent = mainFrame

-- Player ESP Toggle & Color
local espPlayerButton = Instance.new("TextButton")
espPlayerButton.Size = UDim2.new(0.42, 0, 0, 30)
espPlayerButton.Position = UDim2.new(0.05, 0, 0, 78)
espPlayerButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
espPlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espPlayerButton.Text = "Player ESP: OFF"
espPlayerButton.TextScaled = true
espPlayerButton.Font = Enum.Font.GothamBold
espPlayerButton.Parent = mainFrame

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

local colorButton = Instance.new("TextButton")
colorButton.Size = UDim2.new(0.42, 0, 0, 30)
colorButton.Position = UDim2.new(0.53, 0, 0, 78)
colorButton.BackgroundColor3 = selectedColor
colorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
colorButton.Text = "ESP Color"
colorButton.TextScaled = true
colorButton.Font = Enum.Font.GothamBold
colorButton.Parent = mainFrame

-- Speed Presets Header
local speedHeaderLbl = Instance.new("TextLabel")
speedHeaderLbl.Size = UDim2.new(0.9, 0, 0, 20)
speedHeaderLbl.Position = UDim2.new(0.05, 0, 0, 115)
speedHeaderLbl.BackgroundTransparency = 1
speedHeaderLbl.Text = "Select Speed Multiplier:"
speedHeaderLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
speedHeaderLbl.TextScaled = true
speedHeaderLbl.Font = Enum.Font.Gotham
speedHeaderLbl.Parent = mainFrame

local currentSpeedLbl = Instance.new("TextLabel")
currentSpeedLbl.Size = UDim2.new(0.9, 0, 0, 20)
currentSpeedLbl.Position = UDim2.new(0.05, 0, 0, 212)
currentSpeedLbl.BackgroundTransparency = 1
currentSpeedLbl.Text = "Current Speed: 16"
currentSpeedLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
currentSpeedLbl.TextScaled = true
currentSpeedLbl.Font = Enum.Font.Gotham
currentSpeedLbl.Parent = mainFrame

-- Custom Speed Input & Apply Setup (Declared early so presets can access it)
local customSpeed = 16
local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0.42, 0, 0, 30)
speedInput.Position = UDim2.new(0.05, 0, 0, 175)
speedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.PlaceholderText = "Custom Speed"
speedInput.TextScaled = true
speedInput.Font = Enum.Font.Gotham
speedInput.Parent = mainFrame

local applySpeedBtn = Instance.new("TextButton")
applySpeedBtn.Size = UDim2.new(0.42, 0, 0, 30)
applySpeedBtn.Position = UDim2.new(0.53, 0, 0, 175)
applySpeedBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
applySpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applySpeedBtn.Text = "Set Custom"
applySpeedBtn.TextScaled = true
applySpeedBtn.Font = Enum.Font.GothamBold
applySpeedBtn.Parent = mainFrame

local function applyCustomSpeed(val)
    local num = tonumber(val)
    if num and num > 0 and num <= 1000 then
        customSpeed = num
        currentSpeedLbl.Text = "Current Speed: " .. num
        speedInput.Text = tostring(num)
        if humanoid then humanoid.WalkSpeed = num end
    else
        speedInput.Text = "Invalid!"
        task.wait(0.5)
        speedInput.Text = tostring(customSpeed)
    end
end

applySpeedBtn.MouseButton1Click:Connect(function()
    applyCustomSpeed(speedInput.Text)
end)

speedInput.FocusLost:Connect(function(enter)
    if enter then applyCustomSpeed(speedInput.Text) end
end)

-- Speed Preset Buttons (35x, 50x, 100x, 150x, 250x)
local speeds = {35, 50, 100, 150, 250}
local speedButtonWidth = 0.16
for i, spd in ipairs(speeds) do
    local spdBtn = Instance.new("TextButton")
    spdBtn.Size = UDim2.new(speedButtonWidth, 0, 0, 28)
    spdBtn.Position = UDim2.new(0.05 + ((i - 1) * 0.178), 0, 0, 140)
    spdBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    spdBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    spdBtn.Text = spd .. "x"
    spdBtn.TextScaled = true
    spdBtn.Font = Enum.Font.GothamBold
    spdBtn.Parent = mainFrame
    
    spdBtn.MouseButton1Click:Connect(function()
        applyCustomSpeed(spd)
    end)
end

-- Teleport to Mouse Toggle / Button
local tpMouseBtn = Instance.new("TextButton")
tpMouseBtn.Size = UDim2.new(0.9, 0, 0, 30)
tpMouseBtn.Position = UDim2.new(0.05, 0, 0, 238)
tpMouseBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 150)
tpMouseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpMouseBtn.Text = "Teleport to Mouse: OFF [Press R]"
tpMouseBtn.TextScaled = true
tpMouseBtn.Font = Enum.Font.GothamBold
tpMouseBtn.Parent = mainFrame

local sep1 = Instance.new("Frame")
sep1.Size = UDim2.new(0.9, 0, 0, 2)
sep1.Position = UDim2.new(0.05, 0, 0, 278)
sep1.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
sep1.Parent = mainFrame

-- ============================================
-- SECTION 2: SOUND SETTINGS (Saved configs)
-- ============================================
local soundHeader = Instance.new("TextLabel")
soundHeader.Size = UDim2.new(0.9, 0, 0, 25)
soundHeader.Position = UDim2.new(0.05, 0, 0, 290)
soundHeader.BackgroundTransparency = 1
soundHeader.Text = "--- Alert Sound Settings (Auto-Saved) ---"
soundHeader.TextColor3 = Color3.fromRGB(255, 200, 100)
soundHeader.TextScaled = true
soundHeader.Font = Enum.Font.GothamBold
soundHeader.Parent = mainFrame

local soundChoiceBtn = Instance.new("TextButton")
soundChoiceBtn.Size = UDim2.new(0.42, 0, 0, 30)
soundChoiceBtn.Position = UDim2.new(0.05, 0, 0, 320)
soundChoiceBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
soundChoiceBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
soundChoiceBtn.Text = "Sound: " .. config.SelectedSound
soundChoiceBtn.TextScaled = true
soundChoiceBtn.Font = Enum.Font.GothamBold
soundChoiceBtn.Parent = mainFrame

local testSoundBtn = Instance.new("TextButton")
testSoundBtn.Size = UDim2.new(0.42, 0, 0, 30)
testSoundBtn.Position = UDim2.new(0.53, 0, 0, 320)
testSoundBtn.BackgroundColor3 = Color3.fromRGB(180, 120, 0)
testSoundBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
testSoundBtn.Text = "▶ Test Sound"
testSoundBtn.TextScaled = true
testSoundBtn.Font = Enum.Font.GothamBold
testSoundBtn.Parent = mainFrame

local volInput = Instance.new("TextBox")
volInput.Size = UDim2.new(0.9, 0, 0, 30)
volInput.Position = UDim2.new(0.05, 0, 0, 358)
volInput.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
volInput.TextColor3 = Color3.fromRGB(255, 255, 255)
volInput.Text = tostring(config.Volume)
volInput.PlaceholderText = "Volume (0.1 - 2.0)"
volInput.TextScaled = true
volInput.Font = Enum.Font.Gotham
volInput.Parent = mainFrame

local sep2 = Instance.new("Frame")
sep2.Size = UDim2.new(0.9, 0, 0, 2)
sep2.Position = UDim2.new(0.05, 0, 0, 398)
sep2.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
sep2.Parent = mainFrame

-- ============================================
-- SECTION 3: FRUIT FINDER & WORLD TOOLS
-- ============================================
local fruitHeader = Instance.new("TextLabel")
fruitHeader.Size = UDim2.new(0.9, 0, 0, 25)
fruitHeader.Position = UDim2.new(0.05, 0, 0, 410)
fruitHeader.BackgroundTransparency = 1
fruitHeader.Text = "--- Fruit Finder & World ---"
fruitHeader.TextColor3 = Color3.fromRGB(100, 255, 150)
fruitHeader.TextScaled = true
fruitHeader.Font = Enum.Font.GothamBold
fruitHeader.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 22)
statusLabel.Position = UDim2.new(0.05, 0, 0, 438)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Idle"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

local refreshButton = Instance.new("TextButton")
refreshButton.Size = UDim2.new(0.42, 0, 0, 30)
refreshButton.Position = UDim2.new(0.05, 0, 0, 465)
refreshButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
refreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
refreshButton.Text = "🔄 Refresh Fruits"
refreshButton.TextScaled = true
refreshButton.Font = Enum.Font.GothamBold
refreshButton.Parent = mainFrame

local autoRefreshButton = Instance.new("TextButton")
autoRefreshButton.Size = UDim2.new(0.42, 0, 0, 30)
autoRefreshButton.Position = UDim2.new(0.53, 0, 0, 465)
autoRefreshButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
autoRefreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoRefreshButton.Text = "⏱️ AUTO: ON"
autoRefreshButton.TextScaled = true
autoRefreshButton.Font = Enum.Font.GothamBold
autoRefreshButton.Parent = mainFrame

local distanceLabel = Instance.new("TextLabel")
distanceLabel.Size = UDim2.new(0.9, 0, 0, 22)
distanceLabel.Position = UDim2.new(0.05, 0, 0, 500)
distanceLabel.BackgroundTransparency = 1
distanceLabel.Text = "Target: None | Distance: N/A"
distanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
distanceLabel.TextScaled = true
distanceLabel.Font = Enum.Font.Gotham
distanceLabel.Parent = mainFrame

local fruitEspButton = Instance.new("TextButton")
fruitEspButton.Size = UDim2.new(0.42, 0, 0, 30)
fruitEspButton.Position = UDim2.new(0.05, 0, 0, 528)
fruitEspButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
fruitEspButton.TextColor3 = Color3.fromRGB(255, 255, 255)
fruitEspButton.Text = "Fruit ESP: OFF"
fruitEspButton.TextScaled = true
fruitEspButton.Font = Enum.Font.GothamBold
fruitEspButton.Parent = mainFrame

local fogButton = Instance.new("TextButton")
fogButton.Size = UDim2.new(0.42, 0, 0, 30)
fogButton.Position = UDim2.new(0.53, 0, 0, 528)
fogButton.BackgroundColor3 = Color3.fromRGB(0, 100, 100)
fogButton.TextColor3 = Color3.fromRGB(255, 255, 255)
fogButton.Text = "FOG: OFF"
fogButton.TextScaled = true
fogButton.Font = Enum.Font.GothamBold
fogButton.Parent = mainFrame

-- Fruit List Panel
local fruitListFrame = Instance.new("Frame")
fruitListFrame.Size = UDim2.new(0.9, 0, 0, 180)
fruitListFrame.Position = UDim2.new(0.05, 0, 0, 565)
fruitListFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
fruitListFrame.BackgroundTransparency = 0.5
fruitListFrame.BorderSizePixel = 1
fruitListFrame.Parent = mainFrame

local fruitList = Instance.new("ScrollingFrame")
fruitList.Size = UDim2.new(1, -10, 1, -10)
fruitList.Position = UDim2.new(0, 5, 0, 5)
fruitList.BackgroundTransparency = 1
fruitList.ScrollBarThickness = 6
fruitList.CanvasSize = UDim2.new(0, 0, 0, 0)
fruitList.Parent = fruitListFrame

-- Server Stats & Join Utility
local serverLabel = Instance.new("TextLabel")
serverLabel.Size = UDim2.new(0.9, 0, 0, 20)
serverLabel.Position = UDim2.new(0.05, 0, 0, 755)
serverLabel.BackgroundTransparency = 1
serverLabel.Text = "Server ID: Loading..."
serverLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
serverLabel.TextScaled = true
serverLabel.Font = Enum.Font.Gotham
serverLabel.Parent = mainFrame

local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0.42, 0, 0, 30)
copyButton.Position = UDim2.new(0.05, 0, 0, 780)
copyButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.Text = "📋 Copy Server ID"
copyButton.TextScaled = true
copyButton.Font = Enum.Font.GothamBold
copyButton.Parent = mainFrame

local joinInput = Instance.new("TextBox")
joinInput.Size = UDim2.new(0.42, 0, 0, 30)
joinInput.Position = UDim2.new(0.53, 0, 0, 780)
joinInput.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
joinInput.TextColor3 = Color3.fromRGB(255, 255, 255)
joinInput.PlaceholderText = "Paste JobID"
joinInput.TextScaled = true
joinInput.Font = Enum.Font.Gotham
joinInput.Parent = mainFrame

local joinButton = Instance.new("TextButton")
joinButton.Size = UDim2.new(0.9, 0, 0, 30)
joinButton.Position = UDim2.new(0.05, 0, 0, 815)
joinButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
joinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
joinButton.Text = "🚀 Join Server ID"
joinButton.TextScaled = true
joinButton.Font = Enum.Font.GothamBold
joinButton.Parent = mainFrame

local serverStatusLabel = Instance.new("TextLabel")
serverStatusLabel.Size = UDim2.new(0.9, 0, 0, 20)
serverStatusLabel.Position = UDim2.new(0.05, 0, 0, 850)
serverStatusLabel.BackgroundTransparency = 1
serverStatusLabel.Text = ""
serverStatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
serverStatusLabel.TextScaled = true
serverStatusLabel.Font = Enum.Font.Gotham
serverStatusLabel.Parent = mainFrame

-- ============================================
-- SCRIPT LOGIC & STATE VARIABLES
-- ============================================
local teleportEnabled = false
local playerEspEnabled = false
local fruitEspEnabled = false
local fogRemovalEnabled = false
local savedBaseAtmosphere = nil

local targetFruit = nil
local allFruits = {}
local fruitButtons = {}
local islands = {}
local islandObjects = {}
local autoRefreshEnabled = true
local autoRefreshConnection = nil
local lastFruitCheck = 0
local espObjects = {}

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    rootPart = newChar:WaitForChild("HumanoidRootPart")
    humanoid.WalkSpeed = customSpeed
end)

tpMouseBtn.MouseButton1Click:Connect(function()
    teleportEnabled = not teleportEnabled
    tpMouseBtn.Text = "Teleport to Mouse: " .. (teleportEnabled and "ON" or "OFF") .. " [Press R]"
end)

local function getRoot(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
end

local function teleportToMouse()
    if not teleportEnabled then return end
    local char = player.Character
    if not char then return end
    local hrp = getRoot(char)
    if not hrp then return end

    local camera = workspace.CurrentCamera
    if not camera then return end

    local mousePos = userInputService:GetMouseLocation()
    local unitRay = camera:ViewportPointToRay(mousePos.X, mousePos.Y)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {char}
    params.IgnoreWater = true

    local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 2500, params)
    local targetPos = result and result.Position or (unitRay.Origin + unitRay.Direction * 300)
    hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
end

-- ============================================
-- PLAYER ESP LOGIC (Always Visible)
-- ============================================
local playerEspTable = {}

local function createPlayerESP(p)
    if p == player or playerEspTable[p] then return end
    local char = p.Character
    if not char then return end
    local head = char:FindFirstChild("Head") or getRoot(char)
    if not head then return end

    local highlight = Instance.new("Highlight")
    highlight.FillColor = selectedColor
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = selectedColor
    highlight.OutlineTransparency = 0.2
    highlight.Adornee = char
    highlight.Parent = char

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 150, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = head
    billboard.Parent = head

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = p.Name
    nameLabel.TextColor3 = selectedColor
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0.3
    nameLabel.Parent = billboard

    playerEspTable[p] = {highlight = highlight, billboard = billboard, nameLabel = nameLabel}
end

local function removePlayerESP(p)
    if playerEspTable[p] then
        if playerEspTable[p].highlight then playerEspTable[p].highlight:Destroy() end
        if playerEspTable[p].billboard then playerEspTable[p].billboard:Destroy() end
        playerEspTable[p] = nil
    end
end

espPlayerButton.MouseButton1Click:Connect(function()
    playerEspEnabled = not playerEspEnabled
    espPlayerButton.Text = "Player ESP: " .. (playerEspEnabled and "ON" or "OFF")
    espPlayerButton.BackgroundColor3 = playerEspEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(0, 100, 200)
    
    if not playerEspEnabled then
        for p, _ in pairs(playerEspTable) do removePlayerESP(p) end
    end
end)

colorButton.MouseButton1Click:Connect(function()
    colorIndex = colorIndex % #colorOptions + 1
    selectedColor = colorOptions[colorIndex]
    colorButton.BackgroundColor3 = selectedColor
    for _, esp in pairs(playerEspTable) do
        if esp.highlight then
            esp.highlight.FillColor = selectedColor
            esp.highlight.OutlineColor = selectedColor
        end
        if esp.nameLabel then esp.nameLabel.TextColor3 = selectedColor end
    end
end)

soundChoiceBtn.MouseButton1Click:Connect(function()
    if config.SelectedSound == "Chime" then
        config.SelectedSound = "Bell"
    elseif config.SelectedSound == "Bell" then
        config.SelectedSound = "Beep"
    else
        config.SelectedSound = "Chime"
    end
    soundChoiceBtn.Text = "Sound: " .. config.SelectedSound
    saveConfig()
end)

testSoundBtn.MouseButton1Click:Connect(playAlertSound)

volInput.FocusLost:Connect(function()
    local val = tonumber(volInput.Text)
    if val then
        config.Volume = math.clamp(val, 0.1, 2.0)
        volInput.Text = tostring(config.Volume)
        saveConfig()
    else
        volInput.Text = tostring(config.Volume)
    end
end)

local function getIslandFromPath(path)
    local current = workspace
    for part in string.gmatch(path, "[^%.]+") do
        if current then current = current:FindFirstChild(part) else break end
    end
    return current
end

local function getIslandPositions()
    islands = {}
    for _, islandDef in pairs(islandDefinitions) do
        local island = getIslandFromPath(islandDef.Path)
        if island then
            local pos = nil
            if island:IsA("BasePart") then pos = island.Position
            elseif island:IsA("Model") then
                pos = island.PrimaryPart and island.PrimaryPart.Position
                if not pos then
                    for _, p in pairs(island:GetDescendants()) do
                        if p:IsA("BasePart") then pos = p.Position; break end
                    end
                end
            end
            if pos then table.insert(islands, {Name = islandDef.Name, Position = pos}) end
        end
    end
    return islands
end

local function findClosestIsland(position)
    if not position then return "Unknown" end
    local closest, minDist = "Unknown", math.huge
    for _, island in pairs(islands) do
        local dist = (position - island.Position).Magnitude
        if dist < minDist then minDist = dist; closest = island.Name end
    end
    return closest
end

local function getPartPosition(obj)
    if obj:IsA("BasePart") then return obj.Position
    elseif obj:IsA("Model") then
        if obj.PrimaryPart then return obj.PrimaryPart.Position end
        for _, p in pairs(obj:GetDescendants()) do if p:IsA("BasePart") then return p.Position end end
    elseif obj:IsA("Tool") then
        local handle = obj:FindFirstChild("Handle")
        if handle and handle:IsA("BasePart") then return handle.Position end
    end
    return nil
end

local function findAllFruits()
    local fruits = {}
    local container = workspace:FindFirstChild("Fruit ")
    if container then
        for _, obj in pairs(container:GetChildren()) do
            if obj.Name == OLD_FRUIT_NAME then
                local pos = getPartPosition(obj)
                if pos then table.insert(fruits, {Object = obj, Position = pos, Name = "🍎 [Container]", Island = findClosestIsland(pos)}) end
            end
        end
    end
    for _, name in ipairs(targetFruitNames) do
        local obj = workspace:FindFirstChild(name)
        if obj then
            local pos = getPartPosition(obj)
            if pos then table.insert(fruits, {Object = obj, Position = pos, Name = "🍎 " .. name, Island = findClosestIsland(pos)}) end
        end
    end
    return fruits
end

local function createFruitESP(fData)
    if not fData or not fData.Position then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = fData.Object

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, 0, 1, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = fData.Name .. " (" .. fData.Island .. ")"
    nameLbl.TextColor3 = Color3.fromRGB(255, 255, 0)
    nameLbl.TextScaled = true
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.Parent = billboard
    table.insert(espObjects, {billboard = billboard})
end

local function clearFruitESP()
    for _, esp in pairs(espObjects) do
        if esp.billboard then esp.billboard:Destroy() end
    end
    espObjects = {}
end

fruitEspButton.MouseButton1Click:Connect(function()
    fruitEspEnabled = not fruitEspEnabled
    fruitEspButton.Text = fruitEspEnabled and "Fruit ESP: ON" or "Fruit ESP: OFF"
    fruitEspButton.BackgroundColor3 = fruitEspEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(0, 100, 200)
    if fruitEspEnabled then
        for _, f in pairs(allFruits) do createFruitESP(f) end
    else
        clearFruitESP()
    end
end)

local function updateFruitList()
    getIslandPositions()
    for _, btn in pairs(fruitButtons) do btn:Destroy() end
    fruitButtons = {}

    local prevCount = #allFruits
    allFruits = findAllFruits()
    if #allFruits > prevCount then playAlertSound() end

    if #allFruits == 0 then
        local noFruit = Instance.new("TextLabel")
        noFruit.Size = UDim2.new(1, 0, 0, 30)
        noFruit.BackgroundTransparency = 1
        noFruit.Text = "❌ No fruits found"
        noFruit.TextColor3 = Color3.fromRGB(255, 100, 100)
        noFruit.TextScaled = true
        noFruit.Parent = fruitList
        table.insert(fruitButtons, noFruit)
        fruitList.CanvasSize = UDim2.new(0, 0, 0, 30)
        return
    end

    local y = 0
    for _, fData in pairs(allFruits) do
        local dist = (fData.Position - rootPart.Position).Magnitude
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.Position = UDim2.new(0, 5, 0, y)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Text = string.format("%s | %.0fm | 🏝️ %s", fData.Name, dist, fData.Island)
        btn.TextScaled = true
        btn.Font = Enum.Font.Gotham
        btn.Parent = fruitList

        btn.MouseButton1Click:Connect(function()
            targetFruit = fData
            distanceLabel.Text = string.format("Target: %s | Distance: %.0fm", fData.Name, dist)
            statusLabel.Text = "Status: Target locked!"
        end)
        table.insert(fruitButtons, btn)
        y = y + 35
    end
    fruitList.CanvasSize = UDim2.new(0, 0, 0, y + 10)
end

refreshButton.MouseButton1Click:Connect(updateFruitList)

autoRefreshButton.MouseButton1Click:Connect(function()
    autoRefreshEnabled = not autoRefreshEnabled
    autoRefreshButton.Text = autoRefreshEnabled and "⏱️ AUTO: ON" or "⏱ AUTO: OFF"
end)

serverLabel.Text = "Server ID: " .. (game.JobId ~= "" and game.JobId or "Private")
copyButton.MouseButton1Click:Connect(function()
    pcall(function() setclipboard(game.JobId) end)
    serverStatusLabel.Text = "✅ Copied JobId!"
end)

joinButton.MouseButton1Click:Connect(function()
    if joinInput.Text ~= "" then
        teleportService:TeleportToPlaceInstance(game.PlaceId, joinInput.Text, player)
    end
end)

fogButton.MouseButton1Click:Connect(function()
    fogRemovalEnabled = not fogRemovalEnabled
    fogButton.Text = fogRemovalEnabled and "FOG: ON" or "FOG: OFF"
    fogButton.BackgroundColor3 = fogRemovalEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(0, 100, 100)
    local atmosphere = lighting:FindFirstChild("BaseAtmosphere")
    if fogRemovalEnabled and atmosphere then
        savedBaseAtmosphere = atmosphere
        atmosphere.Parent = nil
    elseif not fogRemovalEnabled and savedBaseAtmosphere then
        savedBaseAtmosphere.Parent = lighting
    end
end)

-- Key Shortcut Listener
userInputService.InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.F1 then
        screenGui.Enabled = not screenGui.Enabled
    elseif input.KeyCode == Enum.KeyCode.R then
        if teleportEnabled then
            teleportToMouse()
        end
    end
end)

toggleGuiButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

runService.RenderStepped:Connect(function()
    if humanoid and humanoid.WalkSpeed ~= customSpeed then
        humanoid.WalkSpeed = customSpeed
    end

    if playerEspEnabled then
        for _, p in pairs(playersService:GetPlayers()) do
            if p ~= player then
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    createPlayerESP(p)
                    local espData = playerEspTable[p]
                    if espData and espData.nameLabel and rootPart then
                        local dist = (p.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                        espData.nameLabel.Text = string.format("%s [%.0fm]", p.Name, dist)
                    end
                else
                    removePlayerESP(p)
                end
            end
        end
    else
        for p, _ in pairs(playerEspTable) do removePlayerESP(p) end
    end

    local now = tick()
    if autoRefreshEnabled and now - lastFruitCheck > 0.5 then
        lastFruitCheck = now
        updateFruitList()
    end
end)

updateFruitList()
print("Ultimate Hub Fully Loaded!")
