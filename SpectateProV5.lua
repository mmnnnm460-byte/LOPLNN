-- ╔══════════════════════════════════════════════════════╗
-- ║        Spectate Camera PRO — V5 ULTRA               ║
-- ║        Code: 12717375127                            ║
-- ╚══════════════════════════════════════════════════════╝

local P            = game:GetService("Players")
local R            = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local UIS          = game:GetService("UserInputService")

local lp  = P.LocalPlayer
local cam = workspace.CurrentCamera

-- ══════════════════════════════════════
-- 🛡️ منع التكرار
-- ══════════════════════════════════════
local pg  = lp:WaitForChild("PlayerGui")
for _, old in ipairs({"SpectatePRO_V3","SpectatePRO_V4","SpectatePRO_V5"}) do
    local f = pg:FindFirstChild(old)
    if f then f:Destroy() end
end

-- ══════════════════════════════════════
-- متغيرات
-- ══════════════════════════════════════
local idx           = 0
local guiVisible    = true
local isVerified    = false
local spectating    = false
local REQUIRED_CODE = "12717375127"
local scriptHidden  = false
local liveStartTime = 0
local currentTarget = nil

-- ألوان
local C_BLUE1  = Color3.fromRGB(60,  160, 255)
local C_BLUE2  = Color3.fromRGB(30,  100, 220)
local C_WHITE  = Color3.fromRGB(255, 255, 255)
local C_DARK   = Color3.fromRGB(5,   15,  40)
local C_CYAN   = Color3.fromRGB(100, 220, 255)
local C_GREEN  = Color3.fromRGB(60,  220, 120)

-- ══════════════════════════════════════
-- 🔊 صوت النقر
-- ══════════════════════════════════════
local clickSound              = Instance.new("Sound")
clickSound.SoundId            = "rbxassetid://6895079853"
clickSound.Volume             = 0.5
clickSound.RollOffMaxDistance = 0
clickSound.Parent             = SoundService

-- ══════════════════════════════════════
-- دوال مساعدة
-- ══════════════════════════════════════
local function getPlayers()
    local list = {}
    for _, p in ipairs(P:GetPlayers()) do
        if p ~= lp then table.insert(list, p) end
    end
    return list
end

local function stopSpectate()
    spectating     = false
    idx            = 0
    currentTarget  = nil
    cam.CameraType = Enum.CameraType.Custom
    if lp.Character then
        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then cam.CameraSubject = hum end
    end
end

-- ══════════════════════════════════════
-- GUI الرئيسي
-- ══════════════════════════════════════
local gui          = Instance.new("ScreenGui")
gui.Name           = "SpectatePRO_V5"
gui.ResetOnSpawn   = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent         = pg

-- ════════════════════════════════════════════════════════════════════
-- 🔐 شاشة الكود — تصميم جديد كلياً مع زر X للإغلاق
-- ════════════════════════════════════════════════════════════════════
local codeOverlay                  = Instance.new("Frame")
codeOverlay.Size                   = UDim2.fromScale(1, 1)
codeOverlay.BackgroundColor3       = Color3.fromRGB(0, 4, 18)
codeOverlay.BackgroundTransparency = 0.08
codeOverlay.BorderSizePixel        = 0
codeOverlay.ZIndex                 = 50
codeOverlay.Parent                 = gui

-- نجوم متحركة في الخلفية
for i = 1, 40 do
    local star                  = Instance.new("Frame", codeOverlay)
    local sz                    = math.random(1, 3)
    star.Size                   = UDim2.fromOffset(sz, sz)
    star.Position               = UDim2.fromScale(math.random(), math.random())
    star.BackgroundColor3       = (i % 3 == 0) and C_WHITE or C_CYAN
    star.BackgroundTransparency = math.random(40, 85) / 100
    star.BorderSizePixel        = 0
    star.ZIndex                 = 51
    Instance.new("UICorner", star).CornerRadius = UDim.new(1, 0)
    task.spawn(function()
        while star.Parent do
            TweenService:Create(star,
                TweenInfo.new(math.random(12, 32) / 10, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {BackgroundTransparency = math.random(15, 80) / 100}):Play()
            task.wait(math.random(12, 32) / 10)
        end
    end)
end

-- إضاءة ضبابية خلف الإطار
local codeGlow                  = Instance.new("Frame")
codeGlow.Size                   = UDim2.fromOffset(420, 320)
codeGlow.AnchorPoint            = Vector2.new(0.5, 0.5)
codeGlow.Position               = UDim2.fromScale(0.5, 0.5)
codeGlow.BackgroundColor3       = Color3.fromRGB(30, 80, 200)
codeGlow.BackgroundTransparency = 0.88
codeGlow.BorderSizePixel        = 0
codeGlow.ZIndex                 = 51
codeGlow.Parent                 = codeOverlay
Instance.new("UICorner", codeGlow).CornerRadius = UDim.new(0, 30)

-- الإطار الرئيسي — أكبر وأجمل
local codeFrame                  = Instance.new("Frame")
codeFrame.Size                   = UDim2.fromOffset(400, 310)
codeFrame.AnchorPoint            = Vector2.new(0.5, 0.5)
codeFrame.Position               = UDim2.fromScale(0.5, 0.5)
codeFrame.BackgroundColor3       = Color3.fromRGB(4, 11, 34)
codeFrame.BorderSizePixel        = 0
codeFrame.ZIndex                 = 52
codeFrame.Parent                 = codeOverlay
Instance.new("UICorner", codeFrame).CornerRadius = UDim.new(0, 24)

-- ظل خارجي للإطار
local codeShadow                  = Instance.new("Frame")
codeShadow.Size                   = UDim2.new(1, 18, 1, 18)
codeShadow.Position               = UDim2.fromOffset(-9, -9)
codeShadow.BackgroundColor3       = Color3.fromRGB(20, 80, 200)
codeShadow.BackgroundTransparency = 0.82
codeShadow.BorderSizePixel        = 0
codeShadow.ZIndex                 = 51
codeShadow.Parent                 = codeFrame
Instance.new("UICorner", codeShadow).CornerRadius = UDim.new(0, 30)

local codeStroke           = Instance.new("UIStroke", codeFrame)
codeStroke.Thickness       = 2.5
codeStroke.Color           = C_BLUE1

-- شريط علوي متدرج ثلاثي
local topBar               = Instance.new("Frame")
topBar.Size                = UDim2.new(1, 0, 0, 7)
topBar.BackgroundColor3    = C_BLUE1
topBar.BorderSizePixel     = 0
topBar.ZIndex              = 53
topBar.Parent              = codeFrame
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 24)
Instance.new("UIGradient", topBar).Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(0,  60, 220)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(60, 180, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 240, 255)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(60, 180, 255)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(0,  60, 220))
}

-- خطوط زينة في زوايا الإطار (تأثير كاميرا)
local function makeCodeCorner(px, py, ax, ay)
    local h = Instance.new("Frame", codeFrame)
    h.Size = UDim2.fromOffset(20, 2.5)
    h.Position = UDim2.new(px, ax, py, ay)
    h.BackgroundColor3 = C_CYAN
    h.BorderSizePixel = 0; h.ZIndex = 54
    Instance.new("UICorner", h).CornerRadius = UDim.new(1,0)
    local v = Instance.new("Frame", codeFrame)
    v.Size = UDim2.fromOffset(2.5, 20)
    v.Position = UDim2.new(px, ax, py, ay)
    v.BackgroundColor3 = C_CYAN
    v.BorderSizePixel = 0; v.ZIndex = 54
    Instance.new("UICorner", v).CornerRadius = UDim.new(1,0)
end
makeCodeCorner(0, 0,  6,  6)
makeCodeCorner(1, 0, -26, 6)
makeCodeCorner(0, 1,  6, -26)
makeCodeCorner(1, 1, -26,-26)

-- ✖ زر X للإغلاق (يمسح السكربت)
local closeBtn                  = Instance.new("TextButton")
closeBtn.Size                   = UDim2.fromOffset(28, 28)
closeBtn.Position               = UDim2.new(1, -34, 0, 8)
closeBtn.BackgroundColor3       = Color3.fromRGB(180, 30, 30)
closeBtn.TextColor3             = C_WHITE
closeBtn.Text                   = "✕"
closeBtn.TextSize               = 14
closeBtn.Font                   = Enum.Font.GothamBold
closeBtn.BorderSizePixel        = 0
closeBtn.ZIndex                 = 55
closeBtn.Parent                 = codeFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 7)

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3=Color3.fromRGB(255,60,60)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3=Color3.fromRGB(180,30,30)}):Play()
end)
closeBtn.MouseButton1Click:Connect(function()
    -- تأثير اختفاء ثم حذف
    TweenService:Create(codeOverlay,
        TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {BackgroundTransparency=1}):Play()
    TweenService:Create(codeFrame,
        TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Size=UDim2.fromOffset(0,0)}):Play()
    task.delay(0.45, function()
        gui:Destroy()
    end)
