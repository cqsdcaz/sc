-- LocalScript for GUI - Fixed: only detects workspace.Fruit
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Services
local runService = game:GetService("RunService")
local lighting = game:GetService("Lighting")
local teleportService = game:GetService("TeleportService")
local userInputService = game:GetService("UserInputService")

-- ============================================
-- FRUIT TARGET
-- ============================================
-- EXACT name. Change to "Fruit1" etc. if the real fruits are numbered.
local FRUIT_NAME = "Fruit"

-- Island Definitions
local islandDefinitions = {
    {Name = "Boat Castle", Path = "Boat Castle"},
    {Name = "CakeLoaf", Path = "CakeLoaf"},
    {Name = "CandyCane", Path = "CandyCane"},
    {Name = "ChocolateIsland", Path = "ChocolateIsland"},
    {Name = "Great Tree", Path = "Great Tree"},
    {Name = "Haunted Castle", Path = "Haunted Castle"},
    {Name = "Ice Cream Island", Path = "Ice Cream Island"},
    {Name = "Peanut Island", Path = "Peanut I-- Combined Script: Ultimate Hub [Fixed Speed Buttons & ESP]
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
print("Ultimate Hub Fully Loaded!")sland"},
    {Name = "Port", Path = "Port"},
    {Name = "TikiOutpost", Path = "TikiOutpost"},
    {Name = "Mansion", Path = "Map.Turtle.IslandModel.Mansion"}
}

-- Blacklist (stub - HttpService has no GetAsync/SetAsync, that was DataStore)
local blacklist = {}

-- ============================================
-- CREATE GUI
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FruitGUI"
screenGui.Parent = player.PlayerGui

local toggleGuiButton = Instance.new("TextButton")
toggleGuiButton.Size = UDim2.new(0, 50, 0, 50)
toggleGuiButton.Position = UDim2.new(0, 10, 0, 10)
toggleGuiButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
toggleGuiButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleGuiButton.Text = "🍎"
toggleGuiButton.TextScaled = true
toggleGuiButton.Font = Enum.Font.GothamBold
toggleGuiButton.BackgroundTransparency = 0.2
toggleGuiButton.BorderSizePixel = 2
toggleGuiButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
toggleGuiButton.Parent = screenGui

local mainFrame = Instance.new("ScrollingFrame")
mainFrame.Size = UDim2.new(0, 420, 0, 640)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -320)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ScrollBarThickness = 8
mainFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
mainFrame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🍎 Fruit Finder"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 40)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Idle"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 60, 0, 25)
speedLabel.Position = UDim2.new(0, 10, 0, 70)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed:"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = mainFrame

local speedSlider = Instance.new("TextBox")
speedSlider.Size = UDim2.new(0, 80, 0, 25)
speedSlider.Position = UDim2.new(0, 80, 0, 70)
speedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
speedSlider.Text = "50"
speedSlider.TextScaled = true
speedSlider.Font = Enum.Font.Gotham
speedSlider.ClearTextOnFocus = false
speedSlider.Parent = mainFrame

local speedUnitLabel = Instance.new("TextLabel")
speedUnitLabel.Size = UDim2.new(0, 40, 0, 25)
speedUnitLabel.Position = UDim2.new(0, 165, 0, 70)
speedUnitLabel.BackgroundTransparency = 1
speedUnitLabel.Text = "studs/s"
speedUnitLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedUnitLabel.TextScaled = true
speedUnitLabel.Font = Enum.Font.Gotham
speedUnitLabel.Parent = mainFrame

local refreshButton = Instance.new("TextButton")
refreshButton.Size = UDim2.new(0, 60, 0, 25)
refreshButton.Position = UDim2.new(0, 210, 0, 70)
refreshButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
refreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
refreshButton.Text = "🔄"
refreshButton.TextScaled = true
refreshButton.Font = Enum.Font.GothamBold
refreshButton.Parent = mainFrame

local autoRefreshButton = Instance.new("TextButton")
autoRefreshButton.Size = UDim2.new(0, 80, 0, 25)
autoRefreshButton.Position = UDim2.new(0, 275, 0, 70)
autoRefreshButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
autoRefreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoRefreshButton.Text = "⏱️ AUTO ON"
autoRefreshButton.TextScaled = true
autoRefreshButton.Font = Enum.Font.GothamBold
autoRefreshButton.Parent = mainFrame

