-- ║         LOPK Library  |  Cyan Edition        ║
-- ║         Theme: Neon Cyan / Deep Purple        ║
-- ║         Version: 2.0.0                        ║
-- ║         Modified: Added Funk Music + Images   ║

local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService   = game:GetService("UserInputService")
local TweenService       = game:GetService("TweenService")
local HttpService        = game:GetService("HttpService")
local RunService         = game:GetService("RunService")
local CoreGui            = game:GetService("CoreGui")
local Players            = game:GetService("Players")
local Player             = Players.LocalPlayer
local PlayerMouse        = Player:GetMouse()

-- ══════════════════════════════════════════
-- [1] شاشة التحميل مع الصورة والفونك
-- ══════════════════════════════════════════
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "LOPKLoadingScreen"
LoadingGui.ResetOnSpawn = false
LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() LoadingGui.Parent = game:GetService("CoreGui") end)

-- الخلفية الداكنة
local LoadBG = Instance.new("Frame")
LoadBG.Size = UDim2.fromScale(1, 1)
LoadBG.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
LoadBG.BorderSizePixel = 0
LoadBG.Parent = LoadingGui

-- الصورة الرئيسية في شاشة التحميل (116627951531486)
local LoadImg = Instance.new("ImageLabel")
LoadImg.Size = UDim2.fromOffset(220, 220)
LoadImg.Position = UDim2.new(0.5, -110, 0.5, -150)
LoadImg.BackgroundTransparency = 1
LoadImg.Image = "rbxassetid://116627951531486"
LoadImg.ImageTransparency = 0
LoadImg.ScaleType = Enum.ScaleType.Fit
LoadImg.Parent = LoadBG

-- كورنر دائري للصورة
local LoadImgCorner = Instance.new("UICorner", LoadImg)
LoadImgCorner.CornerRadius = UDim.new(0, 20)

-- حواف نيون للصورة
local LoadImgStroke = Instance.new("UIStroke", LoadImg)
LoadImgStroke.Thickness = 2
LoadImgStroke.Color = Color3.fromRGB(0, 220, 255)
LoadImgStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- أنيميشن نبض الحواف
task.spawn(function()
    local a = 0
    while LoadImg and LoadImg.Parent do
        a = (a + 4) % 360
        local w = (math.sin(math.rad(a)) + 1) / 2
        pcall(function()
            LoadImgStroke.Color = Color3.fromRGB(
                math.floor(w * 50),
                math.floor(180 + w * 75),
                255
            )
        end)
        task.wait(0.04)
    end
end)

-- نص التحميل
local LoadTitle = Instance.new("TextLabel")
LoadTitle.Size = UDim2.new(1, 0, 0, 30)
LoadTitle.Position = UDim2.new(0, 0, 0.5, 85)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Text = "LOPK Library - Cyan Edition"
LoadTitle.TextColor3 = Color3.fromRGB(0, 220, 255)
LoadTitle.TextSize = 18
LoadTitle.Font = Enum.Font.GothamBold
LoadTitle.TextXAlignment = Enum.TextXAlignment.Center
LoadTitle.Parent = LoadBG

local LoadSub = Instance.new("TextLabel")
LoadSub.Size = UDim2.new(1, 0, 0, 20)
LoadSub.Position = UDim2.new(0, 0, 0.5, 118)
LoadSub.BackgroundTransparency = 1
LoadSub.Text = "جاري التحميل..."
LoadSub.TextColor3 = Color3.fromRGB(160, 220, 220)
LoadSub.TextSize = 12
LoadSub.Font = Enum.Font.Gotham
LoadSub.TextXAlignment = Enum.TextXAlignment.Center
LoadSub.Parent = LoadBG

-- شريط التحميل
local BarBG = Instance.new("Frame")
BarBG.Size = UDim2.new(0, 300, 0, 5)
BarBG.Position = UDim2.new(0.5, -150, 0.5, 148)
BarBG.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
BarBG.BorderSizePixel = 0
BarBG.Parent = LoadBG
local BarBGC = Instance.new("UICorner", BarBG)
BarBGC.CornerRadius = UDim.new(1, 0)

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(0, 220, 255)
BarFill.BorderSizePixel = 0
BarFill.Parent = BarBG
local BarFillC = Instance.new("UICorner", BarFill)
BarFillC.CornerRadius = UDim.new(1, 0)

-- الصورة في الحواف الأربعة لشاشة التحميل
local cornerPositions = {
    {UDim2.fromOffset(0, 0),        Vector2.new(0, 0)},
    {UDim2.new(1, 0, 0, 0),        Vector2.new(1, 0)},
    {UDim2.new(0, 0, 1, 0),        Vector2.new(0, 1)},
    {UDim2.new(1, 0, 1, 0),        Vector2.new(1, 1)},
}
for _, cp in ipairs(cornerPositions) do
    local ci = Instance.new("ImageLabel")
    ci.Size = UDim2.fromOffset(70, 70)
    ci.Position = cp[1]
    ci.AnchorPoint = cp[2]
    ci.BackgroundTransparency = 1
    ci.Image = "rbxassetid://116627951531486"
    ci.ImageTransparency = 0.3
    ci.ScaleType = Enum.ScaleType.Fit
    ci.Parent = LoadBG
    local cc = Instance.new("UICorner", ci)
    cc.CornerRadius = UDim.new(0, 10)
end

-- [1] تشغيل الفونك (84878105728262) فور بدء السكربت
local _SoundService = game:GetService("SoundService")
local _FunkMusic = Instance.new("Sound")
_FunkMusic.SoundId = "rbxassetid://84878105728262"
_FunkMusic.Volume = 0.8
_FunkMusic.Looped = true  -- تدور بشكل مستمر
_FunkMusic.Parent = _SoundService
pcall(function() _FunkMusic:Play() end)