end)

-- دائرة توهج خلف الأيقونة
local lockGlow                  = Instance.new("Frame")
lockGlow.Size                   = UDim2.fromOffset(80, 80)
lockGlow.AnchorPoint            = Vector2.new(0.5, 0)
lockGlow.Position               = UDim2.new(0.5, 0, 0, 14)
lockGlow.BackgroundColor3       = Color3.fromRGB(30, 100, 255)
lockGlow.BackgroundTransparency = 0.7
lockGlow.BorderSizePixel        = 0
lockGlow.ZIndex                 = 52
lockGlow.Parent                 = codeFrame
Instance.new("UICorner", lockGlow).CornerRadius = UDim.new(1, 0)

-- نبضة الدائرة
task.spawn(function()
    while lockGlow.Parent do
        TweenService:Create(lockGlow, TweenInfo.new(1.0, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Size=UDim2.fromOffset(90,90), BackgroundTransparency=0.82}):Play()
        task.wait(1.0)
        TweenService:Create(lockGlow, TweenInfo.new(1.0, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Size=UDim2.fromOffset(80,80), BackgroundTransparency=0.7}):Play()
        task.wait(1.0)
    end
end)

-- أيقونة قفل كبيرة مع توهج
local lockIcon                  = Instance.new("TextLabel")
lockIcon.Size                   = UDim2.fromOffset(62, 62)
lockIcon.AnchorPoint            = Vector2.new(0.5, 0)
lockIcon.Position               = UDim2.new(0.5, 0, 0, 23)
lockIcon.BackgroundTransparency = 1
lockIcon.Text                   = "🔐"
lockIcon.TextScaled             = true
lockIcon.ZIndex                 = 53
lockIcon.Parent                 = codeFrame

-- نبضة الأيقونة
task.spawn(function()
    while lockIcon.Parent do
        TweenService:Create(lockIcon,
            TweenInfo.new(1.0, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Size=UDim2.fromOffset(70,70), Position=UDim2.new(0.5,-35,0,18)}):Play()
        task.wait(1.0)
        TweenService:Create(lockIcon,
            TweenInfo.new(1.0, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Size=UDim2.fromOffset(62,62), Position=UDim2.new(0.5,-31,0,23)}):Play()
        task.wait(1.0)
    end
end)

-- عنوان رئيسي
local codeTitle                  = Instance.new("TextLabel")
codeTitle.Size                   = UDim2.new(1, -20, 0, 28)
codeTitle.Position               = UDim2.fromOffset(10, 100)
codeTitle.BackgroundTransparency = 1
codeTitle.TextScaled             = true
codeTitle.Text                   = "أدخل كود الدخول"
codeTitle.Font                   = Enum.Font.GothamBold
codeTitle.TextColor3             = C_WHITE
codeTitle.ZIndex                 = 53
codeTitle.Parent                 = codeFrame

-- عنوان فرعي / وصف
local codeSubTitle                  = Instance.new("TextLabel")
codeSubTitle.Size                   = UDim2.new(1, -20, 0, 18)
codeSubTitle.Position               = UDim2.fromOffset(10, 130)
codeSubTitle.BackgroundTransparency = 1
codeSubTitle.TextScaled             = true
codeSubTitle.Text                   = "🔑  Enter access code to continue"
codeSubTitle.Font                   = Enum.Font.Gotham
codeSubTitle.TextColor3             = Color3.fromRGB(100, 155, 225)
codeSubTitle.ZIndex                 = 53
codeSubTitle.Parent                 = codeFrame

-- خط فاصل متوهج
local divider            = Instance.new("Frame")
divider.Size             = UDim2.new(0.78, 0, 0, 1)
divider.AnchorPoint      = Vector2.new(0.5, 0)
divider.Position         = UDim2.new(0.5, 0, 0, 153)
divider.BackgroundColor3 = C_BLUE1
divider.BackgroundTransparency = 0.45
divider.BorderSizePixel  = 0
divider.ZIndex           = 53
divider.Parent           = codeFrame
-- تدرج الخط الفاصل
local divGrad = Instance.new("UIGradient", divider)
divGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(0,0,0)),
    ColorSequenceKeypoint.new(0.3, C_BLUE1),
    ColorSequenceKeypoint.new(0.5, C_CYAN),
    ColorSequenceKeypoint.new(0.7, C_BLUE1),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(0,0,0))
}
divGrad.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0,   1),
    NumberSequenceKeypoint.new(0.2, 0),
    NumberSequenceKeypoint.new(0.8, 0),
    NumberSequenceKeypoint.new(1,   1)
}

-- حقل الكود
local codeBoxBg            = Instance.new("Frame")
codeBoxBg.Size             = UDim2.new(0.88, 0, 0, 48)
codeBoxBg.AnchorPoint      = Vector2.new(0.5, 0)
codeBoxBg.Position         = UDim2.new(0.5, 0, 0, 165)
codeBoxBg.BackgroundColor3 = Color3.fromRGB(6, 18, 58)
codeBoxBg.BorderSizePixel  = 0
codeBoxBg.ZIndex           = 53
codeBoxBg.Parent           = codeFrame
Instance.new("UICorner", codeBoxBg).CornerRadius = UDim.new(0, 13)
local boxStroke = Instance.new("UIStroke", codeBoxBg)
boxStroke.Thickness   = 1.8
boxStroke.Color       = C_BLUE1
boxStroke.Transparency = 0.35

local keyIconLbl                  = Instance.new("TextLabel")
keyIconLbl.Size                   = UDim2.fromOffset(30, 30)
keyIconLbl.Position               = UDim2.fromOffset(10, 9)
keyIconLbl.BackgroundTransparency = 1
keyIconLbl.Text                   = "🗝️"
keyIconLbl.TextScaled             = true
keyIconLbl.ZIndex                 = 54
keyIconLbl.Parent                 = codeBoxBg

local codeBox                    = Instance.new("TextBox", codeBoxBg)
codeBox.Size                     = UDim2.new(1, -50, 1, -12)
codeBox.Position                 = UDim2.fromOffset(46, 6)
codeBox.BackgroundTransparency   = 1
codeBox.TextScaled               = false
codeBox.TextSize                 = 18
codeBox.PlaceholderText          = "أدخل الكود هنا ..."
codeBox.PlaceholderColor3        = Color3.fromRGB(70, 110, 195)
codeBox.Text                     = ""
codeBox.Font                     = Enum.Font.GothamSemibold
codeBox.TextColor3               = C_WHITE
codeBox.TextXAlignment           = Enum.TextXAlignment.Right
codeBox.BorderSizePixel          = 0
codeBox.ZIndex                   = 54
codeBox.ClearTextOnFocus         = false

codeBox.Focused:Connect(function()
    TweenService:Create(boxStroke, TweenInfo.new(0.2), {Transparency=0, Color=C_CYAN}):Play()
    TweenService:Create(codeBoxBg, TweenInfo.new(0.2), {BackgroundColor3=Color3.fromRGB(10,30,90)}):Play()
end)
codeBox.FocusLost:Connect(function()
    TweenService:Create(boxStroke, TweenInfo.new(0.2), {Transparency=0.35, Color=C_BLUE1}):Play()
    TweenService:Create(codeBoxBg, TweenInfo.new(0.2), {BackgroundColor3=Color3.fromRGB(6,18,58)}):Play()
end)

-- زر الدخول
local confirmBtn                  = Instance.new("TextButton")
confirmBtn.Size                   = UDim2.new(0.88, 0, 0, 48)
confirmBtn.AnchorPoint            = Vector2.new(0.5, 0)
confirmBtn.Position               = UDim2.new(0.5, 0, 0, 228)
confirmBtn.BackgroundColor3       = C_BLUE1
confirmBtn.TextColor3             = C_WHITE
confirmBtn.Text                   = "دخـول  ✦"
confirmBtn.TextSize               = 18
confirmBtn.Font                   = Enum.Font.GothamBold
confirmBtn.BorderSizePixel        = 0
confirmBtn.ZIndex                 = 53
confirmBtn.Parent                 = codeFrame
Instance.new("UICorner", confirmBtn).CornerRadius = UDim.new(0, 13)

local confirmGrad = Instance.new("UIGradient", confirmBtn)
confirmGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(20, 100, 245)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(70,  170, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(160, 225, 255)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(70,  170, 255)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(20, 100, 245))
}
confirmGrad.Rotation = 90