local distanceLabel = Instance.new("TextLabel")
distanceLabel.Size = UDim2.new(1, -20, 0, 25)
distanceLabel.Position = UDim2.new(0, 10, 0, 100)
distanceLabel.BackgroundTransparency = 1
distanceLabel.Text = "Target: None | Distance: N/A | Island: -"
distanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
distanceLabel.TextScaled = true
distanceLabel.Font = Enum.Font.Gotham
distanceLabel.Parent = mainFrame

local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0, 100, 0, 30)
espButton.Position = UDim2.new(0, 10, 0, 130)
espButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.Text = "ESP: OFF"
espButton.TextScaled = true
espButton.Font = Enum.Font.GothamBold
espButton.Parent = mainFrame

local frogButton = Instance.new("TextButton")
frogButton.Size = UDim2.new(0, 100, 0, 30)
frogButton.Position = UDim2.new(0, 120, 0, 130)
frogButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
frogButton.TextColor3 = Color3.fromRGB(255, 255, 255)
frogButton.Text = "🐸 FROG"
frogButton.TextScaled = true
frogButton.Font = Enum.Font.GothamBold
frogButton.Parent = mainFrame

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 100, 0, 30)
toggleButton.Position = UDim2.new(0, 230, 0, 130)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "START"
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = mainFrame

local fruitListFrame = Instance.new("Frame")
fruitListFrame.Size = UDim2.new(1, -20, 0, 200)
fruitListFrame.Position = UDim2.new(0, 10, 0, 170)
fruitListFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
fruitListFrame.BackgroundTransparency = 0.5
fruitListFrame.BorderSizePixel = 1
fruitListFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
fruitListFrame.Parent = mainFrame

local fruitListLabel = Instance.new("TextLabel")
fruitListLabel.Size = UDim2.new(1, 0, 0, 25)
fruitListLabel.BackgroundTransparency = 1
fruitListLabel.Text = "🍎 Fruits Found:"
fruitListLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fruitListLabel.TextScaled = true
fruitListLabel.Font = Enum.Font.GothamBold
fruitListLabel.Parent = fruitListFrame

local fruitList = Instance.new("ScrollingFrame")
fruitList.Size = UDim2.new(1, -10, 1, -30)
fruitList.Position = UDim2.new(0, 5, 0, 25)
fruitList.BackgroundTransparency = 1
fruitList.ScrollBarThickness = 6
fruitList.CanvasSize = UDim2.new(0, 0, 0, 0)
fruitList.Parent = fruitListFrame

local separator = Instance.new("Frame")
separator.Size = UDim2.new(0.9, 0, 0, 2)
separator.Position = UDim2.new(0.05, 0, 0, 378)
separator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
separator.BackgroundTransparency = 0.5
separator.Parent = mainFrame

local startTimeLabel = Instance.new("TextLabel")
startTimeLabel.Size = UDim2.new(0.9, 0, 0, 20)
startTimeLabel.Position = UDim2.new(0.05, 0, 0, 385)
startTimeLabel.BackgroundTransparency = 1
startTimeLabel.Text = "Server Started: Loading..."
startTimeLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
startTimeLabel.TextScaled = true
startTimeLabel.Font = Enum.Font.GothamBold
startTimeLabel.Parent = mainFrame

local uptimeLabel = Instance.new("TextLabel")
uptimeLabel.Size = UDim2.new(0.9, 0, 0, 20)
uptimeLabel.Position = UDim2.new(0.05, 0, 0, 405)
uptimeLabel.BackgroundTransparency = 1
uptimeLabel.Text = "Uptime: 0s"
uptimeLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
uptimeLabel.TextScaled = true
uptimeLabel.Font = Enum.Font.GothamBold
uptimeLabel.Parent = mainFrame

local serverLabel = Instance.new("TextLabel")
serverLabel.Size = UDim2.new(0.9, 0, 0, 16)
serverLabel.Position = UDim2.new(0.05, 0, 0, 428)
serverLabel.BackgroundTransparency = 1
serverLabel.Text = "Server ID: Loading..."
serverLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
serverLabel.TextScaled = true
serverLabel.Font = Enum.Font.Gotham
serverLabel.Parent = mainFrame

