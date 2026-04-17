-- ╔══════════════════════════════════════════════════╗
-- ║       EMBER UI  |  Rose Ember Edition            ║
-- ║       Theme: Deep Rose / Warm Dark               ║
-- ║       Version: 1.0.0  |  Key: jartto0115         ║
-- ╚══════════════════════════════════════════════════╝

local TweenService       = game:GetService("TweenService")
local UserInputService   = game:GetService("UserInputService")
local RunService         = game:GetService("RunService")
local HttpService        = game:GetService("HttpService")
local CoreGui            = game:GetService("CoreGui")
local Players            = game:GetService("Players")
local Player             = Players.LocalPlayer

-- ══════════════════════════════
--   Key System  (Rose Ember)
-- ══════════════════════════════
local VALID_KEY   = "jartto0115"
local KEY_PASSED  = false

local function RunKeySystem()
	local old = CoreGui:FindFirstChild("EmberKeyGui")
	if old then old:Destroy() end

	local Gui = Instance.new("ScreenGui")
	Gui.Name           = "EmberKeyGui"
	Gui.ResetOnSpawn   = false
	Gui.DisplayOrder   = 9999
	Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	pcall(function() Gui.Parent = CoreGui end)

	-- Blur-like dark overlay
	local Overlay = Instance.new("Frame", Gui)
	Overlay.Size                   = UDim2.new(1,0,1,0)
	Overlay.BackgroundColor3       = Color3.fromRGB(5, 3, 8)
	Overlay.BackgroundTransparency = 0.38
	Overlay.BorderSizePixel        = 0
	Overlay.ZIndex                 = 1

	-- Background glow spot (ember)
	local GlowBG = Instance.new("Frame", Gui)
	GlowBG.Size               = UDim2.fromOffset(380, 380)
	GlowBG.Position           = UDim2.new(0.5,0,0.5,0)
	GlowBG.AnchorPoint        = Vector2.new(0.5,0.5)
	GlowBG.BackgroundColor3   = Color3.fromRGB(180, 50, 70)
	GlowBG.BackgroundTransparency = 0.88
	GlowBG.BorderSizePixel    = 0
	GlowBG.ZIndex             = 1
	Instance.new("UICorner", GlowBG).CornerRadius = UDim.new(1,0)

	-- Main card
	local Card = Instance.new("Frame", Gui)
	Card.Size           = UDim2.fromOffset(320, 210)
	Card.Position       = UDim2.new(0.5,0,0.5,0)
	Card.AnchorPoint    = Vector2.new(0.5,0.5)
	Card.BackgroundColor3 = Color3.fromRGB(18, 13, 18)
	Card.BorderSizePixel  = 0
	Card.ZIndex           = 3
	Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 16)

	-- Card stroke: rose-red gradient
	local CStroke = Instance.new("UIStroke", Card)
	CStroke.Thickness       = 1.2
	CStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	CStroke.Color           = Color3.fromRGB(200, 60, 80)

	-- Warm gradient inside card
	local CardGrad = Instance.new("UIGradient", Card)
	CardGrad.Rotation = 130
	CardGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0,   Color3.fromRGB(24, 16, 22)),
		ColorSequenceKeypoint.new(1,   Color3.fromRGB(14, 10, 16)),
	})

	-- Top decorative bar
	local TopStrip = Instance.new("Frame", Card)
	TopStrip.Size             = UDim2.new(1,0,0,3)
	TopStrip.BorderSizePixel  = 0
	TopStrip.BackgroundColor3 = Color3.fromRGB(210, 55, 75)
	TopStrip.ZIndex           = 4
	Instance.new("UICorner", TopStrip).CornerRadius = UDim.new(0,16)
	local SG = Instance.new("UIGradient", TopStrip)
	SG.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 80,  100)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 150, 80)),
		ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 80,  100)),
	})

	-- Flame/ember icon label
	local IconLabel = Instance.new("TextLabel", Card)
	IconLabel.Size               = UDim2.fromOffset(40,40)
	IconLabel.Position           = UDim2.new(0.5,0,0,14)
	IconLabel.AnchorPoint        = Vector2.new(0.5,0)
	IconLabel.BackgroundTransparency = 1
	IconLabel.Text               = "🔑"
	IconLabel.TextSize           = 26
	IconLabel.Font               = Enum.Font.GothamBold
	IconLabel.ZIndex             = 4

	-- Title
	local TL = Instance.new("TextLabel", Card)
	TL.Size               = UDim2.new(1,0,0,18)
	TL.Position           = UDim2.fromOffset(0,60)
	TL.BackgroundTransparency = 1
	TL.Text               = "Ember UI — Key System"
	TL.TextColor3         = Color3.fromRGB(255, 220, 215)
	TL.TextSize           = 14
	TL.Font               = Enum.Font.GothamBold
	TL.ZIndex             = 4

	-- Subtitle
	local SL = Instance.new("TextLabel", Card)
	SL.Size               = UDim2.new(1,-30,0,12)
	SL.Position           = UDim2.fromOffset(15,80)
	SL.BackgroundTransparency = 1
	SL.Text               = "Enter your access key to unlock the script"
	SL.TextColor3         = Color3.fromRGB(160, 110, 115)
	SL.TextSize           = 9
	SL.Font               = Enum.Font.Gotham
	SL.TextXAlignment     = Enum.TextXAlignment.Center
	SL.ZIndex             = 4

	-- Divider
	local Div = Instance.new("Frame", Card)
	Div.Size             = UDim2.new(0.7,0,0,1)
	Div.Position         = UDim2.new(0.15,0,0,98)
	Div.BackgroundColor3 = Color3.fromRGB(90, 40, 50)
	Div.BorderSizePixel  = 0
	Div.ZIndex           = 4

	-- Input box frame
	local InBox = Instance.new("Frame", Card)
	InBox.Size             = UDim2.new(1,-32,0,34)
	InBox.Position         = UDim2.fromOffset(16,106)
	InBox.BackgroundColor3 = Color3.fromRGB(28, 20, 26)
	InBox.BorderSizePixel  = 0
	InBox.ZIndex           = 4
	Instance.new("UICorner", InBox).CornerRadius = UDim.new(0,9)
	local InStroke = Instance.new("UIStroke", InBox)
	InStroke.Color     = Color3.fromRGB(80, 35, 45)
	InStroke.Thickness = 1

	local KeyTB = Instance.new("TextBox", InBox)
	KeyTB.Size               = UDim2.new(1,-14,1,0)
	KeyTB.Position           = UDim2.fromOffset(7,0)
	KeyTB.BackgroundTransparency = 1
	KeyTB.PlaceholderText    = "paste your key here..."
	KeyTB.PlaceholderColor3  = Color3.fromRGB(100, 60, 70)
	KeyTB.Text               = ""
	KeyTB.TextColor3         = Color3.fromRGB(255, 210, 205)
	KeyTB.TextSize           = 11
	KeyTB.Font               = Enum.Font.GothamMedium
	KeyTB.ClearTextOnFocus   = false
	KeyTB.ZIndex             = 5

	-- Error label
	local ErrL = Instance.new("TextLabel", Card)
	ErrL.Size               = UDim2.new(1,-30,0,11)
	ErrL.Position           = UDim2.fromOffset(16,143)
	ErrL.BackgroundTransparency = 1
	ErrL.Text               = ""
	ErrL.TextColor3         = Color3.fromRGB(255, 90, 90)
	ErrL.TextSize           = 8.5
	ErrL.Font               = Enum.Font.Gotham
	ErrL.TextXAlignment     = Enum.TextXAlignment.Left
	ErrL.ZIndex             = 4

	-- Confirm button
	local Btn = Instance.new("TextButton", Card)
	Btn.Size             = UDim2.new(1,-32,0,32)
	Btn.Position         = UDim2.fromOffset(16,158)
	Btn.BackgroundColor3 = Color3.fromRGB(195, 55, 70)
	Btn.Text             = "Unlock Script"
	Btn.TextColor3       = Color3.fromRGB(255, 240, 235)
	Btn.TextSize         = 12
	Btn.Font             = Enum.Font.GothamBold
	Btn.AutoButtonColor  = false
	Btn.BorderSizePixel  = 0
	Btn.ZIndex           = 4
	Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,9)
	local BG2 = Instance.new("UIGradient", Btn)
	BG2.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 65, 85)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 45, 60)),
	})
	BG2.Rotation = 90

	-- Entrance anim
	Card.BackgroundTransparency = 1
	Card.Position = UDim2.new(0.5,0,0.62,0)
	TweenService:Create(Card, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5,0,0.5,0),
		BackgroundTransparency = 0
	}):Play()

	-- Hover effects
	Btn.MouseEnter:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(230,75,95)}):Play()
	end)
	Btn.MouseLeave:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(195,55,70)}):Play()
	end)
	Btn.MouseButton1Down:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.1), {Size = UDim2.new(1,-36,0,30)}):Play()
	end)
	Btn.MouseButton1Up:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.15), {Size = UDim2.new(1,-32,0,32)}):Play()
	end)

	-- Focus effects
	KeyTB.Focused:Connect(function()
		TweenService:Create(InStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(200,65,80)}):Play()
	end)
	KeyTB.FocusLost:Connect(function()
		TweenService:Create(InStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(80,35,45)}):Play()
	end)

	local done = Instance.new("BindableEvent")

	local function Verify()
		local k = KeyTB.Text:gsub("%s+","")
		if k == VALID_KEY then
			KEY_PASSED = true
			ErrL.Text  = ""
			Btn.Text   = "✓  Access Granted"
			TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(40,170,100)}):Play()
			TweenService:Create(CStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(40,200,110)}):Play()
			task.wait(0.85)
			TweenService:Create(Card, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
				Position = UDim2.new(0.5,0,0.38,0),
				BackgroundTransparency = 1
			}):Play()
			TweenService:Create(Overlay, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
			task.wait(0.45)
			Gui:Destroy()
			done:Fire(true)
		else
			ErrL.Text = "✗  Wrong key. Try again."
			-- shake
			for _, dx in ipairs({7,-7,5,-5,0}) do
				TweenService:Create(Card, TweenInfo.new(0.05), {
					Position = UDim2.new(0.5, dx, 0.5, 0)
				}):Play()
				task.wait(0.055)
			end
			TweenService:Create(InStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(220,55,55)}):Play()
			task.wait(0.5)
			TweenService:Create(InStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(80,35,45)}):Play()
		end
	end

	Btn.Activated:Connect(Verify)
	KeyTB.FocusLost:Connect(function(enter) if enter then Verify() end end)

	done.Event:Wait()
	done:Destroy()
	return KEY_PASSED
