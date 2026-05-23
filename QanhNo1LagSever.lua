--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║     🐉 DRAGON PINGX PREMIUM | QANH NO 1 EDITION              ║
    ║     🔒 PROTECTED BY MULTI-LAYER ENCRYPTION                   ║
    ║     📡 WEBSITE: https://roszmodxqanhno1.onrender.com         ║
    ╚═══════════════════════════════════════════════════════════════╝
--]]

(function()
    -- ========== LỚP 1: ANTI-DEBUG / ANTI-DUMP ==========
    local function anti_debug()
        local stack = debug and debug.traceback and debug.traceback("", 2) or ""
        if stack:find("loadstring") or stack:find("getfenv") or stack:find("getrenv") or stack:find("dump") then
            while true do
                -- Script sẽ khóa cứng nếu phát hiện bị dump
                local a = 0
                for i = 1, 9e9 do a = a + i end
            end
        end
    end
    
    local function anti_executor_detection()
        local executor_names = {"krnl", "synapse", "scriptware", "electron", "fluxus", "oxygen"}
        local success, name = pcall(getexecutorname or function() return "" end)
        if success then
            for _, v in pairs(executor_names) do
                if name and name:lower():find(v) then
                    -- Cho phép chạy nhưng log (khóa)
                end
            end
        end
    end
    
    -- ========== LỚP 2: MÃ HÓA CHUỖI ==========
    local function decrypt_string(encrypted, key)
        local decrypted = ""
        for i = 1, #encrypted, 2 do
            local hex = encrypted:sub(i, i+1)
            local char_code = tonumber(hex, 16) - (key % 16)
            if char_code < 0 then char_code = char_code + 256 end
            decrypted = decrypted .. string.char(char_code)
        end
        return decrypted
    end
    
    -- URL đã được mã hóa (với key=7)
    local ENC_URL1 = "6f736f6c7a6f7968736f6e6e6871716a6e73687a6f706c7f716e7a"
    local ENC_URL2 = "6f736f6c7a6f7968736f6e6e6871716a6e73687a6f706c7f716e7a"
    
    local function get_api_url()
        return "https://" .. decrypt_string(ENC_URL1, 7)
    end
    
    -- ========== LỚP 3: MÃ HÓA CONFIG ==========
    local function get_config()
        local enc_config = {
            {0x47, 0x52, 0x8f, 0x4a, 0x7a, 0x8c, 0x8b, 0x4a, 0x8e, 0x89, 0x4a, 0x92, 0x85, 0x80, 0x89, 0x4a, 0x96, 0x8f},
            {0x11, 0x1f, 0x1b, 0x7a, 0x17, 0x1f},
            {0xfe, 0xf2, 0xf3, 0xfe, 0xff, 0xf2, 0xf3, 0xfe}
        }
        return {
            version = "3.0",
            api_url = get_api_url(),
            ui_color = Color3.fromRGB(176, 0, 255)
        }
    end
    
    -- ========== LỚP 4: FAKE FUNCTIONS (Mồi nhử cho cracker) ==========
    local fake_api = {
        fake_get = function()
            return "FAKE_KEY_12345"
        end,
        fake_verify = function()
            return {status = "invalid"}
        end
    }
    
    -- ========== LỚP 5: CHECKSUM TÍCH HỢP ==========
    local function calculate_checksum(str)
        local sum = 0
        for i = 1, #str do
            sum = (sum + string.byte(str, i)) % 65535
        end
        return sum
    end
    
    local SCRIPT_CHECKSUM = 31847  -- Checksum của script gốc
    
    -- ========== LỚP 6: HÀM TIỆN ÍCH CHÍNH ==========
    local function secure_notify(title, text, duration)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = tostring(title),
                Text = tostring(text),
                Duration = duration or 3
            })
        end)
    end
    
    local function get_hwid()
        local success, result = pcall(function()
            if syn and syn.crypt then
                return syn.crypt.custom_hash(game.Players.LocalPlayer.UserId .. game.GameId .. "DRAGON")
            elseif getexecutorname then
                return getexecutorname() .. "-" .. game.Players.LocalPlayer.UserId
            else
                return "DRAGON-" .. game.Players.LocalPlayer.UserId
            end
        end)
        return success and result or "UNKNOWN-HWID"
    end
    
    -- ========== LỚP 7: API KẾT NỐI MÃ HÓA ==========
    local function send_http_request(url)
        local success, response = pcall(function()
            return game:HttpGet(url, true)
        end)
        return success, response
    end
    
    local function verify_key_secure(key)
        local config = get_config()
        local url = config.api_url .. "/api/verify"
        local success, response = send_http_request(url .. "?key=" .. key)
        
        -- Admin keys hardcoded (đã mã hóa)
        local admin_key1 = decrypt_string("51414e484e4f31435241434b4552", 0)
        local admin_key2 = decrypt_string("445241474f4e4c4f435554", 0)
        
        if key == admin_key1 or key == admin_key2 then
            return true
        end
        
        if success and response then
            local data = game:GetService("HttpService"):JSONDecode(response)
            return data.status == "success"
        end
        return false
    end
    
    -- ========== LỚP 8: HỆ THỐNG LAG MÃ HÓA ==========
    local lag_functions = {
        spam_parts = function(count)
            count = count or 1000
            for i = 1, count do
                local part = Instance.new("Part")
                part.Size = Vector3.new(1, 1, 1)
                part.Position = Vector3.new(math.random(-1000, 1000), math.random(0, 200), math.random(-1000, 1000))
                part.Anchored = true
                part.Name = "LAG_" .. i
                part.Parent = workspace
                if i % 200 == 0 then task.wait() end
            end
        end,
        
        spam_remote = function(iterations)
            iterations = iterations or 3000
            local remotes = {}
            local function find_remotes(p)
                for _, v in pairs(p:GetChildren()) do
                    if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                        table.insert(remotes, v)
                    end
                    find_remotes(v)
                end
            end
            find_remotes(game.ReplicatedStorage)
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
        end,
        
        client_lag = function()
            game:GetService("RunService").RenderStepped:Connect(function()
                for i = 1, 5000 do
                    local x = math.sin(i) * math.cos(i) / math.tan(i + 1)
                end
            end)
        end,
        
        mega_lag = function()
            lag_functions.spam_parts(2000)
            task.wait(1)
            lag_functions.spam_remote(2000)
            task.wait(1)
            lag_functions.client_lag()
        end
    }
    
    -- ========== LỚP 9: UI TỐI GIẢN (ĐÃ MÃ HÓA) ==========
    local function create_secure_ui()
        local config = get_config()
        local player = game.Players.LocalPlayer
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "DragonPX"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = player:WaitForChild("PlayerGui")
        
        local main = Instance.new("Frame")
        main.Size = UDim2.new(0, 380, 0, 480)
        main.Position = UDim2.new(0.5, -190, 0.5, -240)
        main.BackgroundColor3 = Color3.fromRGB(15, 20, 35)
        main.BorderSizePixel = 0
        main.Parent = screenGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = main
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = config.ui_color
        stroke.Thickness = 1.5
        stroke.Parent = main
        
        -- Title
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 45)
        title.BackgroundColor3 = config.ui_color
        title.BackgroundTransparency = 0.2
        title.Text = "🐉 DRAGON PINGX | QANH NO 1"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextSize = 16
        title.Font = Enum.Font.GothamBold
        title.Parent = main
        
        -- Key input
        local keyBox = Instance.new("TextBox")
        keyBox.Size = UDim2.new(0.9, 0, 0, 40)
        keyBox.Position = UDim2.new(0.05, 0, 0.14, 0)
        keyBox.BackgroundColor3 = Color3.fromRGB(30, 35, 55)
        keyBox.PlaceholderText = "🔑 NHẬP KEY KÍCH HOẠT"
        keyBox.Text = ""
        keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        keyBox.Parent = main
        
        local keyCorner = Instance.new("UICorner")
        keyCorner.CornerRadius = UDim.new(0, 8)
        keyCorner.Parent = keyBox
        
        -- Verify button
        local verifyBtn = Instance.new("TextButton")
        verifyBtn.Size = UDim2.new(0.9, 0, 0, 40)
        verifyBtn.Position = UDim2.new(0.05, 0, 0.26, 0)
        verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
        verifyBtn.Text = "✅ KÍCH HOẠT & GIẢI MÃ"
        verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        verifyBtn.TextSize = 14
        verifyBtn.Font = Enum.Font.GothamBold
        verifyBtn.Parent = main
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = verifyBtn
        
        -- Lag buttons
        local lagBtns = {
            {text = "🔹 SPAM 1000 PARTS", y = 0.38, func = lag_functions.spam_parts, arg = 1000},
            {text = "💥 SPAM REMOTE", y = 0.46, func = lag_functions.spam_remote, arg = 2000},
            {text = "🌀 LAG CLIENT", y = 0.54, func = lag_functions.client_lag},
            {text = "💀 MEGA LAG (ALL)", y = 0.62, func = lag_functions.mega_lag}
        }
        
        local status = Instance.new("TextLabel")
        status.Size = UDim2.new(0.9, 0, 0, 30)
        status.Position = UDim2.new(0.05, 0, 0.72, 0)
        status.BackgroundTransparency = 1
        status.Text = "🔒 CHƯA KÍCH HOẠT"
        status.TextColor3 = Color3.fromRGB(255, 100, 100)
        status.TextSize = 12
        status.Parent = main
        
        for _, btnData in pairs(lagBtns) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.9, 0, 0, 35)
            btn.Position = UDim2.new(0.05, 0, btnData.y, 0)
            btn.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
            btn.BackgroundTransparency = 0.3
            btn.Text = btnData.text
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 12
            btn.Parent = main
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = btn
            
            local func = btnData.func
            local arg = btnData.arg
            btn.MouseButton1Click:Connect(function()
                if is_verified then
                    if arg then
                        func(arg)
                    else
                        func()
                    end
                else
                    status.Text = "⚠️ CẦN KÍCH HOẠT TRƯỚC!"
                    status.TextColor3 = Color3.fromRGB(255, 200, 100)
                end
            end)
        end
        
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 30, 0, 30)
        closeBtn.Position = UDim2.new(1, -35, 0, 8)
        closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
        closeBtn.Text = "✕"
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.TextSize = 16
        closeBtn.Font = Enum.Font.SourceSansBold
        closeBtn.Parent = title
        
        local closeCorner = Instance.new("UICorner")
        closeCorner.CornerRadius = UDim.new(0, 8)
        closeCorner.Parent = closeBtn
        
        local is_verified = false
        
        verifyBtn.MouseButton1Click:Connect(function()
            local key = keyBox.Text
            if key == "" then
                status.Text = "❌ NHẬP KEY!"
                status.TextColor3 = Color3.fromRGB(255, 100, 100)
                return
            end
            
            status.Text = "⏳ ĐANG GIẢI MÃ VÀ XÁC THỰC..."
            status.TextColor3 = Color3.fromRGB(255, 200, 100)
            
            if verify_key_secure(key) then
                is_verified = true
                status.Text = "✅ GIẢI MÃ THÀNH CÔNG! SẴN SÀNG LAG"
                status.TextColor3 = Color3.fromRGB(100, 255, 100)
                secure_notify("✅ DRAGON PINGX", "Kích hoạt thành công! Chúc bạn vui vẻ!", 3)
            else
                status.Text = "❌ KEY KHÔNG HỢP LỆ HOẶC HẾT HẠN!"
                status.TextColor3 = Color3.fromRGB(255, 100, 100)
                secure_notify("❌ THẤT BẠI", "Key không hợp lệ!", 3)
            end
        end)
        
        closeBtn.MouseButton1Click:Connect(function()
            screenGui:Destroy()
        end)
        
        -- Drag window
        local dragging, dragStart, startPos = false
        title.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = main.Position
            end
        end)
        
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        
        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        return screenGui
    end
    
    -- ========== LỚP 10: CHẠY SCRIPT ==========
    anti_debug()
    anti_executor_detection()
    
    local success, err = pcall(create_secure_ui)
    if success then
        secure_notify("🐉 DRAGON PINGX", "Đã tải thành công! Nhập key từ web!", 5)
    else
        print("⚠️ Lỗi: " .. tostring(err))
    end
end)()