--[[
╔════════════════════════════════════════════════════════╗
║  NovaUI v2.0  —  مكتبة واجهات كاملة + Http / Https     ║
╚════════════════════════════════════════════════════════╝
  1) Services & Utils
  2) Signal
  3) Themes
  4) Net: Http و Https (عميلين منفصلين)
  5) Library (النافذة)
  6) Container: المكونات (Tab / Section)
  7) Config / Settings
  8) مثال تشغيل
]]

--// ============================ 1) Services ============================
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService      = game:GetService("HttpService")
local RunService       = game:GetService("RunService")
local TextService      = game:GetService("TextService")

local FS = {
	write      = writefile,
	read       = readfile,
	list       = listfiles,
	delete     = delfile,
	isfile     = isfile,
	isfolder   = isfolder,
	makefolder = makefolder,
}
local gethui_ = gethui

--// ============================ Utils ============================
local Util = {}

function Util.New(class, props, parent)
	local inst = Instance.new(class)
	if props then
		for k, v in pairs(props) do
			inst[k] = v
		end
	end
	if parent then
		inst.Parent = parent
	end
	return inst
end
local New = Util.New

function Util.Round(inst, radius)
	return New("UICorner", { CornerRadius = UDim.new(0, radius or 6) }, inst)
end

function Util.Stroke(inst, color, thickness, transparency)
	return New("UIStroke", {
		Color = color or Color3.new(1, 1, 1),
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, inst)
end

function Util.Pad(inst, top, bottom, left, right)
	return New("UIPadding", {
		PaddingTop    = UDim.new(0, top or 0),
		PaddingBottom = UDim.new(0, bottom or 0),
		PaddingLeft   = UDim.new(0, left or 0),
		PaddingRight  = UDim.new(0, right or 0),
	}, inst)
end

function Util.List(inst, padding, horizontal)
	return New("UIListLayout", {
		Padding = UDim.new(0, padding or 0),
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = horizontal and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical,
	}, inst)
end

function Util.Tween(obj, props, duration, style, direction)
	local info = TweenInfo.new(
		duration or 0.15,
		style or Enum.EasingStyle.Quad,
		direction or Enum.EasingDirection.Out
	)
	local t = TweenService:Create(obj, info, props)
	t:Play()
	return t
end

function Util.GuiParent()
	if gethui_ then
		local ok, ui = pcall(gethui_)
		if ok and ui then
			return ui
		end
	end
	local lp = Players.LocalPlayer
	if lp then
		local pg = lp:FindFirstChildOfClass("PlayerGui") or lp:WaitForChild("PlayerGui", 5)
		if pg then
			return pg
		end
	end
	return game:GetService("CoreGui")
end

function Util.Clone(t)
	local c = {}
	for k, v in pairs(t) do
		c[k] = type(v) == "table" and Util.Clone(v) or v
	end
	return c
end

function Util.Merge(a, b)
	local out = {}
	if a then
		for k, v in pairs(a) do out[k] = v end
	end
	if b then
		for k, v in pairs(b) do out[k] = v end
	end
	return out
end

function Util.ToHex(c)
	return string.format("#%02X%02X%02X", math.round(c.R * 255), math.round(c.G * 255), math.round(c.B * 255))
end

function Util.FromHex(s)
	s = tostring(s):gsub("#", "")
	if #s ~= 6 then
		return nil
	end
	local r, g, b = tonumber(s:sub(1, 2), 16), tonumber(s:sub(3, 4), 16), tonumber(s:sub(5, 6), 16)
	if r and g and b then
		return Color3.fromRGB(r, g, b)
	end
	return nil
end

function Util.IsPress(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch
end

function Util.IsMove(input)
	return input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch
end

function Util.Drag(handle, target, conns)
	local dragging, origin, startPos = false, nil, nil
	handle.InputBegan:Connect(function(input)
		if Util.IsPress(input) then
			dragging = true
			origin = input.Position
			startPos = target.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	table.insert(conns, UserInputService.InputChanged:Connect(function(input)
		if dragging and Util.IsMove(input) then
			local d = input.Position - origin
			target.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + d.X,
				startPos.Y.Scale, startPos.Y.Offset + d.Y
			)
		end
	end))
end

function Util.Resize(grip, target, minSize, conns)
	local resizing, origin, startSize = false, nil, nil
	grip.InputBegan:Connect(function(input)
		if Util.IsPress(input) then
			resizing = true
			origin = input.Position
			startSize = target.AbsoluteSize
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					resizing = false
				end
			end)
		end
	end)
	table.insert(conns, UserInputService.InputChanged:Connect(function(input)
		if resizing and Util.IsMove(input) then
			local d = input.Position - origin
			local w = math.max(minSize.X, startSize.X + d.X)
			local h = math.max(minSize.Y, startSize.Y + d.Y)
			target.Size = UDim2.fromOffset(w, h)
		end
	end))
end

--// ============================ 2) Signal ============================
local Signal = {}
Signal.__index = Signal

function Signal.new()
	return setmetatable({ _handlers = {} }, Signal)
end

function Signal:Connect(fn)
	local h = { fn = fn }
	table.insert(self._handlers, h)
	return {
		Disconnect = function()
			local i = table.find(self._handlers, h)
			if i then
				table.remove(self._handlers, i)
			end
		end,
	}
end

function Signal:Fire(...)
	for _, h in ipairs(table.clone(self._handlers)) do
		task.spawn(h.fn, ...)
	end
end

--// ============================ 3) Themes ============================
local Themes = {
	Dark = {
		Background   = Color3.fromRGB(35, 35, 48),
		Top          = Color3.fromRGB(28, 28, 40),
		Sidebar      = Color3.fromRGB(30, 30, 43),
		Element      = Color3.fromRGB(48, 48, 66),
		ElementHover = Color3.fromRGB(58, 58, 80),
		Accent       = Color3.fromRGB(90, 120, 255),
		Text         = Color3.fromRGB(235, 235, 245),
		SubText      = Color3.fromRGB(160, 160, 180),
		Stroke       = Color3.fromRGB(70, 70, 95),
	},
	Light = {
		Background   = Color3.fromRGB(240, 241, 247),
		Top          = Color3.fromRGB(226, 228, 238),
		Sidebar      = Color3.fromRGB(232, 234, 243),
		Element      = Color3.fromRGB(255, 255, 255),
		ElementHover = Color3.fromRGB(240, 243, 255),
		Accent       = Color3.fromRGB(70, 100, 240),
		Text         = Color3.fromRGB(30, 32, 45),
		SubText      = Color3.fromRGB(105, 110, 130),
		Stroke       = Color3.fromRGB(200, 204, 220),
	},
	Ocean = {
		Background   = Color3.fromRGB(16, 32, 46),
		Top          = Color3.fromRGB(11, 24, 36),
		Sidebar      = Color3.fromRGB(13, 27, 40),
		Element      = Color3.fromRGB(26, 50, 70),
		ElementHover = Color3.fromRGB(34, 62, 86),
		Accent       = Color3.fromRGB(0, 190, 210),
		Text         = Color3.fromRGB(225, 240, 248),
		SubText      = Color3.fromRGB(135, 165, 185),
		Stroke       = Color3.fromRGB(45, 80, 105),
	},
	Rose = {
		Background   = Color3.fromRGB(42, 30, 38),
		Top          = Color3.fromRGB(34, 23, 30),
		Sidebar      = Color3.fromRGB(37, 26, 33),
		Element      = Color3.fromRGB(62, 44, 55),
		ElementHover = Color3.fromRGB(76, 54, 68),
		Accent       = Color3.fromRGB(240, 90, 140),
		Text         = Color3.fromRGB(250, 235, 242),
		SubText      = Color3.fromRGB(190, 160, 175),
		Stroke       = Color3.fromRGB(95, 70, 85),
	},
	Midnight = {
		Background   = Color3.fromRGB(14, 14, 18),
		Top          = Color3.fromRGB(9, 9, 12),
		Sidebar      = Color3.fromRGB(11, 11, 15),
		Element      = Color3.fromRGB(26, 26, 34),
		ElementHover = Color3.fromRGB(36, 36, 46),
		Accent       = Color3.fromRGB(150, 90, 255),
		Text         = Color3.fromRGB(235, 235, 240),
		SubText      = Color3.fromRGB(140, 140, 155),
		Stroke       = Color3.fromRGB(48, 48, 60),
	},
}

local NotifyColors = {
	info    = nil, -- يستخدم Accent
	success = Color3.fromRGB(70, 200, 120),
	warn    = Color3.fromRGB(240, 180, 60),
	error   = Color3.fromRGB(235, 80, 80),
}

--// ============================ 4) Net (Http / Https) ============================
local Net = {}

function Net.BuildQuery(tbl)
	local pairsList = {}
	for k, v in pairs(tbl) do
		table.insert(pairsList, { tostring(k), tostring(v) })
	end
	table.sort(pairsList, function(a, b) return a[1] < b[1] end)
	local parts = {}
	for _, kv in ipairs(pairsList) do
		parts[#parts + 1] = HttpService:UrlEncode(kv[1]) .. "=" .. HttpService:UrlEncode(kv[2])
	end
	return table.concat(parts, "&")
end

-- يرجّع رابط كامل + البروتوكول. force=true يفرض البروتوكول الافتراضي حتى لو الرابط مختلف
function Net.Normalize(url, defaultScheme, force)
	url = tostring(url or ""):gsub("^%s+", ""):gsub("%s+$", "")
	local scheme, rest = url:match("^(%a[%w+.-]*)://(.+)$")
	if not scheme then
		scheme, rest = defaultScheme, url
	else
		scheme = scheme:lower()
		if force then
			scheme = defaultScheme
		end
	end
	return scheme .. "://" .. rest, scheme
end

function Net.Decode(body)
	local ok, data = pcall(HttpService.JSONDecode, HttpService, body)
	if ok then
		return data
	end
	return nil, data
end

function Net.Encode(data)
	local ok, out = pcall(HttpService.JSONEncode, HttpService, data)
	if ok then
		return out
	end
	return nil, out
end

function Net.Explain(res)
	local m = tostring(res.StatusMessage or "")
	local code = res.StatusCode or 0
	if m:find("can only be executed by game server") then
		return "HttpService يشتغل من السيرفر فقط (Script) مو LocalScript"
	elseif m:find("not enabled") then
		return "فعّل Allow HTTP Requests من Game Settings > Security"
	elseif m:find("exceeded limit") then
		return "تجاوزت حد الطلبات (500 بالدقيقة)"
	elseif m:find("SslConnectFail") or m:find("SSL") then
		return "فشل اتصال SSL، تأكد من شهادة موقع الـ https"
	elseif m:find("ConnectFail") or m:find("Timedout") then
		return "ما قدر يتصل بالسيرفر (انقطاع أو مهلة)"
	elseif m:find("InvalidUrl") or m:find("Invalid URL") then
		return "الرابط غير صالح"
	elseif m:lower():find("roblox") and code == 0 then
		return "ما يسمح بطلبات لدومينات Roblox"
	elseif code == 401 or code == 403 then
		return "ممنوع الوصول (" .. code .. ")"
	elseif code == 404 then
		return "الرابط غير موجود (404)"
	elseif code == 429 then
		return "طلبات كثيرة (429)، انتظر شوي"
	elseif code >= 500 then
		return "خطأ من السيرفر (" .. code .. ")"
	end
	return m ~= "" and m or ("HTTP " .. tostring(code))
end

local function makeClient(name, defaultScheme, force)
	local C = {
		Name        = name,
		Scheme      = defaultScheme,
		ForceScheme = force,
		Headers     = {},
		Retries     = 2,
		RateLimit   = 450,
		OnRequest   = Signal.new(),
		OnResponse  = Signal.new(),
		_stamps     = {},
		_cache      = {},
	}

	local function waitSlot()
		local now = os.clock()
		local fresh = {}
		for _, t in ipairs(C._stamps) do
			if now - t < 60 then
				fresh[#fresh + 1] = t
			end
		end
		C._stamps = fresh
		if #fresh >= C.RateLimit then
			task.wait(60 - (now - fresh[1]) + 0.05)
		end
		table.insert(C._stamps, os.clock())
	end

	local function fail(url, msg)
		return {
			Success = false, StatusCode = 0, StatusMessage = msg,
			Headers = {}, Body = "", Url = url, Elapsed = 0,
		}
	end

	function C.Request(opts)
		local url = Net.Normalize(opts.Url, C.Scheme, C.ForceScheme)
		if opts.Query then
			url = url .. (url:find("?", 1, true) and "&" or "?") .. Net.BuildQuery(opts.Query)
		end

		local method = (opts.Method or "GET"):upper()
		local headers = Util.Merge(C.Headers, opts.Headers)
		local body = opts.Body

		if type(body) == "table" then
			local enc, err = Net.Encode(body)
			if not enc then
				return fail(url, "JSON encode: " .. tostring(err))
			end
			body = enc
			headers["Content-Type"] = headers["Content-Type"] or "application/json"
		end
		if method == "GET" or method == "HEAD" then
			body = nil
		end

		-- كاش بسيط للـ GET
		local cacheKey = method .. " " .. url
		if method == "GET" and opts.Cache then
			local hit = C._cache[cacheKey]
			if hit and os.clock() - hit.at < opts.Cache then
				return hit.res
			end
		end

		local tries = (opts.Retries or C.Retries) + 1
		local res
		for attempt = 1, tries do
			waitSlot()
			C.OnRequest:Fire(method, url, attempt)
			local started = os.clock()
			local ok, r = pcall(HttpService.RequestAsync, HttpService, {
				Url = url, Method = method, Headers = headers, Body = body,
			})
			local elapsed = os.clock() - started
			if ok then
				res = r
				res.Url, res.Elapsed = url, elapsed
				if r.Success or (r.StatusCode < 500 and r.StatusCode ~= 429) then
					break
				end
			else
				res = fail(url, tostring(r))
				res.Elapsed = elapsed
			end
			if attempt < tries then
				task.wait(0.6 * attempt)
			end
		end

		res.Error = (not res.Success) and Net.Explain(res) or nil
		if method == "GET" and opts.Cache and res.Success then
			C._cache[cacheKey] = { at = os.clock(), res = res }
		end
		C.OnResponse:Fire(res)
		return res
	end

	function C.Get(url, opts)
		return C.Request(Util.Merge(opts, { Url = url, Method = "GET" }))
	end

	function C.Post(url, body, opts)
		return C.Request(Util.Merge(opts, { Url = url, Method = "POST", Body = body }))
	end

	function C.Put(url, body, opts)
		return C.Request(Util.Merge(opts, { Url = url, Method = "PUT", Body = body }))
	end

	function C.Patch(url, body, opts)
		return C.Request(Util.Merge(opts, { Url = url, Method = "PATCH", Body = body }))
	end

	function C.Delete(url, opts)
		return C.Request(Util.Merge(opts, { Url = url, Method = "DELETE" }))
	end

	function C.GetJson(url, opts)
		local res = C.Get(url, opts)
		if not res.Success then
			return nil, res
		end
		return Net.Decode(res.Body), res
	end

	function C.PostJson(url, data, opts)
		local res = C.Post(url, data, opts)
		if not res.Success then
			return nil, res
		end
		return Net.Decode(res.Body), res
	end

	function C.GetAll(urls, opts)
		local results, pending = {}, #urls
		for i, u in ipairs(urls) do
			task.spawn(function()
				results[i] = C.Get(u, opts)
				pending -= 1
			end)
		end
		while pending > 0 do
			task.wait()
		end
		return results
	end

	function C.Ping(url)
		local t = os.clock()
		local res = C.Request({ Url = url, Method = "GET", Retries = 0 })
		return res.Success, math.floor((os.clock() - t) * 1000), res
	end

	function C.Download(url, path)
		local res = C.Get(url)
		if res.Success and path and FS.write then
			pcall(FS.write, path, res.Body)
		end
		return res.Success and res.Body or nil, res
	end

	function C.ClearCache()
		C._cache = {}
	end

	return C
end

local Http  = makeClient("Http", "http", false)   -- يحافظ على البروتوكول، الافتراضي http
local Https = makeClient("Https", "https", true)  -- يفرض https دائماً

--// ============================ 5) Library ============================
local Library = {}
Library.__index = Library
Library.Http    = Http
Library.Https   = Https
Library.Net     = Net
Library.Util    = Util
Library.Signal  = Signal
Library.Themes  = Themes

function Library.new(opts)
	opts = opts or {}
	local self = setmetatable({}, Library)

	self.Tabs          = {}
	self.Flags         = {}
	self._setters      = {}
	self._themed       = {}
	self._conns        = {}
	self.ThemeChanged  = Signal.new()
	self.Destroyed     = Signal.new()
	self.Theme         = Util.Clone(Themes[opts.Theme or "Dark"] or Themes.Dark)
	self.ThemeName     = opts.Theme or "Dark"
	self.ConfigFolder  = opts.ConfigFolder or "NovaUI"
	self.ToggleKey     = opts.ToggleKey or Enum.KeyCode.RightShift

	local size = opts.Size or Vector2.new(540, 340)

	self.Gui = New("ScreenGui", {
		Name = "NovaUI_" .. HttpService:GenerateGUID(false):sub(1, 8),
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		DisplayOrder = 999,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	}, Util.GuiParent())

	-- النافذة الرئيسية
	self.Main = New("Frame", {
		Size = UDim2.fromOffset(size.X, size.Y),
		Position = UDim2.new(0.5, -size.X / 2, 0.5, -size.Y / 2),
		BorderSizePixel = 0,
	}, self.Gui)
	Util.Round(self.Main, 8)
	self:_T(self.Main, "BackgroundColor3", "Background")
	local mainStroke = Util.Stroke(self.Main, nil, 1, 0.5)
	self:_T(mainStroke, "Color", "Stroke")

	-- الشريط العلوي
	self.Top = New("Frame", { Size = UDim2.new(1, 0, 0, 36), BorderSizePixel = 0 }, self.Main)
	Util.Round(self.Top, 8)
	self:_T(self.Top, "BackgroundColor3", "Top")
	local topFill = New("Frame", {
		Size = UDim2.new(1, 0, 0, 8), Position = UDim2.new(0, 0, 1, -8), BorderSizePixel = 0,
	}, self.Top)
	self:_T(topFill, "BackgroundColor3", "Top")

	self.TitleLabel = self:_Text(self.Top, {
		Size = UDim2.new(1, -100, 1, 0), Position = UDim2.fromOffset(14, 0),
		Text = opts.Title or "NovaUI", Font = Enum.Font.GothamBold, TextSize = 14,
	})
	self.SubtitleLabel = self:_Text(self.Top, {
		Size = UDim2.new(1, -100, 1, 0), Position = UDim2.fromOffset(14, 0),
		Text = "", TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right,
	}, "SubText")
	if opts.Subtitle then
		self.SubtitleLabel.Text = opts.Subtitle
		self.SubtitleLabel.Position = UDim2.fromOffset(-70, 0)
	end

	local minBtn = New("TextButton", {
		Size = UDim2.fromOffset(32, 36), Position = UDim2.new(1, -68, 0, 0),
		BackgroundTransparency = 1, Text = "–", Font = Enum.Font.GothamBold, TextSize = 18,
	}, self.Top)
	self:_T(minBtn, "TextColor3", "SubText")

	local closeBtn = New("TextButton", {
		Size = UDim2.fromOffset(32, 36), Position = UDim2.new(1, -34, 0, 0),
		BackgroundTransparency = 1, Text = "×", Font = Enum.Font.GothamBold, TextSize = 20,
	}, self.Top)
	self:_T(closeBtn, "TextColor3", "SubText")
	closeBtn.MouseEnter:Connect(function() closeBtn.TextColor3 = NotifyColors.error end)
	closeBtn.MouseLeave:Connect(function() closeBtn.TextColor3 = self.Theme.SubText end)
	closeBtn.MouseButton1Click:Connect(function() self:Destroy() end)

	Util.Drag(self.Top, self.Main, self._conns)

	-- الشريط الجانبي (التابات)
	self.Sidebar = New("Frame", {
		Size = UDim2.new(0, 124, 1, -36), Position = UDim2.fromOffset(0, 36), BorderSizePixel = 0,
	}, self.Main)
	Util.Round(self.Sidebar, 8)
	self:_T(self.Sidebar, "BackgroundColor3", "Sidebar")
	local sideFillTop = New("Frame", { Size = UDim2.new(1, 0, 0, 8), BorderSizePixel = 0 }, self.Sidebar)
	self:_T(sideFillTop, "BackgroundColor3", "Sidebar")
	local sideFillRight = New("Frame", {
		Size = UDim2.new(0, 8, 1, 0), Position = UDim2.new(1, -8, 0, 0), BorderSizePixel = 0,
	}, self.Sidebar)
	self:_T(sideFillRight, "BackgroundColor3", "Sidebar")

	self.TabList = New("ScrollingFrame", {
		Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0,
		ScrollBarThickness = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
	}, self.Sidebar)
	Util.List(self.TabList, 4)
	Util.Pad(self.TabList, 8, 8, 8, 8)

	-- منطقة الصفحات
	self.Pages = New("Frame", {
		Size = UDim2.new(1, -124, 1, -36), Position = UDim2.fromOffset(124, 36),
		BackgroundTransparency = 1, ClipsDescendants = true,
	}, self.Main)

	-- مقبض تغيير الحجم
	self.Grip = New("TextButton", {
		Size = UDim2.fromOffset(16, 16), AnchorPoint = Vector2.new(1, 1), Position = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1, Text = "◢", Font = Enum.Font.GothamBold, TextSize = 12, ZIndex = 5,
	}, self.Main)
	self:_T(self.Grip, "TextColor3", "SubText")
	Util.Resize(self.Grip, self.Main, Vector2.new(400, 240), self._conns)

	-- الإشعارات
	self.Notes = New("Frame", {
		Size = UDim2.new(0, 260, 1, -24), AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -12, 0, 12), BackgroundTransparency = 1,
	}, self.Gui)
	local noteLayout = Util.List(self.Notes, 6)
	noteLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	noteLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right

	-- التلميحات (Tooltip)
	self.Tip = New("Frame", {
		Size = UDim2.fromOffset(10, 22), Visible = false, BorderSizePixel = 0, ZIndex = 100,
	}, self.Gui)
	Util.Round(self.Tip, 4)
	self:_T(self.Tip, "BackgroundColor3", "Top")
	local tipStroke = Util.Stroke(self.Tip, nil, 1, 0.4)
	self:_T(tipStroke, "Color", "Stroke")
	self.TipLabel = self:_Text(self.Tip, {
		Size = UDim2.fromScale(1, 1), TextSize = 12, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 101,
	})

	-- تصغير النافذة
	local minimized, fullSize = false, nil
	minBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			fullSize = self.Main.Size
			self.Sidebar.Visible, self.Pages.Visible, self.Grip.Visible = false, false, false
			Util.Tween(self.Main, { Size = UDim2.new(fullSize.X.Scale, fullSize.X.Offset, 0, 36) }, 0.2)
		else
			Util.Tween(self.Main, { Size = fullSize }, 0.2)
			task.delay(0.15, function()
				self.Sidebar.Visible, self.Pages.Visible, self.Grip.Visible = true, true, true
			end)
		end
	end)

	-- زر الإخفاء/الإظهار
	table.insert(self._conns, UserInputService.InputBegan:Connect(function(input, processed)
		if not processed and input.KeyCode == self.ToggleKey then
			self:Toggle()
		end
	end))

	-- زر عائم للجوال
	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
		local fab = New("TextButton", {
			Size = UDim2.fromOffset(42, 42), Position = UDim2.new(0, 14, 0.5, -21),
			Text = "N", Font = Enum.Font.GothamBold, TextSize = 18, BorderSizePixel = 0,
		}, self.Gui)
		Util.Round(fab, 21)
		self:_T(fab, "BackgroundColor3", "Accent")
		fab.TextColor3 = Color3.new(1, 1, 1)
		fab.MouseButton1Click:Connect(function() self:Toggle() end)
		Util.Drag(fab, fab, self._conns)
	end

	return self
end

function Library:_T(inst, prop, key)
	inst[prop] = self.Theme[key]
	table.insert(self._themed, { inst, prop, key })
	return inst
end

function Library:_Text(parent, props, colorKey)
	local base = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Font = Enum.Font.Gotham,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
	}
	local l = New("TextLabel", Util.Merge(base, props), parent)
	self:_T(l, "TextColor3", colorKey or "Text")
	return l
