-- ================================================================
-- الدخولية
-- ================================================================
local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService   = game:GetService("RunService")
local LocalPlayer  = Players.LocalPlayer
local PlayerGui    = LocalPlayer:WaitForChild("PlayerGui")

local function tw(obj, t, style, dir, props)
    local ti = TweenInfo.new(t, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
    TweenService:Create(obj, ti, props):Play()
end

local function playClick()
    local s = Instance.new("Sound")
    s.SoundId  = "rbxassetid://6042053626"
    s.Volume   = 0.5
    s.RollOffMaxDistance = 0
    s.Parent   = PlayerGui
    s:Play()
    game:GetService("Debris"):AddItem(s, 2)
end

local function silverPulse(t, speed, minV, maxV)
    local v = minV + (maxV - minV) * (0.5 + 0.5 * math.sin(t * speed))
    return Color3.fromRGB(v, v, v)
end

-- ================================================================
-- موسيقى الفونك - تشتغل من البداية
-- ================================================================
local Music = Instance.new("Sound")
Music.SoundId  = "rbxassetid://105840902987664"
Music.Volume   = 0.7
Music.Looped   = true
Music.RollOffMaxDistance = 0
Music.Parent   = PlayerGui
Music:Play()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "Y"
ScreenGui.ResetOnSpawn   = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder   = 9999
ScreenGui.Parent         = PlayerGui

local BG = Instance.new("Frame")
BG.Size                   = UDim2.fromScale(1, 1)
BG.BackgroundColor3       = Color3.fromRGB(0, 0, 0)
BG.BackgroundTransparency = 0
BG.BorderSizePixel        = 0
BG.ZIndex                 = 1
BG.Parent                 = ScreenGui

local BGGrad = Instance.new("UIGradient")
BGGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,    Color3.fromRGB(0,   0,   0  )),
    ColorSequenceKeypoint.new(0.38, Color3.fromRGB(0,   0,   0  )),
    ColorSequenceKeypoint.new(0.55, Color3.fromRGB(60,  60,  60 )),
    ColorSequenceKeypoint.new(0.72, Color3.fromRGB(140, 140, 140)),
    ColorSequenceKeypoint.new(0.88, Color3.fromRGB(210, 210, 210)),
    ColorSequenceKeypoint.new(1,    Color3.fromRGB(255, 255, 255)),
})
BGGrad.Rotation = 135
BGGrad.Parent   = BG

local Flash = Instance.new("Frame")
Flash.Size                   = UDim2.fromScale(1, 1)
Flash.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
Flash.BackgroundTransparency = 0
Flash.BorderSizePixel        = 0
Flash.ZIndex                 = 60
Flash.Parent                 = BG

local Scan = Instance.new("Frame")
Scan.Size             = UDim2.new(1, 0, 0, 2)
Scan.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Scan.BackgroundTransparency = 0.6
Scan.BorderSizePixel  = 0
Scan.ZIndex           = 20
Scan.Parent           = BG
local ScanGrad = Instance.new("UIGradient")
ScanGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,    Color3.fromRGB(0,0,0)),
    ColorSequenceKeypoint.new(0.15, Color3.fromRGB(180,180,180)),
    ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(0.85, Color3.fromRGB(180,180,180)),
    ColorSequenceKeypoint.new(1,    Color3.fromRGB(0,0,0)),
})
ScanGrad.Parent = Scan

local TitleFrame = Instance.new("Frame")
TitleFrame.Size                   = UDim2.fromOffset(500, 120)
TitleFrame.Position               = UDim2.fromScale(0.5, 0.5)
TitleFrame.AnchorPoint            = Vector2.new(0.5, 0.5)
TitleFrame.BackgroundTransparency = 1
TitleFrame.BorderSizePixel        = 0
TitleFrame.ZIndex                 = 5
TitleFrame.Parent                 = BG

local SubTitle = Instance.new("TextLabel")
SubTitle.Size                   = UDim2.fromOffset(500, 22)

