--[[
    DRAGON PINGX ULTIMATE - QANH NO 1 EDITION
    FULL CHUC NANG: FREEZE | KICK | SPEED | FLY | ESP | AIMBOT
    ADMIN KEY: QANHNO1CRACKER
    WEBSITE: https://roszmodxqanhno1.onrender.com
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = game:GetService("Workspace").CurrentCamera
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local API_URL = "https://roszmodxqanhno1.onrender.com"
local isVerified = false
local menuVisible = true
local menuPosition = UDim2.new(0.5, -220, 0.5, -300)

-- Hack variables
local speedEnabled = false
local speedValue = 50
local jumpEnabled = false
local jumpValue = 150
local flyEnabled = false
local noclipEnabled = false
local espEnabled = false
local aimbotEnabled = false
local flyBodyVelocity = nil
local noclipConnections = {}

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local function notify(msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "DRAGON PINGX",
            Text = msg,
            Duration = 2
        })
    end)
end

local function getHWID()
    if syn and syn.crypt then
        return syn.crypt.custom_hash(player.UserId)
    elseif getexecutorname then
        return getexecutorname() .. "-" .. player.UserId
    else
        return "DRAGON-" .. player.UserId
    end
end

local function verifyKey(key)
    if key == "QANHNO1CRACKER" or key == "DRAGONLOCUT" then
        return true
    end
    local url = API_URL .. "/api/verify?key=" .. key .. "&hwid=" .. getHWID()
    local success, res = pcall(function()
        return game:HttpGet(url)
    end)
    if success and res then
        local data = HttpService:JSONDecode(res)
        return data.status == "success"
    end
    return false
end