end

function Library:_Store(flag, value)
	if flag then
		self.Flags[flag] = value
	end
end

function Library:_Reg(flag, obj)
	self._setters[flag] = obj
	self.Flags[flag] = obj:Get()
end

function Library:_Tip(inst, text)
	inst.MouseEnter:Connect(function()
		self.TipLabel.Text = text
		local w = TextService:GetTextSize(text, 12, Enum.Font.Gotham, Vector2.new(400, 30)).X + 16
		self.Tip.Size = UDim2.fromOffset(w, 22)
		self.Tip.Visible = true
	end)
	inst.MouseMoved:Connect(function(x, y)
		self.Tip.Position = UDim2.fromOffset(x + 14, y + 14)
	end)
	inst.MouseLeave:Connect(function()
		self.Tip.Visible = false
	end)
end

function Library:SetTheme(theme)
	local data = type(theme) == "string" and Themes[theme] or theme
	if type(data) ~= "table" then
		return false
	end
	if type(theme) == "string" then
		self.ThemeName = theme
	end
	self.Theme = Util.Merge(self.Theme, data)
	local alive = {}
	for _, e in ipairs(self._themed) do
		local inst, prop, key = e[1], e[2], e[3]
		if inst.Parent then
			alive[#alive + 1] = e
			Util.Tween(inst, { [prop] = self.Theme[key] }, 0.25)
		end
	end
	self._themed = alive
	self.ThemeChanged:Fire(self.Theme)
	return true
end

function Library:SetTitle(title, subtitle)
	self.TitleLabel.Text = title or self.TitleLabel.Text
	if subtitle then
		self.SubtitleLabel.Text = subtitle
	end
end

function Library:Toggle(state)
	if state == nil then
		state = not self.Main.Visible
	end
	self.Main.Visible = state
end

function Library:Destroy()
	for _, c in ipairs(self._conns) do
		pcall(function() c:Disconnect() end)
	end
	if self._wmConn then
		self._wmConn:Disconnect()
	end
	self.Destroyed:Fire()
	self.Gui:Destroy()
end

--// علامة مائية مع FPS
function Library:Watermark(text)
	if self._wm then
		self._wm:Destroy()
	end
	if self._wmConn then
		self._wmConn:Disconnect()
	end
	local frame = New("Frame", {
		Size = UDim2.fromOffset(0, 24), AutomaticSize = Enum.AutomaticSize.X,
		Position = UDim2.fromOffset(12, 12), BorderSizePixel = 0,
	}, self.Gui)
	Util.Round(frame, 5)
	self:_T(frame, "BackgroundColor3", "Top")
	Util.Pad(frame, 0, 0, 10, 10)
	local accent = New("Frame", { Size = UDim2.new(0, 2, 1, -8), Position = UDim2.fromOffset(-6, 4), BorderSizePixel = 0 }, frame)
	self:_T(accent, "BackgroundColor3", "Accent")
	local label = self:_Text(frame, {
		Size = UDim2.fromOffset(0, 24), AutomaticSize = Enum.AutomaticSize.X, TextSize = 12, Text = text,
	})
	self._wm = frame

	local frames, last = 0, os.clock()
	self._wmConn = RunService.Heartbeat:Connect(function()
		frames += 1
		local now = os.clock()
		if now - last >= 1 then
			label.Text = string.format("%s  |  %d FPS", text, frames)
			frames, last = 0, now
		end
	end)
end

--// الإشعارات
function Library:Notify(a, b, c, d)
	local o = type(a) == "table" and a or { Title = a, Text = b, Duration = c, Type = d }
	local duration = o.Duration or 3
	local color = NotifyColors[o.Type or "info"] or self.Theme.Accent

	local wrap = New("Frame", {
		Size = UDim2.new(1, 0, 0, 60), BackgroundTransparency = 1, ClipsDescendants = true,
	}, self.Notes)
	local card = New("Frame", {
		Size = UDim2.fromScale(1, 1), Position = UDim2.new(1, 20, 0, 0), BorderSizePixel = 0,
	}, wrap)
	Util.Round(card, 6)
	self:_T(card, "BackgroundColor3", "Element")

	local stripe = New("Frame", { Size = UDim2.new(0, 3, 1, 0), BackgroundColor3 = color, BorderSizePixel = 0 }, card)
	Util.Round(stripe, 2)

	self:_Text(card, {
		Size = UDim2.new(1, -20, 0, 20), Position = UDim2.fromOffset(12, 5),
		Text = o.Title or "", Font = Enum.Font.GothamBold,
	})
	self:_Text(card, {
		Size = UDim2.new(1, -20, 0, 28), Position = UDim2.fromOffset(12, 24),
		Text = o.Text or "", TextSize = 12, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top,
	}, "SubText")

	local bar = New("Frame", {
		Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 1, -2),
		BackgroundColor3 = color, BorderSizePixel = 0,
	}, card)

	Util.Tween(card, { Position = UDim2.fromOffset(0, 0) }, 0.25, Enum.EasingStyle.Back)
	Util.Tween(bar, { Size = UDim2.new(0, 0, 0, 2) }, duration, Enum.EasingStyle.Linear)
	task.delay(duration, function()
		if wrap.Parent then
			Util.Tween(card, { Position = UDim2.new(1, 20, 0, 0) }, 0.2)
			task.wait(0.22)
			wrap:Destroy()
		end
	end)
