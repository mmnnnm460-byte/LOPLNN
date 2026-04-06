-- ╔══════════════════════════════════════════════════════╗
-- ║        Spectate Camera PRO - Enhanced V2             ║
-- ║        Code: 12717375127                             ║
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
local old = pg:FindFirstChild("SpectatePRO")
if old then old:Destroy() end

-- ══════════════════════════════════════
-- متغيرات
-- ══════════════════════════════════════
local idx           = 0
local guiVisible    = true
local isVerified    = false
local spectating    = false
local REQUIRED_CODE = "12717375127"
local scriptHidden  = false

-- ألوان
local C_BLUE1  = Color3.fromRGB(60,  160, 255)
local C_BLUE2  = Color3.fromRGB(30,  100, 220)
local C_WHITE  = Color3.fromRGB(255, 255, 255)
local C_DARK   = Color3.fromRGB(5,   15,  40)
local C_CYAN   = Color3.fromRGB(100, 220, 255)
local C_GREEN  = Color3.fromRGB(60,  220, 120)
local C_ACCENT = Color3.fromRGB(0,   200, 255)

-- ══════════════════════════════════════
-- 🔊 صوت النقر
-- ══════════════════════════════════════
local clickSound              = Instance.new("Sound")
clickSound.SoundId            = "rbxassetid://6895079853"
clickSound.Volume             = 0.7
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
gui.Name           = "SpectatePRO"
gui.ResetOnSpawn   = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent         = pg

-- ════════════════════════════════════════════════════════
-- 🔐 شاشة الكود - تصميم احترافي جديد كلياً
-- ════════════════════════════════════════════════════════
local codeOverlay            = Instance.new("Frame")
codeOverlay.Size             = UDim2.fromScale(1, 1)
codeOverlay.Position         = UDim2.fromScale(0, 0)
codeOverlay.BackgroundColor3 = Color3.fromRGB(0, 5, 20)
codeOverlay.BackgroundTransparency = 0.15
codeOverlay.BorderSizePixel  = 0
codeOverlay.ZIndex           = 50
codeOverlay.Parent           = gui

-- خلفية ضبابية متحركة (نجوم)
for i = 1, 30 do
    local star                  = Instance.new("Frame", codeOverlay)
    star.Size                   = UDim2.fromOffset(math.random(1,3), math.random(1,3))
    star.Position               = UDim2.fromScale(math.random()/1, math.random()/1)
    star.BackgroundColor3       = C_CYAN
    star.BackgroundTransparency = math.random(50,90)/100
    star.BorderSizePixel        = 0
    star.ZIndex                 = 51
    Instance.new("UICorner", star).CornerRadius = UDim.new(1,0)
    -- وميض النجوم
    local function blinkStar()
        while star.Parent do
            TweenService:Create(star, TweenInfo.new(math.random(10,30)/10, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {BackgroundTransparency = math.random(20,85)/100}):Play()
            task.wait(math.random(10,30)/10)
        end
    end
    task.spawn(blinkStar)
end

-- الإطار الرئيسي للكود
local codeFrame            = Instance.new("Frame")
codeFrame.Size             = UDim2.fromOffset(400, 280)
codeFrame.AnchorPoint      = Vector2.new(0.5, 0.5)
codeFrame.Position         = UDim2.fromScale(0.5, 0.5)
codeFrame.BackgroundColor3 = Color3.fromRGB(4, 12, 35)
codeFrame.BorderSizePixel  = 0
codeFrame.ZIndex           = 52
codeFrame.Parent           = codeOverlay
Instance.new("UICorner", codeFrame).CornerRadius = UDim.new(0, 20)

-- حدود متوهجة خارجية
local outerGlow            = Instance.new("Frame")
outerGlow.Size             = UDim2.new(1, 8, 1, 8)
outerGlow.Position         = UDim2.fromOffset(-4, -4)
outerGlow.BackgroundColor3 = C_BLUE1
outerGlow.BackgroundTransparency = 0.7
outerGlow.BorderSizePixel  = 0
outerGlow.ZIndex           = 51
outerGlow.Parent           = codeFrame
Instance.new("UICorner", outerGlow).CornerRadius = UDim.new(0, 24)

local codeStroke           = Instance.new("UIStroke", codeFrame)
codeStroke.Thickness       = 2
codeStroke.Color           = C_BLUE1

-- شريط علوي ملون
local topBar               = Instance.new("Frame")
topBar.Size                = UDim2.new(1, 0, 0, 5)
topBar.Position            = UDim2.fromScale(0, 0)
topBar.BackgroundColor3    = C_BLUE1
topBar.BorderSizePixel     = 0
topBar.ZIndex              = 53
topBar.Parent              = codeFrame
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 20)

local topBarGrad           = Instance.new("UIGradient", topBar)
topBarGrad.Color           = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(0, 100, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 220, 255)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(0, 100, 255))
}

-- أيقونة قفل كبيرة
local lockIcon                  = Instance.new("TextLabel")
lockIcon.Size                   = UDim2.fromOffset(64, 64)
lockIcon.AnchorPoint            = Vector2.new(0.5, 0)
lockIcon.Position               = UDim2.new(0.5, 0, 0, 22)
lockIcon.BackgroundTransparency = 1
lockIcon.Text                   = "🔐"
lockIcon.TextScaled             = true
lockIcon.Font                   = Enum.Font.GothamBold
lockIcon.ZIndex                 = 53
lockIcon.Parent                 = codeFrame

-- عنوان
local codeTitle                  = Instance.new("TextLabel")
codeTitle.Size                   = UDim2.new(1, -20, 0, 30)
codeTitle.Position               = UDim2.fromOffset(10, 96)
codeTitle.BackgroundTransparency = 1
codeTitle.TextScaled             = true
codeTitle.Text                   = "أدخل كود الدخول"
codeTitle.Font                   = Enum.Font.GothamBold
codeTitle.TextColor3             = C_WHITE
codeTitle.ZIndex                 = 53
codeTitle.Parent                 = codeFrame

-- خط فاصل متوهج
local divider            = Instance.new("Frame")
divider.Size             = UDim2.new(0.7, 0, 0, 1)
divider.AnchorPoint      = Vector2.new(0.5, 0)
divider.Position         = UDim2.new(0.5, 0, 0, 132)
divider.BackgroundColor3 = C_BLUE1
divider.BackgroundTransparency = 0.5
divider.BorderSizePixel  = 0
divider.ZIndex           = 53
divider.Parent           = codeFrame

