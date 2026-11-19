--// UI Library v4 (Black & White)
-- الأيقونات: Icon = 123456789  أو  "rbxassetid://123456789"  أو  "https://.../icon.png"  أو  "folder/icon.png" (ملف من workspace)

local Library = {}

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

Library.Theme = {
	Background = Color3.fromRGB(12, 12, 12),
	Topbar = Color3.fromRGB(8, 8, 8),
	Sidebar = Color3.fromRGB(10, 10, 10),
	Element = Color3.fromRGB(22, 22, 22),
	ElementHover = Color3.fromRGB(34, 34, 34),
	Stroke = Color3.fromRGB(44, 44, 44),
	StrokeHover = Color3.fromRGB(85, 85, 85),
	Accent = Color3.fromRGB(255, 255, 255),
	AccentText = Color3.fromRGB(10, 10, 10),
	Indicator = Color3.fromRGB(255, 255, 255),
	Text = Color3.fromRGB(245, 245, 245),
	SubText = Color3.fromRGB(145, 145, 145),
	Corner = 8,
	WindowCorner = 14,
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
	return Create("UICorner", {CornerRadius = UDim.new(0, r or Theme.Corner), Parent = inst})
end

local function stroke(inst, color, thickness)
	return Create("UIStroke", {
		Color = color or Theme.Stroke,
		Thickness = thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = inst,
	})
end

local function tween(inst, props, t, style)
	TweenService:Create(inst, TweenInfo.new(t or 0.15, style or Enum.EasingStyle.Quad), props):Play()
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

--// Icons (ID / rbxassetid / رابط png / ملف png)
local urlCache = {}

local function loadIcon(img, icon)
	if typeof(icon) == "number" then
		img.Image = "rbxassetid://" .. icon
		return
	end
	if typeof(icon) ~= "string" then return end

	if icon:match("^%d+$") then
		img.Image = "rbxassetid://" .. icon
	elseif icon:match("^rbxasset") or icon:match("^rbxthumb") then
		img.Image = icon
	elseif icon:match("^https?://") then
		task.spawn(function()
			local path = urlCache[icon]
			if not path then
				if not (writefile and getcustomasset) then return end
				local name = "UILib_" .. icon:gsub("%W", ""):sub(-40) .. ".png"
				local exists = false
				if isfile then
					local okf, ex = pcall(isfile, name)
					exists = okf and ex
				end
				if not exists then
					local req = request or http_request or (syn and syn.request)
					if not req then return end
					local ok, res = pcall(req, {Url = icon, Method = "GET"})
					if not ok or not res or not res.Body or (res.StatusCode and res.StatusCode ~= 200) then return end
					if not pcall(writefile, name, res.Body) then return end
				end
				path = name
				urlCache[icon] = name
			end
			local ok2, asset = pcall(getcustomasset, path)
			if ok2 and img.Parent then img.Image = asset end
		end)
	else
		if getcustomasset and isfile then
			local okf, ex = pcall(isfile, icon)
			if okf and ex then
				local ok2, asset = pcall(getcustomasset, icon)
				if ok2 then img.Image = asset end
			end
		end
	end
end

local function makeIcon(parent, icon, px, color)
	if icon == nil or icon == "" then return nil end
	local img = Create("ImageLabel", {
		Size = UDim2.fromOffset(px, px),
		BackgroundTransparency = 1,
		ImageColor3 = color or Theme.Text,
		ScaleType = Enum.ScaleType.Fit,
		Parent = parent,
	})
	loadIcon(img, icon)
	return img
end

local function tintIcon(ic, color, t)
	if ic then tween(ic, {ImageColor3 = color}, t) end
end

--// Elements
local function attachElements(obj, container, Window, counter)
	counter = counter or {n = 0}
	local function nextOrder() counter.n += 1 return counter.n end
	obj._nextOrder = nextOrder

	local function newElement(height)
		local f = Create("Frame", {
			Size = UDim2.new(1, 0, 0, height or 36),
			BackgroundColor3 = Theme.Element,
			LayoutOrder = nextOrder(),
			Parent = container,
		})
		corner(f)
		local st = stroke(f)
		return f, st
	end

	local function hoverFx(hit, f, st)
		hit.MouseEnter:Connect(function()
			tween(f, {BackgroundColor3 = Theme.ElementHover})
			tween(st, {Color = Theme.StrokeHover})
		end)
		hit.MouseLeave:Connect(function()
			tween(f, {BackgroundColor3 = Theme.Element})
			tween(st, {Color = Theme.Stroke})
		end)
		hit.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.Touch then
				tween(f, {BackgroundColor3 = Theme.Element})
				tween(st, {Color = Theme.Stroke})
			end
		end)
	end

	local function nameLabel(parent, o, default, width, rowH)
		rowH = rowH or 36
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

	function obj:AddParagraph(o)
		o = o or {}
		local f = Create("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = Theme.Element,
			LayoutOrder = nextOrder(),
			Parent = container,
		})
		corner(f)
		stroke(f)
		Create("UIPadding", {
			PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
			PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = f,
		})
		Create("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = f})
		local t = Create("TextLabel", {
			Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, Text = o.Title or "",
			TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = 1, Parent = f,
		})
		local c = Create("TextLabel", {
			Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
			Text = o.Content or "", TextColor3 = Theme.SubText, Font = Enum.Font.Gotham, TextSize = 12,
			TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
			LayoutOrder = 2, Parent = f,
		})
		return {
			SetTitle = function(_, s) t.Text = s end,
			SetContent = function(_, s) c.Text = s end,
		}
	end

	function obj:AddSeparator()
		Create("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = Theme.Stroke,
			LayoutOrder = nextOrder(),
			Parent = container,
		})
	end

	function obj:AddButton(o)
		o = o or {}
		local f, st = newElement(36)
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
			tween(st, {Color = Theme.StrokeHover})
		end)
		btn.MouseLeave:Connect(function()
			hover = false
			tween(f, {BackgroundColor3 = Theme.Element})
			tween(st, {Color = Theme.Stroke})
		end)
		btn.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.Touch then
				hover = false
				tween(f, {BackgroundColor3 = Theme.Element})
				tween(st, {Color = Theme.Stroke})
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
		local f, st = newElement(36)
		local btn = Create("TextButton", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Parent = f})
		hoverFx(btn, f, st)
		nameLabel(f, o, "Toggle", 1)
		local sw = Create("Frame", {
			Size = UDim2.fromOffset(38, 20),
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
			tween(sw, {BackgroundColor3 = state and Theme.Accent or Theme.Background}, 0.18)
			tween(knob, {
				Position = state and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
				BackgroundColor3 = state and Theme.AccentText or Theme.SubText,
			}, 0.18, Enum.EasingStyle.Back)
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
		local f, st = newElement(54)
		hoverFx(f, f, st)
		nameLabel(f, o, "Slider", 0.7, 32)
		local valLbl = Create("TextLabel", {
			Size = UDim2.new(0.3, -12, 0, 32),
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
			Position = UDim2.new(0, 12, 1, -17),
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
				tween(knob, {Size = UDim2.fromOffset(15, 15)}, 0.1)
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
				tween(knob, {Size = UDim2.fromOffset(12, 12)}, 0.1)
			end
		end)
		S:Set(value, true)
		return S
	end

	function obj:AddTextBox(o)
		o = o or {}
		local f, st = newElement(36)
		nameLabel(f, o, "TextBox", 0.5)
		local box = Create("TextBox", {
			Size = UDim2.new(0.5, -16, 0, 26),
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
		corner(box, 5)
		local bst = stroke(box)
		box.Focused:Connect(function() tween(bst, {Color = Theme.Accent}) end)
		box.FocusLost:Connect(function(enter)
			tween(bst, {Color = Theme.Stroke})
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
		local f, st = newElement(36)
		hoverFx(f, f, st)
		nameLabel(f, o, "Keybind", 0.6)
		local kb = Create("TextButton", {
			Size = UDim2.fromOffset(80, 26),
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
		corner(kb, 5)
		stroke(kb)
		kb.MouseButton1Click:Connect(function()
			listening = true
			kb.Text = "..."
		end)
		Window:_connect(UIS.InputBegan, function(input, gp)
			if listening then
				if input.UserInputType == Enum.UserInputType.Keyboard then
					listening = false
					if input.KeyCode ~= Enum.KeyCode.Escape then key = input.KeyCode end
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
		local multi = o.Multi == true
		local selected = multi and {} or o.Default
		if multi and typeof(o.Default) == "table" then
			for _, x in ipairs(o.Default) do selected[x] = true end
		end
		local open = false
		local buttons = {}
		local f, st = newElement(36)
		f.ClipsDescendants = true

		local header = Create("TextButton", {Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Parent = f})
		hoverFx(header, f, st)
		nameLabel(header, o, "Dropdown", 0.5)
		local valLbl = Create("TextLabel", {
			Size = UDim2.new(0.5, -34, 0, 36),
			Position = UDim2.new(0.5, 0, 0, 0),
			BackgroundTransparency = 1,
			TextColor3 = Theme.SubText,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Right,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = header,
		})
		local arrow = Create("TextLabel", {
			Size = UDim2.fromOffset(20, 36),
			Position = UDim2.new(1, -26, 0, 0),
			BackgroundTransparency = 1,
			Text = "▼",
			TextColor3 = Theme.SubText,
			TextSize = 9,
			Font = Enum.Font.Gotham,
			Parent = header,
		})
		local list = Create("ScrollingFrame", {
			Size = UDim2.new(1, -12, 1, -46),
			Position = UDim2.fromOffset(6, 40),
			BackgroundTransparency = 1,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = Color3.fromRGB(90, 90, 90),
			CanvasSize = UDim2.new(),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Parent = f,
		})
		Create("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = list})

		local D = {}
		local function openHeight() return 46 + math.min(#options, 5) * 26 end
		local function isSel(opt)
			if multi then return selected[opt] == true end
			return selected == opt
		end
		local function value()
			if multi then
				local t = {}
				for _, opt in ipairs(options) do if selected[opt] then table.insert(t, opt) end end
				return t
			end
			return selected
		end
		local function paint()
			for opt, b in pairs(buttons) do
				local sel = isSel(opt)
				tween(b, {
					BackgroundColor3 = sel and Theme.Accent or Theme.Background,
					TextColor3 = sel and Theme.AccentText or Theme.Text,
				}, 0.1)
			end
		end
		local function updateLabel()
			if multi then
				local t = {}
				for _, opt in ipairs(options) do if selected[opt] then table.insert(t, tostring(opt)) end end
				valLbl.Text = #t > 0 and table.concat(t, ", ") or "—"
			else
				valLbl.Text = selected ~= nil and tostring(selected) or "—"
			end
		end
		local function fire(silent)
			updateLabel()
			paint()
			local val = value()
			if o.Flag then Window.Flags[o.Flag] = val end
			if not silent then safe(o.Callback, val) end
		end

		function D:Set(v, silent)
			if multi then
				selected = {}
				for _, x in ipairs(typeof(v) == "table" and v or {}) do selected[x] = true end
			else
				selected = v
			end
			fire(silent)
		end
		function D:Get() return value() end
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
				corner(b, 5)
				buttons[opt] = b
				b.MouseButton1Click:Connect(function()
					if multi then
						selected[opt] = not selected[opt] or nil
						fire(false)
					else
						D:Set(opt)
						open = false
						tween(arrow, {Rotation = 0})
						tween(f, {Size = UDim2.new(1, 0, 0, 36)})
					end
				end)
			end
			updateLabel()
			paint()
			if open then f.Size = UDim2.new(1, 0, 0, openHeight()) end
		end
		header.MouseButton1Click:Connect(function()
			open = not open
			tween(arrow, {Rotation = open and 180 or 0})
			tween(f, {Size = UDim2.new(1, 0, 0, open and openHeight() or 36)})
		end)

		D:Refresh(options)
		D:Set(multi and o.Default or selected, true)
		return D
	end

	function obj:AddColorPicker(o)
		o = o or {}
		local color = o.Default or Color3.fromRGB(255, 255, 255)
		local h, s, v = color:ToHSV()
		local open = false
		local f, st = newElement(36)
		f.ClipsDescendants = true

		local header = Create("TextButton", {Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Parent = f})
		hoverFx(header, f, st)
		nameLabel(header, o, "Color", 0.7)
		local preview = Create("Frame", {
			Size = UDim2.fromOffset(34, 18),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -10, 0, 18),
			BackgroundColor3 = color,
			Parent = header,
		})
		corner(preview, 5)
		stroke(preview)

		local sv = Create("Frame", {
			Size = UDim2.new(1, -20, 0, 80),
			Position = UDim2.fromOffset(10, 44),
			BackgroundColor3 = Color3.fromHSV(h, 1, 1),
			Parent = f,
		})
		corner(sv, 6)
		local white = Create("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1), Parent = sv})
		corner(white, 6)
		Create("UIGradient", {Transparency = NumberSequence.new(0, 1), Parent = white})
		local black = Create("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), Parent = sv})
		corner(black, 6)
		Create("UIGradient", {Transparency = NumberSequence.new(1, 0), Rotation = 90, Parent = black})
		local svKnob = Create("Frame", {
			Size = UDim2.fromOffset(10, 10),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(s, 1 - v),
			BackgroundColor3 = Color3.new(1, 1, 1),
			Parent = sv,
		})
		corner(svKnob, 5)
		stroke(svKnob, Color3.new(0, 0, 0), 1)

		local hue = Create("Frame", {
			Size = UDim2.new(1, -20, 0, 12),
			Position = UDim2.fromOffset(10, 132),
			BackgroundColor3 = Color3.new(1, 1, 1),
			Parent = f,
		})
		corner(hue, 6)
		local seq = {}
		for i = 0, 6 do table.insert(seq, ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(math.min(i / 6, 0.999), 1, 1))) end
		Create("UIGradient", {Color = ColorSequence.new(seq), Parent = hue})
		local hueKnob = Create("Frame", {
			Size = UDim2.fromOffset(6, 16),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(h, 0, 0.5, 0),
			BackgroundColor3 = Color3.new(1, 1, 1),
			Parent = hue,
		})
		corner(hueKnob, 3)
		stroke(hueKnob, Color3.new(0, 0, 0), 1)

		local C = {}
		local function apply(silent)
			color = Color3.fromHSV(h, s, v)
			sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
			preview.BackgroundColor3 = color
			svKnob.Position = UDim2.fromScale(s, 1 - v)
			hueKnob.Position = UDim2.new(h, 0, 0.5, 0)
			if o.Flag then Window.Flags[o.Flag] = color end
			if not silent then safe(o.Callback, color) end
		end
		function C:Set(c, silent)
			h, s, v = c:ToHSV()
			apply(silent)
		end
		function C:Get() return color end

		local drag = nil
		local function setScroll(on)
			local sc = container:IsA("ScrollingFrame") and container or container:FindFirstAncestorWhichIsA("ScrollingFrame")
			if sc then sc.ScrollingEnabled = on end
		end
		local function update(pos)
			if drag == "sv" then
				s = math.clamp((pos.X - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1)
				v = 1 - math.clamp((pos.Y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1)
				apply()
			elseif drag == "hue" then
				h = math.clamp((pos.X - hue.AbsolutePosition.X) / hue.AbsoluteSize.X, 0, 0.999)
				apply()
			end
		end
		sv.InputBegan:Connect(function(i)
			if isPress(i) then drag = "sv" setScroll(false) update(i.Position) end
		end)
		hue.InputBegan:Connect(function(i)
			if isPress(i) then drag = "hue" setScroll(false) update(i.Position) end
		end)
		Window:_connect(UIS.InputChanged, function(i)
			if drag and isMove(i) then update(i.Position) end
		end)
		Window:_connect(UIS.InputEnded, function(i)
			if drag and isPress(i) then drag = nil setScroll(true) end
		end)
		header.MouseButton1Click:Connect(function()
			open = not open
			tween(f, {Size = UDim2.new(1, 0, 0, open and 154 or 36)})
		end)

		apply(true)
		return C
	end
end

--// Window
function Library:CreateWindow(opts)
	opts = opts or {}
	local Window = {Flags = {}, _conns = {}, _tabs = {}}
	local size = opts.Size or UDim2.fromOffset(520, 340)
	local toggleKey = opts.ToggleKey or Enum.KeyCode.RightShift
	local R = Theme.WindowCorner
	local SIDE = opts.SidebarWidth or 130
	local guiName = opts.Name or "Library"

	function Window:_connect(sig, fn)
		local c = sig:Connect(fn)
		table.insert(self._conns, c)
		return c
	end

	local parent = getParent()
	local old = parent:FindFirstChild(guiName)
	if old then old:Destroy() end

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

	local root = Create("Frame", {
		Name = "Root",
		Size = size,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
		Parent = gui,
	})
	local scale = Create("UIScale", {Scale = 0.92, Parent = root})
	tween(scale, {Scale = 1}, 0.2)

	-- ظل ناعم
	Create("ImageLabel", {
		Size = UDim2.new(1, 50, 1, 50),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = "rbxassetid://6014261993",
		ImageColor3 = Color3.new(0, 0, 0),
		ImageTransparency = 0.45,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(49, 49, 450, 450),
		Parent = root,
	})

	local main = Create("Frame", {
		Name = "Main",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Theme.Background,
		ClipsDescendants = true,
		Parent = root,
	})
	corner(main, R)
	stroke(main)

	-- الشريط العلوي
	local top = Create("Frame", {Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Theme.Topbar, Parent = main})
	corner(top, R)
	local topFill = Create("Frame", {
		Size = UDim2.new(1, 0, 0, R),
		Position = UDim2.new(0, 0, 1, -R),
		BackgroundColor3 = Theme.Topbar,
		Parent = top,
	})
	local titleX = 14
	if opts.Icon then
		local ic = makeIcon(top, opts.Icon, 18, Theme.Text)
		if ic then
			ic.AnchorPoint = Vector2.new(0, 0.5)
			ic.Position = UDim2.new(0, 14, 0.5, 0)
			titleX = 40
		end
	end
	Create("TextLabel", {
		Size = UDim2.new(1, -(titleX + 80), 1, 0),
		Position = UDim2.fromOffset(titleX, 0),
		BackgroundTransparency = 1,
		Text = opts.Title or "Library",
		TextColor3 = Theme.Text,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = top,
	})
	local function topButton(text, x)
		local b = Create("TextButton", {
			Size = UDim2.fromOffset(34, 38),
			Position = UDim2.new(1, x, 0, 0),
			BackgroundTransparency = 1,
			Text = text,
			TextColor3 = Theme.SubText,
			Font = Enum.Font.GothamBold,
			TextSize = 17,
			AutoButtonColor = false,
			Parent = top,
		})
		b.MouseEnter:Connect(function() tween(b, {TextColor3 = Theme.Text}) end)
		b.MouseLeave:Connect(function() tween(b, {TextColor3 = Theme.SubText}) end)
		return b
	end
	local closeBtn = topButton("×", -38)
	local minBtn = topButton("–", -72)
	Create("Frame", {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.fromOffset(0, 38), BackgroundColor3 = Theme.Stroke, Parent = main})

	local body = Create("Frame", {
		Size = UDim2.new(1, 0, 1, -39),
		Position = UDim2.fromOffset(0, 39),
		BackgroundTransparency = 1,
		Parent = main,
	})

	-- الشريط الجانبي
	local side = Create("Frame", {Size = UDim2.new(0, SIDE, 1, 0), BackgroundColor3 = Theme.Sidebar, Parent = body})
	corner(side, R)
	Create("Frame", {Size = UDim2.new(1, 0, 0, R), BackgroundColor3 = Theme.Sidebar, Parent = side})
	Create("Frame", {Size = UDim2.new(0, R, 1, 0), Position = UDim2.new(1, -R, 0, 0), BackgroundColor3 = Theme.Sidebar, Parent = side})
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
		ClipsDescendants = true,
		Parent = body,
	})
	Create("Frame", {Size = UDim2.new(0, 1, 1, 0), Position = UDim2.fromOffset(SIDE, 0), BackgroundColor3 = Theme.Stroke, Parent = body})

	-- drag
	local dragging, dragStart, startPos
	top.InputBegan:Connect(function(i)
		if isPress(i) then
			dragging, dragStart, startPos = true, i.Position, root.Position
		end
	end)
	Window:_connect(UIS.InputChanged, function(i)
		if dragging and isMove(i) then
			local d = i.Position - dragStart
			root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
	Window:_connect(UIS.InputEnded, function(i)
		if isPress(i) then dragging = false end
	end)

	-- show / hide
	local visible = true
	function Window:SetVisible(v)
		visible = v
		if v then
			root.Visible = true
			scale.Scale = 0.94
			tween(scale, {Scale = 1}, 0.18)
		else
			tween(scale, {Scale = 0.94}, 0.12)
			task.delay(0.12, function()
				if not visible then root.Visible = false end
			end)
		end
	end
	function Window:Toggle() Window:SetVisible(not visible) end
	function Window:Destroy() gui:Destroy() end

	-- minimize / close / toggle key
	local minimized = false
	minBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		body.Visible = not minimized
		topFill.Visible = not minimized
		tween(root, {Size = minimized and UDim2.new(size.X.Scale, size.X.Offset, 0, 38) or size}, 0.2)
	end)
	closeBtn.MouseButton1Click:Connect(function() Window:Destroy() end)
	Window:_connect(UIS.InputBegan, function(i, gp)
		if not gp and i.KeyCode == toggleKey then Window:Toggle() end
	end)

	-- زر عائم للجوال (فتح/اخفاء) - اسحبه وين تبي
	if opts.FloatButton ~= false then
		local fb = Create("TextButton", {
			Size = UDim2.fromOffset(42, 42),
			Position = UDim2.new(0, 14, 0.5, -21),
			BackgroundColor3 = Theme.Topbar,
			Text = "",
			AutoButtonColor = false,
			Parent = gui,
		})
		corner(fb, 21)
		stroke(fb, Theme.StrokeHover)
		local fi = opts.FloatIcon and makeIcon(fb, opts.FloatIcon, 22, Theme.Text)
		if fi then
			fi.AnchorPoint = Vector2.new(0.5, 0.5)
			fi.Position = UDim2.fromScale(0.5, 0.5)
		else
			for n = 0, 2 do
				local bar = Create("Frame", {
					Size = UDim2.fromOffset(16, 2),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, (n - 1) * 5),
					BackgroundColor3 = Theme.Text,
					Parent = fb,
				})
				corner(bar, 1)
			end
		end
		local fdrag, fmoved, fstart, fpos = false, false, nil, nil
		fb.InputBegan:Connect(function(i)
			if isPress(i) then
				fdrag, fmoved, fstart, fpos = true, false, i.Position, fb.Position
			end
		end)
		Window:_connect(UIS.InputChanged, function(i)
			if fdrag and isMove(i) then
				local d = i.Position - fstart
				if d.Magnitude > 6 then fmoved = true end
				if fmoved then
					fb.Position = UDim2.new(fpos.X.Scale, fpos.X.Offset + d.X, fpos.Y.Scale, fpos.Y.Offset + d.Y)
				end
			end
		end)
		Window:_connect(UIS.InputEnded, function(i)
			if fdrag and isPress(i) then
				fdrag = false
				if not fmoved then Window:Toggle() end
			end
		end)
	end

	-- notifications
	local holder = Create("Frame", {
		Size = UDim2.new(0, 270, 1, -20),
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -10, 1, -10),
		BackgroundTransparency = 1,
		ZIndex = 10,
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
		local dur = n.Duration or 4
		local item = Create("Frame", {Size = UDim2.new(1, 0, 0, 68), BackgroundTransparency = 1, Parent = holder})
		local f = Create("Frame", {
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromOffset(300, 0),
			BackgroundColor3 = Theme.Background,
			ClipsDescendants = true,
			Parent = item,
		})
		corner(f, 10)
		stroke(f, Theme.StrokeHover)
		local x = 14
		if n.Icon then
			local ic = makeIcon(f, n.Icon, 20, Theme.Text)
			if ic then
				ic.AnchorPoint = Vector2.new(0, 0.5)
				ic.Position = UDim2.new(0, 14, 0.5, -1)
				x = 44
			end
		end
		Create("TextLabel", {
			Size = UDim2.new(1, -(x + 10), 0, 18), Position = UDim2.fromOffset(x, 9), BackgroundTransparency = 1,
			Text = n.Title or "Notification", TextColor3 = Theme.Text, Font = Enum.Font.GothamBold,
			TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = f,
		})
		Create("TextLabel", {
			Size = UDim2.new(1, -(x + 10), 0, 28), Position = UDim2.fromOffset(x, 27), BackgroundTransparency = 1,
			Text = n.Content or "", TextColor3 = Theme.SubText, Font = Enum.Font.Gotham, TextSize = 12,
			TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top,
			TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = f,
		})
		local bar = Create("Frame", {
			Size = UDim2.new(1, 0, 0, 2),
			Position = UDim2.new(0, 0, 1, -2),
			BackgroundColor3 = Theme.Accent,
			Parent = f,
		})
		tween(f, {Position = UDim2.fromOffset(0, 0)}, 0.25)
		TweenService:Create(bar, TweenInfo.new(dur, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 2)}):Play()
		task.delay(dur, function()
			if item.Parent then
				tween(f, {Position = UDim2.fromOffset(300, 0)}, 0.25)
				task.wait(0.3)
				item:Destroy()
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

		local entry = {Button = btn, Page = page, Bar = indicator, Label = lbl, Icon = ic}
		table.insert(Window._tabs, entry)

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
				Size = UDim2.new(1, 0, 0, 20),
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
