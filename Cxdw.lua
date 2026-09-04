--// ============================
--// مكتبة الواجهة الرسومية المخصصة (Custom UI Library)
--// تصميم: شريط جانبي + تبويبات + Toggle/Slider - يشتغل داخل CoreGui
--// ============================

local Library = {}
Library.__index = Library

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--// ============================
--// دوال مساعدة عامة
--// ============================

local function create(class, props, children)
	local inst = Instance.new(class)
	for prop, value in pairs(props or {}) do
		inst[prop] = value
	end
	for _, child in ipairs(children or {}) do
		child.Parent = inst
	end
	return inst
end

local function tween(obj, props, duration)
	duration = duration or 0.18
	local tw = TweenService:Create(obj, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
	tw:Play()
	return tw
end

--// ============================
--// ألوان التصميم (Theme)
--// ============================

local Theme = {
	Background = Color3.fromRGB(15, 15, 18),
	TopBar = Color3.fromRGB(10, 10, 12),
	Sidebar = Color3.fromRGB(12, 12, 15),
	Content = Color3.fromRGB(17, 17, 20),
	Row = Color3.fromRGB(20, 20, 24),
	Accent = Color3.fromRGB(90, 130, 255),
	TextMain = Color3.fromRGB(230, 230, 235),
	TextDim = Color3.fromRGB(140, 140, 150),
	Off = Color3.fromRGB(45, 45, 50),
}

--// ============================
--// إنشاء النافذة الرئيسية
--// ============================

function Library.new(config)
	config = config or {}
	local self = setmetatable({}, Library)

	self.Tabs = {}
	self.TabButtons = {}
	self.CurrentTab = nil

	-- الشاشة الأساسية
	self.ScreenGui = create("ScreenGui", {
		Name = "CustomLibraryUI",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = (gethui and gethui()) or game:GetService("CoreGui"),
	})

	-- الإطار الرئيسي للنافذة
	self.Main = create("Frame", {
		Name = "Main",
		Size = UDim2.new(0, 900, 0, 600),
		Position = UDim2.new(0.5, -450, 0.5, -300),
		BackgroundColor3 = Theme.Background,
		BorderSizePixel = 0,
		Parent = self.ScreenGui,
	}, {
		create("UICorner", { CornerRadius = UDim.new(0, 12) }),
	})

	-- الشريط العلوي (نقاط التحكم + السحب)
	self.TopBar = create("Frame", {
		Name = "TopBar",
		Size = UDim2.new(1, 0, 0, 44),
		BackgroundColor3 = Theme.TopBar,
		BorderSizePixel = 0,
		Parent = self.Main,
	})
	create("UICorner", { CornerRadius = UDim.new(0, 12) }, {}).Parent = self.TopBar

	local dotsHolder = create("Frame", {
		Size = UDim2.new(0, 60, 0, 12),
		Position = UDim2.new(0, 16, 0.5, -6),
		BackgroundTransparency = 1,
		Parent = self.TopBar,
	}, {
		create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8) }),
	})
	local dotColors = { Color3.fromRGB(255, 95, 86), Color3.fromRGB(255, 189, 46), Color3.fromRGB(39, 201, 63) }
	for _, c in ipairs(dotColors) do
		create("Frame", { Size = UDim2.new(0, 12, 0, 12), BackgroundColor3 = c, Parent = dotsHolder }, {
			create("UICorner", { CornerRadius = UDim.new(1, 0) }),
		})
	end

	-- السحب (Drag)
	do
		local dragging, dragStart, startPos
		self.TopBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = self.Main.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local delta = input.Position - dragStart
				self.Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end)
	end

	-- الشريط الجانبي (Sidebar)
	self.Sidebar = create("Frame", {
		Name = "Sidebar",
		Size = UDim2.new(0, 240, 1, -44),
		Position = UDim2.new(0, 0, 0, 44),
		BackgroundColor3 = Theme.Sidebar,
		BorderSizePixel = 0,
		Parent = self.Main,
	})

	-- عنوان المكتبة + الوصف الفرعي
	create("Frame", {
		Size = UDim2.new(1, -32, 0, 50),
		Position = UDim2.new(0, 16, 0, 14),
		BackgroundTransparency = 1,
		Parent = self.Sidebar,
	}, {
		create("TextLabel", {
			Text = config.Title or "MyLibrary",
			Font = Enum.Font.GothamBold,
			TextSize = 20,
			TextColor3 = Theme.TextMain,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 24),
		}),
		create("TextLabel", {
			Text = config.SubTitle or "",
			Font = Enum.Font.Gotham,
			TextSize = 13,
			TextColor3 = Theme.TextDim,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 0, 24),
			Size = UDim2.new(1, 0, 0, 18),
		}),
	})

	-- حاوية أزرار التبويبات
	self.TabList = create("Frame", {
		Size = UDim2.new(1, -16, 1, -160),
		Position = UDim2.new(0, 8, 0, 74),
		BackgroundTransparency = 1,
		Parent = self.Sidebar,
	}, {
		create("UIListLayout", { Padding = UDim.new(0, 4) }),
	})

	-- صف الحساب بالأسفل (بروفايل)
	local profileRow = create("Frame", {
		Size = UDim2.new(1, -16, 0, 60),
		Position = UDim2.new(0, 8, 1, -70),
		BackgroundColor3 = Theme.Row,
		Parent = self.Sidebar,
	}, {
		create("UICorner", { CornerRadius = UDim.new(0, 10) }),
	})
	create("Frame", {
		Size = UDim2.new(0, 36, 0, 36),
		Position = UDim2.new(0, 10, 0.5, -18),
		BackgroundColor3 = Theme.Accent,
		Parent = profileRow,
	}, {
		create("UICorner", { CornerRadius = UDim.new(1, 0) }),
	})
	create("TextLabel", {
		Text = LocalPlayer.DisplayName,
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		TextColor3 = Theme.TextMain,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 56, 0, 8),
		Size = UDim2.new(1, -60, 0, 16),
		Parent = profileRow,
	})
	create("TextLabel", {
		Text = "@" .. LocalPlayer.Name,
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = Theme.TextDim,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 56, 0, 26),
		Size = UDim2.new(1, -60, 0, 14),
		Parent = profileRow,
	})

	-- منطقة المحتوى (يمين النافذة)
	self.ContentContainer = create("Frame", {
		Name = "ContentContainer",
		Size = UDim2.new(1, -240, 1, -44),
		Position = UDim2.new(0, 240, 0, 44),
		BackgroundColor3 = Theme.Content,
		BorderSizePixel = 0,
		Parent = self.Main,
	})

	return self