-- تأثيرات زر الدخول
local confirmStroke = Instance.new("UIStroke", confirmBtn)
confirmStroke.Thickness = 1.5
confirmStroke.Color = C_CYAN
confirmStroke.Transparency = 0.5

confirmBtn.MouseEnter:Connect(function()
    TweenService:Create(confirmBtn,  TweenInfo.new(0.15), {BackgroundColor3=Color3.fromRGB(80,190,255)}):Play()
    TweenService:Create(confirmStroke, TweenInfo.new(0.15), {Transparency=0}):Play()
end)
confirmBtn.MouseLeave:Connect(function()
    TweenService:Create(confirmBtn,  TweenInfo.new(0.15), {BackgroundColor3=C_BLUE1}):Play()
    TweenService:Create(confirmStroke, TweenInfo.new(0.15), {Transparency=0.5}):Play()
end)

-- نص الخطأ
local codeErrLbl                  = Instance.new("TextLabel")
codeErrLbl.Size                   = UDim2.new(1, 0, 0, 20)
codeErrLbl.Position               = UDim2.new(0, 0, 1, -26)
codeErrLbl.BackgroundTransparency = 1
codeErrLbl.TextScaled             = true
codeErrLbl.Text                   = ""
codeErrLbl.Font                   = Enum.Font.GothamSemibold
codeErrLbl.TextColor3             = Color3.fromRGB(255, 80, 80)
codeErrLbl.ZIndex                 = 53
codeErrLbl.Parent                 = codeFrame

-- وميض إطار كود (أزرق ↔ سيان)
task.spawn(function()
    while codeOverlay.Parent do
        TweenService:Create(codeStroke, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Color=C_CYAN}):Play()
        TweenService:Create(codeGlow,   TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {BackgroundColor3=Color3.fromRGB(60,130,255), BackgroundTransparency=0.82}):Play()
        task.wait(1.4)
        TweenService:Create(codeStroke, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Color=C_BLUE2}):Play()
        TweenService:Create(codeGlow,   TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {BackgroundColor3=Color3.fromRGB(20,60,180), BackgroundTransparency=0.90}):Play()
        task.wait(1.4)
    end
end)

-- ══════════════════════════════════════════════════════
-- 🔔 إشعارات Toast — صغيرة وأنيقة
-- ══════════════════════════════════════════════════════
local function showToast(icon, titleText, bodyText, accentColor, duration, onDone)
    for _, child in ipairs(gui:GetChildren()) do
        if child.Name == "ToastFrame" then child:Destroy() end
    end
    local toast                  = Instance.new("Frame")
    toast.Name                   = "ToastFrame"
    toast.Size                   = UDim2.fromOffset(230, 54)
    toast.AnchorPoint            = Vector2.new(0.5, 0)
    toast.Position               = UDim2.new(0.5, 0, 0, -65)
    toast.BackgroundColor3       = Color3.fromRGB(5, 14, 40)
    toast.BackgroundTransparency = 0.1
    toast.BorderSizePixel        = 0
    toast.ZIndex                 = 70
    toast.Parent                 = gui
    Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 10)
    local toastStroke      = Instance.new("UIStroke", toast)
    toastStroke.Thickness  = 1.5
    toastStroke.Color      = accentColor

    -- شريط لون أعلى
    local topAccent            = Instance.new("Frame", toast)
    topAccent.Size             = UDim2.new(1, 0, 0, 3)
    topAccent.BackgroundColor3 = accentColor
    topAccent.BorderSizePixel  = 0
    topAccent.ZIndex           = 71
    Instance.new("UICorner", topAccent).CornerRadius = UDim.new(0, 10)
    Instance.new("UIGradient", topAccent).Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,   accentColor),
        ColorSequenceKeypoint.new(0.5, C_WHITE),
        ColorSequenceKeypoint.new(1,   accentColor)
    }

    local iconLbl                  = Instance.new("TextLabel", toast)
    iconLbl.Size                   = UDim2.fromOffset(26, 26)
    iconLbl.Position               = UDim2.fromOffset(8, 14)
    iconLbl.BackgroundTransparency = 1
    iconLbl.TextScaled             = true
    iconLbl.Text                   = icon
    iconLbl.ZIndex                 = 71

    local titleLbl                  = Instance.new("TextLabel", toast)
    titleLbl.Size                   = UDim2.new(1, -40, 0, 20)
    titleLbl.Position               = UDim2.fromOffset(38, 9)
    titleLbl.BackgroundTransparency = 1
    titleLbl.TextSize               = 12
    titleLbl.Text                   = titleText
    titleLbl.Font                   = Enum.Font.GothamBold
    titleLbl.TextColor3             = C_WHITE
    titleLbl.TextXAlignment         = Enum.TextXAlignment.Left
    titleLbl.ZIndex                 = 71

    local bodyLbl                  = Instance.new("TextLabel", toast)
    bodyLbl.Size                   = UDim2.new(1, -40, 0, 16)
    bodyLbl.Position               = UDim2.fromOffset(38, 30)
    bodyLbl.BackgroundTransparency = 1
    bodyLbl.TextSize               = 10
    bodyLbl.Text                   = bodyText
    bodyLbl.Font                   = Enum.Font.Gotham
    bodyLbl.TextColor3             = Color3.fromRGB(160, 200, 255)
    bodyLbl.TextXAlignment         = Enum.TextXAlignment.Left
    bodyLbl.ZIndex                 = 71

    -- شريط تقدم
    local pgBg            = Instance.new("Frame", toast)
    pgBg.Size             = UDim2.new(1, -14, 0, 2)
    pgBg.Position         = UDim2.new(0, 7, 1, -4)
    pgBg.BackgroundColor3 = Color3.fromRGB(20, 40, 90)
    pgBg.BorderSizePixel  = 0
    pgBg.ZIndex           = 71
    Instance.new("UICorner", pgBg).CornerRadius = UDim.new(1, 0)
    local pgBar            = Instance.new("Frame", pgBg)
    pgBar.Size             = UDim2.fromScale(1, 1)
    pgBar.BackgroundColor3 = accentColor
    pgBar.BorderSizePixel  = 0
    pgBar.ZIndex           = 72
    Instance.new("UICorner", pgBar).CornerRadius = UDim.new(1, 0)

    TweenService:Create(toast,
        TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, 0, 0, 8)}):Play()
    TweenService:Create(pgBar,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        {Size = UDim2.fromScale(0, 1)}):Play()

    task.spawn(function()
        local rem = duration
        while rem > 0 and toast.Parent do
            if bodyText:find("%%d") then bodyLbl.Text = bodyText:format(math.ceil(rem)) end
            task.wait(0.1); rem = rem - 0.1
        end
    end)
    task.delay(duration, function()
        if not toast.Parent then return end
        TweenService:Create(toast,
            TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {Position = UDim2.new(0.5, 0, 0, -65), BackgroundTransparency=1}):Play()
        task.delay(0.32, function()
            if toast.Parent then toast:Destroy() end
            if onDone then onDone() end
        end)
    end)
end

-- ══════════════════════════════════════════════════════════════════════
-- 🎬 شاشة LIVE — تصميم V محسّن مع تأثيرات واقعية
-- ══════════════════════════════════════════════════════════════════════
local liveScreen                  = Instance.new("Frame")
liveScreen.Size                   = UDim2.fromScale(1, 1)
liveScreen.BackgroundTransparency = 1
liveScreen.BorderSizePixel        = 0
liveScreen.ZIndex                 = 2
liveScreen.Visible                = false
liveScreen.Parent                 = gui

-- إطار حول الشاشة الكاملة
local liveBorder                  = Instance.new("Frame")
liveBorder.Size                   = UDim2.new(1, -6, 1, -6)
liveBorder.Position               = UDim2.fromOffset(3, 3)
liveBorder.BackgroundTransparency = 1
liveBorder.BorderSizePixel        = 0
liveBorder.ZIndex                 = 3
liveBorder.Parent                 = liveScreen
local liveBorderStroke            = Instance.new("UIStroke", liveBorder)
liveBorderStroke.Thickness        = 2
liveBorderStroke.Color            = C_CYAN
liveBorderStroke.Transparency     = 0.65
Instance.new("UICorner", liveBorder).CornerRadius = UDim.new(0, 8)

-- شريط مسح متحرك
local scanOverlay                   = Instance.new("Frame")
scanOverlay.Size                    = UDim2.new(1, 0, 0, 1)
scanOverlay.BackgroundColor3        = C_CYAN
scanOverlay.BackgroundTransparency  = 0.9
scanOverlay.BorderSizePixel         = 0
scanOverlay.ZIndex                  = 3
scanOverlay.Parent                  = liveScreen