-- ========== LAG / FREEZE SERVER ==========
local function freezeServer()
    notify("DONG BANG TOAN BO SERVER TRONG 1 PHUT")
    
    for i = 1, 50000 do
        local part = Instance.new("Part")
        part.Size = Vector3.new(1, 1, 1)
        part.Position = Vector3.new(math.random(-3000, 3000), math.random(0, 500), math.random(-3000, 3000))
        part.Anchored = true
        part.Name = "FREEZE_" .. i
        part.Parent = Workspace
        if i % 2000 == 0 then task.wait() end
    end
    
    local remotes = {}
    local function findRemotes(p)
        for _, v in pairs(p:GetChildren()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                table.insert(remotes, v)
            end
            findRemotes(v)
        end
    end
    findRemotes(game.ReplicatedStorage)
    
    for i = 1, 10000 do
        for _, r in pairs(remotes) do
            pcall(function()
                if r:IsA("RemoteEvent") then
                    r:FireServer(string.rep("X", 1000))
                else
                    r:InvokeServer(string.rep("Y", 1000))
                end
            end)
        end
        if i % 500 == 0 then task.wait() end
    end
    
    local startTime = tick()
    while tick() - startTime < 60 do
        for i = 1, 5000 do
            local a = math.sin(i) * math.cos(i) / math.tan(i + 1)
        end
        task.wait()
    end
    
    notify("DA HET 1 PHUT")
end

-- ========== KICK PLAYER ==========
local function kickPlayer(targetName)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():find(targetName:lower()) and plr ~= player then
            if plr.Character then
                plr.Character:BreakJoints()
            end
            notify("DA KICK " .. plr.Name)
            return
        end
    end
    notify("KHONG TIM THAY NGUOI CHOI")
end

-- ========== SPEED HACK ==========
local function toggleSpeed()
    speedEnabled = not speedEnabled
    if speedEnabled then
        humanoid.WalkSpeed = speedValue
        notify("SPEED: " .. speedValue)
    else
        humanoid.WalkSpeed = 16
        notify("DA TAT SPEED")
    end
end

local function setSpeed(val)
    speedValue = val
    if speedEnabled then
        humanoid.WalkSpeed = speedValue
    end
    notify("SPEED: " .. speedValue)
end

-- ========== JUMP HACK ==========
local function toggleJump()
    jumpEnabled = not jumpEnabled
    if jumpEnabled then
        humanoid.JumpPower = jumpValue
        notify("HIGH JUMP: " .. jumpValue)
    else
        humanoid.JumpPower = 50
        notify("DA TAT HIGH JUMP")
    end
end

local function setJump(val)
    jumpValue = val
    if jumpEnabled then
        humanoid.JumpPower = jumpValue
    end
    notify("HIGH JUMP: " .. jumpValue)
end

-- ========== INFINITY JUMP ==========
local infinityJumpEnabled = false
local infinityJumpConn = nil

local function toggleInfinityJump()
    infinityJumpEnabled = not infinityJumpEnabled
    if infinityJumpEnabled then
        if infinityJumpConn then infinityJumpConn:Disconnect() end
        infinityJumpConn = UserInputService.JumpRequest:Connect(function()
            if infinityJumpEnabled then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        notify("BAT INFINITY JUMP")
    else
        if infinityJumpConn then infinityJumpConn:Disconnect() end
        notify("TAT INFINITY JUMP")
    end
end

-- ========== FLY HACK ==========
local function updateFly()
    if not flyEnabled then return end
    if not rootPart or not rootPart.Parent then return end
    local direction = Vector3.new()
    if mouse then
        direction = (Camera.CFrame.LookVector * (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0)) +
                    (Camera.CFrame.RightVector * (UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or (UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0)))
        direction = direction + Vector3.new(0, (UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and -1 or 0)), 0)
    end
    if direction.Magnitude > 0 then
        direction = direction.Unit * 85
    end
    if flyBodyVelocity then
        flyBodyVelocity.VectorVelocity = direction
    end
end

local function toggleFly()
    flyEnabled = not flyEnabled
    if flyEnabled then
        humanoid.PlatformStand = true
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
        flyBodyVelocity.Parent = rootPart
        RunService.RenderStepped:Connect(updateFly)
        notify("BAT FLY")
    else
        humanoid.PlatformStand = false
        if flyBodyVelocity then flyBodyVelocity:Destroy() end
        notify("TAT FLY")
    end
end

-- ========== NOCLIP ==========
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        for _, conn in pairs(noclipConnections) do
            conn:Disconnect()
        end
        noclipConnections = {}
        local function noclipFunc()
            if noclipEnabled and character and character.Parent then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
        noclipConnections[1] = RunService.Stepped:Connect(noclipFunc)
        noclipConnections[2] = character.DescendantAdded:Connect(noclipFunc)
        notify("BAT NOCLIP")
    else
        for _, conn in pairs(noclipConnections) do
            conn:Disconnect()
        end
        noclipConnections = {}
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        notify("TAT NOCLIP")
    end
end

-- ========== ESP ==========
local espObjects = {}
local function createESP(plr)
    if plr == player then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_" .. plr.Name
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.7
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = plr.Character or plr.CharacterAdded:Wait()
    espObjects[plr] = highlight
end

local function toggleESP()
    espEnabled = not espEnabled
    if espEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player then
                if plr.Character then
                    createESP(plr)
                else
                    plr.CharacterAdded:Connect(function()
                        createESP(plr)
                    end)
                end
            end
        end
        Players.PlayerAdded:Connect(function(plr)
            if espEnabled and plr ~= player then
                plr.CharacterAdded:Connect(function()
                    createESP(plr)
                end)
            end
        end)
        notify("BAT ESP")
    else
        for _, obj in pairs(espObjects) do
            if obj then obj:Destroy() end
        end
        espObjects = {}
        notify("TAT ESP")
    end
end

-- ========== AIMBOT ==========
local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        notify("BAT AIMBOT")
    else
        notify("TAT AIMBOT")
    end
end

local function updateAimbot()
    if not aimbotEnabled then return end
    local closest = nil
    local closestDist = 200
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToScreenPoint(plr.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = plr
                end
            end
        end
    end
    if closest then
        local targetPos = closest.Character.HumanoidRootPart.Position
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
    end
end

RunService.RenderStepped:Connect(updateAimbot)

-- ========== AUTO FARM (GUI CLICK) ==========
local autoFarmEnabled = false
local farmConn = nil

local function toggleAutoFarm()
    autoFarmEnabled = not autoFarmEnabled
    if autoFarmEnabled then
        farmConn = RunService.RenderStepped:Connect(function()
            if autoFarmEnabled then
                local remote = game.ReplicatedStorage:FindFirstChild("ClickToFarm")
                if remote and remote:IsA("RemoteEvent") then
                    pcall(function() remote:FireServer() end)
                end
            end
        end)
        notify("BAT AUTO FARM")
    else
        if farmConn then farmConn:Disconnect() end
        notify("TAT AUTO FARM")
    end
end

-- ========== CREATE UI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DragonPingX"
screenGui.ResetOnSpawn = false
pcall(function() screenGui.Parent = game:GetService("CoreGui") end)
if not screenGui.Parent then
    pcall(function() screenGui.Parent = player.PlayerGui end)
end

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 440, 0, 560)
main.Position = menuPosition
main.BackgroundColor3 = Color3.fromRGB(15, 20, 35)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(255, 0, 150)
main.ClipsDescendants = true
main.Parent = screenGui

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
titleBar.BackgroundTransparency = 0.2
titleBar.Parent = main

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -80, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "DRAGON PINGX ULTIMATE"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 16
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0, 35, 1, 0)
hideBtn.Position = UDim2.new(1, -70, 0, 0)
hideBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
hideBtn.BackgroundTransparency = 0.3
hideBtn.Text = "-"
hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hideBtn.TextSize = 20
hideBtn.Font = Enum.Font.SourceSansBold
hideBtn.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 1, 0)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
closeBtn.BackgroundTransparency = 0.3
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Parent = titleBar