local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0, 120, 0, 25)
copyButton.Position = UDim2.new(0, 10, 0, 450)
copyButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.Text = "📋 Copy Server"
copyButton.TextScaled = true
copyButton.Font = Enum.Font.GothamBold
copyButton.Parent = mainFrame

local joinInput = Instance.new("TextBox")
joinInput.Size = UDim2.new(0, 120, 0, 25)
joinInput.Position = UDim2.new(0, 140, 0, 450)
joinInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
joinInput.TextColor3 = Color3.fromRGB(255, 255, 255)
joinInput.Text = ""
joinInput.PlaceholderText = "Server ID"
joinInput.TextScaled = true
joinInput.Font = Enum.Font.Gotham
joinInput.ClearTextOnFocus = true
joinInput.Parent = mainFrame

local joinButton = Instance.new("TextButton")
joinButton.Size = UDim2.new(0, 90, 0, 25)
joinButton.Position = UDim2.new(0, 270, 0, 450)
joinButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
joinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
joinButton.Text = "🚀 Join"
joinButton.TextScaled = true
joinButton.Font = Enum.Font.GothamBold
joinButton.Parent = mainFrame

local serverStatusLabel = Instance.new("TextLabel")
serverStatusLabel.Size = UDim2.new(0.9, 0, 0, 16)
serverStatusLabel.Position = UDim2.new(0.05, 0, 0, 478)
serverStatusLabel.BackgroundTransparency = 1
serverStatusLabel.Text = ""
serverStatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
serverStatusLabel.TextScaled = true
serverStatusLabel.Font = Enum.Font.Gotham
serverStatusLabel.Parent = mainFrame

local blacklistLabel = Instance.new("TextLabel")
blacklistLabel.Size = UDim2.new(0.9, 0, 0, 16)
blacklistLabel.Position = UDim2.new(0.05, 0, 0, 498)
blacklistLabel.BackgroundTransparency = 1
blacklistLabel.Text = "Blacklisted: 0 servers"
blacklistLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
blacklistLabel.TextScaled = true
blacklistLabel.Font = Enum.Font.Gotham
blacklistLabel.Parent = mainFrame

-- ============================================
-- VARIABLES
-- ============================================
local flying = false
local targetFruit = nil
local targetFruitName = ""
local flyConnection = nil
local distanceUpdateConnection = nil
local espEnabled = false
local espObjects = {}
local frogMode = false
local savedEffects = {}
local currentServerId = ""
local fruitButtons = {}
local allFruits = {}
local originalCanCollide = {}
local uptimeConnection = nil
local realServerStartTime = nil
local guiVisible = true
local islands = {}
local islandObjects = {}

local autoRefreshEnabled = true
local autoRefreshConnection = nil
local lastFruitCheck = 0
local lastUptimeTick = 0
local lastServerDisplayTick = 0

