local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local CFG = {
	Size = 340,
	PosX = 0.5,
	PosY = 0.5,
	ParticleCount = 120,
	DiskSpeed = 1.2,
	CoreRatio = 0.28,
	PhotonThick = 4,
	CyanColor = Color3.fromRGB(0, 220, 255),
	CyanBright = Color3.fromRGB(180, 255, 255),
	CyanDeep = Color3.fromRGB(0, 100, 200),
	CyanOuter = Color3.fromRGB(0, 50, 130),
	StarColor = Color3.fromRGB(180, 220, 255),
	StarCount = 80,
	ShowJets = true,
	GuiName = "BlackHole_Cyan_LOPK",
}

local old = CoreGui:FindFirstChild(CFG.GuiName)
if old then old:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = CFG.GuiName
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

local function New(class, props, children)
	local inst = Instance.new(class)
	if props then
		for k, v in pairs(props) do inst[k] = v end
	end
	if children then
		for _, child in ipairs(children) do child.Parent = inst end
	end
	return inst
end

local function Tween(inst, props, time, style, dir)
	local info = TweenInfo.new(
		time or 0.5,
		style or Enum.EasingStyle.Sine,
		dir or Enum.EasingDirection.InOut,
		-1,
		true
	)
	TweenService:Create(inst, info, props):Play()
end

local function TweenOnce(inst, props, time, style, dir)
	local info = TweenInfo.new(
		time or 0.5,
		style or Enum.EasingStyle.Quint,
		dir or Enum.EasingDirection.Out
	)
	local tw = TweenService:Create(inst, info, props)
	tw:Play()
	return tw
end

local S = CFG.Size
local CX = UDim2.new(CFG.PosX, 0, CFG.PosY, 0)

local BG = New("Frame", {
	Name = "BG",
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundColor3 = Color3.fromRGB(0, 2, 8),
	BorderSizePixel = 0,
	ZIndex = 1,
	Parent = ScreenGui,
})

for i = 1, CFG.StarCount do
	local star = New("Frame", {
		Name = "Star" .. i,
		Size = UDim2.fromOffset(math.random(1, 2), math.random(1, 2)),
		Position = UDim2.new(math.random(), 0, math.random(), 0),
		BackgroundColor3 = CFG.StarColor,
		BorderSizePixel = 0,
		ZIndex = 2,
		BackgroundTransparency = math.random() * 0.5,
		Parent = BG,
	})
	New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = star })
	Tween(star, { BackgroundTransparency = math.random() * 0.3 + 0.6 }, math.random(2, 5) + math.random(), Enum.EasingStyle.Sine)
end

local Hub = New("Frame", {
	Name = "BlackHoleHub",
	Size = UDim2.fromOffset(S, S),
	Position = CX,
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundTransparency = 1,
	ZIndex = 3,
	ClipsDescendants = false,
	Parent = ScreenGui,
})

local function MakeGlowRing(size, color, trans, zidx, parent)
	local ring = New("ImageLabel", {
		Size = UDim2.fromOffset(size, size),
		Position = UDim2.new(0.5, -size / 2, 0.5, -size / 2),
		BackgroundTransparency = 1,
		Image = "rbxassetid://6401143412",
		ImageColor3 = color,
		ImageTransparency = trans,
		ZIndex = zidx,
		Parent = parent,
	})
	return ring
end

MakeGlowRing(S * 2.2, CFG.CyanOuter, 0.92, 3, Hub)
MakeGlowRing(S * 1.8, CFG.CyanDeep, 0.88, 3, Hub)
MakeGlowRing(S * 1.4, CFG.CyanDeep, 0.82, 3, Hub)
MakeGlowRing(S * 1.1, CFG.CyanColor, 0.78, 3, Hub)
MakeGlowRing(S * 0.9, CFG.CyanColor, 0.72, 4, Hub)
MakeGlowRing(S * 0.7, CFG.CyanBright, 0.65, 4, Hub)