-- حقل إدخال الكود
local codeBoxBg            = Instance.new("Frame")
codeBoxBg.Size             = UDim2.new(0.82, 0, 0, 46)
codeBoxBg.AnchorPoint      = Vector2.new(0.5, 0)
codeBoxBg.Position         = UDim2.new(0.5, 0, 0, 144)
codeBoxBg.BackgroundColor3 = Color3.fromRGB(8, 22, 60)
codeBoxBg.BorderSizePixel  = 0
codeBoxBg.ZIndex           = 53
codeBoxBg.Parent           = codeFrame
Instance.new("UICorner", codeBoxBg).CornerRadius = UDim.new(0, 12)
local boxStroke = Instance.new("UIStroke", codeBoxBg)
boxStroke.Thickness = 1.5
boxStroke.Color     = C_BLUE1
boxStroke.Transparency = 0.4

-- أيقونة مفتاح داخل الحقل
local keyIcon                  = Instance.new("TextLabel")
keyIcon.Size                   = UDim2.fromOffset(30, 30)
keyIcon.Position               = UDim2.fromOffset(10, 8)
keyIcon.BackgroundTransparency = 1
keyIcon.Text                   = "🗝️"
keyIcon.TextScaled             = true
keyIcon.Font                   = Enum.Font.GothamBold
keyIcon.ZIndex                 = 54
keyIcon.Parent                 = codeBoxBg

local codeBox            = Instance.new("TextBox", codeBoxBg)
codeBox.Size             = UDim2.new(1, -48, 1, -10)
codeBox.Position         = UDim2.fromOffset(42, 5)
codeBox.BackgroundTransparency = 1
codeBox.TextScaled       = false
codeBox.TextSize         = 17
codeBox.PlaceholderText  = "أدخل الكود هنا..."
codeBox.PlaceholderColor3 = Color3.fromRGB(80, 120, 200)
codeBox.Text             = ""
codeBox.Font             = Enum.Font.GothamSemibold
codeBox.TextColor3       = C_WHITE
codeBox.TextXAlignment   = Enum.TextXAlignment.Right
codeBox.BorderSizePixel  = 0
codeBox.ZIndex           = 54

-- تأثير focus على الحقل
codeBox.Focused:Connect(function()
    TweenService:Create(boxStroke, TweenInfo.new(0.2), {Transparency=0, Color=C_CYAN}):Play()
    TweenService:Create(codeBoxBg, TweenInfo.new(0.2), {BackgroundColor3=Color3.fromRGB(12,35,90)}):Play()
end)
codeBox.FocusLost:Connect(function()
    TweenService:Create(boxStroke, TweenInfo.new(0.2), {Transparency=0.4, Color=C_BLUE1}):Play()
    TweenService:Create(codeBoxBg, TweenInfo.new(0.2), {BackgroundColor3=Color3.fromRGB(8,22,60)}):Play()
end)

-- زر الدخول احترافي
local confirmBtn            = Instance.new("TextButton")
confirmBtn.Size             = UDim2.new(0.82, 0, 0, 46)
confirmBtn.AnchorPoint      = Vector2.new(0.5, 0)
confirmBtn.Position         = UDim2.new(0.5, 0, 0, 202)
confirmBtn.BackgroundColor3 = C_BLUE1
confirmBtn.TextColor3       = C_WHITE
confirmBtn.Text             = "دخول  ✅"
confirmBtn.TextSize         = 17
confirmBtn.Font             = Enum.Font.GothamBold
confirmBtn.BorderSizePixel  = 0
confirmBtn.ZIndex           = 53
confirmBtn.Parent           = codeFrame
Instance.new("UICorner", confirmBtn).CornerRadius = UDim.new(0, 12)

local btnGrad              = Instance.new("UIGradient", confirmBtn)
btnGrad.Color              = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(30, 120, 255)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(0,  80,  200))
}
btnGrad.Rotation = 90

confirmBtn.MouseEnter:Connect(function()
    TweenService:Create(confirmBtn, TweenInfo.new(0.15), {BackgroundColor3=Color3.fromRGB(80,180,255)}):Play()
end)
confirmBtn.MouseLeave:Connect(function()
    TweenService:Create(confirmBtn, TweenInfo.new(0.15), {BackgroundColor3=C_BLUE1}):Play()
end)

local codeErrLbl                  = Instance.new("TextLabel")
codeErrLbl.Size                   = UDim2.new(1, 0, 0, 20)
codeErrLbl.Position               = UDim2.new(0, 0, 1, -26)
codeErrLbl.BackgroundTransparency = 1
codeErrLbl.TextScaled             = true
codeErrLbl.Text                   = ""
codeErrLbl.Font                   = Enum.Font.Gotham
codeErrLbl.TextColor3             = Color3.fromRGB(255, 80, 80)
codeErrLbl.ZIndex                 = 53
codeErrLbl.Parent                 = codeFrame

-- تأثير وميض للإطار (نبضة)
task.spawn(function()
    while codeOverlay.Parent do
        TweenService:Create(codeStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Color = C_CYAN}):Play()
        task.wait(1.5)
        TweenService:Create(codeStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Color = C_BLUE2}):Play()
        task.wait(1.5)
    end
end)

