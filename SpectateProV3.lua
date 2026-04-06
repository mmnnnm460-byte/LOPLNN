-- ╔══════════════════════════════════════════════════════╗
-- ║        Spectate Camera PRO — V3 Ultra               ║
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
local old = pg:FindFirstChild("SpectatePRO_V3")
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
local liveStartTime = 0
local currentTarget = nil  -- اللاعب الحالي المراقَب

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
clickSound.Volume             = 0.6
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
gui.Name           = "SpectatePRO_V3"
gui.ResetOnSpawn   = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent         = pg

-- ════════════════════════════════════════════════════════
-- 🔐 شاشة الكود
-- ════════════════════════════════════════════════════════
local codeOverlay            = Instance.new("Frame")
codeOverlay.Size             = UDim2.fromScale(1, 1)
codeOverlay.Position         = UDim2.fromScale(0, 0)
codeOverlay.BackgroundColor3 = Color3.fromRGB(0, 5, 20)
codeOverlay.BackgroundTransparency = 0.1
codeOverlay.BorderSizePixel  = 0
codeOverlay.ZIndex           = 50
codeOverlay.Parent           = gui

-- نجوم خلفية
for i = 1, 35 do
    local star                  = Instance.new("Frame", codeOverlay)
    star.Size                   = UDim2.fromOffset(math.random(1,3), math.random(1,3))
    star.Position               = UDim2.fromScale(math.random()/1, math.random()/1)
    star.BackgroundColor3       = C_CYAN
    star.BackgroundTransparency = math.random(50,90)/100
    star.BorderSizePixel        = 0
    star.ZIndex                 = 51
    Instance.new("UICorner", star).CornerRadius = UDim.new(1,0)
    task.spawn(function()
        while star.Parent do
            TweenService:Create(star, TweenInfo.new(math.random(10,30)/10, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                {BackgroundTransparency = math.random(20,85)/100}):Play()
            task.wait(math.random(10,30)/10)
        end
    end)
end

local codeFrame            = Instance.new("Frame")
codeFrame.Size             = UDim2.fromOffset(380, 270)
codeFrame.AnchorPoint      = Vector2.new(0.5, 0.5)
codeFrame.Position         = UDim2.fromScale(0.5, 0.5)
codeFrame.BackgroundColor3 = Color3.fromRGB(4, 12, 35)
codeFrame.BorderSizePixel  = 0
codeFrame.ZIndex           = 52
codeFrame.Parent           = codeOverlay
Instance.new("UICorner", codeFrame).CornerRadius = UDim.new(0, 20)

local codeStroke           = Instance.new("UIStroke", codeFrame)
codeStroke.Thickness       = 2
codeStroke.Color           = C_BLUE1

local topBar               = Instance.new("Frame")
topBar.Size                = UDim2.new(1, 0, 0, 5)
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

local lockIcon                  = Instance.new("TextLabel")
lockIcon.Size                   = UDim2.fromOffset(56, 56)
lockIcon.AnchorPoint            = Vector2.new(0.5, 0)
lockIcon.Position               = UDim2.new(0.5, 0, 0, 18)
lockIcon.BackgroundTransparency = 1
lockIcon.Text                   = "🔐"
lockIcon.TextScaled             = true
lockIcon.ZIndex                 = 53
lockIcon.Parent                 = codeFrame

local codeTitle                  = Instance.new("TextLabel")
codeTitle.Size                   = UDim2.new(1, -20, 0, 28)
codeTitle.Position               = UDim2.fromOffset(10, 82)
codeTitle.BackgroundTransparency = 1
codeTitle.TextScaled             = true
codeTitle.Text                   = "أدخل كود الدخول"
codeTitle.Font                   = Enum.Font.GothamBold
codeTitle.TextColor3             = C_WHITE
codeTitle.ZIndex                 = 53
codeTitle.Parent                 = codeFrame

local divider            = Instance.new("Frame")
divider.Size             = UDim2.new(0.7, 0, 0, 1)
divider.AnchorPoint      = Vector2.new(0.5, 0)
divider.Position         = UDim2.new(0.5, 0, 0, 116)
divider.BackgroundColor3 = C_BLUE1
divider.BackgroundTransparency = 0.5
divider.BorderSizePixel  = 0
divider.ZIndex           = 53
divider.Parent           = codeFrame

local codeBoxBg            = Instance.new("Frame")
codeBoxBg.Size             = UDim2.new(0.84, 0, 0, 44)
codeBoxBg.AnchorPoint      = Vector2.new(0.5, 0)
codeBoxBg.Position         = UDim2.new(0.5, 0, 0, 128)
codeBoxBg.BackgroundColor3 = Color3.fromRGB(8, 22, 60)
codeBoxBg.BorderSizePixel  = 0
codeBoxBg.ZIndex           = 53
codeBoxBg.Parent           = codeFrame
Instance.new("UICorner", codeBoxBg).CornerRadius = UDim.new(0, 12)
local boxStroke = Instance.new("UIStroke", codeBoxBg)
boxStroke.Thickness = 1.5
boxStroke.Color     = C_BLUE1
boxStroke.Transparency = 0.4

local keyIcon                  = Instance.new("TextLabel")
keyIcon.Size                   = UDim2.fromOffset(28, 28)
keyIcon.Position               = UDim2.fromOffset(8, 8)
keyIcon.BackgroundTransparency = 1
keyIcon.Text                   = "🗝️"
keyIcon.TextScaled             = true
keyIcon.ZIndex                 = 54
keyIcon.Parent                 = codeBoxBg

local codeBox            = Instance.new("TextBox", codeBoxBg)
codeBox.Size             = UDim2.new(1, -44, 1, -10)
codeBox.Position         = UDim2.fromOffset(40, 5)
codeBox.BackgroundTransparency = 1
codeBox.TextScaled       = false
codeBox.TextSize         = 16
codeBox.PlaceholderText  = "أدخل الكود هنا..."
codeBox.PlaceholderColor3 = Color3.fromRGB(80, 120, 200)
codeBox.Text             = ""
codeBox.Font             = Enum.Font.GothamSemibold
codeBox.TextColor3       = C_WHITE
codeBox.TextXAlignment   = Enum.TextXAlignment.Right
codeBox.BorderSizePixel  = 0
codeBox.ZIndex           = 54

codeBox.Focused:Connect(function()
    TweenService:Create(boxStroke, TweenInfo.new(0.2), {Transparency=0, Color=C_CYAN}):Play()
end)
codeBox.FocusLost:Connect(function()
    TweenService:Create(boxStroke, TweenInfo.new(0.2), {Transparency=0.4, Color=C_BLUE1}):Play()
end)

local confirmBtn            = Instance.new("TextButton")
confirmBtn.Size             = UDim2.new(0.84, 0, 0, 44)
confirmBtn.AnchorPoint      = Vector2.new(0.5, 0)
confirmBtn.Position         = UDim2.new(0.5, 0, 0, 186)
confirmBtn.BackgroundColor3 = C_BLUE1
confirmBtn.TextColor3       = C_WHITE
confirmBtn.Text             = "دخول  ✅"
confirmBtn.TextSize         = 16
confirmBtn.Font             = Enum.Font.GothamBold
confirmBtn.BorderSizePixel  = 0
confirmBtn.ZIndex           = 53
confirmBtn.Parent           = codeFrame
Instance.new("UICorner", confirmBtn).CornerRadius = UDim.new(0, 12)
local btnGrad = Instance.new("UIGradient", confirmBtn)
btnGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 120, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,  80,  200))
}
btnGrad.Rotation = 90