local outerGlow = MakeGlowRing(S * 1.6, CFG.CyanDeep, 0.85, 3, Hub)
Tween(outerGlow, { ImageTransparency = 0.78 }, 2.5, Enum.EasingStyle.Sine)

local DiskContainer = New("Frame", {
	Name = "DiskContainer",
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	ZIndex = 5,
	Parent = Hub,
})

local diskLayers = {
	{ size = S * 0.95, color = CFG.CyanOuter,  trans = 0.80, tilt = 0.78 },
	{ size = S * 0.85, color = CFG.CyanDeep,   trans = 0.72, tilt = 0.76 },
	{ size = S * 0.75, color = CFG.CyanColor,  trans = 0.60, tilt = 0.74 },
	{ size = S * 0.65, color = CFG.CyanColor,  trans = 0.50, tilt = 0.72 },
	{ size = S * 0.55, color = CFG.CyanBright, trans = 0.40, tilt = 0.70 },
	{ size = S * 0.45, color = CFG.CyanBright, trans = 0.30, tilt = 0.68 },
}

local diskFrames = {}
for i, layer in ipairs(diskLayers) do
	local disk = New("ImageLabel", {
		Name = "Disk" .. i,
		Size = UDim2.fromOffset(layer.size, layer.size * layer.tilt),
		Position = UDim2.new(0.5, -layer.size / 2, 0.5, -(layer.size * layer.tilt) / 2),
		BackgroundTransparency = 1,
		Image = "rbxassetid://6401143412",
		ImageColor3 = layer.color,
		ImageTransparency = layer.trans,
		ZIndex = 5,
		Parent = DiskContainer,
	})
	New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = disk })
	Tween(disk, { ImageTransparency = layer.trans + 0.12 }, 1.8 + i * 0.3, Enum.EasingStyle.Sine)
	table.insert(diskFrames, disk)
end

local ParticleHolder = New("Frame", {
	Name = "Particles",
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	ZIndex = 6,
	Parent = Hub,
})

local function getParticleColor(r, minR, maxR)
	local t = math.clamp((r - minR) / (maxR - minR), 0, 1)
	if t < 0.15 then
		return Color3.fromRGB(220, 255, 255)
	elseif t < 0.40 then
		return Color3.fromRGB(0, 230, 255)
	elseif t < 0.65 then
		return Color3.fromRGB(0, 180, 255)
	elseif t < 0.82 then
		return Color3.fromRGB(0, 120, 220)
	else
		return Color3.fromRGB(0, 60, 160)
	end
end

local particles = {}
local minR = S * 0.18
local maxR = S * 0.50

for i = 1, CFG.ParticleCount do
	local raw = math.random()
	local radius = minR + math.pow(raw, 1.7) * (maxR - minR)
	local angle = math.random() * math.pi * 2
	local speed = 0.00042 * math.pow((S * 0.16) / radius, 1.5) * (0.88 + math.random() * 0.24) * CFG.DiskSpeed
	local pColor = getParticleColor(radius, minR, maxR)
	local pSize = math.floor(1 + (radius / maxR) * 3)
	local bri = 0.15 + (1 - (radius - minR) / (maxR - minR)) * 0.85

	local dot = New("Frame", {
		Name = "P" .. i,
		Size = UDim2.fromOffset(pSize, pSize),
		BackgroundColor3 = pColor,
		BackgroundTransparency = 1 - bri * 0.7,
		BorderSizePixel = 0,
		ZIndex = 6,
		Parent = ParticleHolder,
	})
	New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = dot })

	table.insert(particles, {
		frame = dot,
		radius = radius,
		angle = angle,
		speed = speed,
		bri = bri,
		zOff = (math.random() - 0.5) * 0.055,
		pSize = pSize,
	})
end

local photonSize = S * CFG.CoreRatio * 2.1