-- Forward declarations (these are used before they're defined below)
local createESP, clearESP, stopFlying

-- ============================================
-- ISLAND HELPERS
-- ============================================
local function getIslandFromPath(path)
    local parts = {}
    for part in string.gmatch(path, "[^%.]+") do
        table.insert(parts, part)
    end

    local current = workspace
    for _, part in pairs(parts) do
        if current then
            current = current:FindFirstChild(part)
        else
            break
        end
    end
    return current
end

local function getIslandPositions()
    islands = {}
    islandObjects = {}

    for _, islandDef in pairs(islandDefinitions) do
        local island = getIslandFromPath(islandDef.Path)
        if island then
            table.insert(islandObjects, island)

            local pos = nil
            if island:IsA("BasePart") then
                pos = island.Position
            elseif island:IsA("Model") then
                if island.PrimaryPart then
                    pos = island.PrimaryPart.Position
                else
                    for _, part in pairs(island:GetDescendants()) do
                        if part:IsA("BasePart") then
                            pos = part.Position
                            break
                        end
                    end
                end
            end

            if pos then
                table.insert(islands, {
                    Name = islandDef.Name,
                    Position = pos,
                    Object = island
                })
            end
        end
    end
    return islands
end

local function findClosestIsland(position)
    if not position then return "Unknown" end

    local closestIsland = nil
    local closestDistance = math.huge

    for _, island in pairs(islands) do
        local distance = (position - island.Position).Magnitude
        if distance < closestDistance then
            closestDistance = distance
            closestIsland = island.Name
        end
    end

    return closestIsland or "Unknown"
end

-- ============================================
-- FIND FRUITS  (workspace.Fruit ONLY)
-- ============================================
local function getPartPosition(obj)
    if obj:IsA("BasePart") then
        return obj.Position
    elseif obj:IsA("Model") then
        if obj.PrimaryPart then
            return obj.PrimaryPart.Position
        end
        for _, part in pairs(obj:GetDescendants()) do
            if part:IsA("BasePart") then
                return part.Position
            end
        end
    end
    return nil
end

local function findAllFruits()
    local fruits = {}

    -- Scan ONLY direct children of workspace whose name is exactly FRUIT_NAME.
    -- No island descendant scans, no substring matches.
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name == FRUIT_NAME then
            local pos = getPartPosition(obj)
            if pos then
                table.insert(fruits, {
                    Object   = obj,
                    Position = pos,
                    Name     = "🍎 " .. obj.Name,
                    Island   = findClosestIsland(pos)
                })
            end
        end
    end

    return fruits
end

-- ============================================
-- UPDATE FRUIT LIST
-- ============================================
local function updateFruitList()
    getIslandPositions()

    for _, btn in pairs(fruitButtons) do
        btn:Destroy()
    end
    fruitButtons = {}

    allFruits = findAllFruits()

    if #allFruits == 0 then
        local noFruitLabel = Instance.new("TextLabel")
        noFruitLabel.Size = UDim2.new(1, 0, 0, 30)
        noFruitLabel.BackgroundTransparency = 1
        noFruitLabel.Text = "❌ No '" .. FRUIT_NAME .. "' in workspace"
        noFruitLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        noFruitLabel.TextScaled = true
        noFruitLabel.Font = Enum.Font.Gotham
        noFruitLabel.Parent = fruitList
        table.insert(fruitButtons, noFruitLabel)
        fruitList.CanvasSize = UDim2.new(0, 0, 0, 30)
        serverStatusLabel.Text = ""
        return
    end

    local yPos = 0
    for _, fruitData in pairs(allFruits) do
        local pos = fruitData.Position
        local distance = (pos - rootPart.Position).Magnitude
        local distText = string.format("%.0f studs", distance)
        local islandName = fruitData.Island or "Unknown"

        local fruitBtn = Instance.new("TextButton")
        fruitBtn.Size = UDim2.new(1, -10, 0, 32)
        fruitBtn.Position = UDim2.new(0, 5, 0, yPos)
        fruitBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        fruitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        fruitBtn.Text = string.format("%s | %s | 🏝️ %s", fruitData.Name, distText, islandName)
        fruitBtn.TextScaled = true
        fruitBtn.Font = Enum.Font.Gotham
        fruitBtn.BorderSizePixel = 1
        fruitBtn.BorderColor3 = Color3.fromRGB(100, 100, 100)
        fruitBtn.Parent = fruitList

        if targetFruit and targetFruit.Object == fruitData.Object then
            fruitBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
            fruitBtn.Text = string.format("▶ %s | %s | 🏝️ %s", fruitData.Name, distText, islandName)
        end

        fruitBtn.MouseButton1Click:Connect(function()
            targetFruit = fruitData
            targetFruitName = fruitData.Name
            distanceLabel.Text = string.format("Target: %s | Distance: %s | 🏝️ %s", fruitData.Name, distText, islandName)
            statusLabel.Text = "Status: Target selected"
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

            for _, btn in pairs(fruitButtons) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                end
            end
            fruitBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
            fruitBtn.Text = string.format("▶ %s | %s | 🏝️ %s", fruitData.Name, distText, islandName)

            if espEnabled then
                clearESP()
                for _, f in pairs(allFruits) do
                    createESP(f)
                end
            end
        end)

        table.insert(fruitButtons, fruitBtn)
        yPos = yPos + 37
    end

    fruitList.CanvasSize = UDim2.new(0, 0, 0, yPos + 10)
    serverStatusLabel.Text = "✅ " .. #allFruits .. " fruit(s) found!"
    serverStatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
end

-- ============================================
-- AUTO-REFRESH (accumulator, not tick() % n)
-- ============================================
local function startAutoRefresh()
    if autoRefreshConnection then return end

    autoRefreshConnection = runService.Heartbeat:Connect(function()
        local now = tick()
        if now - lastFruitCheck < 0.5 then return end
        lastFruitCheck = now

        local newFruits = findAllFruits()

        local changed = #newFruits ~= #allFruits
        if not changed then
            for _, nf in pairs(newFruits) do
                local found = false
                for _, of in pairs(allFruits) do
                    if of.Object == nf.Object then
                        if (of.Position - nf.Position).Magnitude > 1 then
                            changed = true
                        end
                        found = true
                        break
                    end
                end
                if not found then
                    changed = true
                    break
                end
            end
        end

        if changed then
            updateFruitList()

            if espEnabled then
                clearESP()
                for _, f in pairs(allFruits) do
                    createESP(f)
                end
            end

            if not flying then
                statusLabel.Text = "Status: " .. #allFruits .. " fruit(s) detected"
                statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            end
        end
    end)
end

local function stopAutoRefresh()
    if autoRefreshConnection then
        autoRefreshConnection:Disconnect()
        autoRefreshConnection = nil
    end
end

local function toggleAutoRefresh()
    autoRefreshEnabled = not autoRefreshEnabled
    autoRefreshButton.Text = autoRefreshEnabled and "⏱️ AUTO ON" or "⏱️ AUTO OFF"
    autoRefreshButton.BackgroundColor3 = autoRefreshEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)

    if autoRefreshEnabled then
        startAutoRefresh()
        statusLabel.Text = "Status: Auto-refresh ON"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        stopAutoRefresh()
        statusLabel.Text = "Status: Auto-refresh OFF"
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

