-- ║         LOPK Library  |  Cyan Edition        ║ -- ║         Version: 2.0.0 (Upgraded FX)         ║ -- ║         Added: Meteors + Trails + Sound + BG ║

local TweenService = game:GetService("TweenService") local RunService   = game:GetService("RunService") local CoreGui      = game:GetService("CoreGui")

-- ================= MAIN UI ================= local ScreenGui = Instance.new("ScreenGui") ScreenGui.Name = "LOPK_UI" ScreenGui.Parent = CoreGui

-- ================= BACKGROUND ================= local Background = Instance.new("ImageLabel") Background.Size = UDim2.new(1,0,1,0) Background.BackgroundTransparency = 1 Background.Image = "rbxassetid://117630021115876" Background.ImageTransparency = 0.35 Background.ScaleType = Enum.ScaleType.Crop Background.ZIndex = 0 Background.Parent = ScreenGui

-- ================= MAIN FRAME ================= local MainFrame = Instance.new("Frame") MainFrame.Size = UDim2.new(0,600,0,400) MainFrame.Position = UDim2.new(0.5,0,0.5,0) MainFrame.AnchorPoint = Vector2.new(0.5,0.5) MainFrame.BackgroundColor3 = Color3.fromRGB(15,15,15) MainFrame.BackgroundTransparency = 0.1 MainFrame.ZIndex = 2 MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner", MainFrame) Corner.CornerRadius = UDim.new(0,10)

-- ================= PARTICLES HOLDER ================= local FXHolder = Instance.new("Frame") FXHolder.Size = UDim2.new(1,0,1,0) FXHolder.BackgroundTransparency = 1 FXHolder.ZIndex = 1 FXHolder.Parent = MainFrame

-- ================= SOUND ================= local MeteorSound = Instance.new("Sound") MeteorSound.SoundId = "rbxassetid://9118823101" -- whoosh sound MeteorSound.Volume = 0.6 MeteorSound.Parent = MainFrame

-- ================= METEOR SYSTEM ================= local function createTrail(pos) local t = Instance.new("Frame") t.Size = UDim2.fromOffset(6,6) t.Position = pos t.BackgroundColor3 = Color3.fromRGB(255,255,255) t.BorderSizePixel = 0 t.BackgroundTransparency = 0.3 t.ZIndex = 998 t.Parent = FXHolder

TweenService:Create(t, TweenInfo.new(0.6), {
 BackgroundTransparency = 1,
 Size = UDim2.fromOffset(2,2)
}):Play()

task.delay(0.6,function()
 t:Destroy()
end)

end

local function CreateMeteor() local meteor = Instance.new("ImageLabel") meteor.BackgroundTransparency = 1 meteor.Image = "rbxassetid://12543411478" meteor.ImageColor3 = Color3.fromRGB(255,255,255) meteor.Size = UDim2.fromOffset(math.random(35,70), math.random(60,100)) meteor.Position = UDim2.new(math.random(),0,-0.2,0) meteor.Rotation = 45 meteor.ZIndex = 999 meteor.Parent = MainFrame

-- sound
MeteorSound:Play()

local startPos = meteor.Position

local tween = TweenService:Create(meteor,
 TweenInfo.new(math.random(1,2), Enum.EasingStyle.Linear),
 {
  Position = UDim2.new(startPos.X.Scale - 0.3,0,1.3,0),
  ImageTransparency = 1
 }
)

-- trail system
task.spawn(function()
 while meteor.Parent do
  createTrail(meteor.Position)
  task.wait(0.05)
 end
end)

tween:Play()
tween.Completed:Connect(function()
 meteor:Destroy()
end)

end

-- ================= LOOP ================= task.spawn(function() while ScreenGui.Parent do CreateMeteor() task.wait(math.random(0.3,1)) end end)

-- ================= CYAN FLOAT FX ================= RunService.Heartbeat:Connect(function() if math.random(1,12) == 1 then local p = Instance.new("Frame") p.Size = UDim2.fromOffset(3,3) p.Position = UDim2.fromOffset(math.random(0,600),600) p.BackgroundColor3 = Color3.fromRGB(0,255,255) p.BorderSizePixel = 0 p.ZIndex = 1 p.Parent = FXHolder

TweenService:Create(p,TweenInfo.new(2),{
  Position = UDim2.fromOffset(math.random(0,600),-50),
  BackgroundTransparency = 1
 }):Play()

 task.delay(2,function()
  p:Destroy()
 end)
end

end)