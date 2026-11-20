local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

local CONFIG = {
	Title = "MATRIX UI",
	Width = 500,
	Height = 340,
	CornerRadius = 14,
	ToggleWidth = 120,
	ToggleHeight = 34,
	ToggleRadius = 10,
	BorderThickness = 2,
	BorderSpeed = 80,
	Accent = Color3.fromRGB(0, 255, 65),
	ToggleKey = Enum.KeyCode.RightShift,

	Tabs = { "Combat", "Movement", "Visual", "Weapons", "Residences", "Settings" },
	TabWidth = 110,
	TabHeight = 40,
	TabIdleColor = Color3.fromRGB(128, 128, 128),
	TabHoverColor = Color3.fromRGB(190, 190, 190),
	TabFade = true,

	HitboxPart = "HumanoidRootPart",
	HitboxDefault = 10,
	HitboxMax = 100,
	HitboxTransparency = 0.7,

	SpeedMin = 1,
	SpeedMax = 1000,

	ESPColor = Color3.fromRGB(255, 255, 255),
	ESPFillTransparency = 0.6,
	ESPOutlineTransparency = 0.1,

	MachineName = "VendingMachine",
	MachineColor = Color3.fromRGB(255, 200, 60),
	MachineFillTransparency = 0.5,
	MachineOutlineTransparency = 0,

	Key = "discordggreceb",

	ResidenceFile = "Residences.txt",
	ResidenceCache = "Residences_cache.json",

		Weapons = {
		"Baton", "Bo Staff", "Club", "Golf Club", "Spear",
		"War Axe", "Shovel", "Longsword", "Hammer", "Bat",
		"Crowbar", "FireAxeV1", "Lance",
	},

	HitWeapons = {
		"Baton", "Bo Staff", "Club", "Golf Club", "Spear",
		"War Axe", "Shovel", "Longsword", "Hammer", "Bat",
		"Crowbar", "FireAxeV1", "Lance", "",
	},
}

local COLUMN_WIDTH = 20
local COLUMN_STEP = 25
local FONT_SIZE = 16
local LINE_HEIGHT = 18

local DELAYS = {
	2.5, 3.2, 1.8, 2.9, 1.5, 3.8, 2.1, 2.7, 3.4, 1.9,
	3.6, 2.3, 3.1, 2.6, 3.7, 2.8, 3.3, 2.2, 3.9, 2.4,
	1.7, 3.5, 2.0, 4.0, 1.6, 3.0, 3.8, 2.5, 3.2, 2.7,
	1.8, 3.6, 2.1, 3.4, 2.8, 3.7, 2.3, 1.9, 3.5, 2.6,
}

local DURATIONS = {
	3.0, 4.0, 2.5, 3.5, 3.0, 4.5, 2.8, 3.2, 3.8, 2.7,
	4.2, 3.1, 3.6, 2.9, 4.1, 3.3, 3.7, 2.6, 4.3, 3.4,
	2.4, 3.9, 3.0, 4.4, 2.3, 3.5, 4.0, 2.8, 3.6, 3.2,
	2.7, 4.1, 3.1, 3.7, 2.9, 4.2, 3.3, 2.5, 3.8, 3.4,
}

local SET_ODD = "アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲン123456789"
local SET_EVEN = "ガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポヴァィゥェォャュョッABCDEFGHIJKLMNOPQRSTUVWXYZ"
local SET_3N = "アカサタナハマヤラワイキシチニヒミリウクスツヌフムユルエケセテネヘメレオコソトノホモヨロヲン0987654321"
local SET_4N = "ンヲロヨモホノトソコオレメヘネテセケエルユムフヌツスクウリミヒニチシキイワラヤマハナタサカア"
local SET_5N = "ガザダバパギジヂビピグズヅブプゲゼデベペゴゾドボポヴァィゥェォャュョッ!@#$%^&*()_+-=[]{}|;:,.<>?"

local function getCharSet(i)
	if i % 5 == 0 then
		return SET_5N
	elseif i % 4 == 0 then
		return SET_4N
	elseif i % 3 == 0 then
		return SET_3N
	elseif i % 2 == 0 then
		return SET_EVEN
	end
	return SET_ODD
end

local function toVertical(str)
	local chars = {}
	for _, code in utf8.codes(str) do
		chars[#chars + 1] = utf8.char(code)
	end
	return table.concat(chars, "\n"), #chars
end

local function make(className, props, parent)
	local obj = Instance.new(className)
	for k, v in pairs(props or {}) do
		obj[k] = v
	end
	if parent then
		obj.Parent = parent
	end
	return obj
end

local function getGuiParent()
	if typeof(gethui) == "function" then
		local ok, hui = pcall(gethui)
		if ok and hui then
			return hui
		end
	end
	local ok, core = pcall(function()
		return game:GetService("CoreGui")
	end)
	if ok and core then
		return core
	end
	return LocalPlayer:WaitForChild("PlayerGui")
end

local connections = {}
local function track(conn)
	connections[#connections + 1] = conn
	return conn
end

if _G.MatrixUICleanup then
	pcall(_G.MatrixUICleanup)
	_G.MatrixUICleanup = nil
end

local parent = getGuiParent()
local old = parent:FindFirstChild("MatrixUI")
if old then
	old:Destroy()
end

local gui = make("ScreenGui", {
	Name = "MatrixUI",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

local okParent = pcall(function()
	gui.Parent = parent
end)
if not okParent or not gui.Parent then
	gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

gui.Destroying:Connect(function()
	for _, c in ipairs(connections) do
		c:Disconnect()
	end
end)

local function makeRainGradient()
	return make("UIGradient", {
		Rotation = 90,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.05, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.10, Color3.fromRGB(0, 255, 65)),
			ColorSequenceKeypoint.new(0.20, Color3.fromRGB(0, 255, 65)),
			ColorSequenceKeypoint.new(0.30, Color3.fromRGB(0, 221, 51)),
			ColorSequenceKeypoint.new(0.40, Color3.fromRGB(0, 187, 34)),
			ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 153, 17)),
			ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 119, 0)),
			ColorSequenceKeypoint.new(0.70, Color3.fromRGB(0, 85, 0)),
			ColorSequenceKeypoint.new(0.80, Color3.fromRGB(0, 51, 0)),
			ColorSequenceKeypoint.new(0.90, Color3.fromRGB(0, 255, 65)),
			ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 255, 65)),
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0.00, 0),
			NumberSequenceKeypoint.new(0.80, 0),
			NumberSequenceKeypoint.new(0.90, 0.5),
			NumberSequenceKeypoint.new(1.00, 1),
		}),
	})
end

local borderGradients = {}

local function addGlowBorder(frame, thickness)
	local stroke = make("UIStroke", {
		Color = Color3.new(1, 1, 1),
		Thickness = thickness,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, frame)
	local gradient = make("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 255, 65)),
			ColorSequenceKeypoint.new(0.25, Color3.fromRGB(190, 255, 205)),
			ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 65)),
			ColorSequenceKeypoint.new(0.75, Color3.fromRGB(0, 70, 20)),
			ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 255, 65)),
		}),
	}, stroke)
	borderGradients[#borderGradients + 1] = gradient
	return stroke
end

track(RunService.RenderStepped:Connect(function()
	local rotation = (os.clock() * CONFIG.BorderSpeed) % 360
	for i = #borderGradients, 1, -1 do
		local g = borderGradients[i]
		if g.Parent then
			g.Rotation = rotation
		else
			table.remove(borderGradients, i)
		end
	end
end))

local function createMatrix(container, width, root, radius, opts)
	opts = opts or {}
	local colStep = opts.Step or COLUMN_STEP
	local colWidth = opts.ColWidth or COLUMN_WIDTH
	local fontSize = opts.FontSize or FONT_SIZE
	local lineHeight = opts.LineHeight or LINE_HEIGHT

	local inset = math.ceil(radius * 0.2929) + 1
	local innerWidth = width - inset * 2

	local matrix = make("Frame", {
		Name = "Matrix",
		Position = UDim2.fromOffset(inset, inset),
		Size = UDim2.new(1, -inset * 2, 1, -inset * 2),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 1,
	}, container)
	make("UICorner", { CornerRadius = UDim.new(0, math.max(radius - inset, 4)) }, matrix)

	local columnCount = math.max(1, math.ceil(innerWidth / colStep))
	local columns = {}

	for i = 1, columnCount do
		local cfgIndex = ((i - 1) % #DELAYS) + 1
		local text, length = toVertical(getCharSet(i))

		local label = make("TextLabel", {
			Name = "Column" .. i,
			Size = UDim2.fromOffset(colWidth, length * lineHeight),
			Position = UDim2.fromOffset((i - 1) * colStep, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = text,
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = fontSize,
			LineHeight = lineHeight / fontSize,
			Font = Enum.Font.Code,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = false,
			ZIndex = 1,
		}, matrix)
		makeRainGradient().Parent = label

		columns[i] = {
			Label = label,
			X = (i - 1) * colStep,
			Delay = DELAYS[cfgIndex],
			Duration = DURATIONS[cfgIndex],
		}
	end

	track(RunService.RenderStepped:Connect(function()
		if not root.Visible then
			return
		end
		local height = matrix.AbsoluteSize.Y
		local now = os.clock()
		for _, col in ipairs(columns) do
			local t = ((now + col.Delay) % col.Duration) / col.Duration
			col.Label.Position = UDim2.fromOffset(col.X, height * (-1.1 + 2.1 * t))
			col.Label.TextTransparency = t
		end
	end))

	return matrix, inset
end

local function makeDraggable(handle, target, onClick)
	local dragging, dragStart, startPos, moved = false, nil, nil, false

	track(handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			moved = false
			dragStart = input.Position
			startPos = target.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					if not moved and onClick then
						onClick()
					end
				end
			end)
		end
	end))

	track(UserInputService.InputChanged:Connect(function(input)
		if dragging
			and (input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			if delta.Magnitude > 6 then
				moved = true
			end
			if moved then
				target.Position = UDim2.new(
					startPos.X.Scale, startPos.X.Offset + delta.X,
					startPos.Y.Scale, startPos.Y.Offset + delta.Y
				)
			end
		end
	end))
end

local main = make("Frame", {
	Name = "Main",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.fromOffset(CONFIG.Width, CONFIG.Height),
	BackgroundColor3 = Color3.new(0, 0, 0),
	BorderSizePixel = 0,
}, gui)
make("UICorner", { CornerRadius = UDim.new(0, CONFIG.CornerRadius) }, main)
addGlowBorder(main, CONFIG.BorderThickness)

local mainInset = select(2, createMatrix(main, CONFIG.Width, main, CONFIG.CornerRadius))

local toggleFrame = make("Frame", {
	Name = "ToggleButton",
	AnchorPoint = Vector2.new(0.5, 0),
	Position = UDim2.new(0.5, 0, 0, 8),
	Size = UDim2.fromOffset(CONFIG.ToggleWidth, CONFIG.ToggleHeight),
	BackgroundColor3 = Color3.new(0, 0, 0),
	BorderSizePixel = 0,
}, gui)
make("UICorner", { CornerRadius = UDim.new(0, CONFIG.ToggleRadius) }, toggleFrame)
addGlowBorder(toggleFrame, CONFIG.BorderThickness)

local toggleInset = select(2, createMatrix(toggleFrame, CONFIG.ToggleWidth, toggleFrame, CONFIG.ToggleRadius))

local dim = make("Frame", {
	Name = "Dim",
	Position = UDim2.fromOffset(toggleInset, toggleInset),
	Size = UDim2.new(1, -toggleInset * 2, 1, -toggleInset * 2),
	BackgroundColor3 = Color3.new(0, 0, 0),
	BackgroundTransparency = 0.45,
	BorderSizePixel = 0,
	ZIndex = 2,
}, toggleFrame)
make("UICorner", { CornerRadius = UDim.new(0, math.max(CONFIG.ToggleRadius - toggleInset, 4)) }, dim)

local toggleLabel = make("TextButton", {
	Name = "Label",
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	Text = "[ HIDE ]",
	TextColor3 = CONFIG.Accent,
	TextSize = 14,
	Font = Enum.Font.Code,
	TextStrokeColor3 = Color3.new(0, 0, 0),
	TextStrokeTransparency = 0.3,
	AutoButtonColor = false,
	ZIndex = 3,
}, toggleFrame)

local function setOpen(state)
	main.Visible = state
	toggleLabel.Text = state and "[ HIDE ]" or "[ SHOW ]"
end

makeDraggable(toggleLabel, toggleFrame, function()
	setOpen(not main.Visible)
end)

track(UserInputService.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == CONFIG.ToggleKey then
		setOpen(not main.Visible)
	end
end))

local HEADER_HEIGHT = 32

local topBar = make("Frame", {
	Name = "TopBar",
	Position = UDim2.fromOffset(mainInset, mainInset),
	Size = UDim2.new(1, -mainInset * 2, 0, HEADER_HEIGHT),
	BackgroundColor3 = Color3.new(0, 0, 0),
	BackgroundTransparency = 0.25,
	BorderSizePixel = 0,
	ZIndex = 3,
}, main)
make("UICorner", { CornerRadius = UDim.new(0, 8) }, topBar)
make("UIStroke", {
	Color = CONFIG.Accent,
	Transparency = 0.6,
	Thickness = 1,
	ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
}, topBar)

do
	local ICON_W, ICON_H = 36, 24
	local titleIcon = make("Frame", {
		Name = "TitleIcon",
		Position = UDim2.fromOffset(10, (HEADER_HEIGHT - ICON_H) / 2),
		Size = UDim2.fromOffset(ICON_W, ICON_H),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BorderSizePixel = 0,
		ZIndex = 3,
	}, topBar)
	make("UICorner", { CornerRadius = UDim.new(0, 6) }, titleIcon)
	addGlowBorder(titleIcon, 2)
	createMatrix(titleIcon, ICON_W, main, 6, {
		Step = 9,
		ColWidth = 10,
		FontSize = 10,
		LineHeight = 11,
	})

	local iconDim = make("Frame", {
		Name = "IconDim",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		ZIndex = 2,
	}, titleIcon)
	make("UICorner", { CornerRadius = UDim.new(0, 6) }, iconDim)

	make("TextLabel", {
		Name = "IconText",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = "???",
		TextColor3 = CONFIG.Accent,
		TextSize = 14,
		Font = Enum.Font.Code,
		TextStrokeColor3 = Color3.new(0, 0, 0),
		TextStrokeTransparency = 0.3,
		ZIndex = 3,
	}, titleIcon)

	make("TextLabel", {
		Name = "Title",
		Position = UDim2.fromOffset(10 + ICON_W + 10, 0),
		Size = UDim2.new(1, -(10 + ICON_W + 10 + 34), 1, 0),
		BackgroundTransparency = 1,
		Text = CONFIG.Title,
		TextColor3 = CONFIG.Accent,
		TextSize = 16,
		Font = Enum.Font.Code,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextStrokeColor3 = Color3.new(0, 0, 0),
		TextStrokeTransparency = 0.4,
	}, topBar)
end

local closeBtn = make("TextButton", {
	Name = "Close",
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -5, 0.5, 0),
	Size = UDim2.fromOffset(22, 22),
	BackgroundColor3 = Color3.fromRGB(0, 40, 10),
	BackgroundTransparency = 0.2,
	Text = "X",
	TextColor3 = CONFIG.Accent,
	TextSize = 14,
	Font = Enum.Font.Code,
	AutoButtonColor = false,
}, topBar)
make("UICorner", { CornerRadius = UDim.new(0, 6) }, closeBtn)

