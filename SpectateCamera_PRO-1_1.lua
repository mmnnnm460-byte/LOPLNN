-- ╔══════════════════════════════════════════╗
-- ║     Spectate Camera PRO - Enhanced       ║
-- ║     Code: 12717375127                    ║
-- ╚══════════════════════════════════════════╝

local P            = game:GetService("Players")
local R            = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

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

-- ألوان
local C_BLUE1 = Color3.fromRGB(60,  160, 255)
local C_BLUE2 = Color3.fromRGB(30,  100, 220)
local C_WHITE = Color3.fromRGB(255, 255, 255)
local C_DARK  = Color3.fromRGB(5,   15,  40)
local C_CYAN  = Color3.fromRGB(100, 220, 255)
local C_GREEN = Color3.fromRGB(60,  220, 120)

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

-- ══════════════════════════════════════
-- شاشة الكود
-- ══════════════════════════════════════
local codeFrame            = Instance.new("Frame")
codeFrame.Size             = UDim2.fromScale(0.38, 0.30)
codeFrame.Position         = UDim2.fromScale(0.31, 0.35)
codeFrame.BackgroundColor3 = C_DARK
codeFrame.BorderSizePixel  = 0
codeFrame.ZIndex           = 50
codeFrame.Parent           = gui
Instance.new("UICorner", codeFrame).CornerRadius = UDim.new(0, 14)

local codeStroke     = Instance.new("UIStroke", codeFrame)
codeStroke.Thickness = 2
codeStroke.Color     = C_BLUE1

local codeTitleLbl                  = Instance.new("TextLabel", codeFrame)
codeTitleLbl.Size                   = UDim2.fromScale(1, 0.25)
codeTitleLbl.Position               = UDim2.fromScale(0, 0.05)
codeTitleLbl.BackgroundTransparency = 1
codeTitleLbl.TextScaled             = true
codeTitleLbl.Text                   = "🔐 أدخل كود الدخول"
codeTitleLbl.Font                   = Enum.Font.GothamBold
codeTitleLbl.TextColor3             = C_BLUE1
codeTitleLbl.ZIndex                 = 51

local codeBox            = Instance.new("TextBox", codeFrame)
codeBox.Size             = UDim2.fromScale(0.78, 0.20)
codeBox.Position         = UDim2.fromScale(0.11, 0.36)
codeBox.BackgroundColor3 = Color3.fromRGB(10, 25, 60)
codeBox.TextScaled       = true
codeBox.PlaceholderText  = "الكود هنا..."
codeBox.Text             = ""
codeBox.Font             = Enum.Font.GothamSemibold
codeBox.TextColor3       = C_WHITE
codeBox.BorderSizePixel  = 0
codeBox.ZIndex           = 51
Instance.new("UICorner", codeBox).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke",  codeBox).Color       = C_BLUE2

local confirmBtn            = Instance.new("TextButton", codeFrame)
confirmBtn.Size             = UDim2.fromScale(0.6, 0.18)
confirmBtn.Position         = UDim2.fromScale(0.2, 0.64)
confirmBtn.Text             = "✅ دخول"
confirmBtn.TextScaled       = true
confirmBtn.Font             = Enum.Font.GothamBold
confirmBtn.BackgroundColor3 = C_BLUE2
confirmBtn.TextColor3       = C_WHITE
confirmBtn.BorderSizePixel  = 0
confirmBtn.ZIndex           = 51
Instance.new("UICorner", confirmBtn).CornerRadius = UDim.new(0, 8)

local codeErrLbl                  = Instance.new("TextLabel", codeFrame)
codeErrLbl.Size                   = UDim2.fromScale(1, 0.12)
codeErrLbl.Position               = UDim2.fromScale(0, 0.86)
codeErrLbl.BackgroundTransparency = 1
codeErrLbl.TextScaled             = true
codeErrLbl.Text                   = ""
codeErrLbl.Font                   = Enum.Font.Gotham
codeErrLbl.TextColor3             = Color3.fromRGB(255, 80, 80)
codeErrLbl.ZIndex                 = 51