confirmBtn.MouseEnter:Connect(function()
    TweenService:Create(confirmBtn, TweenInfo.new(0.15), {BackgroundColor3=Color3.fromRGB(80,180,255)}):Play()
end)
confirmBtn.MouseLeave:Connect(function()
    TweenService:Create(confirmBtn, TweenInfo.new(0.15), {BackgroundColor3=C_BLUE1}):Play()
end)

local codeErrLbl                  = Instance.new("TextLabel")
codeErrLbl.Size                   = UDim2.new(1, 0, 0, 18)
codeErrLbl.Position               = UDim2.new(0, 0, 1, -22)
codeErrLbl.BackgroundTransparency = 1
codeErrLbl.TextScaled             = true
codeErrLbl.Text                   = ""
codeErrLbl.Font                   = Enum.Font.Gotham
codeErrLbl.TextColor3             = Color3.fromRGB(255, 80, 80)
codeErrLbl.ZIndex                 = 53
codeErrLbl.Parent                 = codeFrame

-- وميض الإطار
task.spawn(function()
    while codeOverlay.Parent do
        TweenService:Create(codeStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Color=C_CYAN}):Play()
        task.wait(1.5)
        TweenService:Create(codeStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Color=C_BLUE2}):Play()
        task.wait(1.5)
    end
end)

-- ══════════════════════════════════════
-- 🔔 إشعارات Toast — صغيرة ولا تزعج
-- ══════════════════════════════════════
local function showToast(icon, titleText, bodyText, accentColor, duration, onDone)
    -- إزالة أي toast موجود
    for _, child in ipairs(gui:GetChildren()) do
        if child.Name == "ToastFrame" then child:Destroy() end
    end

    local toast            = Instance.new("Frame")
    toast.Name             = "ToastFrame"
    -- صغير جداً: 220×52
    toast.Size             = UDim2.fromOffset(220, 52)
    toast.AnchorPoint      = Vector2.new(0.5, 0)
    -- يظهر في الأعلى وسط لكن صغير
    toast.Position         = UDim2.new(0.5, 0, 0, -60)
    toast.BackgroundColor3 = Color3.fromRGB(6, 16, 45)
    toast.BackgroundTransparency = 0.15
    toast.BorderSizePixel  = 0
    toast.ZIndex           = 70
    toast.Parent           = gui
    Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 10)

    local toastStroke      = Instance.new("UIStroke", toast)
    toastStroke.Thickness  = 1.5
    toastStroke.Color      = accentColor

    local bar              = Instance.new("Frame", toast)
    bar.Size               = UDim2.new(1, 0, 0, 3)
    bar.BackgroundColor3   = accentColor
    bar.BorderSizePixel    = 0
    bar.ZIndex             = 71
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 10)

    local iconLbl                  = Instance.new("TextLabel", toast)
    iconLbl.Size                   = UDim2.fromOffset(28, 28)
    iconLbl.Position               = UDim2.fromOffset(8, 12)
    iconLbl.BackgroundTransparency = 1
    iconLbl.TextScaled             = true
    iconLbl.Text                   = icon
    iconLbl.ZIndex                 = 71

    local titleLbl                  = Instance.new("TextLabel", toast)
    titleLbl.Size                   = UDim2.new(1, -44, 0, 20)
    titleLbl.Position               = UDim2.fromOffset(40, 8)
    titleLbl.BackgroundTransparency = 1
    titleLbl.TextSize               = 12
    titleLbl.Text                   = titleText
    titleLbl.Font                   = Enum.Font.GothamBold
    titleLbl.TextColor3             = C_WHITE
    titleLbl.TextXAlignment         = Enum.TextXAlignment.Left
    titleLbl.ZIndex                 = 71

    local bodyLbl                  = Instance.new("TextLabel", toast)
    bodyLbl.Size                   = UDim2.new(1, -44, 0, 16)
    bodyLbl.Position               = UDim2.fromOffset(40, 28)
    bodyLbl.BackgroundTransparency = 1
    bodyLbl.TextSize               = 10
    bodyLbl.Text                   = bodyText
    bodyLbl.Font                   = Enum.Font.Gotham
    bodyLbl.TextColor3             = Color3.fromRGB(160, 200, 255)
    bodyLbl.TextXAlignment         = Enum.TextXAlignment.Left
    bodyLbl.ZIndex                 = 71

    -- شريط تقدم رفيع جداً
    local progressBg               = Instance.new("Frame", toast)
    progressBg.Size                = UDim2.new(1, -16, 0, 2)
    progressBg.Position            = UDim2.new(0, 8, 1, -5)
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
        TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, 0, 0, 8)}):Play()

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
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {Position = UDim2.new(0.5, 0, 0, -60), BackgroundTransparency=1}):Play()
        task.delay(0.35, function()
            if toast.Parent then toast:Destroy() end
            if onDone then onDone() end
        end)
    end)
