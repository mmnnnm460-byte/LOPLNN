--[[
	Virtual Keyboard Panel v6 | Delta / Brookhaven RP

	New in v6:
	- Outfit button on every player: choose the original avatar or the in-map look,
	  see every item with picture + name (clothes, accessories, body parts, poses, skin color),
	  tap one to wear it (tries the wear commands until one works) or wear everything

	v5 features:
	- Players tab: live list (join / leave), picture + name + @username, teleport and spectate,
	  spectate bar with prev / next, tap a picture to preview the original avatar or the
	  in-map character (full body, rotating)
	- Setting: close the panel after teleport / spectate

	v4 features:
	- Settings page: click sound on/off + volume, panel size, accent color,
	  native phone keyboard on/off, auto-close after send, clear after send, reset
	- Saved texts page: save the current text, tap to reuse it, delete it
	- Extra keyboard page "تشكيل": tatweel, harakat, Arabic digits, extra letters
	- Character counter (+ optional per-command limit in Config.MaxLength)
	- Remembers settings, saved texts and positions between sessions (needs writefile/readfile)
	- UI stays inside the screen, click sound on every button (from v3)

	Sections: Services > Config > Persistence > Theme > Helpers > GUI > Panel
	          > Input > Tabs > Keyboard > Pages (Settings / Saved) > Send > Toggle > Init
]]

----------------------------------------------------------------
-- Services
----------------------------------------------------------------
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local ContentProvider = game:GetService("ContentProvider")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

----------------------------------------------------------------
-- Config (edit freely)
----------------------------------------------------------------
local Config = {
	SaveFile = "VirtualKeyboard_v4.json",
	ScreenMargin = 6, -- min gap (px) between the UI and the screen edge
	DeleteRepeatDelay = 0.4, -- seconds before backspace starts repeating
	DeleteRepeatRate = 0.05, -- seconds between repeats
	ClickSoundId = "8816939097",
	ClickPoolSize = 4, -- lets fast taps overlap instead of cutting each other off
	MaxSaved = 15, -- max saved texts
	HideDefaultAnimations = true, -- hide Roblox's built-in animations from the poses list

	-- Commands tried (in order) until one of them changes your character.
	-- kinds = which items it is for (shirt / pants / other); no kinds = every item.
	-- needsType = only runs when the item's asset type is known.
	-- (356 is the number from your Wear example; edit / add lines if the game uses other commands)
	WearAttempts = {
		{ remote = "WearShirt", kinds = { shirt = true }, args = function(item) return { item.id } end },
		{ remote = "WearPants", kinds = { pants = true }, args = function(item) return { item.id } end },
		{ remote = "WearBundle", args = function(item) return { item.id } end },
		{ remote = "Wear", args = function(item) return { item.id, 356 } end },
		{ remote = "Wear", args = function(item) return { item.id } end },
		{ remote = "Wear", needsType = true, args = function(item) return { item.id, item.assetTypeId } end },
	},

	-- Max characters per command. 0 = unlimited. Example: RolePlayName = 20
	MaxLength = {
		RolePlayName = 0,
		RolePlayBio = 0,
		Sign = 0,
	},
}

-- Default values of the options saved from the Settings page
local Defaults = {
	ClickSoundEnabled = true,
	ClickVolume = 0.7,
	PanelScale = 1,
	AccentIndex = 1,
	AllowSystemKeyboard = true,
	AutoCloseOnSend = false,
	ClearAfterSend = false,
	SelectedCommand = "RolePlayName",
	AutoCloseOnAction = true,
}

local Accents = {
	{ name = "Blurple", color = Color3.fromRGB(88, 101, 242) },
	{ name = "Green", color = Color3.fromRGB(46, 184, 114) },
	{ name = "Pink", color = Color3.fromRGB(236, 86, 160) },
	{ name = "Orange", color = Color3.fromRGB(245, 140, 50) },
	{ name = "Cyan", color = Color3.fromRGB(40, 176, 220) },
}

----------------------------------------------------------------
-- Persistence (writefile / readfile, optional)
----------------------------------------------------------------
local function readStore()
	if typeof(isfile) ~= "function" or typeof(readfile) ~= "function" then
		return {}
	end
	local ok, data = pcall(function()
		if isfile(Config.SaveFile) then
			return HttpService:JSONDecode(readfile(Config.SaveFile))
		end
		return nil
	end)
	if ok and type(data) == "table" then
		return data
	end
	return {}
end

local Store = readStore()
if type(Store.positions) ~= "table" then
	Store.positions = {}
end

local cleanSaved = {}
if type(Store.saved) == "table" then
	for _, value in ipairs(Store.saved) do
		if type(value) == "string" and value ~= "" then
			table.insert(cleanSaved, value)
		end
	end
end
Store.saved = cleanSaved

local storedSettings = type(Store.settings) == "table" and Store.settings or {}
local Settings = {}
for key, default in pairs(Defaults) do
	local value = storedSettings[key]
	if type(value) == type(default) then
		Settings[key] = value
	else
		Settings[key] = default
	end