-- ══════════════════════════════════════
-- 🔔 دالة الإشعارات (Toast)
-- تظهر من الأعلى وتختفي ببطء
-- ══════════════════════════════════════
local function showToast(icon, titleText, bodyText, accentColor, duration, onDone)
    local toast            = Instance.new("Frame")
    toast.Size             = UDim2.fromOffset(280, 72)
    toast.AnchorPoint      = Vector2.new(0.5, 0)
    toast.Position         = UDim2.new(0.5, 0, 0, -90)
    toast.BackgroundColor3 = Color3.fromRGB(8, 18, 45)
    toast.BorderSizePixel  = 0
    toast.ZIndex           = 60
    toast.Parent           = gui
    Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 12)

    local toastStroke      = Instance.new("UIStroke", toast)
    toastStroke.Thickness  = 2
    toastStroke.Color      = accentColor

    local bar              = Instance.new("Frame", toast)
    bar.Size               = UDim2.new(1, 0, 0, 3)
    bar.Position           = UDim2.fromScale(0, 0)
    bar.BackgroundColor3   = accentColor
    bar.BorderSizePixel    = 0
    bar.ZIndex             = 61
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 12)

    local iconLbl                  = Instance.new("TextLabel", toast)
    iconLbl.Size                   = UDim2.fromOffset(38, 38)
    iconLbl.Position               = UDim2.fromOffset(10, 17)
    iconLbl.BackgroundTransparency = 1
    iconLbl.TextScaled             = true
    iconLbl.Text                   = icon
    iconLbl.Font                   = Enum.Font.GothamBold
    iconLbl.TextColor3             = accentColor
    iconLbl.ZIndex                 = 61

    local titleLbl                  = Instance.new("TextLabel", toast)
    titleLbl.Size                   = UDim2.new(1, -58, 0, 24)
    titleLbl.Position               = UDim2.fromOffset(52, 10)
    titleLbl.BackgroundTransparency = 1
    titleLbl.TextScaled             = true
    titleLbl.Text                   = titleText
    titleLbl.Font                   = Enum.Font.GothamBold
    titleLbl.TextColor3             = C_WHITE
    titleLbl.TextXAlignment         = Enum.TextXAlignment.Left
    titleLbl.ZIndex                 = 61

    local bodyLbl                  = Instance.new("TextLabel", toast)
    bodyLbl.Size                   = UDim2.new(1, -58, 0, 22)
    bodyLbl.Position               = UDim2.fromOffset(52, 36)
    bodyLbl.BackgroundTransparency = 1
    bodyLbl.TextScaled             = true
    bodyLbl.Text                   = bodyText
    bodyLbl.Font                   = Enum.Font.Gotham
    bodyLbl.TextColor3             = Color3.fromRGB(180, 200, 255)
    bodyLbl.TextXAlignment         = Enum.TextXAlignment.Left
    bodyLbl.ZIndex                 = 61

    local progressBg               = Instance.new("Frame", toast)
    progressBg.Size                = UDim2.new(1, -20, 0, 3)
    progressBg.Position            = UDim2.new(0, 10, 1, -8)
    progressBg.BackgroundColor3    = Color3.fromRGB(30, 50, 100)
    progressBg.BorderSizePixel     = 0
    progressBg.ZIndex              = 61
    Instance.new("UICorner", progressBg).CornerRadius = UDim.new(1, 0)

    local progressBar              = Instance.new("Frame", progressBg)
    progressBar.Size               = UDim2.fromScale(1, 1)
    progressBar.BackgroundColor3   = accentColor
    progressBar.BorderSizePixel    = 0
    progressBar.ZIndex             = 62
    Instance.new("UICorner", progressBar).CornerRadius = UDim.new(1, 0)

    TweenService:Create(toast,
        TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, 0, 0, 12)}
    ):Play()

    TweenService:Create(progressBar,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        {Size = UDim2.fromScale(0, 1)}
    ):Play()

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
            {Position = UDim2.new(0.5, 0, 0, -90), BackgroundTransparency = 1}
        ):Play()
        task.delay(0.4, function()
            if toast.Parent then toast:Destroy() end
            if onDone then onDone() end
        end)
    end)
end

-- ══════════════════════════════════════
-- المحتوى الرئيسي — FULLSCREEN
-- ══════════════════════════════════════
local mainContent                  = Instance.new("Frame")
mainContent.Size                   = UDim2.fromScale(1, 1)
mainContent.Position               = UDim2.fromScale(0, 0)
mainContent.BackgroundTransparency = 1
mainContent.Visible                = false
mainContent.Parent                 = gui

-- ══════════════════════════════════════
-- ❌ تم حذف الخطوط الجانبية الستة
-- ══════════════════════════════════════

-- ══════════════════════════════════════
-- 🎬 Vignette عند المراقبة
-- ══════════════════════════════════════
local vignette                  = Instance.new("Frame")
vignette.Size                   = UDim2.fromScale(1, 1)
vignette.BackgroundTransparency = 1
vignette.BorderSizePixel        = 0
vignette.ZIndex                 = 2
vignette.Visible                = false
vignette.Parent                 = gui

local function makeEdge(ancX, ancY, sX, sY, posX, posY, rot)
    local e                  = Instance.new("Frame")
    e.AnchorPoint            = Vector2.new(ancX, ancY)
    e.Size                   = UDim2.fromScale(sX, sY)
    e.Position               = UDim2.fromScale(posX, posY)
    e.BackgroundColor3       = Color3.fromRGB(0, 5, 20)
    e.BackgroundTransparency = 0.3
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
makeEdge(0,0, 1,0.20, 0,0,   90)
makeEdge(0,1, 1,0.20, 0,1,  270)
makeEdge(0,0, 0.14,1, 0,0,    0)
makeEdge(1,0, 0.14,1, 1,0,  180)