end

-- ══════════════════════════════════════════════════════════════
-- 🎬 شاشة LIVE — تصميم "V" خرافي ودقيق
-- ══════════════════════════════════════════════════════════════
local liveScreen                  = Instance.new("Frame")
liveScreen.Size                   = UDim2.fromScale(1, 1)
liveScreen.BackgroundTransparency = 1
liveScreen.BorderSizePixel        = 0
liveScreen.ZIndex                 = 2
liveScreen.Visible                = false
liveScreen.Parent                 = gui

-- إطار حول الشاشة
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
liveBorderStroke.Transparency     = 0.6
Instance.new("UICorner", liveBorder).CornerRadius = UDim.new(0, 8)

-- شريط مسح متحرك
local scanOverlay                   = Instance.new("Frame")
scanOverlay.Size                    = UDim2.new(1, 0, 0, 1)
scanOverlay.BackgroundColor3        = C_CYAN
scanOverlay.BackgroundTransparency  = 0.88
scanOverlay.BorderSizePixel         = 0
scanOverlay.ZIndex                  = 3
scanOverlay.Parent                  = liveScreen

-- زوايا الشاشة (تأثير كاميرا)
local function makeScreenCorner(ax, ay, px, py)
    local h = Instance.new("Frame")
    h.Size = UDim2.fromOffset(16, 2)
    h.AnchorPoint = Vector2.new(ax, ay)
    h.Position = UDim2.fromScale(px, py)
    h.BackgroundColor3 = C_CYAN
    h.BorderSizePixel = 0
    h.ZIndex = 4
    h.Parent = liveScreen
    local v = Instance.new("Frame")
    v.Size = UDim2.fromOffset(2, 16)
    v.AnchorPoint = Vector2.new(ax, ay)
    v.Position = UDim2.fromScale(px, py)
    v.BackgroundColor3 = C_CYAN
    v.BorderSizePixel = 0
    v.ZIndex = 4
    v.Parent = liveScreen
end
makeScreenCorner(0,0, 0.012,0.012)
makeScreenCorner(1,0, 0.988,0.012)
makeScreenCorner(0,1, 0.012,0.988)
makeScreenCorner(1,1, 0.988,0.988)

-- ══════════════════════════════════════
-- 🔴 شريط LIVE في الأعلى — شفاف وأنيق
-- ══════════════════════════════════════
local topHUD                  = Instance.new("Frame")
topHUD.Size                   = UDim2.new(1, 0, 0, 44)
topHUD.BackgroundColor3       = Color3.fromRGB(0, 5, 20)
topHUD.BackgroundTransparency = 0.45
topHUD.BorderSizePixel        = 0
topHUD.ZIndex                 = 5
topHUD.Parent                 = liveScreen
local topHUDGrad              = Instance.new("UIGradient", topHUD)
topHUDGrad.Transparency       = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 0.2),
    NumberSequenceKeypoint.new(1, 1)
}
topHUDGrad.Rotation = 90

-- نقطة LIVE حمراء وامضة
local liveDot                  = Instance.new("Frame")
liveDot.Size                   = UDim2.fromOffset(10, 10)
liveDot.Position               = UDim2.fromOffset(12, 17)
liveDot.AnchorPoint            = Vector2.new(0, 0.5)
liveDot.BackgroundColor3       = Color3.fromRGB(255, 60, 60)
liveDot.BorderSizePixel        = 0
liveDot.ZIndex                 = 6
liveDot.Parent                 = topHUD
Instance.new("UICorner", liveDot).CornerRadius = UDim.new(1,0)

task.spawn(function()
    while liveDot.Parent do
        TweenService:Create(liveDot, TweenInfo.new(0.5, Enum.EasingStyle.Sine),
            {BackgroundTransparency=0.75}):Play()
        task.wait(0.5)
        TweenService:Create(liveDot, TweenInfo.new(0.5, Enum.EasingStyle.Sine),
            {BackgroundTransparency=0}):Play()
        task.wait(0.5)
    end
end)

-- نص LIVE
local liveTxt                  = Instance.new("TextLabel")
liveTxt.Size                   = UDim2.fromOffset(40, 20)
liveTxt.Position               = UDim2.fromOffset(28, 12)
liveTxt.BackgroundTransparency = 1
liveTxt.Text                   = "LIVE"
liveTxt.TextSize               = 13
liveTxt.Font                   = Enum.Font.GothamBold
liveTxt.TextColor3             = Color3.fromRGB(255,60,60)
liveTxt.ZIndex                 = 6
liveTxt.Parent                 = topHUD

-- ════════════════════════════════════════
-- 💎 لوغو "V" في المنتصف العلوي — خرافي
-- ════════════════════════════════════════
local vLogoFrame                  = Instance.new("Frame")
vLogoFrame.Size                   = UDim2.fromOffset(110, 36)
vLogoFrame.AnchorPoint            = Vector2.new(0.5, 0)
vLogoFrame.Position               = UDim2.new(0.5, 0, 0, 4)
vLogoFrame.BackgroundTransparency = 1
vLogoFrame.ZIndex                 = 6
vLogoFrame.Parent                 = topHUD

-- خلفية الشعار
local vLogoBg                  = Instance.new("Frame")
vLogoBg.Size                   = UDim2.fromScale(1, 1)
vLogoBg.BackgroundColor3       = Color3.fromRGB(0, 8, 30)
vLogoBg.BackgroundTransparency = 0.3
vLogoBg.BorderSizePixel        = 0
vLogoBg.ZIndex                 = 6
vLogoBg.Parent                 = vLogoFrame
Instance.new("UICorner", vLogoBg).CornerRadius = UDim.new(0, 8)
local vBgStroke = Instance.new("UIStroke", vLogoBg)
vBgStroke.Thickness = 1.2
vBgStroke.Color = C_CYAN
vBgStroke.Transparency = 0.3

-- تدرج داخل الشعار
local vBgGrad = Instance.new("UIGradient", vLogoBg)
vBgGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(0, 20, 70)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 50, 130)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(0, 20, 70))
}
vBgGrad.Rotation = 0