-- زوايا كاميرا
local function makeScreenCorner(ax, ay, px, py)
    local h = Instance.new("Frame")
    h.Size = UDim2.fromOffset(18, 2)
    h.AnchorPoint = Vector2.new(ax, ay)
    h.Position = UDim2.fromScale(px, py)
    h.BackgroundColor3 = C_CYAN
    h.BorderSizePixel = 0; h.ZIndex = 5
    h.Parent = liveScreen
    local v = Instance.new("Frame")
    v.Size = UDim2.fromOffset(2, 18)
    v.AnchorPoint = Vector2.new(ax, ay)
    v.Position = UDim2.fromScale(px, py)
    v.BackgroundColor3 = C_CYAN
    v.BorderSizePixel = 0; v.ZIndex = 5
    v.Parent = liveScreen
end
makeScreenCorner(0,0, 0.012, 0.012)
makeScreenCorner(1,0, 0.988, 0.012)
makeScreenCorner(0,1, 0.012, 0.988)
makeScreenCorner(1,1, 0.988, 0.988)

-- ════════════════════════════════════════
-- شريط أعلى الشاشة
-- ════════════════════════════════════════
local topHUD                  = Instance.new("Frame")
topHUD.Size                   = UDim2.new(1, 0, 0, 46)
topHUD.BackgroundColor3       = Color3.fromRGB(0, 5, 20)
topHUD.BackgroundTransparency = 0.35
topHUD.BorderSizePixel        = 0
topHUD.ZIndex                 = 5
topHUD.Parent                 = liveScreen
local topGrad                 = Instance.new("UIGradient", topHUD)
topGrad.Transparency          = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 0.15),
    NumberSequenceKeypoint.new(1, 1)
}
topGrad.Rotation = 90

-- ════════════════════════════════════════
-- 🔴 LIVE — نقطة تتلون أزرق وأبيض
-- ════════════════════════════════════════
local liveDot                  = Instance.new("Frame")
liveDot.Size                   = UDim2.fromOffset(10, 10)
liveDot.Position               = UDim2.fromOffset(12, 18)
liveDot.AnchorPoint            = Vector2.new(0, 0.5)
liveDot.BackgroundColor3       = C_BLUE1
liveDot.BorderSizePixel        = 0
liveDot.ZIndex                 = 6
liveDot.Parent                 = topHUD
Instance.new("UICorner", liveDot).CornerRadius = UDim.new(1, 0)

-- نبضة النقطة: تتلون أزرق ↔ أبيض
task.spawn(function()
    while liveDot.Parent do
        TweenService:Create(liveDot, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {BackgroundColor3=C_WHITE, BackgroundTransparency=0.1}):Play()
        task.wait(0.6)
        TweenService:Create(liveDot, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {BackgroundColor3=C_BLUE1, BackgroundTransparency=0.7}):Play()
        task.wait(0.6)
    end
end)

local liveTxt                  = Instance.new("TextLabel")
liveTxt.Size                   = UDim2.fromOffset(38, 18)
liveTxt.Position               = UDim2.fromOffset(28, 14)
liveTxt.BackgroundTransparency = 1
liveTxt.Text                   = "LIVE"
liveTxt.TextSize               = 12
liveTxt.Font                   = Enum.Font.GothamBold
liveTxt.TextColor3             = C_WHITE
liveTxt.ZIndex                 = 6
liveTxt.Parent                 = topHUD

-- وميض نص LIVE أزرق ↔ أبيض
task.spawn(function()
    while liveTxt.Parent do
        TweenService:Create(liveTxt, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {TextColor3=C_BLUE1}):Play()
        task.wait(0.6)
        TweenService:Create(liveTxt, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {TextColor3=C_WHITE}):Play()
        task.wait(0.6)
    end
end)

-- ════════════════════════════════════════════════
-- 💎 لوغو "V" في المنتصف — تصميم احترافي
-- ════════════════════════════════════════════════
local vLogoFrame                  = Instance.new("Frame")
vLogoFrame.Size                   = UDim2.fromOffset(120, 38)
vLogoFrame.AnchorPoint            = Vector2.new(0.5, 0)
vLogoFrame.Position               = UDim2.new(0.5, 0, 0, 4)
vLogoFrame.BackgroundTransparency = 1
vLogoFrame.ZIndex                 = 6
vLogoFrame.Parent                 = topHUD

local vLogoBg                  = Instance.new("Frame")
vLogoBg.Size                   = UDim2.fromScale(1, 1)
vLogoBg.BackgroundColor3       = Color3.fromRGB(0, 10, 35)
vLogoBg.BackgroundTransparency = 0.25
vLogoBg.BorderSizePixel        = 0
vLogoBg.ZIndex                 = 6
vLogoBg.Parent                 = vLogoFrame
Instance.new("UICorner", vLogoBg).CornerRadius = UDim.new(0, 9)
local vBgStroke = Instance.new("UIStroke", vLogoBg)
vBgStroke.Thickness = 1.2
vBgStroke.Color = C_CYAN
vBgStroke.Transparency = 0.25

local vBgGrad = Instance.new("UIGradient", vLogoBg)
vBgGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(0, 20, 75)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 60, 140)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(0, 20, 75))
}

local vSymbol                  = Instance.new("TextLabel")
vSymbol.Size                   = UDim2.fromOffset(30, 32)
vSymbol.Position               = UDim2.fromOffset(7, 3)
vSymbol.BackgroundTransparency = 1
vSymbol.Text                   = "V"
vSymbol.TextSize               = 22
vSymbol.Font                   = Enum.Font.GothamBold
vSymbol.TextColor3             = C_CYAN
vSymbol.ZIndex                 = 7
vSymbol.Parent                 = vLogoFrame

local vSpectateLabel                  = Instance.new("TextLabel")
vSpectateLabel.Size                   = UDim2.fromOffset(76, 16)
vSpectateLabel.Position               = UDim2.fromOffset(38, 4)
vSpectateLabel.BackgroundTransparency = 1
vSpectateLabel.Text                   = "SPECTATE"
vSpectateLabel.TextSize               = 11
vSpectateLabel.Font                   = Enum.Font.GothamBold
vSpectateLabel.TextColor3             = C_WHITE
vSpectateLabel.ZIndex                 = 7
vSpectateLabel.Parent                 = vLogoFrame

local vPlayerName                  = Instance.new("TextLabel")
vPlayerName.Size                   = UDim2.fromOffset(76, 14)
vPlayerName.Position               = UDim2.fromOffset(38, 20)
vPlayerName.BackgroundTransparency = 1
vPlayerName.Text                   = "—"
vPlayerName.TextSize               = 10
vPlayerName.Font                   = Enum.Font.Gotham
vPlayerName.TextColor3             = Color3.fromRGB(160, 210, 255)
vPlayerName.ZIndex                 = 7
vPlayerName.Parent                 = vLogoFrame

-- وميض V وإطاره (أزرق ↔ أبيض)
task.spawn(function()
    while vSymbol.Parent do
        TweenService:Create(vSymbol,    TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {TextColor3=C_WHITE}):Play()
        TweenService:Create(vBgStroke,  TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Color=C_WHITE, Transparency=0.1}):Play()
        task.wait(1.1)
        TweenService:Create(vSymbol,    TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {TextColor3=C_CYAN}):Play()
        TweenService:Create(vBgStroke,  TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Color=C_CYAN, Transparency=0.25}):Play()
        task.wait(1.1)
    end
end)

-- ════════════════════════════════════════════════════════
-- ⏱️ وقت اللاعب — على يمين الشاشة (يتلون أزرق وأبيض)
-- ════════════════════════════════════════════════════════
local playerSideTimer                  = Instance.new("Frame")
playerSideTimer.Size                   = UDim2.fromOffset(90, 44)
playerSideTimer.AnchorPoint            = Vector2.new(1, 0.5)
playerSideTimer.Position               = UDim2.new(1, -10, 0.5, 0)
playerSideTimer.BackgroundColor3       = Color3.fromRGB(3, 10, 35)
playerSideTimer.BackgroundTransparency = 0.25
playerSideTimer.BorderSizePixel        = 0
playerSideTimer.ZIndex                 = 6
playerSideTimer.Visible                = false
playerSideTimer.Parent                 = liveScreen
Instance.new("UICorner", playerSideTimer).CornerRadius = UDim.new(0, 10)
local sideTimerStroke = Instance.new("UIStroke", playerSideTimer)
sideTimerStroke.Thickness = 1.5
sideTimerStroke.Color = C_BLUE1