local scanOverlay                  = Instance.new("Frame")
scanOverlay.Size                   = UDim2.fromScale(1, 0.003)
scanOverlay.BackgroundColor3       = C_CYAN
scanOverlay.BackgroundTransparency = 0.75
scanOverlay.BorderSizePixel        = 0
scanOverlay.ZIndex                 = 3
scanOverlay.Visible                = false
scanOverlay.Parent                 = gui

local spectateLabel                  = Instance.new("TextLabel")
spectateLabel.Size                   = UDim2.fromScale(0.35, 0.055)
spectateLabel.Position               = UDim2.fromScale(0.325, 0.015)
spectateLabel.BackgroundTransparency = 1
spectateLabel.TextScaled             = true
spectateLabel.Text                   = ""
spectateLabel.Font                   = Enum.Font.GothamBold
spectateLabel.TextColor3             = C_CYAN
spectateLabel.ZIndex                 = 4
spectateLabel.Visible                = false
spectateLabel.Parent                 = gui

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
-- 🎯 الأيقونة 44×44 — تلوين أزرق فاتح وأبيض
-- ══════════════════════════════════════
local iconFrame              = Instance.new("Frame")
iconFrame.Size               = UDim2.fromOffset(ICON_SIZE, ICON_SIZE)
iconFrame.Position           = UDim2.new(ICON_X, 0, ICON_Y, -ICON_SIZE/2)
iconFrame.BackgroundColor3   = Color3.fromRGB(140, 210, 255)  -- أزرق فاتح كخلفية
iconFrame.BorderSizePixel    = 0
iconFrame.ZIndex             = 6
iconFrame.ClipsDescendants   = true
iconFrame.Parent             = mainContent
Instance.new("UICorner", iconFrame).CornerRadius = UDim.new(0, 10)

local iconStroke             = Instance.new("UIStroke", iconFrame)
iconStroke.Thickness         = 2
iconStroke.Color             = C_BLUE1

-- ✅ تدرج أزرق فاتح → أبيض بدل الصورة
local iconGrad               = Instance.new("UIGradient", iconFrame)
iconGrad.Color               = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(100, 190, 255)),  -- أزرق فاتح
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 225, 255)),  -- أزرق فاتح جداً
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 255, 255))   -- أبيض
}
iconGrad.Rotation = 135

-- بريق أبيض في المنتصف (shimmer layer)
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

-- ══════════════════════════════════════
-- أزرار التنقل — وسط الشاشة أسفل
-- ══════════════════════════════════════
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

-- ══════════════════════════════════════
-- تأثيرات المراقبة
-- ══════════════════════════════════════
local scanOverlayY = 0
local function updateSpectateEffects(t, targetName)
    vignette.Visible      = true
    scanOverlay.Visible   = true
    spectateLabel.Visible = true
    spectateLabel.Text    = "👁️  " .. (targetName or "") .. "  |  LIVE"
    local pulse = (math.sin(t*3)+1)/2
    spectateLabel.TextColor3 = C_CYAN:Lerp(C_WHITE, pulse)
    scanOverlayY = scanOverlayY + 0.002
    if scanOverlayY > 1 then scanOverlayY = 0 end
    scanOverlay.Position = UDim2.fromScale(0, scanOverlayY)
end

local function hideSpectateEffects()
    vignette.Visible      = false
    scanOverlay.Visible   = false
    spectateLabel.Visible = false
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
             BackgroundTransparency=1, Size=UDim2.fromOffset(1,1)}
        ):Play()
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

        -- تحديث تلوين الأيقونة: نبضة أزرق فاتح ↔ أبيض
        iconGrad.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0,   Color3.fromRGB(
                math.floor(80  + wave * 60),
                math.floor(170 + wave * 50),
                255
            )),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(
                math.floor(160 + wave * 60),
                math.floor(210 + wave * 35),
                255
            )),
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
            guiVisible      = false
            mainContent.Position = UDim2.fromScale(0,0)
            stopSpectate()
            hideSpectateEffects()
        end)
    else
        prev.Visible    = true
        nxt.Visible     = true
        nameLbl.Visible = true
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
    if codeBox.Text == REQUIRED_CODE then
        isVerified        = true
        codeFrame.Visible = false

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
        codeErrLbl.Text = "❌ كود خاطئ!"
        for i = 1, 6 do
            task.wait(0.05)
            codeFrame.Position = UDim2.fromScale(0.31+(i%2==0 and 0.008 or -0.008),0.35)
        end
        codeFrame.Position = UDim2.fromScale(0.31,0.35)
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
    else
        if idx > #newList then idx = 1 end
        spectating = true
    end
end)

lp.CharacterAdded:Connect(function()
    task.wait(0.5)
    if isVerified then startMainLoop() end
end)