-- الرمز V مع تأثير توهج
local vSymbol                  = Instance.new("TextLabel")
vSymbol.Size                   = UDim2.fromOffset(28, 30)
vSymbol.Position               = UDim2.fromOffset(6, 3)
vSymbol.BackgroundTransparency = 1
vSymbol.Text                   = "V"
vSymbol.TextSize               = 22
vSymbol.Font                   = Enum.Font.GothamBold
vSymbol.TextColor3             = C_CYAN
vSymbol.ZIndex                 = 7
vSymbol.Parent                 = vLogoFrame

-- نص "Spectate" بجانب V
local vSpectateLabel                  = Instance.new("TextLabel")
vSpectateLabel.Size                   = UDim2.fromOffset(72, 14)
vSpectateLabel.Position               = UDim2.fromOffset(34, 4)
vSpectateLabel.BackgroundTransparency = 1
vSpectateLabel.Text                   = "SPECTATE"
vSpectateLabel.TextSize               = 10
vSpectateLabel.Font                   = Enum.Font.GothamBold
vSpectateLabel.TextColor3             = C_WHITE
vSpectateLabel.ZIndex                 = 7
vSpectateLabel.Parent                 = vLogoFrame

-- اسم اللاعب تحت SPECTATE
local vPlayerName                  = Instance.new("TextLabel")
vPlayerName.Size                   = UDim2.fromOffset(72, 12)
vPlayerName.Position               = UDim2.fromOffset(34, 18)
vPlayerName.BackgroundTransparency = 1
vPlayerName.Text                   = "—"
vPlayerName.TextSize               = 9
vPlayerName.Font                   = Enum.Font.Gotham
vPlayerName.TextColor3             = Color3.fromRGB(160, 210, 255)
vPlayerName.ZIndex                 = 7
vPlayerName.Parent                 = vLogoFrame

-- وميض "V" و الإطار
task.spawn(function()
    while vSymbol.Parent do
        TweenService:Create(vSymbol, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {TextColor3=C_WHITE}):Play()
        TweenService:Create(vBgStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Color=C_WHITE, Transparency=0.1}):Play()
        task.wait(1.2)
        TweenService:Create(vSymbol, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {TextColor3=C_CYAN}):Play()
        TweenService:Create(vBgStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Color=C_CYAN, Transparency=0.3}):Play()
        task.wait(1.2)
    end
end)

-- عداد وقت (أعلى اليمين) — صغير وأنيق
local timerLbl                  = Instance.new("TextLabel")
timerLbl.Size                   = UDim2.fromOffset(80, 22)
timerLbl.AnchorPoint            = Vector2.new(1, 0)
timerLbl.Position               = UDim2.new(1, -10, 0, 11)
timerLbl.BackgroundColor3       = Color3.fromRGB(0, 5, 20)
timerLbl.BackgroundTransparency = 0.35
timerLbl.BorderSizePixel        = 0
timerLbl.TextSize               = 11
timerLbl.Text                   = "00:00:00"
timerLbl.Font                   = Enum.Font.GothamBold
timerLbl.TextColor3             = C_GREEN
timerLbl.ZIndex                 = 6
timerLbl.Parent                 = topHUD
Instance.new("UICorner", timerLbl).CornerRadius = UDim.new(0, 5)

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

-- معلومات كاميرا (أسفل اليسار) — صغيرة
local camInfoFrame                  = Instance.new("Frame")
camInfoFrame.Size                   = UDim2.fromOffset(140, 36)
camInfoFrame.Position               = UDim2.new(0, 8, 1, -50)
camInfoFrame.BackgroundColor3       = Color3.fromRGB(0, 5, 20)
camInfoFrame.BackgroundTransparency = 0.45
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

-- ══════════════════════════════════════════════════════
-- 👤 وقت فوق رأس اللاعب المراقَب — يتلون ويتحدث
-- (BillboardGui على اللاعب المراقَب)
-- ══════════════════════════════════════════════════════
local playerTimerBillboard = nil
local playerTimerLabel     = nil
local playerTimerStart     = 0
local timerColorConn       = nil

local function removePlayerTimer()
    if timerColorConn then timerColorConn:Disconnect(); timerColorConn = nil end
    if playerTimerBillboard and playerTimerBillboard.Parent then
        playerTimerBillboard:Destroy()
    end
    playerTimerBillboard = nil
    playerTimerLabel     = nil
    playerTimerStart     = 0
end