-- أنيميشن شريط التحميل (17 ثانية)
task.spawn(function()
    local duration = 17
    local interval = 0.05
    local elapsed = 0
    while elapsed < duration do
        task.wait(interval)
        elapsed = elapsed + interval
        local ratio = math.min(elapsed / duration, 1)
        pcall(function()
            BarFill.Size = UDim2.new(ratio, 0, 1, 0)
            LoadSub.Text = string.format("جاري التحميل... %.0f%%", ratio * 100)
        end)
    end
    -- إخفاء شاشة التحميل بعد الانتهاء
    TweenService:Create(LoadBG, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {
        BackgroundTransparency = 1
    }):Play()
    for _, v in ipairs(LoadBG:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("ImageLabel") or v:IsA("Frame") then
            pcall(function()
                TweenService:Create(v, TweenInfo.new(0.5), {
                    BackgroundTransparency = 1,
                    ImageTransparency = 1,
                    TextTransparency = 1,
                }):Play()
            end)
        end
    end
    task.wait(0.7)
    LoadingGui:Destroy()
end)

-- ══════════════════════════════════════════
-- بقية المكتبة الأصلية
-- ══════════════════════════════════════════

local lopklib = {
	Themes = {
		Darker = {
			["Color Hub 1"]      = ColorSequence.new({
				ColorSequenceKeypoint.new(0.00, Color3.fromRGB(5, 5, 5)),
				ColorSequenceKeypoint.new(0.50, Color3.fromRGB(20, 20, 20)),
				ColorSequenceKeypoint.new(1.00, Color3.fromRGB(5, 5, 5))
			}),
			["Color Hub 2"]      = Color3.fromRGB(15, 15, 15),
			["Color Stroke"]     = Color3.fromRGB(255, 255, 255),
			["Color Theme"]      = Color3.fromRGB(255, 255, 255),
			["Color Text"]       = Color3.fromRGB(255, 255, 255),
			["Color Dark Text"]  = Color3.fromRGB(200, 200, 200),
			["Color Dark Purple"]= Color3.fromRGB(255, 255, 255),
			["Color Hub 9"]      = Color3.fromRGB(0,   0,   0),
			["Color Dark Greem"] = Color3.fromRGB(220, 220, 220)
		},
		Dark = {
			["Color Hub 1"]      = ColorSequence.new({
				ColorSequenceKeypoint.new(0.00, Color3.fromRGB(5, 5, 5)),
				ColorSequenceKeypoint.new(0.50, Color3.fromRGB(20, 20, 20)),
				ColorSequenceKeypoint.new(1.00, Color3.fromRGB(5, 5, 5))
			}),
			["Color Hub 2"]      = Color3.fromRGB(15, 15, 15),
			["Color Stroke"]     = Color3.fromRGB(255, 255, 255),
			["Color Theme"]      = Color3.fromRGB(255, 255, 255),
			["Color Text"]       = Color3.fromRGB(255, 255, 255),
			["Color Dark Text"]  = Color3.fromRGB(200, 200, 200),
			["Color Dark Purple"]= Color3.fromRGB(255, 255, 255),
			["Color Hub 9"]      = Color3.fromRGB(0,   0,   0),
			["Color Dark Greem"] = Color3.fromRGB(220, 220, 220)
		},
		Purple = {
			["Color Hub 1"]      = ColorSequence.new({
				ColorSequenceKeypoint.new(0.00, Color3.fromRGB(5, 5, 5)),
				ColorSequenceKeypoint.new(0.50, Color3.fromRGB(20, 20, 20)),
				ColorSequenceKeypoint.new(1.00, Color3.fromRGB(5, 5, 5))
			}),
			["Color Hub 2"]      = Color3.fromRGB(15, 15, 15),
			["Color Stroke"]     = Color3.fromRGB(255, 255, 255),
			["Color Theme"]      = Color3.fromRGB(255, 255, 255),
			["Color Text"]       = Color3.fromRGB(255, 255, 255),
			["Color Dark Text"]  = Color3.fromRGB(200, 200, 200),
			["Color Dark Purple"]= Color3.fromRGB(255, 255, 255),
			["Color Hub 9"]      = Color3.fromRGB(0,   0,   0),
			["Color Dark Greem"] = Color3.fromRGB(220, 220, 220)
		},
		Neon = {
			["Color Hub 1"]      = ColorSequence.new({
				ColorSequenceKeypoint.new(0.00, Color3.fromRGB(5, 5, 5)),
				ColorSequenceKeypoint.new(0.50, Color3.fromRGB(20, 20, 20)),
				ColorSequenceKeypoint.new(1.00, Color3.fromRGB(5, 5, 5))
			}),
			["Color Hub 2"]      = Color3.fromRGB(15, 15, 15),
			["Color Stroke"]     = Color3.fromRGB(255, 255, 255),
			["Color Theme"]      = Color3.fromRGB(255, 255, 255),
			["Color Text"]       = Color3.fromRGB(255, 255, 255),
			["Color Dark Text"]  = Color3.fromRGB(200, 200, 200),
			["Color Dark Purple"]= Color3.fromRGB(255, 255, 255),
			["Color Hub 9"]      = Color3.fromRGB(0,   0,   0),
			["Color Dark Greem"] = Color3.fromRGB(220, 220, 220)
		}
	},
	Info       = { Version = "2.0.0" },
	Save       = { UISize = {560, 390}, TabSize = 165, Theme = "Dark" },
	Settings   = {},
	Connection = {},
	Instances  = {},
	Elements   = {},
	Options    = {},
	Flags      = {},
	Tabs       = {},
	Icons      = (function()
		return {
			["accessibility"] = "rbxassetid://10709751939",
			["activity"] = "rbxassetid://10709752035",
			["airvent"] = "rbxassetid://10709752131",
			["airplay"] = "rbxassetid://10709752254",
			["alarmcheck"] = "rbxassetid://10709752405",
			["alarmclock"] = "rbxassetid://10709752630",
			["alarmclockoff"] = "rbxassetid://10709752508",
			["alarmminus"] = "rbxassetid://10709752732",
			["alarmplus"] = "rbxassetid://10709752825",
			["album"] = "rbxassetid://10709752906",
			["alertcircle"] = "rbxassetid://10709752996",
			["alertoctagon"] = "rbxassetid://10709753064",
			["alerttriangle"] = "rbxassetid://10709753149",
			["aligncenter"] = "rbxassetid://10709753570",
			["aligncenterhorizontal"] = "rbxassetid://10709753272",
			["aligncentervertical"] = "rbxassetid://10709753421",
			["anchor"] = "rbxassetid://10709761530",
			["angry"] = "rbxassetid://10709761629",
			["aperture"] = "rbxassetid://10709761813",
			["archive"] = "rbxassetid://10709762233",
			["archiverestore"] = "rbxassetid://10709762058",
			["arrowbigdown"] = "rbxassetid://10747796644",
			["arrowbigleft"] = "rbxassetid://10709762574",
			["arrowbigright"] = "rbxassetid://10709762727",
			["arrowbigup"] = "rbxassetid://10709762879",
			["arrowdown"] = "rbxassetid://10709767827",
			["arrowdowncircle"] = "rbxassetid://10709763034",
			["arrowleft"] = "rbxassetid://10709768114",
			["arrowleftcircle"] = "rbxassetid://10709767936",
			["arrowright"] = "rbxassetid://10709768347",
			["arrowrightcircle"] = "rbxassetid://10709768226",
			["arrowup"] = "rbxassetid://10709768939",
			["arrowupcircle"] = "rbxassetid://10709768432",
			["award"] = "rbxassetid://10709769406",
			["axe"] = "rbxassetid://10709769508",
			["baby"] = "rbxassetid://10709769732",
			["backpack"] = "rbxassetid://10709769841",
			["bell"] = "rbxassetid://10709775704",
			["belloff"] = "rbxassetid://10709775320",
			["bellring"] = "rbxassetid://10709775560",
			["bike"] = "rbxassetid://10709775894",
			["bold"] = "rbxassetid://10747813908",
			["bomb"] = "rbxassetid://10709781460",
			["book"] = "rbxassetid://10709781824",
			["bookopen"] = "rbxassetid://10709781717",
			["bookmark"] = "rbxassetid://10709782154",
			["bot"] = "rbxassetid://10709782230",
			["box"] = "rbxassetid://10709782497",
			["briefcase"] = "rbxassetid://10709782662",
			["bug"] = "rbxassetid://10709782845",
			["building"] = "rbxassetid://10709783051",
			["calculator"] = "rbxassetid://10709783311",
			["calendar"] = "rbxassetid://10709789505",
			["camera"] = "rbxassetid://10709789686",
			["check"] = "rbxassetid://10709790644",
			["checkcircle"] = "rbxassetid://10709790387",
			["chevrondown"] = "rbxassetid://10709790948",
			["chevronleft"] = "rbxassetid://10709791281",
			["chevronright"] = "rbxassetid://10709791437",
			["chevronup"] = "rbxassetid://10709791523",
			["clock"] = "rbxassetid://10709805144",
			["code"] = "rbxassetid://10709810463",
			["cog"] = "rbxassetid://10709810948",
			["copy"] = "rbxassetid://10709812159",
			["crown"] = "rbxassetid://10709818626",
			["database"] = "rbxassetid://10709818996",
			["diamond"] = "rbxassetid://10709819149",
			["download"] = "rbxassetid://10723344270",
			["edit"] = "rbxassetid://10734883598",
			["edit2"] = "rbxassetid://10723344885",
			["eye"] = "rbxassetid://10723346959",
			["eyeoff"] = "rbxassetid://10723346871",
			["file"] = "rbxassetid://10723374641",
			["filter"] = "rbxassetid://10723380652",
			["flame"] = "rbxassetid://10723381530",
			["folder"] = "rbxassetid://10723385098",
			["globe"] = "rbxassetid://10723388891",
			["grid"] = "rbxassetid://10723391530",
			["hash"] = "rbxassetid://10723392432",
			["heart"] = "rbxassetid://10723393340",
			["heartpulse"] = "rbxassetid://10723393436",
			["home"] = "rbxassetid://10723393628",
			["image"] = "rbxassetid://10723395088",
			["info"] = "rbxassetid://10723398128",
			["key"] = "rbxassetid://10723402456",
			["layers"] = "rbxassetid://10734884618",
			["layout"] = "rbxassetid://10734884780",
			["link"] = "rbxassetid://10734884924",
			["list"] = "rbxassetid://10734886194",
			["lock"] = "rbxassetid://10734887180",
			["map"] = "rbxassetid://10734889286",
			["maximize"] = "rbxassetid://10734889456",
			["menu"] = "rbxassetid://10734889710",
			["message"] = "rbxassetid://10734889882",
			["minimize"] = "rbxassetid://10734890046",
			["monitor"] = "rbxassetid://10734890390",
			["moon"] = "rbxassetid://10734890558",
			["move"] = "rbxassetid://10734890814",
			["music"] = "rbxassetid://10734890964",
			["package"] = "rbxassetid://10734909540",
			["pencil"] = "rbxassetid://10734919691",
			["percent"] = "rbxassetid://10734919919",
			["phone"] = "rbxassetid://10734921524",
			["pin"] = "rbxassetid://10734922324",
			["play"] = "rbxassetid://10734923549",
			["plus"] = "rbxassetid://10734924532",
			["pluscircle"] = "rbxassetid://10734923868",
			["power"] = "rbxassetid://10734930466",
			["puzzle"] = "rbxassetid://10734930886",
			["rocket"] = "rbxassetid://10734934585",
			["save"] = "rbxassetid://10734941499",
			["search"] = "rbxassetid://10734943674",
			["send"] = "rbxassetid://10734943902",
			["settings"] = "rbxassetid://10734950309",
			["settings2"] = "rbxassetid://10734950020",
			["share"] = "rbxassetid://10734950813",
			["shield"] = "rbxassetid://10734951847",
			["shieldcheck"] = "rbxassetid://10734951367",
			["skull"] = "rbxassetid://10734962068",
			["sliders"] = "rbxassetid://10734963400",
			["smartphone"] = "rbxassetid://10734963940",
			["smile"] = "rbxassetid://10734964441",
			["star"] = "rbxassetid://10734966248",
			["sun"] = "rbxassetid://10734974297",
			["target"] = "rbxassetid://10734975460",
			["terminal"] = "rbxassetid://10734975590",
			["trash"] = "rbxassetid://10734976254",
			["trending"] = "rbxassetid://10734976450",
			["trophy"] = "rbxassetid://10734976680",
			["tv"] = "rbxassetid://10734976820",
			["unlock"] = "rbxassetid://10747365656",
			["upload"] = "rbxassetid://10747366434",
			["user"] = "rbxassetid://10747373176",
			["usercheck"] = "rbxassetid://10747371901",
			["usercog"] = "rbxassetid://10747372167",
			["userplus"] = "rbxassetid://10747372702",
			["users"] = "rbxassetid://10747373426",
			["video"] = "rbxassetid://10747374938",
			["volume"] = "rbxassetid://10747376008",
			["volumex"] = "rbxassetid://10747375880",
			["wallet"] = "rbxassetid://10747376205",
			["wifi"] = "rbxassetid://10747382504",
			["wifioff"] = "rbxassetid://10747382268",
			["wrench"] = "rbxassetid://10747383470",
			["x"] = "rbxassetid://10747384394",
			["xcircle"] = "rbxassetid://10747383819",
			["zoomin"] = "rbxassetid://10747384552",
			["zoomout"] = "rbxassetid://10747384679"
		}
	end)()
}

-- Core Utilities
local ViewportSize = workspace.CurrentCamera.ViewportSize
local UIScale = ViewportSize.Y / 450

local Settings = lopklib.Settings
local Flags    = lopklib.Flags

local SetProps, SetChildren, InsertTheme, Create do
	InsertTheme = function(Instance, Type)
		table.insert(lopklib.Instances, { Instance = Instance, Type = Type })
		return Instance
	end

	SetChildren = function(Instance, Children)
		if Children then
			for _, Child in ipairs(Children) do
				Child.Parent = Instance
			end
		end
		return Instance
	end

	SetProps = function(Instance, Props)
		if Props then
			for prop, value in pairs(Props) do
				Instance[prop] = value
			end
		end
		return Instance
	end

	Create = function(...)
		local args = {...}
		if type(args) ~= "table" then return end
		local new = Instance.new(args[1])
		local Children = {}

		if type(args[2]) == "table" then
			SetProps(new, args[2])
			SetChildren(new, args[3])
			Children = args[3] or {}
		elseif typeof(args[2]) == "Instance" then
			new.Parent = args[2]
			SetProps(new, args[3])
			SetChildren(new, args[4])
			Children = args[4] or {}
		end
		return new
	end

	local function Save(file)
		if readfile and isfile and isfile(file) then
			local ok, decode = pcall(function()
				return HttpService:JSONDecode(readfile(file))
			end)
			if ok and type(decode) == "table" then
				if rawget(decode, "UISize")  then lopklib.Save["UISize"]  = decode["UISize"]  end
				if rawget(decode, "TabSize") then lopklib.Save["TabSize"] = decode["TabSize"] end
				if rawget(decode, "Theme") and VerifyTheme and VerifyTheme(decode["Theme"]) then
					lopklib.Save["Theme"] = decode["Theme"]
				end
			end
		end
	end
	pcall(Save, "lopk library V2.json")
end

-- Callback / Connection System
local Funcs = {}
function Funcs:InsertCallback(tab, func)
	if type(func) == "function" then table.insert(tab, func) end
	return func
end
function Funcs:FireCallback(tab, ...)
	for _, v in ipairs(tab) do
		if type(v) == "function" then task.spawn(v, ...) end
	end
end
function Funcs:ToggleVisible(Obj, Bool)
	Obj.Visible = Bool ~= nil and Bool or not Obj.Visible
end
function Funcs:ToggleParent(Obj, Bool, Parent)
	if Bool ~= nil then Obj.Parent = Bool and Parent or nil
	else Obj.Parent = Obj.Parent and nil or Parent end
end
function Funcs:GetConnectionFunctions(ConnectedFuncs, func)
	local Connected = { Function = func, Connected = true }
	function Connected:Disconnect()
		if self.Connected then
			local idx = table.find(ConnectedFuncs, self.Function)
			if idx then table.remove(ConnectedFuncs, idx) end
			self.Connected = false
		end
	end
	function Connected:Fire(...)
		if self.Connected then task.spawn(self.Function, ...) end
	end
	return Connected
end
function Funcs:GetCallback(Configs, index)
	local func = Configs[index] or Configs.Callback or function() end
	if type(func) == "table" then
		return { function(Value) func[1][func[2]] = Value end }
	end
	return { func }
end

-- Connections
local Connections, Connection = {}, lopklib.Connection
local function NewConnectionList(List)
	for _, CoName in ipairs(List) do
		local ConnectedFuncs, Connect = {}, {}
		Connection[CoName] = Connect
		Connections[CoName] = ConnectedFuncs
		Connect.Name = CoName
		function Connect:Connect(func)
			if type(func) == "function" then
				table.insert(ConnectedFuncs, func)
				return Funcs:GetConnectionFunctions(ConnectedFuncs, func)
			end
		end
		function Connect:Once(func)
			if type(func) == "function" then
				local Connected
				local _NFunc; _NFunc = function(...)
					task.spawn(func, ...)
					Connected:Disconnect()
				end
				Connected = Funcs:GetConnectionFunctions(ConnectedFuncs, _NFunc)
				return Connected
			end
		end
	end
end
function Connection:FireConnection(CoName, ...)
	local C = type(CoName) == "string" and Connections[CoName] or Connections[CoName.Name]
	for _, Func in pairs(C) do task.spawn(Func, ...) end
end
NewConnectionList({"FlagsChanged","ThemeChanged","FileSaved","ThemeChanging","OptionAdded"})

-- Flags
local GetFlag, SetFlag, CheckFlag
CheckFlag = function(Name) return type(Name) == "string" and Flags[Name] ~= nil end
GetFlag   = function(Name) return type(Name) == "string" and Flags[Name] end
SetFlag   = function(Flag, Value)
	if Flag and (Value ~= Flags[Flag] or type(Value) == "table") then
		Flags[Flag] = Value
		Connection:FireConnection("FlagsChanged", Flag, Value)
	end
end

local db
Connection.FlagsChanged:Connect(function(Flag, Value)
	local ScriptFile = Settings.ScriptFile
	if not db and ScriptFile and writefile then
		db = true; task.wait(0.1); db = false
		local ok, Encoded = pcall(function() return HttpService:JSONEncode(Flags) end)
		if ok then
			local s = pcall(writefile, ScriptFile, Encoded)
			if s then Connection:FireConnection("FileSaved", "Script-Flags", ScriptFile, Encoded) end
		end
	end
end)

-- ScreenGui
local ScreenGui = Create("ScreenGui", CoreGui, {
	Name = "LOPKCyanLib",
}, {
	Create("UIScale", { Scale = UIScale, Name = "Scale" })
})

local ScreenFind = CoreGui:FindFirstChild(ScreenGui.Name)
if ScreenFind and ScreenFind ~= ScreenGui then ScreenFind:Destroy() end

local function GetStr(val)
	return type(val) == "function" and val() or val
end

local function ConnectSave(Inst, func)
	Inst.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1
		or Input.UserInputType == Enum.UserInputType.Touch then
			while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
				task.wait()
			end
		end
		func()
	end)