-- شريط علوي ملون
local sideTimerBar            = Instance.new("Frame", playerSideTimer)
sideTimerBar.Size             = UDim2.new(1, 0, 0, 3)
sideTimerBar.BackgroundColor3 = C_BLUE1
sideTimerBar.BorderSizePixel  = 0
sideTimerBar.ZIndex           = 7
Instance.new("UICorner", sideTimerBar).CornerRadius = UDim.new(0, 10)
Instance.new("UIGradient", sideTimerBar).Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   C_BLUE1),
    ColorSequenceKeypoint.new(0.5, C_WHITE),
    ColorSequenceKeypoint.new(1,   C_BLUE1)
}

local sideTimerIcon                  = Instance.new("TextLabel", playerSideTimer)
sideTimerIcon.Size                   = UDim2.fromOffset(22, 22)
sideTimerIcon.Position               = UDim2.fromOffset(6, 10)
sideTimerIcon.BackgroundTransparency = 1
sideTimerIcon.Text                   = "⏱"
sideTimerIcon.TextScaled             = true
sideTimerIcon.ZIndex                 = 7

local sideTimerLbl                  = Instance.new("TextLabel", playerSideTimer)
sideTimerLbl.Size                   = UDim2.new(1, -32, 1, -6)
sideTimerLbl.Position               = UDim2.fromOffset(28, 3)
sideTimerLbl.BackgroundTransparency = 1
sideTimerLbl.TextSize               = 14
sideTimerLbl.Text                   = "00:00:00"
sideTimerLbl.Font                   = Enum.Font.GothamBold
sideTimerLbl.TextColor3             = C_BLUE1
sideTimerLbl.ZIndex                 = 7

-- تلوين Timer يمين (أزرق ↔ أبيض)
task.spawn(function()
    while sideTimerLbl.Parent do
        TweenService:Create(sideTimerLbl,  TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {TextColor3=C_WHITE}):Play()
        TweenService:Create(sideTimerStroke, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Color=C_WHITE}):Play()
        TweenService:Create(sideTimerBar,  TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {BackgroundColor3=C_WHITE}):Play()
        task.wait(0.8)
        TweenService:Create(sideTimerLbl,  TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {TextColor3=C_BLUE1}):Play()
        TweenService:Create(sideTimerStroke, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Color=C_BLUE1}):Play()
        TweenService:Create(sideTimerBar,  TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {BackgroundColor3=C_BLUE1}):Play()
        task.wait(0.8)
    end
end)

-- متغيرات timer اللاعب
local playerTimerStart = 0
local playerTimerConn  = nil
local playerTimerDead  = false

local function resetPlayerTimer()
    playerTimerStart = tick()
    playerTimerDead  = false
    sideTimerLbl.Text = "00:00:00"
    playerSideTimer.Visible = true
end

local function stopPlayerTimer()
    if playerTimerConn then playerTimerConn:Disconnect(); playerTimerConn = nil end
    playerSideTimer.Visible = false
    playerTimerStart = 0
end

local function startPlayerTimer()
    if playerTimerConn then playerTimerConn:Disconnect() end
    resetPlayerTimer()
    playerTimerConn = R.Heartbeat:Connect(function()
        if playerTimerStart == 0 then return end
        local elapsed = math.floor(tick() - playerTimerStart)
        local h = math.floor(elapsed/3600)
        local m = math.floor((elapsed%3600)/60)
        local s = elapsed%60
        sideTimerLbl.Text = string.format("%02d:%02d:%02d", h, m, s)
    end)
end

-- معلومات كاميرا (أسفل اليسار)
local camInfoFrame                  = Instance.new("Frame")
camInfoFrame.Size                   = UDim2.fromOffset(138, 32)
camInfoFrame.Position               = UDim2.new(0, 8, 1, -46)
camInfoFrame.BackgroundColor3       = Color3.fromRGB(0, 5, 20)
camInfoFrame.BackgroundTransparency = 0.4
camInfoFrame.BorderSizePixel        = 0
camInfoFrame.ZIndex                 = 5
camInfoFrame.Parent                 = liveScreen
Instance.new("UICorner", camInfoFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", camInfoFrame).Color = C_BLUE1
local camInfoTxt                  = Instance.new("TextLabel", camInfoFrame)
camInfoTxt.Size                   = UDim2.fromScale(1, 1)
camInfoTxt.BackgroundTransparency = 1
camInfoTxt.TextSize               = 10
camInfoTxt.Text                   = "📷 CAM-01  |  AUTO TRACK"
camInfoTxt.Font                   = Enum.Font.GothamBold
camInfoTxt.TextColor3             = C_CYAN
camInfoTxt.ZIndex                 = 6

-- (تم حذف عداد الوقت الأخضر بناءً على الطلب)

-- ══════════════════════════════════════
-- المحتوى الرئيسي
-- ══════════════════════════════════════
local mainContent                  = Instance.new("Frame")
mainContent.Size                   = UDim2.fromScale(1, 1)
mainContent.BackgroundTransparency = 1
mainContent.Visible                = false
mainContent.Parent                 = gui

-- ══════════════════════════════════════
-- 🔒 زر الإخفاء — حجم 45، مخفي حتى التحقق
-- ══════════════════════════════════════
local hideBtn            = Instance.new("TextButton")
hideBtn.Size             = UDim2.fromOffset(45, 45)
hideBtn.Position         = UDim2.new(1, -55, 0, 10)
hideBtn.BackgroundColor3 = Color3.fromRGB(6, 18, 55)
hideBtn.TextColor3       = C_WHITE
hideBtn.Text             = "👁"
hideBtn.TextScaled       = true
hideBtn.Font             = Enum.Font.GothamBold
hideBtn.BorderSizePixel  = 0
hideBtn.ZIndex           = 80
hideBtn.Visible          = false
hideBtn.Parent           = gui
Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(0, 12)
local hideBtnStroke = Instance.new("UIStroke", hideBtn)
hideBtnStroke.Thickness = 1.8
hideBtnStroke.Color = C_BLUE1

task.spawn(function()
    while hideBtn.Parent do
        TweenService:Create(hideBtnStroke, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Color=C_WHITE, Transparency=0.1}):Play()
        task.wait(1.1)
        TweenService:Create(hideBtnStroke, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Color=C_BLUE1, Transparency=0}):Play()
        task.wait(1.1)
    end
end)

-- سحب زر الإخفاء المحسّن
local hideDragging  = false
local hideDragStart = nil
local hideBtnAbsX   = 0
local hideBtnAbsY   = 0
local hideMoved     = false
local DRAG_THRESHOLD = 5

hideBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        hideDragging  = true
        hideMoved     = false
        hideDragStart = input.Position
        hideBtnAbsX   = hideBtn.AbsolutePosition.X
        hideBtnAbsY   = hideBtn.AbsolutePosition.Y
    end
end)

UIS.InputChanged:Connect(function(input)
    if not hideDragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement
    and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = input.Position - hideDragStart
    if math.abs(delta.X) > DRAG_THRESHOLD or math.abs(delta.Y) > DRAG_THRESHOLD then
        hideMoved = true
    end
    if hideMoved then
        local vp  = cam.ViewportSize
        local btn = 45
        hideBtn.Position = UDim2.fromOffset(
            math.clamp(hideBtnAbsX + delta.X, 0, vp.X - btn),
            math.clamp(hideBtnAbsY + delta.Y, 0, vp.Y - btn)
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        hideDragging = false
    end
end)

hideBtn.MouseButton1Click:Connect(function()
    if hideMoved then hideMoved = false; return end
    clickSound:Play()
    scriptHidden = not scriptHidden
    if scriptHidden then
        mainContent.Visible       = false
        liveScreen.Visible        = false
        playerSideTimer.Visible   = false
        hideBtn.Text              = "🙈"
        hideBtn.BackgroundColor3  = Color3.fromRGB(30, 8, 8)
        showToast("🙈", "تم إخفاء المراقبة", "اضغط 👁 للإظهار", Color3.fromRGB(200,80,80), 2)
    else
        mainContent.Visible      = true
        if spectating then
            liveScreen.Visible      = true
            playerSideTimer.Visible = true
        end
        hideBtn.Text             = "👁"
        hideBtn.BackgroundColor3 = Color3.fromRGB(6, 18, 55)
        showToast("👁", "تم إرجاع المراقبة", "السكربت نشط", C_GREEN, 2)
    end
end)

-- ══════════════════════════════════════
-- الأيقونة الرئيسية
-- ══════════════════════════════════════
local ICON_SIZE = 42
local ICON_X    = 0.022
local ICON_Y    = 0.42

local function makeRing(size, alpha, z)
    local r = Instance.new("Frame")
    r.Size = UDim2.fromOffset(size, size)
    r.AnchorPoint = Vector2.new(0.5, 0.5)
    r.BackgroundTransparency = 1
    r.ZIndex = z or 3; r.BorderSizePixel = 0
    r.Parent = mainContent
    Instance.new("UICorner", r).CornerRadius = UDim.new(1, 0)
    local s = Instance.new("UIStroke", r)
    s.Thickness = 1.2; s.Color = C_BLUE1; s.Transparency = alpha or 0.4
    return r, s
end

local ring1, ring1S = makeRing(56, 0.3, 3)
local ring2, ring2S = makeRing(72, 0.5, 2)
local ring3, ring3S = makeRing(88, 0.7, 1)

local NUM_DOTS = 6
local dots = {}
for i = 1, NUM_DOTS do
    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(4, 4)
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.BackgroundColor3 = (i%2==0) and C_WHITE or C_BLUE1
    dot.BorderSizePixel = 0; dot.ZIndex = 4
    dot.Parent = mainContent
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    table.insert(dots, dot)
end

local particles = {}
for i = 1, 4 do
    local p = Instance.new("Frame")
    p.Size = UDim2.fromOffset(3, 3)
    p.AnchorPoint = Vector2.new(0.5, 0.5)
    p.BackgroundColor3 = C_CYAN
    p.BorderSizePixel = 0; p.ZIndex = 4
    p.BackgroundTransparency = 0.3
    p.Parent = mainContent
    Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
    table.insert(particles, p)
end

-- جناح
local function makeWing(z)
    local f = Instance.new("Frame")
    f.BackgroundTransparency = 1; f.BorderSizePixel = 0; f.ZIndex = z
    f.Parent = mainContent
    local s = Instance.new("UIStroke", f)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0.5, 0)
    return f, s