SubTitle.Position               = UDim2.new(0.5, 0, 0, 0)
SubTitle.AnchorPoint            = Vector2.new(0.5, 0)
SubTitle.BackgroundTransparency = 1
SubTitle.Font                   = Enum.Font.GothamBold
SubTitle.TextSize               = 11
SubTitle.TextColor3             = Color3.fromRGB(160, 160, 160)
SubTitle.Text                   = "··?··"
SubTitle.TextTransparency       = 1
SubTitle.ZIndex                 = 7
SubTitle.Parent                 = TitleFrame

local MainTitle = Instance.new("TextLabel")
MainTitle.Size                   = UDim2.fromOffset(500, 56)
MainTitle.Position               = UDim2.new(0.5, 0, 0, 22)
MainTitle.AnchorPoint            = Vector2.new(0.5, 0)
MainTitle.BackgroundTransparency = 1
MainTitle.Font                   = Enum.Font.GothamBlack
MainTitle.TextSize               = 42
MainTitle.TextColor3             = Color3.fromRGB(255, 255, 255)
MainTitle.Text                   = "Y·H"
MainTitle.TextTransparency       = 1
MainTitle.ZIndex                 = 7
MainTitle.Parent                 = TitleFrame

local TitleGrad = Instance.new("UIGradient")
TitleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,    Color3.fromRGB(120, 120, 120)),
    ColorSequenceKeypoint.new(0.3,  Color3.fromRGB(220, 220, 220)),
    ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.7,  Color3.fromRGB(220, 220, 220)),
    ColorSequenceKeypoint.new(1,    Color3.fromRGB(120, 120, 120)),
})
TitleGrad.Parent = MainTitle

local VerLabel = Instance.new("TextLabel")
VerLabel.Size                   = UDim2.fromOffset(500, 18)
VerLabel.Position               = UDim2.new(0.5, 0, 0, 80)
VerLabel.AnchorPoint            = Vector2.new(0.5, 0)
VerLabel.BackgroundTransparency = 1
VerLabel.Font                   = Enum.Font.Gotham
VerLabel.TextSize               = 9
VerLabel.TextColor3             = Color3.fromRGB(90, 90, 90)
VerLabel.Text                   = "VOP"
VerLabel.TextTransparency       = 1
VerLabel.ZIndex                 = 7
VerLabel.Parent                 = TitleFrame

local Brand = Instance.new("TextLabel")
Brand.Size                   = UDim2.fromOffset(300, 18)
Brand.Position               = UDim2.new(0.5, 0, 1, -22)
Brand.AnchorPoint            = Vector2.new(0.5, 1)
Brand.BackgroundTransparency = 1
Brand.Font                   = Enum.Font.Gotham
Brand.TextSize               = 9
Brand.TextColor3             = Color3.fromRGB(80, 80, 80)
Brand.Text                   = "Hassan"
Brand.TextTransparency       = 1
Brand.ZIndex                 = 12
Brand.Parent                 = BG
task.delay(2.2, function()
    tw(Brand, 0.7, nil, nil, {TextTransparency = 0.35})
end)

local ok, thumbUrl = pcall(function()
    return Players:GetUserThumbnailAsync(
        LocalPlayer.UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size420x420
    )
end)

local RightPanel = Instance.new("Frame")
RightPanel.Size                   = UDim2.fromOffset(220, 280)
RightPanel.Position               = UDim2.new(1, 90, 0.5, 0)
RightPanel.AnchorPoint            = Vector2.new(1, 0.5)
RightPanel.BackgroundColor3       = Color3.fromRGB(4, 4, 4)
RightPanel.BackgroundTransparency = 1
RightPanel.BorderSizePixel        = 0
RightPanel.ZIndex                 = 12
RightPanel.Parent                 = BG
Instance.new("UICorner", RightPanel).CornerRadius = UDim.new(0, 16)

local RPStroke = Instance.new("UIStroke")
RPStroke.Color        = Color3.fromRGB(220, 220, 220)
RPStroke.Thickness    = 1.5
RPStroke.Transparency = 1
RPStroke.Parent       = RightPanel

local RPGrad = Instance.new("UIGradient")
RPGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(26, 26, 26)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 10, 10)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(2,  2,  2 )),
})
RPGrad.Rotation = 120
RPGrad.Parent   = RightPanel