end

--// ============================
--// إنشاء تبويب جديد
--// ============================

function Library:CreateTab(name)
	-- زر التبويب بالشريط الجانبي
	local btn = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 38),
		BackgroundColor3 = Theme.Row,
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Parent = self.TabList,
	}, {
		create("UICorner", { CornerRadius = UDim.new(0, 8) }),
	})
	create("Frame", {
		Size = UDim2.new(0, 20, 0, 20),
		Position = UDim2.new(0, 12, 0.5, -10),
		BackgroundColor3 = Theme.Off,
		Parent = btn,
	}, {
		create("UICorner", { CornerRadius = UDim.new(1, 0) }),
		create("TextLabel", {
			Text = name:sub(1, 1),
			Font = Enum.Font.GothamBold,
			TextSize = 12,
			TextColor3 = Theme.TextMain,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
		}),
	})
	local label = create("TextLabel", {
		Text = name,
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextColor3 = Theme.TextDim,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 42, 0, 0),
		Size = UDim2.new(1, -50, 1, 0),
		Parent = btn,
	})

	-- صفحة المحتوى الخاصة بالتبويب
	local page = create("ScrollingFrame", {
		Size = UDim2.new(1, -48, 1, -32),
		Position = UDim2.new(0, 24, 0, 16),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 4,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Visible = false,
		Parent = self.ContentContainer,
	}, {
		create("UIListLayout", { Padding = UDim.new(0, 14) }),
	})

	local tab = { Name = name, Page = page, Button = btn, Label = label }

	btn.MouseButton1Click:Connect(function()
		self:SelectTab(tab)
	end)

	table.insert(self.Tabs, tab)
	if not self.CurrentTab then
		self:SelectTab(tab)
	end

	--// دالة: إضافة عنوان قسم
	function tab:CreateSection(text)
		create("TextLabel", {
			Text = text,
			Font = Enum.Font.GothamBold,
			TextSize = 20,
			TextColor3 = Theme.TextMain,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 28),
			Parent = self.Page,
		})
	end

	--// دالة: إضافة خط فاصل
	function tab:CreateDivider()
		create("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = Theme.Off,
			BackgroundTransparency = 0.5,
			Parent = self.Page,
		})
	end

	--// دالة: إضافة Toggle
	function tab:CreateToggle(opts)
		opts = opts or {}
		local state = opts.Default or false

		local row = create("Frame", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundTransparency = 1,
			Parent = self.Page,
		})
		create("TextLabel", {
			Text = opts.Name or "Toggle",
			Font = Enum.Font.Gotham,
			TextSize = 15,
			TextColor3 = Theme.TextMain,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -60, 1, 0),
			Parent = row,
		})

		local track = create("Frame", {
			Size = UDim2.new(0, 44, 0, 22),
			Position = UDim2.new(1, -44, 0.5, -11),
			BackgroundColor3 = state and Theme.Accent or Theme.Off,
			Parent = row,
		}, {
			create("UICorner", { CornerRadius = UDim.new(1, 0) }),
		})
		local knob = create("Frame", {
			Size = UDim2.new(0, 18, 0, 18),
			Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Parent = track,
		}, {
			create("UICorner", { CornerRadius = UDim.new(1, 0) }),
		})

		local click = create("TextButton", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = "",
			Parent = track,
		})

		click.MouseButton1Click:Connect(function()
			state = not state
			tween(track, { BackgroundColor3 = state and Theme.Accent or Theme.Off })
			tween(knob, { Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9) })
			-- === ضع منطقك الخاص هنا ===
			if opts.Callback then
				opts.Callback(state)
			end
		end)

		return { Set = function(v) state = v; click.MouseButton1Click:Wait() end }
	end

	--// دالة: إضافة Slider
	function tab:CreateSlider(opts)
		opts = opts or {}
		local min, max = opts.Min or 0, opts.Max or 100
		local value = opts.Default or min

		local row = create("Frame", {
			Size = UDim2.new(1, 0, 0, 46),
			BackgroundTransparency = 1,
			Parent = self.Page,
		})
		create("TextLabel", {
			Text = opts.Name or "Slider",
			Font = Enum.Font.Gotham,
			TextSize = 15,
			TextColor3 = Theme.TextMain,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 18),
			Parent = row,
		})

		local valueBox = create("TextBox", {
			Text = tostring(value),
			Font = Enum.Font.GothamBold,
			TextSize = 13,
			TextColor3 = Theme.TextMain,
			BackgroundColor3 = Theme.Row,
			Size = UDim2.new(0, 50, 0, 24),
			Position = UDim2.new(1, -50, 0, 18),
			ClearTextOnFocus = false,
			Parent = row,
		}, {
			create("UICorner", { CornerRadius = UDim.new(0, 6) }),
		})

		local barBack = create("Frame", {
			Size = UDim2.new(1, -66, 0, 4),
			Position = UDim2.new(0, 0, 0, 28),
			BackgroundColor3 = Theme.Off,
			Parent = row,
		}, {
			create("UICorner", { CornerRadius = UDim.new(1, 0) }),
		})

		local function pct()
			return (value - min) / (max - min)
		end

		local fill = create("Frame", {
			Size = UDim2.new(pct(), 0, 1, 0),
			BackgroundColor3 = Theme.Accent,
			Parent = barBack,
		}, {
			create("UICorner", { CornerRadius = UDim.new(1, 0) }),
		})
		local knob = create("Frame", {
			Size = UDim2.new(0, 14, 0, 14),
			Position = UDim2.new(pct(), -7, 0.5, -7),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			ZIndex = 2,
			Parent = barBack,
		}, {
			create("UICorner", { CornerRadius = UDim.new(1, 0) }),
		})

		local function setValue(v, fire)
			value = math.clamp(math.floor(v + 0.5), min, max)
			local p = (value - min) / (max - min)
			fill.Size = UDim2.new(p, 0, 1, 0)
			knob.Position = UDim2.new(p, -7, 0.5, -7)
			valueBox.Text = tostring(value)
			-- === ضع منطقك الخاص هنا ===
			if fire and opts.Callback then
				opts.Callback(value)
			end
		end

		local dragging = false
		knob.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local rel = math.clamp((input.Position.X - barBack.AbsolutePosition.X) / barBack.AbsoluteSize.X, 0, 1)
				setValue(min + rel * (max - min), true)
			end
		end)

		valueBox.FocusLost:Connect(function()
			local n = tonumber(valueBox.Text)
			if n then
				setValue(n, true)
			else
				valueBox.Text = tostring(value)
			end
		end)

		return { Set = function(v) setValue(v, true) end }
	end

	return tab
end

--// ============================
--// التبديل بين التبويبات
--// ============================

function Library:SelectTab(tab)
	for _, t in ipairs(self.Tabs) do
		t.Page.Visible = (t == tab)
		t.Label.TextColor3 = (t == tab) and Theme.TextMain or Theme.TextDim
		tween(t.Button, { BackgroundTransparency = (t == tab) and 0 or 1 })
	end
	self.CurrentTab = tab
end

return Library