end
local fL, fLS = makeWing(3); local fR, fRS = makeWing(3)
local iL, iLS = makeWing(3); local iR, iRS = makeWing(3)
fLS.Thickness = 2; fRS.Thickness = 2
iLS.Thickness = 1.2; iRS.Thickness = 1.2

local iconFrame = Instance.new("Frame")
iconFrame.Size = UDim2.fromOffset(ICON_SIZE, ICON_SIZE)
iconFrame.Position = UDim2.new(ICON_X, 0, ICON_Y, -ICON_SIZE/2)
iconFrame.BackgroundColor3 = Color3.fromRGB(140, 210, 255)
iconFrame.BorderSizePixel = 0; iconFrame.ZIndex = 6
iconFrame.ClipsDescendants = true; iconFrame.Parent = mainContent
Instance.new("UICorner", iconFrame).CornerRadius = UDim.new(0, 10)
local iconStroke = Instance.new("UIStroke", iconFrame)
iconStroke.Thickness = 1.8; iconStroke.Color = C_BLUE1
local iconGrad = Instance.new("UIGradient", iconFrame)
iconGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100,190,255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180,225,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255))
}
iconGrad.Rotation = 135

local shimmer = Instance.new("Frame", iconFrame)
shimmer.Size = UDim2.fromScale(0.5, 0.5)
shimmer.Position = UDim2.fromScale(0.24, 0.14)
shimmer.BackgroundColor3 = Color3.fromRGB(255,255,255)
shimmer.BackgroundTransparency = 0.6; shimmer.BorderSizePixel = 0; shimmer.ZIndex = 7
Instance.new("UICorner", shimmer).CornerRadius = UDim.new(1,0)

local scanLineIcon = Instance.new("Frame", iconFrame)
scanLineIcon.Size = UDim2.fromOffset(ICON_SIZE, 2)
scanLineIcon.BackgroundColor3 = C_CYAN
scanLineIcon.BackgroundTransparency = 0.4; scanLineIcon.BorderSizePixel = 0; scanLineIcon.ZIndex = 8

-- زوايا الأيقونة
local CORNER_LEN = 7; local CORNER_THICK = 1.8; local CORNER_GAP = 4
local cornerLines = {}
local function makeCL(isH)
    local l = Instance.new("Frame")
    l.BackgroundColor3 = C_WHITE; l.BorderSizePixel = 0; l.ZIndex = 9; l.Parent = mainContent
    l.Size = isH and UDim2.fromOffset(CORNER_LEN, CORNER_THICK) or UDim2.fromOffset(CORNER_THICK, CORNER_LEN)
    table.insert(cornerLines, l); return l
end
local tlH=makeCL(true); local tlV=makeCL(false)
local trH=makeCL(true); local trV=makeCL(false)
local blH=makeCL(true); local blV=makeCL(false)
local brH=makeCL(true); local brV=makeCL(false)

local function updateCorners(cx, cy, sz, col)
    local h, g = sz/2, CORNER_GAP
    tlH.Position=UDim2.fromOffset(cx-h-g-CORNER_LEN, cy-h-g-CORNER_THICK)
    tlV.Position=UDim2.fromOffset(cx-h-g-CORNER_THICK, cy-h-g-CORNER_LEN)
    trH.Position=UDim2.fromOffset(cx+h+g, cy-h-g-CORNER_THICK)
    trV.Position=UDim2.fromOffset(cx+h+g, cy-h-g-CORNER_LEN)
    blH.Position=UDim2.fromOffset(cx-h-g-CORNER_LEN, cy+h+g)
    blV.Position=UDim2.fromOffset(cx-h-g-CORNER_THICK, cy+h+g)
    brH.Position=UDim2.fromOffset(cx+h+g, cy+h+g)
    brV.Position=UDim2.fromOffset(cx+h+g, cy+h+g)
    for _, l in ipairs(cornerLines) do l.BackgroundColor3 = col end
end

-- ══════════════════════════════════════
-- أزرار التنقل — صغيرة وملونة
-- ══════════════════════════════════════
local function makeNavBtn(txt, posX)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(48, 32)
    b.Position = UDim2.new(posX, 0, 0.90, 0)
    b.AnchorPoint = Vector2.new(0.5, 0.5)
    b.Text = txt; b.TextSize = 14
    b.BackgroundColor3 = C_BLUE2; b.TextColor3 = C_WHITE
    b.Font = Enum.Font.GothamBold; b.BorderSizePixel = 0; b.ZIndex = 5
    b.Parent = mainContent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", b)
    s.Thickness = 1.5; s.Color = C_WHITE
    local g = Instance.new("UIGradient", b)
    g.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40,130,255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180,220,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40,130,255))
    }
    g.Rotation = 90
    return b, s
end
local prev, prevS = makeNavBtn("◀", 0.35)
local nxt,  nxtS  = makeNavBtn("▶", 0.65)

-- اسم اللاعب — صغير وأنيق
local nameLbl = Instance.new("TextLabel")
nameLbl.Size = UDim2.fromOffset(140, 22)
nameLbl.Position = UDim2.new(0.5, 0, 0.84, 0)
nameLbl.AnchorPoint = Vector2.new(0.5, 0.5)
nameLbl.BackgroundColor3 = Color3.fromRGB(0, 8, 30)
nameLbl.BackgroundTransparency = 0.3; nameLbl.BorderSizePixel = 0
nameLbl.TextSize = 10; nameLbl.Text = "اختر لاعب  ◀ ▶"
nameLbl.Font = Enum.Font.GothamSemibold; nameLbl.TextColor3 = C_WHITE
nameLbl.ZIndex = 5; nameLbl.Parent = mainContent
Instance.new("UICorner", nameLbl).CornerRadius = UDim.new(0, 6)
local nameStroke = Instance.new("UIStroke", nameLbl)
nameStroke.Thickness = 1; nameStroke.Color = C_BLUE1

-- زر انتقال — صغير وملون
local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.fromOffset(110, 28)
tpBtn.Position = UDim2.new(0.5, 0, 0.905, 0)
tpBtn.AnchorPoint = Vector2.new(0.5, 0)
tpBtn.Text = "🚀 انتقل"; tpBtn.TextSize = 11
tpBtn.BackgroundColor3 = C_BLUE2; tpBtn.TextColor3 = C_WHITE
tpBtn.Font = Enum.Font.GothamBold; tpBtn.BorderSizePixel = 0; tpBtn.ZIndex = 5
tpBtn.Parent = mainContent
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 8)
local tpStroke = Instance.new("UIStroke", tpBtn)
tpStroke.Thickness = 1.5; tpStroke.Color = C_WHITE
local tpGrad = Instance.new("UIGradient", tpBtn)
tpGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30,110,255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200,230,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30,110,255))
}
tpGrad.Rotation = 90

task.spawn(function()
    while tpBtn.Parent do
        TweenService:Create(tpStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Color=C_CYAN, Transparency=0.1}):Play()
        task.wait(1)
        TweenService:Create(tpStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Color=C_WHITE, Transparency=0}):Play()
        task.wait(1)
    end