local RPShine = Instance.new("Frame")
RPShine.Size                   = UDim2.new(1, 0, 0.45, 0)
RPShine.Position               = UDim2.fromScale(0, 0)
RPShine.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
RPShine.BackgroundTransparency = 0.96
RPShine.BorderSizePixel        = 0
RPShine.ZIndex                 = 12
RPShine.Parent                 = RightPanel
Instance.new("UICorner", RPShine).CornerRadius = UDim.new(0, 16)

local RPGlow = Instance.new("Frame")
RPGlow.Size                   = UDim2.fromOffset(114, 114)
RPGlow.Position               = UDim2.new(0.5, 0, 0, 18)
RPGlow.AnchorPoint            = Vector2.new(0.5, 0)
RPGlow.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
RPGlow.BackgroundTransparency = 0.80
RPGlow.BorderSizePixel        = 0
RPGlow.ZIndex                 = 12
RPGlow.Parent                 = RightPanel
Instance.new("UICorner", RPGlow).CornerRadius = UDim.new(1, 0)

local RPAvatarRing = Instance.new("Frame")
RPAvatarRing.Size                   = UDim2.fromOffset(102, 102)
RPAvatarRing.Position               = UDim2.new(0.5, 0, 0, 24)
RPAvatarRing.AnchorPoint            = Vector2.new(0.5, 0)
RPAvatarRing.BackgroundColor3       = Color3.fromRGB(210, 210, 210)
RPAvatarRing.BackgroundTransparency = 0.3
RPAvatarRing.BorderSizePixel        = 0
RPAvatarRing.ZIndex                 = 13
RPAvatarRing.Parent                 = RightPanel
Instance.new("UICorner", RPAvatarRing).CornerRadius = UDim.new(1, 0)

local RPAvatarBG = Instance.new("Frame")
RPAvatarBG.Size                   = UDim2.fromOffset(93, 93)
RPAvatarBG.Position               = UDim2.fromScale(0.5, 0.5)
RPAvatarBG.AnchorPoint            = Vector2.new(0.5, 0.5)
RPAvatarBG.BackgroundColor3       = Color3.fromRGB(5, 5, 5)
RPAvatarBG.BackgroundTransparency = 0
RPAvatarBG.BorderSizePixel        = 0
RPAvatarBG.ZIndex                 = 14
RPAvatarBG.Parent                 = RPAvatarRing
Instance.new("UICorner", RPAvatarBG).CornerRadius = UDim.new(1, 0)

local RPAvatarImg = Instance.new("ImageLabel")
RPAvatarImg.Size                   = UDim2.fromScale(1, 1)
RPAvatarImg.BackgroundTransparency = 1
RPAvatarImg.Image                  = ok and thumbUrl or ""
RPAvatarImg.ZIndex                 = 15
RPAvatarImg.Parent                 = RPAvatarBG
Instance.new("UICorner", RPAvatarImg).CornerRadius = UDim.new(1, 0)

local RPDiv = Instance.new("Frame")
RPDiv.Size             = UDim2.new(0.72, 0, 0, 1)
RPDiv.Position         = UDim2.new(0.5, 0, 0, 140)
RPDiv.AnchorPoint      = Vector2.new(0.5, 0)
RPDiv.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RPDiv.BackgroundTransparency = 0.45
RPDiv.BorderSizePixel  = 0
RPDiv.ZIndex           = 13
RPDiv.Parent           = RightPanel
local RPDivGrad = Instance.new("UIGradient")
RPDivGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(0,0,0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(0,0,0)),
})
RPDivGrad.Parent = RPDiv

local RPName = Instance.new("TextLabel")
RPName.Size                   = UDim2.new(1, -16, 0, 30)
RPName.Position               = UDim2.new(0.5, 0, 0, 152)
RPName.AnchorPoint            = Vector2.new(0.5, 0)
RPName.BackgroundTransparency = 1
RPName.Font                   = Enum.Font.GothamBold
RPName.TextSize               = 17
RPName.TextColor3             = Color3.fromRGB(255, 255, 255)
RPName.Text                   = LocalPlayer.DisplayName
RPName.TextXAlignment         = Enum.TextXAlignment.Center
RPName.ZIndex                 = 13
RPName.Parent                 = RightPanel