local PhotonRing = New("ImageLabel", {
	Name = "PhotonRing",
	Size = UDim2.fromOffset(photonSize, photonSize),
	Position = UDim2.new(0.5, -photonSize / 2, 0.5, -photonSize / 2),
	BackgroundTransparency = 1,
	Image = "rbxassetid://6401143412",
	ImageColor3 = CFG.CyanBright,
	ImageTransparency = 0.10,
	ZIndex = 8,
	Parent = Hub,
})
New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = PhotonRing })

local photonStrokeSize = photonSize + CFG.PhotonThick * 2
local PhotonStroke = New("Frame", {
	Name = "PhotonStroke",
	Size = UDim2.fromOffset(photonStrokeSize, photonStrokeSize),
	Position = UDim2.new(0.5, -photonStrokeSize / 2, 0.5, -photonStrokeSize / 2),
	BackgroundTransparency = 1,
	ZIndex = 8,
	Parent = Hub,
})
New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = PhotonStroke })
local photonUIStroke = New("UIStroke", {
	Color = CFG.CyanBright,
	Thickness = CFG.PhotonThick,
	ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	Parent = PhotonStroke,
})

Tween(PhotonRing, { ImageTransparency = 0.25 }, 1.6, Enum.EasingStyle.Sine)
Tween(photonUIStroke, { Transparency = 0.20 }, 1.9, Enum.EasingStyle.Sine)

local lensRings = {
	{ mult = 1.15, color = CFG.CyanColor,  trans = 0.55, thick = 2 },
	{ mult = 1.28, color = CFG.CyanColor,  trans = 0.72, thick = 2 },
	{ mult = 1.45, color = CFG.CyanDeep,   trans = 0.82, thick = 1.5 },
	{ mult = 1.65, color = CFG.CyanDeep,   trans = 0.88, thick = 1 },
	{ mult = 1.90, color = CFG.CyanOuter,  trans = 0.92, thick = 1 },
}

for i, lr in ipairs(lensRings) do
	local lsz = photonSize * lr.mult
	local lf = New("Frame", {
		Size = UDim2.fromOffset(lsz, lsz),
		Position = UDim2.new(0.5, -lsz / 2, 0.5, -lsz / 2),
		BackgroundTransparency = 1,
		ZIndex = 7,
		Parent = Hub,
	})
	New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = lf })
	local ls = New("UIStroke", {
		Color = lr.color,
		Thickness = lr.thick,
		Transparency = lr.trans,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = lf,
	})
	Tween(ls, { Transparency = math.min(lr.trans + 0.08, 0.98) }, 1.4 + i * 0.25, Enum.EasingStyle.Sine)
end

if CFG.ShowJets then
	local function MakeJet(dir)
		local jetH = S * 0.70
		local jet = New("ImageLabel", {
			Name = "Jet" .. (dir > 0 and "Down" or "Up"),
			Size = UDim2.fromOffset(S * 0.07, jetH),
			Position = UDim2.new(0.5, -S * 0.035, dir > 0 and 0.5 or 0.5 - jetH / S, dir > 0 and 0 or 0),
			BackgroundTransparency = 1,
			Image = "rbxassetid://6401143412",
			ImageColor3 = CFG.CyanColor,
			ImageTransparency = 0.35,
			ZIndex = 4,
			Parent = Hub,
		})
		Tween(jet, { ImageTransparency = 0.60 }, 1.1 + math.random() * 0.5, Enum.EasingStyle.Sine)
		return jet
	end
	MakeJet(-1)
	MakeJet(1)
end

local coreSize = S * CFG.CoreRatio

local coreGlow = New("ImageLabel", {
	Name = "CoreGlow",
	Size = UDim2.fromOffset(coreSize * 1.3, coreSize * 1.3),
	Position = UDim2.new(0.5, -coreSize * 0.65, 0.5, -coreSize * 0.65),
	BackgroundTransparency = 1,
	Image = "rbxassetid://6401143412",
	ImageColor3 = CFG.CyanColor,
	ImageTransparency = 0.72,
	ZIndex = 9,
	Parent = Hub,
})
New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = coreGlow })
Tween(coreGlow, { ImageTransparency = 0.82 }, 2.2, Enum.EasingStyle.Sine)