end)

tpBtn.MouseButton1Click:Connect(function()
    if idx == 0 then
        showToast("⚠️", "لم تختر لاعب", "اختر لاعباً أولاً", Color3.fromRGB(255,200,50), 2)
        return
    end
    local list = getPlayers()
    if #list == 0 then showToast("⚠️","لا يوجد لاعبون","السيرفر فارغ",Color3.fromRGB(255,80,80),2); return end
    if idx > #list then idx = 1 end
    local target = list[idx]
    if not target then return end

    local function tryTp()
        local myC = lp.Character
        if not myC then return false end
        local myR = myC:FindFirstChild("HumanoidRootPart")
        if not myR then return false end
        local tC = target.Character
        if not tC then return false end
        local tR = tC:FindFirstChild("HumanoidRootPart")
        if not tR then return false end
        myR.CFrame = tR.CFrame + Vector3.new(0, 4, 0)
        return true
    end

    clickSound:Play()
    TweenService:Create(tpBtn, TweenInfo.new(0.1), {BackgroundColor3=Color3.fromRGB(80,200,255)}):Play()
    task.delay(0.2, function()
        TweenService:Create(tpBtn, TweenInfo.new(0.2), {BackgroundColor3=C_BLUE2}):Play()
    end)

    if tryTp() then
        showToast("🚀","تم الانتقال!","انتقلت إلى "..target.Name, C_GREEN, 2)
    else
        task.spawn(function()
            for _ = 1, 10 do
                task.wait(0.4)
                if tryTp() then
                    showToast("🚀","تم الانتقال!","انتقلت إلى "..target.Name, C_GREEN, 2)
                    return
                end
            end
            showToast("❌","فشل الانتقال",target.Name.." لم يتحمل",Color3.fromRGB(255,80,80),2)
        end)
    end
end)

-- ══════════════════════════════════════
-- تأثيرات شاشة LIVE
-- ══════════════════════════════════════
local scanOverlayY       = 0
local liveWasHidden      = true  -- لتتبع أول مرة يظهر LIVE

local function updateSpectateEffects(t, targetName)
    if scriptHidden then return end
    -- إشعار "خفاء سكربت المراقبة" أول ما تظهر شاشة LIVE
    if not liveScreen.Visible then
        liveWasHidden = false
        showToast("📡", "سكربت المراقبة نشط", "يمكنك إخفاؤه بـ 👁", C_BLUE1, 2.5)
    end
    liveScreen.Visible = true
    vPlayerName.Text   = targetName or "—"
    local pulse = (math.sin(t * 3) + 1) / 2
    liveBorderStroke.Transparency = 0.45 + pulse * 0.4
    scanOverlayY = scanOverlayY + 0.0014
    if scanOverlayY > 1 then scanOverlayY = 0 end
    scanOverlay.Position = UDim2.fromScale(0, scanOverlayY)
end

local function hideSpectateEffects()
    liveScreen.Visible      = false
    playerSideTimer.Visible = false
end

-- جزيئات نقر
local function spawnClickParticles()
    local cx = iconFrame.AbsolutePosition.X + iconFrame.AbsoluteSize.X / 2
    local cy = iconFrame.AbsolutePosition.Y + iconFrame.AbsoluteSize.Y / 2
    for i = 1, 10 do
        local s = Instance.new("Frame")
        s.Size = UDim2.fromOffset(3, 3)
        s.Position = UDim2.fromOffset(cx - 1.5, cy - 1.5)
        s.BackgroundColor3 = (i % 2 == 0) and C_WHITE or C_CYAN
        s.BorderSizePixel = 0; s.ZIndex = 10; s.Parent = gui
        Instance.new("UICorner", s).CornerRadius = UDim.new(1, 0)
        local ang = math.rad((i / 10) * 360)
        local d = math.random(20, 50)
        TweenService:Create(s, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position=UDim2.fromOffset(cx+math.cos(ang)*d-1.5, cy+math.sin(ang)*d-1.5),
             BackgroundTransparency=1, Size=UDim2.fromOffset(1,1)}):Play()
        task.delay(0.45, function() s:Destroy() end)
    end
end

-- ══════════════════════════════════════
-- Loop رئيسي للتأثيرات
-- ══════════════════════════════════════
local colorConn
local scanIconDir = 1; local scanIconPosY = 0

local function startMainLoop()
    if colorConn then colorConn:Disconnect() end
    colorConn = R.RenderStepped:Connect(function()
        local t  = tick()
        local cx = iconFrame.AbsolutePosition.X + iconFrame.AbsoluteSize.X / 2
        local cy = iconFrame.AbsolutePosition.Y + iconFrame.AbsoluteSize.Y / 2
        local wave = (math.sin(t * 1.2) + 1) / 2
        local autoCol    = C_BLUE1:Lerp(C_WHITE, wave)
        local autoColDim = C_BLUE2:Lerp(Color3.fromRGB(200,220,255), wave)

        iconStroke.Color  = autoCol
        ring1S.Color      = autoCol
        ring2S.Color      = autoColDim
        ring3S.Color      = C_BLUE2:Lerp(C_WHITE, wave*0.5)
        scanLineIcon.BackgroundColor3 = autoCol
        prevS.Color = C_WHITE:Lerp(C_CYAN, wave)
        nxtS.Color  = C_WHITE:Lerp(C_CYAN, wave)
        nameStroke.Color   = autoCol
        nameLbl.TextColor3 = autoCol

        iconGrad.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(math.floor(80+wave*60), math.floor(170+wave*50), 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(math.floor(160+wave*60), math.floor(210+wave*35), 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255))
        }
        shimmer.BackgroundTransparency = 0.35 + wave * 0.4

        local pulse = 1 + math.sin(t * 2.5) * 0.04
        local sz    = math.floor(ICON_SIZE * pulse)
        iconFrame.Size     = UDim2.fromOffset(sz, sz)
        iconFrame.Position = UDim2.new(ICON_X, -((sz-ICON_SIZE)/2), ICON_Y, -(sz/2))
        updateCorners(cx, cy, sz, autoCol)

        local flap = math.sin(t * 2.8)
        local flapY = flap * 8
        local wingW = 20 + math.abs(flap) * 5
        local wingH = 28 - math.abs(flap) * 7
        fL.Size=UDim2.fromOffset(wingW,wingH); fL.Position=UDim2.fromOffset(cx-sz/2-wingW+4,cy-wingH/2+flapY); fLS.Color=autoCol
        fR.Size=UDim2.fromOffset(wingW,wingH); fR.Position=UDim2.fromOffset(cx+sz/2-4,cy-wingH/2+flapY);       fRS.Color=autoCol
        local iW=wingW*0.6; local iH=wingH*0.65; local iFY=flapY*0.6
        iL.Size=UDim2.fromOffset(iW,iH); iL.Position=UDim2.fromOffset(cx-sz/2-iW+5,cy-iH/2+iFY); iLS.Color=autoColDim
        iR.Size=UDim2.fromOffset(iW,iH); iR.Position=UDim2.fromOffset(cx+sz/2-5,cy-iH/2+iFY);   iRS.Color=autoColDim

        local rP = math.abs(math.sin(t*1.8))
        ring1S.Transparency=0.2+rP*0.4; ring2S.Transparency=0.4+rP*0.3; ring3S.Transparency=0.6+rP*0.25
        ring1.Position=UDim2.fromOffset(cx-28,cy-28)
        ring2.Position=UDim2.fromOffset(cx-36,cy-36)
        ring3.Position=UDim2.fromOffset(cx-44,cy-44)

        for i, dot in ipairs(dots) do
            local ang = t*1.6+(i/NUM_DOTS)*math.pi*2
            local ps  = 3+math.sin(t*3+i)*1.5
            dot.Position=UDim2.fromOffset(cx+math.cos(ang)*28-ps/2, cy+math.sin(ang)*28-ps/2)
            dot.Size=UDim2.fromOffset(ps,ps)
            dot.BackgroundColor3=(math.floor(t*2.5+i)%2==0) and autoCol or C_DARK
        end
        for i, p in ipairs(particles) do
            local ang2=t*0.8+(i/#particles)*math.pi*2
            local r2=40+math.sin(t*1.5+i)*8
            p.Position=UDim2.fromOffset(cx+math.cos(ang2)*r2-1.5, cy+math.sin(ang2)*r2-1.5)
            p.BackgroundColor3=autoCol; p.BackgroundTransparency=0.2+math.abs(math.sin(t+i))*0.5
        end

        scanIconPosY=scanIconPosY+scanIconDir*0.7
        if scanIconPosY>=ICON_SIZE-2 then scanIconDir=-1 elseif scanIconPosY<=0 then scanIconDir=1 end
        scanLineIcon.Position=UDim2.fromOffset(0,scanIconPosY)
        scanLineIcon.BackgroundTransparency=0.2+(scanIconPosY/ICON_SIZE)*0.5
    end)