-- ══════════════════════════════════════
-- 🔔 دالة الإشعارات (Toast)
-- ══════════════════════════════════════
local function showToast(icon, titleText, bodyText, accentColor, duration, onDone)
    local toast            = Instance.new("Frame")
    toast.Size             = UDim2.fromOffset(290, 76)
    toast.AnchorPoint      = Vector2.new(0.5, 0)
    toast.Position         = UDim2.new(0.5, 0, 0, -96)
    toast.BackgroundColor3 = Color3.fromRGB(6, 16, 45)
    toast.BorderSizePixel  = 0
    toast.ZIndex           = 70
    toast.Parent           = gui
    Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 14)

    local toastStroke      = Instance.new("UIStroke", toast)
    toastStroke.Thickness  = 2
    toastStroke.Color      = accentColor

    local bar              = Instance.new("Frame", toast)
    bar.Size               = UDim2.new(1, 0, 0, 4)
    bar.Position           = UDim2.fromScale(0, 0)
    bar.BackgroundColor3   = accentColor
    bar.BorderSizePixel    = 0
    bar.ZIndex             = 71
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 14)

    local iconLbl                  = Instance.new("TextLabel", toast)
    iconLbl.Size                   = UDim2.fromOffset(40, 40)
    iconLbl.Position               = UDim2.fromOffset(12, 18)
    iconLbl.BackgroundTransparency = 1
    iconLbl.TextScaled             = true
    iconLbl.Text                   = icon
    iconLbl.Font                   = Enum.Font.GothamBold
    iconLbl.TextColor3             = accentColor
    iconLbl.ZIndex                 = 71

    local titleLbl                  = Instance.new("TextLabel", toast)
    titleLbl.Size                   = UDim2.new(1, -60, 0, 26)
    titleLbl.Position               = UDim2.fromOffset(54, 12)
    titleLbl.BackgroundTransparency = 1
    titleLbl.TextScaled             = true
    titleLbl.Text                   = titleText
    titleLbl.Font                   = Enum.Font.GothamBold
    titleLbl.TextColor3             = C_WHITE
    titleLbl.TextXAlignment         = Enum.TextXAlignment.Left
    titleLbl.ZIndex                 = 71

    local bodyLbl                  = Instance.new("TextLabel", toast)
    bodyLbl.Size                   = UDim2.new(1, -60, 0, 22)
    bodyLbl.Position               = UDim2.fromOffset(54, 38)
    bodyLbl.BackgroundTransparency = 1
    bodyLbl.TextScaled             = true
    bodyLbl.Text                   = bodyText
    bodyLbl.Font                   = Enum.Font.Gotham
    bodyLbl.TextColor3             = Color3.fromRGB(160, 200, 255)
    bodyLbl.TextXAlignment         = Enum.TextXAlignment.Left
    bodyLbl.ZIndex                 = 71

    local progressBg               = Instance.new("Frame", toast)
    progressBg.Size                = UDim2.new(1, -20, 0, 3)
    progressBg.Position            = UDim2.new(0, 10, 1, -8)
    progressBg.BackgroundColor3    = Color3.fromRGB(20, 40, 90)
    progressBg.BorderSizePixel     = 0
    progressBg.ZIndex              = 71
    Instance.new("UICorner", progressBg).CornerRadius = UDim.new(1, 0)

    local progressBar              = Instance.new("Frame", progressBg)
    progressBar.Size               = UDim2.fromScale(1, 1)
    progressBar.BackgroundColor3   = accentColor
    progressBar.BorderSizePixel    = 0
    progressBar.ZIndex             = 72
    Instance.new("UICorner", progressBar).CornerRadius = UDim.new(1, 0)

    TweenService:Create(toast,
        TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, 0, 0, 14)}):Play()

    TweenService:Create(progressBar,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        {Size = UDim2.fromScale(0, 1)}):Play()

    task.spawn(function()
        local remaining = duration
        while remaining > 0 and toast.Parent do
            if bodyText:find("%%d") then
                bodyLbl.Text = bodyText:format(math.ceil(remaining))
            end
            task.wait(0.1)
            remaining = remaining - 0.1
        end
    end)

    task.delay(duration, function()
        if not toast.Parent then return end
        TweenService:Create(toast,
            TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {Position = UDim2.new(0.5, 0, 0, -96), BackgroundTransparency = 1}):Play()
        task.delay(0.4, function()
            if toast.Parent then toast:Destroy() end
            if onDone then onDone() end
        end)
    end)
end

-- ══════════════════════════════════════
-- المحتوى الرئيسي - FULLSCREEN
-- ══════════════════════════════════════
local mainContent                  = Instance.new("Frame")
mainContent.Size                   = UDim2.fromScale(1, 1)
mainContent.Position               = UDim2.fromScale(0, 0)
mainContent.BackgroundTransparency = 1
mainContent.Visible                = false
mainContent.Parent                 = gui

-- ════════════════════════════════════════════════════
-- 🎬 شاشة LIVE - تملأ الشاشة كاملة مع تفاصيل
-- ════════════════════════════════════════════════════
local liveScreen                  = Instance.new("Frame")
liveScreen.Size                   = UDim2.fromScale(1, 1)
liveScreen.Position               = UDim2.fromScale(0, 0)
liveScreen.BackgroundTransparency = 1
liveScreen.BorderSizePixel        = 0
liveScreen.ZIndex                 = 2
liveScreen.Visible                = false
liveScreen.Parent                 = gui

-- إطار كامل حول الشاشة (border LIVE)
local liveBorder                  = Instance.new("Frame")
liveBorder.Size                   = UDim2.new(1, -8, 1, -8)
liveBorder.Position               = UDim2.fromOffset(4, 4)
liveBorder.BackgroundTransparency = 1
liveBorder.BorderSizePixel        = 0
liveBorder.ZIndex                 = 3
liveBorder.Parent                 = liveScreen
local liveBorderStroke            = Instance.new("UIStroke", liveBorder)
liveBorderStroke.Thickness        = 2.5
liveBorderStroke.Color            = C_CYAN
liveBorderStroke.Transparency     = 0.5
Instance.new("UICorner", liveBorder).CornerRadius = UDim.new(0, 10)

-- vignette أطراف الشاشة
local vignette                  = Instance.new("Frame")
vignette.Size                   = UDim2.fromScale(1, 1)
vignette.BackgroundTransparency = 1
vignette.BorderSizePixel        = 0
vignette.ZIndex                 = 2
vignette.Parent                 = liveScreen

local function makeEdge(ancX, ancY, sX, sY, posX, posY, rot)
    local e                  = Instance.new("Frame")
    e.AnchorPoint            = Vector2.new(ancX, ancY)
    e.Size                   = UDim2.fromScale(sX, sY)
    e.Position               = UDim2.fromScale(posX, posY)
    e.BackgroundColor3       = Color3.fromRGB(0, 5, 20)
    e.BackgroundTransparency = 0.35
    e.BorderSizePixel        = 0
    e.ZIndex                 = 2
    e.Parent                 = vignette
    local g = Instance.new("UIGradient", e)
    g.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    }
    g.Rotation = rot
end
makeEdge(0,0, 1,0.18, 0,0,   90)
makeEdge(0,1, 1,0.18, 0,1,  270)
makeEdge(0,0, 0.12,1, 0,0,    0)
makeEdge(1,0, 0.12,1, 1,0,  180)

-- شريط علوي للـ LIVE (الكامل)
local topHUD                  = Instance.new("Frame")
topHUD.Size                   = UDim2.new(1, 0, 0, 52)
topHUD.Position               = UDim2.fromScale(0, 0)
topHUD.BackgroundColor3       = Color3.fromRGB(0, 5, 20)
topHUD.BackgroundTransparency = 0.3
topHUD.BorderSizePixel        = 0
topHUD.ZIndex                 = 5
topHUD.Parent                 = liveScreen
local topHUDGrad              = Instance.new("UIGradient", topHUD)
topHUDGrad.Transparency       = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(1, 1)
}
topHUDGrad.Rotation = 90

-- نقطة LIVE حمراء وامضة
local liveDot                  = Instance.new("Frame")
liveDot.Size                   = UDim2.fromOffset(12, 12)
liveDot.Position               = UDim2.fromOffset(16, 20)
liveDot.AnchorPoint            = Vector2.new(0, 0.5)
liveDot.BackgroundColor3       = Color3.fromRGB(255, 60, 60)
liveDot.BorderSizePixel        = 0
liveDot.ZIndex                 = 6
liveDot.Parent                 = topHUD
Instance.new("UICorner", liveDot).CornerRadius = UDim.new(1,0)