end
Settings.AccentIndex = math.clamp(math.floor(Settings.AccentIndex), 1, #Accents)
Settings.ClickVolume = math.clamp(Settings.ClickVolume, 0, 1)
Settings.PanelScale = math.clamp(Settings.PanelScale, 0.7, 1.3)

local saveQueued = false
local function saveStore()
	if typeof(writefile) ~= "function" or saveQueued then
		return
	end
	saveQueued = true
	task.delay(0.5, function()
		saveQueued = false
		pcall(function()
			writefile(Config.SaveFile, HttpService:JSONEncode({
				settings = Settings,
				saved = Store.saved,
				positions = Store.positions,
			}))
		end)
	end)
end

local function posToTable(pos)
	return { pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset }
end

local function posFromTable(t, fallback)
	if type(t) == "table"
		and type(t[1]) == "number" and type(t[2]) == "number"
		and type(t[3]) == "number" and type(t[4]) == "number" then
		return UDim2.new(t[1], t[2], t[3], t[4])
	end
	return fallback
end

----------------------------------------------------------------
-- Theme
----------------------------------------------------------------
local Theme = {
	Panel = Color3.fromRGB(32, 35, 50),
	Key = Color3.fromRGB(46, 50, 72),
	KeyAlt = Color3.fromRGB(62, 68, 98),
	Accent = Accents[1].color,
	AccentDark = Accents[1].color,
	Danger = Color3.fromRGB(226, 72, 88),
	DangerDark = Color3.fromRGB(184, 48, 64),
	Success = Color3.fromRGB(52, 190, 120),
	Stroke = Color3.fromRGB(70, 76, 105),
	Text = Color3.fromRGB(255, 255, 255),
	Muted = Color3.fromRGB(170, 176, 200),
}

local function setThemeAccent(index)
	local entry = Accents[index] or Accents[1]
	Theme.Accent = entry.color
	Theme.AccentDark = entry.color:Lerp(Color3.new(0, 0, 0), 0.25)
end
setThemeAccent(Settings.AccentIndex)

-- Anything that depends on the accent color / settings registers here (runs once immediately)
local themeListeners = {}

local function onTheme(fn)
	table.insert(themeListeners, fn)
	fn()
end

local function refreshTheme()
	for _, fn in ipairs(themeListeners) do
		local ok, err = pcall(fn)
		if not ok then
			warn("[VirtualKeyboard] " .. tostring(err))
		end
	end
end

----------------------------------------------------------------
-- Helpers
----------------------------------------------------------------
local connections = {}
local destroyCallbacks = {} -- functions that run when the GUI is destroyed

local function track(conn)
	table.insert(connections, conn)
	return conn
end

local function new(class, props, parent)
	local inst = Instance.new(class)
	for key, value in pairs(props or {}) do
		inst[key] = value
	end
	inst.Parent = parent
	return inst
end

local function round(inst, radius)
	return new("UICorner", { CornerRadius = UDim.new(0, radius) }, inst)
end

local function stroke(inst, color, thickness, transparency)
	return new("UIStroke", {
		Color = color,
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, inst)
end

local function isPress(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch
end

local function getGuiParent()
	if typeof(gethui) == "function" then
		local ok, ui = pcall(gethui)
		if ok and ui then
			return ui
		end
	end
	return LocalPlayer:WaitForChild("PlayerGui")
end

-- Click sound (small pool so rapid taps overlap)
local ClickPool = {}
local clickIndex = 0

for i = 1, Config.ClickPoolSize do
	ClickPool[i] = new("Sound", {
		Name = "VirtualKeyboardClick",
		SoundId = "rbxassetid://" .. Config.ClickSoundId,
		Volume = Settings.ClickVolume,
	}, SoundService)
end

task.spawn(function()
	pcall(function()
		ContentProvider:PreloadAsync({ ClickPool[1] })
	end)
end)

local function applyVolume()
	for _, sound in ipairs(ClickPool) do
		sound.Volume = Settings.ClickVolume
	end
end

local function playClick()
	if not Settings.ClickSoundEnabled then
		return
	end
	clickIndex = clickIndex % #ClickPool + 1
	local sound = ClickPool[clickIndex]
	sound.TimePosition = 0
	sound:Play()
end

-- Screen bounds
local ScreenGui -- assigned below

local function getScreenSize()
	local size = ScreenGui and ScreenGui.AbsoluteSize or Vector2.zero
	if size.X < 1 or size.Y < 1 then
		local cam = workspace.CurrentCamera
		return cam and cam.ViewportSize or Vector2.new(800, 600)
	end
	return size
end

local function clampAxis(value, lo, hi)
	if lo > hi then
		return (lo + hi) / 2 -- element is bigger than the screen: just center it
	end
	return math.clamp(value, lo, hi)
end

-- Returns `position` moved (if needed) so an element of `size` (with `anchor`) stays fully on screen
local function clampedPosition(position, anchor, size)
	local screen = getScreenSize()
	local margin = Config.ScreenMargin

	local x = position.X.Scale * screen.X + position.X.Offset
	local y = position.Y.Scale * screen.Y + position.Y.Offset

	x = clampAxis(x, anchor.X * size.X + margin, screen.X - (1 - anchor.X) * size.X - margin)
	y = clampAxis(y, anchor.Y * size.Y + margin, screen.Y - (1 - anchor.Y) * size.Y - margin)

	return UDim2.new(
		position.X.Scale, x - position.X.Scale * screen.X,
		position.Y.Scale, y - position.Y.Scale * screen.Y
	)
end

-- Mouse + touch dragging, kept inside the screen.
-- getSize() = element's on-screen size (Vector2). onEnd() runs after a real drag.
-- Returns state (state.moved = dragged, not tapped)
local function makeDraggable(handle, target, getSize, onEnd)
	local state = { moved = false }
	local dragging = false
	local dragStart, startPos

	track(handle.InputBegan:Connect(function(input)
		if isPress(input) then
			dragging = true
			state.moved = false
			dragStart = input.Position
			startPos = target.Position

			local conn
			conn = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					if conn then
						conn:Disconnect()
					end
					if state.moved and onEnd then
						onEnd()
					end
				end
			end)
		end
	end))

	track(UserInputService.InputChanged:Connect(function(input)
		if not dragging then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
			local delta = input.Position - dragStart
			if not state.moved and delta.Magnitude < 8 then
				return
			end
			state.moved = true
			local wanted = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
			target.Position = clampedPosition(wanted, target.AnchorPoint, getSize())
		end
	end))

	return state
end

-- Press animation (color + tiny scale) + click sound.
-- onDown fires instantly on touch/click start, onUp on release.
local function pressable(btn, baseColor, pressColor, onDown, onUp)
	local scale = new("UIScale", { Scale = 1 }, btn)
	local info = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	btn.AutoButtonColor = false

	local function setPressed(pressed)
		TweenService:Create(scale, info, { Scale = pressed and 0.92 or 1 }):Play()
		TweenService:Create(btn, info, { BackgroundColor3 = pressed and pressColor or baseColor }):Play()
	end

	local function release()
		setPressed(false)
		if onUp then
			onUp()
		end
	end

	btn.InputBegan:Connect(function(input)
		if isPress(input) then
			setPressed(true)
			playClick()
			if onDown then
				onDown()
			end
		end
	end)
	btn.InputEnded:Connect(function(input)
		if isPress(input) then
			release()
		end
	end)
	btn.MouseLeave:Connect(release)
end

-- Places a key inside a row using scale (x0, width) with a 4px gap between keys
local function placeKey(btn, x0, width)
	btn.AnchorPoint = Vector2.new(0.5, 0.5)
	btn.Position = UDim2.new(x0 + width / 2, 0, 0.5, 0)
	btn.Size = UDim2.new(width, -4, 1, 0)
end

local function textLength(str)
	return utf8.len(str) or #str
end

-- Forward declarations (assigned later)
local reclamp, applyPanelSize, setOpen, showPage, renderSaved, updateCounter
local isOpen = true
local currentPage = "keyboard"

----------------------------------------------------------------
-- ScreenGui
----------------------------------------------------------------
local guiParent = getGuiParent()

local oldGui = guiParent:FindFirstChild("VirtualKeyboardUI")
if oldGui then
	oldGui:Destroy()
end

ScreenGui = new("ScreenGui", {
	Name = "VirtualKeyboardUI",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	DisplayOrder = 999,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

if syn and syn.protect_gui then
	pcall(syn.protect_gui, ScreenGui)
end
ScreenGui.Parent = guiParent

ScreenGui.Destroying:Connect(function()
	for _, fn in ipairs(destroyCallbacks) do
		pcall(fn)
	end
	for _, conn in ipairs(connections) do
		conn:Disconnect()
	end
	for _, sound in ipairs(ClickPool) do
		sound:Destroy()
	end
end)

----------------------------------------------------------------
-- Panel
----------------------------------------------------------------
local DEFAULT_PANEL_POS = UDim2.fromScale(0.5, 0.5)
local DEFAULT_TOGGLE_POS = UDim2.new(1, -16, 0.5, 0)

local panelWidth, panelHeight

local function computePanelSize()
	local cam = workspace.CurrentCamera
	local viewport = cam and cam.ViewportSize or Vector2.new(800, 600)
	panelWidth = math.clamp(viewport.X * 0.94 / Settings.PanelScale, 300, 480)
	panelHeight = math.clamp(viewport.Y * 0.90 / Settings.PanelScale, 250, 330)
end
computePanelSize()

local function getPanelSize()
	return Vector2.new(panelWidth, panelHeight) * Settings.PanelScale
end

local MainFrame = new("Frame", {
	Name = "MainFrame",
	Size = UDim2.fromOffset(panelWidth, panelHeight),
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = posFromTable(Store.positions.panel, DEFAULT_PANEL_POS),
	BackgroundColor3 = Color3.new(1, 1, 1),
	BorderSizePixel = 0,
	Active = true,
}, ScreenGui)
round(MainFrame, 16)
stroke(MainFrame, Theme.Stroke, 2)
new("UIGradient", {
	Color = ColorSequence.new(Color3.fromRGB(34, 37, 54), Color3.fromRGB(19, 21, 30)),
	Rotation = 90,
}, MainFrame)
local MainScale = new("UIScale", { Scale = Settings.PanelScale }, MainFrame)

-- Title bar (drag handle + page buttons)
local TitleBar = new("Frame", {
	Name = "TitleBar",
	Size = UDim2.new(1, 0, 0, 38),
	BackgroundTransparency = 1,
	Active = true,
}, MainFrame)

local Dot = new("Frame", {
	Size = UDim2.fromOffset(8, 8),
	Position = UDim2.new(0, 16, 0.5, -4),
	BackgroundColor3 = Theme.Accent,
	BorderSizePixel = 0,
}, TitleBar)
round(Dot, 4)
onTheme(function()
	Dot.BackgroundColor3 = Theme.Accent
end)

new("TextLabel", {
	Size = UDim2.new(1, -208, 1, 0),
	Position = UDim2.fromOffset(32, 0),
	BackgroundTransparency = 1,
	Text = "Keyboard",
	TextColor3 = Theme.Text,
	TextSize = 14,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextTruncate = Enum.TextTruncate.AtEnd,
}, TitleBar)

local function makePill(text, xOffset)
	local pill = new("TextButton", {
		Size = UDim2.fromOffset(52, 24),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, xOffset, 0.5, 0),
		BackgroundColor3 = Theme.Key,
		Text = text,
		TextColor3 = Theme.Muted,
		TextSize = 11,
		Font = Enum.Font.GothamBold,
		BorderSizePixel = 0,
	}, TitleBar)
	round(pill, 12)
	return pill
end

local SavedPill = makePill("محفوظات", -122)
local PlayersPill = makePill("لاعبين", -66)
local SettingsPill = makePill("إعدادات", -10)

local function refreshPills()
	local savedOn = currentPage == "saved"
	local settingsOn = currentPage == "settings"
	local playersOn = currentPage == "players"
	SavedPill.BackgroundColor3 = savedOn and Theme.Accent or Theme.Key
	SavedPill.TextColor3 = savedOn and Theme.Text or Theme.Muted
	SettingsPill.BackgroundColor3 = settingsOn and Theme.Accent or Theme.Key
	SettingsPill.TextColor3 = settingsOn and Theme.Text or Theme.Muted
	PlayersPill.BackgroundColor3 = playersOn and Theme.Accent or Theme.Key
	PlayersPill.TextColor3 = playersOn and Theme.Text or Theme.Muted
end
onTheme(refreshPills)

new("Frame", {
	Size = UDim2.new(1, -24, 0, 1),
	Position = UDim2.new(0, 12, 1, -1),
	BackgroundColor3 = Theme.Stroke,
	BackgroundTransparency = 0.4,
	BorderSizePixel = 0,
}, TitleBar)

makeDraggable(TitleBar, MainFrame, getPanelSize, function()
	Store.positions.panel = posToTable(MainFrame.Position)
	saveStore()
end)

-- Page: keyboard (default)
local Content = new("Frame", {
	Name = "Content",
	Size = UDim2.new(1, 0, 1, -38),
	Position = UDim2.fromOffset(0, 38),
	BackgroundTransparency = 1,
}, MainFrame)
new("UIPadding", {
	PaddingTop = UDim.new(0, 10),
	PaddingBottom = UDim.new(0, 12),
	PaddingLeft = UDim.new(0, 12),
	PaddingRight = UDim.new(0, 12),
}, Content)
new("UIListLayout", {
	Padding = UDim.new(0, 8),
	SortOrder = Enum.SortOrder.LayoutOrder,
	HorizontalAlignment = Enum.HorizontalAlignment.Center,
}, Content)

-- Builds an empty page (same area as Content) for Settings / Saved
local function makePage(name)
	local page = new("Frame", {
		Name = name,
		Size = UDim2.new(1, 0, 1, -38),
		Position = UDim2.fromOffset(0, 38),
		BackgroundTransparency = 1,
		Visible = false,
	}, MainFrame)
	new("UIPadding", {
		PaddingTop = UDim.new(0, 10),
		PaddingBottom = UDim.new(0, 12),
		PaddingLeft = UDim.new(0, 12),
		PaddingRight = UDim.new(0, 12),
	}, page)
	return page
end

----------------------------------------------------------------
-- Input row: TextBox + counter + Clear + Send
----------------------------------------------------------------
local InputRow = new("Frame", {
	Name = "InputRow",
	Size = UDim2.new(1, 0, 0, 42),
	BackgroundTransparency = 1,
	LayoutOrder = 1,
}, Content)

local TextBox = new("TextBox", {
	Name = "OutputDisplay",
	Size = UDim2.new(1, -134, 1, 0),
	BackgroundColor3 = Theme.Panel,
	TextColor3 = Theme.Text,
	PlaceholderColor3 = Theme.Muted,
	PlaceholderText = "",
	Text = "",
	TextSize = 16,
	Font = Enum.Font.Gotham,
	ClearTextOnFocus = false,
	TextEditable = Settings.AllowSystemKeyboard,
	TextXAlignment = Enum.TextXAlignment.Right,
	ClipsDescendants = true,
	BorderSizePixel = 0,
}, InputRow)
round(TextBox, 10)
stroke(TextBox, Theme.Stroke, 1.5)
new("UIPadding", {
	PaddingLeft = UDim.new(0, 46),
	PaddingRight = UDim.new(0, 10),
}, TextBox)

local Counter = new("TextLabel", {
	Size = UDim2.fromOffset(40, 14),
	AnchorPoint = Vector2.new(0, 1),
	Position = UDim2.new(0, 10, 1, -4),
	BackgroundTransparency = 1,
	Text = "0",
	TextColor3 = Theme.Muted,
	TextSize = 11,
	Font = Enum.Font.GothamMedium,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 3,
}, InputRow)

local ClearButton = new("TextButton", {
	Name = "ClearBtn",
	Size = UDim2.new(0, 40, 1, 0),
	Position = UDim2.new(1, -126, 0, 0),
	BackgroundColor3 = Theme.KeyAlt,
	Text = "مسح",
	TextColor3 = Theme.Text,
	TextSize = 13,
	Font = Enum.Font.GothamBold,
	BorderSizePixel = 0,
}, InputRow)
round(ClearButton, 10)

local sendBusy = false -- true while the Send button shows a result

local SendButton = new("TextButton", {
	Name = "SendBtn",
	Size = UDim2.new(0, 80, 1, 0),
	Position = UDim2.new(1, -80, 0, 0),
	BackgroundColor3 = Theme.Accent,
	Text = "إرسال",
	TextColor3 = Theme.Text,
	TextSize = 15,
	Font = Enum.Font.GothamBold,
	BorderSizePixel = 0,
}, InputRow)
round(SendButton, 10)
onTheme(function()
	if not sendBusy then
		SendButton.BackgroundColor3 = Theme.Accent
	end
end)

----------------------------------------------------------------
-- Command tabs
----------------------------------------------------------------
local Commands = {
	{ id = "RolePlayName", label = "اسم الرول", hint = "اكتب اسم الرول..." },
	{ id = "RolePlayBio", label = "البايو", hint = "اكتب البايو..." },
	{ id = "Sign", label = "اللوحة (Sign)", hint = "اكتب نص اللوحة..." },
}

local function isValidCommand(id)
	for _, cmd in ipairs(Commands) do
		if cmd.id == id then
			return true
		end
	end
	return false
end
if not isValidCommand(Settings.SelectedCommand) then
	Settings.SelectedCommand = Defaults.SelectedCommand
end

-- 4px wider than the content so the 2px key inset lines up flush with the other rows
local CmdRow = new("Frame", {
	Name = "CmdRow",
	Size = UDim2.new(1, 4, 0, 34),
	BackgroundTransparency = 1,
	LayoutOrder = 2,
}, Content)

local CmdButtons = {}

local function refreshCommands()
	for _, cmd in ipairs(Commands) do
		local btn = CmdButtons[cmd.id]
		local selected = cmd.id == Settings.SelectedCommand
		btn.BackgroundColor3 = selected and Theme.Accent or Theme.Key
		btn.TextColor3 = selected and Theme.Text or Theme.Muted
		btn.Font = selected and Enum.Font.GothamBold or Enum.Font.GothamMedium
		if selected then
			TextBox.PlaceholderText = cmd.hint
		end
	end
end

for i, cmd in ipairs(Commands) do
	local btn = new("TextButton", {
		Name = cmd.id,
		Text = cmd.label,
		TextSize = 14,
		BorderSizePixel = 0,
	}, CmdRow)
	round(btn, 8)
	placeKey(btn, (i - 1) / #Commands, 1 / #Commands)
	CmdButtons[cmd.id] = btn

	btn.MouseButton1Click:Connect(function()
		playClick()
		Settings.SelectedCommand = cmd.id
		refreshCommands()
		updateCounter()
		saveStore()
	end)
end
onTheme(refreshCommands)

----------------------------------------------------------------
-- Counter
----------------------------------------------------------------
function updateCounter()
	local limit = Config.MaxLength[Settings.SelectedCommand] or 0
	local length = textLength(TextBox.Text)
	if limit > 0 then
		Counter.Text = length .. "/" .. limit
	else
		Counter.Text = tostring(length)
	end
	Counter.TextColor3 = (limit > 0 and length > limit) and Theme.Danger or Theme.Muted
end

local function flashCounter()
	Counter.TextColor3 = Theme.Danger
	task.delay(0.3, updateCounter)
end

TextBox:GetPropertyChangedSignal("Text"):Connect(updateCounter)
updateCounter()

----------------------------------------------------------------
-- Keyboard layouts
----------------------------------------------------------------
local function u(code)
	return utf8.char(code)
end

local TATWEEL = u(0x0640)

-- Key entry = string, or { label, value } (label shown on the key, value typed)
local function mark(code)
	local m = u(code)
	return { TATWEEL .. m, m }
end

local arabicDigits = {}
for i = 0, 9 do
	table.insert(arabicDigits, u(0x0660 + i))
end

local Keyboards = {
	AR = {
		{ "ض", "ص", "ث", "ق", "ف", "غ", "ع", "ه", "خ", "ح", "ج", "د" },
		{ "ش", "س", "ي", "ب", "ل", "ا", "ت", "ن", "م", "ك", "ط", "ذ" },
		{ "ئ", "ء", "ؤ", "ر", "لا", "ى", "ة", "و", "ز", "ظ", "أ", "إ" },
	},
	EN = {
		{ "q", "w", "e", "r", "t", "y", "u", "i", "o", "p" },
		{ "a", "s", "d", "f", "g", "h", "j", "k", "l" },
		{ "z", "x", "c", "v", "b", "n", "m" },
	},
	NUM = {
		{ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" },
		{ "!", "@", "#", "$", "%", "^", "&", "*", "(", ")" },
		{ "-", "_", "=", "+", "،", "؟", ".", ",", ":", ";" },
	},
	TSH = {
		{
			{ TATWEEL, TATWEEL },
			mark(0x064B), mark(0x064C), mark(0x064D), mark(0x064E), mark(0x064F),
			mark(0x0650), mark(0x0651), mark(0x0652), mark(0x0670),
		},
		arabicDigits,
		{ u(0x067E), u(0x0686), u(0x0698), u(0x06AF), u(0x06A4), u(0x061B), u(0x00AB), u(0x00BB) },
	},
}

local NextMode = { AR = "EN", EN = "NUM", NUM = "TSH", TSH = "AR" }
local ModeLabel = { AR = "عربي", EN = "EN", NUM = "123", TSH = "تشكيل" }

local CurrentMode = "AR"
local Shift = false

local KeysFrame = new("Frame", {
	Name = "KeysFrame",
	Size = UDim2.new(1, 4, 1, -92),
	BackgroundTransparency = 1,
	LayoutOrder = 3,
}, Content)
new("UIListLayout", {
	Padding = UDim.new(0, 6),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, KeysFrame)

----------------------------------------------------------------
-- Text editing
----------------------------------------------------------------
local function typeText(str)
	local limit = Config.MaxLength[Settings.SelectedCommand] or 0
	if limit > 0 and textLength(TextBox.Text) + textLength(str) > limit then
		flashCounter()
		return
	end
	TextBox.Text = TextBox.Text .. str
end

-- UTF-8 safe: removes one full character (Arabic letters are 2 bytes)
local function deleteLastChar()
	local text = TextBox.Text
	if text == "" then
		return
	end
	local ok, offset = pcall(utf8.offset, text, -1)
	if ok and offset then
		TextBox.Text = string.sub(text, 1, offset - 1)
	else
		TextBox.Text = string.sub(text, 1, -2)
	end
end

local holdToken = 0

local function stopHold()
	holdToken += 1
end

local function startHold()
	holdToken += 1
	local token = holdToken
	deleteLastChar()
	task.spawn(function()
		task.wait(Config.DeleteRepeatDelay)
		while token == holdToken do
			deleteLastChar()
			task.wait(Config.DeleteRepeatRate)
		end
	end)
end

----------------------------------------------------------------
-- Render keyboard
----------------------------------------------------------------
local function RenderKeyboard()
	stopHold()

	for _, child in ipairs(KeysFrame:GetChildren()) do
		if child:IsA("GuiObject") then
			child:Destroy()
		end
	end

	-- Letter rows
	for rowIndex, row in ipairs(Keyboards[CurrentMode]) do
		local rowFrame = new("Frame", {
			Name = "Row" .. rowIndex,
			Size = UDim2.new(1, 0, 0.25, -5),
			BackgroundTransparency = 1,
			LayoutOrder = rowIndex,
		}, KeysFrame)

		local keyWidth = 1 / #row
		for j, entry in ipairs(row) do
			local label, value = entry, entry
			if type(entry) == "table" then
				label, value = entry[1], entry[2]
			elseif CurrentMode == "EN" and Shift then
				label = string.upper(entry)
				value = label
			end

			local key = new("TextButton", {
				Name = "Key",
				BackgroundColor3 = Theme.Key,
				Text = label,
				TextColor3 = Theme.Text,
				Font = Enum.Font.GothamMedium,
				TextSize = 18,
				BorderSizePixel = 0,
			}, rowFrame)
			round(key, 8)
			placeKey(key, (j - 1) * keyWidth, keyWidth)

			-- types instantly on touch-down (+ click sound from pressable)
			pressable(key, Theme.Key, Theme.Accent, function()
				typeText(value)
			end)
		end
	end

	-- Bottom row
	local bottom = new("Frame", {
		Name = "BottomRow",
		Size = UDim2.new(1, 0, 0.25, -5),
		BackgroundTransparency = 1,
		LayoutOrder = 4,
	}, KeysFrame)

	local items
	if CurrentMode == "EN" then
		items = { { "mode", 0.2 }, { "shift", 0.15 }, { "space", 0.4 }, { "del", 0.25 } }
	else
		items = { { "mode", 0.25 }, { "space", 0.5 }, { "del", 0.25 } }
	end

	local x = 0
	for _, item in ipairs(items) do
		local kind, weight = item[1], item[2]

		local btn = new("TextButton", {
			Name = kind,
			BackgroundColor3 = Theme.KeyAlt,
			TextColor3 = Theme.Text,
			Font = Enum.Font.GothamBold,
			TextSize = 14,
			BorderSizePixel = 0,
		}, bottom)
		round(btn, 8)
		placeKey(btn, x, weight)
		x += weight

		if kind == "mode" then
			btn.Text = ModeLabel[NextMode[CurrentMode]]
			pressable(btn, Theme.KeyAlt, Theme.Accent)
			btn.MouseButton1Click:Connect(function()
				CurrentMode = NextMode[CurrentMode]
				if CurrentMode == "AR" then
					TextBox.TextXAlignment = Enum.TextXAlignment.Right
				elseif CurrentMode == "EN" then
					TextBox.TextXAlignment = Enum.TextXAlignment.Left
				end
				RenderKeyboard()
			end)

		elseif kind == "shift" then
			btn.Text = "Aa"
			btn.BackgroundColor3 = Shift and Theme.Accent or Theme.KeyAlt
			pressable(
				btn,
				Shift and Theme.Accent or Theme.KeyAlt,
				Shift and Theme.AccentDark or Theme.Accent
			)
			btn.MouseButton1Click:Connect(function()
				Shift = not Shift
				RenderKeyboard()
			end)

		elseif kind == "space" then
			btn.Text = "مسافة"
			btn.BackgroundColor3 = Theme.Key
			btn.TextColor3 = Theme.Muted
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 13
			pressable(btn, Theme.Key, Theme.Accent, function()
				typeText(" ")
			end)

		elseif kind == "del" then
			btn.Text = "حذف"
			btn.BackgroundColor3 = Theme.Danger
			pressable(btn, Theme.Danger, Theme.DangerDark, startHold, stopHold)
		end
	end
end

onTheme(RenderKeyboard) -- re-renders when the accent color changes

----------------------------------------------------------------
-- Widgets for the Settings page
----------------------------------------------------------------
local function makeSwitch(row, key, onChange)
	local track = new("TextButton", {
		Size = UDim2.fromOffset(46, 24),
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 10, 0.5, 0),
		Text = "",
		AutoButtonColor = false,
		BorderSizePixel = 0,
	}, row)
	round(track, 12)

	local knob = new("Frame", {
		Size = UDim2.fromOffset(18, 18),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = Theme.Text,
		BorderSizePixel = 0,
	}, track)
	round(knob, 9)

	local function refresh(animate)
		local on = Settings[key]
		local pos = on and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
		local color = on and Theme.Accent or Theme.KeyAlt
		if animate then
			local info = TweenInfo.new(0.15, Enum.EasingStyle.Quad)
			TweenService:Create(knob, info, { Position = pos }):Play()
			TweenService:Create(track, info, { BackgroundColor3 = color }):Play()
		else
			knob.Position = pos
			track.BackgroundColor3 = color
		end
	end

	track.MouseButton1Click:Connect(function()
		playClick()
		Settings[key] = not Settings[key]
		refresh(true)
		if onChange then
			onChange(Settings[key])
		end
		saveStore()
	end)

	onTheme(function()
		refresh(false)
	end)
end

-- options = { {label=..., value=number}, ... }; selects the closest option to Settings[key]
local function makeSegmented(row, options, key, width, onChange)
	local holder = new("Frame", {
		Size = UDim2.fromOffset(width, 26),
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 10, 0.5, 0),
		BackgroundTransparency = 1,
	}, row)

	local buttons = {}

	local function nearestIndex()
		local best, bestDiff = 1, math.huge
		for i, opt in ipairs(options) do
			local diff = math.abs(opt.value - Settings[key])
			if diff < bestDiff then
				best, bestDiff = i, diff
			end
		end
		return best
	end

	local function refresh()
		local selected = nearestIndex()
		for i, btn in ipairs(buttons) do
			btn.BackgroundColor3 = (i == selected) and Theme.Accent or Theme.Key
			btn.TextColor3 = (i == selected) and Theme.Text or Theme.Muted
		end
	end

	for i, opt in ipairs(options) do
		local btn = new("TextButton", {
			Text = opt.label,
			TextSize = 11,
			Font = Enum.Font.GothamBold,
			BorderSizePixel = 0,
		}, holder)
		round(btn, 7)
		placeKey(btn, (i - 1) / #options, 1 / #options)
		buttons[i] = btn

		btn.MouseButton1Click:Connect(function()
			Settings[key] = opt.value
			if onChange then
				onChange(opt.value)
			end
			playClick()
			refresh()
			saveStore()
		end)
	end

	onTheme(refresh)
end

----------------------------------------------------------------
-- Page: Settings
----------------------------------------------------------------
local SettingsPage = makePage("SettingsPage")

local SettingsScroll = new("ScrollingFrame", {
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 3,
	ScrollBarImageColor3 = Theme.Stroke,
	CanvasSize = UDim2.new(),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	ScrollingDirection = Enum.ScrollingDirection.Y,
}, SettingsPage)
new("UIListLayout", {
	Padding = UDim.new(0, 6),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, SettingsScroll)
new("UIPadding", { PaddingRight = UDim.new(0, 6) }, SettingsScroll)

local settingsOrder = 0

local function addSettingRow(labelText)
	settingsOrder += 1
	local row = new("Frame", {
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundColor3 = Theme.Panel,
		BorderSizePixel = 0,
		LayoutOrder = settingsOrder,
	}, SettingsScroll)
	round(row, 10)
	new("TextLabel", {
		Size = UDim2.new(0.5, -12, 1, 0),
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -12, 0, 0),
		BackgroundTransparency = 1,
		Text = labelText,
		TextColor3 = Theme.Text,
		TextSize = 12,
		Font = Enum.Font.GothamMedium,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Right,
	}, row)
	return row
end

-- Click sound
makeSwitch(addSettingRow("صوت النقر"), "ClickSoundEnabled")

makeSegmented(addSettingRow("مستوى الصوت"), {
	{ label = "منخفض", value = 0.3 },
	{ label = "وسط", value = 0.7 },
	{ label = "عالي", value = 1 },
}, "ClickVolume", 120, function()
	applyVolume()
end)

-- Panel size
makeSegmented(addSettingRow("حجم الواجهة"), {
	{ label = "صغير", value = 0.85 },
	{ label = "وسط", value = 1 },
	{ label = "كبير", value = 1.15 },
}, "PanelScale", 120, function()
	applyPanelSize()
end)

-- Accent color
do
	local row = addSettingRow("اللون")
	local holder = new("Frame", {
		Size = UDim2.fromOffset(#Accents * 22 + (#Accents - 1) * 3, 22),
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 10, 0.5, 0),
		BackgroundTransparency = 1,
	}, row)
	new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = UDim.new(0, 3),
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	}, holder)

	local rings = {}
	for i, accent in ipairs(Accents) do
		local swatch = new("TextButton", {
			Size = UDim2.fromOffset(22, 22),
			BackgroundColor3 = accent.color,
			Text = "",
			AutoButtonColor = false,
			BorderSizePixel = 0,
			LayoutOrder = i,
		}, holder)
		round(swatch, 11)
		rings[i] = stroke(swatch, Theme.Text, 2, 1)

		swatch.MouseButton1Click:Connect(function()
			playClick()
			Settings.AccentIndex = i
			setThemeAccent(i)
			refreshTheme()
			saveStore()
		end)
	end

	onTheme(function()
		for i, ring in ipairs(rings) do
			ring.Transparency = (i == Settings.AccentIndex) and 0 or 1
		end
	end)
end

-- Behavior options
makeSwitch(addSettingRow("كيبورد الجوال الأصلي"), "AllowSystemKeyboard", function(value)
	TextBox.TextEditable = value
	if not value then
		TextBox:ReleaseFocus()
	end
end)

makeSwitch(addSettingRow("إغلاق الواجهة بعد الإرسال"), "AutoCloseOnSend")
makeSwitch(addSettingRow("مسح النص بعد الإرسال"), "ClearAfterSend")
makeSwitch(addSettingRow("إغلاق الواجهة بعد الانتقال/المراقبة"), "AutoCloseOnAction")

-- Reset button (wired at the end of the script)
settingsOrder += 1
local ResetButton = new("TextButton", {
	Size = UDim2.new(1, 0, 0, 38),
	BackgroundColor3 = Theme.DangerDark,
	Text = "إعادة الضبط",
	TextColor3 = Theme.Text,
	TextSize = 13,
	Font = Enum.Font.GothamBold,
	BorderSizePixel = 0,
	LayoutOrder = settingsOrder,
}, SettingsScroll)
round(ResetButton, 10)

----------------------------------------------------------------
-- Page: Saved texts
----------------------------------------------------------------
local SavedPage = makePage("SavedPage")

local SaveButton = new("TextButton", {
	Size = UDim2.new(1, 0, 0, 38),
	BackgroundColor3 = Theme.Accent,
	Text = "حفظ النص الحالي",
	TextColor3 = Theme.Text,
	TextSize = 14,
	Font = Enum.Font.GothamBold,
	BorderSizePixel = 0,
}, SavedPage)
round(SaveButton, 10)
onTheme(function()
	SaveButton.BackgroundColor3 = Theme.Accent
end)

local SavedScroll = new("ScrollingFrame", {
	Size = UDim2.new(1, 0, 1, -46),
	Position = UDim2.fromOffset(0, 46),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 3,
	ScrollBarImageColor3 = Theme.Stroke,
	CanvasSize = UDim2.new(),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	ScrollingDirection = Enum.ScrollingDirection.Y,
}, SavedPage)
new("UIListLayout", {
	Padding = UDim.new(0, 6),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, SavedScroll)
new("UIPadding", { PaddingRight = UDim.new(0, 6) }, SavedScroll)

local EmptyLabel = new("TextLabel", {
	Size = UDim2.new(1, 0, 1, -46),
	Position = UDim2.fromOffset(0, 46),
	BackgroundTransparency = 1,
	Text = "ما فيه نصوص محفوظة.\nاكتب نص واضغط \"حفظ النص الحالي\".",
	TextColor3 = Theme.Muted,
	TextSize = 13,
	Font = Enum.Font.Gotham,
	TextWrapped = true,
}, SavedPage)

function renderSaved()
	for _, child in ipairs(SavedScroll:GetChildren()) do
		if child:IsA("GuiObject") then
			child:Destroy()
		end
	end
	EmptyLabel.Visible = #Store.saved == 0

	for i, value in ipairs(Store.saved) do
		local item = new("Frame", {
			Size = UDim2.new(1, 0, 0, 40),
			BackgroundColor3 = Theme.Panel,
			BorderSizePixel = 0,
			LayoutOrder = i,
		}, SavedScroll)
		round(item, 10)

		local useButton = new("TextButton", {
			Size = UDim2.new(1, -60, 1, 0),
			Position = UDim2.fromOffset(58, 0),
			BackgroundTransparency = 1,
			Text = value,
			TextColor3 = Theme.Text,
			TextSize = 15,
			Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Right,
			TextTruncate = Enum.TextTruncate.AtEnd,
			BorderSizePixel = 0,
		}, item)
		new("UIPadding", {
			PaddingRight = UDim.new(0, 12),
			PaddingLeft = UDim.new(0, 4),
		}, useButton)

		local deleteButton = new("TextButton", {
			Size = UDim2.fromOffset(46, 28),
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 8, 0.5, 0),
			BackgroundColor3 = Theme.DangerDark,
			Text = "حذف",
			TextColor3 = Theme.Text,
			TextSize = 12,
			Font = Enum.Font.GothamBold,
			BorderSizePixel = 0,
		}, item)
		round(deleteButton, 8)

		useButton.MouseButton1Click:Connect(function()
			playClick()
			TextBox.Text = value
			showPage("keyboard")
		end)

		deleteButton.MouseButton1Click:Connect(function()
			playClick()
			table.remove(Store.saved, i)
			renderSaved()
			saveStore()
		end)
	end
end

local saveFlashToken = 0

local function flashSave(message)
	saveFlashToken += 1
	local token = saveFlashToken
	SaveButton.Text = message
	task.delay(1.2, function()
		if token == saveFlashToken then
			SaveButton.Text = "حفظ النص الحالي"
		end
	end)
end

SaveButton.MouseButton1Click:Connect(function()
	playClick()
	local text = string.match(TextBox.Text, "^%s*(.-)%s*$") or ""
	if text == "" then
		flashSave("اكتب نص أولاً")
		return
	end
	for _, existing in ipairs(Store.saved) do
		if existing == text then
			flashSave("محفوظ مسبقاً")
			return
		end
	end
	if #Store.saved >= Config.MaxSaved then
		flashSave("وصلت للحد الأقصى")
		return
	end
	table.insert(Store.saved, 1, text)
	renderSaved()
	saveStore()
	flashSave("تم الحفظ")
end)

----------------------------------------------------------------
-- Page: Players (live list, teleport, spectate, avatar preview)
----------------------------------------------------------------
local PlayersPage = makePage("PlayersPage")

local playerRows = {} -- [userId] = { player, frame, specBtn }
local spectatingPlayer = nil
local previewPlayer = nil
local previewMode = "map" -- "map" = character as it looks in the game | "original" = Roblox avatar

local function headshotUrl(userId)
	return "rbxthumb://type=AvatarHeadShot&id=" .. tostring(userId) .. "&w=150&h=150"
end

local function fullBodyUrl(userId)
	return "rbxthumb://type=Avatar&id=" .. tostring(userId) .. "&w=420&h=420"
end

-- Small message that pops up at the bottom of the panel
local Toast = new("TextLabel", {
	Size = UDim2.fromOffset(0, 28),
	AutomaticSize = Enum.AutomaticSize.X,
	AnchorPoint = Vector2.new(0.5, 1),
	Position = UDim2.new(0.5, 0, 1, -12),
	BackgroundColor3 = Color3.fromRGB(12, 13, 20),
	BackgroundTransparency = 0.05,
	Text = "",
	TextColor3 = Theme.Text,
	TextSize = 12,
	Font = Enum.Font.GothamMedium,
	Visible = false,
	ZIndex = 50,
}, MainFrame)
round(Toast, 14)
stroke(Toast, Theme.Stroke, 1)
new("UIPadding", {
	PaddingLeft = UDim.new(0, 14),
	PaddingRight = UDim.new(0, 14),
}, Toast)

local toastToken = 0

local function showToast(text, color)
	toastToken += 1
	local token = toastToken
	Toast.Text = text
	Toast.TextColor3 = color or Theme.Text
	Toast.Visible = true
	task.delay(1.8, function()
		if token == toastToken then
			Toast.Visible = false
		end
	end)
end

----------------------------------------------------------------
-- Players page: UI
----------------------------------------------------------------
local SearchBox = new("TextBox", {
	Size = UDim2.new(1, -86, 0, 34),
	BackgroundColor3 = Theme.Panel,
	Text = "",
	PlaceholderText = "ابحث باسم أو يوزر...",
	PlaceholderColor3 = Theme.Muted,
	TextColor3 = Theme.Text,
	TextSize = 13,
	Font = Enum.Font.Gotham,
	ClearTextOnFocus = false,
	TextXAlignment = Enum.TextXAlignment.Right,
	ClipsDescendants = true,
	BorderSizePixel = 0,
}, PlayersPage)
round(SearchBox, 10)
stroke(SearchBox, Theme.Stroke, 1.5)
new("UIPadding", {
	PaddingLeft = UDim.new(0, 10),
	PaddingRight = UDim.new(0, 10),
}, SearchBox)

local CountLabel = new("TextLabel", {
	Size = UDim2.fromOffset(78, 34),
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, 0, 0, 0),
	BackgroundColor3 = Theme.Panel,
	Text = "0",
	TextColor3 = Theme.Muted,
	TextSize = 12,
	Font = Enum.Font.GothamBold,
	BorderSizePixel = 0,
}, PlayersPage)
round(CountLabel, 10)

local PlayerScroll = new("ScrollingFrame", {
	Size = UDim2.new(1, 0, 1, -42),
	Position = UDim2.fromOffset(0, 42),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 3,
	ScrollBarImageColor3 = Theme.Stroke,
	CanvasSize = UDim2.new(),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	ScrollingDirection = Enum.ScrollingDirection.Y,
}, PlayersPage)
new("UIListLayout", {
	Padding = UDim.new(0, 6),
	SortOrder = Enum.SortOrder.Name, -- rows are named so that you come first, then A-Z
}, PlayerScroll)
new("UIPadding", { PaddingRight = UDim.new(0, 6) }, PlayerScroll)

local NoResults = new("TextLabel", {
	Size = UDim2.new(1, 0, 1, -42),
	Position = UDim2.fromOffset(0, 42),
	BackgroundTransparency = 1,
	Text = "لا توجد نتائج",
	TextColor3 = Theme.Muted,
	TextSize = 13,
	Font = Enum.Font.Gotham,
	Visible = false,
}, PlayersPage)

----------------------------------------------------------------
-- Spectate bar (stays on screen even when the panel is closed)
----------------------------------------------------------------
local SpectateBar = new("Frame", {
	Name = "SpectateBar",
	Size = UDim2.fromOffset(280, 40),
	AnchorPoint = Vector2.new(0.5, 0),
	Position = UDim2.new(0.5, 0, 0, 10),
	BackgroundColor3 = Color3.fromRGB(14, 15, 24),
	BackgroundTransparency = 0.08,
	BorderSizePixel = 0,
	Visible = false,
	ZIndex = 20,
}, ScreenGui)
round(SpectateBar, 20)
local SpectateStroke = stroke(SpectateBar, Theme.Accent, 2)
onTheme(function()
	SpectateStroke.Color = Theme.Accent
end)

local function makeBarButton(text, width, color)
	local btn = new("TextButton", {
		Size = UDim2.fromOffset(width, 28),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = color,
		Text = text,
		TextColor3 = Theme.Text,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		BorderSizePixel = 0,
		ZIndex = 21,
	}, SpectateBar)
	round(btn, 14)
	return btn
end

local SpectateStop = makeBarButton("إيقاف", 56, Theme.Danger)
SpectateStop.Position = UDim2.new(0, 10, 0.5, 0)

local SpectatePrev = makeBarButton("<", 28, Theme.KeyAlt)
SpectatePrev.Position = UDim2.new(0, 72, 0.5, 0)

local SpectateNext = makeBarButton(">", 28, Theme.KeyAlt)
SpectateNext.AnchorPoint = Vector2.new(1, 0.5)
SpectateNext.Position = UDim2.new(1, -10, 0.5, 0)

local SpectateName = new("TextLabel", {
	Size = UDim2.new(1, -150, 1, 0),
	Position = UDim2.fromOffset(104, 0),
	BackgroundTransparency = 1,
	Text = "",
	TextColor3 = Theme.Text,
	TextSize = 13,
	Font = Enum.Font.GothamBold,
	TextTruncate = Enum.TextTruncate.AtEnd,
	ZIndex = 21,
}, SpectateBar)

----------------------------------------------------------------
-- Avatar preview (opens when you tap a player's picture)
----------------------------------------------------------------
local PreviewFrame = new("Frame", {
	Name = "Preview",
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = Color3.fromRGB(22, 24, 36),
	BorderSizePixel = 0,
	Visible = false,
	ZIndex = 5,
}, PlayersPage)
round(PreviewFrame, 12)
stroke(PreviewFrame, Theme.Stroke, 1.5)

-- Right side: viewer + mode buttons
local ViewerColumn = new("Frame", {
	Size = UDim2.new(0.5, -12, 1, -16),
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, -8, 0, 8),
	BackgroundTransparency = 1,
}, PreviewFrame)

local ViewerBG = new("Frame", {
	Size = UDim2.new(1, 0, 1, -36),
	BackgroundColor3 = Theme.Panel,
	BorderSizePixel = 0,
	ClipsDescendants = true,
}, ViewerColumn)
round(ViewerBG, 10)

local OriginalImage = new("ImageLabel", {
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	ScaleType = Enum.ScaleType.Fit,
	Image = "",
	Visible = false,
}, ViewerBG)

local MapViewport = new("ViewportFrame", {
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	Ambient = Color3.fromRGB(190, 190, 190),
	LightColor = Color3.fromRGB(255, 255, 255),
	BorderSizePixel = 0,
	Visible = false,
}, ViewerBG)
local PreviewCam = new("Camera", { FieldOfView = 35 }, MapViewport)
MapViewport.CurrentCamera = PreviewCam

local MsgLabel = new("TextLabel", {
	Size = UDim2.new(1, -16, 1, -16),
	Position = UDim2.fromOffset(8, 8),
	BackgroundTransparency = 1,
	Text = "",
	TextColor3 = Theme.Muted,
	TextSize = 12,
	Font = Enum.Font.Gotham,
	TextWrapped = true,
	Visible = false,
}, ViewerBG)

local RotateHint = new("TextLabel", {
	Size = UDim2.new(1, 0, 0, 14),
	AnchorPoint = Vector2.new(0, 1),
	Position = UDim2.new(0, 0, 1, -3),
	BackgroundTransparency = 1,
	Text = "اسحب للتدوير",
	TextColor3 = Theme.Muted,
	TextSize = 10,
	Font = Enum.Font.Gotham,
	Visible = false,
}, ViewerBG)

local ModeRow = new("Frame", {
	Size = UDim2.new(1, 4, 0, 30),
	AnchorPoint = Vector2.new(0.5, 1),
	Position = UDim2.new(0.5, 0, 1, 0),
	BackgroundTransparency = 1,
}, ViewerColumn)

local ModeButtons = {}
for _, info in ipairs({
	{ "original", "الأصلية", 0.5 },
	{ "map", "داخل الماب", 0 },
}) do
	local btn = new("TextButton", {
		Text = info[2],
		TextSize = 11,
		Font = Enum.Font.GothamBold,
		BorderSizePixel = 0,
	}, ModeRow)
	round(btn, 8)
	placeKey(btn, info[3], 0.5)
	ModeButtons[info[1]] = btn
end

-- Left side: name + actions
local InfoColumn = new("ScrollingFrame", {
	Size = UDim2.new(0.5, -12, 1, -16),
	Position = UDim2.fromOffset(8, 8),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 2,
	ScrollBarImageColor3 = Theme.Stroke,
	CanvasSize = UDim2.new(),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	ScrollingDirection = Enum.ScrollingDirection.Y,
}, PreviewFrame)
new("UIListLayout", {
	Padding = UDim.new(0, 6),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, InfoColumn)

local PreviewName = new("TextLabel", {
	Size = UDim2.new(1, 0, 0, 22),
	BackgroundTransparency = 1,
	Text = "",
	TextColor3 = Theme.Text,
	TextSize = 15,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Right,
	TextTruncate = Enum.TextTruncate.AtEnd,
	LayoutOrder = 1,
}, InfoColumn)

local PreviewUser = new("TextLabel", {
	Size = UDim2.new(1, 0, 0, 16),
	BackgroundTransparency = 1,
	Text = "",
	TextColor3 = Theme.Muted,
	TextSize = 11,
	Font = Enum.Font.Gotham,
	TextXAlignment = Enum.TextXAlignment.Right,
	TextTruncate = Enum.TextTruncate.AtEnd,
	LayoutOrder = 2,
}, InfoColumn)

local function makeInfoButton(text, order, color)
	local btn = new("TextButton", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = color,
		Text = text,
		TextColor3 = Theme.Text,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		BorderSizePixel = 0,
		LayoutOrder = order,
	}, InfoColumn)
	round(btn, 8)
	return btn
end

local PreviewTpBtn = makeInfoButton("انتقال للاعب", 3, Theme.Accent)
local PreviewSpecBtn = makeInfoButton("مراقبة", 4, Theme.KeyAlt)
local PreviewOutfitBtn = makeInfoButton("ملابسه", 5, Theme.KeyAlt)
local PreviewCopyBtn = makeInfoButton("نسخ اليوزر", 6, Theme.Key)
local PreviewBackBtn = makeInfoButton("رجوع للقائمة", 7, Theme.KeyAlt)
onTheme(function()
	PreviewTpBtn.BackgroundColor3 = Theme.Accent
end)

----------------------------------------------------------------
-- Players page: logic
----------------------------------------------------------------
local function countRows()
	local n = 0
	for _ in pairs(playerRows) do
		n += 1
	end
	return n
end

local function updateCount()
	CountLabel.Text = countRows() .. "/" .. Players.MaxPlayers .. " لاعب"
end

local function refreshPlayerButtons()
	for _, data in pairs(playerRows) do
		local active = spectatingPlayer == data.player
		data.specBtn.Text = active and "إيقاف" or "مراقبة"
		data.specBtn.BackgroundColor3 = active and Theme.Danger or Theme.KeyAlt
	end
	local previewActive = previewPlayer ~= nil and spectatingPlayer == previewPlayer
	PreviewSpecBtn.Text = previewActive and "إيقاف المراقبة" or "مراقبة"
	PreviewSpecBtn.BackgroundColor3 = previewActive and Theme.Danger or Theme.KeyAlt
end
onTheme(refreshPlayerButtons)

-- Closes the panel after teleport / spectate (if enabled in Settings)
local function closeAfterAction()
	if Settings.AutoCloseOnAction then
		task.delay(0.4, function()
			if isOpen then
				setOpen(false)
			end
		end)
	end
end

-- Spectate -------------------------------------------------------
local spectateConn = nil

local function disconnectSpectateConn()
	if spectateConn then
		spectateConn:Disconnect()
		spectateConn = nil
	end
end

local function stopSpectate(skipCamera)
	disconnectSpectateConn()
	spectatingPlayer = nil
	SpectateBar.Visible = false
	if not skipCamera then
		local cam = workspace.CurrentCamera
		local char = LocalPlayer.Character
		local humanoid = char and char:FindFirstChildOfClass("Humanoid")
		if cam and humanoid then
			cam.CameraSubject = humanoid
		end
	end
	refreshPlayerButtons()
end

local function startSpectate(player)
	if player == LocalPlayer then
		return false
	end
	local cam = workspace.CurrentCamera
	local char = player.Character
	local humanoid = char and char:FindFirstChildOfClass("Humanoid")
	if not cam or not humanoid then
		showToast("تعذر المراقبة: اللاعب غير محمل", Theme.Danger)
		return false
	end

	disconnectSpectateConn()
	cam.CameraSubject = humanoid
	spectatingPlayer = player

	-- keep following the player after he respawns
	spectateConn = player.CharacterAdded:Connect(function(newChar)
		local h = newChar:WaitForChild("Humanoid", 5)
		local c = workspace.CurrentCamera
		if h and c and spectatingPlayer == player then
			c.CameraSubject = h
		end
	end)

	SpectateName.Text = "تراقب: " .. player.DisplayName
	SpectateBar.Visible = true
	refreshPlayerButtons()
	return true
end

local function toggleSpectate(player)
	if spectatingPlayer == player then
		stopSpectate()
		showToast("أوقفت المراقبة")
		return
	end
	if startSpectate(player) then
		showToast("تراقب " .. player.DisplayName, Theme.Success)
		closeAfterAction()
	end
end

local function getOtherPlayers()
	local list = {}
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			table.insert(list, p)
		end
	end
	table.sort(list, function(a, b)
		return string.lower(a.DisplayName) < string.lower(b.DisplayName)
	end)
	return list
end

-- direction: 1 = next player, -1 = previous player
local function cycleSpectate(direction)
	local list = getOtherPlayers()
	if #list == 0 then
		stopSpectate()
		return
	end

	local index = 0
	for i, p in ipairs(list) do
		if p == spectatingPlayer then
			index = i
			break
		end
	end

	for step = 1, #list do
		local nextIndex = ((index - 1 + direction * step) % #list) + 1
		if startSpectate(list[nextIndex]) then
			return
		end
	end
end

-- Teleport -------------------------------------------------------
local function teleportToPlayer(player)
	local myChar = LocalPlayer.Character
	local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not myRoot or not root then
		showToast("تعذر الانتقال: اللاعب بعيد أو غير محمل", Theme.Danger)
		return
	end

	-- stand 4 studs in front of the player, looking at him
	local pos = (root.CFrame * CFrame.new(0, 1, -4)).Position
	local lookAt = Vector3.new(root.Position.X, pos.Y, root.Position.Z)
	local ok = pcall(function()
		myChar:PivotTo(CFrame.lookAt(pos, lookAt))
	end)

	if ok then
		showToast("انتقلت إلى " .. player.DisplayName, Theme.Success)
		closeAfterAction()
	else
		showToast("تعذر الانتقال", Theme.Danger)
	end
end

-- Avatar preview -------------------------------------------------
local previewConn, previewClone, previewCharConn
local previewAngle = 0
local previewCenter = Vector3.zero
local previewFront = Vector3.new(0, 0, -1)
local previewDistance = 10
local previewDragging = false
local previewDragX = 0

local function clearMapPreview()
	if previewConn then
		previewConn:Disconnect()
		previewConn = nil
	end
	if previewClone then
		previewClone:Destroy()
		previewClone = nil
	end
end

-- Clones the player's character as it looks right now (skins, clothes, accessories...) into the viewport
local function buildMapPreview(player)
	clearMapPreview()

	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not char or not root then
		return false, "شخصية اللاعب غير محملة (بعيد عنك أو ميت)"
	end

	local wasArchivable = char.Archivable
	char.Archivable = true
	local ok, clone = pcall(function()
		return char:Clone()
	end)
	char.Archivable = wasArchivable
	if not ok or not clone then
		return false, "الماب يمنع نسخ الشخصية"
	end

	for _, d in ipairs(clone:GetDescendants()) do
		if d:IsA("LuaSourceContainer") or d:IsA("Sound") or d:IsA("BillboardGui") or d:IsA("ForceField") then
			d:Destroy()
		elseif d:IsA("BasePart") then
			d.Anchored = true
		end
	end
	local humanoid = clone:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	end

	clone.Parent = MapViewport
	previewClone = clone

	-- frame the whole body
	local boxCFrame, boxSize = clone:GetBoundingBox()
	previewCenter = boxCFrame.Position

	local look = root.CFrame.LookVector
	local flat = Vector3.new(look.X, 0, look.Z)
	if flat.Magnitude < 0.01 then
		flat = Vector3.new(0, 0, -1)
	end
	previewFront = flat.Unit

	local tanV = math.tan(math.rad(PreviewCam.FieldOfView / 2))
	local viewSize = MapViewport.AbsoluteSize
	local aspect = viewSize.X / math.max(viewSize.Y, 1)
	if aspect <= 0 then
		aspect = 0.7
	end
	local width = math.max(boxSize.X, boxSize.Z)
	previewDistance = math.max((boxSize.Y / 2) / tanV, (width / 2) / (tanV * aspect)) * 1.15 + boxSize.Z / 2

	previewAngle = 0
	previewConn = RunService.RenderStepped:Connect(function(dt)
		if not previewDragging then
			previewAngle += dt * 0.9
		end
		local dir = CFrame.Angles(0, previewAngle, 0) * previewFront
		local camPos = previewCenter + dir * previewDistance + Vector3.new(0, 0.3, 0)
		PreviewCam.CFrame = CFrame.lookAt(camPos, previewCenter)
	end)

	return true
end

local function refreshModeButtons()
	for mode, btn in pairs(ModeButtons) do
		local selected = previewPlayer ~= nil and previewMode == mode
		btn.BackgroundColor3 = selected and Theme.Accent or Theme.Key
		btn.TextColor3 = selected and Theme.Text or Theme.Muted
	end
end
onTheme(refreshModeButtons)

-- Returns true when the requested mode could be shown
local function setPreviewMode(mode)
	if not previewPlayer then
		return false
	end
	previewMode = mode
	MsgLabel.Visible = false
	local success = true

	if mode == "original" then
		clearMapPreview()
		MapViewport.Visible = false
		RotateHint.Visible = false
		OriginalImage.Image = fullBodyUrl(previewPlayer.UserId)
		OriginalImage.Visible = true
	else
		OriginalImage.Visible = false
		MapViewport.Visible = true
		local ok, err = buildMapPreview(previewPlayer)
		if ok then
			RotateHint.Visible = true
		else
			success = false
			MapViewport.Visible = false
			RotateHint.Visible = false
			MsgLabel.Text = err
			MsgLabel.Visible = true
		end
	end

	refreshModeButtons()
	return success
end

local function closePreview()
	clearMapPreview()
	if previewCharConn then
		previewCharConn:Disconnect()
		previewCharConn = nil
	end
	previewPlayer = nil
	previewDragging = false
	PreviewFrame.Visible = false
	OriginalImage.Image = ""
	refreshModeButtons()
	refreshPlayerButtons()
end

local function openPreview(player)
	previewPlayer = player
	PreviewName.Text = player.DisplayName
	PreviewUser.Text = "@" .. player.Name

	local isSelf = player == LocalPlayer
	PreviewTpBtn.Visible = not isSelf
	PreviewSpecBtn.Visible = not isSelf
	PreviewOutfitBtn.Visible = not isSelf
	PreviewFrame.Visible = true

	if previewCharConn then
		previewCharConn:Disconnect()
	end
	-- if the player respawns / changes skin while you are looking, refresh the in-map view
	previewCharConn = player.CharacterAdded:Connect(function(newChar)
		if previewPlayer == player and previewMode == "map" then
			newChar:WaitForChild("HumanoidRootPart", 5)
			task.wait(1.5) -- let the appearance load
			if previewPlayer == player and previewMode == "map" then
				setPreviewMode("map")
			end
		end
	end)

	if not setPreviewMode("map") then
		setPreviewMode("original")
		showToast("شخصية الماب غير متاحة الحين، عرضت الأصلية")
	end
	refreshPlayerButtons()
end

-- drag on the viewer to rotate the in-map character
track(ViewerBG.InputBegan:Connect(function(input)
	if isPress(input) and previewMode == "map" then
		previewDragging = true
		previewDragX = input.Position.X
		local conn
		conn = input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				previewDragging = false
				conn:Disconnect()
			end
		end)
	end
end))

track(UserInputService.InputChanged:Connect(function(input)
	if previewDragging
		and (input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch) then
		local x = input.Position.X
		previewAngle -= (x - previewDragX) * 0.02
		previewDragX = x
	end
end))

----------------------------------------------------------------
-- Outfit viewer: see what a player wears (original / in-map) and wear it
----------------------------------------------------------------
local MarketplaceService = game:GetService("MarketplaceService")

local outfitPlayer = nil
local outfitSource = nil -- "original" | "map" | nil (not chosen yet)
local outfitItems = {}
local outfitFilter = "all"
local outfitCards = {} -- { item, badge } of the cards on screen
local outfitToken = 0

local wearBusy = false
local wearAllRunning = false
local wearCancel = false
local workingAttempt = {} -- [item.kind] = the attempt that worked last time

-- UI -------------------------------------------------------------
local OutfitFrame = new("Frame", {
	Name = "Outfit",
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = Color3.fromRGB(22, 24, 36),
	BorderSizePixel = 0,
	Visible = false,
	ZIndex = 8,
}, PlayersPage)
round(OutfitFrame, 12)
stroke(OutfitFrame, Theme.Stroke, 1.5)

-- row 1: back + source (original / in-map)
local OutfitHeader = new("Frame", {
	Size = UDim2.new(1, -16, 0, 30),
	Position = UDim2.fromOffset(8, 8),
	BackgroundTransparency = 1,
}, OutfitFrame)

local OutfitBack = new("TextButton", {
	Size = UDim2.new(0, 54, 1, 0),
	BackgroundColor3 = Theme.KeyAlt,
	Text = "رجوع",
	TextColor3 = Theme.Text,
	TextSize = 12,
	Font = Enum.Font.GothamBold,
	BorderSizePixel = 0,
}, OutfitHeader)
round(OutfitBack, 8)

local SourceHolder = new("Frame", {
	Size = UDim2.new(1, -58, 1, 0),
	Position = UDim2.fromOffset(58, 0),
	BackgroundTransparency = 1,
}, OutfitHeader)

local SourceButtons = {}
for _, info in ipairs({
	{ "map", "داخل الماب", 0 },
	{ "original", "الأصلي", 0.5 },
}) do
	local btn = new("TextButton", {
		Text = info[2],
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		BorderSizePixel = 0,
	}, SourceHolder)
	round(btn, 8)
	placeKey(btn, info[3], 0.5)
	SourceButtons[info[1]] = btn
end

-- row 2: wear-all button + filter chips
local OutfitBar = new("Frame", {
	Size = UDim2.new(1, -16, 0, 28),
	Position = UDim2.fromOffset(8, 44),
	BackgroundTransparency = 1,
}, OutfitFrame)

local WearAllBtn = new("TextButton", {
	Size = UDim2.new(0, 96, 1, 0),
	BackgroundColor3 = Theme.Accent,
	Text = "لبس الكل",
	TextColor3 = Theme.Text,
	TextSize = 12,
	Font = Enum.Font.GothamBold,
	BorderSizePixel = 0,
}, OutfitBar)
round(WearAllBtn, 8)

local ChipScroll = new("ScrollingFrame", {
	Size = UDim2.new(1, -102, 1, 0),
	Position = UDim2.fromOffset(102, 0),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 0,
	CanvasSize = UDim2.new(),
	AutomaticCanvasSize = Enum.AutomaticSize.X,
	ScrollingDirection = Enum.ScrollingDirection.X,
}, OutfitBar)
new("UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal,
	Padding = UDim.new(0, 4),
	SortOrder = Enum.SortOrder.LayoutOrder,
	VerticalAlignment = Enum.VerticalAlignment.Center,
}, ChipScroll)

local OutfitFilters = {
	{ id = "all", label = "الكل" },
	{ id = "clothes", label = "ملابس", cats = { clothes = true } },
	{ id = "accessories", label = "إكسسوارات", cats = { accessories = true } },
	{ id = "parts", label = "أجزاء الجسم", cats = { body = true } },
	{ id = "fullbody", label = "الجسم كامل", cats = { body = true, skin = true } },
	{ id = "poses", label = "وقفات", cats = { poses = true } },
	{ id = "skin", label = "لون البشرة", cats = { skin = true } },
}

local FilterById = {}
local ChipButtons = {}
for i, f in ipairs(OutfitFilters) do
	FilterById[f.id] = f
	local chip = new("TextButton", {
		Size = UDim2.fromOffset(0, 26),
		AutomaticSize = Enum.AutomaticSize.X,
		Text = f.label,
		TextSize = 11,
		Font = Enum.Font.GothamBold,
		BorderSizePixel = 0,
		LayoutOrder = i,
	}, ChipScroll)
	round(chip, 13)
	new("UIPadding", {
		PaddingLeft = UDim.new(0, 12),
		PaddingRight = UDim.new(0, 12),
	}, chip)
	ChipButtons[f.id] = chip
end

-- items grid
local OutfitGrid = new("ScrollingFrame", {
	Size = UDim2.new(1, -16, 1, -84),
	Position = UDim2.fromOffset(8, 76),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 3,
	ScrollBarImageColor3 = Theme.Stroke,
	CanvasSize = UDim2.new(),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	ScrollingDirection = Enum.ScrollingDirection.Y,
}, OutfitFrame)
new("UIGridLayout", {
	CellSize = UDim2.fromOffset(84, 100),
	CellPadding = UDim2.fromOffset(6, 6),
	HorizontalAlignment = Enum.HorizontalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder,
}, OutfitGrid)

local OutfitMsg = new("TextLabel", {
	Size = UDim2.new(1, -32, 1, -84),
	Position = UDim2.fromOffset(16, 76),
	BackgroundTransparency = 1,
	Text = "",
	TextColor3 = Theme.Muted,
	TextSize = 13,
	Font = Enum.Font.Gotham,
	TextWrapped = true,
	Visible = false,
}, OutfitFrame)

-- first screen: choose original / in-map
local Chooser = new("Frame", {
	Size = UDim2.new(1, -16, 1, -84),
	Position = UDim2.fromOffset(8, 76),
	BackgroundTransparency = 1,
}, OutfitFrame)
new("UIListLayout", {
	Padding = UDim.new(0, 8),
	SortOrder = Enum.SortOrder.LayoutOrder,
	HorizontalAlignment = Enum.HorizontalAlignment.Center,
	VerticalAlignment = Enum.VerticalAlignment.Center,
}, Chooser)

local ChooserTitle = new("TextLabel", {
	Size = UDim2.new(1, 0, 0, 20),
	BackgroundTransparency = 1,
	Text = "",
	TextColor3 = Theme.Text,
	TextSize = 14,
	Font = Enum.Font.GothamBold,
	TextTruncate = Enum.TextTruncate.AtEnd,
	LayoutOrder = 1,
}, Chooser)

local function makeChooserButton(text, order)
	local btn = new("TextButton", {
		Size = UDim2.new(1, 0, 0, 52),
		BackgroundColor3 = Theme.Panel,
		Text = text,
		TextColor3 = Theme.Text,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		TextWrapped = true,
		BorderSizePixel = 0,
		LayoutOrder = order,
	}, Chooser)
	round(btn, 12)
	stroke(btn, Theme.Stroke, 1.5)
	return btn
end

local ChooseOriginal = makeChooserButton("ملابسه الأصلية\nكل اللي لابسه في حسابه", 2)
local ChooseMap = makeChooserButton("ملابسه داخل الماب\nالوقفات ولون البشرة وكل شي مسويه", 3)

-- Data helpers ---------------------------------------------------
local function parseAssetId(str)
	if type(str) ~= "string" then
		return nil
	end
	return tonumber(string.match(str, "%d+"))
end

local function thumbUrl(id)
	return "rbxthumb://type=Asset&id=" .. tostring(id) .. "&w=150&h=150"
end

-- {label, assetTypeId, category}
local AccessoryInfo = {
	Hat = { "قبعة", 8, "accessories" },
	Hair = { "شعر", 41, "accessories" },
	Face = { "إكسسوار وجه", 42, "accessories" },
	Neck = { "إكسسوار عنق", 43, "accessories" },
	Shoulder = { "إكسسوار كتف", 44, "accessories" },
	Front = { "إكسسوار أمامي", 45, "accessories" },
	Back = { "إكسسوار ظهر", 46, "accessories" },
	Waist = { "إكسسوار خصر", 47, "accessories" },
	TShirt = { "تيشيرت (طبقات)", 64, "clothes" },
	Shirt = { "قميص (طبقات)", 65, "clothes" },
	Pants = { "بنطلون (طبقات)", 66, "clothes" },
	Jacket = { "جاكيت", 67, "clothes" },
	Sweater = { "كنزة", 68, "clothes" },
	Shorts = { "شورت", 69, "clothes" },
	LeftShoe = { "حذاء يسار", 70, "clothes" },
	RightShoe = { "حذاء يمين", 71, "clothes" },
	DressSkirt = { "فستان / تنورة", 72, "clothes" },
	Eyebrow = { "حواجب", 76, "body" },
	Eyelash = { "رموش", 77, "body" },
}

local AnimationFields = {
	{ "IdleAnimation", "وقفة", 51 },
	{ "WalkAnimation", "مشي", 55 },
	{ "RunAnimation", "جري", 53 },
	{ "JumpAnimation", "قفز", 52 },
	{ "FallAnimation", "سقوط", 50 },
	{ "ClimbAnimation", "تسلق", 48 },
	{ "SwimAnimation", "سباحة", 54 },
	{ "MoodAnimation", "مزاج", 78 },
}

-- Roblox's built-in animations (hidden from the "poses" list when HideDefaultAnimations = true)
local DefaultAnimIds = {
	[507766666] = true, [507766951] = true, [507777826] = true, [507767714] = true,
	[507765000] = true, [507767968] = true, [507765644] = true, [507784897] = true,
	[180435571] = true, [180435792] = true, [180426354] = true, [125750702] = true,
	[180436148] = true, [180436334] = true,
}

local function addItem(items, id, typeLabel, category, kind, assetTypeId)
	if type(id) == "number" and id > 0 then
		table.insert(items, {
			id = id,
			typeLabel = typeLabel,
			category = category,
			kind = kind,
			assetTypeId = assetTypeId,
		})
	end
end

local function addAnimation(items, id, label, assetTypeId)
	if Config.HideDefaultAnimations and DefaultAnimIds[id] then
		return
	end
	addItem(items, id, label, "poses", "other", assetTypeId)
end

local function addSkin(items, brickColor)
	table.insert(items, {
		kind = "skin",
		category = "skin",
		typeLabel = "لون البشرة",
		name = brickColor.Name,
		brickName = brickColor.Name,
		color = brickColor.Color,
	})
end

-- clothes, accessories, body parts (and optionally animations) from a HumanoidDescription
local function appendDescription(items, desc, withAnimations)
	addItem(items, desc.Shirt, "قميص", "clothes", "shirt", 11)
	addItem(items, desc.Pants, "بنطلون", "clothes", "pants", 12)
	addItem(items, desc.GraphicTShirt, "تيشيرت", "clothes", "other", 2)
	addItem(items, desc.Face, "وجه", "body", "other", 18)
	addItem(items, desc.Head, "رأس", "body", "other", 17)
	addItem(items, desc.Torso, "جذع", "body", "other", 27)
	addItem(items, desc.RightArm, "ذراع يمين", "body", "other", 28)
	addItem(items, desc.LeftArm, "ذراع يسار", "body", "other", 29)
	addItem(items, desc.LeftLeg, "رجل يسار", "body", "other", 30)
	addItem(items, desc.RightLeg, "رجل يمين", "body", "other", 31)

	local ok, accessories = pcall(function()
		return desc:GetAccessories(true)
	end)
	if ok and type(accessories) == "table" then
		for _, acc in ipairs(accessories) do
			local info = AccessoryInfo[acc.AccessoryType.Name] or { "إكسسوار", nil, "accessories" }
			addItem(items, acc.AssetId, info[1], info[3], "other", info[2])
		end
	end

	if withAnimations then
		for _, field in ipairs(AnimationFields) do
			addAnimation(items, desc[field[1]], field[2], field[3])
		end
	end
end

-- The player's real Roblox avatar (his profile)
local function readOriginal(player)
	local ok, desc = pcall(function()
		return Players:GetHumanoidDescriptionFromUserId(player.UserId)
	end)
	if not ok or not desc then
		return nil, "تعذر جلب أفاتار اللاعب الأصلي"
	end
	local items = {}
	appendDescription(items, desc, true)
	addSkin(items, BrickColor.new(desc.HeadColor))
	return items
end

-- What the player looks like right now inside the map
local function readMap(player)
	local char = player.Character
	local humanoid = char and char:FindFirstChildOfClass("Humanoid")
	if not char or not humanoid then
		return nil, "شخصية اللاعب غير محملة (بعيد عنك أو ميت)"
	end

	local items = {}
	local okDesc, desc = pcall(function()
		return humanoid:GetAppliedDescription()
	end)
	if okDesc and desc then
		appendDescription(items, desc, false)
	end

	local function has(kind)
		for _, it in ipairs(items) do
			if it.kind == kind then
				return true
			end
		end
		return false
	end

	-- clothes straight from the character (template ids, may not match the catalog id)
	if not has("shirt") then
		local shirt = char:FindFirstChildOfClass("Shirt")
		addItem(items, shirt and parseAssetId(shirt.ShirtTemplate), "قميص", "clothes", "shirt", 11)
	end
	if not has("pants") then
		local pants = char:FindFirstChildOfClass("Pants")
		addItem(items, pants and parseAssetId(pants.PantsTemplate), "بنطلون", "clothes", "pants", 12)
	end

	-- accessories we could not get an id for: show them, but they cannot be worn
	local hasAccessory = false
	for _, it in ipairs(items) do
		if it.category == "accessories" then
			hasAccessory = true
		end
	end
	if not hasAccessory then
		for _, child in ipairs(char:GetChildren()) do
			if child:IsA("Accessory") then
				table.insert(items, {
					name = child.Name,
					typeLabel = "إكسسوار (بدون رقم)",
					category = "accessories",
					kind = "other",
				})
			end
		end
	end

	-- poses: the animations the Animate script is using
	local animate = char:FindFirstChild("Animate")
	if animate then
		local function animId(folderName, preferred)
			local folder = animate:FindFirstChild(folderName)
			if not folder then
				return nil
			end
			local anim = (preferred and folder:FindFirstChild(preferred)) or folder:FindFirstChildOfClass("Animation")
			return anim and anim:IsA("Animation") and parseAssetId(anim.AnimationId) or nil
		end
		addAnimation(items, animId("idle", "Animation1"), "وقفة", 51)
		addAnimation(items, animId("walk"), "مشي", 55)
		addAnimation(items, animId("run"), "جري", 53)
		addAnimation(items, animId("jump"), "قفز", 52)
		addAnimation(items, animId("fall"), "سقوط", 50)
		addAnimation(items, animId("climb"), "تسلق", 48)
		addAnimation(items, animId("swim"), "سباحة", 54)
	end

	-- skin color
	local bodyColors = char:FindFirstChildOfClass("BodyColors")
	if bodyColors then
		addSkin(items, bodyColors.HeadColor)
	elseif okDesc and desc then
		addSkin(items, BrickColor.new(desc.HeadColor))
	end

	return items
end

-- names of the items (loaded in the background)
local nameCache = {}

local function fetchName(id, callback)
	if nameCache[id] then
		callback(nameCache[id])
		return
	end
	task.spawn(function()
		local ok, info = pcall(function()
			return MarketplaceService:GetProductInfo(id)
		end)
		if ok and info and info.Name then
			nameCache[id] = info.Name
			callback(info.Name)
		end
	end)
end

-- Wearing --------------------------------------------------------
-- A fingerprint of how your character looks; it changes when a wear command worked
local function characterSignature()
	local char = LocalPlayer.Character
	if not char then
		return ""
	end
	local parts = {}
	for _, child in ipairs(char:GetChildren()) do
		if child:IsA("Accessory") then
			table.insert(parts, "A:" .. child.Name)
		elseif child:IsA("Shirt") then
			table.insert(parts, "S:" .. child.ShirtTemplate)
		elseif child:IsA("Pants") then
			table.insert(parts, "P:" .. child.PantsTemplate)
		elseif child:IsA("ShirtGraphic") then
			table.insert(parts, "G:" .. child.Graphic)
		elseif child:IsA("BodyColors") then
			table.insert(parts, "B:" .. tostring(child.HeadColor3) .. tostring(child.TorsoColor3))
		elseif child:IsA("MeshPart") then
			table.insert(parts, "M:" .. child.Name .. child.MeshId)
		end
	end
	local head = char:FindFirstChild("Head")
	local face = head and head:FindFirstChildOfClass("Decal")
	if face then
		table.insert(parts, "F:" .. face.Texture)
	end
	local animate = char:FindFirstChild("Animate")
	if animate then
		for _, d in ipairs(animate:GetDescendants()) do
			if d:IsA("Animation") then
				table.insert(parts, "N:" .. d.AnimationId)
			end
		end
	end
	table.sort(parts)
	return table.concat(parts, "|")
end

local function waitForChange(before, timeout)
	local waited = 0
	while waited < timeout do
		task.wait(0.2)
		waited += 0.2
		if characterSignature() ~= before then
			return true
		end
	end
	return false
end

-- Calls a remote without ever freezing the UI. Returns ok, result
local function callRemote(remote, args)
	local state = { done = false, ok = false, result = nil }
	task.spawn(function()
		local ok, result = pcall(function()
			if remote:IsA("RemoteFunction") then
				return remote:InvokeServer(table.unpack(args))
			elseif remote:IsA("RemoteEvent") then
				remote:FireServer(table.unpack(args))
			end
			return nil
		end)
		state.ok = ok
		state.result = result
		state.done = true
	end)

	local waited = 0
	while not state.done and waited < 3 do
		task.wait(0.1)
		waited += 0.1
	end
	return state.done and state.ok, state.result
end

local function attemptsFor(item)
	local list = {}
	if item.kind == "skin" then
		table.insert(list, {
			remote = "ChangeBodyColor",
			args = function(it)
				return { it.brickName }
			end,
		})
		return list
	end

	for _, attempt in ipairs(Config.WearAttempts) do
		local allowed = attempt.kinds == nil or attempt.kinds[item.kind] == true
		local typeOk = not attempt.needsType or item.assetTypeId ~= nil
		if allowed and typeOk then
			table.insert(list, attempt)
		end
	end

	-- the command that worked last time for this kind of item goes first
	local preferred = workingAttempt[item.kind]
	if preferred then
		for i, attempt in ipairs(list) do
			if attempt == preferred then
				table.remove(list, i)
				table.insert(list, 1, preferred)
				break
			end
		end
	end
	return list
end

-- Tries the wear commands one by one until one of them changes your character
local function tryWear(item)
	local folder = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:WaitForChild("Remotes", 3)
	if not folder then
		return false, "ما لقيت مجلد Remotes في هذا الماب"
	end

	local before = characterSignature()
	for _, attempt in ipairs(attemptsFor(item)) do
		local remote = folder:FindFirstChild(attempt.remote)
		if remote then
			local ok, result = callRemote(remote, attempt.args(item))
			local changed = ok and waitForChange(before, 1.2)
			if changed or (ok and result == true) then
				workingAttempt[item.kind] = attempt
				return true, attempt.remote
			end
		end
	end
	return false, "ما نجح أي أمر"
end

local function setBadge(badge, text, color)
	if not badge or not badge.Parent then
		return
	end
	badge.Text = text
	badge.BackgroundColor3 = color
	badge.Visible = true
end

local function wearItem(item, badge)
	if wearBusy then
		showToast("انتظر لين يخلص اللبس...", Theme.Danger)
		return
	end
	if item.kind ~= "skin" and not item.id then
		showToast("ما قدرت أعرف رقم هذا العنصر", Theme.Danger)
		return
	end

	wearBusy = true
	setBadge(badge, "جاري...", Theme.KeyAlt)
	task.spawn(function()
		local ok, info = tryWear(item)
		wearBusy = false
		if ok then
			setBadge(badge, "تم", Theme.Success)
			showToast("لبست: " .. (item.name or item.typeLabel) .. " (" .. info .. ")", Theme.Success)
		else
			setBadge(badge, "فشل", Theme.Danger)
			showToast(info, Theme.Danger)
		end
	end)
end

-- Items / cards --------------------------------------------------
local categoryRank = { clothes = 1, accessories = 2, body = 3, poses = 4, skin = 5 }

local function itemPassesFilter(item)
	local f = FilterById[outfitFilter]
	return f == nil or f.cats == nil or f.cats[item.category] == true
end

local function clearCards()
	for _, child in ipairs(OutfitGrid:GetChildren()) do
		if child:IsA("GuiObject") then
			child:Destroy()
		end
	end
	outfitCards = {}
end

local function createCard(item, order)
	local card = new("TextButton", {
		Name = "Card",
		BackgroundColor3 = Theme.Panel,
		Text = "",
		BorderSizePixel = 0,
		LayoutOrder = order,
	}, OutfitGrid)
	round(card, 10)
	stroke(card, Theme.Stroke, 1, 0.5)

	local thumb
	if item.kind == "skin" then
		thumb = new("Frame", {
			Size = UDim2.fromOffset(54, 54),
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 6),
			BackgroundColor3 = item.color,
			BorderSizePixel = 0,
		}, card)
	else
		thumb = new("ImageLabel", {
			Size = UDim2.fromOffset(54, 54),
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 6),
			BackgroundColor3 = Theme.Key,
			Image = item.id and thumbUrl(item.id) or "",
			ScaleType = Enum.ScaleType.Fit,
			BorderSizePixel = 0,
		}, card)
	end
	round(thumb, 10)

	local nameLabel = new("TextLabel", {
		Size = UDim2.new(1, -8, 0, 24),
		Position = UDim2.fromOffset(4, 62),
		BackgroundTransparency = 1,
		Text = item.name or item.typeLabel,
		TextColor3 = Theme.Text,
		TextSize = 10,
		Font = Enum.Font.GothamMedium,
		TextWrapped = true,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextYAlignment = Enum.TextYAlignment.Top,
	}, card)

	new("TextLabel", {
		Size = UDim2.new(1, -8, 0, 12),
		Position = UDim2.fromOffset(4, 86),
		BackgroundTransparency = 1,
		Text = item.typeLabel,
		TextColor3 = Theme.Muted,
		TextSize = 9,
		Font = Enum.Font.Gotham,
		TextTruncate = Enum.TextTruncate.AtEnd,
	}, card)

	local badge = new("TextLabel", {
		Size = UDim2.fromOffset(40, 14),
		Position = UDim2.fromOffset(4, 4),
		BackgroundColor3 = Theme.Accent,
		Text = "",
		TextColor3 = Theme.Text,
		TextSize = 9,
		Font = Enum.Font.GothamBold,
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 3,
	}, card)
	round(badge, 7)

	card.MouseButton1Click:Connect(function()
		playClick()
		wearItem(item, badge)
	end)

	return card, badge, nameLabel
