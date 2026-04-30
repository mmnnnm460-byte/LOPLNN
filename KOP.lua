-- ║         LOPK Library  |  Pink & Purple Edition     ║
-- ║         Theme: Neon Pink / Deep Purple             ║
-- ║         Version: 2.0.0                             ║

local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService   = game:GetService("UserInputService")
local TweenService       = game:GetService("TweenService")
local HttpService        = game:GetService("HttpService")
local RunService         = game:GetService("RunService")
local CoreGui            = game:GetService("CoreGui")
local Players            = game:GetService("Players")
local Player             = Players.LocalPlayer
local PlayerMouse        = Player:GetMouse()

local lopklib = {
 Themes = {
  Darker = {
   ["Color Hub 1"]      = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(20, 0, 20)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(40, 0, 40)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(20, 0, 20))
   }),
   ["Color Hub 2"]      = Color3.fromRGB(30, 0, 30),
   ["Color Stroke"]     = Color3.fromRGB(255, 0, 255), -- وردي
   ["Color Theme"]      = Color3.fromRGB(255, 20, 147), -- وردي فاقع
   ["Color Text"]       = Color3.fromRGB(255, 200, 255),
   ["Color Dark Text"]  = Color3.fromRGB(200, 100, 200),
   ["Color Dark Purple"]= Color3.fromRGB(128, 0, 128),
   ["Color Hub 9"]      = Color3.fromRGB(15, 0, 15),
   ["Color Dark Greem"] = Color3.fromRGB(255, 100, 255)
  },
  Dark = {
   ["Color Hub 1"]      = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(25, 0, 25)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(45, 0, 45)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(25, 0, 25))
   }),
   ["Color Hub 2"]      = Color3.fromRGB(35, 0, 35),
   ["Color Stroke"]     = Color3.fromRGB(255, 50, 255),
   ["Color Theme"]      = Color3.fromRGB(255, 0, 255),
   ["Color Text"]       = Color3.fromRGB(255, 255, 255),
   ["Color Dark Text"]  = Color3.fromRGB(220, 150, 220),
   ["Color Dark Purple"]= Color3.fromRGB(100, 0, 100),
   ["Color Hub 9"]      = Color3.fromRGB(10, 0, 10),
   ["Color Dark Greem"] = Color3.fromRGB(255, 50, 255)
  },
  Purple = {
   ["Color Hub 1"]      = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(30, 0, 50)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(60, 0, 100)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(30, 0, 50))
   }),
   ["Color Hub 2"]      = Color3.fromRGB(40, 0, 70),
   ["Color Stroke"]     = Color3.fromRGB(200, 0, 255),
   ["Color Theme"]      = Color3.fromRGB(180, 0, 255),
   ["Color Text"]       = Color3.fromRGB(255, 255, 255),
   ["Color Dark Text"]  = Color3.fromRGB(230, 180, 255),
   ["Color Dark Purple"]= Color3.fromRGB(80, 0, 150),
   ["Color Hub 9"]      = Color3.fromRGB(20, 0, 40),
   ["Color Dark Greem"] = Color3.fromRGB(220, 100, 255)
  },
  Neon = {
   ["Color Hub 1"]      = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(50, 0, 50)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(100, 0, 100)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(50, 0, 50))
   }),
   ["Color Hub 2"]      = Color3.fromRGB(60, 0, 60),
   ["Color Stroke"]     = Color3.fromRGB(255, 100, 255),
   ["Color Theme"]      = Color3.fromRGB(255, 50, 255),
   ["Color Text"]       = Color3.fromRGB(255, 255, 255),
   ["Color Dark Text"]  = Color3.fromRGB(255, 150, 255),
   ["Color Dark Purple"]= Color3.fromRGB(150, 0, 150),
   ["Color Hub 9"]      = Color3.fromRGB(30, 0, 30),
   ["Color Dark Greem"] = Color3.fromRGB(255, 0, 255)
  }
 },
 Info       = { Version = "2.0.0" },
 Save       = { UISize = {560, 390}, TabSize = 165, Theme = "Dark" },
    -- ... (باقي الجداول كما هي)
}

-- [تعديل نظام النيازك للألوان الوردية]
local function BuildParticleSystem(ParticleContainer, MainFrameRef)
 local ActiveParticles = {}
 local MeteorImage = "rbxassetid://12543411478"
 local MeteorColor = Color3.fromRGB(255, 0, 255) -- لون وردي للنيازك
 local SpawnRate   = 0.10

local function CreateTrail(pos, size)
  if not ParticleContainer or not ParticleContainer.Parent then return end
  local trail = Instance.new("Frame")
  trail.Size                   = size
  trail.Position               = pos
  trail.BackgroundColor3       = Color3.fromRGB(128, 0, 128) -- ذيل بنفسجي
  trail.BorderSizePixel        = 0
  trail.BackgroundTransparency = 0.3
  trail.ZIndex                 = 10
  trail.Parent                 = ParticleContainer
  local corner = Instance.new("UICorner", trail)
  corner.CornerRadius = UDim.new(1, 0)
  local tween = TweenService:Create(trail, TweenInfo.new(0.5), {
   Size = UDim2.fromOffset(0, 0),
   BackgroundTransparency = 1
  })
  tween:Play()
  tween.Completed:Connect(function() trail:Destroy() end)
 end
    -- ... (بقية كود النيازك)
end

-- [تعديل الوميض Shimmer ليكون وردي/بنفسجي]
task.spawn(function()
 task.wait(3)
 local angle = 0
 local shimmerColor = Color3.fromRGB(255, 100, 255) -- وردي لامع بدل الأبيض
 while true do
  task.wait(0.04)
  angle = (angle + 3) % 360
  local wave = (math.sin(math.rad(angle)) + 1) / 2
        -- ... (باقي منطق الوميض)
    end
end)

-- [تعديل الإشعار Cyber ليكون بنمط وردي نيون]
function CyberNotify(title, text, duration, accentColor)
    accentColor = accentColor or Color3.fromRGB(255, 0, 255) -- الافتراضي وردي
    -- ... (باقي كود الإشعار)
end

-- [تعديل خلفية الـ Hub والأطراف]
-- تم تغيير ألوان التدرج في BlueGrad (الذي أصبح PinkGrad الآن)
local PinkGrad = Create("UIGradient", BlueOverlay, {
    Rotation  = 120,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(20, 0, 30)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(50, 0, 80)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(20, 0, 30)),
    }),
    -- ... 
})

-- [تعديل الحواف المتحركة لتكون تدرج بنفسجي ووردي]
task.spawn(function()
    local angle = 0
    while MainFrame and MainFrame.Parent do
        angle = (angle + 4) % 360
        local wave = (math.sin(math.rad(angle)) + 1) / 2
        pcall(function()
            -- تدرج بين الوردي والبنفسجي للحواف
            OuterStroke.Color = Color3.fromRGB(150 + (wave * 105), 0, 200 + (wave * 55))
        end)
        task.wait(0.03)
    end
end)