local RPUser = Instance.new("TextLabel")
RPUser.Size                   = UDim2.new(1, -16, 0, 18)
RPUser.Position               = UDim2.new(0.5, 0, 0, 184)
RPUser.AnchorPoint            = Vector2.new(0.5, 0)
RPUser.BackgroundTransparency = 1

RPUser.Font                   = Enum.Font.Gotham
RPUser.TextSize               = 11
RPUser.TextColor3             = Color3.fromRGB(150, 150, 150)
RPUser.Text                   = "@" .. LocalPlayer.Name
RPUser.TextXAlignment         = Enum.TextXAlignment.Center
RPUser.ZIndex                 = 13
RPUser.Parent                 = RightPanel

local RPBadge = Instance.new("Frame")
RPBadge.Size                   = UDim2.fromOffset(92, 22)
RPBadge.Position               = UDim2.new(0.5, 0, 0, 216)
RPBadge.AnchorPoint            = Vector2.new(0.5, 0)
RPBadge.BackgroundColor3       = Color3.fromRGB(16, 16, 16)
RPBadge.BackgroundTransparency = 0
RPBadge.BorderSizePixel        = 0
RPBadge.ZIndex                 = 13
RPBadge.Parent                 = RightPanel
Instance.new("UICorner", RPBadge).CornerRadius = UDim.new(0, 6)
local RPBadgeStroke = Instance.new("UIStroke")
RPBadgeStroke.Color       = Color3.fromRGB(200, 200, 200)
RPBadgeStroke.Thickness   = 1
RPBadgeStroke.Transparency = 0.4
RPBadgeStroke.Parent      = RPBadge

local RPBadgeLbl = Instance.new("TextLabel")
RPBadgeLbl.Size                   = UDim2.fromScale(1, 1)
RPBadgeLbl.BackgroundTransparency = 1
RPBadgeLbl.Font                   = Enum.Font.GothamBold
RPBadgeLbl.TextSize               = 8
RPBadgeLbl.TextColor3             = Color3.fromRGB(200, 200, 200)
RPBadgeLbl.Text                   = "◈  PLAYER"
RPBadgeLbl.TextXAlignment         = Enum.TextXAlignment.Center
RPBadgeLbl.ZIndex                 = 14
RPBadgeLbl.Parent                 = RPBadge

local LeftPanel = Instance.new("Frame")
LeftPanel.Size                   = UDim2.fromOffset(210, 160)
LeftPanel.Position               = UDim2.new(0, -90, 0.5, 0)
LeftPanel.AnchorPoint            = Vector2.new(0, 0.5)
LeftPanel.BackgroundColor3       = Color3.fromRGB(4, 4, 4)
LeftPanel.BackgroundTransparency = 1
LeftPanel.BorderSizePixel        = 0
LeftPanel.ZIndex                 = 12
LeftPanel.Parent                 = BG
Instance.new("UICorner", LeftPanel).CornerRadius = UDim.new(0, 16)

local LPStroke = Instance.new("UIStroke")
LPStroke.Color        = Color3.fromRGB(220, 220, 220)
LPStroke.Thickness    = 1.5
LPStroke.Transparency = 1
LPStroke.Parent       = LeftPanel

local LPGrad = Instance.new("UIGradient")
LPGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(26, 26, 26)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 10, 10)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(2,  2,  2 )),
})
LPGrad.Rotation = 120
LPGrad.Parent   = LeftPanel

local LPShine = Instance.new("Frame")
LPShine.Size                   = UDim2.new(1, 0, 0.45, 0)
LPShine.Position               = UDim2.fromScale(0, 0)
LPShine.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
LPShine.BackgroundTransparency = 0.96
LPShine.BorderSizePixel        = 0
LPShine.ZIndex                 = 12
LPShine.Parent                 = LeftPanel
Instance.new("UICorner", LPShine).CornerRadius = UDim.new(0, 16)