-- Scrolling frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0.95, 0, 0.85, 0)
scrollFrame.Position = UDim2.new(0.025, 0, 0.1, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 5
scrollFrame.Parent = main

local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 0, 0)
content.BackgroundTransparency = 1
content.Parent = scrollFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = content

local function addCategory(name)
    local cat = Instance.new("TextLabel")
    cat.Size = UDim2.new(1, -10, 0, 25)
    cat.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
    cat.BackgroundTransparency = 0.3
    cat.Text = " " .. name
    cat.TextColor3 = Color3.fromRGB(255, 255, 255)
    cat.TextSize = 12
    cat.Font = Enum.Font.GothamBold
    cat.TextXAlignment = Enum.TextXAlignment.Left
    cat.Parent = content
    return cat
end

local function addButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
    btn.BackgroundTransparency = 0.4
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Parent = content
    
    btn.MouseButton1Click:Connect(function()
        if text ~= "GET KEY" and text ~= "KICH HOAT" and not isVerified then
            notify("Can kich hoat key truoc")
            return
        end
        callback()
    end)
    return btn
end

local function addSlider(name, minVal, maxVal, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = content
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. defaultVal
    label.TextColor3 = Color3.fromRGB(200, 200, 255)
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.25, 0, 0, 25)
    box.Position = UDim2.new(0.5, 0, 0, 0)
    box.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
    box.Text = tostring(defaultVal)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextSize = 11
    box.Parent = frame
    
    local apply = Instance.new("TextButton")
    apply.Size = UDim2.new(0.2, 0, 0, 25)
    apply.Position = UDim2.new(0.78, 0, 0, 0)
    apply.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
    apply.Text = "Set"
    apply.TextColor3 = Color3.fromRGB(255, 255, 255)
    apply.TextSize = 11
    apply.Parent = frame
    
    apply.MouseButton1Click:Connect(function()
        local val = tonumber(box.Text)
        if val then
            val = math.clamp(val, minVal, maxVal)
            box.Text = tostring(val)
            label.Text = name .. ": " .. val
            callback(val)
        end
    end)
end

