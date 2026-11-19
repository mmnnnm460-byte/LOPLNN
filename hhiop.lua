--// UI Library v2
local Library = {}

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

Library.Theme = {
	Background = Color3.fromRGB(35, 35, 48),
	Topbar = Color3.fromRGB(28, 28, 39),
	Element = Color3.fromRGB(45, 45, 62),
	ElementHover = Color3.fromRGB(58, 58, 80),
	Accent = Color3.fromRGB(120, 100, 255),
	Indicator = Color3.fromRGB(120, 100, 255), -- لون شريط التبويب
	Text = Color3.fromRGB(235, 235, 245),
	SubText = Color3.fromRGB(160, 160, 180),
	Corner = 6,
	WindowCorner = 10,
}
local Theme = Library.Theme

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

--// Elements
local function attachElements(obj, container, Window, counter)
	counter = counter or {n = 0}
	local function nextOrder()
		counter.n += 1
		return counter.n
	end
	obj._nextOrder = nextOrder

	local function newElement(height)
		local f = Create("Frame", {
			Size = UDim2.new(1, 0, 0, height or 32),
			BackgroundColor3 = Theme.Element,
			LayoutOrder = nextOrder(),
			Parent = container,
		})
		corner(f)
		return f
	end

	local function nameLabel(parent, text, width)
		return Create("TextLabel", {
			Size = UDim2.new(width or 1, -20, 0, 32),
			Position = UDim2.fromOffset(10, 0),
			BackgroundTransparency = 1,
			Text = text,
			TextColor3 = Theme.Text,
			Font = Enum.Font.Gotham,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
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
		local f = newElement(32)
		local hover = false
		local btn = Create("TextButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = o.Name or "Button",
			TextColor3 = Theme.Text,
			Font = Enum.Font.Gotham,
			TextSize = 13,
			Parent = f,
		})
		btn.MouseEnter:Connect(function()
			hover = true
			tween(f, {BackgroundColor3 = Theme.ElementHover})
		end)
		btn.MouseLeave:Connect(function()
			hover = false
			tween(f, {BackgroundColor3 = Theme.Element})
		end)
		-- الجوال: ما فيه MouseLeave، فنرجع اللون عند رفع الاصبع
		btn.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.Touch then
				hover = false
				tween(f, {BackgroundColor3 = Theme.Element})
			end
		end)
		btn.MouseButton1Click:Connect(function()
			tween(f, {BackgroundColor3 = Theme.Accent}, 0.08)
			task.delay(0.12, function()
				tween(f, {BackgroundColor3 = hover and Theme.ElementHover or Theme.Element})
			end)
			safe(o.Callback)
		end)
		return {SetText = function(_, t) btn.Text = t end}
	end

	function obj:AddToggle(o)
		o = o or {}
		local state = o.Default == true
		local f = newElement(32)
		local btn = Create("TextButton", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", Parent = f})
		nameLabel(f, o.Name or "Toggle", 1)
		local sw = Create("Frame", {
			Size = UDim2.fromOffset(34, 18),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -10, 0.5, 0),
			BackgroundColor3 = Theme.Background,
			Parent = f,
		})
		corner(sw, 9)
		local knob = Create("Frame", {
			Size = UDim2.fromOffset(14, 14),
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 2, 0.5, 0),
			BackgroundColor3 = Theme.Text,
			Parent = sw,
		})
		corner(knob, 7)

		local T = {}
		local function render()
			tween(sw, {BackgroundColor3 = state and Theme.Accent or Theme.Background})
			tween(knob, {Position = state and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)})
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
		local f = newElement(46)
		local lbl = Create("TextLabel", {
			Size = UDim2.new(1, -20, 0, 24),
			Position = UDim2.fromOffset(10, 2),
			BackgroundTransparency = 1,
			TextColor3 = Theme.Text,
			Font = Enum.Font.Gotham,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = f,
		})
		local bar = Create("Frame", {
			Size = UDim2.new(1, -20, 0, 6),
			Position = UDim2.new(0, 10, 1, -14),
			BackgroundColor3 = Theme.Background,
			Parent = f,
		})
		corner(bar, 3)
		local fill = Create("Frame", {Size = UDim2.fromScale(0, 1), BackgroundColor3 = Theme.Accent, Parent = bar})
		corner(fill, 3)

		local S = {}
		function S:Set(v, silent)
			v = math.clamp(v, min, max)
			v = math.floor(v / inc + 0.5) * inc
			v = tonumber(string.format("%.4f", v))
			value = v
			fill.Size = UDim2.fromScale((v - min) / (max - min), 1)
			lbl.Text = (o.Name or "Slider") .. ": " .. tostring(v) .. (o.Suffix or "")
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
				setScroll(false) -- يمنع سحب الصفحة وقت تحريك السلايدر
				fromInput(i.Position.X)
			end
		end)
		Window:_connect(UIS.InputChanged, function(i)
			if dragging and isMove(i) then
				fromInput(i.Position.X)
			end
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
		local f = newElement(32)
		nameLabel(f, o.Name or "TextBox", 0.5)
		local box = Create("TextBox", {
			Size = UDim2.new(0.5, -16, 0, 22),
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
		local f = newElement(32)
		nameLabel(f, o.Name or "Keybind", 0.6)
		local kb = Create("TextButton", {
			Size = UDim2.fromOffset(80, 22),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -6, 0.5, 0),
			BackgroundColor3 = Theme.Background,
			Text = key.Name,
			TextColor3 = Theme.Text,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			Parent = f,
		})
		corner(kb, 4)
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
		local f = newElement(32)
		f.ClipsDescendants = true

		local header = Create("TextButton", {Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, Text = "", Parent = f})
		local lbl = nameLabel(header, "", 1)
		local arrow = Create("TextLabel", {
			Size = UDim2.fromOffset(20, 32),
			Position = UDim2.new(1, -24, 0, 0),
			BackgroundTransparency = 1,
			Text = "▼",
			TextColor3 = Theme.SubText,
			TextSize = 10,
			Font = Enum.Font.Gotham,
			Parent = header,
		})
		local list = Create("ScrollingFrame", {
			Size = UDim2.new(1, -12, 1, -38),
			Position = UDim2.fromOffset(6, 34),
			BackgroundTransparency = 1,
			ScrollBarThickness = 3,
			CanvasSize = UDim2.new(),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Parent = f,
		})
		Create("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = list})

		local D = {}
		local function updateLabel()
			lbl.Text = (o.Name or "Dropdown") .. ": " .. (selected ~= nil and tostring(selected) or "—")
		end
		local function openHeight() return 38 + math.min(#options, 5) * 24 end

		function D:Set(v, silent)
			selected = v
			updateLabel()
			if o.Flag then Window.Flags[o.Flag] = v end
			if not silent then safe(o.Callback, v) end
		end
		function D:Get() return selected end
		function D:Refresh(newOptions)
			options = newOptions or {}
			for _, c in ipairs(list:GetChildren()) do
				if c:IsA("TextButton") then c:Destroy() end
			end
			for i, opt in ipairs(options) do
				local b = Create("TextButton", {
					Size = UDim2.new(1, -4, 0, 22),
					BackgroundColor3 = Theme.Background,
					Text = tostring(opt),
					TextColor3 = Theme.Text,
					Font = Enum.Font.Gotham,
					TextSize = 12,
					LayoutOrder = i,
					Parent = list,
				})
				corner(b, 4)
				b.MouseButton1Click:Connect(function()
					D:Set(opt)
					open = false
					arrow.Text = "▼"
					tween(f, {Size = UDim2.new(1, 0, 0, 32)})
				end)
			end
			if open then f.Size = UDim2.new(1, 0, 0, openHeight()) end
		end
		header.MouseButton1Click:Connect(function()
			open = not open
			arrow.Text = open and "▲" or "▼"
			tween(f, {Size = UDim2.new(1, 0, 0, open and openHeight() or 32)})
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
	local size = opts.Size or UDim2.fromOffset(480, 320)
	local toggleKey = opts.ToggleKey or Enum.KeyCode.RightShift
	local R = Theme.WindowCorner

	function Window:_connect(sig, fn)
		local c = sig:Connect(fn)
		table.insert(self._conns, c)
		return c
	end

	local gui = Create("ScreenGui", {
		Name = opts.Name or "Library",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 100,
		Parent = getParent(),
	})
	Window.Gui = gui

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

	-- الشريط العلوي (حواف مدورة من فوق فقط)
	local top = Create("Frame", {Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = Theme.Topbar, Parent = main})
	corner(top, R)
	local topFill = Create("Frame", {
		Size = UDim2.new(1, 0, 0, R),
		Position = UDim2.new(0, 0, 1, -R),
		BackgroundColor3 = Theme.Topbar,
		Parent = top,
	})
	Create("TextLabel", {
		Size = UDim2.new(1, -80, 1, 0),
		Position = UDim2.fromOffset(14, 0),
		BackgroundTransparency = 1,
		Text = opts.Title or "Library",
		TextColor3 = Theme.Text,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = top,
	})
	local function topButton(text, x)
		return Create("TextButton", {
			Size = UDim2.fromOffset(32, 32),
			Position = UDim2.new(1, x, 0, 0),
			BackgroundTransparency = 1,
			Text = text,
			TextColor3 = Theme.SubText,
			Font = Enum.Font.GothamBold,
			TextSize = 16,
			Parent = top,
		})
	end
	local closeBtn = topButton("×", -34)
	local minBtn = topButton("–", -66)

	local body = Create("Frame", {
		Size = UDim2.new(1, 0, 1, -32),
		Position = UDim2.fromOffset(0, 32),
		BackgroundTransparency = 1,
		Parent = main,
	})

	-- الشريط الجانبي (حافة مدورة تحت يسار فقط)
	local side = Create("Frame", {
		Size = UDim2.new(0, 110, 1, 0),
		BackgroundColor3 = Theme.Topbar,
		Parent = body,
	})
	corner(side, R)
	Create("Frame", {Size = UDim2.new(1, 0, 0, R), BackgroundColor3 = Theme.Topbar, Parent = side})
	Create("Frame", {
		Size = UDim2.new(0, R, 1, 0),
		Position = UDim2.new(1, -R, 0, 0),
		BackgroundColor3 = Theme.Topbar,
		Parent = side,
	})
	local tabBar = Create("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Parent = side,
	})
	Create("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = tabBar})
	Create("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), Parent = tabBar})

	local pages = Create("Frame", {
		Size = UDim2.new(1, -110, 1, 0),
		Position = UDim2.fromOffset(110, 0),
		BackgroundTransparency = 1,
		Parent = body,
	})

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
		topFill.Visible = not minimized -- وهي مصغرة تصير كل الحواف مدورة
		tween(main, {Size = minimized and UDim2.new(size.X.Scale, size.X.Offset, 0, 32) or size}, 0.2)
	end)
	closeBtn.MouseButton1Click:Connect(function() Window:Destroy() end)
	Window:_connect(UIS.InputBegan, function(i, gp)
		if not gp and i.KeyCode == toggleKey then gui.Enabled = not gui.Enabled end
	end)

	function Window:Destroy()
		for _, c in ipairs(self._conns) do c:Disconnect() end
		gui:Destroy()
	end
	function Window:Toggle() gui.Enabled = not gui.Enabled end

	-- notifications
	local holder = Create("Frame", {
		Size = UDim2.new(0, 260, 1, -20),
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
		local f = Create("Frame", {Size = UDim2.new(1, 0, 0, 52), BackgroundColor3 = Theme.Background, Parent = holder})
		corner(f, 8)
		local accentBar = Create("Frame", {
			Size = UDim2.new(0, 3, 1, -16),
			Position = UDim2.fromOffset(8, 8),
			BackgroundColor3 = Theme.Accent,
			Parent = f,
		})
		corner(accentBar, 2)
		Create("TextLabel", {
			Size = UDim2.new(1, -28, 0, 20), Position = UDim2.fromOffset(20, 6), BackgroundTransparency = 1,
			Text = n.Title or "Notification", TextColor3 = Theme.Text, Font = Enum.Font.GothamBold,
			TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = f,
		})
		Create("TextLabel", {
			Size = UDim2.new(1, -28, 0, 20), Position = UDim2.fromOffset(20, 26), BackgroundTransparency = 1,
			Text = n.Content or "", TextColor3 = Theme.SubText, Font = Enum.Font.Gotham,
			TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = f,
		})
		task.delay(n.Duration or 4, function()
			if f.Parent then
				tween(f, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}, 0.2)
				task.wait(0.25)
				f:Destroy()
			end
		end)
	end

	-- tabs
	function Window:AddTab(name)
		local Tab = {}
		local counter = {n = 0}

		local btn = Create("TextButton", {
			Size = UDim2.new(1, 0, 0, 32),
			BackgroundColor3 = Theme.Element,
			BackgroundTransparency = 1,
			Text = name or "Tab",
			TextColor3 = Theme.SubText,
			Font = Enum.Font.Gotham,
			TextSize = 13,
			LayoutOrder = #Window._tabs + 1,
			Parent = tabBar,
		})
		corner(btn)

		-- الشريط اللي يطلع على التبويب المحدد
		local indicator = Create("Frame", {
			Size = UDim2.fromOffset(3, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 5, 0.5, 0),
			BackgroundColor3 = Theme.Indicator,
			BackgroundTransparency = 1,
			Parent = btn,
		})
		corner(indicator, 2)

		local page = Create("ScrollingFrame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ScrollBarThickness = 3,
			CanvasSize = UDim2.new(),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Visible = false,
			Parent = pages,
		})
		Create("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = page})
		Create("UIPadding", {
			PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8),
			PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 10), Parent = page,
		})

		table.insert(Window._tabs, {Button = btn, Page = page, Bar = indicator})

		function Tab:Select()
			for _, t in ipairs(Window._tabs) do
				t.Page.Visible = false
				tween(t.Button, {BackgroundTransparency = 1, TextColor3 = Theme.SubText})
				tween(t.Bar, {Size = UDim2.fromOffset(3, 0), BackgroundTransparency = 1})
			end
			page.Visible = true
			tween(btn, {BackgroundTransparency = 0, TextColor3 = Theme.Text})
			tween(indicator, {Size = UDim2.fromOffset(3, 20), BackgroundTransparency = 0}, 0.2)
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
				TextColor3 = Theme.Accent,
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