end

--// ============================ Tabs ============================
local Container = {}
Container.__index = Container

function Library:AddTab(name)
	local tab = setmetatable({ Window = self, Name = name, _order = 0 }, Container)

	tab.Button = New("TextButton", {
		Size = UDim2.new(1, 0, 0, 30), BorderSizePixel = 0, AutoButtonColor = false,
		Text = name, Font = Enum.Font.GothamMedium, TextSize = 13, LayoutOrder = #self.Tabs + 1,
	}, self.TabList)
	Util.Round(tab.Button, 6)

	tab.Indicator = New("Frame", {
		Size = UDim2.new(0, 3, 0, 16), AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 2, 0.5, 0), BorderSizePixel = 0, Visible = false,
	}, tab.Button)
	Util.Round(tab.Indicator, 2)

	tab.Page = New("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false,
		ScrollBarThickness = 3, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
	}, self.Pages)
	tab.Holder = tab.Page
	Util.List(tab.Page, 6)
	Util.Pad(tab.Page, 8, 8, 10, 12)

	tab.Button.MouseButton1Click:Connect(function()
		self:SelectTab(tab)
	end)

	table.insert(self.Tabs, tab)
	if #self.Tabs == 1 then
		self:SelectTab(tab)
	else
		self:_PaintTab(tab, false)
	end
	return tab