end

if not RunKeySystem() then return end

-- ══════════════════════════════════════════════
--   EMBER UI  Library
-- ══════════════════════════════════════════════
local EmberLib = {
	Save     = { UISize = {580, 400}, TabSize = 170, Theme = "Ember" },
	Flags    = {},
	Options  = {},
	Tabs     = {},
	Instances= {},
	Elements = {},
	Settings = {},
	Connection={},
	Themes   = {
		Ember = {
			Hub1      = ColorSequence.new({
				ColorSequenceKeypoint.new(0,   Color3.fromRGB(16, 10, 16)),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(22, 14, 20)),
				ColorSequenceKeypoint.new(1,   Color3.fromRGB(16, 10, 16)),
			}),
			Hub2      = Color3.fromRGB(24, 16, 22),
			Accent    = Color3.fromRGB(220, 65, 85),
			AccentSoft= Color3.fromRGB(170, 45, 60),
			Text      = Color3.fromRGB(255, 230, 225),
			SubText   = Color3.fromRGB(160, 115, 120),
			Stroke    = Color3.fromRGB(100, 40, 55),
		},
		Violet = {
			Hub1      = ColorSequence.new({
				ColorSequenceKeypoint.new(0,   Color3.fromRGB(12, 10, 20)),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18, 14, 28)),
				ColorSequenceKeypoint.new(1,   Color3.fromRGB(12, 10, 20)),
			}),
			Hub2      = Color3.fromRGB(20, 16, 30),
			Accent    = Color3.fromRGB(140, 80, 240),
			AccentSoft= Color3.fromRGB(100, 55, 180),
			Text      = Color3.fromRGB(230, 225, 255),
			SubText   = Color3.fromRGB(140, 125, 175),
			Stroke    = Color3.fromRGB(80, 50, 140),
		},
		Slate = {
			Hub1      = ColorSequence.new({
				ColorSequenceKeypoint.new(0,   Color3.fromRGB(10, 12, 16)),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(16, 18, 24)),
				ColorSequenceKeypoint.new(1,   Color3.fromRGB(10, 12, 16)),
			}),
			Hub2      = Color3.fromRGB(18, 22, 30),
			Accent    = Color3.fromRGB(60, 160, 240),
			AccentSoft= Color3.fromRGB(40, 120, 190),
			Text      = Color3.fromRGB(220, 232, 255),
			SubText   = Color3.fromRGB(130, 155, 195),
			Stroke    = Color3.fromRGB(45, 75, 130),
		},
	},
	Icons = {
		["home"]      = "rbxassetid://10723393628",
		["settings"]  = "rbxassetid://10734950309",
		["star"]      = "rbxassetid://10734966248",
		["user"]      = "rbxassetid://10747373176",
		["shield"]    = "rbxassetid://10734951847",
		["flame"]     = "rbxassetid://10723381530",
		["bolt"]      = "rbxassetid://10709769406",
		["eye"]       = "rbxassetid://10723346959",
		["lock"]      = "rbxassetid://10734887180",
		["code"]      = "rbxassetid://10709810463",
		["bell"]      = "rbxassetid://10709775704",
		["globe"]     = "rbxassetid://10723388891",
		["rocket"]    = "rbxassetid://10734934585",
		["trophy"]    = "rbxassetid://10734976680",
		["box"]       = "rbxassetid://10709782497",
		["layers"]    = "rbxassetid://10734884618",
		["puzzle"]    = "rbxassetid://10734930886",
		["chart"]     = "rbxassetid://10734976450",
		["message"]   = "rbxassetid://10734889882",
		["grid"]      = "rbxassetid://10723391530",
		["list"]      = "rbxassetid://10734886194",
		["moon"]      = "rbxassetid://10734890558",
		["sun"]       = "rbxassetid://10734974297",
		["target"]    = "rbxassetid://10734975460",
		["wrench"]    = "rbxassetid://10747383470",
		["package"]   = "rbxassetid://10734909540",
		["database"]  = "rbxassetid://10709818996",
		["crown"]     = "rbxassetid://10709818626",
		["sword"]     = "rbxassetid://10709769508",
		["close"]     = "rbxassetid://10747384394",
	}
}

-- ── helpers ──────────────────────────────────────────────
local ViewportSize = workspace.CurrentCamera.ViewportSize
local UIScale      = ViewportSize.Y / 450
local T            = EmberLib.Themes[EmberLib.Save.Theme]   -- active theme shortcut

