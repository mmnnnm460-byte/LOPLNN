-- LocalScript في StarterPlayerScripts
-- ScriptV4 LPMK Edition

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- ===== إعدادات =====
local ACCESS_CODE = "889"
local DEVELOPER_USERS = {"maxra2w"}
local isDeveloper = false
for _, u in ipairs(DEVELOPER_USERS) do
    if player.Name:lower() == u:lower() then isDeveloper = true end
end

-- ===== متغيرات =====
local savedPositions = {}
local speedActive = false
local noclipActive = false
local jumpActive = false
local infiniteJumpActive = false
local selectedPlayer = nil
local spectateActive = false
local spectateConnection = nil
local saveCount = 0
local colorStep = 0
local currentSpeed = 66

-- ===== أصوات =====
local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://6895079853"; clickSound.Volume = 0.5; clickSound.Parent = SoundService
local successSound = Instance.new("Sound")
successSound.SoundId = "rbxassetid://4590657391"; successSound.Volume = 0.8; successSound.Parent = SoundService
local errorSound = Instance.new("Sound")
errorSound.SoundId = "rbxassetid://3201169635"; errorSound.Volume = 0.8; errorSound.Parent = SoundService
local function playClick() clickSound:Play() end

local function copyToClipboard(text)
    local ok = pcall(function() setclipboard(text) end)
    if not ok then
        local tb = Instance.new("TextBox"); tb.Text = text; tb.Parent = player.PlayerGui
        tb:CaptureFocus(); tb:ReleaseFocus(); tb:Destroy()
    end
end

RunService.Heartbeat:Connect(function(dt) colorStep = colorStep + dt * 1.8 end)

local function bwColor()
    local t = (math.sin(colorStep) + 1) / 2
    local v = math.floor(255 * t)
    return Color3.fromRGB(v, v, v)
end
local function bwColorFast()
    local t = (math.sin(colorStep * 2.5) + 1) / 2
    local v = math.floor(255 * t)
    return Color3.fromRGB(v, v, v)
end

-- ========== ScreenGui ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptV4_LPMK"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

-- =========================================
-- شاشة المفتاح
-- =========================================
local keyScreen = Instance.new("Frame")
keyScreen.Size = UDim2.new(1,0,1,0); keyScreen.BackgroundColor3 = Color3.fromRGB(0,0,0)
keyScreen.BackgroundTransparency = 0.35; keyScreen.BorderSizePixel = 0; keyScreen.ZIndex = 100; keyScreen.Parent = screenGui

local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0,320,0,210); keyFrame.Position = UDim2.new(0.5,-160,0.5,-105)
keyFrame.BackgroundColor3 = Color3.fromRGB(8,8,8); keyFrame.BorderSizePixel = 0; keyFrame.ZIndex = 101; keyFrame.Parent = keyScreen
Instance.new("UICorner", keyFrame).CornerRadius = UDim.new(0,16)
local kfStroke = Instance.new("UIStroke"); kfStroke.Thickness = 2.5; kfStroke.Color = Color3.fromRGB(255,255,255); kfStroke.Parent = keyFrame
RunService.Heartbeat:Connect(function() if keyScreen and keyScreen.Parent then kfStroke.Color = bwColor() end end)

local kTitle = Instance.new("TextLabel")
kTitle.Size = UDim2.new(1,0,0,44); kTitle.BackgroundTransparency = 1; kTitle.Text = "🔐  ScriptV4 LPMK"
kTitle.TextColor3 = Color3.fromRGB(255,255,255); kTitle.TextSize = 17; kTitle.Font = Enum.Font.GothamBold
kTitle.ZIndex = 102; kTitle.Parent = keyFrame

local kSub = Instance.new("TextLabel")
kSub.Size = UDim2.new(1,0,0,18); kSub.Position = UDim2.new(0,0,0,40)
kSub.BackgroundTransparency = 1; kSub.Text = "أدخل المفتاح للمتابعة"
kSub.TextColor3 = Color3.fromRGB(160,160,160); kSub.TextSize = 12; kSub.Font = Enum.Font.Gotham
kSub.ZIndex = 102; kSub.Parent = keyFrame

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1,-40,0,44); keyBox.Position = UDim2.new(0,20,0,68)
keyBox.BackgroundColor3 = Color3.fromRGB(20,20,20); keyBox.Text = ""
keyBox.PlaceholderText = "المفتاح هنا..."; keyBox.PlaceholderColor3 = Color3.fromRGB(90,90,90)
keyBox.TextColor3 = Color3.fromRGB(255,255,255); keyBox.TextSize = 16; keyBox.Font = Enum.Font.GothamBold
keyBox.ClearTextOnFocus = false; keyBox.BorderSizePixel = 0; keyBox.ZIndex = 102; keyBox.Parent = keyFrame
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0,10)
local kbStroke = Instance.new("UIStroke"); kbStroke.Color = Color3.fromRGB(180,180,180); kbStroke.Thickness = 1.5; kbStroke.Parent = keyBox

local keyBtn = Instance.new("TextButton")
keyBtn.Size = UDim2.new(1,-40,0,42); keyBtn.Position = UDim2.new(0,20,0,122)
keyBtn.BackgroundColor3 = Color3.fromRGB(30,30,30); keyBtn.Text = "✅  دخول"
keyBtn.TextColor3 = Color3.fromRGB(255,255,255); keyBtn.TextSize = 14; keyBtn.Font = Enum.Font.GothamBold
keyBtn.BorderSizePixel = 0; keyBtn.ZIndex = 102; keyBtn.Parent = keyFrame
Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0,10)
local kbtnStroke = Instance.new("UIStroke"); kbtnStroke.Color = Color3.fromRGB(200,200,200); kbtnStroke.Thickness = 1.5; kbtnStroke.Parent = keyBtn

local keyStatus = Instance.new("TextLabel")
keyStatus.Size = UDim2.new(1,0,0,24); keyStatus.Position = UDim2.new(0,0,0,172)
keyStatus.BackgroundTransparency = 1; keyStatus.Text = ""
keyStatus.TextColor3 = Color3.fromRGB(255,80,80); keyStatus.TextSize = 13; keyStatus.Font = Enum.Font.GothamBold
keyStatus.ZIndex = 102; keyStatus.Parent = keyFrame