-- وميض نقطة LIVE
task.spawn(function()
    while liveDot.Parent do
        TweenService:Create(liveDot, TweenInfo.new(0.5, Enum.EasingStyle.Sine),
            {BackgroundTransparency=0.7}):Play()
        task.wait(0.5)
        TweenService:Create(liveDot, TweenInfo.new(0.5, Enum.EasingStyle.Sine),
            {BackgroundTransparency=0}):Play()
        task.wait(0.5)
    end
end)

-- نص LIVE
local liveTxt                  = Instance.new("TextLabel")
liveTxt.Size                   = UDim2.fromOffset(50, 22)
liveTxt.Position               = UDim2.fromOffset(34, 9)
liveTxt.BackgroundTransparency = 1
liveTxt.Text                   = "LIVE"
liveTxt.TextSize               = 16
liveTxt.Font                   = Enum.Font.GothamBold
liveTxt.TextColor3             = Color3.fromRGB(255,60,60)
liveTxt.ZIndex                 = 6
liveTxt.Parent                 = topHUD

-- اسم اللاعب المراقَب في الشريط العلوي (MAIN)
local spectateLabel                  = Instance.new("TextLabel")
spectateLabel.Size                   = UDim2.new(0.5, 0, 0, 36)
spectateLabel.AnchorPoint            = Vector2.new(0.5, 0)
spectateLabel.Position               = UDim2.new(0.5, 0, 0, 8)
spectateLabel.BackgroundTransparency = 1
spectateLabel.TextScaled             = true
spectateLabel.Text                   = ""
spectateLabel.Font                   = Enum.Font.GothamBold
spectateLabel.TextColor3             = C_WHITE
spectateLabel.ZIndex                 = 6
spectateLabel.Parent                 = topHUD

-- نقاط زوايا الشاشة (تأثير كاميرا)
local cornerSize = 18
local cornerThick = 2.5
local function makeScreenCorner(ax, ay, px, py, rh, rv)
    -- أفقي
    local h            = Instance.new("Frame")
    h.Size             = UDim2.fromOffset(cornerSize, cornerThick)
    h.AnchorPoint      = Vector2.new(ax, ay)
    h.Position         = UDim2.fromScale(px, py)
    h.BackgroundColor3 = C_CYAN
    h.BorderSizePixel  = 0
    h.ZIndex           = 4
    h.Parent           = liveScreen
    -- عمودي
    local v            = Instance.new("Frame")
    v.Size             = UDim2.fromOffset(cornerThick, cornerSize)
    v.AnchorPoint      = Vector2.new(ax, ay)
    v.Position         = UDim2.fromScale(px, py)
    v.BackgroundColor3 = C_CYAN
    v.BorderSizePixel  = 0
    v.ZIndex           = 4
    v.Parent           = liveScreen
end
makeScreenCorner(0,0, 0.01,0.01)
makeScreenCorner(1,0, 0.99,0.01)
makeScreenCorner(0,1, 0.01,0.99)
makeScreenCorner(1,1, 0.99,0.99)

-- شريط مسح متحرك
local scanOverlay                   = Instance.new("Frame")
scanOverlay.Size                    = UDim2.new(1, 0, 0, 2)
scanOverlay.BackgroundColor3        = C_CYAN
scanOverlay.BackgroundTransparency  = 0.80
scanOverlay.BorderSizePixel         = 0
scanOverlay.ZIndex                  = 3
scanOverlay.Parent                  = liveScreen

-- معلومات إضافية - أسفل اليسار (كاميرا info)
local camInfoFrame                  = Instance.new("Frame")
camInfoFrame.Size                   = UDim2.fromOffset(180, 50)
camInfoFrame.Position               = UDim2.new(0, 10, 1, -65)
camInfoFrame.BackgroundColor3       = Color3.fromRGB(0, 5, 20)
camInfoFrame.BackgroundTransparency = 0.4
camInfoFrame.BorderSizePixel        = 0
camInfoFrame.ZIndex                 = 5
camInfoFrame.Parent                 = liveScreen
Instance.new("UICorner", camInfoFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", camInfoFrame).Color        = C_BLUE1

local camInfoTxt                  = Instance.new("TextLabel", camInfoFrame)
camInfoTxt.Size                   = UDim2.fromScale(1, 1)
camInfoTxt.BackgroundTransparency = 1
camInfoTxt.TextScaled             = true
camInfoTxt.Text                   = "📷 CAM-01  |  AUTO TRACK"
camInfoTxt.Font                   = Enum.Font.GothamBold
camInfoTxt.TextColor3             = C_CYAN
camInfoTxt.ZIndex                 = 6

-- عداد الوقت المباشر (أعلى اليمين)
local timerLbl                  = Instance.new("TextLabel")
timerLbl.Size                   = UDim2.fromOffset(110, 28)
timerLbl.AnchorPoint            = Vector2.new(1, 0)
timerLbl.Position               = UDim2.new(1, -12, 0, 12)
timerLbl.BackgroundColor3       = Color3.fromRGB(0, 5, 20)
timerLbl.BackgroundTransparency = 0.4
timerLbl.BorderSizePixel        = 0
timerLbl.TextScaled             = true
timerLbl.Text                   = "00:00:00"
timerLbl.Font                   = Enum.Font.GothamBold
timerLbl.TextColor3             = C_GREEN
timerLbl.ZIndex                 = 6
timerLbl.Parent                 = liveScreen
Instance.new("UICorner", timerLbl).CornerRadius = UDim.new(0, 6)

-- تحديث العداد
local liveStartTime = 0
task.spawn(function()
    while timerLbl.Parent do
        if spectating and liveStartTime > 0 then
            local elapsed = math.floor(tick() - liveStartTime)
            local h = math.floor(elapsed/3600)
            local m = math.floor((elapsed%3600)/60)
            local s = elapsed%60
            timerLbl.Text = string.format("%02d:%02d:%02d", h, m, s)
        end
        task.wait(1)
    end
end)

-- ══════════════════════════════════════
-- 🔒 زر الإخفاء القابل للسحب (زاوية)
-- ══════════════════════════════════════
local hideBtn            = Instance.new("TextButton")
hideBtn.Size             = UDim2.fromOffset(52, 52)
hideBtn.Position         = UDim2.new(1, -62, 0, 10)
hideBtn.AnchorPoint      = Vector2.new(0, 0)
hideBtn.BackgroundColor3 = Color3.fromRGB(6, 18, 55)
hideBtn.TextColor3       = C_WHITE
hideBtn.Text             = "👁"
hideBtn.TextScaled       = true
hideBtn.Font             = Enum.Font.GothamBold
hideBtn.BorderSizePixel  = 0
hideBtn.ZIndex           = 80
hideBtn.Parent           = gui
Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(0, 14)
local hideBtnStroke      = Instance.new("UIStroke", hideBtn)
hideBtnStroke.Thickness  = 2
hideBtnStroke.Color      = C_BLUE1

-- تأثير وميض الزر
task.spawn(function()
    while hideBtn.Parent do
        TweenService:Create(hideBtnStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Color=C_CYAN, Transparency=0.2}):Play()
        task.wait(1.2)
        TweenService:Create(hideBtnStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Color=C_BLUE1, Transparency=0}):Play()
        task.wait(1.2)
    end