-- ============================================
-- ESP
-- ============================================
createESP = function(fruitData)
    if not fruitData or not fruitData.Position then return end

    local pos = fruitData.Position
    local islandName = fruitData.Island or findClosestIsland(pos)
    local distance = (pos - rootPart.Position).Magnitude

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 250, 0, 75)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true

    if fruitData.Object and fruitData.Object.Parent then
        billboard.Parent = fruitData.Object
    else
        local dummy = Instance.new("Part")
        dummy.Size = Vector3.new(1, 1, 1)
        dummy.CFrame = CFrame.new(pos)
        dummy.Anchored = true
        dummy.CanCollide = false
        dummy.Transparency = 1
        dummy.Parent = workspace
        billboard.Parent = dummy
        table.insert(espObjects, { dummy = dummy })
    end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
    frame.Parent = billboard

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "🍎 " .. fruitData.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = frame

    local islandLabel = Instance.new("TextLabel")
    islandLabel.Size = UDim2.new(1, 0, 0.3, 0)
    islandLabel.Position = UDim2.new(0, 0, 0.4, 0)
    islandLabel.BackgroundTransparency = 1
    islandLabel.Text = "🏝️ " .. islandName
    islandLabel.TextColor3 = Color3.fromRGB(100, 255, 255)
    islandLabel.TextScaled = true
    islandLabel.Font = Enum.Font.GothamBold
    islandLabel.Parent = frame

    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1, 0, 0.3, 0)
    distLabel.Position = UDim2.new(0, 0, 0.7, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = string.format("%.0f studs", distance)
    distLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    distLabel.TextScaled = true
    distLabel.Font = Enum.Font.Gotham
    distLabel.Parent = frame

    if targetFruit and targetFruit.Object == fruitData.Object then
        frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
        nameLabel.Text = "🎯 " .. fruitData.Name
    end

    table.insert(espObjects, {
        object = fruitData.Object,
        billboard = billboard,
        distLabel = distLabel,
        position = pos
    })

    if fruitData.Object and fruitData.Object.Parent then
        local highlight = Instance.new("Highlight")
        local isTarget = targetFruit and targetFruit.Object == fruitData.Object
        highlight.FillColor = isTarget and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.4
        highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
        highlight.OutlineTransparency = 0.3
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = fruitData.Object

        table.insert(espObjects, {
            object = fruitData.Object,
            highlight = highlight
        })
    end
end

clearESP = function()
    for _, esp in pairs(espObjects) do
        if esp.billboard then esp.billboard:Destroy() end
        if esp.highlight then esp.highlight:Destroy() end
        if esp.dummy then esp.dummy:Destroy() end
    end
    espObjects = {}
end

local function toggleESP()
    espEnabled = not espEnabled
    espButton.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    espButton.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 100, 200)

    if espEnabled then
        for _, fruitData in pairs(allFruits) do
            createESP(fruitData)
        end
    else
        clearESP()
    end
