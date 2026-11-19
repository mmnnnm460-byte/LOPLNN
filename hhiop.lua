--// UI Library v3 (Black & White + Icons)
local Library = {}

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

Library.Theme = {
	Background = Color3.fromRGB(14, 14, 14),
	Topbar = Color3.fromRGB(8, 8, 8),
	Element = Color3.fromRGB(26, 26, 26),
	ElementHover = Color3.fromRGB(40, 40, 40),
	Stroke = Color3.fromRGB(52, 52, 52),
	Accent = Color3.fromRGB(255, 255, 255),
	AccentText = Color3.fromRGB(10, 10, 10),
	Indicator = Color3.fromRGB(255, 255, 255),
	Text = Color3.fromRGB(245, 245, 245),
	SubText = Color3.fromRGB(145, 145, 145),
	Corner = 6,
	WindowCorner = 12,
}
local Theme = Library.Theme

-- أسماء جاهزة (رموز نصية). تقدر تضيف عليها أو تحط rbxassetid
Library.Icons = {
	home = "⌂", settings = "⚙", star = "★", user = "☺", target = "◎",
	eye = "◉", sword = "⚔", bolt = "ϟ", check = "✓", info = "ℹ",
	misc = "✦", list = "☰",
}

--// Helpers
local function Create(class, props, children)
	local inst = Instance.new(class)
	if inst:IsA("GuiObject") then inst.BorderSizePixel = 0 end
	local parent
	for k, v in pairs(props or {}) do
		if k == "Parent" then parent = v else inst[k] = v end
	end
	for _, c in ipairs(children or {}) do c.Parent = inst end
	inst.Parent = parent
	return inst
end

local function corner(inst, r)
	Create("UICorner", {CornerRadius = UDim.new(0, r or Theme.Corner), Parent = inst})
end

local function stroke(inst, color, thickness)
	return Create("UIStroke", {
		Color = color or Theme.Stroke,
		Thickness = thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = inst,
	})
end

local function tween(inst, props, t)
	TweenService:Create(inst, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad), props):Play()
end

local function safe(cb, ...)
	if typeof(cb) == "function" then
		local ok, err = pcall(cb, ...)
		if not ok then warn("[Library] " .. tostring(err)) end
	end
end

local function getParent()
	if gethui then
		local ok, r = pcall(gethui)
		if ok and r then return r end
	end
	return Players.LocalPlayer:WaitForChild("PlayerGui")
end

local function isPress(i)
	return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
end

local function isMove(i)
	return i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch
end

--// Icons
local function resolveIcon(icon)
	if icon == nil or icon == "" then return nil end
	icon = Library.Icons[icon] or icon
	if typeof(icon) == "number" then return "image", "rbxassetid://" .. icon end
	if typeof(icon) == "string" then
		if icon:match("^%d+$") then return "image", "rbxassetid://" .. icon end
		if icon:match("^rbxasset") then return "image", icon end
		return "text", icon
	end
	return nil
end

local function makeIcon(parent, icon, px, color)
	local kind, value = resolveIcon(icon)
	if not kind then return nil end
	if kind == "image" then
		return Create("ImageLabel", {
			Size = UDim2.fromOffset(px, px),
			BackgroundTransparency = 1,
			Image = value,
			ImageColor3 = color or Theme.Text,
			Parent = parent,
		})
	end
	return Create("TextLabel", {
		Size = UDim2.fromOffset(px, px),
		BackgroundTransparency = 1,
		Text = value,
		TextColor3 = color or Theme.Text,
		Font = Enum.Font.GothamBold,
		TextSize = px,
		Parent = parent,
	})
end

local function iconProp(ic)
	return ic:IsA("ImageLabel") and "ImageColor3" or "TextColor3"
end

local function tintIcon(ic, color, t)
	if ic then tween(ic, {[iconProp(ic)] = color}, t) end
end