local function createPlayerTimer(targetPlayer)
    removePlayerTimer()
    if not targetPlayer or not targetPlayer.Character then return end
    local head = targetPlayer.Character:FindFirstChild("Head")
    if not head then return end

    local bb           = Instance.new("BillboardGui")
    bb.Name            = "SpectateTimerBB"
    bb.Size            = UDim2.fromOffset(90, 30)
    bb.StudsOffset     = Vector3.new(0, 2.8, 0)
    bb.AlwaysOnTop     = true
    bb.ResetOnSpawn    = false
    bb.Parent          = head

    local bg            = Instance.new("Frame", bb)
    bg.Size             = UDim2.fromScale(1, 1)
    bg.BackgroundColor3 = Color3.fromRGB(0, 5, 20)
    bg.BackgroundTransparency = 0.3
    bg.BorderSizePixel  = 0
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)
    local bgStroke = Instance.new("UIStroke", bg)
    bgStroke.Thickness = 1.2
    bgStroke.Color = C_CYAN

    local lbl                  = Instance.new("TextLabel", bg)
    lbl.Size                   = UDim2.fromScale(1, 1)
    lbl.BackgroundTransparency = 1
    lbl.TextSize               = 11
    lbl.Font                   = Enum.Font.GothamBold
    lbl.TextColor3             = C_CYAN
    lbl.Text                   = "00:00"
    lbl.ZIndex                 = 2

    playerTimerBillboard = bb
    playerTimerLabel     = lbl
    playerTimerStart     = tick()

    -- تلوين متغير + تحديث الوقت
    local colorPhase = 0
    local colors = {
        Color3.fromRGB(100, 220, 255),
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(60,  220, 120),
        Color3.fromRGB(60,  160, 255),
    }
    timerColorConn = R.Heartbeat:Connect(function()
        if not lbl.Parent then
            timerColorConn:Disconnect()
            return
        end
        -- تحديث الوقت
        local elapsed = math.floor(tick() - playerTimerStart)
        local m = math.floor(elapsed/60)
        local s = elapsed%60
        lbl.Text = string.format("%02d:%02d", m, s)

        -- تلوين سلس
        colorPhase = colorPhase + 0.008
        if colorPhase >= #colors then colorPhase = 0 end
        local i1 = math.floor(colorPhase) + 1
        local i2 = (i1 % #colors) + 1
        local alpha = colorPhase - math.floor(colorPhase)
        local col = colors[i1]:Lerp(colors[i2], alpha)
        lbl.TextColor3 = col
        bgStroke.Color = col
    end)
end

-- ══════════════════════════════════════
-- المحتوى الرئيسي
-- ══════════════════════════════════════
local mainContent                  = Instance.new("Frame")
mainContent.Size                   = UDim2.fromScale(1, 1)
mainContent.BackgroundTransparency = 1
mainContent.Visible                = false
mainContent.Parent                 = gui

-- ══════════════════════════════════════
-- 🔒 زر الإخفاء — حجم 45، قابل للسحب
-- يظهر فقط بعد التحقق من الكود
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
hideBtn.Visible          = false  -- مخفي حتى يدخل الكود
hideBtn.Parent           = gui
Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(0, 12)
local hideBtnStroke      = Instance.new("UIStroke", hideBtn)
hideBtnStroke.Thickness  = 1.8
hideBtnStroke.Color      = C_BLUE1

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

-- ══════════════════════════════════════════════════════
-- سحب زر الإخفاء — محسّن يعمل بشكل صحيح
-- ══════════════════════════════════════════════════════
local hideDragging  = false
local hideDragStart = nil
local hideBtnX      = 0
local hideBtnY      = 0
local hideMoved     = false
local DRAG_THRESHOLD = 6

hideBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        hideDragging  = true
        hideMoved     = false
        hideDragStart = input.Position
        local vp      = cam.ViewportSize
        -- حفظ الموقع الحالي بالنسبة المئوية
        hideBtnX = hideBtn.Position.X.Scale * vp.X + hideBtn.Position.X.Offset
        hideBtnY = hideBtn.Position.Y.Scale * vp.Y + hideBtn.Position.Y.Offset
    end
end)

UIS.InputChanged:Connect(function(input)
    if hideDragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - hideDragStart
        if math.abs(delta.X) > DRAG_THRESHOLD or math.abs(delta.Y) > DRAG_THRESHOLD then
            hideMoved = true
        end
        if hideMoved then
            local vp  = cam.ViewportSize
            local btn = 45
            local nx  = math.clamp(hideBtnX + delta.X, 0, vp.X - btn)
            local ny  = math.clamp(hideBtnY + delta.Y, 0, vp.Y - btn)
            hideBtn.Position = UDim2.fromOffset(nx, ny)
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1
    or  input.UserInputType == Enum.UserInputType.Touch) and hideDragging then
        hideDragging = false
    end
end)

-- وظيفة الإخفاء (نقر فقط إذا لم يتحرك)
hideBtn.MouseButton1Click:Connect(function()
    if hideMoved then hideMoved = false; return end
    clickSound:Play()
    scriptHidden = not scriptHidden
    if scriptHidden then
        mainContent.Visible = false
        liveScreen.Visible  = false
        hideBtn.Text        = "🙈"
        hideBtn.BackgroundColor3 = Color3.fromRGB(35, 8, 8)
        showToast("🙈", "تم الإخفاء", "اضغط 👁 للإظهار", Color3.fromRGB(200,80,80), 2)
    else
        mainContent.Visible = true
        if spectating then liveScreen.Visible = true end
        hideBtn.Text = "👁"
        hideBtn.BackgroundColor3 = Color3.fromRGB(6, 18, 55)
        showToast("👁", "تم الإظهار", "السكربت نشط الآن", C_GREEN, 2)
    end
end)

-- ══════════════════════════════════════
-- إعدادات الأيقونة
-- ══════════════════════════════════════
local ICON_SIZE = 42
local ICON_X    = 0.022
local ICON_Y    = 0.42

-- حلقات ضوء
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
    s.Thickness   = 1.2
    s.Color       = C_BLUE1
    s.Transparency = alpha or 0.4
    return r, s
end

local ring1, ring1S = makeRing(56, 0.3, 3)
local ring2, ring2S = makeRing(72, 0.5, 2)
local ring3, ring3S = makeRing(88, 0.7, 1)

local NUM_DOTS = 6
local dots = {}
for i = 1, NUM_DOTS do
    local dot            = Instance.new("Frame")
    dot.Size             = UDim2.fromOffset(4,4)
    dot.AnchorPoint      = Vector2.new(0.5,0.5)
    dot.BackgroundColor3 = (i%2==0) and C_WHITE or C_BLUE1
    dot.BorderSizePixel  = 0
    dot.ZIndex           = 4
    dot.Parent           = mainContent
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
    table.insert(dots, dot)
end

local particles = {}
for i = 1, 4 do
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

-- جناح
local function makeWingPart(z)
    local f = Instance.new("Frame")
    f.BackgroundTransparency = 1
    f.BorderSizePixel = 0
    f.ZIndex = z
    f.Parent = mainContent
    local s = Instance.new("UIStroke", f)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0.5, 0)
    return f, s
end
local featherL, featherLS = makeWingPart(3)
local featherR, featherRS = makeWingPart(3)
local innerL,   innerLS   = makeWingPart(3)
local innerR,   innerRS   = makeWingPart(3)
featherLS.Thickness = 2; featherRS.Thickness = 2
innerLS.Thickness   = 1.2; innerRS.Thickness = 1.2

-- الأيقونة الرئيسية
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
iconStroke.Thickness         = 1.8
iconStroke.Color             = C_BLUE1

local iconGrad               = Instance.new("UIGradient", iconFrame)
iconGrad.Color               = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(100, 190, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 225, 255)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 255, 255))
}
iconGrad.Rotation = 135