local function tw(inst, props, t, style, dir)
	TweenService:Create(inst,
		TweenInfo.new(t or 0.25, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out),
		props):Play()
end

local function corner(parent, r)
	local c = Instance.new("UICorner", parent)
	c.CornerRadius = r or UDim.new(0, 8)
	return c
end

local function stroke(parent, col, thick)
	local s = Instance.new("UIStroke", parent)
	s.Color           = col or T.Stroke
	s.Thickness       = thick or 1
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	return s
end

local function lbl(parent, props)
	local l = Instance.new("TextLabel", parent)
	for k,v in pairs(props) do l[k] = v end
	return l
end

local function frm(parent, props)
	local f = Instance.new("Frame", parent)
	for k,v in pairs(props) do f[k] = v end
	return f
end

local function img(parent, props)
	local i = Instance.new("ImageLabel", parent)
	for k,v in pairs(props) do i[k] = v end
	return i
end

local function btn(parent, props)
	local b = Instance.new("TextButton", parent)
	b.AutoButtonColor = false
	for k,v in pairs(props) do b[k] = v end
	return b
end

local function pad(parent, l,r,t,b)
	local p = Instance.new("UIPadding", parent)
	if l then p.PaddingLeft   = UDim.new(0,l) end
	if r then p.PaddingRight  = UDim.new(0,r) end
	if t then p.PaddingTop    = UDim.new(0,t) end
	if b then p.PaddingBottom = UDim.new(0,b) end
end

local function list(parent, dir, pad_, halign, valign)
	local l = Instance.new("UIListLayout", parent)
	l.FillDirection       = dir or Enum.FillDirection.Vertical
	l.Padding             = UDim.new(0, pad_ or 5)
	l.HorizontalAlignment = halign or Enum.HorizontalAlignment.Left
	l.VerticalAlignment   = valign or Enum.VerticalAlignment.Top
	l.SortOrder           = Enum.SortOrder.LayoutOrder
end

local function getIcon(name)
	return EmberLib.Icons[name:lower()] or ""
end

-- Track theme instances for re-theming
local Themed = {}
local function Track(inst, kind) table.insert(Themed, {i=inst,k=kind}); return inst end

local function ApplyTheme(newT)
	T = newT
	for _, v in ipairs(Themed) do
		if not v.i or not v.i.Parent then continue end
		pcall(function()
			if     v.k == "Hub2"    then v.i.BackgroundColor3 = T.Hub2
			elseif v.k == "Accent"  then
				if v.i:IsA("UIStroke") then v.i.Color = T.Accent
				elseif v.i:IsA("Frame") or v.i:IsA("TextButton") then v.i.BackgroundColor3 = T.Accent
				elseif v.i:IsA("ImageLabel") then v.i.ImageColor3 = T.Accent
				else v.i.TextColor3 = T.Accent end
			elseif v.k == "Text"    then v.i.TextColor3 = T.Text
			elseif v.k == "Sub"     then v.i.TextColor3 = T.SubText
			elseif v.k == "Stroke"  then v.i.Color = T.Stroke
			elseif v.k == "Grad"    then v.i.Color = T.Hub1
			end
		end)
	end
end

-- ── ScreenGui ────────────────────────────────────────────
local SGui = Instance.new("ScreenGui")
SGui.Name           = "EmberUI"
SGui.ResetOnSpawn   = false
SGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Instance.new("UIScale", SGui).Scale = UIScale
pcall(function() SGui.Parent = CoreGui end)

-- ── Notification system ───────────────────────────────────
local NotiContainer = frm(SGui, {
	Name                   = "NotiBox",
	Size                   = UDim2.new(0,280,1,0),
	Position               = UDim2.new(1,-298,1,-16),
	AnchorPoint            = Vector2.new(0,1),
	BackgroundTransparency = 1,
	ZIndex                 = 999
})
local NotiList = Instance.new("UIListLayout", NotiContainer)
NotiList.Padding            = UDim.new(0,6)
NotiList.VerticalAlignment  = Enum.VerticalAlignment.Bottom
NotiList.SortOrder          = Enum.SortOrder.LayoutOrder

function EmberLib:Notify(cfg)
	local title    = cfg.Title    or cfg[1] or "Notice"
	local text     = cfg.Text     or cfg[2] or ""
	local duration = cfg.Duration or cfg[3] or 5
	local kind     = cfg.Type     or "Info"   -- Info Success Warning Error

	local colors = {
		Info    = Color3.fromRGB(220, 65,  85),
		Success = Color3.fromRGB(50,  190, 120),
		Warning = Color3.fromRGB(240, 175, 50),
		Error   = Color3.fromRGB(255, 65,  65),
	}
	local ac = colors[kind] or colors.Info

	local NF = frm(NotiContainer, {
		Size             = UDim2.new(1,0,0,54),
		BackgroundColor3 = Color3.fromRGB(20,14,20),
		BorderSizePixel  = 0,
		ClipsDescendants = true,
	})
	corner(NF, UDim.new(0,10))
	stroke(NF, ac, 1)

	-- left accent bar
	local AB = frm(NF, {
		Size             = UDim2.new(0,3,0.6,0),
		Position         = UDim2.new(0,0,0.2,0),
		BackgroundColor3 = ac, BorderSizePixel = 0
	})
	corner(AB, UDim.new(0.5,0))

	lbl(NF, {
		Size=UDim2.new(1,-46,0,17), Position=UDim2.fromOffset(14,7),
		BackgroundTransparency=1, Text=title,
		TextColor3=Color3.fromRGB(255,235,230), TextSize=11,
		Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left
	})
	lbl(NF, {
		Size=UDim2.new(1,-46,0,22), Position=UDim2.fromOffset(14,24),
		BackgroundTransparency=1, Text=text,
		TextColor3=Color3.fromRGB(155,115,120), TextSize=9,
		Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true
	})
	local CL = lbl(NF, {
		Size=UDim2.new(0,30,0,16), Position=UDim2.new(1,-34,0,7),
		BackgroundTransparency=1, Text=tostring(duration),
		TextColor3=ac, TextSize=10, Font=Enum.Font.GothamBold,
		TextXAlignment=Enum.TextXAlignment.Right
	})

	NF.Position = UDim2.new(1,50,0,0)
	tw(NF, {Position=UDim2.new(0,0,0,0)}, 0.35)

	local function dismiss()
		tw(NF, {Position=UDim2.new(1,50,0,0), BackgroundTransparency=1}, 0.28)
		task.wait(0.3)
		pcall(function() NF:Destroy() end)
	end

	if duration > 0 then
		task.spawn(function()
			local t = duration
			while t > 0 do
				task.wait(0.1); t = t - 0.1
				if NF and NF.Parent then
					CL.Text = string.format("%.1f", math.max(t,0))
				end
			end
			if NF and NF.Parent then dismiss() end
		end)
	end

	return { Remove = dismiss }
end

-- ── Sound ─────────────────────────────────────────────────
local _SS  = game:GetService("SoundService")
local _SFX = Instance.new("Sound")
_SFX.SoundId = "rbxassetid://115942274494895"
_SFX.Volume  = 0.8
_SFX.Parent  = _SS
local function Click()
	task.spawn(function()
		local s = _SFX:Clone(); s.Parent = _SS; s:Play()
		game:GetService("Debris"):AddItem(s,2)
	end)
end