local LPTitle = Instance.new("TextLabel")
LPTitle.Size                   = UDim2.new(1, 0, 0, 22)
LPTitle.Position               = UDim2.new(0.5, 0, 0, 13)
LPTitle.AnchorPoint            = Vector2.new(0.5, 0)
LPTitle.BackgroundTransparency = 1
LPTitle.Font                   = Enum.Font.GothamBold
LPTitle.TextSize               = 9
LPTitle.TextColor3             = Color3.fromRGB(130, 130, 130)
LPTitle.Text                   = "◈  CONTROL PANEL"
LPTitle.TextXAlignment         = Enum.TextXAlignment.Center
LPTitle.ZIndex                 = 13
LPTitle.Parent                 = LeftPanel

local LPDiv = Instance.new("Frame")
LPDiv.Size             = UDim2.new(0.78, 0, 0, 1)
LPDiv.Position         = UDim2.new(0.5, 0, 0, 38)
LPDiv.AnchorPoint      = Vector2.new(0.5, 0)
LPDiv.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LPDiv.BackgroundTransparency = 0.55
LPDiv.BorderSizePixel  = 0
LPDiv.ZIndex           = 13
LPDiv.Parent           = LeftPanel
local LPDivGrad = Instance.new("UIGradient")
LPDivGrad.Color = RPDivGrad.Color
LPDivGrad.Parent = LPDiv

local BtnOpen = Instance.new("TextButton")
BtnOpen.Size                   = UDim2.new(1, -22, 0, 54)
BtnOpen.Position               = UDim2.new(0.5, 0, 0, 48)
BtnOpen.AnchorPoint            = Vector2.new(0.5, 0)
BtnOpen.BackgroundColor3       = Color3.fromRGB(238, 238, 238)
BtnOpen.BackgroundTransparency = 0
BtnOpen.BorderSizePixel        = 0
BtnOpen.Font                   = Enum.Font.GothamBold
BtnOpen.TextSize               = 13
BtnOpen.TextColor3             = Color3.fromRGB(0, 0, 0)
BtnOpen.Text                   = "▶   فتح السكربت"
BtnOpen.ZIndex                 = 14
BtnOpen.Parent                 = LeftPanel
Instance.new("UICorner", BtnOpen).CornerRadius = UDim.new(0, 10)

local BtnOpenStroke = Instance.new("UIStroke")
BtnOpenStroke.Color        = Color3.fromRGB(210, 210, 210)
BtnOpenStroke.Thickness    = 1.8
BtnOpenStroke.Transparency = 0.2
BtnOpenStroke.Parent       = BtnOpen

local BtnOpenGrad = Instance.new("UIGradient")
BtnOpenGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(238, 238, 238)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(205, 205, 205)),
})
BtnOpenGrad.Rotation = 90
BtnOpenGrad.Parent   = BtnOpen

local BtnOpenShine = Instance.new("Frame")
BtnOpenShine.Size                   = UDim2.new(0.28, 0, 1, 0)
BtnOpenShine.Position               = UDim2.fromScale(-0.32, 0)
BtnOpenShine.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
BtnOpenShine.BackgroundTransparency = 0.55
BtnOpenShine.BorderSizePixel        = 0
BtnOpenShine.ClipsDescendants       = false
BtnOpenShine.ZIndex                 = 15
BtnOpenShine.Parent                 = BtnOpen
Instance.new("UICorner", BtnOpenShine).CornerRadius = UDim.new(0, 10)
local BtnOpenShineGrad = Instance.new("UIGradient")
BtnOpenShineGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(0,0,0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(0,0,0)),
})
BtnOpenShineGrad.Parent = BtnOpenShine

local BtnClose = Instance.new("TextButton")
BtnClose.Size                   = UDim2.new(1, -22, 0, 36)
BtnClose.Position               = UDim2.new(0.5, 0, 0, 112)
BtnClose.AnchorPoint            = Vector2.new(0.5, 0)
BtnClose.BackgroundColor3       = Color3.fromRGB(12, 12, 12)
BtnClose.BackgroundTransparency = 0
BtnClose.BorderSizePixel        = 0
BtnClose.Font                   = Enum.Font.GothamBold
BtnClose.TextSize               = 11
BtnClose.TextColor3             = Color3.fromRGB(185, 185, 185)
BtnClose.Text                   = "✕   غلاق"
BtnClose.ZIndex                 = 14
BtnClose.Parent                 = LeftPanel
Instance.new("UICorner", BtnClose).CornerRadius = UDim.new(0, 10)

