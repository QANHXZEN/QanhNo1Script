--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║     🐉 DRAGON PINGX PRO | QANH NO 1 | v4.0                  ║
    ║     🔧 TÍNH NĂNG MỚI: ẨN MENU + 3 NGÓN BẬT                 ║
    ║     📡 WEBSITE: https://roszmodxqanhno1.onrender.com        ║
    ╚═══════════════════════════════════════════════════════════════╝
--]]

(function()
    -- ========== SERVICES ==========
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local HttpService = game:GetService("HttpService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local player = Players.LocalPlayer
    
    -- ========== CONFIG ==========
    local API_URL = "https://roszmodxqanhno1.onrender.com"
    local isVerified = false
    local currentKey = ""
    local isMenuVisible = true
    
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
    
    -- Main Frame
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 420, 0, 540)
    main.Position = UDim2.new(0.5, -210, 0.5, -270)
    main.BackgroundColor3 = Color3.fromRGB(15, 20, 35)
    main.BackgroundTransparency = 0.08
    main.BorderSizePixel = 2
    main.BorderColor3 = Color3.fromRGB(176, 0, 255)
    main.Parent = screenGui
    
    -- Title Bar
    local title = Instance.new("Frame")
    title.Size = UDim2.new(1, 0, 0, 45)
    title.BackgroundColor3 = Color3.fromRGB(176, 0, 255)
    title.BackgroundTransparency = 0.2
    title.Parent = main
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -70, 1, 0)
    titleText.Position = UDim2.new(0, 5, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "🐉 DRAGON PINGX | QANH NO 1"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 16
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = title
    
    -- Nút ẩn menu (dấu ✖)
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
    
    -- Nút đóng (dấu X)
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
    
    -- Status
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(0.9, 0, 0, 30)
    status.Position = UDim2.new(0.05, 0, 0.12, 0)
    status.BackgroundTransparency = 1
    status.Text = "🔒 CHƯA KÍCH HOẠT"
    status.TextColor3 = Color3.fromRGB(255, 100, 100)
    status.TextSize = 13
    status.Font = Enum.Font.GothamSemibold
    status.Parent = main
    
    -- Key Input
    local keyLabel = Instance.new("TextLabel")
    keyLabel.Size = UDim2.new(0.9, 0, 0, 20)
    keyLabel.Position = UDim2.new(0.05, 0, 0.2, 0)
    keyLabel.BackgroundTransparency = 1
    keyLabel.Text = "🔑 NHẬP KEY KÍCH HOẠT:"
    keyLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    keyLabel.TextSize = 12
    keyLabel.TextXAlignment = Enum.TextXAlignment.Left
    keyLabel.Parent = main
    
    local keyBox = Instance.new("TextBox")
    keyBox.Size = UDim2.new(0.9, 0, 0, 40)
    keyBox.Position = UDim2.new(0.05, 0, 0.25, 0)
    keyBox.BackgroundColor3 = Color3.fromRGB(30, 35, 55)
    keyBox.PlaceholderText = "Dán key vào đây..."
    keyBox.Text = ""
    keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyBox.TextSize = 13
    keyBox.Parent = main
    
    -- Buttons
    local verifyBtn = Instance.new("TextButton")
    verifyBtn.Size = UDim2.new(0.43, 0, 0, 40)
    verifyBtn.Position = UDim2.new(0.05, 0, 0.33, 0)
    verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    verifyBtn.Text = "✅ KÍCH HOẠT"
    verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    verifyBtn.TextSize = 13
    verifyBtn.Font = Enum.Font.GothamBold
    verifyBtn.Parent = main
    
    local getKeyBtn = Instance.new("TextButton")
    getKeyBtn.Size = UDim2.new(0.43, 0, 0, 40)
    getKeyBtn.Position = UDim2.new(0.52, 0, 0.33, 0)
    getKeyBtn.BackgroundColor3 = Color3.fromRGB(176, 0, 255)
    getKeyBtn.Text = "🔗 GET KEY"
    getKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    getKeyBtn.TextSize = 13
    getKeyBtn.Font = Enum.Font.GothamBold
    getKeyBtn.Parent = main
    
    -- Separator
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0.9, 0, 0, 1)
    line.Position = UDim2.new(0.05, 0, 0.42, 0)
    line.BackgroundColor3 = Color3.fromRGB(176, 0, 255)
    line.BackgroundTransparency = 0.6
    line.Parent = main
    
    -- Lag Title
    local lagTitle = Instance.new("TextLabel")
    lagTitle.Size = UDim2.new(0.9, 0, 0, 25)
    lagTitle.Position = UDim2.new(0.05, 0, 0.45, 0)
    lagTitle.BackgroundTransparency = 1
    lagTitle.Text = "💣 CHỌN CHẾ ĐỘ LAG:"
    lagTitle.TextColor3 = Color3.fromRGB(255, 200, 100)
    lagTitle.TextSize = 13
    lagTitle.TextXAlignment = Enum.TextXAlignment.Left
    lagTitle.Font = Enum.Font.GothamBold
    lagTitle.Parent = main
    
    -- ========== LAG FUNCTIONS ==========
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
            return count
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
            if #remotes == 0 then return 0 end
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
            return iterations
        end,
        
        clientLag = function()
            local conn = RunService.RenderStepped:Connect(function()
                for i = 1, 5000 do
                    local x = math.sin(i) * math.cos(i) / math.tan(i + 1)
                end
            end)
            return conn
        end,
        
        megaLag = function()
            lagFunctions.spamParts(2000)
            task.wait(1)
            lagFunctions.spamRemote(2000)
            task.wait(1)
            lagFunctions.clientLag()
            return 2000
        end
    }
    
    -- ========== TẠO NÚT LAG ==========
    local lagButtons = {
        {text = "🔹 SPAM 1000 PARTS", y = 0.51, func = lagFunctions.spamParts, arg = 1000},
        {text = "🔸 SPAM 5000 PARTS", y = 0.57, func = lagFunctions.spamParts, arg = 5000},
        {text = "💥 SPAM REMOTE", y = 0.63, func = lagFunctions.spamRemote, arg = 3000},
        {text = "🌀 LAG CLIENT", y = 0.69, func = lagFunctions.clientLag, arg = nil},
        {text = "💀 MEGA LAG (ALL)", y = 0.75, func = lagFunctions.megaLag, arg = nil}
    }
    
    for _, btnData in pairs(lagButtons) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 35)
        btn.Position = UDim2.new(0.05, 0, btnData.y, 0)
        btn.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
        btn.BackgroundTransparency = 0.4
        btn.Text = btnData.text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 12
        btn.Parent = main
        
        btn.MouseButton1Click:Connect(function()
            if not isVerified then
                status.Text = "⚠️ CẦN KÍCH HOẠT TRƯỚC!"
                status.TextColor3 = Color3.fromRGB(255, 200, 100)
                notify("⚠️ CHƯA KÍCH HOẠT", "Vui lòng nhập key và bấm KÍCH HOẠT trước khi dùng lag!", 3)
                return
            end
            
            local oldText = status.Text
            status.Text = "💀 ĐANG LAG: " .. btnData.text
            status.TextColor3 = Color3.fromRGB(255, 100, 100)
            
            local result = 0
            if btnData.arg then
                result = btnData.func(btnData.arg)
            else
                result = btnData.func()
            end
            
            status.Text = "✅ LAG XONG! (" .. tostring(result) .. " tác vụ)"
            status.TextColor3 = Color3.fromRGB(100, 255, 100)
            notify("✅ DRAGON PINGX", "Đã thi hành: " .. btnData.text, 2)
            
            task.wait(2)
            status.Text = oldText
            if isVerified then
                status.TextColor3 = Color3.fromRGB(100, 255, 100)
            else
                status.TextColor3 = Color3.fromRGB(255, 100, 100)
            end
        end)
    end
    
    -- Footer
    local footer = Instance.new("TextLabel")
    footer.Size = UDim2.new(1, 0, 0, 25)
    footer.Position = UDim2.new(0, 0, 1, -25)
    footer.BackgroundTransparency = 1
    footer.Text = "⚡ 3 NGÓN CHẠM MÀN HÌNH ĐỂ HIỆN MENU ⚡"
    footer.TextColor3 = Color3.fromRGB(255, 200, 100)
    footer.TextSize = 10
    footer.Parent = main
    
    -- ========== SỰ KIỆN ==========
    -- Nút ẩn menu (✖)
    hideBtn.MouseButton1Click:Connect(function()
        isMenuVisible = false
        local tween = TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0.5, -210, 2, 0)
        })
        tween:Play()
        tween.Completed:Connect(function()
            main.Visible = false
        end)
        notify("🔒 MENU", "Đã ẩn menu. Chạm 3 ngón vào màn hình để hiện lại.", 3)
    end)
    
    -- Nút đóng (X)
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        notify("👋 DRAGON PINGX", "Đã đóng!", 2)
    end)
    
    getKeyBtn.MouseButton1Click:Connect(function()
        local url = API_URL .. "/getkey"
        setclipboard(url)
        notify("🔗 ĐÃ COPY LINK!", "Dán vào trình duyệt để lấy key: " .. url, 5)
        status.Text = "📋 ĐÃ COPY LINK GET KEY!"
        status.TextColor3 = Color3.fromRGB(255, 200, 100)
        task.wait(2)
        if isVerified then
            status.Text = "✅ SẴN SÀNG"
            status.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            status.Text = "🔒 NHẬP KEY ĐỂ KÍCH HOẠT"
            status.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
    
    verifyBtn.MouseButton1Click:Connect(function()
        local key = keyBox.Text
        if key == "" then
            status.Text = "❌ NHẬP KEY!"
            status.TextColor3 = Color3.fromRGB(255, 100, 100)
            notify("❌ LỖI", "Vui lòng nhập key!", 2)
            return
        end
        
        status.Text = "⏳ ĐANG XÁC THỰC..."
        status.TextColor3 = Color3.fromRGB(255, 200, 100)
        
        local success = verifyKey(key)
        
        if success then
            isVerified = true
            currentKey = key
            status.Text = "✅ KÍCH HOẠT THÀNH CÔNG!"
            status.TextColor3 = Color3.fromRGB(100, 255, 100)
            notify("✅ DRAGON PINGX", "Kích hoạt thành công! Chọn chế độ lag để bắt đầu.", 3)
        else
            isVerified = false
            status.Text = "❌ KEY KHÔNG HỢP LỆ!"
            status.TextColor3 = Color3.fromRGB(255, 100, 100)
            notify("❌ THẤT BẠI", "Key không hợp lệ hoặc đã hết hạn!", 3)
        end
    end)
    
    -- ========== 3 NGÓN CHẠM HIỆN MENU ==========
    local touchCount = 0
    local lastTouchTime = 0
    
    UserInputService.TouchStarted:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        touchCount = touchCount + 1
        lastTouchTime = tick()
        
        -- Reset touchCount sau 0.5 giây
        task.delay(0.5, function()
            if tick() - lastTouchTime >= 0.5 then
                touchCount = 0
            end
        end)
        
        -- Nếu có 3 ngón chạm cùng lúc
        if touchCount >= 3 then
            touchCount = 0
            if not isMenuVisible then
                isMenuVisible = true
                main.Visible = true
                local tween = TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                    Position = UDim2.new(0.5, -210, 0.5, -270)
                })
                tween:Play()
                notify("🔓 MENU", "Đã hiện menu!", 2)
            end
        end
    end)
    
    -- ========== KÉO CỬA SỔ ==========
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
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- ========== KHỞI CHẠY ==========
    notify("🐉 DRAGON PINGX", "Đã tải thành công! Lấy key tại: " .. API_URL .. "/getkey", 5)
    notify("📱", "Chạm 3 ngón vào màn hình để hiện menu nếu bị ẩn.", 4)
    print("✅ DRAGON PINGX PRO - QANH NO 1 v4.0 LOADED")
    print("🔗 Website: " .. API_URL)
    print("🔑 Dùng key: QANHNO1CRACKER (admin key) để test")
    print("📱 3 ngón chạm màn hình để hiện menu")
end)()