-- ── Drag ──────────────────────────────────────────────────
local function MakeDrag(inst)
	task.spawn(function()
		inst.Active = true
		local ds, sp, on
		inst.MouseButton1Down:Connect(function() on = true end)
		inst.InputBegan:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1
			or inp.UserInputType == Enum.UserInputType.Touch then
				sp = inst.Position; ds = inp.Position
				while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
					RunService.Heartbeat:Wait()
					if on then
						local d = inp.Position - ds
						tw(inst, {Position = UDim2.new(
							sp.X.Scale, sp.X.Offset + d.X/UIScale,
							sp.Y.Scale, sp.Y.Offset + d.Y/UIScale
						)}, 0.28)
					end
				end
				on = false
			end
		end)
	end)
	return inst
end

-- ── Row helper (label + control side) ─────────────────────
local function MakeRow(container, title, desc, ctrlWidth)
	ctrlWidth = ctrlWidth or 0

	local row = btn(container, {
		Size             = UDim2.new(1,0,0,28),
		AutomaticSize    = Enum.AutomaticSize.Y,
		BackgroundColor3 = T.Hub2,
		BorderSizePixel  = 0,
		Text             = "",
		Name             = "Row",
		AutoButtonColor  = false,
	})
	Track(row,"Hub2")
	corner(row, UDim.new(0,7))

	-- tiny accent left bar
	local bar = Track(frm(row, {
		Size=UDim2.new(0,2,0.5,0), Position=UDim2.new(0,0,0.25,0),
		BackgroundColor3=T.Accent, BorderSizePixel=0,
		BackgroundTransparency=0.5
	}), "Accent")
	corner(bar, UDim.new(0.5,0))

	-- Hover
	local over = false
	row.MouseEnter:Connect(function() over=true;  tw(row,{BackgroundTransparency=0.32},0.15) end)
	row.MouseLeave:Connect(function() over=false; tw(row,{BackgroundTransparency=0},0.15) end)
	row.MouseButton1Down:Connect(function()
		Click()
		tw(row,{BackgroundTransparency=0.55},0.1)
		local os = row.Size
		tw(row,{Size=os-UDim2.fromOffset(4,2)},0.08)
		task.delay(0.09,function() tw(row,{Size=os},0.14) end)
	end)
	row.MouseButton1Up:Connect(function()
		tw(row,{BackgroundTransparency=over and 0.32 or 0},0.15)
	end)

	local txtHolder = frm(row, {
		AutomaticSize    = Enum.AutomaticSize.Y,
		BackgroundTransparency=1,
		Size             = UDim2.new(1, -(ctrlWidth+18), 0, 0),
		Position         = UDim2.fromOffset(12,0),
	})
	local tl = list(txtHolder, Enum.FillDirection.Vertical, 1)
	pad(txtHolder,0,0,6,6)

	local titleL = Track(lbl(txtHolder, {
		Size=UDim2.new(1,0,0,13), BackgroundTransparency=1,
		Text=title, TextColor3=T.Text, TextSize=10,
		Font=Enum.Font.GothamMedium, TextXAlignment=Enum.TextXAlignment.Left,
		AutomaticSize=Enum.AutomaticSize.Y, TextTruncate=Enum.TextTruncate.AtEnd,
	}),"Text")

	local descL  = Track(lbl(txtHolder, {
		Size=UDim2.new(1,0,0,0), BackgroundTransparency=1,
		Text=desc or "", TextColor3=T.SubText, TextSize=8,
		Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left,
		AutomaticSize=Enum.AutomaticSize.Y, TextWrapped=true,
		Visible = desc ~= nil and desc ~= "",
	}),"Sub")

	local Label = {}
	function Label:Title(v) titleL.Text = v end
	function Label:Desc(v)
		descL.Visible = v ~= nil and v ~= ""
		descL.Text    = v or ""
	end
	return row, Label
end