end)

-- ══════════════════════════════════════
-- جعل الزر قابلاً للسحب
-- ══════════════════════════════════════
local dragging   = false
local dragStart  = nil
local startPos   = nil

hideBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging  = true
        dragStart = input.Position
        startPos  = hideBtn.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local vp    = cam.ViewportSize
        local nx    = math.clamp((startPos.X.Offset + delta.X) / vp.X, 0, 1 - 52/vp.X)
        local ny    = math.clamp((startPos.Y.Offset + delta.Y) / vp.Y, 0, 1 - 52/vp.Y)
        hideBtn.Position = UDim2.fromScale(nx, ny)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- وظيفة الإخفاء
hideBtn.MouseButton1Click:Connect(function()
    clickSound:Play()
    scriptHidden = not scriptHidden
    if scriptHidden then
        -- إخفاء السكربت
        TweenService:Create(mainContent, TweenInfo.new(0.3, Enum.EasingStyle.Quad),
            {BackgroundTransparency=1}):Play()
        mainContent.Visible = false
        liveScreen.Visible  = false
        hideBtn.Text        = "🙈"
        hideBtn.BackgroundColor3 = Color3.fromRGB(40, 8, 8)
        showToast("🙈", "تم الإخفاء", "اضغط 👁 لإظهار السكربت", Color3.fromRGB(200,80,80), 2)
    else
        -- إظهار السكربت
        mainContent.Visible = true
        if spectating then liveScreen.Visible = true end
        TweenService:Create(mainContent, TweenInfo.new(0.3, Enum.EasingStyle.Quad),
            {BackgroundTransparency=1}):Play()
        hideBtn.Text = "👁"
        hideBtn.BackgroundColor3 = Color3.fromRGB(6, 18, 55)
        showToast("👁", "تم الإظهار", "السكربت نشط الآن", C_GREEN, 2)
    end
end)

-- ══════════════════════════════════════
-- إعدادات الأيقونة
-- ══════════════════════════════════════
local ICON_SIZE = 44
local ICON_X    = 0.025
local ICON_Y    = 0.40

-- ══════════════════════════════════════
-- حلقات الضوء
-- ══════════════════════════════════════
local function makeRing(size, alpha, zidx)
    local r                  = Instance.new("Frame")
    r.Size                   = UDim2.fromOffset(size, size)
    r.AnchorPoint            = Vector2.new(0.5, 0.5)
    r.BackgroundTransparency = 1
    r.ZIndex                 = zidx or 3
    r.BorderSizePixel        = 0
    r.Parent                 = mainContent
    Instance.new("UICorner", r).CornerRadius = UDim.new(1, 0)
    local s       = Instance.new("UIStroke", r)
    s.Thickness   = 1.5
    s.Color       = C_BLUE1
    s.Transparency = alpha or 0.4
    return r, s
end

local ring1, ring1S = makeRing(60, 0.3, 3)
local ring2, ring2S = makeRing(78, 0.5, 2)
local ring3, ring3S = makeRing(96, 0.7, 1)

local NUM_DOTS = 8
local dots = {}
for i = 1, NUM_DOTS do
    local dot            = Instance.new("Frame")
    dot.Size             = UDim2.fromOffset(5,5)
    dot.AnchorPoint      = Vector2.new(0.5,0.5)
    dot.BackgroundColor3 = (i%2==0) and C_WHITE or C_BLUE1
    dot.BorderSizePixel  = 0
    dot.ZIndex           = 4
    dot.Parent           = mainContent
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
    table.insert(dots, dot)
end

local particles = {}
for i = 1, 5 do
    local p                  = Instance.new("Frame")
    p.Size                   = UDim2.fromOffset(3,3)
    p.AnchorPoint            = Vector2.new(0.5,0.5)
    p.BackgroundColor3       = C_CYAN
    p.BorderSizePixel        = 0
    p.ZIndex                 = 4
    p.BackgroundTransparency = 0.3
    p.Parent                 = mainContent
    Instance.new("UICorner", p).CornerRadius = UDim.new(1,0)
    table.insert(particles, p)
end

-- ══════════════════════════════════════
-- 🪶 الجناح
-- ══════════════════════════════════════
local function makeWingPart(z)
    local f                  = Instance.new("Frame")
    f.BackgroundTransparency = 1
    f.BorderSizePixel        = 0
    f.ZIndex                 = z
    f.Parent                 = mainContent
    local s = Instance.new("UIStroke", f)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0.5, 0)
    return f, s
end
local featherL, featherLS = makeWingPart(3)
local featherR, featherRS = makeWingPart(3)
local innerL,   innerLS   = makeWingPart(3)
local innerR,   innerRS   = makeWingPart(3)
featherLS.Thickness = 2.2; featherRS.Thickness = 2.2
innerLS.Thickness   = 1.5; innerRS.Thickness   = 1.5

-- ══════════════════════════════════════
-- 🎯 الأيقونة 44×44
-- ══════════════════════════════════════
local iconFrame              = Instance.new("Frame")
iconFrame.Size               = UDim2.fromOffset(ICON_SIZE, ICON_SIZE)
iconFrame.Position           = UDim2.new(ICON_X, 0, ICON_Y, -ICON_SIZE/2)
iconFrame.BackgroundColor3   = Color3.fromRGB(140, 210, 255)
iconFrame.BorderSizePixel    = 0
iconFrame.ZIndex             = 6
iconFrame.ClipsDescendants   = true
iconFrame.Parent             = mainContent
Instance.new("UICorner", iconFrame).CornerRadius = UDim.new(0, 10)

local iconStroke             = Instance.new("UIStroke", iconFrame)
iconStroke.Thickness         = 2
iconStroke.Color             = C_BLUE1

local iconGrad               = Instance.new("UIGradient", iconFrame)
iconGrad.Color               = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(100, 190, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 225, 255)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 255, 255))
}
iconGrad.Rotation = 135