local shimmer                  = Instance.new("Frame", iconFrame)
shimmer.Size                   = UDim2.fromScale(0.5, 0.5)
shimmer.Position               = UDim2.fromScale(0.24, 0.14)
shimmer.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
shimmer.BackgroundTransparency = 0.6
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
local CORNER_LEN   = 7
local CORNER_THICK = 1.8
local CORNER_GAP   = 4
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
local tlH=makeCLine(true); local tlV=makeCLine(false)
local trH=makeCLine(true); local trV=makeCLine(false)
local blH=makeCLine(true); local blV=makeCLine(false)
local brH=makeCLine(true); local brV=makeCLine(false)

local function updateCorners(cx, cy, sz, col)
    local h, g = sz/2, CORNER_GAP
    tlH.Position = UDim2.fromOffset(cx-h-g-CORNER_LEN,  cy-h-g-CORNER_THICK)
    tlV.Position = UDim2.fromOffset(cx-h-g-CORNER_THICK, cy-h-g-CORNER_LEN)
    trH.Position = UDim2.fromOffset(cx+h+g,              cy-h-g-CORNER_THICK)
    trV.Position = UDim2.fromOffset(cx+h+g,              cy-h-g-CORNER_LEN)
    blH.Position = UDim2.fromOffset(cx-h-g-CORNER_LEN,  cy+h+g)
    blV.Position = UDim2.fromOffset(cx-h-g-CORNER_THICK, cy+h+g)
    brH.Position = UDim2.fromOffset(cx+h+g,              cy+h+g)
    brV.Position = UDim2.fromOffset(cx+h+g,              cy+h+g)
    for _, l in ipairs(cornerLines) do l.BackgroundColor3 = col end
end

-- ══════════════════════════════════════════════════════
-- أزرار التنقل — صغيرة وملونة (أزرق وأبيض)
-- ══════════════════════════════════════════════════════
local function makeNavBtn(txt, posX)
    local b            = Instance.new("TextButton")
    -- صغير: 48×32
    b.Size             = UDim2.fromOffset(48, 32)
    b.Position         = UDim2.new(posX, 0, 0.90, 0)
    b.AnchorPoint      = Vector2.new(0.5, 0.5)
    b.Text             = txt
    b.TextSize         = 14
    b.BackgroundColor3 = C_BLUE2
    b.TextColor3       = C_WHITE
    b.Font             = Enum.Font.GothamBold
    b.BorderSizePixel  = 0
    b.ZIndex           = 5
    b.Parent           = mainContent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", b)
    s.Thickness = 1.5
    s.Color = C_WHITE
    -- تدرج أزرق وأبيض
    local g = Instance.new("UIGradient", b)
    g.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(40,  130, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 220, 255)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(40,  130, 255))
    }
    g.Rotation = 90
    return b, s
end

local prev, prevS = makeNavBtn("◀", 0.35)
local nxt,  nxtS  = makeNavBtn("▶", 0.65)

-- ══════════════════════════════════════════════════════
-- اسم اللاعب — صغير ولا يزعج
-- ══════════════════════════════════════════════════════
local nameLbl                  = Instance.new("TextLabel")
nameLbl.Size                   = UDim2.fromOffset(140, 22)
nameLbl.Position               = UDim2.new(0.5, 0, 0.84, 0)
nameLbl.AnchorPoint            = Vector2.new(0.5, 0.5)
nameLbl.BackgroundColor3       = Color3.fromRGB(0, 8, 30)
nameLbl.BackgroundTransparency = 0.3
nameLbl.BorderSizePixel        = 0
nameLbl.TextSize               = 10
nameLbl.Text                   = "اختر لاعب  ◀ ▶"
nameLbl.Font                   = Enum.Font.GothamSemibold
nameLbl.TextColor3             = C_WHITE
nameLbl.ZIndex                 = 5
nameLbl.Parent                 = mainContent
Instance.new("UICorner", nameLbl).CornerRadius = UDim.new(0, 6)
local nameStroke = Instance.new("UIStroke", nameLbl)
nameStroke.Thickness = 1
nameStroke.Color = C_BLUE1

-- ══════════════════════════════════════════════════════
-- 🚀 زر انتقال — أصغر وملون أزرق وأبيض
-- ══════════════════════════════════════════════════════
local tpBtn            = Instance.new("TextButton")
tpBtn.Size             = UDim2.fromOffset(110, 28)
tpBtn.Position         = UDim2.new(0.5, 0, 0.905, 0)
tpBtn.AnchorPoint      = Vector2.new(0.5, 0)
tpBtn.Text             = "🚀 انتقل"
tpBtn.TextSize         = 11
tpBtn.BackgroundColor3 = C_BLUE2
tpBtn.TextColor3       = C_WHITE
tpBtn.Font             = Enum.Font.GothamBold
tpBtn.BorderSizePixel  = 0
tpBtn.ZIndex           = 5
tpBtn.Parent           = mainContent
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 8)
local tpStroke = Instance.new("UIStroke", tpBtn)
tpStroke.Thickness = 1.5
tpStroke.Color = C_WHITE
local tpGrad = Instance.new("UIGradient", tpBtn)
tpGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(30,  110, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 230, 255)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(30,  110, 255))
}
tpGrad.Rotation = 90

-- وميض زر الانتقال
task.spawn(function()
    while tpBtn.Parent do
        TweenService:Create(tpStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            {Color=C_CYAN, Transparency=0.2}):Play()
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
    if #list == 0 then
        showToast("⚠️", "لا يوجد لاعبون", "السيرفر فارغ", Color3.fromRGB(255,80,80), 2)
        return
    end
    if idx > #list then idx = 1 end
    local target = list[idx]
    if not target then return end

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
    TweenService:Create(tpBtn, TweenInfo.new(0.1), {BackgroundColor3=Color3.fromRGB(80,200,255)}):Play()
    task.delay(0.2, function()
        TweenService:Create(tpBtn, TweenInfo.new(0.2), {BackgroundColor3=C_BLUE2}):Play()
    end)

    if tryTeleport() then
        showToast("🚀", "تم الانتقال!", "انتقلت إلى " .. target.Name, C_GREEN, 2)
    else
        task.spawn(function()
            for _ = 1, 10 do
                task.wait(0.4)
                if tryTeleport() then
                    showToast("🚀", "تم الانتقال!", "انتقلت إلى " .. target.Name, C_GREEN, 2)
                    return
                end
            end
            showToast("❌", "فشل الانتقال", target.Name .. " لم يتحمل", Color3.fromRGB(255,80,80), 2)
        end)
    end
end)