-- =========================================
-- دالة بناء الواجهة الرئيسية
-- =========================================
local function buildMainGUI()
    if keyScreen and keyScreen.Parent then keyScreen:Destroy() end

    -- ===== مساعدات =====
    local function addWhiteStroke(obj, thickness)
        local s = Instance.new("UIStroke"); s.Color = Color3.fromRGB(255,255,255); s.Thickness = thickness or 1.5; s.Parent = obj
        RunService.Heartbeat:Connect(function() s.Color = bwColor() end)
        return s
    end

    local function makeWindow(posX, posY, w, h, title, emoji)
        local win = Instance.new("Frame")
        win.Size = UDim2.new(0,w,0,h); win.Position = UDim2.new(0,posX,0,posY)
        win.BackgroundColor3 = Color3.fromRGB(8,8,8); win.BorderSizePixel = 0
        win.Active = true; win.Visible = false; win.Parent = screenGui
        Instance.new("UICorner", win).CornerRadius = UDim.new(0,14)
        addWhiteStroke(win, 2)

        -- glow متحرك
        RunService.Heartbeat:Connect(function()
            local t = (math.sin(colorStep)+1)/2
            win.BackgroundColor3 = Color3.fromRGB(math.floor(6+6*t), math.floor(6+6*t), math.floor(6+6*t))
        end)

        local tb = Instance.new("Frame")
        tb.Size = UDim2.new(1,0,0,38); tb.BackgroundColor3 = Color3.fromRGB(16,16,16)
        tb.BorderSizePixel = 0; tb.Parent = win
        Instance.new("UICorner", tb).CornerRadius = UDim.new(0,14)

        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size = UDim2.new(1,-16,1,0); titleLbl.Position = UDim2.new(0,12,0,0)
        titleLbl.BackgroundTransparency = 1; titleLbl.Text = (emoji or "")..title
        titleLbl.TextColor3 = Color3.fromRGB(255,255,255); titleLbl.TextSize = 14; titleLbl.Font = Enum.Font.GothamBold
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left; titleLbl.Parent = tb

        -- سحب
        local drag, ds, dp
        tb.InputBegan:Connect(function(inp)
            if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
                drag=true; ds=inp.Position; dp=win.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(inp)
            if drag and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
                local d=inp.Position-ds
                win.Position=UDim2.new(dp.X.Scale,dp.X.Offset+d.X,dp.Y.Scale,dp.Y.Offset+d.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(inp)
            if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then drag=false end
        end)

        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(1,-12,1,-46); scroll.Position = UDim2.new(0,6,0,42)
        scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 4; scroll.ScrollBarImageColor3 = Color3.fromRGB(200,200,200)
        scroll.CanvasSize = UDim2.new(0,0,0,0); scroll.Parent = win
        local ul = Instance.new("UIListLayout"); ul.SortOrder = Enum.SortOrder.LayoutOrder; ul.Padding = UDim.new(0,5); ul.Parent = scroll
        local up = Instance.new("UIPadding"); up.PaddingTop=UDim.new(0,4); up.PaddingBottom=UDim.new(0,4); up.Parent = scroll
        ul:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scroll.CanvasSize = UDim2.new(0,0,0,ul.AbsoluteContentSize.Y+8)
        end)

        return win, scroll
    end

    local function makeBtn(parent, text, order)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,0,0,40); btn.BackgroundColor3 = Color3.fromRGB(20,20,20)
        btn.Text = text; btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.TextSize = 13; btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0; btn.LayoutOrder = order or 0; btn.Parent = parent
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
        addWhiteStroke(btn, 1.2)
        btn.MouseButton1Click:Connect(playClick)
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(38,38,38)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(20,20,20)}):Play()
        end)
        return btn
    end

    local function makeLbl(parent, text, order)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1,0,0,18); l.BackgroundTransparency = 1
        l.Text = text; l.TextColor3 = Color3.fromRGB(180,180,180)
        l.TextSize = 12; l.Font = Enum.Font.GothamBold
        l.TextXAlignment = Enum.TextXAlignment.Left; l.LayoutOrder = order or 0; l.Parent = parent
        return l
    end

    local function makeInputRow(parent, defText, btnText, order)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1,0,0,40); row.BackgroundTransparency = 1
        row.LayoutOrder = order or 0; row.Parent = parent
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(0,108,0,36); box.Position = UDim2.new(0,0,0.5,-18)
        box.BackgroundColor3 = Color3.fromRGB(18,18,18); box.Text = defText
        box.TextColor3 = Color3.fromRGB(255,255,255); box.PlaceholderText = "رقم..."
        box.PlaceholderColor3 = Color3.fromRGB(100,100,100); box.TextSize = 14
        box.Font = Enum.Font.GothamBold; box.BorderSizePixel = 0; box.ClearTextOnFocus = false; box.Parent = row
        Instance.new("UICorner", box).CornerRadius = UDim.new(0,8)
        addWhiteStroke(box, 1.3)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,-116,0,36); btn.Position = UDim2.new(0,116,0.5,-18)
        btn.BackgroundColor3 = Color3.fromRGB(22,22,22); btn.Text = btnText
        btn.TextColor3 = Color3.fromRGB(255,255,255); btn.TextSize = 12
        btn.Font = Enum.Font.GothamBold; btn.BorderSizePixel = 0; btn.Parent = row
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,9)
        addWhiteStroke(btn, 1.2)
        btn.MouseButton1Click:Connect(playClick)
        return box, btn
    end

    local function toggleWin(win, stateRef, targetH)
        if stateRef[1] then
            stateRef[1] = false
            TweenService:Create(win,TweenInfo.new(0.2),{Size=UDim2.new(0,win.Size.X.Offset,0,0),BackgroundTransparency=1}):Play()
            task.delay(0.2, function() win.Visible=false end)
        else
            stateRef[1] = true; win.Visible=true; win.Size=UDim2.new(0,win.Size.X.Offset,0,0)
            TweenService:Create(win,TweenInfo.new(0.25,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,win.Size.X.Offset,0,targetH),BackgroundTransparency=0}):Play()
        end
    end

    -- ==========================================
    -- شريط الأيقونات
    -- ==========================================
    local iconBar = Instance.new("Frame")
    iconBar.Size = UDim2.new(0,52,0,390); iconBar.Position = UDim2.new(0,10,0,60)
    iconBar.BackgroundColor3 = Color3.fromRGB(10,10,10); iconBar.BorderSizePixel = 0
    iconBar.Active = true; iconBar.ZIndex = 20; iconBar.Parent = screenGui
    Instance.new("UICorner", iconBar).CornerRadius = UDim.new(0,14)
    addWhiteStroke(iconBar, 2)

    -- سحب شريط الأيقونات
    local ibDrag, ibStart, ibPos
    iconBar.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            ibDrag=true; ibStart=inp.Position; ibPos=iconBar.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if ibDrag and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
            local d=inp.Position-ibStart
            iconBar.Position=UDim2.new(ibPos.X.Scale,ibPos.X.Offset+d.X,ibPos.Y.Scale,ibPos.Y.Offset+d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then ibDrag=false end
    end)

    RunService.Heartbeat:Connect(function()
        local t=(math.sin(colorStep)+1)/2
        iconBar.BackgroundColor3=Color3.fromRGB(math.floor(8+8*t),math.floor(8+8*t),math.floor(8+8*t))
    end)

    local function makeIconBtn(emoji, yPos, tooltip)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0,40,0,40); btn.Position = UDim2.new(0.5,-20,0,yPos)
        btn.BackgroundColor3 = Color3.fromRGB(18,18,18); btn.Text = emoji
        btn.TextSize = 20; btn.Font = Enum.Font.GothamBold
        btn.TextColor3 = Color3.fromRGB(255,255,255); btn.BorderSizePixel = 0
        btn.ZIndex = 21; btn.Parent = iconBar
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
        addWhiteStroke(btn, 1.3)
        btn.MouseButton1Click:Connect(playClick)
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(35,35,35)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(18,18,18)}):Play()
        end)
        return btn
    end

    -- الأيقونات (كل وظيفة لحالها)
    local iMenu    = makeIconBtn("☰",  6,  "القائمة")
    local iSpeed   = makeIconBtn("⚡", 52, "السرعة")
    local iGlitch  = makeIconBtn("🏃", 98, "Speed Glitch")
    local iJump    = makeIconBtn("🦘",144, "القفز")
    local iSave    = makeIconBtn("📍",190, "المواقع")
    local iPlayers = makeIconBtn("👥",236, "اللاعبين")
    local iInfo    = makeIconBtn("📊",282, "المعلومات")
    local iDev     = makeIconBtn("👑",328, "المطور")
    local iHide    = makeIconBtn("👁",370, "إخفاء")

    -- زر إظهار
    local showBtn = Instance.new("TextButton")
    showBtn.Size=UDim2.new(0,40,0,40); showBtn.Position=UDim2.new(0,10,0,60)
    showBtn.BackgroundColor3=Color3.fromRGB(10,10,10); showBtn.Text="☰"
    showBtn.TextSize=18; showBtn.Font=Enum.Font.GothamBold
    showBtn.TextColor3=Color3.fromRGB(255,255,255); showBtn.BorderSizePixel=0
    showBtn.ZIndex=25; showBtn.Visible=false; showBtn.Parent=screenGui
    Instance.new("UICorner",showBtn).CornerRadius=UDim.new(0,10)
    addWhiteStroke(showBtn, 1.5)

    iHide.MouseButton1Click:Connect(function()
        TweenService:Create(iconBar,TweenInfo.new(0.2),{Size=UDim2.new(0,0,0,390),BackgroundTransparency=1}):Play()
        task.delay(0.2, function() iconBar.Visible=false; showBtn.Visible=true end)
    end)
    showBtn.MouseButton1Click:Connect(function()
        playClick(); iconBar.Visible=true; iconBar.Size=UDim2.new(0,0,0,390); showBtn.Visible=false
        TweenService:Create(iconBar,TweenInfo.new(0.25),{Size=UDim2.new(0,52,0,390),BackgroundTransparency=0}):Play()
    end)

    -- ==========================================
    -- إشعار Android
    -- ==========================================
    local notif = Instance.new("Frame")
    notif.Size=UDim2.new(0,270,0,62); notif.Position=UDim2.new(0.5,-135,1,10)
    notif.BackgroundColor3=Color3.fromRGB(10,10,10); notif.BorderSizePixel=0; notif.ZIndex=60; notif.Parent=screenGui
    Instance.new("UICorner",notif).CornerRadius=UDim.new(0,14)
    addWhiteStroke(notif, 1.8)
    local nIco=Instance.new("TextLabel"); nIco.Size=UDim2.new(0,38,0,38); nIco.Position=UDim2.new(0,10,0.5,-19)
    nIco.BackgroundTransparency=1; nIco.Text=isDeveloper and "👑" or "✅"; nIco.TextSize=22; nIco.Font=Enum.Font.GothamBold; nIco.ZIndex=61; nIco.Parent=notif
    local nT=Instance.new("TextLabel"); nT.Size=UDim2.new(1,-54,0,22); nT.Position=UDim2.new(0,52,0,8)
    nT.BackgroundTransparency=1; nT.Text="ScriptV4 LPMK  شغّال"; nT.TextColor3=Color3.fromRGB(255,255,255)
    nT.TextSize=13; nT.Font=Enum.Font.GothamBold; nT.TextXAlignment=Enum.TextXAlignment.Left; nT.ZIndex=61; nT.Parent=notif
    local nS=Instance.new("TextLabel"); nS.Size=UDim2.new(1,-54,0,16); nS.Position=UDim2.new(0,52,0,34)
    nS.BackgroundTransparency=1; nS.Text=(isDeveloper and "مرحباً مطور 👑 " or "مرحباً ")..player.Name
    nS.TextColor3=Color3.fromRGB(180,180,180); nS.TextSize=11; nS.Font=Enum.Font.Gotham
    nS.TextXAlignment=Enum.TextXAlignment.Left; nS.ZIndex=61; nS.Parent=notif
    TweenService:Create(notif,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Position=UDim2.new(0.5,-135,1,-72)}):Play()
    task.delay(3.5, function()
        TweenService:Create(notif,TweenInfo.new(0.3),{Position=UDim2.new(0.5,-135,1,10)}):Play()
        task.delay(0.35, function() notif:Destroy() end)
    end)

    -- ==========================================
    -- 1) نافذة القائمة (noclip)
    -- ==========================================
    local winMenu, scMenu = makeWindow(72,10,260,110,"  القائمة","⚙️")
    local stMenu = {false}
    local noclipBtn = makeBtn(scMenu, "👻  اختراق الجدران", 1)

    noclipBtn.MouseButton1Click:Connect(function()
        noclipActive = not noclipActive
        noclipBtn.Text = noclipActive and "🟢  اختراق (شغّال)" or "👻  اختراق الجدران"
    end)
    RunService.Stepped:Connect(function()
        if not noclipActive then return end
        local ch = player.Character; if not ch then return end
        for _,p in ipairs(ch:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then p.CanCollide=false end
        end
    end)

    iMenu.MouseButton1Click:Connect(function() toggleWin(winMenu,stMenu,110) end)

    -- ==========================================
    -- 2) نافذة السرعة
    -- ==========================================
    local winSpeed, scSpeed = makeWindow(72,10,260,160,"  السرعة","⚡")
    local stSpeed = {false}

    makeLbl(scSpeed,"⚡ السرعة المخصصة",1)
    local speedBox, speedBtn = makeInputRow(scSpeed,"66","▶ فعّل",2)

    local presetsRow = Instance.new("Frame")
    presetsRow.Size=UDim2.new(1,0,0,32); presetsRow.BackgroundTransparency=1; presetsRow.LayoutOrder=3; presetsRow.Parent=scSpeed
    local presets={16,100,500,9999}
    local presetColors={Color3.fromRGB(40,60,140),Color3.fromRGB(30,100,50),Color3.fromRGB(120,70,10),Color3.fromRGB(140,20,20)}
    for i,spd in ipairs(presets) do
        local pw=1/#presets
        local pb=Instance.new("TextButton")
        pb.Size=UDim2.new(pw,-4,1,0); pb.Position=UDim2.new((i-1)*pw,2,0,0)
        pb.BackgroundColor3=presetColors[i]; pb.Text=tostring(spd)
        pb.TextColor3=Color3.fromRGB(255,255,255); pb.TextSize=12
        pb.Font=Enum.Font.GothamBold; pb.BorderSizePixel=0; pb.Parent=presetsRow
        Instance.new("UICorner",pb).CornerRadius=UDim.new(0,7)
        pb.MouseButton1Click:Connect(function()
            playClick(); speedBox.Text=tostring(spd)
            local ch=player.Character; if not ch then return end
            local hum=ch:FindFirstChild("Humanoid"); if not hum then return end
            speedActive=true; currentSpeed=spd; hum.WalkSpeed=spd
            speedBtn.BackgroundColor3=Color3.fromRGB(140,30,30); speedBtn.Text="⏹ إيقاف"
        end)
    end

    speedBtn.MouseButton1Click:Connect(function()
        local ch=player.Character; if not ch then return end
        local hum=ch:FindFirstChild("Humanoid"); if not hum then return end
        if speedActive then
            speedActive=false; hum.WalkSpeed=16
            speedBtn.BackgroundColor3=Color3.fromRGB(22,22,22); speedBtn.Text="▶ فعّل"
        else
            local num=tonumber(speedBox.Text)
            if not num then speedBox.Text="رقم!"; task.delay(1,function() speedBox.Text=tostring(currentSpeed) end); return end
            num=math.clamp(num,1,99999); currentSpeed=num; speedActive=true; hum.WalkSpeed=num
            speedBtn.BackgroundColor3=Color3.fromRGB(140,30,30); speedBtn.Text="⏹ إيقاف"
        end
    end)

    iSpeed.MouseButton1Click:Connect(function() toggleWin(winSpeed,stSpeed,160) end)

    -- ==========================================
    -- 3) نافذة Speed Glitch
    -- ==========================================
    local winGlitch, scGlitch = makeWindow(72,10,260,130,"  Speed Glitch","🏃")
    local stGlitch = {false}

    local sliderContain = Instance.new("Frame")
    sliderContain.Size=UDim2.new(1,0,0,66); sliderContain.BackgroundTransparency=1; sliderContain.LayoutOrder=1; sliderContain.Parent=scGlitch

    local sgTopRow = Instance.new("Frame"); sgTopRow.Size=UDim2.new(1,0,0,24); sgTopRow.BackgroundTransparency=1; sgTopRow.Parent=sliderContain
    local sgLbl=Instance.new("TextLabel"); sgLbl.Size=UDim2.new(0,120,1,0); sgLbl.BackgroundTransparency=1
    sgLbl.Text="السرعة:"; sgLbl.TextColor3=Color3.fromRGB(180,180,180); sgLbl.TextSize=12; sgLbl.Font=Enum.Font.GothamBold
    sgLbl.TextXAlignment=Enum.TextXAlignment.Left; sgLbl.Parent=sgTopRow
    local sgVal=Instance.new("TextLabel"); sgVal.Size=UDim2.new(0,60,1,0); sgVal.Position=UDim2.new(1,-60,0,0)
    sgVal.BackgroundTransparency=1; sgVal.Text="16"; sgVal.TextColor3=Color3.fromRGB(255,255,255)
    sgVal.TextSize=13; sgVal.Font=Enum.Font.GothamBold; sgVal.TextXAlignment=Enum.TextXAlignment.Right; sgVal.Parent=sgTopRow

    local slBG=Instance.new("Frame"); slBG.Size=UDim2.new(1,0,0,18); slBG.Position=UDim2.new(0,0,0,26)
    slBG.BackgroundColor3=Color3.fromRGB(18,18,18); slBG.BorderSizePixel=0; slBG.Parent=sliderContain
    Instance.new("UICorner",slBG).CornerRadius=UDim.new(0,9)
    addWhiteStroke(slBG,1)
    local slFill=Instance.new("Frame"); slFill.Size=UDim2.new(0,0,1,0); slFill.BackgroundColor3=Color3.fromRGB(200,200,200)
    slFill.BorderSizePixel=0; slFill.Parent=slBG; Instance.new("UICorner",slFill).CornerRadius=UDim.new(0,9)
    local slThumb=Instance.new("Frame"); slThumb.Size=UDim2.new(0,20,0,20); slThumb.Position=UDim2.new(0,-10,0.5,-10)
    slThumb.BackgroundColor3=Color3.fromRGB(255,255,255); slThumb.BorderSizePixel=0; slThumb.ZIndex=5; slThumb.Parent=slBG
    Instance.new("UICorner",slThumb).CornerRadius=UDim.new(0,10)

    local glitchToggle = makeBtn(scGlitch,"▶ فعّل Speed Glitch",2)

    local slMin,slMax=1,99999; local slVal=16; local slSliding=false; local glitchActive=false

    local function updateSl(v)
        slVal=math.clamp(math.floor(v),slMin,slMax)
        local pct=(slVal-slMin)/(slMax-slMin)
        slFill.Size=UDim2.new(pct,0,1,0); slThumb.Position=UDim2.new(pct,-10,0.5,-10)
        sgVal.Text=tostring(slVal)
        local bv=math.floor(120+135*pct)
        slFill.BackgroundColor3=Color3.fromRGB(bv,bv,bv)
    end
    updateSl(16)

    slBG.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            slSliding=true
            local rel=math.clamp((inp.Position.X-slBG.AbsolutePosition.X)/slBG.AbsoluteSize.X,0,1)
            updateSl(slMin+rel*(slMax-slMin))
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if slSliding and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
            local rel=math.clamp((inp.Position.X-slBG.AbsolutePosition.X)/slBG.AbsoluteSize.X,0,1)
            updateSl(slMin+rel*(slMax-slMin))
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then slSliding=false end
    end)

    glitchToggle.MouseButton1Click:Connect(function()
        glitchActive=not glitchActive
        if glitchActive then
            glitchToggle.Text="⏹ إيقاف Speed Glitch"
            task.spawn(function()
                while glitchActive do
                    local ch=player.Character; if not ch then task.wait(0.1); continue end
                    local hum=ch:FindFirstChild("Humanoid"); if not hum then task.wait(0.1); continue end
                    hum.WalkSpeed=slVal; task.wait(0.03)
                    hum.WalkSpeed=slVal+5; task.wait(0.03)
                end
                local ch=player.Character
                if ch then local hum=ch:FindFirstChild("Humanoid"); if hum then hum.WalkSpeed=16 end end
            end)
        else
            glitchToggle.Text="▶ فعّل Speed Glitch"
        end
    end)

    iGlitch.MouseButton1Click:Connect(function() toggleWin(winGlitch,stGlitch,130) end)

    -- ==========================================
    -- 4) نافذة القفز
    -- ==========================================
    local winJump, scJump = makeWindow(72,10,260,160,"  القفز","🦘")
    local stJump = {false}

    makeLbl(scJump,"🦘 ارتفاع القفز",1)
    local jumpBox, jumpApplyBtn = makeInputRow(scJump,"50","▶ فعّل",2)
    local infiniteBtn = makeBtn(scJump,"♾️  قفز لا نهائي",3)

    jumpApplyBtn.MouseButton1Click:Connect(function()
        local ch=player.Character; if not ch then return end
        local hum=ch:FindFirstChild("Humanoid"); if not hum then return end
        if jumpActive then
            jumpActive=false; hum.JumpPower=50
            jumpApplyBtn.BackgroundColor3=Color3.fromRGB(22,22,22); jumpApplyBtn.Text="▶ فعّل"
        else
            local num=tonumber(jumpBox.Text)
            if not num then jumpBox.Text="رقم!"; task.delay(1,function() jumpBox.Text="50" end); return end
            num=math.clamp(num,1,999999); jumpActive=true; hum.JumpPower=num
            jumpApplyBtn.BackgroundColor3=Color3.fromRGB(100,30,140); jumpApplyBtn.Text="⏹ إيقاف"
        end
    end)

    infiniteBtn.MouseButton1Click:Connect(function()
        infiniteJumpActive=not infiniteJumpActive
        infiniteBtn.Text=infiniteJumpActive and "🟢  قفز لا نهائي (شغّال)" or "♾️  قفز لا نهائي"
    end)

    UserInputService.JumpRequest:Connect(function()
        if not infiniteJumpActive then return end
        local ch=player.Character; if not ch then return end
        local hum=ch:FindFirstChild("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)

    iJump.MouseButton1Click:Connect(function() toggleWin(winJump,stJump,160) end)

    -- ==========================================
    -- 5) نافذة المواقع
    -- ==========================================
    local winSave, scSave = makeWindow(72,10,260,220,"  المواقع المحفوظة","📍")
    local stSave = {false}

    local saveBtn = makeBtn(scSave,"💾  احفظ موقعي الحالي",1)

    local locScroll = Instance.new("ScrollingFrame")
    locScroll.Size=UDim2.new(1,0,0,130); locScroll.BackgroundColor3=Color3.fromRGB(6,6,6)
    locScroll.BorderSizePixel=0; locScroll.ScrollBarThickness=4
    locScroll.ScrollBarImageColor3=Color3.fromRGB(180,180,180)
    locScroll.CanvasSize=UDim2.new(0,0,0,0); locScroll.LayoutOrder=2; locScroll.Parent=scSave
    Instance.new("UICorner",locScroll).CornerRadius=UDim.new(0,8)
    addWhiteStroke(locScroll,1)
    local locList=Instance.new("UIListLayout"); locList.SortOrder=Enum.SortOrder.LayoutOrder; locList.Padding=UDim.new(0,4); locList.Parent=locScroll
    local locPad=Instance.new("UIPadding"); locPad.PaddingTop=UDim.new(0,4); locPad.PaddingLeft=UDim.new(0,4); locPad.PaddingRight=UDim.new(0,4); locPad.Parent=locScroll

    local function refreshList()
        for _,c in ipairs(locScroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
        for i,data in ipairs(savedPositions) do
            local row=Instance.new("Frame")
            row.Size=UDim2.new(1,0,0,34); row.BackgroundColor3=Color3.fromRGB(16,16,16)
            row.BorderSizePixel=0; row.LayoutOrder=i; row.Parent=locScroll
            Instance.new("UICorner",row).CornerRadius=UDim.new(0,7)
            local nm=Instance.new("TextLabel")
            nm.Size=UDim2.new(1,-80,1,0); nm.Position=UDim2.new(0,8,0,0)
            nm.BackgroundTransparency=1; nm.Text=data.name
            nm.TextColor3=Color3.fromRGB(220,220,220); nm.TextSize=12
            nm.Font=Enum.Font.Gotham; nm.TextXAlignment=Enum.TextXAlignment.Left
            nm.TextTruncate=Enum.TextTruncate.AtEnd; nm.Parent=row
            local tpB=Instance.new("TextButton")
            tpB.Size=UDim2.new(0,32,0,26); tpB.Position=UDim2.new(1,-74,0.5,-13)
            tpB.BackgroundColor3=Color3.fromRGB(25,90,50); tpB.Text="🚀"; tpB.TextSize=14
            tpB.BorderSizePixel=0; tpB.Font=Enum.Font.GothamBold; tpB.Parent=row
            Instance.new("UICorner",tpB).CornerRadius=UDim.new(0,6)
            local dlB=Instance.new("TextButton")
            dlB.Size=UDim2.new(0,32,0,26); dlB.Position=UDim2.new(1,-38,0.5,-13)
            dlB.BackgroundColor3=Color3.fromRGB(130,20,20); dlB.Text="🗑"; dlB.TextSize=14
            dlB.BorderSizePixel=0; dlB.Font=Enum.Font.GothamBold; dlB.Parent=row
            Instance.new("UICorner",dlB).CornerRadius=UDim.new(0,6)
            tpB.MouseButton1Click:Connect(function()
                playClick()
                local ch=player.Character; if not ch then return end
                local hrp=ch:FindFirstChild("HumanoidRootPart"); if hrp then hrp.CFrame=data.cframe end
            end)
            dlB.MouseButton1Click:Connect(function()
                playClick(); table.remove(savedPositions,i); refreshList()
            end)
        end
        locScroll.CanvasSize=UDim2.new(0,0,0,#savedPositions*38+8)
    end

    saveBtn.MouseButton1Click:Connect(function()
        local ch=player.Character; if not ch then return end
        local hrp=ch:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        saveCount=saveCount+1
        table.insert(savedPositions,{name="📍 موقع "..saveCount, cframe=hrp.CFrame})
        refreshList(); saveBtn.Text="✅  تم الحفظ!"
        task.delay(1.5,function() saveBtn.Text="💾  احفظ موقعي الحالي" end)
    end)

    iSave.MouseButton1Click:Connect(function() toggleWin(winSave,stSave,220) end)
    refreshList()

    -- ==========================================
    -- 6) نافذة اللاعبين
    -- ==========================================
    local winPlayers, scPlayers = makeWindow(72,10,280,330,"  اللاعبين","👥")
    local stPlayers = {false}

    -- بحث مع اقتراحات
    local searchBox=Instance.new("TextBox")
    searchBox.Size=UDim2.new(1,0,0,34); searchBox.BackgroundColor3=Color3.fromRGB(16,16,16)
    searchBox.Text=""; searchBox.PlaceholderText="🔍 ابحث..."; searchBox.PlaceholderColor3=Color3.fromRGB(90,90,90)
    searchBox.TextColor3=Color3.fromRGB(255,255,255); searchBox.TextSize=13; searchBox.Font=Enum.Font.Gotham
    searchBox.BorderSizePixel=0; searchBox.ClearTextOnFocus=false; searchBox.LayoutOrder=1; searchBox.Parent=scPlayers
    Instance.new("UICorner",searchBox).CornerRadius=UDim.new(0,8)
    addWhiteStroke(searchBox,1.3)

    -- اقتراحات
    local suggestScroll=Instance.new("ScrollingFrame")
    suggestScroll.Size=UDim2.new(1,0,0,0); suggestScroll.BackgroundColor3=Color3.fromRGB(14,14,14)
    suggestScroll.BorderSizePixel=0; suggestScroll.ScrollBarThickness=0
    suggestScroll.CanvasSize=UDim2.new(0,0,0,0); suggestScroll.LayoutOrder=2; suggestScroll.ClipsDescendants=true; suggestScroll.Parent=scPlayers
    Instance.new("UICorner",suggestScroll).CornerRadius=UDim.new(0,8)
    addWhiteStroke(suggestScroll,1)
    local sugList=Instance.new("UIListLayout"); sugList.SortOrder=Enum.SortOrder.LayoutOrder; sugList.Parent=suggestScroll

    local function updateSug(q)
        for _,c in ipairs(suggestScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        if q=="" then suggestScroll.Size=UDim2.new(1,0,0,0); return end
        local matches={}
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=player then
                local ql=q:lower()
                if p.Name:lower():sub(1,#ql)==ql or p.DisplayName:lower():sub(1,#ql)==ql then
                    table.insert(matches,p)
                end
            end
        end
        for i,p in ipairs(matches) do
            local sb=Instance.new("TextButton")
            sb.Size=UDim2.new(1,0,0,28); sb.BackgroundColor3=Color3.fromRGB(20,20,20)
            sb.Text="  "..p.DisplayName.." (@"..p.Name..")"; sb.TextColor3=Color3.fromRGB(220,220,220)
            sb.TextSize=12; sb.Font=Enum.Font.Gotham; sb.TextXAlignment=Enum.TextXAlignment.Left
            sb.BorderSizePixel=0; sb.LayoutOrder=i; sb.Parent=suggestScroll
            sb.MouseButton1Click:Connect(function()
                playClick(); searchBox.Text=p.Name
                suggestScroll.Size=UDim2.new(1,0,0,0)
                for _,c in ipairs(suggestScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
            end)
        end
        local h=math.min(#matches*28,112)
        suggestScroll.Size=UDim2.new(1,0,0,h)
        suggestScroll.CanvasSize=UDim2.new(0,0,0,#matches*28)
    end

    searchBox:GetPropertyChangedSignal("Text"):Connect(function() updateSug(searchBox.Text) end)

    local pList=Instance.new("ScrollingFrame")
    pList.Size=UDim2.new(1,0,0,90); pList.BackgroundColor3=Color3.fromRGB(6,6,6)
    pList.BorderSizePixel=0; pList.ScrollBarThickness=4; pList.ScrollBarImageColor3=Color3.fromRGB(180,180,180)
    pList.CanvasSize=UDim2.new(0,0,0,0); pList.LayoutOrder=3; pList.Parent=scPlayers
    Instance.new("UICorner",pList).CornerRadius=UDim.new(0,8)
    addWhiteStroke(pList,1)
    local pLL=Instance.new("UIListLayout"); pLL.SortOrder=Enum.SortOrder.LayoutOrder; pLL.Padding=UDim.new(0,3); pLL.Parent=pList
    local pLP=Instance.new("UIPadding"); pLP.PaddingTop=UDim.new(0,4); pLP.PaddingLeft=UDim.new(0,4); pLP.PaddingRight=UDim.new(0,4); pLP.Parent=pList

    local pCard=Instance.new("Frame")
    pCard.Size=UDim2.new(1,0,0,0); pCard.BackgroundColor3=Color3.fromRGB(12,12,12)
    pCard.BorderSizePixel=0; pCard.ClipsDescendants=true; pCard.LayoutOrder=4; pCard.Parent=scPlayers
    Instance.new("UICorner",pCard).CornerRadius=UDim.new(0,10)
    addWhiteStroke(pCard,1.2)

    local pAv=Instance.new("ImageLabel")
    pAv.Size=UDim2.new(0,52,0,52); pAv.Position=UDim2.new(0,8,0,8)
    pAv.BackgroundColor3=Color3.fromRGB(18,18,18); pAv.BorderSizePixel=0; pAv.Image=""; pAv.Parent=pCard
    Instance.new("UICorner",pAv).CornerRadius=UDim.new(0,8)
    addWhiteStroke(pAv,1)

    local pNm=Instance.new("TextLabel"); pNm.Size=UDim2.new(1,-70,0,16); pNm.Position=UDim2.new(0,68,0,8)
    pNm.BackgroundTransparency=1; pNm.Text="الاسم: —"; pNm.TextColor3=Color3.fromRGB(240,240,240)
    pNm.TextSize=12; pNm.Font=Enum.Font.GothamBold; pNm.TextXAlignment=Enum.TextXAlignment.Left
    pNm.TextTruncate=Enum.TextTruncate.AtEnd; pNm.Parent=pCard

    local pUs=Instance.new("TextLabel"); pUs.Size=UDim2.new(1,-70,0,14); pUs.Position=UDim2.new(0,68,0,26)
    pUs.BackgroundTransparency=1; pUs.Text="@—"; pUs.TextColor3=Color3.fromRGB(170,170,170)
    pUs.TextSize=11; pUs.Font=Enum.Font.Gotham; pUs.TextXAlignment=Enum.TextXAlignment.Left
    pUs.TextTruncate=Enum.TextTruncate.AtEnd; pUs.Parent=pCard

    local pId=Instance.new("TextLabel"); pId.Size=UDim2.new(1,-70,0,14); pId.Position=UDim2.new(0,68,0,42)
    pId.BackgroundTransparency=1; pId.Text="ID: —"; pId.TextColor3=Color3.fromRGB(130,130,130)
    pId.TextSize=11; pId.Font=Enum.Font.Gotham; pId.TextXAlignment=Enum.TextXAlignment.Left; pId.Parent=pCard

    local function makeCBtn(text,xPos,yPos,w)
        local b=Instance.new("TextButton")
        b.Size=UDim2.new(0,w,0,26); b.Position=UDim2.new(0,xPos,0,yPos)
        b.BackgroundColor3=Color3.fromRGB(22,22,22); b.Text=text
        b.TextColor3=Color3.fromRGB(255,255,255); b.TextSize=10
        b.Font=Enum.Font.GothamBold; b.BorderSizePixel=0; b.Parent=pCard
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,7)
        addWhiteStroke(b,1)
        b.MouseButton1Click:Connect(playClick)
        return b
    end

    local tpToBtn    = makeCBtn("🚀 انتقل",    8, 68, 76)
    local cpPosBtn   = makeCBtn("📋 موقع",     90, 68, 70)
    local cpNameBtn  = makeCBtn("📝 اسم",     166, 68, 62)
    local spectateBtn= makeCBtn("👁 مراقبة",    8,100, 76)
    local cpUserBtn  = makeCBtn("📋 يوزر",     90,100, 70)
    local cpIdBtn    = makeCBtn("🔢 ID",       166,100, 62)

    local function stopSpectate()
        spectateActive=false
        if spectateConnection then spectateConnection:Disconnect(); spectateConnection=nil end
        workspace.CurrentCamera.CameraType=Enum.CameraType.Custom
        local ch=player.Character
        if ch then local hum=ch:FindFirstChild("Humanoid"); if hum then workspace.CurrentCamera.CameraSubject=hum end end
        spectateBtn.Text="👁 مراقبة"
    end

    local function startSpectate(tgt)
        if spectateActive then stopSpectate() end
        spectateActive=true; spectateBtn.Text="🔴 إيقاف"
        spectateConnection=RunService.RenderStepped:Connect(function()
            if not spectateActive then return end
            local tCh=tgt.Character; if not tCh then return end
            local tHum=tCh:FindFirstChild("Humanoid"); if not tHum then return end
            workspace.CurrentCamera.CameraType=Enum.CameraType.Custom
            workspace.CurrentCamera.CameraSubject=tHum
        end)
    end

    spectateBtn.MouseButton1Click:Connect(function()
        if not selectedPlayer then return end
        if spectateActive then stopSpectate() else startSpectate(selectedPlayer) end
    end)

    tpToBtn.MouseButton1Click:Connect(function()
        if not selectedPlayer then return end
        local ch=player.Character; local tCh=selectedPlayer.Character
        if not ch or not tCh then return end
        local hrp=ch:FindFirstChild("HumanoidRootPart"); local tHrp=tCh:FindFirstChild("HumanoidRootPart")
        if hrp and tHrp then hrp.CFrame=tHrp.CFrame*CFrame.new(3,0,0) end
    end)

    cpPosBtn.MouseButton1Click:Connect(function()
        if not selectedPlayer then return end
        local tCh=selectedPlayer.Character; if not tCh then return end
        local tHrp=tCh:FindFirstChild("HumanoidRootPart"); if not tHrp then return end
        saveCount=saveCount+1
        table.insert(savedPositions,{name="📍 "..selectedPlayer.Name,cframe=tHrp.CFrame})
        refreshList(); cpPosBtn.Text="✅ تم"
        task.delay(1.5,function() cpPosBtn.Text="📋 موقع" end)
    end)

    cpNameBtn.MouseButton1Click:Connect(function()
        if not selectedPlayer then return end
        copyToClipboard(selectedPlayer.DisplayName); cpNameBtn.Text="✅"
        task.delay(1.5,function() cpNameBtn.Text="📝 اسم" end)
    end)
    cpUserBtn.MouseButton1Click:Connect(function()
        if not selectedPlayer then return end
        copyToClipboard(selectedPlayer.Name); cpUserBtn.Text="✅"
        task.delay(1.5,function() cpUserBtn.Text="📋 يوزر" end)
    end)
    cpIdBtn.MouseButton1Click:Connect(function()
        if not selectedPlayer then return end
        local id=tostring(selectedPlayer.UserId)
        copyToClipboard(id); cpIdBtn.Text="✅"
        task.delay(1.5,function() cpIdBtn.Text="🔢 ID" end)
    end)

    local function updatePList(q)
        for _,c in ipairs(pList:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        local count=0
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=player then
                local ql=(q or ""):lower()
                if ql=="" or p.Name:lower():find(ql,1,true) or p.DisplayName:lower():find(ql,1,true) then
                    count=count+1
                    local btn=Instance.new("TextButton")
                    btn.Size=UDim2.new(1,0,0,26)
                    btn.BackgroundColor3=(selectedPlayer==p) and Color3.fromRGB(50,50,50) or Color3.fromRGB(18,18,18)
                    btn.Text="  "..p.DisplayName.."  (@"..p.Name..")"
                    btn.TextColor3=Color3.fromRGB(220,220,220); btn.TextSize=11
                    btn.Font=Enum.Font.Gotham; btn.TextXAlignment=Enum.TextXAlignment.Left
                    btn.BorderSizePixel=0; btn.LayoutOrder=count; btn.Parent=pList
                    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)
                    btn.MouseButton1Click:Connect(function()
                        playClick(); selectedPlayer=p
                        pNm.Text="الاسم: "..p.DisplayName; pUs.Text="@"..p.Name; pId.Text="ID: "..tostring(p.UserId)
                        task.spawn(function()
                            local ok,th=pcall(function() return Players:GetUserThumbnailAsync(p.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100) end)
                            pAv.Image=ok and th or ""
                        end)
                        TweenService:Create(pCard,TweenInfo.new(0.25),{Size=UDim2.new(1,0,0,134)}):Play()
                        updatePList(searchBox.Text)
                        if spectateActive then startSpectate(p) end
                    end)
                end
            end
        end
        pList.CanvasSize=UDim2.new(0,0,0,count*29+8)
    end

    searchBox:GetPropertyChangedSignal("Text"):Connect(function() updatePList(searchBox.Text) end)
    Players.PlayerRemoving:Connect(function(p)
        if selectedPlayer==p then
            selectedPlayer=nil; stopSpectate()
            TweenService:Create(pCard,TweenInfo.new(0.2),{Size=UDim2.new(1,0,0,0)}):Play()
        end
        updatePList(searchBox.Text)
    end)
    Players.PlayerAdded:Connect(function() updatePList(searchBox.Text) end)
    updatePList("")

    iPlayers.MouseButton1Click:Connect(function()
        if not stPlayers[1] then updatePList("") end
        toggleWin(winPlayers,stPlayers,330)
    end)

    -- ==========================================
    -- 7) نافذة المعلومات - معلومات من يشغل السكربت (تلقائي)
    -- ==========================================
    local winInfo, scInfo = makeWindow(72,10,280,300,"  معلومات المستخدم","📊")
    local stInfo = {false}

    local function makeInfoRow(parent, lbl, order)
        local f=Instance.new("Frame")
        f.Size=UDim2.new(1,0,0,28); f.BackgroundColor3=Color3.fromRGB(14,14,14)
        f.BorderSizePixel=0; f.LayoutOrder=order; f.Parent=parent
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,7)
        local l=Instance.new("TextLabel")
        l.Size=UDim2.new(1,-8,1,0); l.Position=UDim2.new(0,8,0,0)
        l.BackgroundTransparency=1; l.Text=lbl
        l.TextColor3=Color3.fromRGB(220,220,220); l.TextSize=12
        l.Font=Enum.Font.Gotham; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=f
        return l
    end

    -- صورة المستخدم نفسه
    local myAvBg=Instance.new("Frame"); myAvBg.Size=UDim2.new(1,0,0,80); myAvBg.BackgroundTransparency=1; myAvBg.LayoutOrder=1; myAvBg.Parent=scInfo
    local myAv=Instance.new("ImageLabel")
    myAv.Size=UDim2.new(0,64,0,64); myAv.Position=UDim2.new(0.5,-32,0,6)
    myAv.BackgroundColor3=Color3.fromRGB(16,16,16); myAv.BorderSizePixel=0; myAv.Image=""; myAv.Parent=myAvBg
    Instance.new("UICorner",myAv).CornerRadius=UDim.new(0,10)
    addWhiteStroke(myAv,1.8)
    task.spawn(function()
        local ok,th=pcall(function() return Players:GetUserThumbnailAsync(player.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100) end)
        if ok then myAv.Image=th end
    end)

    local iMyName  = makeInfoRow(scInfo,"👤 الاسم: "..player.DisplayName, 2)
    local iMyUser  = makeInfoRow(scInfo,"🔖 اليوزر: @"..player.Name, 3)
    local iMyID    = makeInfoRow(scInfo,"🆔 ID: "..tostring(player.UserId), 4)
    local iMyPing  = makeInfoRow(scInfo,"📶 البنق: جاري...", 5)
    local iMyFPS   = makeInfoRow(scInfo,"🎮 الفريمات: جاري...", 6)
    local iMyExec  = makeInfoRow(scInfo,"⚔️ الهكر: جاري...", 7)
    local iMyMap   = makeInfoRow(scInfo,"🗺️ الماب: جاري...", 8)
    local iMyDev   = makeInfoRow(scInfo, isDeveloper and "👑 الرتبة: مطور" or "👤 الرتبة: مستخدم", 9)

    -- نسخ
    local cpMyRow=Instance.new("Frame"); cpMyRow.Size=UDim2.new(1,0,0,30); cpMyRow.BackgroundTransparency=1; cpMyRow.LayoutOrder=10; cpMyRow.Parent=scInfo
    local cpMyName=Instance.new("TextButton"); cpMyName.Size=UDim2.new(0.48,0,1,0); cpMyName.BackgroundColor3=Color3.fromRGB(22,22,22)
    cpMyName.Text="📋 نسخ اسم"; cpMyName.TextColor3=Color3.fromRGB(255,255,255); cpMyName.TextSize=11; cpMyName.Font=Enum.Font.GothamBold; cpMyName.BorderSizePixel=0; cpMyName.Parent=cpMyRow
    Instance.new("UICorner",cpMyName).CornerRadius=UDim.new(0,7)
    local cpMyUser=Instance.new("TextButton"); cpMyUser.Size=UDim2.new(0.48,0,1,0); cpMyUser.Position=UDim2.new(0.52,0,0,0)
    cpMyUser.BackgroundColor3=Color3.fromRGB(22,22,22); cpMyUser.Text="📋 نسخ يوزر"; cpMyUser.TextColor3=Color3.fromRGB(255,255,255); cpMyUser.TextSize=11; cpMyUser.Font=Enum.Font.GothamBold; cpMyUser.BorderSizePixel=0; cpMyUser.Parent=cpMyRow
    Instance.new("UICorner",cpMyUser).CornerRadius=UDim.new(0,7)
    addWhiteStroke(cpMyName,1); addWhiteStroke(cpMyUser,1)
    cpMyName.MouseButton1Click:Connect(function() copyToClipboard(player.DisplayName); cpMyName.Text="✅"; task.delay(1.5,function() cpMyName.Text="📋 نسخ اسم" end) end)
    cpMyUser.MouseButton1Click:Connect(function() copyToClipboard(player.Name); cpMyUser.Text="✅"; task.delay(1.5,function() cpMyUser.Text="📋 نسخ يوزر" end) end)

    local mapNameStr = "—"

    -- تحديث تلقائي كل 2 ثانية
    task.spawn(function()
        while true do
            task.wait(2)
            if not winInfo or not winInfo.Parent then break end

            -- FPS
            local fpsVal = math.floor(1/RunService.Heartbeat:Wait())
            iMyFPS.Text = "🎮 الفريمات: "..tostring(fpsVal).." FPS"

            -- Ping
            pcall(function()
                local ping = player:GetNetworkPing and math.floor(player:GetNetworkPing()*1000) or "—"
                iMyPing.Text = "📶 البنق: "..tostring(ping).." ms"
            end)

            -- Executor
            pcall(function()
                local en = "غير محدد"
                if identifyexecutor then en=identifyexecutor()
                elseif getexecutorname then en=getexecutorname()
                elseif syn then en="Synapse"
                elseif KRNL_LOADED then en="Krnl"
                elseif pebc then en="Fluxus" end
                iMyExec.Text = "⚔️ الهكر: "..en
            end)

            -- Map
            pcall(function()
                mapNameStr = MarketplaceService:GetProductInfo(game.PlaceId).Name or "—"
                iMyMap.Text = "🗺️ الماب: "..mapNameStr
            end)
        end
    end)

    iInfo.MouseButton1Click:Connect(function() toggleWin(winInfo,stInfo,300) end)

    -- ==========================================
    -- 8) نافذة المطور
    -- ==========================================
    local winDev, scDev = makeWindow(72,10,260,220,"  معلومات المطور","👑")
    local stDev = {false}

    -- صورة المطور
    local devAvBg=Instance.new("Frame"); devAvBg.Size=UDim2.new(1,0,0,90); devAvBg.BackgroundTransparency=1; devAvBg.LayoutOrder=1; devAvBg.Parent=scDev
    local devAv=Instance.new("ImageLabel")
    devAv.Size=UDim2.new(0,72,0,72); devAv.Position=UDim2.new(0.5,-36,0,8)
    devAv.BackgroundColor3=Color3.fromRGB(16,16,16); devAv.BorderSizePixel=0; devAv.Image=""; devAv.Parent=devAvBg
    Instance.new("UICorner",devAv).CornerRadius=UDim.new(0,12)
    local devAvStroke=Instance.new("UIStroke"); devAvStroke.Color=Color3.fromRGB(255,255,255); devAvStroke.Thickness=2.5; devAvStroke.Parent=devAv
    RunService.Heartbeat:Connect(function() devAvStroke.Color=bwColorFast() end)

    local function makeDRow(parent, text, order)
        local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,28); f.BackgroundColor3=Color3.fromRGB(14,14,14)
        f.BorderSizePixel=0; f.LayoutOrder=order; f.Parent=parent
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,7)
        local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,-8,1,0); l.Position=UDim2.new(0,8,0,0)
        l.BackgroundTransparency=1; l.Text=text; l.TextColor3=Color3.fromRGB(220,220,220)
        l.TextSize=12; l.Font=Enum.Font.Gotham; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=f
        return l
    end

    makeDRow(scDev,"👑 الاسم: LPMK",2)
    makeDRow(scDev,"🔖 اليوزر: @maxra2w",3)
    makeDRow(scDev,"📦 الإصدار: ScriptV4 LPMK",4)
    makeDRow(scDev,"🛠️ لغة: Lua (Roblox)",5)
    makeDRow(scDev,"⭐ الحالة: مطوّر رئيسي",6)

    task.spawn(function()
        local ok,uid=pcall(function() return Players:GetUserIdFromNameAsync("maxra2w") end)
        if ok and uid then
            local ok2,th=pcall(function() return Players:GetUserThumbnailAsync(uid,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100) end)
            if ok2 then devAv.Image=th end
        end
    end)

    iDev.MouseButton1Click:Connect(function() toggleWin(winDev,stDev,220) end)

    -- ==========================================
    -- صورة المطور على شريط الأيقونات
    -- ==========================================
    if isDeveloper then
        local myBadge=Instance.new("ImageLabel")
        myBadge.Size=UDim2.new(0,34,0,34); myBadge.Position=UDim2.new(0.5,-17,0,374)
        myBadge.BackgroundColor3=Color3.fromRGB(16,16,16); myBadge.BorderSizePixel=0; myBadge.Image=""; myBadge.ZIndex=22; myBadge.Parent=iconBar
        Instance.new("UICorner",myBadge).CornerRadius=UDim.new(0,8)
        addWhiteStroke(myBadge,1.5)
        iconBar.Size=UDim2.new(0,52,0,418)
        task.spawn(function()
            local ok,th=pcall(function() return Players:GetUserThumbnailAsync(player.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100) end)
            if ok then myBadge.Image=th end
        end)
    end

    -- شخصية تتجدد
    player.CharacterAdded:Connect(function(char)
        character=char
        speedActive=false; noclipActive=false; jumpActive=false; infiniteJumpActive=false; glitchActive=false
        stopSpectate()
        speedBtn.BackgroundColor3=Color3.fromRGB(22,22,22); speedBtn.Text="▶ فعّل"
        jumpApplyBtn.BackgroundColor3=Color3.fromRGB(22,22,22); jumpApplyBtn.Text="▶ فعّل"
        infiniteBtn.Text="♾️  قفز لا نهائي"
        glitchToggle.Text="▶ فعّل Speed Glitch"
        noclipBtn.Text="👻  اختراق الجدران"
    end)

end -- buildMainGUI

-- =========================================
-- منطق المفتاح
-- =========================================
if isDeveloper then
    task.wait(0.1)
    if keyScreen and keyScreen.Parent then keyScreen:Destroy() end
    buildMainGUI()
else
    keyBtn.MouseButton1Click:Connect(function()
        if keyBox.Text == ACCESS_CODE then
            successSound:Play()
            keyStatus.TextColor3=Color3.fromRGB(100,255,100); keyStatus.Text="✅ مفتاح صحيح!"
            TweenService:Create(keyFrame,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.In),
                {Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)}):Play()
            task.delay(0.45, function() buildMainGUI() end)
        else
            errorSound:Play()
            keyStatus.TextColor3=Color3.fromRGB(255,80,80); keyStatus.Text="❌ مفتاح خاطئ!"
            -- اهتزاز
            local origPos = keyFrame.Position
            for i=1,3 do
                task.wait(0.05)
                keyFrame.Position=UDim2.new(0.5,-168,0.5,-105)
                task.wait(0.05)
                keyFrame.Position=UDim2.new(0.5,-152,0.5,-105)
            end
            keyFrame.Position=origPos
            task.delay(2,function() keyStatus.Text="" end)
        end
    end)
end