closeBtn.MouseButton1Click:Connect(function()
	setOpen(false)
end)

makeDraggable(topBar, main)

local contentTop = mainInset + HEADER_HEIGHT + 6
local STATUS_HEIGHT = 22

local content = make("Frame", {
	Name = "Content",
	Position = UDim2.fromOffset(mainInset, contentTop),
	Size = UDim2.new(1, -mainInset * 2, 1, -contentTop - mainInset),
	BackgroundTransparency = 1,
	ZIndex = 2,
}, main)

local body = make("Frame", {
	Name = "Body",
	Size = UDim2.new(1, 0, 1, -(STATUS_HEIGHT + 6)),
	BackgroundTransparency = 1,
	ZIndex = 2,
}, content)

local order = 0
local function nextOrder()
	order += 1
	return order
end

local statusLabel = make("TextLabel", {
	Name = "Status",
	AnchorPoint = Vector2.new(0, 1),
	Position = UDim2.new(0, 0, 1, 0),
	Size = UDim2.new(1, 0, 0, STATUS_HEIGHT),
	BackgroundTransparency = 1,
	Text = "> Ready  [RightShift = Hide/Show]",
	TextColor3 = CONFIG.Accent,
	TextSize = 13,
	Font = Enum.Font.Code,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextTruncate = Enum.TextTruncate.AtEnd,
	TextStrokeColor3 = Color3.new(0, 0, 0),
	TextStrokeTransparency = 0.3,
	ZIndex = 3,
}, content)

local function setStatus(text)
	statusLabel.Text = "> " .. text
end

local function styleRow(row)
	row.BackgroundColor3 = Color3.new(0, 0, 0)
	row.BackgroundTransparency = 0.35
	row.BorderSizePixel = 0
	make("UICorner", { CornerRadius = UDim.new(0, 8) }, row)
	make("UIStroke", {
		Color = CONFIG.Accent,
		Transparency = 0.7,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, row)
end

local TWEEN = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local TAB_W = CONFIG.TabWidth
local TAB_H = CONFIG.TabHeight
local tabCount = #CONFIG.Tabs
local LINE_X = 6

local tabPanel = make("Frame", {
	Name = "Tabs",
	Size = UDim2.fromOffset(TAB_W, tabCount * TAB_H),
	BackgroundColor3 = Color3.new(0, 0, 0),
	BackgroundTransparency = 0.35,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	ZIndex = 3,
}, body)
make("UICorner", { CornerRadius = UDim.new(0, 8) }, tabPanel)

local line = make("Frame", {
	Name = "Line",
	Position = UDim2.fromOffset(LINE_X, 0),
	Size = UDim2.new(0, 1, 1, 0),
	BackgroundColor3 = Color3.fromRGB(0, 90, 25),
	BorderSizePixel = 0,
	ZIndex = 4,
}, tabPanel)
make("UIGradient", {
	Rotation = 90,
	Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0.0, 1),
		NumberSequenceKeypoint.new(0.5, 0),
		NumberSequenceKeypoint.new(1.0, 1),
	}),
}, line)

local glider = make("Frame", {
	Name = "Glider",
	Position = UDim2.fromOffset(LINE_X - 1, 0),
	Size = UDim2.fromOffset(3, TAB_H),
	BackgroundColor3 = CONFIG.Accent,
	BorderSizePixel = 0,
	ZIndex = 5,
}, tabPanel)
make("UIGradient", {
	Rotation = 90,
	Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0.0, 1),
		NumberSequenceKeypoint.new(0.5, 0),
		NumberSequenceKeypoint.new(1.0, 1),
	}),
}, glider)

if CONFIG.TabFade then
	local fade = make("Frame", {
		Name = "Fade",
		Size = UDim2.fromOffset(TAB_W - LINE_X + 1, TAB_H),
		BackgroundColor3 = CONFIG.Accent,
		BorderSizePixel = 0,
		ZIndex = 4,
	}, glider)
	make("UIGradient", {
		Rotation = 0,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0.0, 0.88),
			NumberSequenceKeypoint.new(1.0, 1),
		}),
	}, fade)
end

local PAGES_X = TAB_W + 8
local pages, tabButtons = {}, {}
local currentTab = 1

local function createPage(name)
	local page = make("ScrollingFrame", {
		Name = "Page_" .. name,
		Position = UDim2.fromOffset(PAGES_X, 0),
		Size = UDim2.new(1, -PAGES_X, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = CONFIG.Accent,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Visible = false,
		ZIndex = 3,
	}, body)
	make("UIPadding", {
		PaddingTop = UDim.new(0, 1),
		PaddingLeft = UDim.new(0, 1),
		PaddingBottom = UDim.new(0, 1),
		PaddingRight = UDim.new(0, 6),
	}, page)
	make("UIListLayout", {
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, page)
	return page
end

local GLIDER_TWEEN = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local function selectTab(index, animate)
	currentTab = index
	local targetPos = UDim2.fromOffset(LINE_X - 1, (index - 1) * TAB_H)
	if animate then
		TweenService:Create(glider, GLIDER_TWEEN, { Position = targetPos }):Play()
	else
		glider.Position = targetPos
	end

	for i, btn in ipairs(tabButtons) do
		local color = (i == index) and CONFIG.Accent or CONFIG.TabIdleColor
		if animate then
			TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
				TextColor3 = color,
			}):Play()
		else
			btn.TextColor3 = color
		end
		pages[CONFIG.Tabs[i]].Visible = (i == index)
	end

	if animate then
		setStatus("Tab: " .. CONFIG.Tabs[index])
	end
end

for i, name in ipairs(CONFIG.Tabs) do
	pages[name] = createPage(name)

	local btn = make("TextButton", {
		Name = name,
		Position = UDim2.fromOffset(0, (i - 1) * TAB_H),
		Size = UDim2.new(1, 0, 0, TAB_H),
		BackgroundTransparency = 1,
		Text = name,
		TextColor3 = CONFIG.TabIdleColor,
		TextSize = 14,
		Font = Enum.Font.Code,
		TextXAlignment = Enum.TextXAlignment.Left,
		AutoButtonColor = false,
		ZIndex = 6,
	}, tabPanel)
	make("UIPadding", { PaddingLeft = UDim.new(0, 18) }, btn)

	btn.MouseButton1Click:Connect(function()
		selectTab(i, true)
	end)
	btn.MouseEnter:Connect(function()
		if currentTab ~= i then
			TweenService:Create(btn, TWEEN, { TextColor3 = CONFIG.TabHoverColor }):Play()
		end
	end)
	btn.MouseLeave:Connect(function()
		if currentTab ~= i then
			TweenService:Create(btn, TWEEN, { TextColor3 = CONFIG.TabIdleColor }):Play()
		end
	end)

	tabButtons[i] = btn
end

local function addToggle(page, name, default, callback)
	local state = default

	local row = make("TextButton", {
		Name = name,
		Size = UDim2.new(1, 0, 0, 36),
		Text = "",
		AutoButtonColor = false,
		LayoutOrder = nextOrder(),
		ZIndex = 3,
	}, page)
	styleRow(row)

	make("TextLabel", {
		Position = UDim2.fromOffset(12, 0),
		Size = UDim2.new(1, -70, 1, 0),
		BackgroundTransparency = 1,
		Text = name,
		TextColor3 = CONFIG.Accent,
		TextSize = 14,
		Font = Enum.Font.Code,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 3,
	}, row)

	local switch = make("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.fromOffset(36, 18),
		BackgroundColor3 = Color3.fromRGB(20, 30, 20),
		BorderSizePixel = 0,
		ZIndex = 3,
	}, row)
	make("UICorner", { CornerRadius = UDim.new(1, 0) }, switch)

	local knob = make("Frame", {
		Size = UDim2.fromOffset(14, 14),
		Position = UDim2.new(0, 2, 0.5, -7),
		BackgroundColor3 = Color3.fromRGB(120, 120, 120),
		BorderSizePixel = 0,
		ZIndex = 3,
	}, switch)
	make("UICorner", { CornerRadius = UDim.new(1, 0) }, knob)

	local function render(animate)
		local knobPos = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
		local knobColor = state and CONFIG.Accent or Color3.fromRGB(120, 120, 120)
		local switchColor = state and Color3.fromRGB(0, 70, 20) or Color3.fromRGB(20, 30, 20)
		if animate then
			TweenService:Create(knob, TWEEN, { Position = knobPos, BackgroundColor3 = knobColor }):Play()
			TweenService:Create(switch, TWEEN, { BackgroundColor3 = switchColor }):Play()
		else
			knob.Position = knobPos
			knob.BackgroundColor3 = knobColor
			switch.BackgroundColor3 = switchColor
		end
	end
	render(false)

	local function setState(newState)
		state = newState
		render(true)
		setStatus(name .. ": " .. (state and "ON" or "OFF"))
		if callback then
			task.spawn(callback, state)
		end
	end

	row.MouseButton1Click:Connect(function()
		setState(not state)
	end)

	return {
		Set = function(s)
			if s ~= state then
				setState(s)
			end
		end,
		Get = function()
			return state
		end,
	}
end

local function addButton(page, name, callback)
	local btn = make("TextButton", {
		Name = name,
		Size = UDim2.new(1, 0, 0, 36),
		Text = name,
		TextColor3 = CONFIG.Accent,
		TextSize = 14,
		Font = Enum.Font.Code,
		AutoButtonColor = false,
		LayoutOrder = nextOrder(),
		ZIndex = 3,
	}, page)
	styleRow(btn)

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TWEEN, { BackgroundTransparency = 0.1 }):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TWEEN, { BackgroundTransparency = 0.35 }):Play()
	end)
	btn.MouseButton1Click:Connect(function()
		setStatus(name .. " executed")
		if callback then
			task.spawn(callback)
		end
	end)
	return btn
end

local function addSlider(page, name, min, max, default, callback, decimals)
	decimals = decimals or 0
	local mult = 10 ^ decimals
	local fmt = "%." .. decimals .. "f"

	local function snap(v)
		return math.clamp(math.floor(v * mult + 0.5) / mult, min, max)
	end

	local function fmtValue(v)
		return string.format(fmt, v)
	end

	local value = snap(default)

	local row = make("Frame", {
		Name = name,
		Size = UDim2.new(1, 0, 0, 52),
		LayoutOrder = nextOrder(),
		ZIndex = 3,
	}, page)
	styleRow(row)

	make("TextLabel", {
		Position = UDim2.fromOffset(12, 6),
		Size = UDim2.new(1, -100, 0, 18),
		BackgroundTransparency = 1,
		Text = name,
		TextColor3 = CONFIG.Accent,
		TextSize = 14,
		Font = Enum.Font.Code,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 3,
	}, row)

	local box = make("TextBox", {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -10, 0, 6),
		Size = UDim2.fromOffset(70, 18),
		BackgroundColor3 = Color3.fromRGB(0, 40, 10),
		BackgroundTransparency = 0.2,
		BorderSizePixel = 0,
		Text = fmtValue(value),
		TextColor3 = CONFIG.Accent,
		TextSize = 13,
		Font = Enum.Font.Code,
		ClearTextOnFocus = true,
		ZIndex = 3,
	}, row)
	make("UICorner", { CornerRadius = UDim.new(0, 4) }, box)

	local bar = make("Frame", {
		Position = UDim2.fromOffset(12, 35),
		Size = UDim2.new(1, -24, 0, 6),
		BackgroundColor3 = Color3.fromRGB(20, 30, 20),
		BorderSizePixel = 0,
		ZIndex = 3,
	}, row)
	make("UICorner", { CornerRadius = UDim.new(1, 0) }, bar)

	local fill = make("Frame", {
		Size = UDim2.fromScale(0, 1),
		BackgroundColor3 = CONFIG.Accent,
		BorderSizePixel = 0,
		ZIndex = 3,
	}, bar)
	make("UICorner", { CornerRadius = UDim.new(1, 0) }, fill)

	local knob = make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(12, 12),
		BackgroundColor3 = Color3.fromRGB(190, 255, 205),
		BorderSizePixel = 0,
		ZIndex = 4,
	}, bar)
	make("UICorner", { CornerRadius = UDim.new(1, 0) }, knob)

	local hit = make("TextButton", {
		Name = "Hit",
		Position = UDim2.fromOffset(6, 26),
		Size = UDim2.new(1, -12, 0, 22),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 5,
	}, row)

	local function render()
		local ratio = (value - min) / (max - min)
		fill.Size = UDim2.fromScale(ratio, 1)
		knob.Position = UDim2.new(ratio, 0, 0.5, 0)
		box.Text = fmtValue(value)
	end
	render()

	local function set(v)
		v = snap(v)
		local changed = v ~= value
		value = v
		render()
		if changed and callback then
			callback(value)
		end
	end

	local dragging = false

	local function fromInput(input)
		local ratio = math.clamp(
			(input.Position.X - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1),
			0, 1
		)
		set(min + ratio * (max - min))
	end

	hit.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			page.ScrollingEnabled = false
			fromInput(input)
		end
	end)

	track(UserInputService.InputChanged:Connect(function(input)
		if dragging
			and (input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch) then
			fromInput(input)
		end
	end))

	track(UserInputService.InputEnded:Connect(function(input)
		if dragging
			and (input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch) then
			dragging = false
			page.ScrollingEnabled = true
			setStatus(name .. ": " .. fmtValue(value))
		end
	end))

	box.FocusLost:Connect(function()
		local n = tonumber(box.Text)
		if n then
			set(n)
			setStatus(name .. ": " .. fmtValue(value))
		else
			render()
		end
	end)

	return {
		Set = set,
		Get = function()
			return value
		end,
	}
end

local function getHumanoid()
	local char = LocalPlayer.Character
	return char and char:FindFirstChildOfClass("Humanoid")
end

local hitbox = {
	Enabled = false,
	Size = CONFIG.HitboxDefault,
	TeamCheck = false,
}
local hitboxOriginals = setmetatable({}, { __mode = "k" })

local function restorePart(part)
	local data = hitboxOriginals[part]
	if data then
		hitboxOriginals[part] = nil
		if part.Parent then
			part.Size = data.Size
			part.Transparency = data.Transparency
			part.CanCollide = data.CanCollide
		end
	end
end

local function restoreHitboxes()
	for part in pairs(hitboxOriginals) do
		restorePart(part)
	end
end