-- ══════════════════════════════════════
-- تأثيرات شاشة LIVE
-- ══════════════════════════════════════
local scanOverlayY = 0
local function updateSpectateEffects(t, targetName)
    liveScreen.Visible = not scriptHidden
    vPlayerName.Text   = targetName or "—"
    local pulse = (math.sin(t*3)+1)/2
    liveBorderStroke.Transparency = 0.4 + pulse*0.4
    scanOverlayY = scanOverlayY + 0.0015
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
    for i = 1, 10 do
        local s            = Instance.new("Frame")
        s.Size             = UDim2.fromOffset(3,3)
        s.Position         = UDim2.fromOffset(cx-1.5, cy-1.5)
        s.BackgroundColor3 = (i%2==0) and C_WHITE or C_CYAN
        s.BorderSizePixel  = 0
        s.ZIndex           = 10
        s.Parent           = gui
        Instance.new("UICorner", s).CornerRadius = UDim.new(1,0)
        local ang = math.rad((i/10)*360)
        local d   = math.random(20,50)
        TweenService:Create(s,
            TweenInfo.new(0.45,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
            {Position=UDim2.fromOffset(cx+math.cos(ang)*d-1.5, cy+math.sin(ang)*d-1.5),
             BackgroundTransparency=1, Size=UDim2.fromOffset(1,1)}):Play()
        task.delay(0.5, function() s:Destroy() end)
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

        -- تلوين أزرار التنقل
        prevS.Color = C_WHITE:Lerp(C_CYAN, wave)
        nxtS.Color  = C_WHITE:Lerp(C_CYAN, wave)
        nameStroke.Color = autoCol
        nameLbl.TextColor3 = autoCol

        iconGrad.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(math.floor(80+wave*60), math.floor(170+wave*50), 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(math.floor(160+wave*60), math.floor(210+wave*35), 255)),
            ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 255, 255))
        }
        shimmer.BackgroundTransparency = 0.35 + wave*0.4

        local pulse = 1 + math.sin(t*2.5)*0.04
        local sz    = math.floor(ICON_SIZE * pulse)
        iconFrame.Size     = UDim2.fromOffset(sz, sz)
        iconFrame.Position = UDim2.new(ICON_X, -((sz-ICON_SIZE)/2), ICON_Y, -(sz/2))
        updateCorners(cx, cy, sz, autoCol)

        -- جناح
        local flap  = math.sin(t*2.8)
        local flapY = flap * 8
        local wingW = 20 + math.abs(flap)*5
        local wingH = 28 - math.abs(flap)*7
        featherL.Size = UDim2.fromOffset(wingW, wingH)
        featherL.Position = UDim2.fromOffset(cx-sz/2-wingW+4, cy-wingH/2+flapY)
        featherLS.Color = autoCol
        featherR.Size = UDim2.fromOffset(wingW, wingH)
        featherR.Position = UDim2.fromOffset(cx+sz/2-4, cy-wingH/2+flapY)
        featherRS.Color = autoCol
        local iW=wingW*0.6; local iH=wingH*0.65; local iFlap=flapY*0.6
        innerL.Size = UDim2.fromOffset(iW, iH)
        innerL.Position = UDim2.fromOffset(cx-sz/2-iW+5, cy-iH/2+iFlap)
        innerLS.Color = autoColDim
        innerR.Size = UDim2.fromOffset(iW, iH)
        innerR.Position = UDim2.fromOffset(cx+sz/2-5, cy-iH/2+iFlap)
        innerRS.Color = autoColDim

        -- حلقات
        local rP = math.abs(math.sin(t*1.8))
        ring1S.Transparency = 0.2+rP*0.4
        ring2S.Transparency = 0.4+rP*0.3
        ring3S.Transparency = 0.6+rP*0.25
        ring1.Position = UDim2.fromOffset(cx-28, cy-28)
        ring2.Position = UDim2.fromOffset(cx-36, cy-36)
        ring3.Position = UDim2.fromOffset(cx-44, cy-44)

        -- نقاط
        for i, dot in ipairs(dots) do
            local ang = t*1.6+(i/NUM_DOTS)*math.pi*2
            local ps  = 3+math.sin(t*3+i)*1.5
            dot.Position = UDim2.fromOffset(cx+math.cos(ang)*28-ps/2, cy+math.sin(ang)*28-ps/2)
            dot.Size     = UDim2.fromOffset(ps, ps)
            dot.BackgroundColor3 = (math.floor(t*2.5+i)%2==0) and autoCol or C_DARK
        end

        -- جزيئات
        for i, p in ipairs(particles) do
            local ang2 = t*0.8+(i/#particles)*math.pi*2
            local r2   = 40+math.sin(t*1.5+i)*8
            p.Position = UDim2.fromOffset(cx+math.cos(ang2)*r2-1.5, cy+math.sin(ang2)*r2-1.5)
            p.BackgroundColor3       = autoCol
            p.BackgroundTransparency = 0.2+math.abs(math.sin(t+i))*0.5
        end

        -- خط مسح الأيقونة
        scanIconPosY = scanIconPosY + scanIconDir*0.7
        if scanIconPosY >= ICON_SIZE-2 then scanIconDir=-1
        elseif scanIconPosY <= 0 then scanIconDir=1 end
        scanLineIcon.Position = UDim2.fromOffset(0, scanIconPosY)
        scanLineIcon.BackgroundTransparency = 0.2+(scanIconPosY/ICON_SIZE)*0.5
    end)
end