--// Elements
local function attachElements(obj, container, Window, counter)
	counter = counter or {n = 0}
	local function nextOrder() counter.n += 1 return counter.n end
	obj._nextOrder = nextOrder

	local function newElement(height)
		local f = Create("Frame", {
			Size = UDim2.new(1, 0, 0, height or 34),
			BackgroundColor3 = Theme.Element,
			LayoutOrder = nextOrder(),
			Parent = container,
		})
		corner(f)
		stroke(f)
		return f
	end

	-- اسم العنصر (مع ايقونة اذا موجودة)
	local function nameLabel(parent, o, default, width, rowH)
		rowH = rowH or 34
		local x = 12
		if o.Icon then
			local ic = makeIcon(parent, o.Icon, 16, Theme.SubText)
			if ic then
				ic.AnchorPoint = Vector2.new(0, 0.5)
				ic.Position = UDim2.new(0, 12, 0, rowH / 2)
				x = 36
			end
		end
		return Create("TextLabel", {
			Size = UDim2.new(width or 1, -(x + 8), 0, rowH),
			Position = UDim2.fromOffset(x, 0),
			BackgroundTransparency = 1,
			Text = o.Name or default,
			TextColor3 = Theme.Text,
			Font = Enum.Font.Gotham,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = parent,
		})
	end

	function obj:AddLabel(text)
		local l = Create("TextLabel", {
			Size = UDim2.new(1, 0, 0, 20),
			BackgroundTransparency = 1,
			Text = text or "Label",
			TextColor3 = Theme.SubText,
			Font = Enum.Font.Gotham,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = nextOrder(),
			Parent = container,
		})
		return {Set = function(_, t) l.Text = t end}
	end

	function obj:AddButton(o)
		o = o or {}
		local f = newElement(34)
		local hover = false
		local btn = Create("TextButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = o.Name or "Button",
			TextColor3 = Theme.Text,
			Font = Enum.Font.Gotham,
			TextSize = 13,
			AutoButtonColor = false,
			Parent = f,
		})
		local ic = o.Icon and makeIcon(btn, o.Icon, 16, Theme.SubText)
		if ic then
			ic.AnchorPoint = Vector2.new(0, 0.5)
			ic.Position = UDim2.new(0, 12, 0.5, 0)
		end
		btn.MouseEnter:Connect(function()
			hover = true
			tween(f, {BackgroundColor3 = Theme.ElementHover})
		end)
		btn.MouseLeave:Connect(function()
			hover = false
			tween(f, {BackgroundColor3 = Theme.Element})
		end)
		btn.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.Touch then
				hover = false
				tween(f, {BackgroundColor3 = Theme.Element})
			end
		end)
		btn.MouseButton1Click:Connect(function()
			tween(f, {BackgroundColor3 = Theme.Accent}, 0.06)
			tween(btn, {TextColor3 = Theme.AccentText}, 0.06)
			tintIcon(ic, Theme.AccentText, 0.06)
			task.delay(0.12, function()
				tween(f, {BackgroundColor3 = hover and Theme.ElementHover or Theme.Element}, 0.2)
				tween(btn, {TextColor3 = Theme.Text}, 0.2)
				tintIcon(ic, Theme.SubText, 0.2)
			end)
			safe(o.Callback)
		end)
		return {SetText = function(_, t) btn.Text = t end}
	end

	function obj:AddToggle(o)
		o = o or {}
		local state = o.Default == true
		local f = newElement(34)
		local btn = Create("TextButton", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Parent = f})
		nameLabel(f, o, "Toggle", 1)
		local sw = Create("Frame", {
			Size = UDim2.fromOffset(36, 20),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -10, 0.5, 0),
			BackgroundColor3 = Theme.Background,
			Parent = f,
		})
		corner(sw, 10)
		stroke(sw)
		local knob = Create("Frame", {
			Size = UDim2.fromOffset(14, 14),
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 3, 0.5, 0),
			BackgroundColor3 = Theme.SubText,
			Parent = sw,
		})
		corner(knob, 7)

		local T = {}
		local function render()
			tween(sw, {BackgroundColor3 = state and Theme.Accent or Theme.Background})
			tween(knob, {
				Position = state and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
				BackgroundColor3 = state and Theme.AccentText or Theme.SubText,
			})
		end
		function T:Set(v, silent)
			state = v and true or false
			render()
			if o.Flag then Window.Flags[o.Flag] = state end
			if not silent then safe(o.Callback, state) end
		end
		function T:Get() return state end
		btn.MouseButton1Click:Connect(function() T:Set(not state) end)
		T:Set(state, true)
		return T
	end

	function obj:AddSlider(o)
		o = o or {}
		local min, max = o.Min or 0, o.Max or 100
		local inc = o.Increment or 1
		local value = o.Default or min
		local f = newElement(52)
		nameLabel(f, o, "Slider", 0.7, 30)
		local valLbl = Create("TextLabel", {
			Size = UDim2.new(0.3, -12, 0, 30),
			Position = UDim2.new(0.7, 0, 0, 0),
			BackgroundTransparency = 1,
			TextColor3 = Theme.SubText,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Right,
			Parent = f,
		})
		local bar = Create("Frame", {
			Size = UDim2.new(1, -24, 0, 6),
			Position = UDim2.new(0, 12, 1, -16),
			BackgroundColor3 = Theme.Background,
			Parent = f,
		})
		corner(bar, 3)
		stroke(bar)
		local fill = Create("Frame", {Size = UDim2.fromScale(0, 1), BackgroundColor3 = Theme.Accent, Parent = bar})
		corner(fill, 3)
		local knob = Create("Frame", {
			Size = UDim2.fromOffset(12, 12),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(1, 0.5),
			BackgroundColor3 = Theme.Accent,
			Parent = fill,
		})
		corner(knob, 6)

		local S = {}
		function S:Set(v, silent)
			v = math.clamp(v, min, max)
			v = min + math.floor((v - min) / inc + 0.5) * inc
			v = math.clamp(tonumber(string.format("%.4f", v)), min, max)
			value = v
			local frac = (max > min) and (v - min) / (max - min) or 0
			fill.Size = UDim2.fromScale(frac, 1)
			valLbl.Text = tostring(v) .. (o.Suffix or "")
			if o.Flag then Window.Flags[o.Flag] = v end
			if not silent then safe(o.Callback, v) end
		end
		function S:Get() return value end

		local dragging = false
		local function setScroll(on)
			local s = container:IsA("ScrollingFrame") and container or container:FindFirstAncestorWhichIsA("ScrollingFrame")
			if s then s.ScrollingEnabled = on end
		end
		local function fromInput(x)
			local rel = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
			S:Set(min + (max - min) * rel)
		end
		f.InputBegan:Connect(function(i)
			if isPress(i) then
				dragging = true
				setScroll(false)
				fromInput(i.Position.X)
			end
		end)
		Window:_connect(UIS.InputChanged, function(i)
			if dragging and isMove(i) then fromInput(i.Position.X) end
		end)
		Window:_connect(UIS.InputEnded, function(i)
			if dragging and isPress(i) then
				dragging = false
				setScroll(true)
			end
		end)
		S:Set(value, true)
		return S
	end

	function obj:AddTextBox(o)
		o = o or {}
		local f = newElement(34)
		nameLabel(f, o, "TextBox", 0.5)
		local box = Create("TextBox", {
			Size = UDim2.new(0.5, -16, 0, 24),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -6, 0.5, 0),
			BackgroundColor3 = Theme.Background,
			Text = o.Default or "",
			PlaceholderText = o.Placeholder or "...",
			PlaceholderColor3 = Theme.SubText,
			TextColor3 = Theme.Text,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			ClearTextOnFocus = false,
			Parent = f,
		})
		corner(box, 4)
		stroke(box)
		box.FocusLost:Connect(function(enter)
			if o.Flag then Window.Flags[o.Flag] = box.Text end
			safe(o.Callback, box.Text, enter)
		end)
		return {
			Set = function(_, t) box.Text = t end,
			Get = function() return box.Text end,
		}
	end

	function obj:AddKeybind(o)
		o = o or {}
		local key = o.Default or Enum.KeyCode.F
		local listening = false
		local f = newElement(34)
		nameLabel(f, o, "Keybind", 0.6)
		local kb = Create("TextButton", {
			Size = UDim2.fromOffset(80, 24),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -6, 0.5, 0),
			BackgroundColor3 = Theme.Background,
			Text = key.Name,
			TextColor3 = Theme.Text,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			AutoButtonColor = false,
			Parent = f,
		})
		corner(kb, 4)
		stroke(kb)
		kb.MouseButton1Click:Connect(function()
			listening = true
			kb.Text = "..."
		end)
		Window:_connect(UIS.InputBegan, function(input, gp)
			if listening then
				if input.UserInputType == Enum.UserInputType.Keyboard then
					listening = false
					key = input.KeyCode
					kb.Text = key.Name
					if o.Flag then Window.Flags[o.Flag] = key end
					safe(o.OnChanged, key)
				end
			elseif not gp and input.KeyCode == key then
				safe(o.Callback, key)
			end
		end)
		return {
			Get = function() return key end,
			Set = function(_, k) key = k kb.Text = k.Name end,
		}
	end

	function obj:AddDropdown(o)
		o = o or {}
		local options = o.Options or {}
		local selected = o.Default
		local open = false
		local buttons = {}
		local f = newElement(34)
		f.ClipsDescendants = true

		local header = Create("TextButton", {Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Parent = f})
		nameLabel(header, o, "Dropdown", 0.55)
		local valLbl = Create("TextLabel", {
			Size = UDim2.new(0.45, -34, 0, 34),
			Position = UDim2.new(0.55, 0, 0, 0),
			BackgroundTransparency = 1,
			TextColor3 = Theme.SubText,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Right,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = header,
		})
		local arrow = Create("TextLabel", {
			Size = UDim2.fromOffset(20, 34),
			Position = UDim2.new(1, -26, 0, 0),
			BackgroundTransparency = 1,
			Text = "▼",
			TextColor3 = Theme.SubText,
			TextSize = 10,
			Font = Enum.Font.Gotham,
			Parent = header,
		})
		local list = Create("ScrollingFrame", {
			Size = UDim2.new(1, -12, 1, -44),
			Position = UDim2.fromOffset(6, 38),
			BackgroundTransparency = 1,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = Color3.fromRGB(90, 90, 90),
			CanvasSize = UDim2.new(),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Parent = f,
		})
		Create("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = list})

		local D = {}
		local function openHeight() return 44 + math.min(#options, 5) * 26 end
		local function paint()
			for opt, b in pairs(buttons) do
				local sel = opt == selected
				tween(b, {
					BackgroundColor3 = sel and Theme.Accent or Theme.Background,
					TextColor3 = sel and Theme.AccentText or Theme.Text,
				}, 0.1)
			end
		end
		local function updateLabel()
			valLbl.Text = selected ~= nil and tostring(selected) or "—"
		end

		function D:Set(v, silent)
			selected = v
			updateLabel()
			paint()
			if o.Flag then Window.Flags[o.Flag] = v end
			if not silent then safe(o.Callback, v) end
		end
		function D:Get() return selected end
		function D:Refresh(newOptions)
			options = newOptions or {}
			buttons = {}
			for _, c in ipairs(list:GetChildren()) do
				if c:IsA("TextButton") then c:Destroy() end
			end
			for i, opt in ipairs(options) do
				local b = Create("TextButton", {
					Size = UDim2.new(1, -4, 0, 24),
					BackgroundColor3 = Theme.Background,
					Text = tostring(opt),
					TextColor3 = Theme.Text,
					Font = Enum.Font.Gotham,
					TextSize = 12,
					AutoButtonColor = false,
					LayoutOrder = i,
					Parent = list,
				})
				corner(b, 4)
				buttons[opt] = b
				b.MouseButton1Click:Connect(function()
					D:Set(opt)
					open = false
					arrow.Text = "▼"
					tween(f, {Size = UDim2.new(1, 0, 0, 34)})
				end)
			end
			paint()
			if open then f.Size = UDim2.new(1, 0, 0, openHeight()) end
		end
		header.MouseButton1Click:Connect(function()
			open = not open
			arrow.Text = open and "▲" or "▼"
			tween(f, {Size = UDim2.new(1, 0, 0, open and openHeight() or 34)})
		end)

		D:Refresh(options)
		D:Set(selected, true)
		return D
	end
end

--// Window
function Library:CreateWindow(opts)
	opts = opts or {}
	local Window = {Flags = {}, _conns = {}, _tabs = {}}
	local size = opts.Size or UDim2.fromOffset(500, 330)
	local toggleKey = opts.ToggleKey or Enum.KeyCode.RightShift
	local R = Theme.WindowCorner
	local SIDE = 120
	local guiName = opts.Name or "Library"

	function Window:_connect(sig, fn)
		local c = sig:Connect(fn)
		table.insert(self._conns, c)
		return c
	end

	local parent = getParent()
	local old = parent:FindFirstChild(guiName)
	if old then old:Destroy() end -- يمنع تكرار النافذة اذا شغلت السكربت مرتين

	local gui = Create("ScreenGui", {
		Name = guiName,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 100,
		Parent = parent,
	})
	Window.Gui = gui
	gui.Destroying:Connect(function()
		for _, c in ipairs(Window._conns) do c:Disconnect() end
	end)

	local main = Create("Frame", {
		Name = "Main",
		Size = size,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundColor3 = Theme.Background,
		ClipsDescendants = true,
		Parent = gui,
	})
	corner(main, R)
	stroke(main)
	local scale = Create("UIScale", {Scale = 0.92, Parent = main})
	tween(scale, {Scale = 1}, 0.2)

	-- الشريط العلوي
	local top = Create("Frame", {Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = Theme.Topbar, Parent = main})
	corner(top, R)
	local topFill = Create("Frame", {
		Size = UDim2.new(1, 0, 0, R),
		Position = UDim2.new(0, 0, 1, -R),
		BackgroundColor3 = Theme.Topbar,
		Parent = top,
	})
	local titleX = 14
	if opts.Icon then
		local ic = makeIcon(top, opts.Icon, 16, Theme.Text)
		if ic then
			ic.AnchorPoint = Vector2.new(0, 0.5)
			ic.Position = UDim2.new(0, 14, 0.5, 0)
			titleX = 38
		end
	end
	Create("TextLabel", {
		Size = UDim2.new(1, -(titleX + 76), 1, 0),
		Position = UDim2.fromOffset(titleX, 0),
		BackgroundTransparency = 1,
		Text = opts.Title or "Library",
		TextColor3 = Theme.Text,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = top,
	})
	local function topButton(text, x)
		local b = Create("TextButton", {
			Size = UDim2.fromOffset(34, 34),
			Position = UDim2.new(1, x, 0, 0),
			BackgroundTransparency = 1,
			Text = text,
			TextColor3 = Theme.SubText,
			Font = Enum.Font.GothamBold,
			TextSize = 16,
			AutoButtonColor = false,
			Parent = top,
		})
		b.MouseEnter:Connect(function() tween(b, {TextColor3 = Theme.Text}) end)
		b.MouseLeave:Connect(function() tween(b, {TextColor3 = Theme.SubText}) end)
		return b
	end
	local closeBtn = topButton("×", -36)
	local minBtn = topButton("–", -70)
	Create("Frame", {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.fromOffset(0, 34), BackgroundColor3 = Theme.Stroke, Parent = main})

	local body = Create("Frame", {
		Size = UDim2.new(1, 0, 1, -35),
		Position = UDim2.fromOffset(0, 35),
		BackgroundTransparency = 1,
		Parent = main,
	})

	-- الشريط الجانبي
	local side = Create("Frame", {Size = UDim2.new(0, SIDE, 1, 0), BackgroundColor3 = Theme.Topbar, Parent = body})
	corner(side, R)
	Create("Frame", {Size = UDim2.new(1, 0, 0, R), BackgroundColor3 = Theme.Topbar, Parent = side})
	Create("Frame", {Size = UDim2.new(0, R, 1, 0), Position = UDim2.new(1, -R, 0, 0), BackgroundColor3 = Theme.Topbar, Parent = side})
	local tabBar = Create("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Parent = side,
	})
	Create("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = tabBar})
	Create("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = tabBar})

	local pages = Create("Frame", {
		Size = UDim2.new(1, -SIDE, 1, 0),
		Position = UDim2.fromOffset(SIDE, 0),
		BackgroundTransparency = 1,
		Parent = body,
	})
	Create("Frame", {Size = UDim2.new(0, 1, 1, 0), Position = UDim2.fromOffset(SIDE, 0), BackgroundColor3 = Theme.Stroke, Parent = body})

	-- drag
	local dragging, dragStart, startPos
	top.InputBegan:Connect(function(i)
		if isPress(i) then
			dragging, dragStart, startPos = true, i.Position, main.Position
		end
	end)
	Window:_connect(UIS.InputChanged, function(i)
		if dragging and isMove(i) then
			local d = i.Position - dragStart
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
	Window:_connect(UIS.InputEnded, function(i)
		if isPress(i) then dragging = false end
	end)

	-- minimize / close / toggle key
	local minimized = false
	minBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		body.Visible = not minimized
		topFill.Visible = not minimized
		tween(main, {Size = minimized and UDim2.new(size.X.Scale, size.X.Offset, 0, 34) or size}, 0.2)
	end)
	closeBtn.MouseButton1Click:Connect(function() Window:Destroy() end)
	Window:_connect(UIS.InputBegan, function(i, gp)
		if not gp and i.KeyCode == toggleKey then gui.Enabled = not gui.Enabled end
	end)

	function Window:Destroy() gui:Destroy() end
	function Window:Toggle() gui.Enabled = not gui.Enabled end

	-- notifications
	local holder = Create("Frame", {
		Size = UDim2.new(0, 270, 1, -20),
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -10, 1, -10),
		BackgroundTransparency = 1,
		Parent = gui,
	})
	Create("UIListLayout", {
		Padding = UDim.new(0, 6),
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = holder,
	})
	function Window:Notify(n)
		n = n or {}
		local f = Create("Frame", {
			Size = UDim2.new(1, 0, 0, 56),
			BackgroundColor3 = Theme.Background,
			ClipsDescendants = true,
			Parent = holder,
		})
		corner(f, 10)
		local st = stroke(f)
		local bar = Create("Frame", {
			Size = UDim2.new(0, 3, 1, -20),
			Position = UDim2.fromOffset(10, 10),
			BackgroundColor3 = Theme.Accent,
			Parent = f,
		})
		corner(bar, 2)
		local x = 22
		if n.Icon then
			local ic = makeIcon(f, n.Icon, 18, Theme.Text)
			if ic then
				ic.AnchorPoint = Vector2.new(0, 0.5)
				ic.Position = UDim2.new(0, 22, 0.5, 0)
				x = 48
			end
		end
		Create("TextLabel", {
			Size = UDim2.new(1, -(x + 10), 0, 20), Position = UDim2.fromOffset(x, 8), BackgroundTransparency = 1,
			Text = n.Title or "Notification", TextColor3 = Theme.Text, Font = Enum.Font.GothamBold,
			TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = f,
		})
		Create("TextLabel", {
			Size = UDim2.new(1, -(x + 10), 0, 20), Position = UDim2.fromOffset(x, 28), BackgroundTransparency = 1,
			Text = n.Content or "", TextColor3 = Theme.SubText, Font = Enum.Font.Gotham,
			TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = f,
		})
		task.delay(n.Duration or 4, function()
			if f.Parent then
				tween(f, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}, 0.2)
				tween(st, {Transparency = 1}, 0.2)
				task.wait(0.25)
				f:Destroy()
			end
		end)
	end

	-- tabs
	function Window:AddTab(name, icon)
		local Tab = {}
		local counter = {n = 0}

		local btn = Create("TextButton", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = Theme.Element,
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			LayoutOrder = #Window._tabs + 1,
			Parent = tabBar,
		})
		corner(btn)

		local ic = makeIcon(btn, icon, 16, Theme.SubText)
		local x = 14
		if ic then
			ic.AnchorPoint = Vector2.new(0, 0.5)
			ic.Position = UDim2.new(0, 14, 0.5, 0)
			x = 38
		end
		local lbl = Create("TextLabel", {
			Size = UDim2.new(1, -(x + 6), 1, 0),
			Position = UDim2.fromOffset(x, 0),
			BackgroundTransparency = 1,
			Text = name or "Tab",
			TextColor3 = Theme.SubText,
			Font = Enum.Font.GothamMedium,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = btn,
		})

		-- الشريط اللي يطلع على التبويب المحدد
		local indicator = Create("Frame", {
			Size = UDim2.fromOffset(3, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 4, 0.5, 0),
			BackgroundColor3 = Theme.Indicator,
			BackgroundTransparency = 1,
			Parent = btn,
		})
		corner(indicator, 2)

		local page = Create("ScrollingFrame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = Color3.fromRGB(90, 90, 90),
			CanvasSize = UDim2.new(),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Visible = false,
			Parent = pages,
		})
		Create("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = page})
		Create("UIPadding", {
			PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
			PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 12), Parent = page,
		})

		table.insert(Window._tabs, {Button = btn, Page = page, Bar = indicator, Label = lbl, Icon = ic})

		function Tab:Select()
			for _, t in ipairs(Window._tabs) do
				t.Page.Visible = false
				tween(t.Button, {BackgroundTransparency = 1})
				tween(t.Label, {TextColor3 = Theme.SubText})
				tintIcon(t.Icon, Theme.SubText)
				tween(t.Bar, {Size = UDim2.fromOffset(3, 0), BackgroundTransparency = 1})
			end
			page.Visible = true
			tween(btn, {BackgroundTransparency = 0})
			tween(lbl, {TextColor3 = Theme.Text})
			tintIcon(ic, Theme.Text)
			tween(indicator, {Size = UDim2.fromOffset(3, 16), BackgroundTransparency = 0}, 0.2)
		end
		btn.MouseButton1Click:Connect(function() Tab:Select() end)
		if #Window._tabs == 1 then Tab:Select() end

		attachElements(Tab, page, Window, counter)

		function Tab:AddSection(title)
			local Section = {}
			local frame = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = Tab._nextOrder(),
				Parent = page,
			})
			Create("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = frame})
			Create("TextLabel", {
				Size = UDim2.new(1, 0, 0, 18),
				BackgroundTransparency = 1,
				Text = string.upper(title or "Section"),
				TextColor3 = Theme.SubText,
				Font = Enum.Font.GothamBold,
				TextSize = 11,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = -1,
				Parent = frame,
			})
			attachElements(Section, frame, Window)
			return Section
		end

		return Tab
	end

	return Window
end

return Library