local BtnCloseStroke = Instance.new("UIStroke")
BtnCloseStroke.Color       = Color3.fromRGB(160, 160, 160)
BtnCloseStroke.Thickness   = 1
BtnCloseStroke.Transparency = 0.45
BtnCloseStroke.Parent      = BtnClose

BtnOpen.MouseEnter:Connect(function()
    playClick()
    tw(BtnOpen, 0.12, nil, nil, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
end)
BtnOpen.MouseLeave:Connect(function()
    tw(BtnOpen, 0.12, nil, nil, {BackgroundColor3 = Color3.fromRGB(238, 238, 238)})
end)

BtnClose.MouseEnter:Connect(function()
    playClick()
    tw(BtnClose, 0.12, nil, nil, {BackgroundColor3 = Color3.fromRGB(28, 28, 28)})
    tw(BtnCloseStroke, 0.12, nil, nil, {Transparency = 0.15})
end)
BtnClose.MouseLeave:Connect(function()
    tw(BtnClose, 0.12, nil, nil, {BackgroundColor3 = Color3.fromRGB(12, 12, 12)})
    tw(BtnCloseStroke, 0.12, nil, nil, {Transparency = 0.45})
end)

local alive      = true
local scriptUsed = false
local startT     = tick()
local shineX     = -0.35

local function doExit()
    alive = false

tw(BG,        0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.In, {BackgroundTransparency = 1})
    tw(Scan,      0.3,  nil, nil, {BackgroundTransparency = 1})
    tw(Brand,     0.3,  nil, nil, {TextTransparency = 1})
    tw(MainTitle, 0.3,  nil, nil, {TextTransparency = 1})
    tw(SubTitle,  0.3,  nil, nil, {TextTransparency = 1})
    tw(VerLabel,  0.3,  nil, nil, {TextTransparency = 1})
    tw(RightPanel, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In,
        {Position = UDim2.new(1, 90, 0.5, 0), BackgroundTransparency = 1})
    tw(LeftPanel,  0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In,
        {Position = UDim2.new(0, -90, 0.5, 0), BackgroundTransparency = 1})

    task.delay(0.75, function()
        ScreenGui:Destroy()
        -- ================================================================
        -- تشغيل السكربت الرئيسي بعد الدخولية
        -- ================================================================
        local ok2, Library = pcall(function()
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/mmnnnnn460-byte/LOPLNN/refs/heads/main/library_merged.lua"))()
        end)

        if not ok2 or not Library then
            warn("فشل تحميل المكتبة")
            return
        end

        local Window = Library:MakeWindow({
            Title = " NAR | V3.0",
            SubTitle = "Brookhaven RP",
            LoadText = "Loading...",
            Flags = "koSettings"
        })

        task.wait(1)

        local SGui = game:GetService("CoreGui"):FindFirstChild("LOPKCyanLib")
        if SGui then
            local MainFrame = SGui:FindFirstChild("Hub")
            if MainFrame then
                MainFrame.BackgroundTransparency = 1
                local NarBG = Instance.new("ImageLabel")
                NarBG.Name = "NarCustomBackground"
                NarBG.Parent = MainFrame
                NarBG.Size = UDim2.new(1, 0, 1, 0)
                NarBG.Position = UDim2.new(0, 0, 0, 0)
                NarBG.BackgroundTransparency = 1
                NarBG.Image = "rbxassetid://88848481844181"
                NarBG.ImageTransparency = 0
                NarBG.ScaleType = Enum.ScaleType.Stretch
                NarBG.ZIndex = -1
                Instance.new("UICorner", NarBG).CornerRadius = UDim.new(0, 10)
            end
        end

        local Tab = Window:MakeTab({ Title = "حقوق مطورين", Icon = "rbxassetid://10747830374" })
        local Container = Tab.Cont
        local Players2 = game:GetService("Players")

        local function AnimateBorder(stroke)
            task.spawn(function()
                local angle = 0
                while stroke and stroke.Parent do
                    angle = (angle + 3) % 360
                    local wave = (math.sin(math.rad(angle)) + 1) / 2
                    local b = math.floor(wave * 255)
                    pcall(function() stroke.Color = Color3.fromRGB(b, b, b) end)
                    task.wait(0.04)
                end
            end)
        end

        local function CreateCard(username, displayName, role, roleColor, fixedImage, noAvatar)
            local Card = Instance.new("Frame")
            Card.Size = UDim2.new(1, 0, 0, 110)
            Card.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
            Card.BackgroundTransparency = 0.2
            Card.BorderSizePixel = 0
            Card.Name = "Option"
            Card.Parent = Container
            Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)

            local CS = Instance.new("UIStroke", Card)
            CS.Thickness = 1.5
            CS.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            AnimateBorder(CS)

            local AvatarFrame = Instance.new("Frame")
            AvatarFrame.Size = UDim2.new(0, 72, 0, 72)
            AvatarFrame.Position = UDim2.new(0, 12, 0.5, 0)

AvatarFrame.AnchorPoint = Vector2.new(0, 0.5)
            AvatarFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
            AvatarFrame.BorderSizePixel = 0
            AvatarFrame.Parent = Card
            Instance.new("UICorner", AvatarFrame).CornerRadius = UDim.new(0, 8)

            local AS = Instance.new("UIStroke", AvatarFrame)
            AS.Thickness = 2
            AS.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            AnimateBorder(AS)

            local Avatar = Instance.new("ImageLabel")
            Avatar.Size = UDim2.new(1, -4, 1, -4)
            Avatar.Position = UDim2.new(0, 2, 0, 2)
            Avatar.BackgroundTransparency = 1
            Avatar.Image = fixedImage or ""
            Avatar.ScaleType = Enum.ScaleType.Fit
            Avatar.Parent = AvatarFrame
            Instance.new("UICorner", Avatar).CornerRadius = UDim.new(0, 6)

            local N = Instance.new("TextLabel")
            N.Size = UDim2.new(1, -100, 0, 22)
            N.Position = UDim2.new(0, 95, 0, 14)
            N.BackgroundTransparency = 1
            N.Text = displayName
            N.TextColor3 = Color3.fromRGB(255, 255, 255)
            N.Font = Enum.Font.GothamBold
            N.TextSize = 13
            N.TextXAlignment = Enum.TextXAlignment.Left
            N.Parent = Card

            local U = Instance.new("TextLabel")
            U.Size = UDim2.new(1, -100, 0, 16)
            U.Position = UDim2.new(0, 95, 0, 37)
            U.BackgroundTransparency = 1
            U.Text = "@" .. username
            U.TextColor3 = Color3.fromRGB(170, 170, 170)
            U.Font = Enum.Font.Gotham
            U.TextSize = 10
            U.TextXAlignment = Enum.TextXAlignment.Left
            U.Parent = Card

            local R = Instance.new("TextLabel")
            R.Size = UDim2.new(1, -100, 0, 16)
            R.Position = UDim2.new(0, 95, 0, 54)
            R.BackgroundTransparency = 1
            R.Text = role
            R.TextColor3 = roleColor
            R.Font = Enum.Font.GothamMedium
            R.TextSize = 10
            R.TextXAlignment = Enum.TextXAlignment.Left
            R.Parent = Card

            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(0, 85, 0, 24)
            Btn.Position = UDim2.new(0, 95, 0, 74)
            Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Btn.BorderSizePixel = 0
            Btn.Text = "📋 نسخ اليوزر"
            Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
            Btn.Font = Enum.Font.GothamMedium
            Btn.TextSize = 10
            Btn.AutoButtonColor = false
            Btn.Parent = Card
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 5)

            local BS = Instance.new("UIStroke", Btn)
            BS.Thickness = 1
            BS.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            AnimateBorder(BS)

            Btn.MouseButton1Click:Connect(function()
                pcall(function() setclipboard(username) end)
                Btn.Text = "✅ تم النسخ!"
                Btn.BackgroundColor3 = Color3.fromRGB(0, 110, 0)
                task.wait(1.5)
                Btn.Text = "📋 نسخ اليوزر"
                Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            end)

            if not noAvatar and (not fixedImage or fixedImage == "") then
                task.spawn(function()
                    local o, uid = pcall(function() return Players2:GetUserIdFromNameAsync(username) end)
                    if o and uid then
                        local o2, thumb = pcall(function()
                            return Players2:GetUserThumbnailAsync(uid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
                        end)
                        if o2 and thumb then Avatar.Image = thumb end
                    end
                end)
            end
        end

Tab:AddSection("⭐ يوزر تيك")
        CreateCard("1xt86",   "1xt86",   "⭐ يوزر تيك", Color3.fromRGB(100, 200, 255), nil, true)
        CreateCard("nar_0.6", "nar_0.6", "⭐ يوزر تيك", Color3.fromRGB(100, 200, 255), nil, true)

        Tab:AddSection("🔧 مطورين روبلوكس")
        CreateCard("mx091mi", "i2M",   "🔧 مطور روبلوكس", Color3.fromRGB(255, 165, 0), nil, false)
        CreateCard("xc_tth",  "Daffy", "🔧 مطور روبلوكس", Color3.fromRGB(255, 165, 0), nil, false)
    end)