local shimmer                  = Instance.new("Frame", iconFrame)
shimmer.Size                   = UDim2.fromScale(0.55, 0.55)
shimmer.Position               = UDim2.fromScale(0.22, 0.15)
shimmer.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
shimmer.BackgroundTransparency = 0.55
shimmer.BorderSizePixel        = 0
shimmer.ZIndex                 = 7
Instance.new("UICorner", shimmer).CornerRadius = UDim.new(1, 0)

local scanLineIcon               = Instance.new("Frame", iconFrame)
scanLineIcon.Size                = UDim2.fromOffset(ICON_SIZE, 2)
scanLineIcon.BackgroundColor3    = C_CYAN
scanLineIcon.BackgroundTransparency = 0.4
scanLineIcon.BorderSizePixel     = 0
scanLineIcon.ZIndex              = 8

-- خطوط زوايا الأيقونة
local CORNER_LEN   = 9
local CORNER_THICK = 2
local CORNER_GAP   = 5
local cornerLines  = {}
local function makeCLine(isH)
    local l            = Instance.new("Frame")
    l.BackgroundColor3 = C_WHITE
    l.BorderSizePixel  = 0
    l.ZIndex           = 9
    l.Parent           = mainContent
    l.Size = isH and UDim2.fromOffset(CORNER_LEN, CORNER_THICK)
                  or  UDim2.fromOffset(CORNER_THICK, CORNER_LEN)
    table.insert(cornerLines, l)
    return l
end
local tlH=makeCLine(true);  local tlV=makeCLine(false)
local trH=makeCLine(true);  local trV=makeCLine(false)
local blH=makeCLine(true);  local blV=makeCLine(false)
local brH=makeCLine(true);  local brV=makeCLine(false)

local function updateCorners(cx, cy, sz, col)
    local h, g = sz/2, CORNER_GAP
    tlH.Position = UDim2.fromOffset(cx-h-g-CORNER_LEN,   cy-h-g-CORNER_THICK)
    tlV.Position = UDim2.fromOffset(cx-h-g-CORNER_THICK,  cy-h-g-CORNER_LEN)
    trH.Position = UDim2.fromOffset(cx+h+g,               cy-h-g-CORNER_THICK)
    trV.Position = UDim2.fromOffset(cx+h+g,               cy-h-g-CORNER_LEN)
    blH.Position = UDim2.fromOffset(cx-h-g-CORNER_LEN,   cy+h+g)
    blV.Position = UDim2.fromOffset(cx-h-g-CORNER_THICK,  cy+h+g)
    brH.Position = UDim2.fromOffset(cx+h+g,               cy+h+g)
    brV.Position = UDim2.fromOffset(cx+h+g,               cy+h+g)
    for _, l in ipairs(cornerLines) do l.BackgroundColor3 = col end
end

-- ════════════════════════════════════════════════════════
-- أزرار التنقل — وسط الشاشة أسفل
-- ════════════════════════════════════════════════════════
local function makeBtn(txt, x, y, sX, sY)
    local b            = Instance.new("TextButton")
    b.Size             = UDim2.fromScale(sX or 0.12, sY or 0.07)
    b.Position         = UDim2.fromScale(x, y)
    b.AnchorPoint      = Vector2.new(0.5, 0.5)
    b.Text             = txt
    b.TextScaled       = true
    b.BackgroundColor3 = C_BLUE2
    b.TextColor3       = C_WHITE
    b.Font             = Enum.Font.GothamBold
    b.BorderSizePixel  = 0
    b.ZIndex           = 5
    b.Parent           = mainContent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    local s = Instance.new("UIStroke", b)
    s.Thickness = 1.8; s.Color = C_BLUE1
    return b
end

local prev = makeBtn("◀", 0.35, 0.88)
local nxt  = makeBtn("▶", 0.65, 0.88)

-- اسم اللاعب المراقَب (واجهة رئيسية)
local nameLbl                  = Instance.new("TextLabel")
nameLbl.Size                   = UDim2.fromScale(0.30, 0.06)
nameLbl.Position               = UDim2.fromScale(0.5, 0.82)
nameLbl.AnchorPoint            = Vector2.new(0.5, 0.5)
nameLbl.BackgroundTransparency = 1
nameLbl.TextScaled             = true
nameLbl.Text                   = "اختر لاعب  ◀ ▶"
nameLbl.Font                   = Enum.Font.GothamSemibold
nameLbl.TextColor3             = C_WHITE
nameLbl.ZIndex                 = 5
nameLbl.Parent                 = mainContent

-- ════════════════════════════════════════════════════════
-- 🚀 زر انتقال للاعب (تحت اسم اللاعب)
-- يشتغل لجميع اللاعبين
-- ════════════════════════════════════════════════════════
local tpBtn            = Instance.new("TextButton")
tpBtn.Size             = UDim2.fromScale(0.26, 0.055)
tpBtn.Position         = UDim2.fromScale(0.5, 0.89)
tpBtn.AnchorPoint      = Vector2.new(0.5, 0.5)
tpBtn.Text             = "🚀 انتقل للاعب"
tpBtn.TextScaled       = true
tpBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 80)
tpBtn.TextColor3       = C_WHITE
tpBtn.Font             = Enum.Font.GothamBold
tpBtn.BorderSizePixel  = 0
tpBtn.ZIndex           = 5
tpBtn.Parent           = mainContent
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 10)
local tpStroke = Instance.new("UIStroke", tpBtn)
tpStroke.Thickness = 1.8
tpStroke.Color     = C_GREEN

-- وميض زر الانتقال
task.spawn(function()
    while tpBtn.Parent do
        TweenService:Create(tpStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Color=Color3.fromRGB(100,255,150), Transparency=0.3}):Play()
        task.wait(1)
        TweenService:Create(tpStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Color=C_GREEN, Transparency=0}):Play()
        task.wait(1)
    end
end)

tpBtn.MouseButton1Click:Connect(function()
    if idx == 0 then
        showToast("⚠️", "لم تختر لاعب", "اختر لاعباً أولاً بـ ◀ ▶", Color3.fromRGB(255,200,50), 2)
        return
    end
    local list   = getPlayers()
    if #list == 0 then
        showToast("⚠️", "لا يوجد لاعبون", "السيرفر فارغ", Color3.fromRGB(255,80,80), 2)
        return
    end
    if idx > #list then idx = 1 end
    local target = list[idx]
    if not target then return end

    -- الانتقال لجميع اللاعبين: نحاول نقل الشخصية
    local function tryTeleport()
        local myChar = lp.Character
        if not myChar then return false end
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return false end
        local tChar  = target.Character
        if not tChar then return false end
        local tRoot  = tChar:FindFirstChild("HumanoidRootPart")
        if not tRoot then return false end
        myRoot.CFrame = tRoot.CFrame + Vector3.new(0, 4, 0)
        return true
    end

    clickSound:Play()
    -- تأثير الزر
    TweenService:Create(tpBtn, TweenInfo.new(0.1), {BackgroundColor3=Color3.fromRGB(80,220,120)}):Play()
    task.delay(0.2, function()
        TweenService:Create(tpBtn, TweenInfo.new(0.2), {BackgroundColor3=Color3.fromRGB(40,160,80)}):Play()
    end)

    if tryTeleport() then
        showToast("🚀", "تم الانتقال!", "انتقلت إلى " .. target.Name, C_GREEN, 2)
    else
        -- انتظر حتى يتحمل اللاعب
        task.spawn(function()
            for _ = 1, 10 do
                task.wait(0.4)
                if tryTeleport() then
                    showToast("🚀", "تم الانتقال!", "انتقلت إلى " .. target.Name, C_GREEN, 2)
                    return
                end
            end
            showToast("❌", "فشل الانتقال", target.Name .. " لم يتحمل بعد", Color3.fromRGB(255,80,80), 2)
        end)
    end
end)