end

local function updateESP()
    if not espEnabled then return end

    for _, esp in pairs(espObjects) do
        if esp.distLabel and esp.position then
            local dist = (esp.position - rootPart.Position).Magnitude
            esp.distLabel.Text = string.format("%.0f studs", dist)
        end
    end
end

-- ============================================
-- SERVER TIME
-- ============================================
local function extractServerStartTimeFromJobId()
    local jobId = game.JobId
    if not jobId or jobId == "" then return nil end

    local year, month, day, hour, minute, second = string.match(
        jobId,
        "(%d%d%d%d)(%d%d)(%d%d)_(%d%d)(%d%d)(%d%d)"
    )

    if year and month and day and hour and minute and second then
        local timeTable = {
            year = tonumber(year), month = tonumber(month), day = tonumber(day),
            hour = tonumber(hour), min = tonumber(minute), sec = tonumber(second)
        }
        return os.time(timeTable)
    end
    return nil
end

local function getRealServerStartTime()
    local fromJobId = extractServerStartTimeFromJobId()
    if fromJobId then return fromJobId end

    local success, result = pcall(function()
        local startTimeObj = game:GetService("ReplicatedStorage"):FindFirstChild("ServerStartTime")
        if startTimeObj and startTimeObj:IsA("NumberValue") then
            return startTimeObj.Value
        end
        return nil
    end)

    if success and result then return result end
    return os.time()
end

local function formatTime(timestamp)
    if not timestamp then return "Unknown" end
    return os.date("%Y-%m-%d %H:%M:%S", timestamp)
end

local function formatUptime(seconds)
    if not seconds or seconds < 0 then return "0s" end
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)
    if days > 0 then
        return string.format("%dd %02dh %02dm %02ds", days, hours, minutes, secs)
    elseif hours > 0 then
        return string.format("%02dh %02dm %02ds", hours, minutes, secs)
    elseif minutes > 0 then
        return string.format("%02dm %02ds", minutes, secs)
    else
        return string.format("%ds", secs)
    end
end

local function updateServerTime()
    if not realServerStartTime then
        realServerStartTime = getRealServerStartTime()
    end

    local currentTime = os.time()
    local uptime = currentTime - realServerStartTime

    if uptime < 0 or uptime > 31536000 then
        realServerStartTime = getRealServerStartTime()
        uptime = currentTime - realServerStartTime
    end

    startTimeLabel.Text = "🚀 Server Started: " .. formatTime(realServerStartTime)
    uptimeLabel.Text = "⏱️ Uptime: " .. formatUptime(uptime)
end

-- ============================================
-- TOGGLE GUI
-- ============================================
local function toggleGUI()
    guiVisible = not guiVisible
    mainFrame.Visible = guiVisible
    toggleGuiButton.BackgroundColor3 = guiVisible and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(255, 0, 0)
    toggleGuiButton.Text = "🍎"
end

-- ============================================
-- NOCLIP
-- ============================================
local function enableNoclip()
    originalCanCollide = {}

    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            originalCanCollide[part] = part.CanCollide
            part.CanCollide = false
        end
    end

    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Parent ~= character then
            local distance = (part.Position - rootPart.Position).Magnitude
            if distance < 100 and originalCanCollide[part] == nil then
                originalCanCollide[part] = part.CanCollide
                part.CanCollide = false
            end
        end
    end
end

local function disableNoclip()
    for part, canCollide in pairs(originalCanCollide) do
        if part and part.Parent then
            part.CanCollide = canCollide
        end
    end
    originalCanCollide = {}
end