local function addPlayerInput()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.BackgroundTransparency = 1
    frame.Parent = content
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = "Ten nguoi choi:"
    label.TextColor3 = Color3.fromRGB(200, 200, 255)
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.5, 0, 0, 30)
    box.Position = UDim2.new(0.45, 0, 0, 0)
    box.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
    box.PlaceholderText = "Nhap ten"
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextSize = 11
    box.Parent = frame
    
    local kick = Instance.new("TextButton")
    kick.Size = UDim2.new(0.5, 0, 0, 30)
    kick.Position = UDim2.new(0.45, 0, 0.55, 0)
    kick.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    kick.Text = "KICK"
    kick.TextColor3 = Color3.fromRGB(255, 255, 255)
    kick.TextSize = 11
    kick.Parent = frame
    
    kick.MouseButton1Click:Connect(function()
        if box.Text ~= "" then
            kickPlayer(box.Text)
        end
    end)
end

-- Build UI
addCategory("XAC THUC")
local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, -10, 0, 35)
keyBox.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
keyBox.PlaceholderText = "Nhap key tai day"
keyBox.Text = ""
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.TextSize = 12
keyBox.Parent = content

addButton("GET KEY", function()
    setclipboard(API_URL .. "/getkey")
    notify("Da copy link lay key")
end)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 0, 25)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "CHUA KICH HOAT"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.TextSize = 11
statusLabel.Parent = content

addButton("KICH HOAT", function()
    if keyBox.Text == "" then
        statusLabel.Text = "NHAP KEY"
        return
    end
    statusLabel.Text = "DANG XAC THUC..."
    if verifyKey(keyBox.Text) then
        isVerified = true
        statusLabel.Text = "DA KICH HOAT"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        notify("Kich hoat thanh cong")
    else
        statusLabel.Text = "KEY SAI"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

addCategory("LAG SERVER")
addButton("FREEZE SERVER 1 PHUT", freezeServer)

addCategory("KICK NGUOI CHOI")
addPlayerInput()

addCategory("HACK DI CHUYEN")
addButton("TOGGLE SPEED", toggleSpeed)
addSlider("SPEED VALUE", 16, 250, 50, setSpeed)
addButton("TOGGLE HIGH JUMP", toggleJump)
addSlider("JUMP VALUE", 50, 500, 150, setJump)
addButton("TOGGLE INFINITY JUMP", toggleInfinityJump)
addButton("TOGGLE FLY", toggleFly)
addButton("TOGGLE NOCLIP", toggleNoclip)

addCategory("ESP VA AIMBOT")
addButton("TOGGLE ESP", toggleESP)
addButton("TOGGLE AIMBOT", toggleAimbot)

addCategory("AUTO FARM")
addButton("TOGGLE AUTO FARM", toggleAutoFarm)

addCategory("THONG TIN")
addButton("LAY HWID", function()
    notify(getHWID())
end)

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    content.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + 10)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
end)

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 20)
footer.Position = UDim2.new(0, 0, 1, -20)
footer.BackgroundTransparency = 1
footer.Text = "ADMIN KEY: QANHNO1CRACKER"
footer.TextColor3 = Color3.fromRGB(200, 200, 100)
footer.TextSize = 9
footer.Parent = main

hideBtn.MouseButton1Click:Connect(function()
    menuVisible = false
    local tween = TweenService:Create(main, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -220, 2, 0)})
    tween:Play()
    tween.Completed:Connect(function() main.Visible = false end)
    notify("Menu da an. Cham 3 ngon de hien lai")
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    notify("Da dong")
end)

local dragging = false
local dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        menuPosition = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        main.Position = menuPosition
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

local touchCount = 0
UserInputService.TouchStarted:Connect(function()
    touchCount = touchCount + 1
    task.delay(0.5, function() touchCount = 0 end)
    if touchCount >= 3 then
        touchCount = 0
        if not menuVisible then
            menuVisible = true
            main.Visible = true
            local tween = TweenService:Create(main, TweenInfo.new(0.3), {Position = menuPosition})
            tween:Play()
            notify("Menu da hien")
        end
    end
end)

notify("DRAGON PINGX ULTIMATE DA TAI")