track(RunService.Heartbeat:Connect(function()
	if not hitbox.Enabled then
		return
	end
	local size = Vector3.new(hitbox.Size, hitbox.Size, hitbox.Size)
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local char = player.Character
			local part = char and char:FindFirstChild(CONFIG.HitboxPart)
			if part and part:IsA("BasePart") then
				local skip = hitbox.TeamCheck and player.Team ~= nil and player.Team == LocalPlayer.Team
				if skip then
					restorePart(part)
				else
					if not hitboxOriginals[part] then
						hitboxOriginals[part] = {
							Size = part.Size,
							Transparency = part.Transparency,
							CanCollide = part.CanCollide,
						}
					end
					if part.Size ~= size then
						part.Size = size
					end
					if part.Transparency ~= CONFIG.HitboxTransparency then
						part.Transparency = CONFIG.HitboxTransparency
					end
					if part.CanCollide then
						part.CanCollide = false
					end
				end
			end
		end
	end
end))

local function clampSpeed(v)
	return math.clamp(math.floor(v + 0.5), CONFIG.SpeedMin, CONFIG.SpeedMax)
end

local startHum = getHumanoid()
local baseSpeed = startHum and startHum.WalkSpeed or 16
local speed = {
	Lock = false,
	Base = baseSpeed,
	Value = clampSpeed(baseSpeed),
}

local function syncSpeed(hum)
	if not hum or not hum.Parent then
		return
	end
	local current = hum.WalkSpeed
	if speed.Lock then
		if current ~= speed.Value then
			speed.Base = current
			hum.WalkSpeed = speed.Value
		end
	else
		speed.Base = current
	end
end

local speedConn
local function hookHumanoid(hum)
	if speedConn then
		speedConn:Disconnect()
	end
	speedConn = hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		syncSpeed(hum)
	end)
	syncSpeed(hum)
end

local function onCharacter(char)
	local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 10)
	if hum then
		hookHumanoid(hum)
	end
end

if LocalPlayer.Character then
	task.spawn(onCharacter, LocalPlayer.Character)
end
track(LocalPlayer.CharacterAdded:Connect(function(char)
	task.spawn(onCharacter, char)
end))

track(RunService.Heartbeat:Connect(function()
	syncSpeed(getHumanoid())
end))

local infJump = false
track(UserInputService.JumpRequest:Connect(function()
	if infJump then
		local hum = getHumanoid()
		if hum then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end))

local noclip = false
local noclipParts = setmetatable({}, { __mode = "k" })

track(RunService.Stepped:Connect(function()
	if not noclip then
		return
	end
	local char = LocalPlayer.Character
	if not char then
		return
	end
	for _, d in ipairs(char:GetDescendants()) do
		if d:IsA("BasePart") and d.CanCollide then
			noclipParts[d] = true
			d.CanCollide = false
		end
	end
end))

local function restoreNoclip()
	for part in pairs(noclipParts) do
		noclipParts[part] = nil
		if part.Parent then
			part.CanCollide = true
		end
	end
end

local espFolder = make("Folder", { Name = "ESP" }, gui)
local esp = { Enabled = false, Objects = {} }

local function removeESP(player)
	local h = esp.Objects[player]
	if h then
		h:Destroy()
		esp.Objects[player] = nil
	end
end

local function applyESP(player)
	if player == LocalPlayer or not esp.Enabled then
		return
	end
	if player.Parent ~= Players then
		removeESP(player)
		return
	end
	local char = player.Character
	if not char or not char.Parent then
		removeESP(player)
		return
	end
	local h = esp.Objects[player]
	if h and h.Parent and h.Adornee == char then
		return
	end
	if h then
		h:Destroy()
	end
	esp.Objects[player] = make("Highlight", {
		Name = player.Name,
		Adornee = char,
		FillColor = CONFIG.ESPColor,
		FillTransparency = CONFIG.ESPFillTransparency,
		OutlineColor = CONFIG.ESPColor,
		OutlineTransparency = CONFIG.ESPOutlineTransparency,
		DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
	}, espFolder)
end

local function hookPlayer(player)
	if player == LocalPlayer then
		return
	end
	track(player.CharacterAdded:Connect(function()
		applyESP(player)
	end))
	track(player.CharacterRemoving:Connect(function()
		removeESP(player)
	end))
end

for _, p in ipairs(Players:GetPlayers()) do
	hookPlayer(p)
end

track(Players.PlayerAdded:Connect(function(p)
	hookPlayer(p)
	applyESP(p)
end))

track(Players.PlayerRemoving:Connect(function(p)
	removeESP(p)
end))

local espClock = 0
track(RunService.Heartbeat:Connect(function(dt)
	if not esp.Enabled then
		return
	end
	espClock += dt
	if espClock < 0.25 then
		return
	end
	espClock = 0
	for player in pairs(esp.Objects) do
		if player.Parent ~= Players then
			removeESP(player)
		end
	end
	for _, p in ipairs(Players:GetPlayers()) do
		applyESP(p)
	end
end))

local machineFolder = make("Folder", { Name = "MachineESP" }, gui)
local machines = {
	Enabled = false,
	Token = 0,
	Objects = {},
	Added = nil,
	Removing = nil,
}

local function isMachine(inst)
	return inst.Name == CONFIG.MachineName and inst:IsA("Model")
end

local function removeMachine(model)
	local h = machines.Objects[model]
	if h then
		h:Destroy()
		machines.Objects[model] = nil
	end
end

local function applyMachine(model)
	if not machines.Enabled then
		return
	end
	if not model:IsDescendantOf(workspace) then
		removeMachine(model)
		return
	end
	local h = machines.Objects[model]
	if h and h.Parent == machineFolder and h.Adornee == model then
		return
	end
	if h then
		h:Destroy()
	end
	machines.Objects[model] = make("Highlight", {
		Name = "Machine",
		Adornee = model,
		FillColor = CONFIG.MachineColor,
		FillTransparency = CONFIG.MachineFillTransparency,
		OutlineColor = CONFIG.MachineColor,
		OutlineTransparency = CONFIG.MachineOutlineTransparency,
		DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
	}, machineFolder)
end

local function setMachineESP(state)
	if state == machines.Enabled then
		return
	end
	machines.Enabled = state
	machines.Token += 1
	local token = machines.Token

	if state then
		machines.Added = workspace.DescendantAdded:Connect(function(obj)
			if isMachine(obj) then
				applyMachine(obj)
			end
		end)
		machines.Removing = workspace.DescendantRemoving:Connect(function(obj)
			if machines.Objects[obj] then
				removeMachine(obj)
			end
		end)
		task.spawn(function()
			local count = 0
			for _, obj in ipairs(workspace:GetDescendants()) do
				if machines.Token ~= token then
					return
				end
				if isMachine(obj) then
					applyMachine(obj)
				end
				count += 1
				if count % 3000 == 0 then
					task.wait()
				end
			end
		end)
	else
		if machines.Added then
			machines.Added:Disconnect()
			machines.Added = nil
		end
		if machines.Removing then
			machines.Removing:Disconnect()
			machines.Removing = nil
		end
		for model in pairs(machines.Objects) do
			removeMachine(model)
		end
	end
end

local machineClock = 0
track(RunService.Heartbeat:Connect(function(dt)
	if not machines.Enabled then
		return
	end
	machineClock += dt
	if machineClock < 0.5 then
		return
	end
	machineClock = 0
	for model in pairs(machines.Objects) do
		applyMachine(model)
	end
end))

local instant = {
	Enabled = false,
	Token = 0,
	Added = nil,
	Removing = nil,
	Hooks = {},
	Originals = setmetatable({}, { __mode = "k" }),
}

local function forcePrompt(prompt)
	if instant.Enabled and prompt.HoldDuration ~= 0 then
		instant.Originals[prompt] = prompt.HoldDuration
		prompt.HoldDuration = 0
	end
end

local function hookPrompt(prompt)
	if instant.Hooks[prompt] then
		return
	end
	instant.Hooks[prompt] = prompt:GetPropertyChangedSignal("HoldDuration"):Connect(function()
		forcePrompt(prompt)
	end)
	forcePrompt(prompt)
end

local function unhookPrompt(prompt)
	local conn = instant.Hooks[prompt]
	if conn then
		conn:Disconnect()
		instant.Hooks[prompt] = nil
	end
end

local function setInstant(state)
	if state == instant.Enabled then
		return
	end
	instant.Enabled = state
	instant.Token += 1
	local token = instant.Token

	if state then
		instant.Added = workspace.DescendantAdded:Connect(function(obj)
			if obj:IsA("ProximityPrompt") then
				hookPrompt(obj)
			end
		end)
		instant.Removing = workspace.DescendantRemoving:Connect(function(obj)
			if obj:IsA("ProximityPrompt") then
				unhookPrompt(obj)
			end
		end)
		task.spawn(function()
			local count = 0
			for _, obj in ipairs(workspace:GetDescendants()) do
				if instant.Token ~= token then
					return
				end
				if obj:IsA("ProximityPrompt") then
					hookPrompt(obj)
				end
				count += 1
				if count % 3000 == 0 then
					task.wait()
				end
			end
		end)
	else
		if instant.Added then
			instant.Added:Disconnect()
			instant.Added = nil
		end
		if instant.Removing then
			instant.Removing:Disconnect()
			instant.Removing = nil
		end
		for prompt, conn in pairs(instant.Hooks) do
			conn:Disconnect()
			instant.Hooks[prompt] = nil
		end
		for prompt, hold in pairs(instant.Originals) do
			instant.Originals[prompt] = nil
			if prompt.Parent then
				prompt.HoldDuration = hold
			end
		end
	end
end

local keyState = { Enabled = false, Token = 0 }

local function findKeyBox()
	local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local keyGui = playerGui and playerGui:FindFirstChild("KeyGui")
	local frame = keyGui and keyGui:FindFirstChild("Frame")
	local holder = frame and frame:FindFirstChild("a")
	local box = holder and holder:FindFirstChild("TextBox")
	if box and box:IsA("TextBox") then
		return box
	end
	return nil
end

local function setKey(state)
	if state == keyState.Enabled then
		return
	end
	keyState.Enabled = state
	keyState.Token += 1
	local token = keyState.Token
	if not state then
		return
	end
	task.spawn(function()
		while keyState.Token == token do
			local box = findKeyBox()
			if box and not box:IsFocused() and box.Text ~= CONFIG.Key then
				box.Text = CONFIG.Key
			end
			task.wait(0.5)
		end
	end)
end

local weaponBusy = false

local function purchase(action, itemName)
	local remote = ReplicatedStorage:FindFirstChild("ClientFunc")
		or ReplicatedStorage:WaitForChild("ClientFunc", 5)
	if not remote then
		return false, "ClientFunc not found"
	end
	return pcall(function()
		return remote:InvokeServer("PurchazeItem", action, itemName)
	end)
end

local function describe(label, ok, result)
	if ok then
		return label .. " -> " .. tostring(result)
	end
	return label .. " error: " .. string.sub(tostring(result), 1, 40)
end