local Core = New("Frame", {
	Name = "EventHorizon",
	Size = UDim2.fromOffset(coreSize, coreSize),
	Position = UDim2.new(0.5, -coreSize / 2, 0.5, -coreSize / 2),
	BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	BorderSizePixel = 0,
	ZIndex = 10,
	Parent = Hub,
})
New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Core })

local coreStroke = New("UIStroke", {
	Color = CFG.CyanColor,
	Thickness = 1.5,
	Transparency = 0.75,
	ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	Parent = Core,
})
Tween(coreStroke, { Transparency = 0.88 }, 1.8, Enum.EasingStyle.Sine)

local Label = New("TextLabel", {
	Name = "Label",
	Size = UDim2.new(1, 0, 0, 20),
	Position = UDim2.new(0, 0, 1, 20),
	BackgroundTransparency = 1,
	Text = "LOPK · SCHWARZSCHILD · CYAN",
	TextColor3 = CFG.CyanColor,
	TextTransparency = 0.5,
	Font = Enum.Font.Code,
	TextSize = 10,
	TextXAlignment = Enum.TextXAlignment.Center,
	ZIndex = 10,
	Parent = Hub,
})
Tween(Label, { TextTransparency = 0.15 }, 2.5, Enum.EasingStyle.Sine)

local HubBorder = New("Frame", {
	Size = UDim2.fromOffset(S * 1.01, S * 1.01),
	Position = UDim2.new(0.5, -S * 0.505, 0.5, -S * 0.505),
	BackgroundTransparency = 1,
	ZIndex = 11,
	Parent = Hub,
})
New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = HubBorder })
local hubStroke = New("UIStroke", {
	Color = CFG.CyanColor,
	Thickness = 1,
	Transparency = 0.6,
	ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	Parent = HubBorder,
})
Tween(hubStroke, { Transparency = 0.85 }, 3.0, Enum.EasingStyle.Sine)

local TILT = 0.22
local halfS = S / 2

RunService.Heartbeat:Connect(function(dt)
	for _, p in ipairs(particles) do
		p.angle = p.angle + p.speed * dt * 60

		local cosA = math.cos(p.angle)
		local sinA = math.sin(p.angle)

		local px = cosA * p.radius
		local py = sinA * p.radius * math.sin(TILT) + p.zOff * p.radius

		local dop = 0.45 + 0.55 * math.cos(p.angle + math.pi)

		local dist2 = px * px + py * py
		if dist2 < (coreSize * 0.52) ^ 2 then
			p.frame.Visible = false
		else
			p.frame.Visible = true

			local isBack = sinA > 0
			local alpha = isBack
				and p.bri * dop * 0.32
				or p.bri * (0.5 + 0.5 * dop)

			p.frame.Position = UDim2.fromOffset(
				halfS + px - p.pSize / 2,
				halfS + py - p.pSize / 2
			)
			p.frame.BackgroundTransparency = math.clamp(1 - alpha, 0, 1)
		end
	end
end)

local BlackHole = {}

function BlackHole:Destroy()
	ScreenGui:Destroy()
end

function BlackHole:Toggle(visible)
	Hub.Visible = visible ~= nil and visible or not Hub.Visible
end

function BlackHole:SetPosition(x, y)
	TweenOnce(Hub, { Position = UDim2.new(x or CFG.PosX, 0, y or CFG.PosY, 0) }, 0.5)
end

function BlackHole:SetColor(color3)
	photonUIStroke.Color = color3
	coreStroke.Color = color3
	Label.TextColor3 = color3
end

function BlackHole:Appear()
	Hub.Size = UDim2.fromOffset(0, 0)
	TweenOnce(Hub, { Size = UDim2.fromOffset(S, S) }, 0.7, Enum.EasingStyle.Back)
end

BlackHole:Appear()

return BlackHole