end

local function refreshChips()
	for id, chip in pairs(ChipButtons) do
		local selected = id == outfitFilter
		chip.BackgroundColor3 = selected and Theme.Accent or Theme.Key
		chip.TextColor3 = selected and Theme.Text or Theme.Muted
	end
end

local function refreshSourceButtons()
	for source, btn in pairs(SourceButtons) do
		local selected = outfitSource == source
		btn.BackgroundColor3 = selected and Theme.Accent or Theme.Key
		btn.TextColor3 = selected and Theme.Text or Theme.Muted
	end
end

onTheme(function()
	refreshChips()
	refreshSourceButtons()
	if not wearAllRunning then
		WearAllBtn.BackgroundColor3 = Theme.Accent
	end
end)

local function renderOutfit()
	clearCards()

	local list = {}
	for index, item in ipairs(outfitItems) do
		if itemPassesFilter(item) then
			table.insert(list, { item = item, index = index })
		end
	end
	table.sort(list, function(a, b)
		local ra = categoryRank[a.item.category] or 9
		local rb = categoryRank[b.item.category] or 9
		if ra ~= rb then
			return ra < rb
		end
		return a.index < b.index
	end)

	if #list == 0 then
		OutfitMsg.Text = (#outfitItems == 0) and "ما لقيت عناصر لهذا اللاعب" or "ما فيه عناصر في هذا القسم"
		OutfitMsg.Visible = true
	else
		OutfitMsg.Visible = false
	end

	for order, entry in ipairs(list) do
		local item = entry.item
		local _, badge, nameLabel = createCard(item, order)
		table.insert(outfitCards, { item = item, badge = badge })

		if not item.name and item.id then
			task.delay(order * 0.06, function()
				fetchName(item.id, function(name)
					item.name = name
					if nameLabel.Parent then
						nameLabel.Text = name
					end
				end)
			end)
		end
	end

	if not wearAllRunning then
		WearAllBtn.Text = "لبس الكل (" .. #list .. ")"
	end
end

local function setFilter(id)
	outfitFilter = id
	refreshChips()
	if outfitSource then
		renderOutfit()
	end
end

local function loadOutfit(source)
	if not outfitPlayer then
		return
	end
	outfitToken += 1
	local token = outfitToken
	outfitSource = source
	local player = outfitPlayer

	Chooser.Visible = false
	clearCards()
	OutfitMsg.Text = "جاري التحميل..."
	OutfitMsg.Visible = true
	refreshSourceButtons()

	task.spawn(function()
		local items, err
		if source == "original" then
			items, err = readOriginal(player)
		else
			items, err = readMap(player)
		end
		if token ~= outfitToken then
			return -- the user switched / closed meanwhile
		end
		if not items then
			outfitItems = {}
			OutfitMsg.Text = err or "تعذر التحميل"
			OutfitMsg.Visible = true
			return
		end
		outfitItems = items
		renderOutfit()
	end)
end

local function closeOutfit()
	outfitToken += 1
	wearCancel = true
	outfitPlayer = nil
	outfitSource = nil
	outfitItems = {}
	OutfitFrame.Visible = false
	clearCards()
end

local function openOutfit(player)
	outfitToken += 1
	outfitPlayer = player
	outfitSource = nil
	outfitItems = {}
	outfitFilter = "all"

	ChooserTitle.Text = "ملابس " .. player.DisplayName
	clearCards()
	OutfitMsg.Visible = false
	Chooser.Visible = true
	WearAllBtn.Text = "لبس الكل"
	refreshChips()
	refreshSourceButtons()
	OutfitFrame.Visible = true
end

local function wearAll()
	if wearAllRunning then
		wearCancel = true -- second tap = stop
		return
	end
	if wearBusy then
		showToast("انتظر لين يخلص اللبس...", Theme.Danger)
		return
	end
	if #outfitCards == 0 then
		return
	end

	local list = {}
	for _, entry in ipairs(outfitCards) do
		table.insert(list, entry)
	end

	wearBusy = true
	wearAllRunning = true
	wearCancel = false
	WearAllBtn.BackgroundColor3 = Theme.Danger

	task.spawn(function()
		local okCount = 0
		for i, entry in ipairs(list) do
			if wearCancel then
				break
			end
			WearAllBtn.Text = "إيقاف " .. i .. "/" .. #list
			if entry.item.kind == "skin" or entry.item.id then
				setBadge(entry.badge, "جاري...", Theme.KeyAlt)
				local ok = tryWear(entry.item)
				if ok then
					okCount += 1
					setBadge(entry.badge, "تم", Theme.Success)
				else
					setBadge(entry.badge, "فشل", Theme.Danger)
				end
				task.wait(0.2)
			end
		end

		wearBusy = false
		wearAllRunning = false
		WearAllBtn.BackgroundColor3 = Theme.Accent
		WearAllBtn.Text = "لبس الكل (" .. #list .. ")"
		showToast("تم لبس " .. okCount .. " من " .. #list, okCount > 0 and Theme.Success or Theme.Danger)
	end)
end

-- wiring
OutfitBack.MouseButton1Click:Connect(function()
	playClick()
	closeOutfit()
end)

ChooseOriginal.MouseButton1Click:Connect(function()
	playClick()
	loadOutfit("original")
end)

ChooseMap.MouseButton1Click:Connect(function()
	playClick()
	loadOutfit("map")
end)

for source, btn in pairs(SourceButtons) do
	btn.MouseButton1Click:Connect(function()
		playClick()
		loadOutfit(source)
	end)
end

for id, chip in pairs(ChipButtons) do
	chip.MouseButton1Click:Connect(function()
		playClick()
		setFilter(id)
	end)
end

WearAllBtn.MouseButton1Click:Connect(function()
	playClick()
	wearAll()
end)

table.insert(destroyCallbacks, function()
	wearCancel = true
end)

-- Player rows ----------------------------------------------------
local function matchesFilter(player, query)
	if query == "" then
		return true
	end
	local haystack = string.lower(player.DisplayName .. " " .. player.Name)
	return string.find(haystack, query, 1, true) ~= nil
end

local function applyFilter()
	local query = string.lower(SearchBox.Text)
	local shown = 0
	for _, data in pairs(playerRows) do
		local visible = matchesFilter(data.player, query)
		data.frame.Visible = visible
		if visible then
			shown += 1
		end
	end
	NoResults.Visible = shown == 0 and countRows() > 0
end

local function createPlayerRow(player, flash)
	local userId = player.UserId
	if playerRows[userId] then
		return
	end
	local isSelf = player == LocalPlayer

	local row = new("Frame", {
		Name = (isSelf and "0" or "1") .. string.lower(player.DisplayName) .. tostring(userId),
		Size = UDim2.new(1, 0, 0, 74),
		BackgroundColor3 = flash and Theme.Accent or Theme.Panel,
		BorderSizePixel = 0,
	}, PlayerScroll)
	round(row, 12)

	-- picture (tap = preview)
	local avatar = new("ImageButton", {
		Size = UDim2.fromOffset(44, 44),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -8, 0.5, 0),
		BackgroundColor3 = Theme.Key,
		Image = headshotUrl(userId),
		BorderSizePixel = 0,
	}, row)
	round(avatar, 22)
	stroke(avatar, Theme.Stroke, 2)

	new("TextLabel", {
		Size = UDim2.new(1, -138, 0, 20),
		Position = UDim2.fromOffset(78, 15),
		BackgroundTransparency = 1,
		Text = player.DisplayName .. (isSelf and "  (أنت)" or ""),
		TextColor3 = Theme.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Right,
		TextTruncate = Enum.TextTruncate.AtEnd,
	}, row)

	new("TextLabel", {
		Size = UDim2.new(1, -138, 0, 16),
		Position = UDim2.fromOffset(78, 39),
		BackgroundTransparency = 1,
		Text = "@" .. player.Name,
		TextColor3 = Theme.Muted,
		TextSize = 11,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Right,
		TextTruncate = Enum.TextTruncate.AtEnd,
	}, row)

	local function makeRowButton(text, y)
		local btn = new("TextButton", {
			Size = UDim2.fromOffset(62, 20),
			Position = UDim2.fromOffset(8, y),
			BackgroundColor3 = Theme.KeyAlt,
			Text = text,
			TextColor3 = Theme.Text,
			TextSize = 11,
			Font = Enum.Font.GothamBold,
			BorderSizePixel = 0,
			Visible = not isSelf,
		}, row)
		round(btn, 8)
		return btn
	end

	local tpBtn = makeRowButton("انتقال", 7)
	local specBtn = makeRowButton("مراقبة", 28)
	local outfitBtn = makeRowButton("ملابس", 49)

	avatar.MouseButton1Click:Connect(function()
		playClick()
		openPreview(player)
	end)
	tpBtn.MouseButton1Click:Connect(function()
		playClick()
		teleportToPlayer(player)
	end)
	specBtn.MouseButton1Click:Connect(function()
		playClick()
		toggleSpectate(player)
	end)
	outfitBtn.MouseButton1Click:Connect(function()
		playClick()
		openOutfit(player)
	end)

	if flash then
		TweenService:Create(row, TweenInfo.new(1.2), { BackgroundColor3 = Theme.Panel }):Play()
	end

	playerRows[userId] = { player = player, frame = row, specBtn = specBtn }
	updateCount()
	applyFilter()
	refreshPlayerButtons()
end

local function removePlayerRow(player)
	local data = playerRows[player.UserId]
	if data then
		data.frame:Destroy()
		playerRows[player.UserId] = nil
	end
	if spectatingPlayer == player then
		stopSpectate()
	end
	if previewPlayer == player then
		closePreview()
	end
	updateCount()
	applyFilter()
end

----------------------------------------------------------------
-- Players page: wiring
----------------------------------------------------------------
SearchBox:GetPropertyChangedSignal("Text"):Connect(applyFilter)

SpectateStop.MouseButton1Click:Connect(function()
	playClick()
	stopSpectate()
	showToast("أوقفت المراقبة")
end)
SpectatePrev.MouseButton1Click:Connect(function()
	playClick()
	cycleSpectate(-1)
end)
SpectateNext.MouseButton1Click:Connect(function()
	playClick()
	cycleSpectate(1)
end)

for mode, btn in pairs(ModeButtons) do
	btn.MouseButton1Click:Connect(function()
		playClick()
		if previewPlayer then
			setPreviewMode(mode)
		end
	end)
end

PreviewTpBtn.MouseButton1Click:Connect(function()
	playClick()
	if previewPlayer then
		teleportToPlayer(previewPlayer)
	end
end)

PreviewSpecBtn.MouseButton1Click:Connect(function()
	playClick()
	if previewPlayer then
		toggleSpectate(previewPlayer)
	end
end)

PreviewOutfitBtn.MouseButton1Click:Connect(function()
	playClick()
	if previewPlayer then
		local target = previewPlayer
		closePreview()
		openOutfit(target)
	end
end)

PreviewCopyBtn.MouseButton1Click:Connect(function()
	playClick()
	if not previewPlayer then
		return
	end
	if typeof(setclipboard) == "function" then
		pcall(setclipboard, previewPlayer.Name)
		showToast("تم نسخ اليوزر", Theme.Success)
	else
		showToast("النسخ غير مدعوم في الاكسكيوتر", Theme.Danger)
	end
end)

PreviewBackBtn.MouseButton1Click:Connect(function()
	playClick()
	closePreview()
end)

-- live join / leave
for _, player in ipairs(Players:GetPlayers()) do
	createPlayerRow(player, false)
end

track(Players.PlayerAdded:Connect(function(player)
	createPlayerRow(player, true)
	if isOpen and currentPage == "players" then
		showToast("انضم: " .. player.DisplayName, Theme.Success)
	end
end))

track(Players.PlayerRemoving:Connect(function(player)
	removePlayerRow(player)
	if isOpen and currentPage == "players" then
		showToast("غادر: " .. player.DisplayName, Theme.Danger)
	end
end))

-- if you respawn, the game resets your camera: forget the spectate state
track(LocalPlayer.CharacterAdded:Connect(function()
	if spectatingPlayer then
		stopSpectate(true)
	end
end))

-- cleanup when the GUI is destroyed (e.g. script executed again)
table.insert(destroyCallbacks, function()
	stopSpectate()
	clearMapPreview()
end)

----------------------------------------------------------------
-- Page switching
----------------------------------------------------------------
function showPage(name)
	currentPage = name
	Content.Visible = name == "keyboard"
	SettingsPage.Visible = name == "settings"
	SavedPage.Visible = name == "saved"
	PlayersPage.Visible = name == "players"
	if name ~= "players" then
		closePreview()
		closeOutfit()
	end
	if name ~= "keyboard" then
		TextBox:ReleaseFocus()
		stopHold()
	end
	refreshPills()
end

SettingsPill.MouseButton1Click:Connect(function()
	playClick()
	showPage(currentPage == "settings" and "keyboard" or "settings")
end)

SavedPill.MouseButton1Click:Connect(function()
	playClick()
	showPage(currentPage == "saved" and "keyboard" or "saved")
end)

PlayersPill.MouseButton1Click:Connect(function()
	playClick()
	showPage(currentPage == "players" and "keyboard" or "players")
end)

----------------------------------------------------------------
-- Send logic
----------------------------------------------------------------
local resultToken = 0

local function showResult(ok)
	resultToken += 1
	local token = resultToken
	sendBusy = true
	SendButton.Text = ok and "تم" or "فشل"
	SendButton.BackgroundColor3 = ok and Theme.Success or Theme.Danger
	task.delay(1.3, function()
		if token == resultToken then
			sendBusy = false
			SendButton.Text = "إرسال"
			SendButton.BackgroundColor3 = Theme.Accent
		end
	end)
end

-- Returns the Sign tool from the character (equips it from the Backpack if needed)
local function getSignTool()
	local char = LocalPlayer.Character
	if not char then
		return nil
	end

	local sign = char:FindFirstChild("Sign")
	if sign then
		return sign
	end

	local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
	local tool = backpack and backpack:FindFirstChild("Sign")
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if tool and humanoid then
		humanoid:EquipTool(tool)
		return char:WaitForChild("Sign", 2)
	end
	return nil
end

-- Cuts the text to the command's max length (0 = unlimited)
local function limitText(text, limit)
	if limit > 0 and textLength(text) > limit then
		local ok, offset = pcall(utf8.offset, text, limit + 1)
		if ok and offset then
			return string.sub(text, 1, offset - 1)
		end
	end
	return text
end

local function sendCommand()
	local command = Settings.SelectedCommand
	local text = limitText(TextBox.Text, Config.MaxLength[command] or 0)

	task.spawn(function()
		local ok = false

		if command == "RolePlayName" or command == "RolePlayBio" then
			local folder = ReplicatedStorage:WaitForChild("RE", 3)
			local remote = folder and folder:WaitForChild("1RPNam1eTex1t", 3)
			if remote then
				ok = pcall(function()
					remote:FireServer(command, text)
				end)
			end

		elseif command == "Sign" then
			local sign = getSignTool()
			local remote = sign and sign:WaitForChild("ToolSound", 3)
			if remote then
				ok = pcall(function()
					remote:FireServer("Sign", "SignWords", text)
				end)
			end
		end

		showResult(ok)

		if ok then
			if Settings.ClearAfterSend then
				TextBox.Text = ""
			end
			if Settings.AutoCloseOnSend then
				task.delay(0.6, function()
					if isOpen then
						setOpen(false)
					end
				end)
			end
		end
	end)
end

SendButton.MouseButton1Click:Connect(function()
	playClick()
	sendCommand()
end)

ClearButton.MouseButton1Click:Connect(function()
	playClick()
	TextBox.Text = ""
end)

----------------------------------------------------------------
-- Toggle button (square, rounded, draggable) with drawn icons
----------------------------------------------------------------
local TOGGLE_SIZE = Vector2.new(50, 50)

local ToggleButton = new("TextButton", {
	Name = "ToggleButton",
	Size = UDim2.fromOffset(TOGGLE_SIZE.X, TOGGLE_SIZE.Y),
	AnchorPoint = Vector2.new(1, 0.5),
	Position = posFromTable(Store.positions.toggle, DEFAULT_TOGGLE_POS),
	BackgroundColor3 = Theme.Danger,
	Text = "",
	BorderSizePixel = 0,
	ZIndex = 10,
}, ScreenGui)
round(ToggleButton, 14)
stroke(ToggleButton, Theme.Text, 2, 0.75)

-- Close icon: an X made from two rotated bars
local CloseIcon = new("Frame", {
	Name = "CloseIcon",
	Size = UDim2.fromOffset(22, 22),
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	BackgroundTransparency = 1,
	ZIndex = 11,
}, ToggleButton)

for _, rotation in ipairs({ 45, -45 }) do
	local bar = new("Frame", {
		Size = UDim2.fromOffset(26, 4),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Rotation = rotation,
		BackgroundColor3 = Theme.Text,
		BorderSizePixel = 0,
		ZIndex = 11,
	}, CloseIcon)
	round(bar, 2)
end

-- Keyboard icon: outlined box with small keys and a space bar
local KeyboardIcon = new("Frame", {
	Name = "KeyboardIcon",
	Size = UDim2.fromOffset(30, 20),
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	BackgroundTransparency = 1,
	Visible = false,
	ZIndex = 11,
}, ToggleButton)
round(KeyboardIcon, 4)
stroke(KeyboardIcon, Theme.Text, 2)

for rowIdx = 0, 1 do
	for colIdx = 0, 3 do
		new("Frame", {
			Size = UDim2.fromOffset(3, 3),
			Position = UDim2.fromOffset(5 + colIdx * 6, 4 + rowIdx * 5),
			BackgroundColor3 = Theme.Text,
			BorderSizePixel = 0,
			ZIndex = 11,
		}, KeyboardIcon)
	end
end
new("Frame", {
	Size = UDim2.fromOffset(14, 3),
	Position = UDim2.fromOffset(8, 13),
	BackgroundColor3 = Theme.Text,
	BorderSizePixel = 0,
	ZIndex = 11,
}, KeyboardIcon)

local toggleDrag = makeDraggable(ToggleButton, ToggleButton, function()
	return TOGGLE_SIZE
end, function()
	Store.positions.toggle = posToTable(ToggleButton.Position)
	saveStore()
end)

onTheme(function()
	ToggleButton.BackgroundColor3 = isOpen and Theme.Danger or Theme.Accent
end)

----------------------------------------------------------------
-- Layout control (clamp, size, open/close)
----------------------------------------------------------------
-- Keeps both the panel and the toggle button fully on screen
function reclamp()
	MainFrame.Position = clampedPosition(MainFrame.Position, MainFrame.AnchorPoint, getPanelSize())
	ToggleButton.Position = clampedPosition(ToggleButton.Position, ToggleButton.AnchorPoint, TOGGLE_SIZE)
end

function applyPanelSize()
	computePanelSize()
	MainFrame.Size = UDim2.fromOffset(panelWidth, panelHeight)
	if isOpen then
		MainScale.Scale = Settings.PanelScale
	end
	reclamp()
end

function setOpen(state)
	isOpen = state

	CloseIcon.Visible = state
	KeyboardIcon.Visible = not state
	TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
		BackgroundColor3 = state and Theme.Danger or Theme.Accent,
	}):Play()

	if state then
		reclamp()
		MainFrame.Visible = true
		MainScale.Scale = Settings.PanelScale * 0.85
		TweenService:Create(MainScale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Scale = Settings.PanelScale,
		}):Play()
	else
		TextBox:ReleaseFocus() -- also hides the phone's native keyboard
		closePreview()
		closeOutfit()
		stopHold()
		TweenService:Create(MainScale, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Scale = Settings.PanelScale * 0.85,
		}):Play()
		task.delay(0.15, function()
			if not isOpen then
				MainFrame.Visible = false
			end
		end)
	end