local function runWeaponAction(itemName, mode)
	if weaponBusy then
		setStatus("Busy, wait...")
		return
	end
	weaponBusy = true
	local results = {}

	if mode == "Buy" or mode == "Both" then
		setStatus(itemName .. ": Buy...")
		local ok, res = purchase("Buy", itemName)
		results[#results + 1] = describe("Buy", ok, res)
		if mode == "Both" then
			task.wait(0.3)
		end
	end

	if mode == "set" or mode == "Both" then
		setStatus(itemName .. ": set...")
		local ok, res = purchase("set", itemName)
		results[#results + 1] = describe("Set", ok, res)
	end

	weaponBusy = false
	setStatus(itemName .. " | " .. table.concat(results, " | "))
end

local function buyAllWeapons()
	if weaponBusy then
		setStatus("Busy, wait...")
		return
	end
	weaponBusy = true
	local total = #CONFIG.Weapons
	for i, name in ipairs(CONFIG.Weapons) do
		setStatus(("Buying %d/%d: %s"):format(i, total, name))
		purchase("Buy", name)
		task.wait(0.4)
	end
	weaponBusy = false
	setStatus("Buy All finished")
end

local function normalize(s)
	return (string.lower((string.gsub(tostring(s), "[%s_%-]", ""))))
end

local weaponKeys = {}
for _, w in ipairs(CONFIG.Weapons) do
	weaponKeys[normalize(w)] = true
end

local IMAGE_FIELDS = { "image", "icon", "thumbnail", "texture", "assetid", "picture" }

local function isImageField(name)
	local lowered = string.lower(tostring(name))
	for _, f in ipairs(IMAGE_FIELDS) do
		if string.find(lowered, f, 1, true) then
			return true
		end
	end
	return false
end

local function toImage(v)
	if type(v) == "number" and v > 1000 then
		return "rbxassetid://" .. math.floor(v)
	end
	if type(v) == "string" and v ~= "" then
		if string.find(v, "rbx", 1, true) or string.find(v, "http", 1, true) then
			return v
		end
		if string.match(v, "^%d+$") and #v > 4 then
			return "rbxassetid://" .. v
		end
	end
	return nil
end

local function isImg(inst)
	return (inst:IsA("ImageLabel") or inst:IsA("ImageButton")) and inst.Image ~= ""
end

local function countWeaponTexts(container)
	local seen, n = {}, 0
	for _, d in ipairs(container:GetDescendants()) do
		if d:IsA("TextLabel") or d:IsA("TextButton") then
			local k = normalize(d.Text)
			if weaponKeys[k] and not seen[k] then
				seen[k] = true
				n += 1
			end
		end
	end
	return n
end

local function iconInCard(card)
	local best, bestArea = nil, -1
	local cardSize = card.AbsoluteSize
	for _, d in ipairs(card:GetDescendants()) do
		if d:IsA("ViewportFrame") then
			return d
		end
		if isImg(d) then
			local s = d.AbsoluteSize
			local full = cardSize.X > 0 and cardSize.Y > 0
				and s.X >= cardSize.X * 0.95 and s.Y >= cardSize.Y * 0.95
			if not full then
				local area = s.X * s.Y
				if area > bestArea then
					best, bestArea = d, area
				end
			end
		end
	end
	return best
end

local function scanShopIcon(name)
	local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	if not playerGui then
		return nil
	end
	local key = normalize(name)
	local count = 0

	for _, inst in ipairs(playerGui:GetDescendants()) do
		count += 1
		if count % 2000 == 0 then
			task.wait()
		end

		if not inst:IsDescendantOf(gui) then
			if (inst:IsA("TextLabel") or inst:IsA("TextButton")) and normalize(inst.Text) == key then
				local node = inst.Parent
				for _ = 1, 4 do
					if not node or node == playerGui or not node:IsA("GuiObject") then
						break
					end
					if countWeaponTexts(node) > 1 then
						break
					end
					local found = iconInCard(node)
					if found then
						return found
					end
					node = node.Parent
				end
			elseif inst:IsA("GuiObject") and normalize(inst.Name) == key then
				local found = iconInCard(inst)
				if found then
					return found
				end
				if isImg(inst) or inst:IsA("ViewportFrame") then
					return inst
				end
			end
		end
	end
	return nil
end

local function rank(inst)
	if inst:IsA("Tool") then
		return 3
	end
	if inst:IsA("Model") then
		return 2
	end
	if inst:IsA("BasePart") then
		return 1
	end
	return 0
end

local weaponIndex, indexState = {}, "idle"
local dataTables, dataState = {}, "idle"

local function resetIconCaches()
	weaponIndex = {}
	indexState = "idle"
	dataTables = {}
	dataState = "idle"
end

local function ensureIndex()
	if indexState == "done" then
		return
	end
	if indexState == "running" then
		while indexState == "running" do
			task.wait(0.1)
		end
		return
	end
	indexState = "running"
	pcall(function()
		local roots = {}
		local function add(r)
			if r then
				roots[#roots + 1] = r
			end
		end
		add(ReplicatedStorage)
		add(game:GetService("StarterPack"))
		add(game:GetService("ReplicatedFirst"))
		add(LocalPlayer:FindFirstChildOfClass("Backpack"))
		add(LocalPlayer.Character)
		add(workspace)

		local count = 0
		for _, root in ipairs(roots) do
			for _, inst in ipairs(root:GetDescendants()) do
				local r = rank(inst)
				if r > 0 then
					local key = normalize(inst.Name)
					if inst:IsA("Tool") or weaponKeys[key] then
						local cur = weaponIndex[key]
						if not cur or rank(cur) < r then
							weaponIndex[key] = inst
						end
					end
				end
				count += 1
				if count % 3000 == 0 then
					task.wait()
				end
			end
		end
	end)
	indexState = "done"
end

local function lookupTool(name)
	local key = normalize(name)
	if weaponIndex[key] then
		return weaponIndex[key]
	end
	if #key >= 4 then
		for k, inst in pairs(weaponIndex) do
			if inst:IsA("Tool") and #k >= 4 and not weaponKeys[k]
				and (string.find(k, key, 1, true) or string.find(key, k, 1, true)) then
				return inst
			end
		end
	end
	return nil
end

local function imageFromInstance(inst)
	for k, v in pairs(inst:GetAttributes()) do
		if isImageField(k) then
			local img = toImage(v)
			if img then
				return img
			end
		end
	end
	for _, d in ipairs(inst:GetDescendants()) do
		local img = nil
		if d:IsA("ValueBase") and isImageField(d.Name) then
			img = toImage(d.Value)
		elseif d:IsA("ImageLabel") or d:IsA("ImageButton") then
			img = toImage(d.Image)
		end
		if img then
			return img
		end
	end
	return nil
end

local function ensureData()
	if dataState == "done" then
		return
	end
	if dataState == "running" then
		while dataState == "running" do
			task.wait(0.1)
		end
		return
	end
	dataState = "running"
	pcall(function()
		local pending, count = 0, 0
		for _, inst in ipairs(ReplicatedStorage:GetDescendants()) do
			if inst:IsA("ModuleScript") then
				local n = string.lower(inst.Name)
				if string.find(n, "item", 1, true) or string.find(n, "weapon", 1, true)
					or string.find(n, "shop", 1, true) or string.find(n, "data", 1, true)
					or string.find(n, "store", 1, true) or string.find(n, "config", 1, true) then
					pending += 1
					task.spawn(function()
						local ok, result = pcall(require, inst)
						if ok and type(result) == "table" then
							dataTables[#dataTables + 1] = result
						end
						pending -= 1
					end)
				end
			end
			count += 1
			if count % 500 == 0 then
				task.wait()
			end
		end
		local started = os.clock()
		while pending > 0 and os.clock() - started < 3 do
			task.wait(0.1)
		end
	end)
	dataState = "done"
end

local function imageFromTable(t)
	for k, v in pairs(t) do
		if type(k) == "string" and isImageField(k) then
			local img = toImage(v)
			if img then
				return img
			end
		end
	end
	return nil
end

local function searchData(t, key, depth, seen)
	if depth > 4 or seen[t] then
		return nil
	end
	seen[t] = true
	local ok, found = pcall(function()
		for k, v in pairs(t) do
			if type(v) == "table" then
				local match = (type(k) == "string" and normalize(k) == key)
					or (type(v.Name) == "string" and normalize(v.Name) == key)
					or (type(v.name) == "string" and normalize(v.name) == key)
				if match then
					local img = imageFromTable(v)
					if img then
						return img
					end
				end
				local deeper = searchData(v, key, depth + 1, seen)
				if deeper then
					return deeper
				end
			end
		end
		return nil
	end)
	if ok then
		return found
	end
	return nil
end

local function showIcon(holder, source)
	if source:IsA("ViewportFrame") then
		local vp = source:Clone()
		for _, d in ipairs(vp:GetDescendants()) do
			if d:IsA("BaseScript") then
				d:Destroy()
			end
		end
		vp.AnchorPoint = Vector2.new(0, 0)
		vp.Position = UDim2.fromScale(0, 0)
		vp.Size = UDim2.fromScale(1, 1)
		vp.BackgroundTransparency = 1
		vp.Visible = true
		vp.ZIndex = 4
		vp.Parent = holder
	else
		make("ImageLabel", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Image = source.Image,
			ImageRectOffset = source.ImageRectOffset,
			ImageRectSize = source.ImageRectSize,
			ScaleType = Enum.ScaleType.Fit,
			ZIndex = 4,
		}, holder)
	end
end

local function showImageId(holder, image)
	make("ImageLabel", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Image = image,
		ScaleType = Enum.ScaleType.Fit,
		ZIndex = 4,
	}, holder)
end

local function showModelViewport(holder, source)
	local clone = source:Clone()
	if not clone then
		return false
	end
	for _, d in ipairs(clone:GetDescendants()) do
		if d:IsA("BaseScript") then
			d:Destroy()
		end
	end

	local vp = make("ViewportFrame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Ambient = Color3.fromRGB(200, 200, 200),
		LightColor = Color3.new(1, 1, 1),
		ZIndex = 4,
	}, holder)

	local model = Instance.new("Model")
	clone.Parent = model
	model.Parent = vp

	local ok, cf, size = pcall(function()
		return model:GetBoundingBox()
	end)
	if not ok or not cf or size.Magnitude == 0 then
		vp:Destroy()
		return false
	end

	local cam = make("Camera", { FieldOfView = 50 }, vp)
	vp.CurrentCamera = cam
	local radius = size.Magnitude / 2
	local dist = radius / math.tan(math.rad(cam.FieldOfView / 2)) * 1.05
	local eye = cf.Position + Vector3.new(1, 0.5, 1).Unit * dist
	cam.CFrame = CFrame.lookAt(eye, cf.Position)
	return true
end

local function loadWeaponIcon(name, holder, placeholder)
	local shown = false

	pcall(function()
		local source = scanShopIcon(name)
		if source then
			showIcon(holder, source)
			shown = true
			return
		end

		ensureIndex()
		local inst = lookupTool(name)

		if inst and inst:IsA("Tool") and inst.TextureId ~= "" then
			showImageId(holder, inst.TextureId)
			shown = true
			return
		end

		ensureData()
		local key = normalize(name)
		for _, t in ipairs(dataTables) do
			local img = searchData(t, key, 0, {})
			if img then
				showImageId(holder, img)
				shown = true
				return
			end
		end

		if inst then
			local img = imageFromInstance(inst)
			if img then
				showImageId(holder, img)
				shown = true
				return
			end
			if showModelViewport(holder, inst) then
				shown = true
				return
			end
		end
	end)

	if shown then
		placeholder:Destroy()
	else
		placeholder.Text = "?"
	end
	return shown
end

local WEAPON_BODY_H = 84

local function addSmallButton(parent, text, position, size, callback)
	local btn = make("TextButton", {
		Position = position,
		Size = size,
		BackgroundColor3 = Color3.fromRGB(0, 40, 10),
		BackgroundTransparency = 0.2,
		BorderSizePixel = 0,
		Text = text,
		TextColor3 = CONFIG.Accent,
		TextSize = 13,
		Font = Enum.Font.Code,
		AutoButtonColor = false,
		ZIndex = 4,
	}, parent)
	make("UICorner", { CornerRadius = UDim.new(0, 6) }, btn)
	make("UIStroke", {
		Color = CONFIG.Accent,
		Transparency = 0.6,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, btn)

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TWEEN, { BackgroundTransparency = 0 }):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TWEEN, { BackgroundTransparency = 0.2 }):Play()
	end)
	btn.MouseButton1Click:Connect(function()
		task.spawn(callback)
	end)
	return btn
end

local function addWeaponCard(page, weaponName)
	local expanded = false
	local iconRequested = false
	local loading = false
	local failed = false

	local card = make("Frame", {
		Name = weaponName,
		Size = UDim2.new(1, 0, 0, 36),
		ClipsDescendants = true,
		LayoutOrder = nextOrder(),
		ZIndex = 3,
	}, page)
	styleRow(card)

	local header = make("TextButton", {
		Name = "Header",
		Size = UDim2.new(1, 0, 0, 36),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 4,
	}, card)

	make("TextLabel", {
		Position = UDim2.fromOffset(12, 0),
		Size = UDim2.new(1, -50, 1, 0),
		BackgroundTransparency = 1,
		Text = weaponName,
		TextColor3 = CONFIG.Accent,
		TextSize = 14,
		Font = Enum.Font.Code,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 4,
	}, header)

	local arrow = make("TextLabel", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.fromOffset(30, 20),
		BackgroundTransparency = 1,
		Text = "[+]",
		TextColor3 = CONFIG.Accent,
		TextSize = 13,
		Font = Enum.Font.Code,
		ZIndex = 4,
	}, header)

	local cardBody = make("Frame", {
		Name = "Body",
		Position = UDim2.fromOffset(0, 36),
		Size = UDim2.new(1, 0, 0, WEAPON_BODY_H),
		BackgroundTransparency = 1,
		ZIndex = 4,
	}, card)

	local holder = make("Frame", {
		Name = "Icon",
		Position = UDim2.fromOffset(10, 6),
		Size = UDim2.fromOffset(72, 72),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 4,
	}, cardBody)
	make("UICorner", { CornerRadius = UDim.new(0, 8) }, holder)
	make("UIStroke", {
		Color = CONFIG.Accent,
		Transparency = 0.7,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, holder)

	local placeholder = make("TextButton", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = string.upper(string.sub(weaponName, 1, 1)),
		TextColor3 = CONFIG.Accent,
		TextTransparency = 0.4,
		TextSize = 28,
		Font = Enum.Font.Code,
		AutoButtonColor = false,
		ZIndex = 5,
	}, holder)

	local function requestIcon()
		if loading then
			return
		end
		loading = true
		if failed then
			resetIconCaches()
		end
		placeholder.Text = "..."
		task.spawn(function()
			local ok = loadWeaponIcon(weaponName, holder, placeholder)
			failed = not ok
			loading = false
		end)
	end

	placeholder.MouseButton1Click:Connect(function()
		if failed then
			requestIcon()
		end
	end)

	addSmallButton(cardBody, "Buy + Set", UDim2.fromOffset(92, 6), UDim2.new(1, -102, 0, 34), function()
		runWeaponAction(weaponName, "Both")
	end)
	addSmallButton(cardBody, "Buy", UDim2.new(0, 92, 0, 46), UDim2.new(0.5, -54, 0, 30), function()
		runWeaponAction(weaponName, "Buy")
	end)
	addSmallButton(cardBody, "Set", UDim2.new(0.5, 44, 0, 46), UDim2.new(0.5, -54, 0, 30), function()
		runWeaponAction(weaponName, "set")
	end)

	header.MouseButton1Click:Connect(function()
		expanded = not expanded
		arrow.Text = expanded and "[-]" or "[+]"
		local targetHeight = expanded and (36 + WEAPON_BODY_H) or 36
		TweenService:Create(card, TWEEN, { Size = UDim2.new(1, 0, 0, targetHeight) }):Play()

		if expanded and (not iconRequested or failed) then
			iconRequested = true
			requestIcon()
		end
	end)
end

local residences = {
	Token = 0,
	Entries = {},
	Cards = {},
}

local function trim(s)
	return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

local function readWorkspaceFile(path)
	if typeof(isfile) ~= "function" or typeof(readfile) ~= "function" then
		return nil, "file functions not supported"
	end
	local okCheck, exists = pcall(isfile, path)
	if not okCheck or not exists then
		return nil, path .. " not found"
	end
	local okRead, data = pcall(readfile, path)
	if not okRead or type(data) ~= "string" then
		return nil, path .. " unreadable"
	end
	data = string.gsub(data, "^\239\187\191", "")
	return data
end