end

-- ══════════════════════════════════════
-- Loop المراقبة
-- ══════════════════════════════════════
local spectateConn
local function startSpectateLoop()
    if spectateConn then spectateConn:Disconnect() end
    spectateConn = R.Heartbeat:Connect(function()
        if not isVerified or not spectating or idx == 0 then
            if liveScreen.Visible then hideSpectateEffects() end; return
        end
        local list = getPlayers()
        if #list == 0 then
            nameLbl.Text = "⚠️ لا يوجد لاعبون"
            hideSpectateEffects(); stopPlayerTimer(); stopSpectate(); return
        end
        if idx > #list then idx = #list end
        if idx < 1 then idx = 1 end
        local target = list[idx]
        if not target then return end

        -- تغيير اللاعب → إعادة Timer
        if currentTarget ~= target then
            currentTarget = target
            startPlayerTimer()
        end

        if target.Character then
            local hum = target.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                -- راقب الموت وإعادة الولادة
                if hum.Health <= 0 and not playerTimerDead then
                    playerTimerDead = true
                elseif hum.Health > 0 and playerTimerDead then
                    -- عاد للحياة → إعادة Timer من الصفر
                    playerTimerDead = false
                    resetPlayerTimer()
                end

                if hum.Health > 0 then
                    if cam.CameraSubject ~= hum then
                        cam.CameraType = Enum.CameraType.Custom
                        cam.CameraSubject = hum
                    end
                    if not scriptHidden then playerSideTimer.Visible = true end
                    nameLbl.Text = "👁 " .. target.Name
                    updateSpectateEffects(tick(), target.Name)
                    return
                end
            end
        end
        nameLbl.Text = "⏳ " .. target.Name
        if liveScreen.Visible then hideSpectateEffects() end
    end)
end

-- ══════════════════════════════════════
-- تغيير اللاعب
-- ══════════════════════════════════════
local function changeTarget(dir)
    local list = getPlayers()
    if #list == 0 then nameLbl.Text = "⚠️ لا يوجد لاعبون"; return end
    if idx == 0 then idx = 1
    else
        idx = idx + dir
        if idx < 1 then idx = #list end
        if idx > #list then idx = 1 end
    end
    spectating = true
    if liveStartTime == 0 then liveStartTime = tick() end
    local target = list[idx]
    if target then
        currentTarget = target
        startPlayerTimer()
        if target.Character then
            local hum = target.Character:FindFirstChildOfClass("Humanoid")
            if hum then cam.CameraType=Enum.CameraType.Custom; cam.CameraSubject=hum end
        end
    end
end

prev.MouseButton1Down:Connect(function() clickSound:Play(); changeTarget(-1) end)
nxt.MouseButton1Down:Connect(function()  clickSound:Play(); changeTarget(1)  end)

-- ══════════════════════════════════════
-- ضغط الأيقونة
-- ══════════════════════════════════════
iconFrame.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1
    and input.UserInputType ~= Enum.UserInputType.Touch then return end
    clickSound:Play()
    TweenService:Create(iconFrame, TweenInfo.new(0.07,Enum.EasingStyle.Back,Enum.EasingDirection.In),
        {Size=UDim2.fromOffset(ICON_SIZE*0.82,ICON_SIZE*0.82)}):Play()
    task.delay(0.07, function()
        TweenService:Create(iconFrame, TweenInfo.new(0.14,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
            {Size=UDim2.fromOffset(ICON_SIZE*1.1,ICON_SIZE*1.1)}):Play()
        task.delay(0.14, function()
            TweenService:Create(iconFrame, TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                {Size=UDim2.fromOffset(ICON_SIZE,ICON_SIZE)}):Play()
        end)
    end)
    spawnClickParticles()
    if guiVisible then
        TweenService:Create(mainContent, TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.In),
            {Position=UDim2.fromScale(-0.16,0)}):Play()
        task.delay(0.26, function()
            prev.Visible=false; nxt.Visible=false; nameLbl.Visible=false; tpBtn.Visible=false
            guiVisible=false; mainContent.Position=UDim2.fromScale(0,0)
            stopSpectate(); stopPlayerTimer(); hideSpectateEffects(); liveStartTime=0
        end)
    else
        prev.Visible=true; nxt.Visible=true; nameLbl.Visible=true; tpBtn.Visible=true
        guiVisible=true
        mainContent.Position=UDim2.fromScale(0.16,0)
        TweenService:Create(mainContent, TweenInfo.new(0.28,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
            {Position=UDim2.fromScale(0,0)}):Play()
    end
end)

-- ══════════════════════════════════════
-- التحقق من الكود
-- ══════════════════════════════════════
confirmBtn.MouseButton1Click:Connect(function()
    clickSound:Play()
    if codeBox.Text == REQUIRED_CODE then
        isVerified = true
        TweenService:Create(codeFrame,  TweenInfo.new(0.3,Enum.EasingStyle.Back),
            {BackgroundColor3=Color3.fromRGB(5,30,10)}):Play()
        TweenService:Create(codeStroke, TweenInfo.new(0.3), {Color=C_GREEN}):Play()

        -- تأثير جزيئات نجاح
        for i = 1, 16 do
            task.spawn(function()
                local s = Instance.new("Frame", codeOverlay)
                local sz2 = math.random(3,7)
                s.Size = UDim2.fromOffset(sz2, sz2)
                s.Position = UDim2.fromScale(math.random(30,70)/100, math.random(30,70)/100)
                s.BackgroundColor3 = (i%2==0) and C_GREEN or C_CYAN
                s.BorderSizePixel = 0; s.ZIndex = 60
                Instance.new("UICorner", s).CornerRadius = UDim.new(1,0)
                local ang2 = math.rad(math.random(360))
                TweenService:Create(s, TweenInfo.new(0.7,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                    {Position=UDim2.fromScale(
                        math.random(10,90)/100,
                        math.random(10,90)/100),
                     BackgroundTransparency=1}):Play()
                task.delay(0.75, function() s:Destroy() end)
            end)
            task.wait(0.02)
        end

        task.wait(0.4)
        TweenService:Create(codeOverlay, TweenInfo.new(0.45,Enum.EasingStyle.Quad,Enum.EasingDirection.In),
            {BackgroundTransparency=1}):Play()
        task.delay(0.5, function()
            codeOverlay.Visible = false
            hideBtn.Visible     = true
        end)

        showToast("⏳","جاري التشغيل","انتظر %d ثواني...",C_BLUE1,4,function()
            showToast("✅","تم التشغيل","اختر لاعب ◀ ▶",C_GREEN,3,function()
                mainContent.Visible = true
                startMainLoop()
                startSpectateLoop()
            end)
        end)
    else
        codeErrLbl.Text = "❌  كود خاطئ! حاول مرة ثانية"
        TweenService:Create(codeStroke, TweenInfo.new(0.1), {Color=Color3.fromRGB(255,50,50)}):Play()
        task.delay(0.6, function()
            TweenService:Create(codeStroke, TweenInfo.new(0.35), {Color=C_BLUE1}):Play()
            codeErrLbl.Text = ""
        end)
        -- اهتزاز الإطار
        task.spawn(function()
            for i = 1, 8 do
                task.wait(0.04)
                codeFrame.Position = UDim2.new(0.5, (i%2==0 and 8 or -8), 0.5, 0)
            end
            codeFrame.Position = UDim2.fromScale(0.5, 0.5)
        end)
    end
end)

-- ══════════════════════════════════════
-- خروج لاعب
-- ══════════════════════════════════════
P.PlayerRemoving:Connect(function(removedPlayer)
    if currentTarget == removedPlayer then
        stopPlayerTimer(); currentTarget = nil
    end
    if not spectating then return end
    local newList = {}
    for _, p in ipairs(P:GetPlayers()) do
        if p ~= lp and p ~= removedPlayer then table.insert(newList, p) end
    end
    if #newList == 0 then
        stopSpectate(); stopPlayerTimer(); hideSpectateEffects()
        nameLbl.Text = "⚠️ لا يوجد لاعبون"; idx=0; liveStartTime=0
        showToast("👋","غادر اللاعب",removedPlayer.Name.." غادر",Color3.fromRGB(255,180,50),2)
    else
        if idx > #newList then idx = 1 end
        spectating = true
    end
end)

lp.CharacterAdded:Connect(function()
    task.wait(0.5)
    if isVerified then startMainLoop() end
end)