-- ══════════════════════════════════════
-- تأثيرات المراقبة
-- ══════════════════════════════════════
local scanOverlayY = 0
local function updateSpectateEffects(t, targetName)
    liveScreen.Visible    = true
    spectateLabel.Text    = "👁  " .. (targetName or "") .. "  |  LIVE"
    local pulse = (math.sin(t*3)+1)/2
    spectateLabel.TextColor3 = C_CYAN:Lerp(C_WHITE, pulse)
    liveBorderStroke.Transparency = 0.3 + pulse*0.4
    scanOverlayY = scanOverlayY + 0.002
    if scanOverlayY > 1 then scanOverlayY = 0 end
    scanOverlay.Position = UDim2.fromScale(0, scanOverlayY)
end

local function hideSpectateEffects()
    liveScreen.Visible = false
end

-- ══════════════════════════════════════
-- جزيئات انفجار النقر
-- ══════════════════════════════════════
local function spawnClickParticles()
    local cx = iconFrame.AbsolutePosition.X + iconFrame.AbsoluteSize.X/2
    local cy = iconFrame.AbsolutePosition.Y + iconFrame.AbsoluteSize.Y/2
    for i = 1, 12 do
        local s            = Instance.new("Frame")
        s.Size             = UDim2.fromOffset(4,4)
        s.Position         = UDim2.fromOffset(cx-2, cy-2)
        s.BackgroundColor3 = (i%2==0) and C_WHITE or C_CYAN
        s.BorderSizePixel  = 0
        s.ZIndex           = 10
        s.Parent           = gui
        Instance.new("UICorner", s).CornerRadius = UDim.new(1,0)
        local ang = math.rad((i/12)*360)
        local d   = math.random(25,60)
        TweenService:Create(s,
            TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
            {Position=UDim2.fromOffset(cx+math.cos(ang)*d-2, cy+math.sin(ang)*d-2),
             BackgroundTransparency=1, Size=UDim2.fromOffset(1,1)}):Play()
        task.delay(0.55, function() s:Destroy() end)
    end
end

-- ══════════════════════════════════════
-- Loop الرئيسي للتأثيرات
-- ══════════════════════════════════════
local colorConn
local scanIconDir  = 1
local scanIconPosY = 0

local function startMainLoop()
    if colorConn then colorConn:Disconnect() end
    colorConn = R.RenderStepped:Connect(function()
        local t  = tick()
        local cx = iconFrame.AbsolutePosition.X + iconFrame.AbsoluteSize.X/2
        local cy = iconFrame.AbsolutePosition.Y + iconFrame.AbsoluteSize.Y/2

        local wave       = (math.sin(t*1.2)+1)/2
        local autoCol    = C_BLUE1:Lerp(C_WHITE, wave)
        local autoColDim = C_BLUE2:Lerp(Color3.fromRGB(200,220,255), wave)

        iconStroke.Color              = autoCol
        ring1S.Color                  = autoCol
        ring2S.Color                  = autoColDim
        ring3S.Color                  = C_BLUE2:Lerp(C_WHITE, wave*0.5)
        scanLineIcon.BackgroundColor3 = autoCol
        prev.BackgroundColor3         = autoColDim
        nxt.BackgroundColor3          = autoColDim
        nameLbl.TextColor3            = autoCol

        iconGrad.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(
                math.floor(80  + wave * 60),
                math.floor(170 + wave * 50),
                255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(
                math.floor(160 + wave * 60),
                math.floor(210 + wave * 35),
                255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 255, 255))
        }
        shimmer.BackgroundTransparency = 0.3 + wave * 0.4

        -- نبضة الأيقونة
        local pulse = 1 + math.sin(t*2.5)*0.05
        local sz    = math.floor(ICON_SIZE * pulse)
        iconFrame.Size     = UDim2.fromOffset(sz, sz)
        iconFrame.Position = UDim2.new(ICON_X, -((sz-ICON_SIZE)/2), ICON_Y, -(sz/2))
        updateCorners(cx, cy, sz, autoCol)

        -- الجناح
        local flap  = math.sin(t*2.8)
        local flapY = flap * 9
        local wingW = 22 + math.abs(flap)*6
        local wingH = 30 - math.abs(flap)*8

        featherL.Size = UDim2.fromOffset(wingW, wingH)
        featherL.Position = UDim2.fromOffset(cx-sz/2-wingW+4, cy-wingH/2+flapY)
        featherLS.Color = autoCol

        featherR.Size = UDim2.fromOffset(wingW, wingH)
        featherR.Position = UDim2.fromOffset(cx+sz/2-4, cy-wingH/2+flapY)
        featherRS.Color = autoCol

        local iW=wingW*0.6; local iH=wingH*0.7; local iFlap=flapY*0.6
        innerL.Size = UDim2.fromOffset(iW, iH)
        innerL.Position = UDim2.fromOffset(cx-sz/2-iW+6, cy-iH/2+iFlap)
        innerLS.Color = autoColDim
        innerR.Size = UDim2.fromOffset(iW, iH)
        innerR.Position = UDim2.fromOffset(cx+sz/2-6, cy-iH/2+iFlap)
        innerRS.Color = autoColDim

        -- حلقات
        local rP = math.abs(math.sin(t*1.8))
        ring1S.Transparency = 0.2+rP*0.4
        ring2S.Transparency = 0.4+rP*0.3
        ring3S.Transparency = 0.6+rP*0.25
        ring1.Position = UDim2.fromOffset(cx-30, cy-30)
        ring2.Position = UDim2.fromOffset(cx-39, cy-39)
        ring3.Position = UDim2.fromOffset(cx-48, cy-48)

        -- نقاط دائرية
        for i, dot in ipairs(dots) do
            local ang = t*1.6+(i/NUM_DOTS)*math.pi*2
            local ps  = 4+math.sin(t*3+i)*2
            dot.Position = UDim2.fromOffset(cx+math.cos(ang)*30-ps/2, cy+math.sin(ang)*30-ps/2)
            dot.Size     = UDim2.fromOffset(ps, ps)
            dot.BackgroundColor3 = (math.floor(t*2.5+i)%2==0) and autoCol or C_DARK
        end

        -- جزيئات
        for i, p in ipairs(particles) do
            local ang2 = t*0.8+(i/#particles)*math.pi*2
            local r2   = 45+math.sin(t*1.5+i)*10
            p.Position = UDim2.fromOffset(cx+math.cos(ang2)*r2-1.5, cy+math.sin(ang2)*r2-1.5)
            p.BackgroundColor3       = autoCol
            p.BackgroundTransparency = 0.2+math.abs(math.sin(t+i))*0.5
        end

        -- خط مسح الأيقونة
        scanIconPosY = scanIconPosY + scanIconDir*0.8
        if scanIconPosY >= ICON_SIZE-2 then scanIconDir=-1
        elseif scanIconPosY <= 0 then scanIconDir=1 end
        scanLineIcon.Position = UDim2.fromOffset(0, scanIconPosY)
        scanLineIcon.BackgroundTransparency = 0.2+(scanIconPosY/ICON_SIZE)*0.5
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
            hideSpectateEffects()
            return
        end
        local list = getPlayers()
        if #list == 0 then
            nameLbl.Text = "⚠️ لا يوجد لاعبون"
            hideSpectateEffects()
            stopSpectate()
            return
        end
        if idx > #list then idx = #list end
        if idx < 1    then idx = 1     end
        local target = list[idx]
        if not target then return end
        if target.Character then
            local hum = target.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                if cam.CameraSubject ~= hum then
                    cam.CameraType    = Enum.CameraType.Custom
                    cam.CameraSubject = hum
                end
                nameLbl.Text = "👁️ " .. target.Name
                updateSpectateEffects(tick(), target.Name)
                return
            end
        end
        nameLbl.Text = "⏳ " .. target.Name .. " يتحمّل..."
        hideSpectateEffects()
    end)