-- ══════════════════════════════════════
-- Loop المراقبة — يحدث timer عند تغيير اللاعب
-- ══════════════════════════════════════
local spectateConn
local function startSpectateLoop()
    if spectateConn then spectateConn:Disconnect() end
    spectateConn = R.Heartbeat:Connect(function()
        if not isVerified or not spectating or idx == 0 then
            if liveScreen.Visible then hideSpectateEffects() end
            return
        end
        local list = getPlayers()
        if #list == 0 then
            nameLbl.Text = "⚠️ لا يوجد لاعبون"
            hideSpectateEffects()
            removePlayerTimer()
            stopSpectate()
            return
        end
        if idx > #list then idx = #list end
        if idx < 1    then idx = 1 end
        local target = list[idx]
        if not target then return end

        -- إذا تغير اللاعب المراقَب → أنشئ timer جديد
        if currentTarget ~= target then
            currentTarget = target
            createPlayerTimer(target)
        end

        -- إذا تغير الـ character (مات وعاد) → أعد ربط timer
        if playerTimerBillboard and not playerTimerBillboard.Parent then
            createPlayerTimer(target)
        end

        if target.Character then
            local hum = target.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                if cam.CameraSubject ~= hum then
                    cam.CameraType    = Enum.CameraType.Custom
                    cam.CameraSubject = hum
                end
                nameLbl.Text = "👁 " .. target.Name
                updateSpectateEffects(tick(), target.Name)
                return
            end
        end
        nameLbl.Text = "⏳ " .. target.Name
        if liveScreen.Visible then hideSpectateEffects() end
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
        if idx < 1     then idx = #list end
        if idx > #list then idx = 1 end
    end
    spectating = true
    if liveStartTime == 0 then liveStartTime = tick() end

    -- إعادة إنشاء timer عند تغيير اللاعب
    local target = list[idx]
    if target then
        currentTarget = target
        createPlayerTimer(target)
        if target.Character then
            local hum = target.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                cam.CameraType    = Enum.CameraType.Custom
                cam.CameraSubject = hum
            end
        end
    end
end

prev.MouseButton1Down:Connect(function() clickSound:Play(); changeTarget(-1) end)
nxt.MouseButton1Down:Connect(function()  clickSound:Play(); changeTarget(1)  end)

-- ══════════════════════════════════════
-- ضغط الأيقونة (فتح/غلق الواجهة)
-- ══════════════════════════════════════
iconFrame.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1
    and input.UserInputType ~= Enum.UserInputType.Touch then return end
    clickSound:Play()
    TweenService:Create(iconFrame,
        TweenInfo.new(0.07,Enum.EasingStyle.Back,Enum.EasingDirection.In),
        {Size=UDim2.fromOffset(ICON_SIZE*0.82,ICON_SIZE*0.82)}):Play()
    task.delay(0.07, function()
        TweenService:Create(iconFrame,
            TweenInfo.new(0.14,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
            {Size=UDim2.fromOffset(ICON_SIZE*1.1,ICON_SIZE*1.1)}):Play()
        task.delay(0.14, function()
            TweenService:Create(iconFrame,
                TweenInfo.new(0.1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
                {Size=UDim2.fromOffset(ICON_SIZE,ICON_SIZE)}):Play()
        end)
    end)
    spawnClickParticles()
    if guiVisible then
        TweenService:Create(mainContent,
            TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.In),
            {Position=UDim2.fromScale(-0.16,0)}):Play()
        task.delay(0.26, function()
            prev.Visible    = false
            nxt.Visible     = false
            nameLbl.Visible = false
            tpBtn.Visible   = false
            guiVisible      = false
            mainContent.Position = UDim2.fromScale(0,0)
            stopSpectate()
            removePlayerTimer()
            hideSpectateEffects()
            liveStartTime = 0
        end)
    else
        prev.Visible    = true
        nxt.Visible     = true
        nameLbl.Visible = true
        tpBtn.Visible   = true
        guiVisible      = true
        mainContent.Position = UDim2.fromScale(0.16,0)
        TweenService:Create(mainContent,
            TweenInfo.new(0.28,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
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
        TweenService:Create(codeFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back),
            {BackgroundColor3=Color3.fromRGB(5, 30, 10)}):Play()
        TweenService:Create(codeStroke, TweenInfo.new(0.3), {Color=C_GREEN}):Play()
        task.wait(0.35)
        TweenService:Create(codeOverlay, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {BackgroundTransparency=1}):Play()
        task.delay(0.5, function()
            codeOverlay.Visible = false
            -- إظهار زر الإخفاء بعد التحقق
            hideBtn.Visible = true
            TweenService:Create(hideBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                {BackgroundTransparency=0}):Play()
        end)

        showToast("⏳", "جاري التشغيل", "انتظر %d ثواني...", C_BLUE1, 4, function()
            showToast("✅", "تم التشغيل", "اختر لاعب ◀ ▶", C_GREEN, 3, function()
                mainContent.Visible = true
                startMainLoop()
                startSpectateLoop()
            end)
        end)
    else
        codeErrLbl.Text = "❌ كود خاطئ!"
        TweenService:Create(codeStroke, TweenInfo.new(0.1), {Color=Color3.fromRGB(255,50,50)}):Play()
        task.delay(0.5, function()
            TweenService:Create(codeStroke, TweenInfo.new(0.3), {Color=C_BLUE1}):Play()
            codeErrLbl.Text = ""
        end)
        -- اهتزاز
        for i = 1, 6 do
            task.wait(0.05)
            codeFrame.Position = UDim2.new(0.5, (i%2==0 and 7 or -7), 0.5, 0)
        end
        codeFrame.Position = UDim2.fromScale(0.5, 0.5)
    end
end)

-- ══════════════════════════════════════
-- خروج لاعب
-- ══════════════════════════════════════
P.PlayerRemoving:Connect(function(removedPlayer)
    if currentTarget == removedPlayer then
        removePlayerTimer()
        currentTarget = nil
    end
    if not spectating then return end
    local newList = {}
    for _, p in ipairs(P:GetPlayers()) do
        if p ~= lp and p ~= removedPlayer then table.insert(newList, p) end
    end
    if #newList == 0 then
        stopSpectate()
        removePlayerTimer()
        hideSpectateEffects()
        nameLbl.Text = "⚠️ لا يوجد لاعبون"
        idx = 0
        liveStartTime = 0
        showToast("👋", "غادر اللاعب", removedPlayer.Name .. " غادر", Color3.fromRGB(255,180,50), 2)
    else
        if idx > #newList then idx = 1 end
        spectating = true
    end
end)

lp.CharacterAdded:Connect(function()
    task.wait(0.5)
    if isVerified then startMainLoop() end
end)