end

ToggleButton.MouseButton1Click:Connect(function()
	if toggleDrag.moved then
		return -- it was a drag, not a tap
	end
	playClick()
	setOpen(not isOpen)
end)

----------------------------------------------------------------
-- Reset (asks to press twice)
----------------------------------------------------------------
local function resetAll()
	for key, value in pairs(Defaults) do
		Settings[key] = value
	end
	Store.positions = {}
	setThemeAccent(Settings.AccentIndex)
	applyVolume()
	TextBox.TextEditable = Settings.AllowSystemKeyboard
	MainFrame.Position = DEFAULT_PANEL_POS
	ToggleButton.Position = DEFAULT_TOGGLE_POS
	applyPanelSize()
	refreshTheme()
	updateCounter()
	saveStore()
end

local resetToken = 0

ResetButton.MouseButton1Click:Connect(function()
	playClick()
	if ResetButton.Text == "إعادة الضبط" then
		resetToken += 1
		local token = resetToken
		ResetButton.Text = "اضغط مرة ثانية للتأكيد"
		task.delay(2, function()
			if token == resetToken then
				ResetButton.Text = "إعادة الضبط"
			end
		end)
	else
		resetToken += 1
		ResetButton.Text = "إعادة الضبط"
		resetAll()
	end
end)

----------------------------------------------------------------
-- Init
----------------------------------------------------------------
renderSaved()
track(ScreenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(reclamp))
reclamp()