end

local function CreateTween(Configs)
	local Inst     = Configs[1] or Configs.Instance
	local Prop     = Configs[2] or Configs.Prop
	local NewVal   = Configs[3] or Configs.NewVal
	local Time     = Configs[4] or Configs.Time or 0.5
	local TWait    = Configs[5] or Configs.wait or false
	local Info     = TweenInfo.new(Time, Enum.EasingStyle.Quint)
	local Tween    = TweenService:Create(Inst, Info, {[Prop] = NewVal})
	Tween:Play()
	if TWait then Tween.Completed:Wait() end
	return Tween
end

-- Click Sound
local _ClickSound = Instance.new("Sound")
_ClickSound.SoundId  = "rbxassetid://115942274494895"
_ClickSound.Volume   = 1
_ClickSound.Parent   = _SoundService

local function PlayClickSound()
	task.spawn(function()
		local s = _ClickSound:Clone()
		s.Parent = _SoundService
		s:Play()
		game:GetService("Debris"):AddItem(s, 2)
	end)
end

local function MakeDrag(Inst)
	task.spawn(function()
		SetProps(Inst, { Active = true, AutoButtonColor = false })
		local DragStart, StartPos, InputOn
		local function Update(Input)
			local delta    = Input.Position - DragStart
			local Position = UDim2.new(
				StartPos.X.Scale, StartPos.X.Offset + delta.X / UIScale,
				StartPos.Y.Scale, StartPos.Y.Offset + delta.Y / UIScale
			)
			CreateTween({Inst, "Position", Position, 0.3})
		end
		Inst.MouseButton1Down:Connect(function() InputOn = true end)
		Inst.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch then
				StartPos  = Inst.Position
				DragStart = Input.Position
				while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
					RunService.Heartbeat:Wait()
					if InputOn then Update(Input) end
				end
				InputOn = false
			end
		end)
	end)
	return Inst