end

function Library:_PaintTab(tab, active)
	tab.Button.BackgroundColor3 = self.Theme.Element
	tab.Button.BackgroundTransparency = active and 0 or 1
	tab.Button.TextColor3 = active and self.Theme.Text or self.Theme.SubText
	tab.Indicator.BackgroundColor3 = self.Theme.Accent
	tab.Indicator.Visible = active
end

function Library:SelectTab(tab)
	self.ActiveTab = tab
	for _, t in ipairs(self.Tabs) do
		local active = t == tab
		t.Page.Visible = active
		self:_PaintTab(t, active)
	end
	if not self._tabThemeHooked then
		self._tabThemeHooked = true
		self.ThemeChanged:Connect(function()
			for _, t in ipairs(self.Tabs) do
				self:_PaintTab(t, t == self.ActiveTab)
			end
		end)
	end
end

--// ============================ 6) Container: المكونات ============================
function Container:_Row(height)
	local win = self.Window
	self._order += 1
	local f = New("Frame", {
		Size = UDim2.new(1, 0, 0, height or 34), BorderSizePixel = 0, LayoutOrder = self._order,
	}, self.Holder)
	Util.Round(f, 6)
	win:_T(f, "BackgroundColor3", "Element")
	return f
end

function Container:_Finish(frame, o, obj)
	local win = self.Window
	obj.Frame = frame
	function obj:SetVisible(v)
		frame.Visible = v
	end
	if o.Flag then
		win:_Reg(o.Flag, obj)
	end
	if o.Tooltip then
		win:_Tip(frame, o.Tooltip)
	end
	return obj