local function splitLines(text)
	local lines = {}
	for line in string.gmatch(text .. "\n", "(.-)\r?\n") do
		lines[#lines + 1] = line
	end
	return lines
end

local function extractId(text)
	for s, run, e in string.gmatch(text, "()(%d%d%d%d%d+)()") do
		local before = s > 1 and string.sub(text, s - 1, s - 1) or ""
		local after = string.sub(text, e, e)
		if not string.match(before, "[%w_]") and not string.match(after, "[%w_]") then
			return tonumber(run), s, e
		end
	end
	return nil
end

local function cleanName(s)
	s = string.gsub(s, "^[%s,;:|=%-\"'#]+", "")
	s = string.gsub(s, "[%s,;:|=%-\"'#]+$", "")
	return s
end

local function parseLine(line)
	local text = trim(line)
	if text == "" then
		return nil
	end
	local id, s, e = extractId(text)
	local name = text
	if id then
		name = string.sub(text, 1, s - 1) .. " " .. string.sub(text, e)
	end
	name = cleanName(name)
	if name == "" then
		name = nil
	end
	return { name = name, id = id }
end

local function usernameFrom(name)
	if not name then
		return nil
	end
	local plain = string.gsub(name, "^@", "")
	if string.match(plain, "^[%w_]+$") and #plain >= 3 and #plain <= 20 then
		return plain
	end
	local inner = string.match(name, "%(@?([%w_]+)%)")
	if inner and #inner >= 3 and #inner <= 20 then
		return inner
	end
	return nil
end

local ID_KEYS = {
	id = true, userid = true, uid = true, robloxid = true, placeid = true,
	universeid = true, assetid = true, residenceid = true, houseid = true,
}
local IMAGE_KEYS = {
	image = true, imageid = true, imageurl = true, icon = true, iconurl = true,
	thumbnail = true, thumbnailurl = true, thumb = true, img = true, avatar = true,
	avatarurl = true, headshot = true, picture = true, photo = true, url = true, decalid = true,
}
local SKIP_KEYS = {
	time = true, timestamp = true, updated = true, updatedat = true, created = true,
	createdat = true, version = true, count = true, total = true, expires = true,
	expiry = true, ttl = true,
}

local function keyOf(k)
	return (string.lower((string.gsub(tostring(k), "[^%w]", ""))))
end

local function digitsId(v)
	if type(v) == "number" and v >= 10000 and v == math.floor(v) then
		return v
	end
	if type(v) == "string" and string.match(v, "^%d%d%d%d%d+$") then
		return tonumber(v)
	end
	return nil
end

local function walkCache(node, hint, list, depth, parentIsRecord)
	if type(node) ~= "table" or depth > 6 then
		return
	end

	local rec = {}
	local isRecord = false
	local nested = {}
	local scalars = {}

	for k, v in pairs(node) do
		local nk = keyOf(k)
		local tv = type(v)
		if tv == "table" then
			nested[#nested + 1] = { k, v }
		elseif SKIP_KEYS[nk] then
		elseif ID_KEYS[nk] and digitsId(v) then
			rec.id = rec.id or digitsId(v)
			isRecord = true
		elseif tv == "string" and (nk == "username" or nk == "user" or nk == "owner") then
			rec.username = rec.username or v
			isRecord = true
		elseif tv == "string" and nk == "displayname" then
			rec.display = rec.display or v
			isRecord = true
		elseif tv == "string" and (nk == "name" or nk == "title" or nk == "label" or nk == "residence") then
			rec.name = rec.name or v
			isRecord = true
		elseif IMAGE_KEYS[nk] and (tv == "string" or tv == "number") then
			rec.image = rec.image or v
			isRecord = true
		else
			scalars[#scalars + 1] = { k, v }
		end
	end

	if isRecord then
		if not parentIsRecord and not (rec.name or rec.username or rec.display) and type(hint) == "string" then
			local hintId = digitsId(hint)
			if hintId then
				rec.id = rec.id or hintId
			elseif rec.id or rec.image then
				rec.name = hint
			end
		end
		if rec.id or rec.name or rec.username or rec.display then
			list[#list + 1] = rec
		end
	else
		for _, pair in ipairs(scalars) do
			local k, v = pair[1], pair[2]
			if type(k) == "string" and not SKIP_KEYS[keyOf(k)] then
				local vid = digitsId(v)
				local kid = digitsId(k)
				if vid and not kid then
					list[#list + 1] = { name = k, id = vid }
				elseif kid and type(v) == "string" and v ~= "" then
					list[#list + 1] = { id = kid, name = v }
				end
			end
		end
	end

	for _, pair in ipairs(nested) do
		walkCache(pair[2], pair[1], list, depth + 1, isRecord)
	end
end

local function loadCache()
	local result = { list = {}, byId = {}, byName = {}, note = nil }
	local raw, err = readWorkspaceFile(CONFIG.ResidenceCache)
	if not raw then
		result.note = err
		return result
	end
	local ok, decoded = pcall(function()
		return HttpService:JSONDecode(raw)
	end)
	if not ok then
		result.note = CONFIG.ResidenceCache .. " invalid JSON"
		return result
	end
	walkCache(decoded, nil, result.list, 0, false)
	for _, rec in ipairs(result.list) do
		if rec.id and not result.byId[rec.id] then
			result.byId[rec.id] = rec
		end
		for _, value in ipairs({ rec.name or false, rec.username or false, rec.display or false }) do
			if value then
				local key = normalize(value)
				if not result.byName[key] then
					result.byName[key] = rec
				end
			end
		end
	end
	return result
end

local function buildEntries()
	local entries = {}
	local notes = {}
	local rawText, errText = readWorkspaceFile(CONFIG.ResidenceFile)
	local cache = loadCache()
	if cache.note then
		notes[#notes + 1] = cache.note
	end

	if rawText then
		for _, line in ipairs(splitLines(rawText)) do
			local parsed = parseLine(line)
			if parsed then
				local rec = nil
				if parsed.id then
					rec = cache.byId[parsed.id]
				end
				if not rec and parsed.name then
					rec = cache.byName[normalize(parsed.name)]
				end
				local entry = { Name = parsed.name, Id = parsed.id }
				if rec then
					entry.Id = entry.Id or rec.id
					entry.Name = entry.Name or rec.name or rec.username or rec.display
					entry.Username = rec.username
					entry.Image = rec.image
				end
				if entry.Name or entry.Id then
					entries[#entries + 1] = entry
				end
			end
		end
	else
		notes[#notes + 1] = errText
	end

	if #entries == 0 and #cache.list > 0 then
		local sorted = {}
		for _, rec in ipairs(cache.list) do
			sorted[#sorted + 1] = rec
		end
		table.sort(sorted, function(a, b)
			local an = string.lower(a.name or a.username or a.display or "")
			local bn = string.lower(b.name or b.username or b.display or "")
			if an == bn then
				return (a.id or 0) < (b.id or 0)
			end
			return an < bn
		end)
		for _, rec in ipairs(sorted) do
			entries[#entries + 1] = {
				Name = rec.name or rec.username or rec.display,
				Id = rec.id,
				Username = rec.username,
				Image = rec.image,
			}
		end
		notes[#notes + 1] = "listing from cache"
	end

	for i, entry in ipairs(entries) do
		entry.Index = i
	end
	return entries, notes, rawText
end

local function resolveEntry(entry)
	if not entry.Id and entry.Name then
		local lookup = usernameFrom(entry.Name)
		if lookup then
			local ok, id = pcall(function()
				return Players:GetUserIdFromNameAsync(lookup)
			end)
			if ok and type(id) == "number" then
				entry.Id = id
				entry.Username = entry.Username or lookup
			end
		end
	end
	if entry.Id and not entry.Name then
		local ok, uname = pcall(function()
			return Players:GetNameFromUserIdAsync(entry.Id)
		end)
		if ok and type(uname) == "string" then
			entry.Name = uname
			entry.Username = uname
		end
	end
end

local function downloadImage(url, key)
	local req = nil
	if typeof(request) == "function" then
		req = request
	elseif typeof(http_request) == "function" then
		req = http_request
	end
	if not req or typeof(writefile) ~= "function" or typeof(getcustomasset) ~= "function" then
		return nil
	end
	local ok, res = pcall(req, { Url = url, Method = "GET" })
	if not ok or type(res) ~= "table" or type(res.Body) ~= "string" or res.Body == "" then
		return nil
	end
	if res.StatusCode and res.StatusCode ~= 200 then
		return nil
	end
	if typeof(makefolder) == "function" and typeof(isfolder) == "function" then
		pcall(function()
			if not isfolder("MatrixUI_Residences") then
				makefolder("MatrixUI_Residences")
			end
		end)
	end
	local path = "MatrixUI_Residences/" .. key .. ".png"
	if not pcall(writefile, path, res.Body) then
		return nil
	end
	local okAsset, asset = pcall(getcustomasset, path)
	if okAsset then
		return asset
	end
	return nil
end

local function residenceImageSource(value, key)
	if type(value) == "number" and value >= 1000 then
		return "rbxassetid://" .. math.floor(value)
	end
	if type(value) ~= "string" or value == "" then
		return nil
	end
	if string.match(value, "^%d+$") and #value >= 4 then
		return "rbxassetid://" .. value
	end
	local lowered = string.lower(value)
	if string.find(lowered, "^rbxassetid://") or string.find(lowered, "^rbxthumb://")
		or string.find(lowered, "^rbxasset://") then
		return value
	end
	if string.find(lowered, "^https?://") then
		if string.find(lowered, "roblox.com", 1, true) then
			return value
		end
		return downloadImage(value, key)
	end
	return nil
end

local function residenceImage(entry)
	local source = residenceImageSource(entry.Image, tostring(entry.Id or entry.Index))
	if source then
		return source
	end
	if entry.Id then
		return "rbxthumb://type=AvatarHeadShot&id=" .. tostring(entry.Id) .. "&w=150&h=150"
	end
	return nil
end

local function fireResidence(id, label)
	local remote = ReplicatedStorage:FindFirstChild("ConfirmRemote")
		or ReplicatedStorage:WaitForChild("ConfirmRemote", 5)
	if not remote then
		setStatus("ConfirmRemote not found")
		return
	end
	local ok, err = pcall(function()
		if remote:IsA("RemoteFunction") then
			return remote:InvokeServer(id)
		end
		remote:FireServer(id)
	end)
	if ok then
		setStatus("Applied: " .. label .. " (" .. tostring(id) .. ")")
	else
		setStatus("Error: " .. string.sub(tostring(err), 1, 40))
	end
end

local function applyResidence(entry)
	if not entry.Id then
		resolveEntry(entry)
		if entry.Refresh then
			entry.Refresh()
		end
	end
	if not entry.Id then
		setStatus("No ID for " .. tostring(entry.Name))
		return
	end
	fireResidence(entry.Id, entry.Name or tostring(entry.Id))
end

local function applyManual(text)
	text = trim(text)
	if text == "" then
		setStatus("Type a name, username or ID")
		return
	end
	local id = extractId(text)
	local label = text
	if not id then
		local lookup = usernameFrom(text)
		if not lookup then
			setStatus("Invalid name or ID")
			return
		end
		local ok, result = pcall(function()
			return Players:GetUserIdFromNameAsync(lookup)
		end)
		if not ok or type(result) ~= "number" then
			setStatus("User not found: " .. lookup)
			return
		end
		id = result
		label = lookup
	end
	fireResidence(id, label)
end

local residencePage = pages["Residences"]
local loadResidences

local infoRow = make("Frame", {
	Name = "Info",
	Size = UDim2.new(1, 0, 0, 36),
	LayoutOrder = nextOrder(),
	ZIndex = 3,
}, residencePage)
styleRow(infoRow)

local infoLabel = make("TextLabel", {
	Position = UDim2.fromOffset(10, 0),
	Size = UDim2.new(1, -90, 1, 0),
	BackgroundTransparency = 1,
	Text = "",
	TextColor3 = CONFIG.Accent,
	TextTransparency = 0.2,
	TextSize = 12,
	Font = Enum.Font.Code,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextWrapped = true,
	TextTruncate = Enum.TextTruncate.AtEnd,
	ZIndex = 4,
}, infoRow)

local function setResidenceInfo(text)
	infoLabel.Text = text
end

addSmallButton(infoRow, "Reload", UDim2.new(1, -76, 0.5, -13), UDim2.fromOffset(68, 26), function()
	loadResidences()
end)

local manualRow = make("Frame", {
	Name = "Manual",
	Size = UDim2.new(1, 0, 0, 40),
	LayoutOrder = nextOrder(),
	ZIndex = 3,
}, residencePage)
styleRow(manualRow)

local manualBox = make("TextBox", {
	Position = UDim2.fromOffset(8, 6),
	Size = UDim2.new(1, -92, 0, 28),
	BackgroundColor3 = Color3.fromRGB(0, 40, 10),
	BackgroundTransparency = 0.2,
	BorderSizePixel = 0,
	Text = "",
	PlaceholderText = "Name / Username / ID",
	PlaceholderColor3 = Color3.fromRGB(0, 140, 40),
	TextColor3 = CONFIG.Accent,
	TextSize = 13,
	Font = Enum.Font.Code,
	TextXAlignment = Enum.TextXAlignment.Left,
	ClearTextOnFocus = false,
	ZIndex = 4,
}, manualRow)
make("UICorner", { CornerRadius = UDim.new(0, 6) }, manualBox)
make("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) }, manualBox)

addSmallButton(manualRow, "Apply", UDim2.new(1, -76, 0.5, -14), UDim2.fromOffset(68, 28), function()
	applyManual(manualBox.Text)
end)

manualBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		task.spawn(applyManual, manualBox.Text)
	end
end)

local function addResidenceCard(page, entry)
	local card = make("Frame", {
		Name = "Residence_" .. entry.Index,
		Size = UDim2.new(1, 0, 0, 62),
		LayoutOrder = nextOrder(),
		ZIndex = 3,
	}, page)
	styleRow(card)

	local holder = make("Frame", {
		Name = "Icon",
		Position = UDim2.fromOffset(10, 8),
		Size = UDim2.fromOffset(46, 46),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 4,
	}, card)
	make("UICorner", { CornerRadius = UDim.new(0, 8) }, holder)
	addGlowBorder(holder, 2)

	local placeholder = make("TextLabel", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = "?",
		TextColor3 = CONFIG.Accent,
		TextTransparency = 0.4,
		TextSize = 22,
		Font = Enum.Font.Code,
		ZIndex = 4,
	}, holder)

	local nameLabel = make("TextLabel", {
		Position = UDim2.fromOffset(66, 8),
		Size = UDim2.new(1, -150, 0, 22),
		BackgroundTransparency = 1,
		Text = "",
		TextColor3 = CONFIG.Accent,
		TextSize = 14,
		Font = Enum.Font.Code,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 4,
	}, card)

	local idLabel = make("TextLabel", {
		Position = UDim2.fromOffset(66, 32),
		Size = UDim2.new(1, -150, 0, 18),
		BackgroundTransparency = 1,
		Text = "",
		TextColor3 = CONFIG.Accent,
		TextTransparency = 0.35,
		TextSize = 12,
		Font = Enum.Font.Code,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 4,
	}, card)

	addSmallButton(card, "Apply", UDim2.new(1, -76, 0.5, -15), UDim2.fromOffset(68, 30), function()
		applyResidence(entry)
	end)

	local imageStarted = false

	local function refresh()
		local display = entry.Name or entry.Username or "..."
		nameLabel.Text = entry.Index .. ". " .. display
		local parts = { "ID: " .. (entry.Id and tostring(entry.Id) or "?") }
		if entry.Username and entry.Username ~= entry.Name then
			parts[#parts + 1] = "@" .. entry.Username
		end
		idLabel.Text = table.concat(parts, "   ")
		placeholder.Text = string.upper(string.sub(display, 1, 1))
		if not imageStarted and (entry.Image or entry.Id) then
			imageStarted = true
			task.spawn(function()
				local image = residenceImage(entry)
				if image and card.Parent then
					local img = make("ImageLabel", {
						Size = UDim2.fromScale(1, 1),
						BackgroundColor3 = Color3.new(0, 0, 0),
						BackgroundTransparency = 0,
						BorderSizePixel = 0,
						Image = image,
						ScaleType = Enum.ScaleType.Crop,
						ZIndex = 5,
					}, holder)
					make("UICorner", { CornerRadius = UDim.new(0, 8) }, img)
				end
			end)
		end
	end

	entry.Refresh = refresh
	refresh()
	return card
end

loadResidences = function()
	residences.Token += 1
	local token = residences.Token

	for _, card in ipairs(residences.Cards) do
		card:Destroy()
	end
	residences.Cards = {}
	residences.Entries = {}
	setResidenceInfo("Loading...")

	local ok, entries, notes, raw = pcall(buildEntries)
	if not ok then
		setResidenceInfo("Parse error: " .. string.sub(tostring(entries), 1, 80))
		return
	end
	residences.Entries = entries

	for _, entry in ipairs(entries) do
		residences.Cards[#residences.Cards + 1] = addResidenceCard(residencePage, entry)
	end

	local noteText = #notes > 0 and (" | " .. table.concat(notes, " | ")) or ""
	if #entries > 0 then
		setResidenceInfo("Loaded " .. #entries .. " residences" .. noteText)
	else
		local preview = ""
		if raw then
			preview = " | " .. string.sub((string.gsub(raw, "%s+", " ")), 1, 60)
		end
		setResidenceInfo("No residences found" .. noteText .. preview)
	end

	task.spawn(function()
		for _, entry in ipairs(entries) do
			if residences.Token ~= token then
				return
			end
			if not entry.Id or not entry.Name then
				resolveEntry(entry)
				if entry.Refresh then
					entry.Refresh()
				end
				task.wait(0.2)
			end
		end
	end)
end

addToggle(pages["Combat"], "Hitbox Expander", false, function(state)
	hitbox.Enabled = state
	if not state then
		restoreHitboxes()
	end
end)

addSlider(pages["Combat"], "Hitbox Size", 1, CONFIG.HitboxMax, CONFIG.HitboxDefault, function(v)
	hitbox.Size = v
end)

addToggle(pages["Combat"], "Team Check", false, function(state)
	hitbox.TeamCheck = state
end)

-- ===== Auto Hit (Combat tab) - wrapped in a function to save local variables =====
task.spawn(function()
	local combatPage = pages["Combat"]

	local AutoHit = {
		Enabled = false,
		Running = true,
		MaxDistance = 28,
		Delay = 0.08,
		SendFX = true,
		Targets = {}, -- [UserId] = true  (players to hit; empty = everyone)
		Ignored = {}, -- [UserId] = true  (players never hit)
	}

	local CAPTURED_CF = CFrame.new(
		5.00006103515625, 1.9088973999023438, 0.17636537551879883,
		2.4498044695064891e-06, 0, -1.0000001192092896,
		0, 1.0000001192092896, 0,
		1, 0, 2.4518190002709161e-06
	)

	local remoteCache = {}

	local function getRemotes()
		if remoteCache.Hit and remoteCache.Hit.Parent then
			return remoteCache.Hit, remoteCache.FX
		end
		local assets = ReplicatedStorage:FindFirstChild("Assets")
		local folder = assets and assets:FindFirstChild("Remotes")
		if not folder then
			return nil, nil
		end
		remoteCache.Hit = folder:FindFirstChild("hitMelee")
		remoteCache.FX = folder:FindFirstChild("repMeleeFX")
		return remoteCache.Hit, remoteCache.FX
	end

	-- only works when a shop weapon is held in the hand
	local function getEquippedWeapon()
		local character = LocalPlayer.Character
		if not character then
			return nil
		end
		for _, weaponName in ipairs(CONFIG.Weapons) do
			local tool = character:FindFirstChild(weaponName)
			if tool and tool:IsA("Tool") then
				return tool
			end
		end
		return nil
	end

	local function getBestTarget()
		local myChar = LocalPlayer.Character
		local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
		if not myRoot then
			return nil, nil
		end

		local useList = next(AutoHit.Targets) ~= nil
		local bestRoot = nil
		local bestDist = AutoHit.MaxDistance

		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer
				and not AutoHit.Ignored[plr.UserId]
				and (not useList or AutoHit.Targets[plr.UserId]) then
				local char = plr.Character
				if char then
					local hum = char:FindFirstChildOfClass("Humanoid")
					local root = char:FindFirstChild("HumanoidRootPart")
					local hasFF = char:FindFirstChildOfClass("ForceField")
					if hum and hum.Health > 0 and root and not hasFF then
						local dist = (root.Position - myRoot.Position).Magnitude
						if dist <= bestDist then
							bestDist = dist
							bestRoot = root
						end
					end
				end
			end
		end

		return bestRoot, myRoot
	end

	local function doHit()
		local tool = getEquippedWeapon()
		if not tool then
			return
		end
		local hit, fx = getRemotes()
		if not hit then
			return
		end
		local targetRoot, myRoot = getBestTarget()
		if not (targetRoot and myRoot) then
			return
		end

		local delta = targetRoot.Position - myRoot.Position
		local dir = delta.Magnitude > 0.001 and delta.Unit or Vector3.new(0, 0, -1)

		hit:FireServer(
			targetRoot,
			targetRoot.Position,
			dir,
			Enum.Material.Plastic,
			CAPTURED_CF,
			tool
		)

		if AutoHit.SendFX and fx then
			fx:FireServer(
				targetRoot,
				targetRoot.Position,
				dir,
				Enum.Material.Plastic
			)
		end
	end

	-- ===== multi-select player picker (dropdown card) =====
	local function createPicker(title, emptyText, selected, onToggle)
		local HEADER_H = 36
		local ROW_H = 44
		local ROW_GAP = 4
		local MAX_LIST_H = 184

		local expanded = false
		local rows = {}
		local rowCount = 0

		local card = make("Frame", {
			Name = title,
			Size = UDim2.new(1, 0, 0, HEADER_H),
			ClipsDescendants = true,
			LayoutOrder = nextOrder(),
			ZIndex = 3,
		}, combatPage)
		styleRow(card)

		local header = make("TextButton", {
			Name = "Header",
			Size = UDim2.new(1, 0, 0, HEADER_H),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			ZIndex = 4,
		}, card)

		local titleLabel = make("TextLabel", {
			Position = UDim2.fromOffset(12, 0),
			Size = UDim2.new(1, -50, 1, 0),
			BackgroundTransparency = 1,
			Text = title,
			TextColor3 = CONFIG.Accent,
			TextSize = 14,
			Font = Enum.Font.Code,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 4,
		}, header)

		local arrow = make("TextLabel", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -10, 0.5, 0),
			Size = UDim2.fromOffset(30, 20),
			BackgroundTransparency = 1,
			Text = "[+]",
			TextColor3 = CONFIG.Accent,
			TextSize = 13,
			Font = Enum.Font.Code,
			ZIndex = 4,
		}, header)

		local list = make("ScrollingFrame", {
			Name = "List",
			Position = UDim2.fromOffset(6, HEADER_H + 4),
			Size = UDim2.new(1, -12, 0, ROW_H),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = CONFIG.Accent,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Visible = false,
			ZIndex = 4,
		}, card)
		make("UIListLayout", {
			Padding = UDim.new(0, ROW_GAP),
			SortOrder = Enum.SortOrder.Name,
		}, list)
		make("UIPadding", { PaddingRight = UDim.new(0, 5) }, list)

		local emptyLabel = make("TextLabel", {
			Position = UDim2.fromOffset(12, HEADER_H + 4),
			Size = UDim2.new(1, -24, 0, 28),
			BackgroundTransparency = 1,
			Text = "No other players",
			TextColor3 = CONFIG.Accent,
			TextTransparency = 0.4,
			TextSize = 13,
			Font = Enum.Font.Code,
			TextXAlignment = Enum.TextXAlignment.Left,
			Visible = false,
			ZIndex = 4,
		}, card)

		local function updateHeader()
			local count = 0
			for _ in pairs(selected) do
				count += 1
			end
			titleLabel.Text = title .. ": " .. (count == 0 and emptyText or tostring(count))
		end
		updateHeader()

		local function resize(animate)
			local listH = math.clamp(rowCount * (ROW_H + ROW_GAP), ROW_H, MAX_LIST_H)
			list.Size = UDim2.new(1, -12, 0, listH)
			list.Visible = rowCount > 0
			emptyLabel.Visible = rowCount == 0

			local height = HEADER_H
			if expanded then
				if rowCount == 0 then
					height = HEADER_H + 36
				else
					height = HEADER_H + 8 + listH
				end
			end
			local size = UDim2.new(1, 0, 0, height)
			if animate then
				TweenService:Create(card, TWEEN, { Size = size }):Play()
			else
				card.Size = size
			end
		end

		local function paintRow(entry)
			local on = selected[entry.UserId] == true
			entry.Row.BackgroundColor3 = on and Color3.fromRGB(0, 60, 18) or Color3.new(0, 0, 0)
			entry.Row.BackgroundTransparency = on and 0.1 or 0.35
			entry.Fill.Visible = on
		end

		local function Add(plr)
			if plr == LocalPlayer or rows[plr.UserId] then
				return
			end
			local userId = plr.UserId

			local row = make("TextButton", {
				Name = string.format("%s_%d", string.lower(plr.DisplayName), userId),
				Size = UDim2.new(1, 0, 0, ROW_H),
				Text = "",
				AutoButtonColor = false,
				ZIndex = 5,
			}, list)
			styleRow(row)

			local avatarHolder = make("Frame", {
				Position = UDim2.fromOffset(6, 5),
				Size = UDim2.fromOffset(34, 34),
				BackgroundColor3 = Color3.new(0, 0, 0),
				BackgroundTransparency = 0.3,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				ZIndex = 6,
			}, row)
			make("UICorner", { CornerRadius = UDim.new(0, 8) }, avatarHolder)
			local avatar = make("ImageLabel", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Image = "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=150&h=150",
				ScaleType = Enum.ScaleType.Crop,
				ZIndex = 7,
			}, avatarHolder)
			make("UICorner", { CornerRadius = UDim.new(0, 8) }, avatar)

			make("TextLabel", {
				Position = UDim2.fromOffset(46, 4),
				Size = UDim2.new(1, -80, 0, 18),
				BackgroundTransparency = 1,
				Text = plr.DisplayName,
				TextColor3 = CONFIG.Accent,
				TextSize = 13,
				Font = Enum.Font.Code,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				ZIndex = 6,
			}, row)

			make("TextLabel", {
				Position = UDim2.fromOffset(46, 22),
				Size = UDim2.new(1, -80, 0, 16),
				BackgroundTransparency = 1,
				Text = "@" .. plr.Name,
				TextColor3 = CONFIG.Accent,
				TextTransparency = 0.4,
				TextSize = 11,
				Font = Enum.Font.Code,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
				ZIndex = 6,
			}, row)

			local box = make("Frame", {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -10, 0.5, 0),
				Size = UDim2.fromOffset(18, 18),
				BackgroundColor3 = Color3.fromRGB(0, 25, 8),
				BorderSizePixel = 0,
				ZIndex = 6,
			}, row)
			make("UICorner", { CornerRadius = UDim.new(0, 4) }, box)
			make("UIStroke", {
				Color = CONFIG.Accent,
				Transparency = 0.3,
				Thickness = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			}, box)
			local fill = make("Frame", {
				Position = UDim2.fromOffset(3, 3),
				Size = UDim2.new(1, -6, 1, -6),
				BackgroundColor3 = CONFIG.Accent,
				BorderSizePixel = 0,
				Visible = false,
				ZIndex = 7,
			}, box)
			make("UICorner", { CornerRadius = UDim.new(0, 2) }, fill)

			local entry = { UserId = userId, Row = row, Fill = fill }
			rows[userId] = entry
			rowCount += 1
			paintRow(entry)

			row.MouseButton1Click:Connect(function()
				local state = not (selected[userId] == true)
				selected[userId] = state and true or nil
				paintRow(entry)
				updateHeader()
				if onToggle then
					onToggle(userId, state)
				end
				setStatus(title .. ": " .. plr.Name .. (state and " added" or " removed"))
			end)

			resize(false)
		end

		local function Remove(userId)
			local entry = rows[userId]
			if entry then
				entry.Row:Destroy()
				rows[userId] = nil
				rowCount -= 1
			end
			selected[userId] = nil
			updateHeader()
			resize(false)
		end

		local function Deselect(userId)
			selected[userId] = nil
			local entry = rows[userId]
			if entry then
				paintRow(entry)
			end
			updateHeader()
		end

		header.MouseButton1Click:Connect(function()
			expanded = not expanded
			arrow.Text = expanded and "[-]" or "[+]"
			resize(true)
		end)

		return { Add = Add, Remove = Remove, Deselect = Deselect }
	end

	-- ===== UI =====
	addToggle(combatPage, "Auto Hit", false, function(state)
		AutoHit.Enabled = state
	end)

	addSlider(combatPage, "Max Distance", 16, 10000, AutoHit.MaxDistance, function(v)
		AutoHit.MaxDistance = v
	end)

	addSlider(combatPage, "Delay (ms)", 0, 1000, AutoHit.Delay * 1000, function(v)
	AutoHit.Delay = v / 1000
end, 2)

	local hitPicker, ignorePicker

	hitPicker = createPicker("Hit Players", "All", AutoHit.Targets, function(userId, state)
		if state and AutoHit.Ignored[userId] then
			ignorePicker.Deselect(userId)
		end
	end)

	ignorePicker = createPicker("Don't Hit Players", "None", AutoHit.Ignored, function(userId, state)
		if state and AutoHit.Targets[userId] then
			hitPicker.Deselect(userId)
		end
	end)

	for _, p in ipairs(Players:GetPlayers()) do
		hitPicker.Add(p)
		ignorePicker.Add(p)
	end

	track(Players.PlayerAdded:Connect(function(p)
		hitPicker.Add(p)
		ignorePicker.Add(p)
	end))

	track(Players.PlayerRemoving:Connect(function(p)
		hitPicker.Remove(p.UserId)
		ignorePicker.Remove(p.UserId)
	end))

	gui.Destroying:Connect(function()
		AutoHit.Running = false
		AutoHit.Enabled = false
	end)

	-- ===== main loop =====
	while AutoHit.Running do
		task.wait(AutoHit.Delay)
		if AutoHit.Enabled then
			pcall(doHit)
		end
	end
end)

addToggle(pages["Movement"], "Speed Lock", false, function(state)
	speed.Lock = state
	local hum = getHumanoid()
	if not hum then
		return
	end
	if state then
		syncSpeed(hum)
	else
		hum.WalkSpeed = speed.Base
	end
end)

local speedSlider = addSlider(pages["Movement"], "Speed", CONFIG.SpeedMin, CONFIG.SpeedMax, speed.Value, function(v)
	speed.Value = v
	if speed.Lock then
		syncSpeed(getHumanoid())
	end
end)

addButton(pages["Movement"], "Reset Speed", function()
	speedSlider.Set(speed.Base)
end)

addToggle(pages["Movement"], "Infinite Jump", false, function(state)
	infJump = state
end)

addToggle(pages["Movement"], "Noclip", false, function(state)
	noclip = state
	if not state then
		restoreNoclip()
	end
end)

addToggle(pages["Visual"], "Player ESP", false, function(state)
	esp.Enabled = state
	if state then
		for _, p in ipairs(Players:GetPlayers()) do
			applyESP(p)
		end
	else
		for player in pairs(esp.Objects) do
			removeESP(player)
		end
	end
end)

addToggle(pages["Visual"], "Vending Machine ESP", false, function(state)
	setMachineESP(state)
end)

-- ===== Vending Machine Auto Hit + Teleport (Visual tab) =====
task.spawn(function()
	local visualPage = pages["Visual"]

		local VM = {
		Enabled = false,
		Running = true,
		MaxDistance = 28,
		Delay = 0,
		SendFX = true,
		List = {},
	}

	local CAPTURED_CF = CFrame.new(
		5.00006103515625, 1.9088973999023438, 0.17636537551879883,
		2.4498044695064891e-06, 0, -1.0000001192092896,
		0, 1.0000001192092896, 0,
		1, 0, 2.4518190002709161e-06
	)
	
	local teleportOrder = nextOrder()
	
	-- ===== UI =====
	addToggle(visualPage, "Machine Auto Hit", false, function(state)
		VM.Enabled = state
	end)

	addSlider(visualPage, "Machine Distance", 5, 10000, VM.MaxDistance, function(v)
		VM.MaxDistance = v
	end)

		addSlider(visualPage, "Machine Delay (ms)", 0, 1000, 0, function(v)
		VM.Delay = v / 1000
	end, 2)

	-- ===== Teleport dropdown =====
	local HEADER_H, ROW_H, GAP, MAX_LIST_H = 36, 30, 4, 150
	local expanded = false
	local rowButtons = {}

	local card = make("Frame", {
		Name = "MachineTeleport",
		Size = UDim2.new(1, 0, 0, HEADER_H),
		ClipsDescendants = true,
		LayoutOrder = teleportOrder,
		ZIndex = 3,
	}, visualPage)
	styleRow(card)

	local header = make("TextButton", {
		Size = UDim2.new(1, 0, 0, HEADER_H),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 4,
	}, card)

	local titleLabel = make("TextLabel", {
		Position = UDim2.fromOffset(12, 0),
		Size = UDim2.new(1, -50, 1, 0),
		BackgroundTransparency = 1,
		Text = "Teleport: Machines",
		TextColor3 = CONFIG.Accent,
		TextSize = 14,
		Font = Enum.Font.Code,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 4,
	}, header)

	local arrow = make("TextLabel", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.fromOffset(30, 20),
		BackgroundTransparency = 1,
		Text = "[+]",
		TextColor3 = CONFIG.Accent,
		TextSize = 13,
		Font = Enum.Font.Code,
		ZIndex = 4,
	}, header)

	local list = make("ScrollingFrame", {
		Position = UDim2.fromOffset(6, HEADER_H + 4),
		Size = UDim2.new(1, -12, 0, ROW_H),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = CONFIG.Accent,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Visible = false,
		ZIndex = 4,
	}, card)
	make("UIListLayout", {
		Padding = UDim.new(0, GAP),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, list)
	make("UIPadding", { PaddingRight = UDim.new(0, 5) }, list)

	local emptyLabel = make("TextLabel", {
		Position = UDim2.fromOffset(12, HEADER_H + 4),
		Size = UDim2.new(1, -24, 0, 28),
		BackgroundTransparency = 1,
		Text = "No VendingMachine found",
		TextColor3 = CONFIG.Accent,
		TextTransparency = 0.4,
		TextSize = 13,
		Font = Enum.Font.Code,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 4,
	}, card)

	local function machineBox(model)
		local ok, cf, size = pcall(model.GetBoundingBox, model)
		if ok and cf then
			return cf, size
		end
		return model:GetPivot(), Vector3.new(4, 6, 4)
	end

	local function teleportTo(model)
		local char = LocalPlayer.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if not (root and model.Parent) then
			setStatus("Can't teleport")
			return
		end
		local cf, size = machineBox(model)
		root.CFrame = CFrame.new(cf.Position + Vector3.new(0, size.Y / 2 + 4, 0))
		root.AssemblyLinearVelocity = Vector3.zero
		setStatus("Teleported to " .. CONFIG.MachineName)
	end

	local function rebuild()
		for _, b in ipairs(rowButtons) do
			b:Destroy()
		end
		rowButtons = {}

		local char = LocalPlayer.Character
		local myRoot = char and char:FindFirstChild("HumanoidRootPart")
		local items = {}
		for model in pairs(VM.List) do
			if model.Parent then
				local cf = machineBox(model)
				local d = myRoot and (cf.Position - myRoot.Position).Magnitude or 0
				items[#items + 1] = { Model = model, Dist = d }
			end
		end
		table.sort(items, function(a, b)
			return a.Dist < b.Dist
		end)

		for i, item in ipairs(items) do
			local btn = make("TextButton", {
				Name = string.format("%03d", i),
				Size = UDim2.new(1, 0, 0, ROW_H),
				Text = string.format("#%d  -  %d studs", i, math.floor(item.Dist)),
				TextColor3 = CONFIG.Accent,
				TextSize = 13,
				Font = Enum.Font.Code,
				AutoButtonColor = false,
				LayoutOrder = i,
				ZIndex = 5,
			}, list)
			styleRow(btn)
			btn.MouseButton1Click:Connect(function()
				teleportTo(item.Model)
			end)
			rowButtons[#rowButtons + 1] = btn
		end

		titleLabel.Text = "Teleport: Machines (" .. #items .. ")"
	end

	local function resize(animate)
		local count = #rowButtons
		local listH = math.clamp(count * (ROW_H + GAP), ROW_H, MAX_LIST_H)
		list.Size = UDim2.new(1, -12, 0, listH)
		list.Visible = count > 0
		emptyLabel.Visible = count == 0

		local height = HEADER_H
		if expanded then
			height = (count == 0) and (HEADER_H + 36) or (HEADER_H + 8 + listH)
		end
		local size = UDim2.new(1, 0, 0, height)
		if animate then
			TweenService:Create(card, TWEEN, { Size = size }):Play()
		else
			card.Size = size
		end
	end

	local function refresh(animate)
		rebuild()
		resize(animate)
	end

	local pending = false
	local function queueRefresh()
		if pending then
			return
		end
		pending = true
		task.delay(0.3, function()
			pending = false
			refresh(false)
		end)
	end

	header.MouseButton1Click:Connect(function()
		expanded = not expanded
		arrow.Text = expanded and "[-]" or "[+]"
		refresh(true)
	end)

	-- ===== track machines =====
	track(workspace.DescendantAdded:Connect(function(obj)
		if isMachine(obj) and not VM.List[obj] then
			VM.List[obj] = true
			queueRefresh()
		end
	end))

	track(workspace.DescendantRemoving:Connect(function(obj)
		if VM.List[obj] then
			VM.List[obj] = nil
			queueRefresh()
		end
	end))

	task.spawn(function()
		local count = 0
		for _, obj in ipairs(workspace:GetDescendants()) do
			if isMachine(obj) then
				VM.List[obj] = true
			end
			count += 1
			if count % 3000 == 0 then
				task.wait()
			end
		end
		queueRefresh()
	end)

	-- ===== hit logic =====
	local remoteCache = {}

	local function getRemotes()
		if remoteCache.Hit and remoteCache.Hit.Parent then
			return remoteCache.Hit, remoteCache.FX
		end
		local assets = ReplicatedStorage:FindFirstChild("Assets")
		local folder = assets and assets:FindFirstChild("Remotes")
		if not folder then
			return nil, nil
		end
		remoteCache.Hit = folder:FindFirstChild("hitMelee")
		remoteCache.FX = folder:FindFirstChild("repMeleeFX")
		return remoteCache.Hit, remoteCache.FX
	end

	local function getEquippedWeapon()
		local character = LocalPlayer.Character
		if not character then
			return nil
		end
		for _, weaponName in ipairs(CONFIG.Weapons) do
			local tool = character:FindFirstChild(weaponName)
			if tool and tool:IsA("Tool") then
				return tool
			end
		end
		return nil
	end

	local function getBestPart()
		local char = LocalPlayer.Character
		local myRoot = char and char:FindFirstChild("HumanoidRootPart")
		if not myRoot then
			return nil, nil
		end
		local bestPart, bestDist = nil, VM.MaxDistance
		for model in pairs(VM.List) do
			if model.Parent then
				for _, d in ipairs(model:GetDescendants()) do
					if d:IsA("BasePart") then
						local dist = (d.Position - myRoot.Position).Magnitude
						if dist <= bestDist then
							bestDist = dist
							bestPart = d
						end
					end
				end
			end
		end
		return bestPart, myRoot
	end

	local function doHit()
		local tool = getEquippedWeapon()
		if not tool then
			return
		end
		local hit, fx = getRemotes()
		if not hit then
			return
		end
		local part, myRoot = getBestPart()
		if not (part and myRoot) then
			return
		end

		local delta = part.Position - myRoot.Position
		local dir = delta.Magnitude > 0.001 and delta.Unit or Vector3.new(0, 0, -1)

		hit:FireServer(part, part.Position, dir, part.Material, CAPTURED_CF, tool)

		if VM.SendFX and fx then
			fx:FireServer(part, part.Position, dir, part.Material)
		end
	end

	gui.Destroying:Connect(function()
		VM.Running = false
		VM.Enabled = false
	end)

	while VM.Running do
		task.wait(VM.Delay)
		if VM.Enabled then
			pcall(doHit)
		end
	end
end)

addButton(pages["Weapons"], "Buy All Weapons", buyAllWeapons)
for _, weaponName in ipairs(CONFIG.Weapons) do
	addWeaponCard(pages["Weapons"], weaponName)
end

-- ===== Name Tag (wrapped in a function to save local variables) =====
local setNameTag = (function()
	local TextService = game:GetService("TextService")
	local player = LocalPlayer

	local TAG_TEXT = player.Name
	local PERIOD = 1.5
	local BAND = 0.3
	local BANDS = 2
	local FLOAT_AMPLITUDE = 0.08
	local FADE_TIME = 0.6
	local POP_TIME = 0.5

	local GREEN = CONFIG.Accent
	local LIGHT = Color3.fromRGB(190, 255, 205)
	local SHINE = Color3.fromRGB(225, 255, 235)
	local SHINE_ALPHA = 0.8
	local EDGE_BASE = Color3.fromRGB(0, 55, 16)
	local EDGE_PEAK = LIGHT
	local LINE_BASE = Color3.fromRGB(0, 110, 30)
	local LINE_PEAK = LIGHT

	local SCAN_COLOR = LIGHT
	local SCAN_ALPHA = 0.9
	local SCAN_PERIOD = 2.6
	local SCAN_TRAVEL = 1.1
	local SCAN_BAND = 0.12
	local SCAN_TOP = 0.12
	local SCAN_BOTTOM = 0.88

	local SPARKLE_COUNT = 4
	local SPARKLE_SIZE = 14

	local GLITCH_MIN = 2.2
	local GLITCH_MAX = 4.5
	local GLITCH_TIME = 0.18
	local GLITCH_SHIFT = 4
	local GLITCH_A = GREEN
	local GLITCH_B = Color3.fromRGB(0, 90, 25)

	local FONT = Enum.Font.GothamBlack
	local LABEL_H = 46
	local MAX_FONT_SIZE = 40

	local S = {
		Enabled = false,
		Token = 0,
		Tag = nil,
		Anim = nil,
		CharConn = nil,
	}

	local half = BAND / 2
	local from = -half
	local to = 1 + half
	local travel = to - from
	local spacing = travel / BANDS
	local sweepSpeed = travel / PERIOD

	local function strengthAt(x, centers)
		local best = 0
		for _, c in ipairs(centers) do
			local k = 1 - math.abs(x - c) / half
			if k > best then
				best = k
			end
		end
		return best
	end

	local function positions(centers)
		local xs = { 0, 1 }
		for _, c in ipairs(centers) do
			for _, x in ipairs({ c - half, c, c + half }) do
				if x > 0.001 and x < 0.999 then
					xs[#xs + 1] = x
				end
			end
		end
		table.sort(xs)
		local list = {}
		local last = -1
		for _, x in ipairs(xs) do
			if x - last > 0.0005 then
				list[#list + 1] = x
				last = x
			end
		end
		return list
	end

	local function colorSeq(centers, base, peak)
		local points = {}
		for i, x in ipairs(positions(centers)) do
			points[i] = ColorSequenceKeypoint.new(x, base:Lerp(peak, strengthAt(x, centers)))
		end
		return ColorSequence.new(points)
	end

	local function alphaSeq(centers)
		local points = {}
		for i, x in ipairs(positions(centers)) do
			points[i] = NumberSequenceKeypoint.new(x, 1 - strengthAt(x, centers) * SHINE_ALPHA)
		end
		return NumberSequence.new(points)
	end

	local function bandSeq(c, h, alpha)
		local xs = { 0, 1 }
		for _, x in ipairs({ c - h, c, c + h }) do
			if x > 0.001 and x < 0.999 then
				xs[#xs + 1] = x
			end
		end
		table.sort(xs)
		local points = {}
		local last = -1
		for _, x in ipairs(xs) do
			if x - last > 0.0005 then
				local k = math.max(0, 1 - math.abs(x - c) / h)
				points[#points + 1] = NumberSequenceKeypoint.new(x, 1 - k * alpha)
				last = x
			end
		end
		return NumberSequence.new(points)
	end

	local function measure(text, size)
		if text == "" then
			return 0
		end
		local ok, v = pcall(function()
			return TextService:GetTextSize(text, size, FONT, Vector2.new(10000, 100))
		end)
		if ok then
			return v.X
		end
		return #text * size * 0.68
	end

	local function makeLabel(parent, z, fontSize)
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 0, LABEL_H)
		label.BackgroundTransparency = 1
		label.Text = TAG_TEXT
		label.Font = FONT
		label.TextScaled = false
		label.TextSize = fontSize
		label.TextXAlignment = Enum.TextXAlignment.Center
		label.TextYAlignment = Enum.TextYAlignment.Center
		label.TextColor3 = Color3.new(1, 1, 1)
		label.ZIndex = z
		label.Parent = parent
		return label
	end

	local function easeOutBack(p)
		local c1 = 1.70158
		local c3 = c1 + 1
		return 1 + c3 * (p - 1) ^ 3 + c1 * (p - 1) ^ 2
	end

	local function makeSparkle(parent)
		local holder = Instance.new("Frame")
		holder.AnchorPoint = Vector2.new(0.5, 0.5)
		holder.Size = UDim2.new(0, SPARKLE_SIZE, 0, SPARKLE_SIZE)
		holder.BackgroundTransparency = 1
		holder.ZIndex = 9
		holder.Visible = false
		holder.Parent = parent

		local sc = Instance.new("UIScale")
		sc.Scale = 1
		sc.Parent = holder

		local function bar(size, rot)
			local f = Instance.new("Frame")
			f.AnchorPoint = Vector2.new(0.5, 0.5)
			f.Position = UDim2.new(0.5, 0, 0.5, 0)
			f.Size = size
			f.BackgroundColor3 = LIGHT
			f.BorderSizePixel = 0
			f.ZIndex = 9
			f.Parent = holder
			local g = Instance.new("UIGradient")
			g.Rotation = rot
			g.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.5, 0),
				NumberSequenceKeypoint.new(1, 1),
			})
			g.Parent = f
		end
		bar(UDim2.new(1, 0, 0, 2), 0)
		bar(UDim2.new(0, 2, 1, 0), 90)

		return { holder = holder, scale = sc, start = 0, life = 0.6, size = 1 }
	end

	local function destroyTag()
		if S.Anim then
			S.Anim:Disconnect()
			S.Anim = nil
		end
		if S.Tag then
			S.Tag:Destroy()
			S.Tag = nil
		end
	end

	local function build(head)
		destroyTag()

		local oldTag = head:FindFirstChild("MatrixNameTag")
		if oldTag then
			oldTag:Destroy()
		end

		local width = math.clamp(#TAG_TEXT * 24 + 50, 150, 320)
		local baseOffset = 2.6

		local fontSize = MAX_FONT_SIZE
		while fontSize > 12 and measure(TAG_TEXT, fontSize) > width - 10 do
			fontSize = fontSize - 2
		end
		local textW = measure(TAG_TEXT, fontSize)

		local billboard = Instance.new("BillboardGui")
		billboard.Name = "MatrixNameTag"
		billboard.Adornee = head
		billboard.Size = UDim2.new(0, width, 0, 62)
		billboard.StudsOffset = Vector3.new(0, baseOffset, 0)
		billboard.AlwaysOnTop = true
		billboard.LightInfluence = 0
		billboard.ClipsDescendants = false
		billboard.ZIndexBehavior = Enum.ZIndexBehavior.Global
		billboard.Parent = head

		local root = Instance.new("Frame")
		root.AnchorPoint = Vector2.new(0.5, 0.5)
		root.Position = UDim2.new(0.5, 0, 0.5, 0)
		root.Size = UDim2.new(1, 0, 1, 0)
		root.BackgroundTransparency = 1
		root.ClipsDescendants = false
		root.ZIndex = 1
		root.Parent = billboard

		local scale = Instance.new("UIScale")
		scale.Scale = 0.5
		scale.Parent = root

		local pill = Instance.new("Frame")
		pill.AnchorPoint = Vector2.new(0.5, 0.5)
		pill.Position = UDim2.new(0.5, 0, 0, LABEL_H / 2)
		pill.Size = UDim2.new(0, math.min(width, textW + 40), 0, LABEL_H - 4)
		pill.BackgroundColor3 = Color3.new(0, 0, 0)
		pill.BackgroundTransparency = 1
		pill.BorderSizePixel = 0
		pill.ZIndex = 1
		pill.Parent = root
		local pillCorner = Instance.new("UICorner")
		pillCorner.CornerRadius = UDim.new(0, 10)
		pillCorner.Parent = pill
		local pillStroke = Instance.new("UIStroke")
		pillStroke.Color = GREEN
		pillStroke.Thickness = 1.5
		pillStroke.Transparency = 1
		pillStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		pillStroke.Parent = pill

		local ghostA = makeLabel(root, 2, fontSize)
		ghostA.TextColor3 = GLITCH_A
		ghostA.TextTransparency = 1
		local ghostB = makeLabel(root, 2, fontSize)
		ghostB.TextColor3 = GLITCH_B
		ghostB.TextTransparency = 1

		local base = makeLabel(root, 3, fontSize)
		local chrome = Instance.new("UIGradient")
		chrome.Rotation = 90
		chrome.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(170, 255, 190)),
			ColorSequenceKeypoint.new(0.3, Color3.fromRGB(0, 255, 65)),
			ColorSequenceKeypoint.new(0.47, Color3.fromRGB(0, 150, 40)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 25, 8)),
			ColorSequenceKeypoint.new(0.58, Color3.fromRGB(0, 110, 30)),
			ColorSequenceKeypoint.new(0.78, Color3.fromRGB(0, 220, 55)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 255, 150)),
		})
		chrome.Parent = base

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.new(1, 1, 1)
		stroke.Thickness = 2
		stroke.LineJoinMode = Enum.LineJoinMode.Round
		stroke.Parent = base
		local strokeGradient = Instance.new("UIGradient")
		strokeGradient.Parent = stroke

		local scan = makeLabel(root, 7, fontSize)
		scan.TextColor3 = SCAN_COLOR
		local scanGradient = Instance.new("UIGradient")
		scanGradient.Rotation = 90
		scanGradient.Transparency = bandSeq(-999, SCAN_BAND, SCAN_ALPHA)
		scanGradient.Parent = scan

		local shine = makeLabel(root, 8, fontSize)
		shine.TextColor3 = SHINE
		local shineGradient = Instance.new("UIGradient")
		shineGradient.Parent = shine

		local underline = Instance.new("Frame")
		underline.Position = UDim2.new(0.1, 0, 0, 53)
		underline.Size = UDim2.new(0.8, 0, 0, 3)
		underline.BackgroundColor3 = GREEN
		underline.BorderSizePixel = 0
		underline.ZIndex = 3
		underline.Parent = root
		local lineCorner = Instance.new("UICorner")
		lineCorner.CornerRadius = UDim.new(1, 0)
		lineCorner.Parent = underline
		local lineGradient = Instance.new("UIGradient")
		lineGradient.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.2, 0),
			NumberSequenceKeypoint.new(0.8, 0),
			NumberSequenceKeypoint.new(1, 1),
		})
		lineGradient.Parent = underline

		local sparkles = {}
		local startX = (width - textW) / 2
		local function placeSparkle(sp, t)
			sp.holder.Position = UDim2.new(0, startX + math.random() * textW, 0, 11 + math.random() * 22)
			sp.start = t + 0.3 + math.random() * 1.7
			sp.life = 0.5 + math.random() * 0.4
			sp.size = 0.7 + math.random() * 0.5
			sp.holder.Visible = false
		end

		base.TextTransparency = 1
		shine.TextTransparency = 1
		scan.TextTransparency = 1
		stroke.Transparency = 1
		underline.BackgroundTransparency = 1

		local mains = { base, scan, shine }

		S.Tag = billboard
		local startTime = os.clock()
		local faded = false
		local glitching = false
		local glitchEnd = 0
		local nextGlitch = startTime + FADE_TIME + GLITCH_MIN + math.random() * (GLITCH_MAX - GLITCH_MIN)

		for i = 1, SPARKLE_COUNT do
			local sp = makeSparkle(root)
			placeSparkle(sp, startTime + FADE_TIME)
			sparkles[i] = sp
		end

		local function setMainOffset(dx, dy)
			for _, l in ipairs(mains) do
				l.Position = UDim2.new(0, dx, 0, dy)
			end
		end

		S.Anim = RunService.RenderStepped:Connect(function()
			local t = os.clock()
			local elapsed = t - startTime

			local s = (t * sweepSpeed) % spacing
			local centers = {}
			local c = from + s
			while c - half < 1 do
				centers[#centers + 1] = c
				c = c + spacing
			end
			shineGradient.Transparency = alphaSeq(centers)
			strokeGradient.Color = colorSeq(centers, EDGE_BASE, EDGE_PEAK)
			lineGradient.Color = colorSeq(centers, LINE_BASE, LINE_PEAK)

			billboard.StudsOffset = Vector3.new(0, baseOffset + math.sin(t * 2) * FLOAT_AMPLITUDE, 0)

			local pop = math.clamp(elapsed / POP_TIME, 0, 1)
			scale.Scale = 0.5 + 0.5 * easeOutBack(pop)

			if not faded then
				local fade = math.clamp(elapsed / FADE_TIME, 0, 1)
				local a = 1 - fade
				base.TextTransparency = a
				shine.TextTransparency = a
				scan.TextTransparency = a
				stroke.Transparency = a
				underline.BackgroundTransparency = a
				pill.BackgroundTransparency = 0.35 + 0.65 * a
				pillStroke.Transparency = 0.5 + 0.5 * a
				if fade >= 1 then
					faded = true
				end
			end

			local p = (t % SCAN_PERIOD) / SCAN_TRAVEL
			local scanPos = -999
			if p <= 1 then
				scanPos = SCAN_TOP + (SCAN_BOTTOM - SCAN_TOP) * p
			end
			scanGradient.Transparency = bandSeq(scanPos, SCAN_BAND, SCAN_ALPHA)

			if faded then
				for _, sp in ipairs(sparkles) do
					local k = (t - sp.start) / sp.life
					if k >= 1 then
						placeSparkle(sp, t)
					elseif k >= 0 then
						sp.holder.Visible = true
						sp.scale.Scale = math.max(math.sin(k * math.pi) * sp.size, 0.01)
						sp.holder.Rotation = k * 90
					end
				end

				if not glitching and t >= nextGlitch then
					glitching = true
					glitchEnd = t + GLITCH_TIME
				end
				if glitching then
					if t >= glitchEnd then
						glitching = false
						nextGlitch = t + GLITCH_MIN + math.random() * (GLITCH_MAX - GLITCH_MIN)
						setMainOffset(0, 0)
						ghostA.Position = UDim2.new(0, 0, 0, 0)
						ghostB.Position = UDim2.new(0, 0, 0, 0)
						ghostA.TextTransparency = 1
						ghostB.TextTransparency = 1
					else
						local sx = (math.random() * 2 - 1) * GLITCH_SHIFT
						local sy = (math.random() * 2 - 1) * (GLITCH_SHIFT * 0.4)
						setMainOffset(sx * 0.3, 0)
						ghostA.Position = UDim2.new(0, -sx - GLITCH_SHIFT * 0.5, 0, sy)
						ghostB.Position = UDim2.new(0, sx + GLITCH_SHIFT * 0.5, 0, -sy)
						ghostA.TextTransparency = 0.45 + math.random() * 0.25
						ghostB.TextTransparency = 0.4 + math.random() * 0.25
					end
				end
			end
		end)
	end

	local function ensureTag()
		if not S.Enabled then
			return
		end
		local char = LocalPlayer.Character
		local head = char and char:FindFirstChild("Head")
		if not head then
			return
		end
		if S.Tag and S.Tag.Parent and S.Tag.Adornee == head then
			return
		end
		build(head)
	end

	return function(state)
		if state == S.Enabled then
			return
		end
		S.Enabled = state
		S.Token += 1
		local token = S.Token

		if state then
			S.CharConn = LocalPlayer.CharacterAdded:Connect(function(char)
				task.spawn(function()
					char:WaitForChild("Head", 10)
					ensureTag()
				end)
			end)
			task.spawn(function()
				while S.Enabled and S.Token == token do
					pcall(ensureTag)
					task.wait(0.5)
				end
			end)
		else
			if S.CharConn then
				S.CharConn:Disconnect()
				S.CharConn = nil
			end
			destroyTag()
		end
	end
end)()

local function unload()
	hitbox.Enabled = false
	restoreHitboxes()
	noclip = false
	restoreNoclip()
	infJump = false
	esp.Enabled = false
	for player in pairs(esp.Objects) do
		removeESP(player)
	end
	setMachineESP(false)
	setInstant(false)
	setKey(false)
	setNameTag(false)
	residences.Token += 1
	speed.Lock = false
	if speedConn then
		speedConn:Disconnect()
	end
	local hum = getHumanoid()
	if hum then
		hum.WalkSpeed = speed.Base
	end
	if _G.MatrixUICleanup == unload then
		_G.MatrixUICleanup = nil
	end
	gui:Destroy()
end

_G.MatrixUICleanup = unload

addToggle(pages["Settings"], "Instant Prompts", true, function(state)
	setInstant(state)
end)
setInstant(true)

addToggle(pages["Settings"], "Key", true, function(state)
	setKey(state)
end)
setKey(true)

addToggle(pages["Settings"], "Name Tag", false, function(state)
	setNameTag(state)
end)

-- ===== Reduce Lag (Settings tab) - wrapped in a function to save local variables =====
task.spawn(function()
	local Lighting = game:GetService("Lighting")

	local lag = {
		Enabled = false,
		Token = 0,
		Added = nil,
		Saved = setmetatable({}, { __mode = "k" }), -- [instance] = { Prop = originalValue }
		Props = {}, -- { object, propertyName, originalValue }
	}

	local EFFECT_CLASSES = { "ParticleEmitter", "Trail", "Beam", "Smoke", "Fire", "Sparkles" }

	local function isEffect(inst)
		for _, className in ipairs(EFFECT_CLASSES) do
			if inst:IsA(className) then
				return true
			end
		end
		return false
	end

	-- skip player / NPC characters so avatars keep their look
	local function isCharacterPart(inst)
		local model = inst:FindFirstAncestorOfClass("Model")
		return model ~= nil and model:FindFirstChildOfClass("Humanoid") ~= nil
	end

	local function trySet(obj, prop, value)
		local ok, old = pcall(function()
			return obj[prop]
		end)
		if ok then
			lag.Props[#lag.Props + 1] = { obj, prop, old }
			pcall(function()
				obj[prop] = value
			end)
		end
	end

	local function apply(inst)
		if lag.Saved[inst] then
			return
		end
		if inst:IsA("BasePart") then
			if inst:IsA("Terrain") or isCharacterPart(inst) then
				return
			end
			lag.Saved[inst] = {
				Material = inst.Material,
				Reflectance = inst.Reflectance,
				CastShadow = inst.CastShadow,
			}
			inst.Material = Enum.Material.Plastic
			inst.Reflectance = 0
			inst.CastShadow = false
		elseif isEffect(inst) then
			lag.Saved[inst] = { Enabled = inst.Enabled }
			inst.Enabled = false
		end
	end

	local function restoreAll()
		for inst, saved in pairs(lag.Saved) do
			lag.Saved[inst] = nil
			if inst.Parent then
				for prop, value in pairs(saved) do
					pcall(function()
						inst[prop] = value
					end)
				end
			end
		end
		for _, p in ipairs(lag.Props) do
			pcall(function()
				p[1][p[2]] = p[3]
			end)
		end
		lag.Props = {}
	end

	local function setLag(state)
		if state == lag.Enabled then
			return
		end
		lag.Enabled = state
		lag.Token += 1
		local token = lag.Token

		if state then
			-- global render settings
			pcall(function()
				trySet(settings().Rendering, "QualityLevel", Enum.QualityLevel.Level01)
			end)
			trySet(Lighting, "GlobalShadows", false)

			-- post effects (bloom, blur, sun rays, etc.)
			for _, child in ipairs(Lighting:GetChildren()) do
				if child:IsA("PostEffect") then
					lag.Saved[child] = { Enabled = child.Enabled }
					child.Enabled = false
				end
			end

			-- terrain water / grass decoration
			local terrain = workspace:FindFirstChildOfClass("Terrain")
			if terrain then
				trySet(terrain, "Decoration", false)
				trySet(terrain, "WaterWaveSize", 0)
				trySet(terrain, "WaterWaveSpeed", 0)
				trySet(terrain, "WaterReflectance", 0)
			end

			-- new objects that spawn while enabled
			lag.Added = workspace.DescendantAdded:Connect(function(obj)
				if lag.Enabled then
					pcall(apply, obj)
				end
			end)

			-- existing parts / particles (chunked so it doesn't freeze)
			task.spawn(function()
				local count = 0
				for _, obj in ipairs(workspace:GetDescendants()) do
					if lag.Token ~= token or not lag.Enabled then
						return
					end
					pcall(apply, obj)
					count += 1
					if count % 1500 == 0 then
						task.wait()
					end
				end
			end)
		else
			if lag.Added then
				lag.Added:Disconnect()
				lag.Added = nil
			end
			restoreAll()
		end
	end

	addToggle(pages["Settings"], "Reduce Lag", false, function(state)
		setLag(state)
	end)

	gui.Destroying:Connect(function()
		setLag(false)
	end)
end)

addButton(pages["Settings"], "Unload Script", unload)

local okLoad, errLoad = pcall(loadResidences)
if not okLoad then
	setResidenceInfo("Load error: " .. string.sub(tostring(errLoad), 1, 80))
end

(function()
	local sound = Instance.new("Sound")
	sound.Name = "ClickSound"
	sound.SoundId = "rbxassetid://4307186075"
	sound.Volume = 1
	sound.Parent = gui

	local hooked = setmetatable({}, { __mode = "k" })

	local function hook(obj)
		if obj:IsA("GuiButton") and not hooked[obj] then
			hooked[obj] = true
			obj.MouseButton1Click:Connect(function()
				sound.TimePosition = 0
				sound:Play()
			end)
		end
	end

	for _, obj in ipairs(gui:GetDescendants()) do
		hook(obj)
	end

	gui.DescendantAdded:Connect(hook)
end)()

selectTab(1, false)
