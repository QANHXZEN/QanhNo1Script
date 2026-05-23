--[[
    ╔═══════════════════════════════════════════════════════════════════╗
    ║     🐉 DRAGON PINGX PRO MAX | QANH NO 1 | v5.0                  ║
    ║     🔧 TÍNH NĂNG: LAG SERVER | KICK PLAYER | HACK MOVEMENT      ║
    ║     🔧 TÍNH NĂNG: FREE GAMEPASS | MENU DI CHUYỂN | 3 NGÓN BẬT   ║
    ║     📡 WEBSITE: https://roszmodxqanhno1.onrender.com            ║
    ╚═══════════════════════════════════════════════════════════════════╝
--]]

(function()
    -- ========== SERVICES ==========
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local HttpService = game:GetService("HttpService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local VirtualUser = game:GetService("VirtualUser")
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- ========== CONFIG ==========
    local API_URL = "https://roszmodxqanhno1.onrender.com"
    local isVerified = false
    local currentKey = ""
    local isMenuVisible = true
    local menuPosition = UDim2.new(0.5, -250, 0.5, -300)
    
    -- ========== HACK VARIABLES ==========
    local infinityJumpEnabled = false
    local walkspeedEnabled = false
    local walkspeedValue = 32
    local highjumpEnabled = false
    local highjumpValue = 100
    
    -- ========== HÀM TIỆN ÍCH ==========
    local function notify(title, text, duration)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = tostring(title),
                Text = tostring(text),
                Duration = duration or 3
            })
        end)
    end
    
    local function getHWID()
        if syn and syn.crypt then
            return syn.crypt.custom_hash(player.UserId .. game.GameId .. "DRAGON")
        elseif getexecutorname then
            return getexecutorname() .. "-" .. player.UserId
        else
            return "DRAGON-" .. player.UserId
        end
    end
    
    local function verifyKey(key)
        if key == nil or key == "" then return false end
        local adminKeys = {"QANHNO1CRACKER", "DRAGONLOCUT", "ADMIN2024", "VIPKEY"}
        for _, ak in pairs(adminKeys) do
            if key == ak then return true end
        end
        local url = API_URL .. "/api/verify?key=" .. key .. "&hwid=" .. getHWID()
        local success, response = pcall(function()
            return game:HttpGet(url)
        end)
        if success and response then
            local data = HttpService:JSONDecode(response)
            return data.status == "success"
        end
        return false
    end
    
    -- ========== CHỨC NĂNG LAG ==========
    local lagFunctions = {
        spamParts = function(count)
            count = count or 1000
            for i = 1, count do
                local part = Instance.new("Part")
                part.Size = Vector3.new(1, 1, 1)
                part.Position = Vector3.new(math.random(-1000, 1000), math.random(0, 200), math.random(-1000, 1000))
                part.Anchored = true
                part.Name = "DRAGON_LAG_" .. i
                part.Parent = workspace
                if i % 200 == 0 then task.wait() end
            end
            notify("✅ LAG", "Đã spam " .. count .. " parts!", 2)
        end,
        
        spamRemote = function(iterations)
            iterations = iterations or 3000
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
            if #remotes == 0 then notify("⚠️", "Không tìm thấy remote!", 2) return 0 end
            for i = 1, iterations do
                for _, r in pairs(remotes) do
                    pcall(function()
                        if r:IsA("RemoteEvent") then
                            r:FireServer(string.rep("X", 500))
                        else
                            r:InvokeServer(string.rep("Y", 500))
                        end
                    end)
                end
                if i % 100 == 0 then task.wait() end
            end
            notify("✅ LAG", "Đã spam " .. iterations .. " lần remote!", 2)
        end,
        
        clientLag = function()
            local conn = RunService.RenderStepped:Connect(function()
                for i = 1, 5000 do
                    local x = math.sin(i) * math.cos(i) / math.tan(i + 1)
                end
            end)
            notify("🌀 LAG", "Đã bật lag client!", 2)
            return conn
        end,
        
        megaLag = function()
            lagFunctions.spamParts(2000)
            task.wait(1)
            lagFunctions.spamRemote(2000)
            task.wait(1)
            lagFunctions.clientLag()
            notify("💀 MEGA LAG", "Đã kích hoạt tất cả chế độ lag!", 2)
        end
    }
    
    -- ========== CHỨC NĂNG KICK PLAYER ==========
    local function kickPlayer(targetPlayer)
        if not targetPlayer or targetPlayer == player then 
            notify("⚠️", "Không thể tự kick chính mình!", 2)
            return 
        end
        
        -- Method 1: Clear character
        if targetPlayer.Character then
            targetPlayer.Character:BreakJoints()
        end
        
        -- Method 2: Kick qua remote (nếu có)
        local remotes = {}
        for _, v in pairs(game.ReplicatedStorage:GetChildren()) do
            if v:IsA("RemoteEvent") and v.Name:lower():find("kick") then
                pcall(function() v:FireServer(targetPlayer) end)
            end
        end
        
        notify("👢 KICK", "Đã kick " .. targetPlayer.Name, 3)
    end
    
    -- ========== CHỨC NĂNG HACK MOVEMENT ==========
    local function toggleInfinityJump()
        infinityJumpEnabled = not infinityJumpEnabled
        if infinityJumpEnabled then
            local con
            con = game:GetService("UserInputService").JumpRequest:Connect(function()
                if infinityJumpEnabled then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
            notify("🦘 INFINITY JUMP", "Đã bật nhảy vô hạn!", 2)
        else
            notify("🦘 INFINITY JUMP", "Đã tắt nhảy vô hạn!", 2)
        end
    end
    
    local function setWalkspeed(value)
        walkspeedValue = value
        if walkspeedEnabled then
            humanoid.WalkSpeed = value
        end
        notify("⚡ WALKSPEED", "Đã set tốc độ: " .. value, 2)
    end
    
    local function toggleWalkspeed()
        walkspeedEnabled = not walkspeedEnabled
        if walkspeedEnabled then
            humanoid.WalkSpeed = walkspeedValue
            notify("⚡ WALKSPEED", "Đã bật! Tốc độ: " .. walkspeedValue, 2)
        else
            humanoid.WalkSpeed = 16
            notify("⚡ WALKSPEED", "Đã tắt!", 2)
        end
    end
    
    local function setHighJump(value)
        highjumpValue = value
        if highjumpEnabled then
            humanoid.JumpPower = value
        end
        notify("🦘 HIGH JUMP", "Đã set nhảy cao: " .. value, 2)
    end
    
    local function toggleHighJump()
        highjumpEnabled = not highjumpEnabled
        if highjumpEnabled then
            humanoid.JumpPower = highjumpValue
            notify("🦘 HIGH JUMP", "Đã bật! Lực nhảy: " .. highjumpValue, 2)
        else
            humanoid.JumpPower = 50
            notify("🦘 HIGH JUMP", "Đã tắt!", 2)
        end
    end
    
    -- ========== CHỨC NĂNG FREE GAMEPASS (BYFRASS) ==========
    -- LƯU Ý: Chỉ hoạt động trong 1 số game có lỗ hổng, không phải game nào cũng dùng được
    
    local function bypassGamepass(gamepassId)
        -- Method 1: Fake ownership (client-side only)
        local MarketplaceService = game:GetService("MarketplaceService")
        local success, result = pcall(function()
            return MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamepassId)
        end)
        
        -- Method 2: Override local checks
        local mt = getrawmetatable(game)
        local old = mt.__index
        setreadonly(mt, false)
        mt.__index = newcclosure(function(self, key)
            if key == "UserOwnsGamePassAsync" then
                return function(_, _, id)
                    if id == gamepassId then return true end
                    return old(self, key)(self, key)
                end
            end
            return old(self, key)
        end)
        setreadonly(mt, true)
        
        notify("🎮 GAMEPASS", "Đã bypass gamepass ID: " .. gamepassId .. " (client-side)", 3)
    end
    
    local function freeGamepassUI()
        local passId = tonumber(game:GetService("UserInputService"):GetStringAsync("Nhập Gamepass ID cần bypass:"))
        if passId then
            bypassGamepass(passId)
        end
    end
    
    -- ========== LẤY DANH SÁCH NGƯỜI CHƠI ==========
    local function getPlayerList()
        local list = {}
        for _, plr in pairs(Players:GetPlayers()) do
            table.insert(list, plr)
        end
        return list
    end
    
    -- ========== TẠO UI CUỘN (SCROLLING) ==========
    -- ========== TẠO UI ==========
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DragonPingX"
    screenGui.ResetOnSpawn = false
    
    local parentList = {game:GetService("CoreGui"), player:WaitForChild("PlayerGui")}
    for _, parent in pairs(parentList) do
        local success = pcall(function()
            screenGui.Parent = parent
        end)
        if success and screenGui.Parent then break end
    end
    
    if not screenGui.Parent then
        return notify("❌ LỖI", "Không thể tạo UI! Game quá khóa.", 5)
    end
    
    -- Main Frame (có thể kéo)
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 480, 0, 580)
    main.Position = menuPosition
    main.BackgroundColor3 = Color3.fromRGB(15, 20, 35)
    main.BackgroundTransparency = 0.08
    main.BorderSizePixel = 2
    main.BorderColor3 = Color3.fromRGB(176, 0, 255)
    main.Parent = screenGui
    
    -- Title Bar (kéo được)
    local title = Instance.new("Frame")
    title.Size = UDim2.new(1, 0, 0, 45)
    title.BackgroundColor3 = Color3.fromRGB(176, 0, 255)
    title.BackgroundTransparency = 0.2
    title.Parent = main
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -100, 1, 0)
    titleText.Position = UDim2.new(0, 5, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "🐉 DRAGON PINGX | QANH NO 1"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 16
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = title
    
    -- Nút ẩn menu (✖)
    local hideBtn = Instance.new("TextButton")
    hideBtn.Size = UDim2.new(0, 35, 1, 0)
    hideBtn.Position = UDim2.new(1, -70, 0, 0)
    hideBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    hideBtn.BackgroundTransparency = 0.3
    hideBtn.Text = "✖"
    hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    hideBtn.TextSize = 18
    hideBtn.Font = Enum.Font.SourceSansBold
    hideBtn.Parent = title
    
    -- Nút đóng (X)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 1, 0)
    closeBtn.Position = UDim2.new(1, -35, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.Parent = title
    
    -- ScrollingFrame để chứa nhiều chức năng
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(0.95, 0, 0.85, 0)
    scrollFrame.Position = UDim2.new(0.025, 0, 0.1, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 5
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(176, 0, 255)
    scrollFrame.Parent = main
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 0, 0)
    content.BackgroundTransparency = 1
    content.Parent = scrollFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = content
    
    -- Hàm tạo category
    local function addCategory(titleText)
        local cat = Instance.new("TextLabel")
        cat.Size = UDim2.new(1, 0, 0, 30)
        cat.BackgroundColor3 = Color3.fromRGB(176, 0, 255)
        cat.BackgroundTransparency = 0.3
        cat.Text = "📁 " .. titleText
        cat.TextColor3 = Color3.fromRGB(255, 255, 255)
        cat.TextSize = 14
        cat.Font = Enum.Font.GothamBold
        cat.Parent = content
        
        local catCorner = Instance.new("UICorner")
        catCorner.CornerRadius = UDim.new(0, 6)
        catCorner.Parent = cat
        return cat
    end
    
    -- Hàm tạo nút
    local function addButton(text, callback, color)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 35)
        btn.Position = UDim2.new(0, 5, 0, 0)
        btn.BackgroundColor3 = color or Color3.fromRGB(100, 50, 150)
        btn.BackgroundTransparency = 0.4
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 12
        btn.Parent = content
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            if not isVerified and text ~= "🔑 KÍCH HOẠT" and text ~= "🔗 GET KEY" then
                notify("⚠️", "Cần kích hoạt key trước!", 2)
                return
            end
            callback()
        end)
        return btn
    end
    
    -- Hàm tạo slider
    local function addSlider(text, min, max, defaultValue, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 50)
        frame.BackgroundTransparency = 1
        frame.Parent = content
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = text .. ": " .. defaultValue
        label.TextColor3 = Color3.fromRGB(200, 200, 255)
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        local slider = Instance.new("TextBox")
        slider.Size = UDim2.new(0.3, 0, 0, 25)
        slider.Position = UDim2.new(0.7, 0, 0.2, 0)
        slider.BackgroundColor3 = Color3.fromRGB(30, 35, 55)
        slider.Text = tostring(defaultValue)
        slider.TextColor3 = Color3.fromRGB(255, 255, 255)
        slider.Parent = frame
        
        local apply = Instance.new("TextButton")
        apply.Size = UDim2.new(0.2, 0, 0, 25)
        apply.Position = UDim2.new(0.48, 0, 0.2, 0)
        apply.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        apply.Text = "Áp dụng"
        apply.TextColor3 = Color3.fromRGB(255, 255, 255)
        apply.TextSize = 11
        apply.Parent = frame
        
        apply.MouseButton1Click:Connect(function()
            local val = tonumber(slider.Text)
            if val then
                val = math.clamp(val, min, max)
                slider.Text = tostring(val)
                label.Text = text .. ": " .. val
                callback(val)
            end
        end)
    end
    
    -- Hàm tạo dropdown chọn người chơi
    local function addPlayerDropdown(callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 50)
        frame.BackgroundTransparency = 1
        frame.Parent = content
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.5, 0, 0, 25)
        label.BackgroundTransparency = 1
        label.Text = "👤 CHỌN NGƯỜI CHƠI:"
        label.TextColor3 = Color3.fromRGB(200, 200, 255)
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        local dropdown = Instance.new("TextBox")
        dropdown.Size = UDim2.new(0.45, 0, 0, 30)
        dropdown.Position = UDim2.new(0.5, 0, 0, 0)
        dropdown.BackgroundColor3 = Color3.fromRGB(30, 35, 55)
        dropdown.PlaceholderText = "Tên người chơi"
        dropdown.Text = ""
        dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
        dropdown.Parent = frame
        
        local kickBtn = Instance.new("TextButton")
        kickBtn.Size = UDim2.new(0.45, 0, 0, 30)
        kickBtn.Position = UDim2.new(0.5, 0, 0.55, 0)
        kickBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        kickBtn.Text = "👢 KICK"
        kickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        kickBtn.TextSize = 12
        kickBtn.Parent = frame
        
        kickBtn.MouseButton1Click:Connect(function()
            local targetName = dropdown.Text
            if targetName == "" then
                notify("⚠️", "Nhập tên người chơi cần kick!", 2)
                return
            end
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Name:lower():find(targetName:lower()) then
                    callback(plr)
                    return
                end
            end
            notify("❌", "Không tìm thấy người chơi!", 2)
        end)
    end
    
    -- ========== XÂY DỰNG UI ==========
    
    -- Category: Xác thực
    addCategory("🔐 XÁC THỰC")
    addButton("🔑 KÍCH HOẠT", function()
        local key = game:GetService("UserInputService"):GetStringAsync("Nhập key kích hoạt:")
        if key and verifyKey(key) then
            isVerified = true
            currentKey = key
            notify("✅", "Kích hoạt thành công!", 3)
        elseif key then
            notify("❌", "Key không hợp lệ!", 3)
        end
    end, Color3.fromRGB(0, 180, 100))
    
    addButton("🔗 GET KEY", function()
        local url = API_URL .. "/getkey"
        setclipboard(url)
        notify("🔗", "Đã copy link: " .. url, 4)
    end, Color3.fromRGB(176, 0, 255))
    
    -- Category: Lag Server
    addCategory("💣 LAG SERVER")
    addButton("🔹 SPAM 1000 PARTS", function() lagFunctions.spamParts(1000) end)
    addButton("🔸 SPAM 5000 PARTS", function() lagFunctions.spamParts(5000) end)
    addButton("💥 SPAM REMOTE", function() lagFunctions.spamRemote(3000) end)
    addButton("🌀 LAG CLIENT", function() lagFunctions.clientLag() end)
    addButton("💀 MEGA LAG (ALL)", function() lagFunctions.megaLag() end)
    
    -- Category: Kick Player
    addCategory("👢 KICK NGƯỜI CHƠI")
    addPlayerDropdown(function(plr) kickPlayer(plr) end)
    
    -- Category: Hack Movement
    addCategory("🏃 HACK MOVEMENT")
    addButton("🦘 INFINITY JUMP (BẬT/TẮT)", toggleInfinityJump)
    addButton("⚡ WALKSPEED (BẬT/TẮT)", toggleWalkspeed)
    addSlider("⚡ WALKSPEED", 16, 250, 32, setWalkspeed)
    addButton("🦘 HIGH JUMP (BẬT/TẮT)", toggleHighJump)
    addSlider("🦘 HIGH JUMP", 50, 500, 100, setHighJump)
    
    -- Category: Free Gamepass
    addCategory("🎮 FREE GAMEPASS (BYPASS)")
    addButton("🎮 BYPASS GAMEPASS", freeGamepassUI, Color3.fromRGB(255, 150, 0))
    
    -- Category: Thông tin
    addCategory("ℹ️ THÔNG TIN")
    addButton("📋 LẤY HWID", function()
        notify("🆔 HWID", getHWID(), 5)
    end)
    addButton("🔗 WEBSITE", function()
        setclipboard(API_URL)
        notify("🔗", "Đã copy link website!", 3)
    end)
    
    -- Update content size
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + 10)
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Footer
    local footer = Instance.new("TextLabel")
    footer.Size = UDim2.new(1, 0, 0, 20)
    footer.Position = UDim2.new(0, 0, 1, -20)
    footer.BackgroundTransparency = 1
    footer.Text = "⚡ 3 NGÓN CHẠM ĐỂ HIỆN MENU | KÉO THANH TITLE ĐỂ DI CHUYỂN ⚡"
    footer.TextColor3 = Color3.fromRGB(255, 200, 100)
    footer.TextSize = 9
    footer.Parent = main
    
    -- ========== SỰ KIỆN ==========
    
    -- Nút ẩn menu (✖)
    hideBtn.MouseButton1Click:Connect(function()
        isMenuVisible = false
        local tween = TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0.5, -250, 2, 0)
        })
        tween:Play()
        tween.Completed:Connect(function()
            main.Visible = false
        end)
        notify("🔒", "Menu đã ẩn. Chạm 3 ngón để hiện lại.", 2)
    end)
    
    -- Nút đóng (X)
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        notify("👋", "DRAGON PINGX đã đóng!", 2)
    end)
    
    -- Kéo menu
    local dragging = false
    local dragStart, startPos
    
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            menuPosition = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            main.Position = menuPosition
        end
    end)
    
    -- 3 ngón chạm hiện menu
    local touchCount = 0
    local lastTouchTime = 0
    
    UserInputService.TouchStarted:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        touchCount = touchCount + 1
        lastTouchTime = tick()
        task.delay(0.5, function()
            if tick() - lastTouchTime >= 0.5 then
                touchCount = 0
            end
        end)
        if touchCount >= 3 then
            touchCount = 0
            if not isMenuVisible then
                isMenuVisible = true
                main.Visible = true
                local tween = TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                    Position = menuPosition
                })
                tween:Play()
                notify("🔓", "Menu đã hiện!", 2)
            end
        end
    end)
    
    -- ========== KHỞI CHẠY ==========
    notify("🐉 DRAGON PINGX PRO MAX", "Đã tải thành công! Lấy key tại: " .. API_URL .. "/getkey", 5)
    notify("📱", "Chạm 3 ngón để hiện menu | Kéo title để di chuyển", 4)
    print("✅ DRAGON PINGX PRO MAX v5.0 LOADED")
    print("🔗 Website: " .. API_URL)
    print("🔑 Dùng key: QANHNO1CRACKER (admin key) để test")
    print("📱 3 ngón chạm màn hình để hiện menu")
end)()