end

-- ══════════════════════════════════════
-- تغيير اللاعب المراقَب
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
    if target and target.Character then
        local hum = target.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            cam.CameraType    = Enum.CameraType.Custom
            cam.CameraSubject = hum
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
    TweenService:Create(iconFrame,
        TweenInfo.new(0.08,Enum.EasingStyle.Back,Enum.EasingDirection.In),
        {Size=UDim2.fromOffset(ICON_SIZE*0.82,ICON_SIZE*0.82)}):Play()
    task.delay(0.08, function()
        TweenService:Create(iconFrame,
            TweenInfo.new(0.15,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
            {Size=UDim2.fromOffset(ICON_SIZE*1.12,ICON_SIZE*1.12)}):Play()
        task.delay(0.15, function()
            TweenService:Create(iconFrame,
                TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                {Size=UDim2.fromOffset(ICON_SIZE,ICON_SIZE)}):Play()
        end)
    end)
    spawnClickParticles()
    if guiVisible then
        TweenService:Create(mainContent,
            TweenInfo.new(0.28,Enum.EasingStyle.Quad,Enum.EasingDirection.In),
            {Position=UDim2.fromScale(-0.18,0)}):Play()
        task.delay(0.29, function()
            prev.Visible    = false
            nxt.Visible     = false
            nameLbl.Visible = false
            tpBtn.Visible   = false
            guiVisible      = false
            mainContent.Position = UDim2.fromScale(0,0)
            stopSpectate()
            hideSpectateEffects()
            liveStartTime   = 0
        end)
    else
        prev.Visible    = true
        nxt.Visible     = true
        nameLbl.Visible = true
        tpBtn.Visible   = true
        guiVisible      = true
        mainContent.Position = UDim2.fromScale(0.18,0)
        TweenService:Create(mainContent,
            TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
            {Position=UDim2.fromScale(0,0)}):Play()
    end
end)

-- ══════════════════════════════════════
-- التحقق من الكود
-- ══════════════════════════════════════
confirmBtn.MouseButton1Click:Connect(function()
    clickSound:Play()
    if codeBox.Text == REQUIRED_CODE then
        isVerified          = true
        -- تأثير نجاح
        TweenService:Create(codeFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back),
            {BackgroundColor3=Color3.fromRGB(5, 30, 10)}):Play()
        TweenService:Create(codeStroke, TweenInfo.new(0.3), {Color=C_GREEN}):Play()
        task.wait(0.4)
        TweenService:Create(codeOverlay, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {BackgroundTransparency=1}):Play()
        task.delay(0.5, function()
            codeOverlay.Visible = false
        end)

        showToast(
            "⏳",
            "جاري التشغيل",
            "انتظر %d ثواني...",
            C_BLUE1,
            5,
            function()
                showToast(
                    "✅",
                    "تم تشغيل المراقبة",
                    "يمكنك الآن اختيار لاعب ◀ ▶",
                    C_GREEN,
                    3,
                    function()
                        mainContent.Visible = true
                        startMainLoop()
                        startSpectateLoop()
                    end
                )
            end
        )
    else
        codeErrLbl.Text = "❌ كود خاطئ! حاول مرة ثانية"
        TweenService:Create(codeStroke, TweenInfo.new(0.1), {Color=Color3.fromRGB(255,50,50)}):Play()
        task.delay(0.5, function()
            TweenService:Create(codeStroke, TweenInfo.new(0.3), {Color=C_BLUE1}):Play()
            codeErrLbl.Text = ""
        end)
        -- اهتزاز
        for i = 1, 6 do
            task.wait(0.05)
            codeFrame.Position = UDim2.new(0.5, (i%2==0 and 6 or -6), 0.5, 0)
        end
        codeFrame.Position = UDim2.fromScale(0.5, 0.5)
    end
end)

-- ══════════════════════════════════════
-- خروج لاعب
-- ══════════════════════════════════════
P.PlayerRemoving:Connect(function(removedPlayer)
    if not spectating then return end
    local newList = {}
    for _, p in ipairs(getPlayers()) do
        if p ~= removedPlayer then table.insert(newList, p) end
    end
    if #newList == 0 then
        stopSpectate(); hideSpectateEffects()
        nameLbl.Text = "⚠️ لا يوجد لاعبون"; idx = 0
        liveStartTime = 0
        showToast("👋", "غادر اللاعب", removedPlayer.Name .. " غادر اللعبة", Color3.fromRGB(255,180,50), 3)
    else
        if idx > #newList then idx = 1 end
        spectating = true
    end
end)

lp.CharacterAdded:Connect(function()
    task.wait(0.5)
    if isVerified then startMainLoop() end
end)