end

BtnOpen.MouseButton1Click:Connect(function()
    if scriptUsed then return end
    scriptUsed = true
    playClick()
    tw(BtnOpen, 0.06, nil, nil, {BackgroundColor3 = Color3.fromRGB(160,160,160)})
    task.delay(0.06, function()
        tw(BtnOpen, 0.1, nil, nil, {BackgroundColor3 = Color3.fromRGB(255,255,255)})
    end)
    task.delay(0.35, function()
        doExit()
    end)
end)

BtnClose.MouseButton1Click:Connect(function()
    playClick()
    tw(BtnClose, 0.06, nil, nil, {BackgroundColor3 = Color3.fromRGB(50,50,50)})
    task.delay(0.06, function()
        tw(BtnClose, 0.1, nil, nil, {BackgroundColor3 = Color3.fromRGB(12,12,12)})
    end)
    task.delay(0.2, function()
        Music:Stop()
        Music:Destroy()
        doExit()
    end)
end)

tw(Flash, 0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {BackgroundTransparency = 1})

task.delay(1.0, function()
    tw(SubTitle,  0.55, nil, nil, {TextTransparency = 0.1})
    tw(MainTitle, 0.55, nil, nil, {TextTransparency = 0})
    tw(VerLabel,  0.55, nil, nil, {TextTransparency = 0.5})
end)