end

local function VerifyTheme(Theme)
	for name, _ in pairs(lopklib.Themes) do
		if name == Theme then return true end
	end
end

local function SaveJson(FileName, save)
	if writefile then
		local json = HttpService:JSONEncode(save)
		writefile(FileName, json)
	end
end

local Theme = lopklib.Themes[lopklib.Save.Theme]

local function AddEle(Name, Func) lopklib.Elements[Name] = Func end
local function Make(Ele, Inst, props, ...)
	return lopklib.Elements[Ele](Inst, props, ...)
end

-- Element Factories
AddEle("Corner", function(parent, CornerRadius)
	return SetProps(Create("UICorner", parent, {
		CornerRadius = CornerRadius or UDim.new(0, 7)
	}), {})
end)

AddEle("Stroke", function(parent, props, ...)
	local args = {...}
	return InsertTheme(SetProps(Create("UIStroke", parent, {
		Color           = args[1] or Theme["Color Stroke"],
		Thickness       = args[2] or 1,
		ApplyStrokeMode = "Border"
	}), props), "Stroke")
end)

AddEle("Button", function(parent, props, ...)
	local args = {...}
	local New  = InsertTheme(SetProps(Create("TextButton", parent, {
		Text             = "",
		Size             = UDim2.fromScale(1, 1),
		BackgroundColor3 = Theme["Color Hub 2"],
		AutoButtonColor  = false
	}), props), "Frame")

	local OriginalSize = New.Size
	local IsMouseOver  = false

	New.MouseEnter:Connect(function()
		IsMouseOver = true
		CreateTween({New, "BackgroundTransparency", 0.35, 0.2})
	end)
	New.MouseLeave:Connect(function()
		IsMouseOver = false
		CreateTween({New, "BackgroundTransparency", 0, 0.2})
	end)
	New.MouseButton1Down:Connect(function()
		PlayClickSound()
		CreateTween({New, "Size",                  OriginalSize - UDim2.fromOffset(4, 2), 0.1})
		CreateTween({New, "BackgroundTransparency", 0.55, 0.1})
	end)
	New.MouseButton1Up:Connect(function()
		CreateTween({New, "Size",                  OriginalSize, 0.15})
		CreateTween({New, "BackgroundTransparency", IsMouseOver and 0.35 or 0, 0.15})
	end)
	if args[1] then New.Activated:Connect(args[1]) end
	return New
end)

AddEle("Gradient", function(parent, props, ...)
	return InsertTheme(SetProps(Create("UIGradient", parent, {
		Color = Theme["Color Hub 1"]
	}), props), "Gradient")
end)

-- ButtonFrame helper
local LabelHolder
local function ButtonFrame(Container, Title, Description, HolderSize)
	local TitleL = InsertTheme(Create("TextLabel", {
		Font              = Enum.Font.GothamMedium,
		TextColor3        = Theme["Color Text"],
		Size              = UDim2.new(1, -20),
		AutomaticSize     = "Y",
		Position          = UDim2.new(0, 0, 0.5),
		AnchorPoint       = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		TextTruncate      = "AtEnd",
		TextSize          = 10,
		TextXAlignment    = "Left",
		Text              = "",
		RichText          = true
	}), "Text")

	local DescL = InsertTheme(Create("TextLabel", {
		Font              = Enum.Font.Gotham,
		TextColor3        = Theme["Color Dark Text"],
		Size              = UDim2.new(1, -20),
		AutomaticSize     = "Y",
		Position          = UDim2.new(0, 12, 0, 15),
		BackgroundTransparency = 1,
		TextWrapped       = true,
		TextSize          = 8,
		TextXAlignment    = "Left",
		Text              = "",
		RichText          = true
	}), "DarkText")

	local Frame = Make("Button", Container, {
		Size          = UDim2.new(1, 0, 0, 25),
		AutomaticSize = "Y",
		Name          = "Option"
	}) Make("Corner", Frame, UDim.new(0, 6))

	local LeftGlow = InsertTheme(Create("Frame", Frame, {
		Size             = UDim2.new(0, 2, 0.6, 0),
		Position         = UDim2.new(0, 0, 0.2, 0),
		BackgroundColor3 = Theme["Color Theme"],
		BorderSizePixel  = 0,
		BackgroundTransparency = 0.5
	}), "Theme") Make("Corner", LeftGlow, UDim.new(0.5, 0))

	LabelHolder = Create("Frame", Frame, {
		AutomaticSize      = "Y",
		BackgroundTransparency = 1,
		Size               = HolderSize,
		Position           = UDim2.new(0, 10, 0),
		AnchorPoint        = Vector2.new(0, 0)
	}, {
		Create("UIListLayout", {
			SortOrder        = "LayoutOrder",
			VerticalAlignment= "Center",
			Padding          = UDim.new(0, 2)
		}),
		Create("UIPadding", {
			PaddingBottom = UDim.new(0, 5),
			PaddingTop    = UDim.new(0, 5)
		}),
		TitleL, DescL,
	})

	local Label = {}
	function Label:SetTitle(NewTitle)
		if type(NewTitle) == "string" and NewTitle:gsub(" ",""):len() > 0 then
			TitleL.Text = NewTitle
		end
	end
	function Label:SetDesc(NewDesc)
		if type(NewDesc) == "string" and NewDesc:gsub(" ",""):len() > 0 then
			DescL.Visible = true
			DescL.Text    = NewDesc
			LabelHolder.Position    = UDim2.new(0, 10, 0)
			LabelHolder.AnchorPoint = Vector2.new(0, 0)
		else
			DescL.Visible = false
			DescL.Text    = ""
			LabelHolder.Position    = UDim2.new(0, 10, 0.5)
			LabelHolder.AnchorPoint = Vector2.new(0, 0.5)
		end
	end
	Label:SetTitle(Title)
	Label:SetDesc(Description)
	return Frame, Label
end

local function GetColor(Inst)
	if Inst:IsA("Frame")          then return "BackgroundColor3"
	elseif Inst:IsA("ImageLabel") then return "ImageColor3"
	elseif Inst:IsA("ImageButton")then return "ImageColor3"
	elseif Inst:IsA("TextLabel")  then return "TextColor3"
	elseif Inst:IsA("TextButton") then return "TextColor3"
	elseif Inst:IsA("ScrollingFrame") then return "ScrollBarImageColor3"
	elseif Inst:IsA("UIStroke")   then return "Color"
	end return ""