-- ============================================
-- FROG MODE
-- ============================================
local function toggleFrog()
    frogMode = not frogMode
    frogButton.Text = frogMode and "🐸 FROG: ON" or "🐸 FROG"
    frogButton.BackgroundColor3 = frogMode and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(0, 200, 100)

    if frogMode then
        savedEffects = {}
        for _, child in pairs(lighting:GetChildren()) do
            if child.Name ~= "Sky" and child.Name ~= "BaseAtmosphere" then
                table.insert(savedEffects, child:Clone())
                child:Destroy()
            end
        end
        if guiVisible then
            statusLabel.Text = string.format("Status: Removed %d effects 🐸", #savedEffects)
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        end
    else
        local restored = 0
        for _, effect in pairs(savedEffects) do
            if effect and effect.Parent == nil then
                effect:Clone().Parent = lighting
                restored = restored + 1
            end
        end
        savedEffects = {}
        if guiVisible then
            statusLabel.Text = string.format("Status: Restored %d effects", restored)
            statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end
end

-- ============================================
-- SERVER ID / JOIN
-- ============================================
local function getServerId()
    local success, result = pcall(function() return game.JobId end)
    if success and result and result ~= "" then return result end
    return "Unknown"
end

local function updateServerDisplay()
    currentServerId = getServerId()
    serverLabel.Text = "Server ID: " .. currentServerId
    updateServerTime()
    blacklistLabel.Text = "Blacklisted: " .. #blacklist .. " servers"
end

local function copyServerId()
    if currentServerId and currentServerId ~= "" and currentServerId ~= "Unknown" then
        local success = pcall(function() setclipboard(currentServerId) end)
        if success then
            serverStatusLabel.Text = "✅ Server ID copied!"
            serverStatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        else
            serverStatusLabel.Text = "⚠️ Copy manually: " .. currentServerId
            serverStatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        end
    else
        serverStatusLabel.Text = "❌ No server ID found!"
        serverStatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end

local function joinServerById(serverId)
    if not serverId or serverId == "" then
        serverStatusLabel.Text = "❌ Please enter a server ID!"
        serverStatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        return
    end
    if string.len(serverId) < 10 then
        serverStatusLabel.Text = "❌ Invalid server ID format!"
        serverStatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        return
    end

    serverStatusLabel.Text = "🔄 Joining server..."
    serverStatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)

    local success, errorMsg = pcall(function()
        teleportService:TeleportToPlaceInstance(game.PlaceId, serverId, player)
    end)

    if not success then
        serverStatusLabel.Text = "❌ Failed: " .. tostring(errorMsg)
        serverStatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end

-- ============================================
-- FLIGHT
-- ============================================
local function startFlying()
    if not targetFruit then
        statusLabel.Text = "Status: No fruit selected!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        return
    end
    if not targetFruit.Position then
        statusLabel.Text = "Status: Target fruit has no position!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        return
    end

    local speed = tonumber(speedSlider.Text)
    if not speed or speed <= 0 then
        speed = 50
        speedSlider.Text = "50"
    end
    if speed > 500 then
        speed = 500
        speedSlider.Text = "500"
    end

    flying = true
    toggleButton.Text = "STOP"
    toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    statusLabel.Text = string.format("Status: Flying to %s...", targetFruit.Name)
    statusLabel.TextColor3 = Color3.fromRGB(0, 200, 255)

    humanoid.AutoRotate = false
    humanoid.PlatformStand = true

    enableNoclip()

    flyConnection = runService.Heartbeat:Connect(function()
        if not flying then
            stopFlying()
            return
        end

        if not targetFruit or not targetFruit.Object or not targetFruit.Object.Parent then
            statusLabel.Text = "Status: Target lost!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            stopFlying()
            return
        end

        local targetPos = getPartPosition(targetFruit.Object) or targetFruit.Position
        targetFruit.Position = targetPos

        local currentPos = rootPart.Position
        local distance = (targetPos - currentPos).Magnitude
        local islandName = targetFruit.Island or findClosestIsland(targetPos)

        distanceLabel.Text = string.format("Target: %s | Distance: %.0f studs | 🏝️ %s", targetFruit.Name, distance, islandName)

        if distance < 5 then
            statusLabel.Text = "Status: Arrived! 🎯"
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            stopFlying()
            return
        end

        local direction = (targetPos - currentPos).Unit
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e8, 1e8, 1e8)
        bv.Velocity = direction * speed
        bv.Parent = rootPart

        task.delay(0.1, function()
            if bv and bv.Parent then bv:Destroy() end
        end)
    end)

    distanceUpdateConnection = runService.Heartbeat:Connect(function()
        if flying and targetFruit and targetFruit.Position then
            local pos = targetFruit.Position
            local dist = (pos - rootPart.Position).Magnitude
            local islandName = targetFruit.Island or findClosestIsland(pos)
            distanceLabel.Text = string.format("Target: %s | Distance: %.0f studs | 🏝️ %s", targetFruit.Name, dist, islandName)
        end
    end)