-- ═══════════════════════════════════════════════════
--   MakeWindow
-- ═══════════════════════════════════════════════════
function EmberLib:MakeWindow(cfg)
	EmberLib.Tabs = {}
	local WTitle   = cfg.Title   or cfg[1] or "Ember UI"
	local WSub     = cfg.SubTitle or cfg[2] or "v1.0"
	local W = cfg.Width  or EmberLib.Save.UISize[1]
	local H = cfg.Height or EmberLib.Save.UISize[2]

	-- ── loading toast ──
	task.spawn(function()
		EmberLib:Notify({Title="⏳ Loading...", Text="Please wait while the script initialises.", Duration=6, Type="Info"})
	end)

	-- ── Main frame ────────────────────────────────────────
	local Main = MakeDrag(btn(SGui, {
		Size             = UDim2.fromOffset(W,H),
		Position         = UDim2.new(0.5,-W/2,0.5,-H/2),
		BackgroundColor3 = Color3.fromRGB(16,10,16),
		BorderSizePixel  = 0, Text = "",
		AutoButtonColor  = false, Name = "EmberMain",
	}))
	Track(Main,"Hub2")
	corner(Main, UDim.new(0,12))
	stroke(Main, T.Stroke, 1.2)

	-- gradient overlay
	local GO = frm(Main, {
		Size=UDim2.new(1,0,1,0), BackgroundTransparency=0, BorderSizePixel=0, ZIndex=0
	})
	corner(GO, UDim.new(0,12))
	local GG = Track(Instance.new("UIGradient", GO), "Grad")
	GG.Color    = T.Hub1
	GG.Rotation = 130
	GG.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0,0.38),
		NumberSequenceKeypoint.new(1,0.50),
	})
	task.spawn(function()
		local a = 130
		while Main and Main.Parent do
			a = (a+0.4)%360; GG.Rotation = a; task.wait(0.035)
		end
	end)

	-- top bar
	local TopH = frm(Main, {
		Size=UDim2.new(1,0,0,32), BackgroundTransparency=1, Name="TopBar", ZIndex=2
	})

	-- top accent line
	local TAc = frm(TopH, {
		Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,1,-1),
		BackgroundColor3=T.Accent, BorderSizePixel=0, BackgroundTransparency=0.6
	})
	Track(TAc,"Accent")

	-- ember dot  (animated)
	local EDot = Track(frm(TopH, {
		Size=UDim2.fromOffset(7,7), Position=UDim2.new(0,13,0.5,0),
		AnchorPoint=Vector2.new(0,0.5), BackgroundColor3=T.Accent, BorderSizePixel=0
	}), "Accent")
	corner(EDot, UDim.new(0.5,0))
	task.spawn(function()
		while Main and Main.Parent do
			tw(EDot,{BackgroundTransparency=0.7},0.7)
			task.wait(0.72)
			tw(EDot,{BackgroundTransparency=0},0.7)
			task.wait(0.72)
		end
	end)

	-- title
	Track(lbl(TopH, {
		Position=UDim2.new(0,25,0.5,0), AnchorPoint=Vector2.new(0,0.5),
		AutomaticSize=Enum.AutomaticSize.X, BackgroundTransparency=1,
		Text=WTitle, TextColor3=T.Text, TextSize=13, Font=Enum.Font.GothamBold,
		TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
	}),"Text")

	-- subtitle badge
	local SubBadge = Track(frm(TopH,{
		AutomaticSize=Enum.AutomaticSize.X, Size=UDim2.fromOffset(0,14),
		Position=UDim2.new(0,25+#WTitle*8+6,0.5,0), AnchorPoint=Vector2.new(0,0.5),
		BackgroundColor3=T.AccentSoft, BorderSizePixel=0, ZIndex=3,
	}),"AccentSoft")
	corner(SubBadge, UDim.new(0,4))
	pad(SubBadge,5,5,0,0)
	Track(lbl(SubBadge,{
		AutomaticSize=Enum.AutomaticSize.X, Size=UDim2.fromOffset(0,14),
		BackgroundTransparency=1, Text=WSub, TextColor3=T.Text,
		TextSize=8, Font=Enum.Font.GothamBold, ZIndex=4,
		TextXAlignment=Enum.TextXAlignment.Center,
	}),"Text")

	-- Close & Minimise buttons
	local CloseBtn = btn(TopH, {
		Size=UDim2.fromOffset(14,14), Position=UDim2.new(1,-12,0.5,0),
		AnchorPoint=Vector2.new(1,0.5), BackgroundTransparency=1,
		Image="rbxassetid://10747384394", Text="",
		AutoButtonColor=false, ZIndex=4,
	})
	-- reuse ImageButton
	local cb2 = Instance.new("ImageButton", TopH)
	cb2.Size=UDim2.fromOffset(14,14); cb2.Position=UDim2.new(1,-12,0.5,0)
	cb2.AnchorPoint=Vector2.new(1,0.5); cb2.BackgroundTransparency=1
	cb2.Image="rbxassetid://10747384394"; cb2.ImageColor3=Color3.fromRGB(255,80,90)
	cb2.AutoButtonColor=false; cb2.ZIndex=4; cb2.Parent=TopH

	local mb2 = Instance.new("ImageButton", TopH)
	mb2.Size=UDim2.fromOffset(14,14); mb2.Position=UDim2.new(1,-32,0.5,0)
	mb2.AnchorPoint=Vector2.new(1,0.5); mb2.BackgroundTransparency=1
	mb2.Image="rbxassetid://10734896206"; mb2.ImageColor3=T.Accent
	mb2.AutoButtonColor=false; mb2.ZIndex=4; mb2.Parent=TopH
	Track(mb2,"Accent")

	-- ── Tab sidebar ───────────────────────────────────────
	local TabW  = EmberLib.Save.TabSize
	local Sidebar = Instance.new("ScrollingFrame", Main)
	Sidebar.Size                   = UDim2.new(0,TabW,1,-32)
	Sidebar.Position               = UDim2.new(0,0,0,32)
	Sidebar.BackgroundTransparency = 1
	Sidebar.BorderSizePixel        = 0
	Sidebar.ScrollBarThickness     = 2
	Sidebar.ScrollBarImageColor3   = T.Accent
	Sidebar.ScrollBarImageTransparency = 0.3
	Sidebar.CanvasSize             = UDim2.new()
	Sidebar.AutomaticCanvasSize    = Enum.AutomaticSize.Y
	Sidebar.ScrollingDirection     = Enum.ScrollingDirection.Y
	Sidebar.ZIndex                 = 2
	pad(Sidebar,8,8,8,8)
	list(Sidebar)

	-- sidebar separator
	local Sep = Track(frm(Main,{
		Size=UDim2.new(0,1,1,-32), Position=UDim2.new(0,TabW,0,32),
		BackgroundColor3=T.Stroke, BorderSizePixel=0, BackgroundTransparency=0.55, ZIndex=2,
	}),"Stroke")

	-- content area
	local ContentArea = frm(Main, {
		Size=UDim2.new(1,-TabW-1,1,-32), Position=UDim2.new(0,TabW+1,0,32),
		BackgroundTransparency=1, ClipsDescendants=true, ZIndex=2,
	})

	-- ── window object ─────────────────────────────────────
	local Win = {}
	local Minimised, SavedSize, Busy = false, nil, false
	local ContList = {}

	local function CloseDialog()
		Win:Dialog({
			Title="Close Script",
			Text="Are you sure you want to close?",
			Options={
				{"Yes", function() SGui:Destroy() end},
				{"No"}
			}
		})
	end

	local function ToggleMin()
		if Busy then return end; Busy=true
		if Minimised then
			tw(Main,{Size=SavedSize},0.25, Enum.EasingStyle.Quint)
			task.wait(0.26); mb2.ImageColor3=T.Accent; Minimised=false
		else
			SavedSize=Main.Size
			mb2.ImageColor3=Color3.fromRGB(255,90,90)
			tw(Main,{Size=UDim2.fromOffset(Main.Size.X.Offset,32)},0.25,Enum.EasingStyle.Quint)
			task.wait(0.26); Minimised=true
		end
		Busy=false
	end

	cb2.Activated:Connect(CloseDialog)
	mb2.Activated:Connect(ToggleMin)

	function Win:Dialog(cfg2)
		if Main:FindFirstChild("DialogOverlay") then return end
		local dt = cfg2.Title or "Dialog"
		local dx = cfg2.Text  or ""
		local do_ = cfg2.Options or {}

		local Ovr = frm(Main, {
			Size=UDim2.new(1,0,1,0), BackgroundColor3=Color3.fromRGB(5,3,8),
			BackgroundTransparency=0.45, Active=true, ZIndex=10, Name="DialogOverlay"
		})
		corner(Ovr, UDim.new(0,12))

		local DCard = frm(Ovr, {
			Size=UDim2.fromOffset(260,150), Position=UDim2.new(0.5,0,0.5,0),
			AnchorPoint=Vector2.new(0.5,0.5), BackgroundColor3=Color3.fromRGB(22,14,22),
			BorderSizePixel=0, ZIndex=11,
		})
		corner(DCard)
		stroke(DCard, T.Stroke, 1)
		local DG = Instance.new("UIGradient", DCard)
		DG.Color = T.Hub1; DG.Rotation = 130

		lbl(DCard,{
			Size=UDim2.new(1,-20,0,20), Position=UDim2.fromOffset(12,8),
			BackgroundTransparency=1, Text=dt, TextColor3=T.Text,
			TextSize=14, Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=12,
		})
		lbl(DCard,{
			Size=UDim2.new(1,-20,0,0), AutomaticSize=Enum.AutomaticSize.Y,
			Position=UDim2.fromOffset(12,30), BackgroundTransparency=1,
			Text=dx, TextColor3=T.SubText, TextSize=11,
			Font=Enum.Font.GothamMedium, TextXAlignment=Enum.TextXAlignment.Left,
			TextWrapped=true, ZIndex=12,
		})

		local BH = frm(DCard,{
			Size=UDim2.new(1,-20,0,32), Position=UDim2.new(0,10,1,-40),
			BackgroundTransparency=1, ZIndex=12,
		})
		list(BH, Enum.FillDirection.Horizontal, 8, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center)

		local D = {}
		local bcount = 0
		function D:Close() Ovr:Destroy() end
		function D:Button(bc)
			local bn = bc[1] or "OK"
			local cb = bc[2] or function()end
			bcount += 1
			local nb = btn(BH,{
				Size=UDim2.new(0,100,0,28), BackgroundColor3=T.Accent, BorderSizePixel=0,
				Text=bn, TextColor3=T.Text, TextSize=11, Font=Enum.Font.GothamBold, ZIndex=13,
			})
			Track(nb,"Accent")
			corner(nb, UDim.new(0,7))
			nb.Activated:Connect(D.Close)
			nb.Activated:Connect(cb)
		end
		for _,b in ipairs(do_) do D:Button(b) end
		return D
	end

	function Win:SelectTab(n)
		if type(n)=="number" then
			local t = EmberLib.Tabs[n]
			if t then t.func:Enable() end
		end
	end

	-- ── MakeTab ──────────────────────────────────────────
	function Win:MakeTab(cfg3)
		local TName = cfg3.Title or cfg3[1] or "Tab"
		local TIcon = cfg3.Icon  or cfg3[2] or ""
		local iconId = TIcon ~= "" and getIcon(TIcon) or ""

		-- tab button
		local TBtn = btn(Sidebar, {
			Size=UDim2.new(1,0,0,30), BackgroundColor3=T.Hub2,
			BorderSizePixel=0, Text="", AutoButtonColor=false, Name="Tab",
		})
		Track(TBtn,"Hub2"); corner(TBtn, UDim.new(0,7))

		-- selected indicator (left stripe)
		local Ind = Track(frm(TBtn, {
			Size=UDim2.new(0,2,0,0), Position=UDim2.new(0,0,0.5,0),
			AnchorPoint=Vector2.new(0,0.5), BackgroundColor3=T.Accent,
			BorderSizePixel=0, BackgroundTransparency=1,
		}),"Accent")
		corner(Ind, UDim.new(0.5,0))

		-- icon
		if iconId ~= "" then
			Track(img(TBtn,{
				Size=UDim2.fromOffset(13,13), Position=UDim2.new(0,10,0.5,0),
				AnchorPoint=Vector2.new(0,0.5), Image=iconId,
				ImageColor3=T.Accent, BackgroundTransparency=1, ImageTransparency=0.3,
			}),"Accent")
		end

		-- label
		local TL = Track(lbl(TBtn, {
			Size=UDim2.new(1,-(iconId~="" and 28 or 14),1,0),
			Position=UDim2.fromOffset(iconId~="" and 28 or 14, 0),
			BackgroundTransparency=1, Text=TName,
			TextColor3=T.Text, TextSize=10, Font=Enum.Font.GothamMedium,
			TextXAlignment=Enum.TextXAlignment.Left, TextTransparency=0.35,
		}),"Text")

		-- container (scrollable)
		local Cont = Instance.new("ScrollingFrame")
		Cont.Size                    = UDim2.new(1,0,1,0)
		Cont.BackgroundTransparency  = 1
		Cont.BorderSizePixel         = 0
		Cont.ScrollBarThickness      = 2
		Cont.ScrollBarImageColor3    = T.Accent
		Cont.ScrollBarImageTransparency = 0.35
		Cont.CanvasSize              = UDim2.new()
		Cont.AutomaticCanvasSize     = Enum.AutomaticSize.Y
		Cont.ScrollingDirection      = Enum.ScrollingDirection.Y
		Cont.Name                    = "Cont_"..TName
		Track(Cont,"ScrollBar")
		pad(Cont,10,10,10,10)
		list(Cont, Enum.FillDirection.Vertical, 5)

		table.insert(ContList, Cont)
		local isFirst = #ContList == 1
		if isFirst then Cont.Parent = ContentArea end

		-- Tab object
		local Tab = {}
		table.insert(EmberLib.Tabs, {func=Tab, Cont=Cont})
		Tab.Cont = Cont

		local function Activate()
			if Cont.Parent == ContentArea then return end
			for _, c in ipairs(ContList) do
				if c ~= Cont and c.Parent == ContentArea then c.Parent = nil end
			end
			for _, t in ipairs(EmberLib.Tabs) do
				if t.Cont ~= Cont then t.func:Disable() end
			end
			Cont.Parent = ContentArea
			tw(TL,{TextTransparency=0},0.28)
			tw(Ind,{Size=UDim2.new(0,2,0,14), BackgroundTransparency=0},0.28)
			tw(TBtn,{BackgroundTransparency=0},0.18)
		end

		function Tab:Disable()
			Cont.Parent = nil
			tw(TL,{TextTransparency=0.38},0.28)
			tw(Ind,{Size=UDim2.new(0,2,0,0), BackgroundTransparency=1},0.28)
			tw(TBtn,{BackgroundTransparency=0.35},0.18)
		end
		function Tab:Enable() Activate() end
		function Tab:Visible(b) TBtn.Visible=b end
		function Tab:Destroy() TBtn:Destroy(); Cont:Destroy() end

		TBtn.Activated:Connect(Activate)

		-- ── Tab elements ──────────────────────────────────

		function Tab:AddSection(cfg4)
			local sname = type(cfg4)=="string" and cfg4 or cfg4.Title or cfg4[1] or "Section"
			local SF = frm(Cont, {
				Size=UDim2.new(1,0,0,18), BackgroundTransparency=1, Name="Section"
			})
			Track(lbl(SF,{
				Size=UDim2.new(1,-20,1,0), Position=UDim2.fromOffset(18,0),
				BackgroundTransparency=1, Text=sname:upper(),
				TextColor3=T.Accent, TextSize=8.5, Font=Enum.Font.GothamBold,
				TextXAlignment=Enum.TextXAlignment.Left,
			}),"Accent")
			-- dot
			Track(frm(SF,{
				Size=UDim2.fromOffset(4,4), Position=UDim2.new(0,8,0.5,0),
				AnchorPoint=Vector2.new(0,0.5), BackgroundColor3=T.Accent, BorderSizePixel=0,
			}),"Accent")
			-- line
			Track(frm(SF,{
				Size=UDim2.new(1,-20,0,1), Position=UDim2.new(0,16,1,-1),
				BackgroundColor3=T.Stroke, BorderSizePixel=0, BackgroundTransparency=0.5,
			}),"Stroke")
			local S = {}
			function S:Set(v) end
			function S:Visible(b) SF.Visible = b end
			function S:Destroy() SF:Destroy() end
			return S
		end

		function Tab:AddParagraph(cfg4)
			local t = cfg4.Title or cfg4[1] or ""
			local d = cfg4.Text  or cfg4[2] or ""
			local row, L = MakeRow(Cont, t, d, 0)
			local P = {}
			function P:SetTitle(v) L:Title(v) end
			function P:SetDesc(v)  L:Desc(v)  end
			function P:Set(a,b) if b then L:Title(a); L:Desc(b) else L:Desc(a) end end
			function P:Visible(b) row.Visible=b end
			function P:Destroy() row:Destroy() end
			return P
		end

		function Tab:AddButton(cfg4)
			local t  = cfg4.Title or cfg4[1] or "Button"
			local d  = cfg4.Desc  or cfg4.Description or ""
			local cb = cfg4.Callback or cfg4[2] or function()end
			local row, L = MakeRow(Cont, t, d, 22)

			-- arrow icon right
			local AI = Track(img(row,{
				Size=UDim2.fromOffset(12,12), Position=UDim2.new(1,-10,0.5,0),
				AnchorPoint=Vector2.new(1,0.5), Image="rbxassetid://10709791437",
				ImageColor3=T.Accent, BackgroundTransparency=1,
			}),"Accent")

			row.Activated:Connect(function()
				tw(AI,{ImageTransparency=0.8},0.08)
				task.delay(0.12,function() tw(AI,{ImageTransparency=0},0.15) end)
				task.spawn(cb)
			end)

			local B = {}
			function B:Set(a,b) if type(a)=="string" and b then L:Title(a);L:Desc(b) elseif type(a)=="string" then L:Title(a) end end
			function B:Visible(b) row.Visible=b end
			function B:Destroy() row:Destroy() end
			function B:Callback(f) cb=f end
			return B
		end

		function Tab:AddToggle(cfg4)
			local t  = cfg4.Title or cfg4[1] or "Toggle"
			local d  = cfg4.Desc  or cfg4.Description or ""
			local def = cfg4.Default or cfg4[2] or false
			local cb = cfg4.Callback or cfg4[3] or function()end
			local flag = cfg4.Flag or false

			local row, L = MakeRow(Cont, t, d, 44)

			-- toggle pill
			local Pill = Track(frm(row,{
				Size=UDim2.fromOffset(36,18), Position=UDim2.new(1,-10,0.5,0),
				AnchorPoint=Vector2.new(1,0.5), BackgroundColor3=T.Stroke, BorderSizePixel=0,
			}),"Stroke")
			corner(Pill, UDim.new(0.5,0))

			local Knob = Track(frm(Pill,{
				Size=UDim2.fromOffset(12,12), Position=UDim2.new(0,3,0.5,0),
				AnchorPoint=Vector2.new(0,0.5), BackgroundColor3=T.Accent, BorderSizePixel=0,
			}),"Accent")
			corner(Knob, UDim.new(0.5,0))

			local state = def
			local busy  = false

			local function SetState(v)
				if busy then return end; busy=true; state=v
				if flag then EmberLib.Flags[flag]=v end
				task.spawn(cb, v)
				if v then
					tw(Knob,{Position=UDim2.new(1,-3,0.5,0), AnchorPoint=Vector2.new(1,0.5)},0.2)
					tw(Pill,{BackgroundColor3=Color3.fromRGB(30,50,20)},0.2)
					tw(Knob,{BackgroundTransparency=0},0.2)
				else
					tw(Knob,{Position=UDim2.new(0,3,0.5,0), AnchorPoint=Vector2.new(0,0.5)},0.2)
					tw(Pill,{BackgroundColor3=T.Stroke},0.2)
					tw(Knob,{BackgroundTransparency=0.5},0.2)
				end
				busy=false
			end
			task.spawn(SetState, state)

			row.Activated:Connect(function() SetState(not state) end)

			local TG = {}
			function TG:Set(v)
				if type(v)=="boolean" then task.spawn(SetState,v)
				elseif type(v)=="string" then L:Title(v) end
			end
			function TG:Visible(b) row.Visible=b end
			function TG:Destroy() row:Destroy() end
			return TG
		end

		function Tab:AddSlider(cfg4)
			local t    = cfg4.Title or cfg4[1] or "Slider"
			local d    = cfg4.Desc  or cfg4.Description or ""
			local minV = cfg4.Min   or cfg4[2] or 0
			local maxV = cfg4.Max   or cfg4[3] or 100
			local def  = cfg4.Default or cfg4[5] or 50
			local inc  = cfg4.Increase or cfg4[4] or 1
			local cb   = cfg4.Callback or cfg4[6] or function()end
			local flag = cfg4.Flag or false

			local row, L = MakeRow(Cont, t, d, 170)

			local SH = Instance.new("TextButton", row)
			SH.Size=UDim2.new(0.45,0,1,0); SH.Position=UDim2.new(1,0,0,0)
			SH.AnchorPoint=Vector2.new(1,0); SH.BackgroundTransparency=1
			SH.Text=""; SH.AutoButtonColor=false

			local Track_ = Track(frm(SH,{
				Size=UDim2.new(1,-18,0,4), Position=UDim2.new(0.5,0,0.5,0),
				AnchorPoint=Vector2.new(0.5,0.5), BackgroundColor3=T.Stroke, BorderSizePixel=0,
			}),"Stroke")
			corner(Track_)

			local Fill = Track(frm(Track_,{
				Size=UDim2.fromScale(0.4,1), BackgroundColor3=T.Accent, BorderSizePixel=0,
			}),"Accent")
			corner(Fill)

			-- glow
			Track(frm(Track_,{
				Size=UDim2.fromScale(0.4,4), Position=UDim2.new(0,0,0.5,0),
				AnchorPoint=Vector2.new(0,0.5), BackgroundColor3=T.Accent,
				BorderSizePixel=0, BackgroundTransparency=0.72,
			}),"Accent")

			local Thumb = Track(frm(Track_,{
				Size=UDim2.fromOffset(5,14), Position=UDim2.fromScale(0.4,0.5),
				AnchorPoint=Vector2.new(0.5,0.5), BackgroundColor3=T.Text, BorderSizePixel=0,
			}),"Text")
			corner(Thumb, UDim.new(0,3))

			local ValL = Track(lbl(SH,{
				Size=UDim2.fromOffset(20,14), Position=UDim2.new(0,0,0.5,0),
				AnchorPoint=Vector2.new(1,0.5), BackgroundTransparency=1,
				TextColor3=T.Text, TextSize=11, Font=Enum.Font.GothamBold,
			}),"Text")
			local UISc = Instance.new("UIScale", ValL)

			local curVal = def
			local function SetVal(v)
				v = math.clamp(math.floor(v/inc)*inc, minV, maxV)
				curVal = v
				local sp = (v-minV)/(maxV-minV)
				Fill.Size       = UDim2.fromScale(sp,1)
				Thumb.Position  = UDim2.fromScale(sp,0.5)
				ValL.Text       = tostring(v)
				if flag then EmberLib.Flags[flag]=v end
				task.spawn(cb,v)
				-- bounce anim on label
				UISc.Scale=0.4; tw(UISc,{Scale=1.15},0.1)
				task.delay(0.11,function() tw(UISc,{Scale=1},0.15) end)
			end

			SH.MouseButton1Down:Connect(function()
				Cont.ScrollingEnabled=false
				while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
					task.wait()
					local ax = Player:GetMouse().X - Track_.AbsolutePosition.X
					local sp = math.clamp(ax/Track_.AbsoluteSize.X, 0, 1)
					SetVal(minV + sp*(maxV-minV))
				end
				Cont.ScrollingEnabled=true
			end)

			SetVal(def)

			local SL = {}
			function SL:Set(v)
				if type(v)=="number" then SetVal(v)
				elseif type(v)=="string" then L:Title(v) end
			end
			function SL:Visible(b) row.Visible=b end
			function SL:Destroy() row:Destroy() end
			return SL
		end

		function Tab:AddDropdown(cfg4)
			local t    = cfg4.Title   or cfg4[1] or "Dropdown"
			local d    = cfg4.Desc    or cfg4.Description or ""
			local opts = cfg4.Options or cfg4[2] or {}
			local def  = cfg4.Default or cfg4[3]
			local cb   = cfg4.Callback or cfg4[4] or function()end
			local flag = cfg4.Flag or false

			local row, L = MakeRow(Cont, t, d, 165)

			local SelF = Track(frm(row,{
				Size=UDim2.fromOffset(148,20), Position=UDim2.new(1,-10,0.5,0),
				AnchorPoint=Vector2.new(1,0.5), BackgroundColor3=T.Stroke, BorderSizePixel=0,
			}),"Stroke")
			corner(SelF, UDim.new(0,5))

			local SelL = Track(lbl(SelF,{
				Size=UDim2.new(0.82,0,1,0), Position=UDim2.new(0,6,0,0),
				BackgroundTransparency=1, TextScaled=true, Font=Enum.Font.GothamBold,
				TextColor3=T.Text, Text="...",
			}),"Text")

			local Arr = Track(img(SelF,{
				Size=UDim2.fromOffset(12,12), Position=UDim2.new(0,-5,0.5,0),
				AnchorPoint=Vector2.new(1,0.5), Image="rbxassetid://10709791523",
				ImageColor3=T.Accent, BackgroundTransparency=1,
			}),"Accent")

			-- drop frame (parented to ScreenGui to avoid clipping)
			local AntiClick = btn(SGui,{
				Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", Visible=false, ZIndex=50,
			})
			local DF = frm(AntiClick,{
				Size=UDim2.fromOffset(148,0), BackgroundColor3=Color3.fromRGB(18,12,18),
				BackgroundTransparency=0.04, BorderSizePixel=0, ClipsDescendants=true, ZIndex=51,
			})
			corner(DF); stroke(DF, T.Stroke, 1)
			local DG2 = Instance.new("UIGradient", DF)
			DG2.Color = T.Hub1; DG2.Rotation = 130

			local SF2 = Instance.new("ScrollingFrame", DF)
			SF2.Size=UDim2.new(1,0,1,0); SF2.BackgroundTransparency=1
			SF2.BorderSizePixel=0; SF2.ScrollBarThickness=1.5
			SF2.ScrollBarImageColor3=T.Accent; SF2.CanvasSize=UDim2.new()
			SF2.AutomaticCanvasSize=Enum.AutomaticSize.Y
			SF2.ScrollingDirection=Enum.ScrollingDirection.Y
			pad(SF2,6,6,5,5); list(SF2, Enum.FillDirection.Vertical,3)

			local curSel = def
			local optItems = {}
			local open = false

			local function UpdateLabel()
				SelL.Text = curSel ~= nil and tostring(curSel) or "..."
			end

			local function Close()
				if not open then return end; open=false
				tw(Arr,{Rotation=0},0.18)
				tw(DF,{Size=UDim2.fromOffset(148,0)},0.2)
				task.wait(0.21); AntiClick.Visible=false
			end

			local function Open()
				if open then return end; open=true
				AntiClick.Visible=true
				local abs = SelF.AbsolutePosition
				local sz  = math.clamp(#optItems,1,8)*24+10
				DF.Position = UDim2.fromOffset(abs.X/UIScale, abs.Y/UIScale)
				tw(Arr,{Rotation=180},0.18)
				tw(DF,{Size=UDim2.fromOffset(148,sz)},0.22)
			end

			AntiClick.MouseButton1Down:Connect(Close)

			local function AddOpt(v)
				if optItems[tostring(v)] then return end
				local ob = btn(SF2,{
					Size=UDim2.new(1,0,0,21), BackgroundColor3=T.Hub2,
					BorderSizePixel=0, Text="", AutoButtonColor=false,
				})
				Track(ob,"Hub2"); corner(ob, UDim.new(0,5))
				local sel_ind = Track(frm(ob,{
					Size=UDim2.fromOffset(3,3), Position=UDim2.new(0,4,0.5,0),
					AnchorPoint=Vector2.new(0,0.5), BackgroundColor3=T.Accent,
					BorderSizePixel=0, BackgroundTransparency=1,
				}),"Accent")
				corner(sel_ind, UDim.new(0.5,0))
				local ol = Track(lbl(ob,{
					Size=UDim2.new(1,0,1,0), Position=UDim2.fromOffset(12,0),
					BackgroundTransparency=1, Text=tostring(v),
					TextColor3=T.Text, TextSize=9, Font=Enum.Font.GothamMedium,
					TextXAlignment=Enum.TextXAlignment.Left, TextTransparency=0.35,
				}),"Text")
				ob.MouseEnter:Connect(function() tw(ob,{BackgroundTransparency=0.35},0.12) end)
				ob.MouseLeave:Connect(function() tw(ob,{BackgroundTransparency=0},0.12) end)
				ob.Activated:Connect(function()
					curSel = v
					UpdateLabel()
					if flag then EmberLib.Flags[flag]=v end
					task.spawn(cb,v)
					-- update indicators
					for _, it in pairs(optItems) do
						local isSel = it.val == v
						tw(it.ind,{BackgroundTransparency=isSel and 0 or 1, Size=isSel and UDim2.fromOffset(3,12) or UDim2.fromOffset(3,3)},0.2)
						tw(it.lbl,{TextTransparency=isSel and 0 or 0.35},0.2)
					end
					Close()
				end)
				optItems[tostring(v)] = {val=v, ind=sel_ind, lbl=ol}
			end

			for _,v in pairs(opts) do AddOpt(v) end
			UpdateLabel()

			row.Activated:Connect(function() if open then Close() else Open() end end)
			Main:GetPropertyChangedSignal("Visible"):Connect(Close)

			local DD = {}
			function DD:Set(v)
				if type(v)=="table" then
					for _,it in pairs(optItems) do it.ind.Parent.Parent:Destroy() end
					optItems = {}
					for _,ov in pairs(v) do AddOpt(ov) end
				elseif type(v)~="nil" then
					curSel=v; UpdateLabel()
				end
			end
			function DD:Add(v) AddOpt(v) end
			function DD:Visible(b) row.Visible=b end
			function DD:Destroy() row:Destroy() end
			return DD
		end

		function Tab:AddTextBox(cfg4)
			local t   = cfg4.Title or cfg4[1] or "TextBox"
			local d   = cfg4.Desc  or cfg4.Description or ""
			local ph  = cfg4.Placeholder or cfg4[5] or "Type here..."
			local cb  = cfg4.Callback or cfg4[4] or function()end

			local row, L = MakeRow(Cont, t, d, 164)

			local InputF = Track(frm(row,{
				Size=UDim2.fromOffset(148,20), Position=UDim2.new(1,-10,0.5,0),
				AnchorPoint=Vector2.new(1,0.5), BackgroundColor3=T.Stroke, BorderSizePixel=0,
			}),"Stroke")
			corner(InputF, UDim.new(0,5))
			local InSt = stroke(InputF, T.Stroke, 1)
			Track(InSt,"Stroke")

			local TB = Instance.new("TextBox", InputF)
			TB.Size=UDim2.new(1,-10,1,0); TB.Position=UDim2.fromOffset(5,0)
			TB.BackgroundTransparency=1; TB.PlaceholderText=ph
			TB.PlaceholderColor3=T.SubText; TB.Text=""
			TB.TextColor3=T.Text; TB.TextSize=10
			TB.Font=Enum.Font.GothamMedium; TB.ClearTextOnFocus=false
			Track(TB,"Text")

			-- pencil icon
			local PI = Track(img(InputF,{
				Size=UDim2.fromOffset(10,10), Position=UDim2.new(0,-4,0.5,0),
				AnchorPoint=Vector2.new(1,0.5), Image="rbxassetid://15637081879",
				ImageColor3=T.SubText, BackgroundTransparency=1,
			}),"Sub")

			TB.Focused:Connect(function() tw(InSt,{Color=T.Accent},0.18); tw(PI,{ImageColor3=T.Accent},0.18) end)
			TB.FocusLost:Connect(function(enter)
				tw(InSt,{Color=T.Stroke},0.18); tw(PI,{ImageColor3=T.SubText},0.18)
				if enter or TB.Text~="" then task.spawn(cb, TB.Text) end
			end)

			local TX = {}
			function TX:Visible(b) row.Visible=b end
			function TX:Destroy() row:Destroy() end
			return TX
		end

		-- first tab auto-activate
		if #ContList == 1 then
			Activate()
		end

		return Tab
	end -- MakeTab

	-- activate first tab when created
	task.delay(0.05, function()
		if EmberLib.Tabs[1] then EmberLib.Tabs[1].func:Enable() end
	end)

	-- ── ready notify ──────────────────────────────────────
	task.delay(0.2, function()
		EmberLib:Notify({Title="✅ Script Active", Text="Ember UI loaded successfully!", Duration=4, Type="Success"})
	end)

	return Win
end -- MakeWindow

return EmberLib