end

-- lopklib API
function lopklib:GetIcon(index)
	if type(index) ~= "string" or index:find("rbxassetid://") or #index == 0 then return index end
	local firstMatch = nil
	index = string.lower(index):gsub("lucide",""):gsub("-","")
	for Name, Icon in pairs(self.Icons) do
		Name = Name:gsub("lucide",""):gsub("-","")
		if Name == index then return Icon
		elseif not firstMatch and Name:find(index, 1, true) then firstMatch = Icon end
	end
	return firstMatch or index
end

function lopklib:SetTheme(NewTheme)
	if not VerifyTheme(NewTheme) then return end
	lopklib.Save.Theme = NewTheme
	SaveJson("lopk library V2.json", lopklib.Save)
	Theme = lopklib.Themes[NewTheme]
	Connection:FireConnection("ThemeChanged", NewTheme)
	for _, Val in pairs(lopklib.Instances) do
		if     Val.Type == "Gradient"  then Val.Instance.Color = Theme["Color Hub 1"]
		elseif Val.Type == "Frame"     then Val.Instance.BackgroundColor3 = Theme["Color Hub 2"]
		elseif Val.Type == "Stroke"    then Val.Instance[GetColor(Val.Instance)] = Theme["Color Stroke"]
		elseif Val.Type == "Theme"     then Val.Instance[GetColor(Val.Instance)] = Theme["Color Theme"]
		elseif Val.Type == "Text"      then Val.Instance[GetColor(Val.Instance)] = Theme["Color Text"]
		elseif Val.Type == "DarkText"  then Val.Instance[GetColor(Val.Instance)] = Theme["Color Dark Text"]
		elseif Val.Type == "ScrollBar" then Val.Instance[GetColor(Val.Instance)] = Theme["Color Theme"]
		end
	end
end

function lopklib:SetScale(NewScale)
	NewScale        = ViewportSize.Y / math.clamp(NewScale, 300, 2000)
	UIScale         = NewScale
	ScreenGui.Scale.Scale = NewScale
end

-- White/Purple Shimmer
task.spawn(function()
	task.wait(3)
	local angle = 0
	local shimmerColor = Color3.fromRGB(255, 255, 255)
	while true do
		task.wait(0.04)
		angle = (angle + 3) % 360
		local wave = (math.sin(math.rad(angle)) + 1) / 2
		for _, val in pairs(lopklib.Instances) do
			local inst = val.Instance
			local t    = val.Type
			if not inst or not inst.Parent then continue end
			local base, prop
			if t == "Stroke" then
				base = Theme["Color Stroke"]; prop = "Color"
			elseif t == "Theme" then
				base = Theme["Color Theme"]
				prop = GetColor(inst)
			elseif t == "Text" then
				base = Theme["Color Text"]
				prop = GetColor(inst)
			elseif t == "DarkText" then
				base = Theme["Color Dark Text"]
				prop = GetColor(inst)
			end
			if base and prop and prop ~= "" then
				pcall(function()
					inst[prop] = base:Lerp(shimmerColor, wave * 0.40)
				end)
			end
		end
	end
end)

local NotificationContainer = Create("Frame", ScreenGui, {
	Name               = "NotificationContainer",
	Size               = UDim2.new(0, 290, 1, 0),
	Position           = UDim2.new(1, -310, 1, -20),
	AnchorPoint        = Vector2.new(0, 1),
	BackgroundTransparency = 1,
	ZIndex             = 999
}, {
	Create("UIListLayout", {
		SortOrder        = "LayoutOrder",
		Padding          = UDim.new(0, 8),
		VerticalAlignment= "Bottom"
	})
})

function lopklib:Notify(Configs)
	local Title       = Configs[1] or Configs.Title or "Notification"
	local Description = Configs[2] or Configs.Description or Configs.Text or ""
	local Duration    = Configs[3] or Configs.Duration or 5
	local Type        = Configs.Type or "Info"
	local Image       = Configs.Image or "rbxassetid://113449060491896"

	local Colors = {
		Info    = Color3.fromRGB(0,   200, 255),
		Success = Color3.fromRGB(0,   255, 160),
		Warning = Color3.fromRGB(255, 210, 0),
		Error   = Color3.fromRGB(255, 60,  80)
	}
	local TypeColor = Colors[Type] or Colors.Info

	local NFrame = Create("Frame", NotificationContainer, {
		Size                   = UDim2.new(1, 0, 0, 50),
		BackgroundColor3       = Color3.fromRGB(15, 15, 15),
		BackgroundTransparency = 0,
		BorderSizePixel        = 0,
		ClipsDescendants       = true
	})
	Make("Corner", NFrame, UDim.new(0, 12))

	local AccentLine = Create("Frame", NFrame, {
		Size             = UDim2.new(1, 0, 0, 2),
		BackgroundColor3 = TypeColor,
		BorderSizePixel  = 0
	})

	local NStroke = Create("UIStroke", NFrame, {
		Color           = TypeColor,
		Thickness       = 1.2,
		ApplyStrokeMode = "Border"
	})

	local TitleLabel = Create("TextLabel", NFrame, {
		Size               = UDim2.new(1, -55, 0, 17),
		Position           = UDim2.new(0, 46, 0, 7),
		BackgroundTransparency = 1,
		Text               = Title,
		TextColor3         = Color3.fromRGB(255, 255, 255),
		TextSize           = 11,
		Font               = Enum.Font.GothamBold,
		TextXAlignment     = "Left",
		TextTruncate       = "AtEnd"
	})

	local DescLabel = Create("TextLabel", NFrame, {
		Size               = UDim2.new(1, -55, 0, 20),
		Position           = UDim2.new(0, 46, 0, 23),
		BackgroundTransparency = 1,
		Text               = Description,
		TextColor3         = Color3.fromRGB(180, 180, 180),
		TextSize           = 9,
		Font               = Enum.Font.Gotham,
		TextXAlignment     = "Left",
		TextWrapped        = true
	})

	Create("ImageLabel", NFrame, {
		Size               = UDim2.new(0, 30, 0, 30),
		Position           = UDim2.new(0, 9, 0.5, 0),
		AnchorPoint        = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		Image              = Image,
		ImageColor3        = TypeColor,
		ZIndex             = 1000
	})

	local CounterLabel = Create("TextLabel", NFrame, {
		Size               = UDim2.new(0, 32, 0, 17),
		Position           = UDim2.new(1, -36, 0, 7),
		BackgroundTransparency = 1,
		Text               = tostring(Duration),
		TextColor3         = TypeColor,
		TextSize           = 10,
		Font               = Enum.Font.GothamBold,
		TextXAlignment     = "Right"
	})

	local function RemoveNotification()
		CreateTween({NFrame, "Position",              UDim2.new(1, 50, NFrame.Position.Y.Scale, 0), 0.3})
		CreateTween({NFrame, "BackgroundTransparency",1, 0.3})
		CreateTween({NStroke,"Transparency",          1, 0.3, true})
		NFrame:Destroy()
	end

	NFrame.Position = UDim2.new(1, 50, 0, 0)
	CreateTween({NFrame, "Position", UDim2.new(0, 0, 0, 0), 0.4})

	if Duration > 0 then
		local timeLeft       = Duration
		local updateInterval = 0.1
		task.spawn(function()
			while timeLeft > 0 do
				task.wait(updateInterval)
				timeLeft = timeLeft - updateInterval
				if timeLeft <= 0 then
					CounterLabel.Text = "0.0"
					task.wait(0.1)
					if NFrame and NFrame.Parent then RemoveNotification() end
					break
				else
					CounterLabel.Text = string.format("%.1f", timeLeft)
				end
			end
		end)
	end

	local Notification = {}
	function Notification:Remove() RemoveNotification() end
	return Notification
end