end

local function opts(a, b)
	if type(a) == "table" then
		return a
	end
	return { Name = a, Callback = b }
end

--// قسم قابل للطي
function Container:AddSection(name)
	local win = self.Window
	self._order += 1
	local box = New("Frame", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1, LayoutOrder = self._order,
	}, self.Holder)
	Util.List(box, 6)

	local header = New("TextButton", {
		Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = 1,
	}, box)
	win:_Text(header, {
		Size = UDim2.new(1, -24, 1, 0), Text = string.upper(name or "Section"),
		Font = Enum.Font.GothamBold, TextSize = 11,
	}, "Accent")
	local arrow = win:_Text(header, {
		Size = UDim2.fromOffset(20, 22), Position = UDim2.new(1, -20, 0, 0),
		Text = "▾", TextXAlignment = Enum.TextXAlignment.Center,
	}, "SubText")

	local holder = New("Frame", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1, LayoutOrder = 2,
	}, box)
	Util.List(holder, 6)

	local open = true
	header.MouseButton1Click:Connect(function()
		open = not open
		holder.Visible = open
		arrow.Text = open and "▾" or "▸"
	end)

	return setmetatable({ Window = win, Holder = holder, _order = 0 }, Container)
end

function Container:AddLabel(a)
	local o = opts(a)
	local win = self.Window
	local f = self:_Row(30)
	local l = win:_Text(f, {
		Size = UDim2.new(1, -20, 1, 0), Position = UDim2.fromOffset(10, 0), Text = o.Name or o.Text or "",
	})
	local obj = {}
	function obj:Set(t) l.Text = t end
	function obj:Get() return l.Text end
	return self:_Finish(f, o, obj)
end

function Container:AddParagraph(o)
	local win = self.Window
	local f = self:_Row(0)
	f.AutomaticSize = Enum.AutomaticSize.Y
	Util.Pad(f, 8, 8, 10, 10)
	Util.List(f, 3)
	win:_Text(f, {
		Size = UDim2.new(1, 0, 0, 16), Text = o.Title or "", Font = Enum.Font.GothamBold, LayoutOrder = 1,
	})
	local body = win:_Text(f, {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = o.Text or "",
		TextWrapped = true, TextSize = 12, TextYAlignment = Enum.TextYAlignment.Top, LayoutOrder = 2,
	}, "SubText")
	local obj = {}
	function obj:Set(t) body.Text = t end
	function obj:Get() return body.Text end
	return self:_Finish(f, o, obj)
end

function Container:AddSeparator()
	local win = self.Window
	self._order += 1
	local line = New("Frame", {
		Size = UDim2.new(1, 0, 0, 1), BorderSizePixel = 0, LayoutOrder = self._order,
	}, self.Holder)
	win:_T(line, "BackgroundColor3", "Stroke")
	return line
end

function Container:AddButton(a, b)
	local o = opts(a, b)
	local win = self.Window
	local f = self:_Row(34)
	local btn = New("TextButton", {
		Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = o.Name or "Button",
		Font = Enum.Font.GothamMedium, TextSize = 13, AutoButtonColor = false,
	}, f)
	win:_T(btn, "TextColor3", "Text")

	btn.MouseEnter:Connect(function()
		Util.Tween(f, { BackgroundColor3 = win.Theme.ElementHover }, 0.1)
	end)
	btn.MouseLeave:Connect(function()
		Util.Tween(f, { BackgroundColor3 = win.Theme.Element }, 0.1)
	end)
	btn.MouseButton1Click:Connect(function()
		f.BackgroundColor3 = win.Theme.Accent
		Util.Tween(f, { BackgroundColor3 = win.Theme.Element }, 0.25)
		if o.Callback then
			task.spawn(o.Callback)
		end
	end)

	local obj = {}
	function obj:SetText(t) btn.Text = t end
	function obj:Get() return btn.Text end
	return self:_Finish(f, o, obj)
end

function Container:AddToggle(o)
	local win = self.Window
	local f = self:_Row(34)
	win:_Text(f, {
		Size = UDim2.new(1, -64, 1, 0), Position = UDim2.fromOffset(10, 0), Text = o.Name or "Toggle",
	})

	local state = o.Default == true
	local box = New("Frame", {
		Size = UDim2.fromOffset(38, 18), AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -8, 0.5, 0), BorderSizePixel = 0,
	}, f)
	Util.Round(box, 9)
	local knob = New("Frame", {
		Size = UDim2.fromOffset(14, 14), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0,
	}, box)
	Util.Round(knob, 7)

	local function paint(animate)
		local col = state and win.Theme.Accent or win.Theme.Top
		local pos = state and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2)
		if animate then
			Util.Tween(box, { BackgroundColor3 = col })
			Util.Tween(knob, { Position = pos })
		else
			box.BackgroundColor3, knob.Position = col, pos
		end
	end
	paint(false)
	win.ThemeChanged:Connect(function() paint(false) end)

	local obj = {}
	function obj:Get() return state end
	function obj:Set(v, silent)
		state = v == true
		paint(true)
		win:_Store(o.Flag, state)
		if o.Callback and not silent then
			task.spawn(o.Callback, state)
		end
	end

	local hit = New("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "" }, f)
	hit.MouseButton1Click:Connect(function()
		obj:Set(not state)
	end)
	return self:_Finish(f, o, obj)
end

function Container:AddSlider(o)
	local win = self.Window
	local min, max = o.Min or 0, o.Max or 100
	local step = o.Step or 1
	local decimals = #(tostring(step):match("%.(%d+)") or "")
	local suffix = o.Suffix or ""

	local f = self:_Row(52)
	win:_Text(f, {
		Size = UDim2.new(0.6, -10, 0, 28), Position = UDim2.fromOffset(10, 0), Text = o.Name or "Slider",
	})
	local valLbl = win:_Text(f, {
		Size = UDim2.new(0.4, -10, 0, 28), Position = UDim2.new(0.6, 0, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Right, TextSize = 12,
	}, "SubText")

	local bar = New("Frame", {
		Size = UDim2.new(1, -20, 0, 6), Position = UDim2.fromOffset(10, 36), BorderSizePixel = 0,
	}, f)
	Util.Round(bar, 3)
	win:_T(bar, "BackgroundColor3", "Top")
	local fill = New("Frame", { Size = UDim2.fromScale(0, 1), BorderSizePixel = 0 }, bar)
	Util.Round(fill, 3)
	win:_T(fill, "BackgroundColor3", "Accent")
	local knob = New("Frame", {
		Size = UDim2.fromOffset(12, 12), AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0, 0.5), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0,
	}, bar)
	Util.Round(knob, 6)

	local value = math.clamp(o.Default or min, min, max)
	local obj = {}
	function obj:Get() return value end
	function obj:Set(v, silent)
		v = tonumber(v) or min
		v = math.clamp(math.floor((v - min) / step + 0.5) * step + min, min, max)
		v = tonumber(string.format("%." .. decimals .. "f", v))
		local changed = v ~= value
		value = v
		local a = (max == min) and 0 or (v - min) / (max - min)
		fill.Size = UDim2.fromScale(a, 1)
		knob.Position = UDim2.fromScale(a, 0.5)
		valLbl.Text = string.format("%." .. decimals .. "f", v) .. suffix
		win:_Store(o.Flag, v)
		if o.Callback and not silent and changed then
			task.spawn(o.Callback, v)
		end
	end
	obj:Set(value, true)

	local dragging = false
	local function update(x)
		local a = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
		obj:Set(min + (max - min) * a)
	end
	local hit = New("TextButton", {
		Size = UDim2.new(1, 0, 0, 26), Position = UDim2.fromOffset(0, 26), BackgroundTransparency = 1, Text = "",
	}, f)
	hit.InputBegan:Connect(function(input)
		if Util.IsPress(input) then
			dragging = true
			update(input.Position.X)
		end
	end)
	table.insert(win._conns, UserInputService.InputEnded:Connect(function(input)
		if Util.IsPress(input) then
			dragging = false
		end
	end))
	table.insert(win._conns, UserInputService.InputChanged:Connect(function(input)
		if dragging and Util.IsMove(input) then
			update(input.Position.X)
		end
	end))
	return self:_Finish(f, o, obj)
end

function Container:AddTextbox(o)
	local win = self.Window
	local f = self:_Row(34)
	win:_Text(f, {
		Size = UDim2.new(0.4, -10, 1, 0), Position = UDim2.fromOffset(10, 0), Text = o.Name or "Textbox",
	})
	local box = New("TextBox", {
		Size = UDim2.new(0.6, -18, 0, 24), AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -8, 0.5, 0), BorderSizePixel = 0, Text = tostring(o.Default or ""),
		PlaceholderText = o.Placeholder or "", ClearTextOnFocus = o.ClearOnFocus == true,
		Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
	}, f)
	Util.Round(box, 4)
	Util.Pad(box, 0, 0, 8, 8)
	win:_T(box, "BackgroundColor3", "Top")
	win:_T(box, "TextColor3", "Text")
	win:_T(box, "PlaceholderColor3", "SubText")

	if o.Numeric then
		box:GetPropertyChangedSignal("Text"):Connect(function()
			local clean = box.Text:gsub("[^%d%.%-]", "")
			if clean ~= box.Text then
				box.Text = clean
			end
		end)
	end

	local obj = {}
	function obj:Get() return box.Text end
	function obj:Set(v, silent)
		box.Text = tostring(v)
		win:_Store(o.Flag, box.Text)
		if o.Callback and not silent then
			task.spawn(o.Callback, box.Text)
		end
	end
	box.FocusLost:Connect(function(enter)
		win:_Store(o.Flag, box.Text)
		if o.Callback then
			task.spawn(o.Callback, box.Text, enter)
		end
	end)
	return self:_Finish(f, o, obj)