task.delay(1.4, function()
    tw(RightPanel, 0.58, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {
        Position = UDim2.new(1, -44, 0.5, 0),
        BackgroundTransparency = 0,
    })
    RPStroke.Transparency = 0.3
end)

task.delay(1.7, function()
    tw(LeftPanel, 0.58, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {
        Position = UDim2.new(0, 44, 0.5, 0),
        BackgroundTransparency = 0,
    })
    LPStroke.Transparency = 0.3
    playClick()
end)

local conn
conn = RunService.RenderStepped:Connect(function(dt)
    if not alive then conn:Disconnect() return end

    local t = tick() - startT

    local sy = (t % 3.5) / 3.5
    Scan.Position               = UDim2.fromScale(0, sy)
    Scan.BackgroundTransparency = 0.45 + sy * 0.5

    local strokeColor = silverPulse(t, 1.9, 155, 245)
    RPStroke.Color = strokeColor
    LPStroke.Color = strokeColor

    shineX = shineX + dt * 0.52
    if shineX > 1.35 then shineX = -0.35 end
    BtnOpenShine.Position = UDim2.fromScale(shineX, 0)

    local titleOffset = (t * 0.22) % 1
    TitleGrad.Offset = Vector2.new(math.sin(titleOffset * math.pi * 2) * 0.35, 0)

    RPAvatarRing.BackgroundColor3 = silverPulse(t, 2.1, 155, 225)
    RPAvatarRing.BackgroundTransparency = 0.28 + math.sin(t * 2.1) * 0.14

    RPGlow.BackgroundTransparency = 0.76 + math.sin(t * 1.8) * 0.09

    local badgePulse = silverPulse(t, 1.3, 150, 220)
    RPBadgeStroke.Color = badgePulse

    BtnOpenStroke.Color = silverPulse(t, 1.9, 170, 255)

    local bgShift = 0.5 + 0.5 * math.sin(t * 0.4)
    BGGrad.Rotation = 135 + bgShift * 8
end)