-- Meteor System (NAR)
local function BuildParticleSystem(ParticleContainer, MainFrameRef)
	local ActiveParticles = {}
	local MeteorImage = "rbxassetid://12543411478"
	local MeteorColor = Color3.fromRGB(0, 255, 255)
	local SpawnRate   = 0.10

	local function CreateTrail(pos, size)
		if not ParticleContainer or not ParticleContainer.Parent then return end
		local trail = Instance.new("Frame")
		trail.Size                   = size
		trail.Position               = pos
		trail.BackgroundColor3       = MeteorColor
		trail.BorderSizePixel        = 0
		trail.BackgroundTransparency = 0.3
		trail.ZIndex                 = 10
		trail.Parent                 = ParticleContainer
		local corner = Instance.new("UICorner", trail)
		corner.CornerRadius = UDim.new(1, 0)
		local tween = TweenService:Create(trail, TweenInfo.new(0.5), {
			Size = UDim2.fromOffset(0, 0),
			BackgroundTransparency = 1
		})
		tween:Play()
		tween.Completed:Connect(function() trail:Destroy() end)
	end

	local function SpawnMeteor()
		if not ParticleContainer or not ParticleContainer.Parent then return end
		local cs = ParticleContainer.AbsoluteSize
		if cs.X <= 0 or cs.Y <= 0 then return end

		local sizeW = math.random(90, 160)
		local sizeH = math.floor(sizeW * 1.5)

		local meteor = Instance.new("ImageLabel")
		meteor.Name                  = "NAR_Meteor"
		meteor.Size                  = UDim2.fromOffset(sizeW, sizeH)
		meteor.Position              = UDim2.new(math.random(-20, 120) / 100, 0, -0.5, 0)
		meteor.BackgroundTransparency = 1
		meteor.Image                 = MeteorImage
		meteor.ImageColor3           = MeteorColor
		meteor.Rotation              = 45
		meteor.ZIndex                = 11
		meteor.Parent                = ParticleContainer

		local fallTime  = math.random(10, 18) / 10
		local targetPos = UDim2.new(meteor.Position.X.Scale - 0.7, 0, 1.4, 0)

		local tween = TweenService:Create(meteor, TweenInfo.new(fallTime, Enum.EasingStyle.Linear), {
			Position        = targetPos,
			ImageTransparency = 0.8
		})

		local connection
		connection = RunService.Heartbeat:Connect(function()
			if meteor and meteor.Parent then
				CreateTrail(meteor.Position, UDim2.fromOffset(sizeW / 8, sizeW / 8))
			else
				connection:Disconnect()
			end
		end)

		tween:Play()
		tween.Completed:Connect(function()
			meteor:Destroy()
			connection:Disconnect()
		end)

		table.insert(ActiveParticles, meteor)
	end

	local spawnConn
	if _G.LOPKParticleConnection then _G.LOPKParticleConnection:Disconnect() end
	_G.LOPKParticleConnection = task.spawn(function()
		while true do
			if MainFrameRef and MainFrameRef.Visible
			and ParticleContainer and ParticleContainer.Visible then
				SpawnMeteor()
			end
			task.wait(SpawnRate)
		end
	end)

	return ActiveParticles, function(enabled)
		ParticleContainer.Visible = enabled
	end
end