end

stopFlying = function()
    flying = false
    toggleButton.Text = "START"
    toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)

    humanoid.AutoRotate = true
    humanoid.PlatformStand = false

    disableNoclip()

    if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
    if distanceUpdateConnection then distanceUpdateConnection:Disconnect(); distanceUpdateConnection = nil end

    if guiVisible and statusLabel.Text ~= "Status: Arrived! 🎯" then
        statusLabel.Text = "Status: Stopped"
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

-- ============================================
-- BUTTON EVENTS
-- ============================================
toggleGuiButton.MouseButton1Click:Connect(toggleGUI)

toggleButton.MouseButton1Click:Connect(function()
    if flying then stopFlying() else startFlying() end
end)

espButton.MouseButton1Click:Connect(toggleESP)
frogButton.MouseButton1Click:Connect(toggleFrog)
refreshButton.MouseButton1Click:Connect(updateFruitList)
autoRefreshButton.MouseButton1Click:Connect(toggleAutoRefresh)

copyButton.MouseButton1Click:Connect(copyServerId)
joinButton.MouseButton1Click:Connect(function()
    joinServerById(joinInput.Text)
end)

joinInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then joinServerById(joinInput.Text) end
end)

speedSlider.FocusLost:Connect(function()
    local speed = tonumber(speedSlider.Text)
    if speed and speed > 0 then
        if speed > 500 then speedSlider.Text = "500" end
    else
        speedSlider.Text = "50"
    end
end)

-- ============================================
-- RESPAWN
-- ============================================
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")

    if flying then stopFlying() end

    if frogMode then
        frogMode = false
        frogButton.Text = "🐸 FROG"
        frogButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        for _, effect in pairs(savedEffects) do
            if effect and effect.Parent == nil then
                effect:Clone().Parent = lighting
            end
        end
        savedEffects = {}
    end

    statusLabel.Text = "Status: Respawned"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distanceLabel.Text = "Target: None | Distance: N/A | Island: -"

    task.wait(0.5)
    updateFruitList()
end)

-- ============================================
-- CLEANUP
-- ============================================
screenGui.AncestryChanged:Connect(function()
    if not screenGui.Parent then
        if flying then stopFlying() end
        if espEnabled then clearESP() end
        if frogMode then
            frogMode = false
            for _, effect in pairs(savedEffects) do
                if effect and effect.Parent == nil then
                    effect:Clone().Parent = lighting
                end
            end
            savedEffects = {}
        end
        if uptimeConnection then uptimeConnection:Disconnect(); uptimeConnection = nil end
        stopAutoRefresh()
    end
end)

-- ============================================
-- LOOPS
-- ============================================
runService.Heartbeat:Connect(function()
    if espEnabled then updateESP() end
end)

realServerStartTime = getRealServerStartTime()
updateServerDisplay()

uptimeConnection = runService.Heartbeat:Connect(function()
    local now = tick()
    if now - lastUptimeTick >= 1 then
        lastUptimeTick = now
        updateServerTime()
    end
end)

runService.Heartbeat:Connect(function()
    local now = tick()
    if now - lastServerDisplayTick >= 10 then
        lastServerDisplayTick = now
        updateServerDisplay()
    end
end)

userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        toggleGUI()
    end
end)

-- ============================================
-- INITIAL LOAD
-- ============================================
getIslandPositions()
statusLabel.Text = "Status: Loading fruits..."
task.wait(1)
updateFruitList()
statusLabel.Text = "Status: Idle"

startAutoRefresh()

print("🍎 Fruit Finder loaded - looking for workspace." .. FRUIT_NAME .. " only")
print("Press F1 or click 🍎 button to hide/show GUI")