end

function Container:AddDropdown(o)
	local win = self.Window
	local multi = o.Multi == true
	local options = o.Options or {}
	local chosen, single = {}, nil
	local open = false
	local btns = {}

	local f = self:_Row(34)
	f.ClipsDescendants = true
	local head = New("TextButton", {
		Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
	}, f)
	win:_Text(head, {
		Size = UDim2.new(0.5, -10, 1, 0), Position = UDim2.fromOffset(10, 0), Text = o.Name or "Dropdown",
	})
	local valLbl = win:_Text(head, {
		Size = UDim2.new(0.5, -34, 1, 0), Position = UDim2.new(0.5, 0, 0, 0), Text = "—", TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd,
	}, "SubText")
	local arrow = win:_Text(head, {
		Size = UDim2.fromOffset(24, 34), Position = UDim2.new(1, -26, 0, 0), Text = "▾",
		TextXAlignment = Enum.TextXAlignment.Center, Font = Enum.Font.GothamBold, TextSize = 14,
	}, "SubText")

	local list = New("ScrollingFrame", {
		Size = UDim2.new(1, -12, 0, 0), Position = UDim2.fromOffset(6, 38), BackgroundTransparency = 1,
		BorderSizePixel = 0, ScrollBarThickness = 2, CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
	}, f)
	Util.List(list, 3)

	local obj = {}
	function obj:Get()
		if not multi then
			return single
		end
		local out = {}
		for _, opt in ipairs(options) do
			if chosen[tostring(opt)] then
				out[#out + 1] = opt
			end
		end
		return out
	end

	local function summary()
		if multi then
			local names = {}
			for _, opt in ipairs(options) do
				if chosen[tostring(opt)] then
					names[#names + 1] = tostring(opt)
				end
			end
			return #names > 0 and table.concat(names, ", ") or "—"
		end
		return single ~= nil and tostring(single) or "—"
	end

	local function paint()
		for _, e in ipairs(btns) do
			local on
			if multi then
				on = chosen[tostring(e.opt)] == true
			else
				on = single == e.opt
			end
			e.btn.BackgroundColor3 = on and win.Theme.Accent or win.Theme.Top
			e.btn.TextColor3 = win.Theme.Text
		end
		valLbl.Text = summary()
	end

	local function setOpen(v)
		open = v
		local h = math.min(#options, 6) * 25
		list.Size = UDim2.new(1, -12, 0, h)
		Util.Tween(f, { Size = UDim2.new(1, 0, 0, v and (34 + h + 10) or 34) })
		arrow.Text = v and "▴" or "▾"
	end

	local function build()
		for _, e in ipairs(btns) do
			e.btn:Destroy()
		end
		btns = {}
		for i, opt in ipairs(options) do
			local b = New("TextButton", {
				Size = UDim2.new(1, -4, 0, 22), BorderSizePixel = 0, Text = tostring(opt),
				Font = Enum.Font.Gotham, TextSize = 12, AutoButtonColor = false, LayoutOrder = i,
			}, list)
			Util.Round(b, 4)
			b.MouseButton1Click:Connect(function()
				if multi then
					chosen[tostring(opt)] = (not chosen[tostring(opt)]) or nil
				else
					single = opt
					setOpen(false)
				end
				paint()
				win:_Store(o.Flag, obj:Get())
				if o.Callback then
					task.spawn(o.Callback, obj:Get())
				end
			end)
			btns[#btns + 1] = { opt = opt, btn = b }
		end
		paint()
		if open then
			setOpen(true)
		end
	end

	function obj:Set(v, silent)
		if multi then
			chosen = {}
			for _, x in ipairs(type(v) == "table" and v or {}) do
				chosen[tostring(x)] = true
			end
		else
			single = v
		end
		paint()
		win:_Store(o.Flag, obj:Get())
		if o.Callback and not silent then
			task.spawn(o.Callback, obj:Get())
		end
	end

	function obj:Refresh(newOptions, keepSelection)
		options = newOptions or {}
		if not keepSelection then
			chosen, single = {}, nil
		end
		build()
	end

	if o.Default ~= nil then
		if multi then
			for _, x in ipairs(type(o.Default) == "table" and o.Default or { o.Default }) do
				chosen[tostring(x)] = true
			end
		else
			single = o.Default
		end
	end
	build()
	win.ThemeChanged:Connect(paint)
	head.MouseButton1Click:Connect(function()
		setOpen(not open)
	end)
	return self:_Finish(f, o, obj)
end

function Container:AddKeybind(o)
	local win = self.Window
	local f = self:_Row(34)
	win:_Text(f, {
		Size = UDim2.new(1, -110, 1, 0), Position = UDim2.fromOffset(10, 0), Text = o.Name or "Keybind",
	})
	local btn = New("TextButton", {
		Size = UDim2.fromOffset(86, 22), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0),
		BorderSizePixel = 0, Font = Enum.Font.GothamMedium, TextSize = 12, AutoButtonColor = false,
	}, f)
	Util.Round(btn, 4)
	win:_T(btn, "BackgroundColor3", "Top")
	win:_T(btn, "TextColor3", "Text")

	local key = o.Default
	local binding = false
	local obj = {}
	function obj:Get() return key end
	function obj:Set(k, silent)
		if typeof(k) ~= "EnumItem" then
			k = nil
		end
		key = k
		btn.Text = key and key.Name or "None"
		win:_Store(o.Flag, key)
		if o.Changed and not silent then
			task.spawn(o.Changed, key)
		end
	end
	obj:Set(key, true)

	btn.MouseButton1Click:Connect(function()
		binding = true
		btn.Text = "..."
	end)
	table.insert(win._conns, UserInputService.InputBegan:Connect(function(input, processed)
		if binding then
			if input.UserInputType == Enum.UserInputType.Keyboard then
				binding = false
				if input.KeyCode == Enum.KeyCode.Escape then
					obj:Set(nil)
				else
					obj:Set(input.KeyCode)
				end
			end
		elseif not processed and key and input.KeyCode == key and o.Callback then
			task.spawn(o.Callback, key)
		end
	end))
	return self:_Finish(f, o, obj)
end

function Container:AddColorPicker(o)
	local win = self.Window
	local f = self:_Row(34)
	f.ClipsDescendants = true
	local head = New("TextButton", {
		Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
	}, f)
	win:_Text(head, {
		Size = UDim2.new(1, -60, 1, 0), Position = UDim2.fromOffset(10, 0), Text = o.Name or "Color",
	})
	local swatch = New("Frame", {
		Size = UDim2.fromOffset(34, 18), AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -8, 0.5, 0), BorderSizePixel = 0,
	}, head)
	Util.Round(swatch, 4)
	Util.Stroke(swatch, Color3.new(1, 1, 1), 1, 0.7)

	local body = New("Frame", {
		Size = UDim2.new(1, -20, 0, 122), Position = UDim2.fromOffset(10, 40), BackgroundTransparency = 1,
	}, f)

	-- مربع التشبع/السطوع
	local sv = New("Frame", { Size = UDim2.new(1, -26, 0, 96), BorderSizePixel = 0 }, body)
	Util.Round(sv, 4)
	local white = New("Frame", {
		Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0,
	}, sv)
	Util.Round(white, 4)
	New("UIGradient", {
		Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }),
	}, white)
	local black = New("Frame", {
		Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0,
	}, sv)
	Util.Round(black, 4)
	New("UIGradient", {
		Rotation = 90,
		Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) }),
	}, black)
	local svCursor = New("Frame", {
		Size = UDim2.fromOffset(10, 10), AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 3,
	}, sv)
	Util.Round(svCursor, 5)
	Util.Stroke(svCursor, Color3.new(0, 0, 0), 1, 0.2)

	-- شريط الدرجة (Hue)
	local hue = New("Frame", {
		Size = UDim2.new(0, 16, 0, 96), Position = UDim2.new(1, -16, 0, 0),
		BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0,
	}, body)
	Util.Round(hue, 4)
	New("UIGradient", {
		Rotation = 90,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
			ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
			ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
			ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
			ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
			ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
			ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0)),
		}),
	}, hue)
	local hueCursor = New("Frame", {
		Size = UDim2.new(1, 4, 0, 4), AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 3,
	}, hue)
	Util.Stroke(hueCursor, Color3.new(0, 0, 0), 1, 0.2)

	-- خانة الهكس
	local hexBox = New("TextBox", {
		Size = UDim2.new(1, 0, 0, 20), Position = UDim2.fromOffset(0, 102), BorderSizePixel = 0,
		Font = Enum.Font.Code, TextSize = 12, ClearTextOnFocus = false,
	}, body)
	Util.Round(hexBox, 4)
	win:_T(hexBox, "BackgroundColor3", "Top")
	win:_T(hexBox, "TextColor3", "Text")

	local h, s, v = (o.Default or Color3.fromRGB(255, 255, 255)):ToHSV()
	local obj = {}

	local function apply(silent)
		local c = Color3.fromHSV(h, s, v)
		swatch.BackgroundColor3 = c
		sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
		svCursor.Position = UDim2.fromScale(s, 1 - v)
		hueCursor.Position = UDim2.fromScale(0.5, h)
		hexBox.Text = Util.ToHex(c)
		win:_Store(o.Flag, c)
		if o.Callback and not silent then
			task.spawn(o.Callback, c)
		end
	end

	function obj:Get() return Color3.fromHSV(h, s, v) end
	function obj:Set(c, silent)
		if typeof(c) == "Color3" then
			h, s, v = c:ToHSV()
			apply(silent)
		end
	end
	apply(true)

	local dragSV, dragH = false, false
	local function setSV(x, y)
		s = math.clamp((x - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1)
		v = 1 - math.clamp((y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1)
		apply()
	end
	local function setH(y)
		h = math.clamp((y - hue.AbsolutePosition.Y) / hue.AbsoluteSize.Y, 0, 1)
		apply()
	end
	sv.InputBegan:Connect(function(input)
		if Util.IsPress(input) then
			dragSV = true
			setSV(input.Position.X, input.Position.Y)
		end
	end)
	hue.InputBegan:Connect(function(input)
		if Util.IsPress(input) then
			dragH = true
			setH(input.Position.Y)
		end
	end)
	table.insert(win._conns, UserInputService.InputEnded:Connect(function(input)
		if Util.IsPress(input) then
			dragSV, dragH = false, false
		end
	end))
	table.insert(win._conns, UserInputService.InputChanged:Connect(function(input)
		if Util.IsMove(input) then
			if dragSV then
				setSV(input.Position.X, input.Position.Y)
			elseif dragH then
				setH(input.Position.Y)
			end
		end
	end))
	hexBox.FocusLost:Connect(function()
		local c = Util.FromHex(hexBox.Text)
		if c then
			obj:Set(c)
		else
			apply(true)
		end
	end)

	local open = false
	head.MouseButton1Click:Connect(function()
		open = not open
		Util.Tween(f, { Size = UDim2.new(1, 0, 0, open and 172 or 34) })
	end)
	return self:_Finish(f, o, obj)
end

function Container:AddProgressBar(o)
	local win = self.Window
	local f = self:_Row(44)
	win:_Text(f, {
		Size = UDim2.new(0.6, -10, 0, 26), Position = UDim2.fromOffset(10, 0), Text = o.Name or "Progress",
	})
	local pct = win:_Text(f, {
		Size = UDim2.new(0.4, -10, 0, 26), Position = UDim2.new(0.6, 0, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Right, TextSize = 12,
	}, "SubText")
	local bar = New("Frame", {
		Size = UDim2.new(1, -20, 0, 8), Position = UDim2.fromOffset(10, 28), BorderSizePixel = 0,
	}, f)
	Util.Round(bar, 4)
	win:_T(bar, "BackgroundColor3", "Top")
	local fill = New("Frame", { Size = UDim2.fromScale(0, 1), BorderSizePixel = 0 }, bar)
	Util.Round(fill, 4)
	win:_T(fill, "BackgroundColor3", "Accent")

	local value = 0
	local obj = {}
	function obj:Get() return value end
	function obj:Set(v)
		value = math.clamp(tonumber(v) or 0, 0, 1)
		Util.Tween(fill, { Size = UDim2.fromScale(value, 1) }, 0.2)
		pct.Text = string.format("%d%%", math.round(value * 100))
	end
	obj:Set(o.Value or 0)
	return self:_Finish(f, o, obj)
end

function Container:AddConsole(o)
	o = o or {}
	local win = self.Window
	local f = self:_Row(o.Height or 140)
	win:_T(f, "BackgroundColor3", "Top")
	local sf = New("ScrollingFrame", {
		Size = UDim2.new(1, -10, 1, -10), Position = UDim2.fromOffset(5, 5), BackgroundTransparency = 1,
		BorderSizePixel = 0, ScrollBarThickness = 3, CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
	}, f)
	Util.List(sf, 2)

	local lines, count = {}, 0
	local obj = {}
	function obj:Log(text, color)
		count += 1
		local l = New("TextLabel", {
			Size = UDim2.new(1, -6, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
			Text = tostring(text), TextWrapped = true, Font = Enum.Font.Code, TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
			LayoutOrder = count,
		}, sf)
		if typeof(color) == "Color3" then
			l.TextColor3 = color
		else
			win:_T(l, "TextColor3", type(color) == "string" and color or "Text")
		end
		lines[#lines + 1] = l
		if #lines > 200 then
			table.remove(lines, 1):Destroy()
		end
		task.defer(function()
			task.wait()
			sf.CanvasPosition = Vector2.new(0, 1e6)
		end)
	end
	function obj:Clear()
		for _, l in ipairs(lines) do
			l:Destroy()
		end
		lines = {}
	end
	function obj:Get() return #lines end
	return self:_Finish(f, o, obj)
end

--// ============================ 7) Config / Settings ============================
local function encodeValue(v)
	if typeof(v) == "Color3" then
		return { __c = Util.ToHex(v) }
	elseif typeof(v) == "EnumItem" then
		return { __k = v.Name }
	end
	return v
end

local function decodeValue(v)
	if type(v) == "table" then
		if v.__c then
			return Util.FromHex(v.__c)
		elseif v.__k then
			local ok, k = pcall(function() return Enum.KeyCode[v.__k] end)
			return ok and k or nil
		end
	end
	return v
end

function Library:_ConfigPath(name)
	return self.ConfigFolder .. "/" .. name .. ".json"
end

function Library:SaveConfig(name)
	if not FS.write then
		return false, "writefile غير متوفر"
	end
	if not name or name == "" then
		return false, "اكتب اسم للإعداد"
	end
	local data = {}
	for flag, obj in pairs(self._setters) do
		local v = obj:Get()
		if v ~= nil then
			data[flag] = encodeValue(v)
		end
	end
	local json, err = Net.Encode(data)
	if not json then
		return false, tostring(err)
	end
	local ok, e = pcall(function()
		if FS.makefolder and FS.isfolder and not FS.isfolder(self.ConfigFolder) then
			FS.makefolder(self.ConfigFolder)
		end
		FS.write(self:_ConfigPath(name), json)
	end)
	return ok, ok and nil or tostring(e)
end

function Library:LoadConfig(name)
	if not FS.read or not FS.isfile then
		return false, "readfile غير متوفر"
	end
	local path = self:_ConfigPath(name)
	if not FS.isfile(path) then
		return false, "الملف غير موجود"
	end
	local ok, raw = pcall(FS.read, path)
	if not ok then
		return false, tostring(raw)
	end
	local data = Net.Decode(raw)
	if type(data) ~= "table" then
		return false, "ملف تالف"
	end
	for flag, value in pairs(data) do
		local obj = self._setters[flag]
		if obj then
			pcall(function() obj:Set(decodeValue(value)) end)
		end
	end
	return true
end

function Library:DeleteConfig(name)
	if FS.delete and FS.isfile and FS.isfile(self:_ConfigPath(name)) then
		return pcall(FS.delete, self:_ConfigPath(name))
	end
	return false
end

function Library:ListConfigs()
	local out = {}
	if FS.list and FS.isfolder and FS.isfolder(self.ConfigFolder) then
		local ok, files = pcall(FS.list, self.ConfigFolder)
		if ok then
			for _, p in ipairs(files) do
				local n = p:match("([^/\\]+)%.json$")
				if n then
					out[#out + 1] = n
				end
			end
		end
	end
	table.sort(out)
	return out
end

function Library:AddSettingsTab()
	local tab = self:AddTab("الإعدادات")

	local ui = tab:AddSection("الواجهة")
	local names = {}
	for n in pairs(Themes) do
		names[#names + 1] = n
	end
	table.sort(names)
	ui:AddDropdown({
		Name = "الثيم", Options = names, Default = self.ThemeName, Flag = "__theme",
		Callback = function(v) self:SetTheme(v) end,
	})
	ui:AddKeybind({
		Name = "زر الإخفاء", Default = self.ToggleKey, Flag = "__togglekey",
		Changed = function(k) self.ToggleKey = k end,
	})
	ui:AddButton("إظهار علامة FPS", function() self:Watermark("NovaUI") end)

	local cfg = tab:AddSection("الإعدادات المحفوظة")
	local nameBox = cfg:AddTextbox({ Name = "اسم الإعداد", Placeholder = "default" })
	local drop = cfg:AddDropdown({ Name = "المحفوظة", Options = self:ListConfigs() })

	local function pick()
		local n = nameBox:Get()
		if n == "" then
			n = drop:Get() or ""
		end
		return n
	end
	cfg:AddButton("حفظ", function()
		local ok, err = self:SaveConfig(pick())
		self:Notify(ok and "تم الحفظ" or "فشل الحفظ", ok and pick() or tostring(err), 3, ok and "success" or "error")
		drop:Refresh(self:ListConfigs(), true)
	end)
	cfg:AddButton("تحميل", function()
		local ok, err = self:LoadConfig(pick())
		self:Notify(ok and "تم التحميل" or "فشل التحميل", ok and pick() or tostring(err), 3, ok and "success" or "error")
	end)
	cfg:AddButton("حذف", function()
		self:DeleteConfig(pick())
		drop:Refresh(self:ListConfigs())
		self:Notify("تم الحذف", pick(), 2, "warn")
	end)
	cfg:AddButton("تحديث القائمة", function()
		drop:Refresh(self:ListConfigs(), true)
	end)

	local misc = tab:AddSection("أخرى")
	misc:AddButton("إغلاق الواجهة", function() self:Destroy() end)
	return tab
end

--// ============================ 8) مثال تشغيل ============================
local RUN_DEMO = true

if RUN_DEMO then
	local win = Library.new({
		Title = "NovaUI", Subtitle = "v2.0", Theme = "Dark", ToggleKey = Enum.KeyCode.RightShift,
	})

	-- تاب الرئيسية
	local main = win:AddTab("الرئيسية")
	local basics = main:AddSection("عناصر أساسية")
	basics:AddLabel("أهلاً فيك في NovaUI")
	basics:AddButton({
		Name = "اضغط", Tooltip = "يطلع إشعار",
		Callback = function() win:Notify("تم", "انضغط الزر", 3, "success") end,
	})
	basics:AddToggle({ Name = "Auto Farm", Flag = "autofarm", Callback = function(v) print("AutoFarm:", v) end })
	basics:AddSlider({ Name = "السرعة", Min = 0, Max = 100, Default = 16, Flag = "speed", Suffix = " st" })
	basics:AddSlider({ Name = "الشفافية", Min = 0, Max = 1, Step = 0.05, Default = 0.5, Flag = "alpha" })
	basics:AddTextbox({ Name = "الاسم", Placeholder = "اكتب...", Flag = "name" })
	basics:AddTextbox({ Name = "رقم", Numeric = true, Placeholder = "123", Flag = "num" })

	local adv = main:AddSection("متقدم")
	adv:AddDropdown({ Name = "الوضع", Options = { "Easy", "Normal", "Hard" }, Default = "Normal", Flag = "mode" })
	adv:AddDropdown({
		Name = "متعدد", Options = { "A", "B", "C", "D", "E", "F", "G" }, Multi = true,
		Default = { "A", "C" }, Flag = "multi",
	})
	adv:AddKeybind({ Name = "زر الأكشن", Default = Enum.KeyCode.F, Flag = "actionkey",
		Callback = function() win:Notify("Keybind", "ضغطت F", 2) end })
	adv:AddColorPicker({ Name = "اللون", Default = Color3.fromRGB(90, 120, 255), Flag = "color" })
	adv:AddSeparator()
	local prog = adv:AddProgressBar({ Name = "تقدّم", Value = 0.3 })
	adv:AddButton("زيادة 10%", function() prog:Set(prog:Get() + 0.1) end)
	adv:AddParagraph({ Title = "ملاحظة", Text = "هذا نص طويل يوضح إن الفقرة تلتف تلقائياً وتتمدد حسب المحتوى." })

	-- تاب الشبكة
	local net = win:AddTab("الشبكة")
	local console = net:AddConsole({ Height = 150 })
	local url = net:AddTextbox({ Name = "الرابط", Default = "httpbin.org/get", Placeholder = "example.com/api" })

	local function report(client, res)
		local color = res.Success and NotifyColors.success or NotifyColors.error
		console:Log(string.format("[%s] %s → %d (%.0fms)", client.Name, res.Url, res.StatusCode, res.Elapsed * 1000), color)
		if not res.Success then
			console:Log("   " .. tostring(res.Error), NotifyColors.warn)
		end
	end

	net:AddButton("Http GET (يحافظ على البروتوكول)", function()
		local target = url:Get():find("://") and url:Get() or ("http://" .. url:Get())
		report(Http, Http.Get(target))
	end)
	net:AddButton("Https GET (يفرض https)", function()
		report(Https, Https.Get(url:Get()))
	end)
	net:AddButton("Https POST JSON", function()
		local data, res = Https.PostJson("httpbin.org/post", { hello = "world", time = os.time() })
		report(Https, res)
		if data then
			console:Log("   json.hello = " .. tostring(data.json and data.json.hello), "SubText")
		end
	end)
	net:AddButton("Ping Http vs Https", function()
		local _, msHttp = Http.Ping("http://httpbin.org/get")
		local _, msHttps = Https.Ping("httpbin.org/get")
		console:Log(string.format("Ping: http=%dms  https=%dms", msHttp, msHttps), "Accent")
	end)
	net:AddButton("مسح السجل", function() console:Clear() end)

	win:AddSettingsTab()
	win:Notify({ Title = "NovaUI", Text = "تم تحميل المكتبة بنجاح", Type = "success" })
end

return Library