-- MakeWindow
function lopklib:MakeWindow(Configs)
	lopklib.Tabs = {}

	local WTitle    = Configs[1] or Configs.Name  or Configs.Title    or "LOPK Library V2"
	local WMiniText = Configs[2] or Configs.SubTitle or "Cyan Edition"

	Settings.ScriptFile = Configs[3] or Configs.SaveFolder or false

	local function LoadFile()
		local File = Settings.ScriptFile
		if type(File) ~= "string" or not readfile or not isfile then return end
		local s, r = pcall(isfile, File)
		if s and r then
			local ok, _Flags = pcall(readfile, File)
			if ok and type(_Flags) == "string" then
				local s2, r2 = pcall(function() return HttpService:JSONDecode(_Flags) end)
				Flags = s2 and r2 or {}
			end
		end
	end; LoadFile()

	local function CyberNotify(title, text, duration, accentColor)
		accentColor = accentColor or Color3.fromRGB(0, 255, 255)
		local NGui = Instance.new("ScreenGui")
		NGui.Name = "LOPKCyberNotif"
		NGui.ResetOnSpawn = false
		NGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		pcall(function() NGui.Parent = game:GetService("CoreGui") end)

		local Frame = Instance.new("Frame")
		Frame.Size = UDim2.fromOffset(320, 80)
		Frame.Position = UDim2.new(0.5, -160, 1, 10)
		Frame.AnchorPoint = Vector2.new(0, 0)
		Frame.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
		Frame.BorderSizePixel = 0
		Frame.ClipsDescendants = true
		Frame.Parent = NGui
		local FC = Instance.new("UICorner", Frame)
		FC.CornerRadius = UDim.new(0, 12)

		local TopBar = Instance.new("Frame", Frame)
		TopBar.Size = UDim2.new(1, 0, 0, 3)
		TopBar.BackgroundTransparency = 0
		TopBar.BorderSizePixel = 0
		local TBGrad = Instance.new("UIGradient", TopBar)
		TBGrad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0,    Color3.fromRGB(0, 0, 0)),
			ColorSequenceKeypoint.new(0.35, accentColor),
			ColorSequenceKeypoint.new(0.65, accentColor),
			ColorSequenceKeypoint.new(1,    Color3.fromRGB(0, 0, 0)),
		})

		local Stroke = Instance.new("UIStroke", Frame)
		Stroke.Thickness = 1.5
		Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		Stroke.Color = accentColor
		Stroke.Transparency = 0.3

		local Glow = Instance.new("Frame", Frame)
		Glow.Size = UDim2.new(1, 0, 0, 35)
		Glow.Position = UDim2.new(0, 0, 0, 0)
		Glow.BackgroundColor3 = accentColor
		Glow.BorderSizePixel = 0
		local GGrad = Instance.new("UIGradient", Glow)
		GGrad.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.88),
			NumberSequenceKeypoint.new(1, 1),
		})
		GGrad.Rotation = 90

		-- [2] الصورة (116627951531486) في بطاقة الإشعار بدل الأيقونة
		local IconCircle = Instance.new("Frame", Frame)
		IconCircle.Size = UDim2.fromOffset(46, 46)
		IconCircle.Position = UDim2.new(0, 14, 0.5, 0)
		IconCircle.AnchorPoint = Vector2.new(0, 0.5)
		IconCircle.BackgroundColor3 = accentColor
		IconCircle.BorderSizePixel = 0
		local ICC = Instance.new("UICorner", IconCircle)
		ICC.CornerRadius = UDim.new(0, 10)
		local IconGrad = Instance.new("UIGradient", IconCircle)
		IconGrad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, accentColor),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 20, 30)),
		})
		IconGrad.Rotation = 135

		-- صورة بدل الإيموجي
		local IconImg = Instance.new("ImageLabel", IconCircle)
		IconImg.Size = UDim2.fromScale(1, 1)
		IconImg.BackgroundTransparency = 1
		IconImg.Image = "rbxassetid://116627951531486"
		IconImg.ScaleType = Enum.ScaleType.Fit
		local IconImgC = Instance.new("UICorner", IconImg)
		IconImgC.CornerRadius = UDim.new(0, 8)

		local TitleL = Instance.new("TextLabel", Frame)
		TitleL.Size = UDim2.new(1, -120, 0, 24)
		TitleL.Position = UDim2.fromOffset(72, 10)
		TitleL.BackgroundTransparency = 1
		TitleL.Text = title
		TitleL.TextColor3 = Color3.fromRGB(255, 255, 255)
		TitleL.TextSize = 13
		TitleL.Font = Enum.Font.GothamBold
		TitleL.TextXAlignment = Enum.TextXAlignment.Left
		TitleL.TextTruncate = Enum.TextTruncate.AtEnd

		local DescL = Instance.new("TextLabel", Frame)
		DescL.Size = UDim2.new(1, -120, 0, 22)
		DescL.Position = UDim2.fromOffset(72, 34)
		DescL.BackgroundTransparency = 1
		DescL.Text = text
		DescL.TextColor3 = Color3.fromRGB(160, 220, 220)
		DescL.TextSize = 10
		DescL.Font = Enum.Font.Gotham
		DescL.TextXAlignment = Enum.TextXAlignment.Left
		DescL.TextWrapped = true

		local BarBG2 = Instance.new("Frame", Frame)
		BarBG2.Size = UDim2.new(1, -20, 0, 3)
		BarBG2.Position = UDim2.new(0, 10, 1, -8)
		BarBG2.AnchorPoint = Vector2.new(0, 1)
		BarBG2.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
		BarBG2.BorderSizePixel = 0
		local BBC2 = Instance.new("UICorner", BarBG2)
		BBC2.CornerRadius = UDim.new(1, 0)

		local BarFill2 = Instance.new("Frame", BarBG2)
		BarFill2.Size = UDim2.new(1, 0, 1, 0)
		BarFill2.BackgroundColor3 = accentColor
		BarFill2.BorderSizePixel = 0
		local BFC2 = Instance.new("UICorner", BarFill2)
		BFC2.CornerRadius = UDim.new(1, 0)

		local CounterL = Instance.new("TextLabel", Frame)
		CounterL.Size = UDim2.fromOffset(38, 38)
		CounterL.Position = UDim2.new(1, -50, 0.5, 0)
		CounterL.AnchorPoint = Vector2.new(0, 0.5)
		CounterL.BackgroundTransparency = 1
		CounterL.Text = tostring(duration)
		CounterL.TextColor3 = accentColor
		CounterL.TextSize = 18
		CounterL.Font = Enum.Font.GothamBold
		CounterL.TextXAlignment = Enum.TextXAlignment.Center

		task.spawn(function()
			local a = 0
			while Frame and Frame.Parent do
				a = (a + 5) % 360
				local w = (math.sin(math.rad(a)) + 1) / 2
				pcall(function()
					Stroke.Transparency = 0.2 + w * 0.5
				end)
				task.wait(0.04)
			end
		end)

		TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Position = UDim2.new(0.5, -160, 0.5, -40)
		}):Play()

		local timeLeft = duration
		local interval = 0.05
		task.spawn(function()
			while timeLeft > 0 and Frame and Frame.Parent do
				task.wait(interval)
				timeLeft = timeLeft - interval
				local ratio = math.max(timeLeft / duration, 0)
				pcall(function()
					BarFill2.Size = UDim2.new(ratio, 0, 1, 0)
					CounterL.Text = string.format("%.0f", math.ceil(timeLeft))
				end)
			end
		end)

		task.wait(duration)

		local out = TweenService:Create(Frame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
			Position = UDim2.new(0.5, -160, 1, 10)
		})
		out:Play()
		out.Completed:Wait()
		NGui:Destroy()
	end

	local function ShowFirstNotify()
		-- الموسيقى تعمل بالفعل من أول السكربت (84878105728262)
		-- هنا فقط الإشعار
		CyberNotify("⏳ جاري التحميل...", "انتظر 17 ثانية وسيشتغل السكربت", 17, Color3.fromRGB(0, 200, 255))
	end
	ShowFirstNotify()

	local UISizeX, UISizeY = unpack(lopklib.Save.UISize)
	local MainFrame = InsertTheme(Create("ImageButton", ScreenGui, {
		Size                   = UDim2.fromOffset(UISizeX, UISizeY),
		Position               = UDim2.new(0.5, -UISizeX/2, 0.5, -UISizeY/2),
		BackgroundTransparency = 0.08,
		Name                   = "Hub"
	}), "Main")
	Make("Gradient", MainFrame, { Rotation = 135 })
	MakeDrag(MainFrame)
	local MainCorner = Make("Corner", MainFrame)

	-- [3] صورة الخلفية الرئيسية في كل الواجهة (116627951531486) - في الخلف
	local AvatarBG = Create("ImageLabel", MainFrame, {
		Size               = UDim2.new(1, 0, 1, 0),
		Position           = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		Image              = "rbxassetid://116627951531486",
		ImageTransparency  = 0.55,
		ScaleType          = Enum.ScaleType.Crop,
		ZIndex             = 0,
		Name               = "AvatarBG"
	})
	Make("Corner", AvatarBG)

	-- [4] صورة في كل ركن من أركان الواجهة
	local cornerDefs = {
		{pos = UDim2.fromOffset(4, 4),        anchor = Vector2.new(0, 0)},   -- أعلى يسار
		{pos = UDim2.new(1, -4, 0, 4),        anchor = Vector2.new(1, 0)},   -- أعلى يمين
		{pos = UDim2.new(0, 4, 1, -4),        anchor = Vector2.new(0, 1)},   -- أسفل يسار
		{pos = UDim2.new(1, -4, 1, -4),       anchor = Vector2.new(1, 1)},   -- أسفل يمين
	}
	for _, cd in ipairs(cornerDefs) do
		local cornerImg = Create("ImageLabel", MainFrame, {
			Size               = UDim2.fromOffset(38, 38),
			Position           = cd.pos,
			AnchorPoint        = cd.anchor,
			BackgroundTransparency = 1,
			Image              = "rbxassetid://116627951531486",
			ImageTransparency  = 0.25,
			ScaleType          = Enum.ScaleType.Fit,
			ZIndex             = 2,
			Name               = "CornerImg"
		})
		local cic = Create("UICorner", cornerImg, { CornerRadius = UDim.new(0, 7) })
		-- حواف نيون للصور الركنية
		local cis = Create("UIStroke", cornerImg, {
			Color           = Color3.fromRGB(0, 200, 255),
			Thickness       = 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		})
	end

	-- [5] صورة في TopBar (أيقونة صغيرة بجانب العنوان)
	-- سيتم إضافتها بعد إنشاء TopBar أدناه

	local BlueOverlay = Create("Frame", MainFrame, {
		Size               = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 0,
		BorderSizePixel    = 0,
		ZIndex             = 1,
		Name               = "BlueOverlay"
	})
	Make("Corner", BlueOverlay)
	local BlueGrad = Create("UIGradient", BlueOverlay, {
		Rotation  = 120,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0.00, Color3.fromRGB(5,  5,  5)),
			ColorSequenceKeypoint.new(0.50, Color3.fromRGB(18, 18, 18)),
			ColorSequenceKeypoint.new(1.00, Color3.fromRGB(5,  5,  5)),
		}),
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.40),
			NumberSequenceKeypoint.new(1, 0.50),
		})
	})

	task.spawn(function()
		local angle = 120
		while MainFrame and MainFrame.Parent do
			angle = (angle + 0.4) % 360
			BlueGrad.Rotation = angle
			task.wait(0.03)
		end
	end)

	local OuterStroke = Create("UIStroke", MainFrame, {
		Color           = Color3.fromRGB(255, 255, 255),
		Thickness       = 1.8,
		ApplyStrokeMode = "Border"
	})
	task.spawn(function()
		local angle = 0
		while MainFrame and MainFrame.Parent do
			angle = (angle + 4) % 360
			local wave = (math.sin(math.rad(angle)) + 1) / 2
			local brightness = math.floor(wave * 255)
			pcall(function()
				OuterStroke.Color = Color3.fromRGB(brightness, brightness, brightness)
			end)
			task.wait(0.03)
		end
	end)

	local Components    = Create("Folder", MainFrame,  { Name = "Components" })
	local DropdownHolder = Create("Folder", ScreenGui, { Name = "Dropdown"   })

	local TopBar = Create("Frame", Components, {
		Size               = UDim2.new(1, 0, 0, 30),
		BackgroundTransparency = 1,
		Name               = "Top Bar"
	})

	local TopAccent = Create("Frame", TopBar, {
		Size             = UDim2.new(1, 0, 0, 1),
		Position         = UDim2.new(0, 0, 1, -1),
		BackgroundColor3 = Theme["Color Stroke"],
		BorderSizePixel  = 0,
		BackgroundTransparency = 0.6
	})

	-- [6] صورة صغيرة في TopBar بجانب العنوان
	local TopBarIcon = Create("ImageLabel", TopBar, {
		Size               = UDim2.fromOffset(20, 20),
		Position           = UDim2.new(0, -2, 0.5, 0),
		AnchorPoint        = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		Image              = "rbxassetid://116627951531486",
		ImageTransparency  = 0,
		ScaleType          = Enum.ScaleType.Fit,
		ZIndex             = 5,
		Name               = "TopBarIcon"
	})
	local tbic = Create("UICorner", TopBarIcon, { CornerRadius = UDim.new(0, 5) })

	local Title = InsertTheme(Create("TextLabel", TopBar, {
		Position          = UDim2.new(0, 22, 0.5),  -- أزحنا للجهة بعد الأيقونة
		AnchorPoint       = Vector2.new(0, 0.5),
		AutomaticSize     = "XY",
		Text              = WTitle,
		TextXAlignment    = "Left",
		TextSize          = 13,
		TextColor3        = Theme["Color Text"],
		BackgroundTransparency = 1,
		Font              = Enum.Font.GothamBold,
		Name              = "Title"
	}, {
		InsertTheme(Create("TextLabel", {
			Size              = UDim2.fromScale(0, 1),
			AutomaticSize     = "X",
			AnchorPoint       = Vector2.new(0, 1),
			Position          = UDim2.new(1, 6, 0.9),
			Text              = WMiniText,
			TextColor3        = Theme["Color Dark Greem"],
			BackgroundTransparency = 1,
			TextXAlignment    = "Left",
			TextYAlignment    = "Bottom",
			TextSize          = 8,
			Font              = Enum.Font.Gotham,
			Name              = "SubTitle"
		}), "DarkText")
	}), "Text")

	local MainScroll = InsertTheme(Create("ScrollingFrame", Components, {
		Size                    = UDim2.new(0, lopklib.Save.TabSize, 1, -TopBar.Size.Y.Offset),
		ScrollBarImageColor3    = Theme["Color Theme"],
		Position                = UDim2.new(0, 0, 1, 0),
		AnchorPoint             = Vector2.new(0, 1),
		ScrollBarThickness      = 1.5,
		BackgroundTransparency  = 1,
		ScrollBarImageTransparency = 0.2,
		CanvasSize              = UDim2.new(),
		AutomaticCanvasSize     = "Y",
		ScrollingDirection      = "Y",
		BorderSizePixel         = 0,
		Name                    = "Tab Scroll"
	}, {
		Create("UIPadding", {
			PaddingLeft   = UDim.new(0, 10),
			PaddingRight  = UDim.new(0, 10),
			PaddingTop    = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10)
		}),
		Create("UIListLayout", { Padding = UDim.new(0, 5) })
	}), "ScrollBar")

	local TabSep = Create("Frame", Components, {
		Size             = UDim2.new(0, 1, 1, -30),
		Position         = UDim2.new(0, lopklib.Save.TabSize, 0, 30),
		BackgroundColor3 = Theme["Color Stroke"],
		BorderSizePixel  = 0,
		BackgroundTransparency = 0.7,
		Name             = "TabSep"
	})

	local Containers = Create("Frame", Components, {
		Size               = UDim2.new(1, -MainScroll.Size.X.Offset, 1, -TopBar.Size.Y.Offset),
		AnchorPoint        = Vector2.new(1, 1),
		Position           = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ClipsDescendants   = true,
		Name               = "Containers"
	})

	local ParticleContainer = Create("Frame", Containers, {
		Size               = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Name               = "ThemeParticles",
		ZIndex             = -5,
		ClipsDescendants   = true
	})
	local ActiveParticles, SetParticlesVisible = BuildParticleSystem(ParticleContainer, MainFrame)

	local ControlSize1 = MakeDrag(Create("ImageButton", MainFrame, {
		Size               = UDim2.new(0, 35, 0, 35),
		Position           = MainFrame.Size,
		Active             = true,
		AnchorPoint        = Vector2.new(0.8, 0.8),
		BackgroundTransparency = 1,
		Name               = "Control Hub Size"
	}))
	local ControlSize2 = MakeDrag(Create("ImageButton", MainFrame, {
		Size               = UDim2.new(0, 20, 1, -30),
		Position           = UDim2.new(0, MainScroll.Size.X.Offset, 1, 0),
		AnchorPoint        = Vector2.new(0.5, 1),
		Active             = true,
		BackgroundTransparency = 1,
		Name               = "Control Tab Size"
	}))

	local function ControlSize()
		local Pos1 = ControlSize1.Position
		local Pos2 = ControlSize2.Position
		ControlSize1.Position = UDim2.fromOffset(math.clamp(Pos1.X.Offset, 430, 1000), math.clamp(Pos1.Y.Offset, 200, 600))
		ControlSize2.Position = UDim2.new(0, math.clamp(Pos2.X.Offset, 135, 260), 1, 0)
		MainScroll.Size  = UDim2.new(0, ControlSize2.Position.X.Offset, 1, -TopBar.Size.Y.Offset)
		Containers.Size  = UDim2.new(1, -MainScroll.Size.X.Offset, 1, -TopBar.Size.Y.Offset)
		TabSep.Position  = UDim2.new(0, MainScroll.Size.X.Offset, 0, 30)
		MainFrame.Size   = ControlSize1.Position
	end
	ControlSize1:GetPropertyChangedSignal("Position"):Connect(ControlSize)
	ControlSize2:GetPropertyChangedSignal("Position"):Connect(ControlSize)

	ConnectSave(ControlSize1, function()
		if not Minimized then
			lopklib.Save.UISize = {MainFrame.Size.X.Offset, MainFrame.Size.Y.Offset}
			SaveJson("lopk library V2.json", lopklib.Save)
		end
	end)
	ConnectSave(ControlSize2, function()
		lopklib.Save.TabSize = MainScroll.Size.X.Offset
		SaveJson("lopk library V2.json", lopklib.Save)
	end)

	local ButtonsFolder = Create("Folder", TopBar, { Name = "Buttons" })

	local CloseButton = Create("ImageButton", {
		Size               = UDim2.new(0, 14, 0, 14),
		Position           = UDim2.new(1, -12, 0.5),
		AnchorPoint        = Vector2.new(1, 0.5),
		BackgroundTransparency = 1,
		Image              = "rbxassetid://10747384394",
		ImageColor3        = Color3.fromRGB(255, 80, 100),
		AutoButtonColor    = false,
		Name               = "Close"
	})

	local MinimizeButton = SetProps(CloseButton:Clone(), {
		Position   = UDim2.new(1, -34, 0.5),
		Image      = "rbxassetid://10734896206",
		ImageColor3 = Theme["Color Theme"],
		Name       = "Minimize"
	})

	SetChildren(ButtonsFolder, { CloseButton, MinimizeButton })

	CloseButton.MouseButton1Down:Connect(PlayClickSound)
	MinimizeButton.MouseButton1Down:Connect(PlayClickSound)

	local Minimized, SaveSize, WaitClick
	local Window, FirstTab = {}, false

	function Window:CloseBtn()
		Window:Dialog({
			Title   = "اغلاق",
			Text    = "تريد ان تغلق السكربت؟",
			Options = {
				{"نعم", function() ScreenGui:Destroy() end},
				{"لا"}
			}
		})
	end

	function Window:MinimizeBtn()
		if WaitClick then return end
		WaitClick = true
		if Minimized then
			MinimizeButton.ImageColor3 = Theme["Color Theme"]
			CreateTween({MainFrame, "Size", SaveSize, 0.25, true})
			ControlSize1.Visible = true
			ControlSize2.Visible = true
			SetParticlesVisible(true)
			Minimized = false
		else
			MinimizeButton.ImageColor3 = Color3.fromRGB(200, 200, 200)
			SaveSize = MainFrame.Size
			ControlSize1.Visible = false
			ControlSize2.Visible = false
			SetParticlesVisible(false)
			CreateTween({MainFrame, "Size", UDim2.fromOffset(MainFrame.Size.X.Offset, 30), 0.25, true})
			Minimized = true
		end
		WaitClick = false
	end

	function Window:Minimize()
		MainFrame.Visible = not MainFrame.Visible
	end

	function Window:AddMinimizeButton(Configs)
		local BtnSize = (Configs.Button and Configs.Button.Size) or UDim2.fromOffset(60, 60)

		local Btn = MakeDrag(Create("ImageButton", ScreenGui, {
			Size               = BtnSize,
			Position           = UDim2.fromScale(0.15, 0.15),
			BackgroundTransparency = 1,
			AutoButtonColor    = false,
			ZIndex             = 10
		}))

		local Corner, Stroke
		if Configs.Corner then Corner = Make("Corner", Btn); SetProps(Corner, Configs.Corner) end

		Stroke = InsertTheme(Create("UIStroke", Btn, {
			Color           = Theme["Color Stroke"],
			Thickness       = 1.5,
			ApplyStrokeMode = "Border"
		}), "Stroke")

		-- [7] صورة داخل زر المصغّر
		local BtnImg = Create("ImageLabel", Btn, {
			Size               = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Image              = "rbxassetid://116627951531486",
			ImageTransparency  = 0.1,
			ScaleType          = Enum.ScaleType.Fit,
			ZIndex             = 11
		})
		if Configs.Corner then
			local bic = Create("UICorner", BtnImg, { CornerRadius = UDim.new(0, 10) })
		end

		return Btn
	end

	return Window
end

return lopklib