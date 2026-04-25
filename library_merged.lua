-- ║         LOPK Library  |  Cyan Edition        ║
-- ║         Theme: Neon Cyan / Deep Purple        ║
-- ║         Version: 2.0.0                        ║

local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService   = game:GetService("UserInputService")
local TweenService       = game:GetService("TweenService")
local HttpService        = game:GetService("HttpService")
local RunService         = game:GetService("RunService")
local CoreGui            = game:GetService("CoreGui")
local Players            = game:GetService("Players")
local Player             = Players.LocalPlayer
local PlayerMouse        = Player:GetMouse()

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

--  Core Utilities
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

--  Callback / Connection System
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

--  ScreenGui
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

--  Click Sound
local _SoundService = game:GetService("SoundService")
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

--  Element Factories
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

--  ButtonFrame helper
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

	-- Subtle neon left border glow
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

--  lopklib API
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
	local shimmerColor = Color3.fromRGB(255, 255, 255) -- أبيض لامع
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

	-- Top cyan accent line
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

--  Meteor System (NAR) - مدمج مع نظام الجسيمات
local function BuildParticleSystem(ParticleContainer, MainFrameRef)
	local ActiveParticles = {}

	-- إعدادات النيازك
	local MeteorImage = "rbxassetid://12543411478"
	local MeteorColor = Color3.fromRGB(255, 255, 255) -- أبيض لامع
	local SpawnRate   = 0.10 -- سرعة التوليد

	-- دالة إنشاء أثر ذيل النيزك
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

	-- دالة إنشاء نيزك
	local function SpawnMeteor()
		if not ParticleContainer or not ParticleContainer.Parent then return end
		local cs = ParticleContainer.AbsoluteSize
		if cs.X <= 0 or cs.Y <= 0 then return end

		local sizeW = math.random(90, 160)  -- كبير
		local sizeH = math.floor(sizeW * 1.5)

		local meteor = Instance.new("ImageLabel")
		meteor.Name                  = "NAR_Meteor"
		meteor.Size                  = UDim2.fromOffset(sizeW, sizeH)
		-- انتشار على كامل عرض الـ Frame بما فيه الأطراف
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

	-- حلقة التوليد - مع إصلاح مشكلة التعليق عند إعادة التشغيل
	if _G.LOPKParticleConnection then
		pcall(function() _G.LOPKParticleConnection:Disconnect() end)
		_G.LOPKParticleConnection = nil
	end
	if _G.LOPKParticleActive then _G.LOPKParticleActive = false end
	_G.LOPKParticleActive = true

	local lastSpawnTime = 0
	_G.LOPKParticleConnection = RunService.Heartbeat:Connect(function()
		if not _G.LOPKParticleActive then
			_G.LOPKParticleConnection:Disconnect()
			_G.LOPKParticleConnection = nil
			return
		end
		if MainFrameRef and MainFrameRef.Visible
		and ParticleContainer and ParticleContainer.Visible then
			local now = tick()
			if now - lastSpawnTime >= SpawnRate then
				lastSpawnTime = now
				SpawnMeteor()
			end
		end
	end)

	return ActiveParticles, function(enabled)
		ParticleContainer.Visible = enabled
	end
end

--  MakeWindow
function lopklib:MakeWindow(Configs)
	lopklib.Tabs = {} -- reset tabs لكل window جديد

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

	-- ══ دالة الإشعار الأزرق ══
	-- ══ دالة الإشعار - أبيض وأسود، صغير، من الأعلى ══
	local function CyberNotify(title, text, duration, accentColor)
		accentColor = accentColor or Color3.fromRGB(255, 255, 255)
		local NGui = Instance.new("ScreenGui")
		NGui.Name = "LOPKCyberNotif"
		NGui.ResetOnSpawn = false
		NGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		pcall(function() NGui.Parent = game:GetService("CoreGui") end)

		-- Frame صغير من الأعلى
		local Frame = Instance.new("Frame")
		Frame.Size = UDim2.fromOffset(240, 56)
		Frame.Position = UDim2.new(0.5, -120, 0, -65) -- مخفي فوق الشاشة
		Frame.AnchorPoint = Vector2.new(0, 0)
		Frame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
		Frame.BorderSizePixel = 0
		Frame.ClipsDescendants = true
		Frame.Parent = NGui
		Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

		-- خط علوي أبيض
		local TopBar = Instance.new("Frame", Frame)
		TopBar.Size = UDim2.new(1, 0, 0, 2)
		TopBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TopBar.BorderSizePixel = 0
		local TBGrad = Instance.new("UIGradient", TopBar)
		TBGrad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0,    Color3.fromRGB(0, 0, 0)),
			ColorSequenceKeypoint.new(0.3,  Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.7,  Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1,    Color3.fromRGB(0, 0, 0)),
		})

		-- Stroke أبيض
		local Stroke = Instance.new("UIStroke", Frame)
		Stroke.Thickness = 1.2
		Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		Stroke.Color = Color3.fromRGB(255, 255, 255)
		Stroke.Transparency = 0.5

		-- نبض الـ Stroke
		task.spawn(function()
			local a = 0
			while Frame and Frame.Parent do
				a = (a + 4) % 360
				local w = (math.sin(math.rad(a)) + 1) / 2
				pcall(function() Stroke.Transparency = 0.3 + w * 0.55 end)
				task.wait(0.04)
			end
		end)

		-- عنوان
		local TitleL = Instance.new("TextLabel", Frame)
		TitleL.Size = UDim2.new(1, -70, 0, 20)
		TitleL.Position = UDim2.fromOffset(12, 8)
		TitleL.BackgroundTransparency = 1
		TitleL.Text = title
		TitleL.TextColor3 = Color3.fromRGB(255, 255, 255)
		TitleL.TextSize = 11
		TitleL.Font = Enum.Font.GothamBold
		TitleL.TextXAlignment = Enum.TextXAlignment.Left
		TitleL.TextTruncate = Enum.TextTruncate.AtEnd

		-- وصف
		local DescL = Instance.new("TextLabel", Frame)
		DescL.Size = UDim2.new(1, -70, 0, 16)
		DescL.Position = UDim2.fromOffset(12, 27)
		DescL.BackgroundTransparency = 1
		DescL.Text = text
		DescL.TextColor3 = Color3.fromRGB(190, 190, 190)
		DescL.TextSize = 9
		DescL.Font = Enum.Font.Gotham
		DescL.TextXAlignment = Enum.TextXAlignment.Left
		DescL.TextWrapped = true

		-- عداد تنازلي (أبيض)
		local CounterL = Instance.new("TextLabel", Frame)
		CounterL.Size = UDim2.fromOffset(48, 40)
		CounterL.Position = UDim2.new(1, -52, 0.5, 0)
		CounterL.AnchorPoint = Vector2.new(0, 0.5)
		CounterL.BackgroundTransparency = 1
		CounterL.Text = tostring(duration)
		CounterL.TextColor3 = Color3.fromRGB(255, 255, 255)
		CounterL.TextSize = 20
		CounterL.Font = Enum.Font.GothamBold
		CounterL.TextXAlignment = Enum.TextXAlignment.Center

		-- شريط تقدم سفلي
		local BarBG = Instance.new("Frame", Frame)
		BarBG.Size = UDim2.new(1, -16, 0, 2)
		BarBG.Position = UDim2.new(0, 8, 1, -5)
		BarBG.AnchorPoint = Vector2.new(0, 1)
		BarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		BarBG.BorderSizePixel = 0
		Instance.new("UICorner", BarBG).CornerRadius = UDim.new(1, 0)

		local BarFill = Instance.new("Frame", BarBG)
		BarFill.Size = UDim2.new(1, 0, 1, 0)
		BarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BarFill.BorderSizePixel = 0
		Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

		-- دخول من الأعلى
		TweenService:Create(Frame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Position = UDim2.new(0.5, -120, 0, 10)
		}):Play()

		-- عداد تنازلي
		local timeLeft = duration
		local interval = 0.05
		task.spawn(function()
			while timeLeft > 0 and Frame and Frame.Parent do
				task.wait(interval)
				timeLeft = timeLeft - interval
				local ratio = math.max(timeLeft / duration, 0)
				pcall(function()
					BarFill.Size = UDim2.new(ratio, 0, 1, 0)
					CounterL.Text = string.format("%d", math.ceil(timeLeft))
				end)
			end
		end)

		task.wait(duration)

		-- خروج للأعلى
		local out = TweenService:Create(Frame, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
			Position = UDim2.new(0.5, -120, 0, -65)
		})
		out:Play()
		out.Completed:Wait()
		NGui:Destroy()
	end

	-- ══ إشعار أول: 17 ثانية مع موسيقى ══
	local function ShowFirstNotify()
		CyberNotify("⏳ جاري التحميل...", "انتظر 5 ثواني وسيشتغل السكربت", 5, Color3.fromRGB(255, 255, 255))
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

	-- ══ Avatar Background Image ══
	local AvatarBG = Create("ImageLabel", MainFrame, {
		Size               = UDim2.new(1, 0, 1, 0),
		Position           = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		Image              = "rbxassetid://88293683920607",
		ImageTransparency  = 0,
		ScaleType          = Enum.ScaleType.Crop,
		ZIndex             = 0,
		Name               = "AvatarBG"
	})
	Make("Corner", AvatarBG)

	-- ══ Animated Purple/Black Gradient Overlay ══
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

	-- Animate gradient rotation
	task.spawn(function()
		local angle = 120
		while MainFrame and MainFrame.Parent do
			angle = (angle + 0.4) % 360
			BlueGrad.Rotation = angle
			task.wait(0.03)
		end
	end)


	-- Outer animated black/white stroke
	local OuterStroke = Create("UIStroke", MainFrame, {
		Color           = Color3.fromRGB(255, 255, 255),
		Thickness       = 1.8,
		ApplyStrokeMode = "Border"
	})
	-- أنيميشن متحرك أسود وأبيض للحواف
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

	-- Top bar accent line
	local TopAccent = Create("Frame", TopBar, {
		Size             = UDim2.new(1, 0, 0, 1),
		Position         = UDim2.new(0, 0, 1, -1),
		BackgroundColor3 = Theme["Color Stroke"],
		BorderSizePixel  = 0,
		BackgroundTransparency = 0.6
	})

	local Title = InsertTheme(Create("TextLabel", TopBar, {
		Position          = UDim2.new(0, 18, 0.5),
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

	-- Tab separator line
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

	-- Particles
	local ParticleContainer = Create("Frame", Containers, {
		Size               = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Name               = "ThemeParticles",
		ZIndex             = -5,
		ClipsDescendants   = true
	})
	local ActiveParticles, SetParticlesVisible = BuildParticleSystem(ParticleContainer, MainFrame)

	-- Resize handles
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

	-- Close / Minimize buttons
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

		-- Cyan stroke مطابق لنمط المكتبة
		Stroke = InsertTheme(Create("UIStroke", Btn, {
			Color           = Theme["Color Stroke"],
			Thickness       = 1.5,
			ApplyStrokeMode = "Border"
		}), "Stroke")
		if Configs.Stroke then SetProps(Stroke, Configs.Stroke) end

		SetProps(Btn, Configs.Button)

		-- انيميشن تكبير / تصغير عند الضغط
		local OrigSize = Btn.Size
		Btn.MouseButton1Down:Connect(function()
			PlayClickSound()
			CreateTween({Btn, "Size", OrigSize - UDim2.fromOffset(6, 6), 0.1})
		end)
		Btn.MouseButton1Up:Connect(function()
			CreateTween({Btn, "Size", OrigSize, 0.15})
		end)
		Btn.MouseLeave:Connect(function()
			CreateTween({Btn, "Size", OrigSize, 0.15})
		end)

		Btn.Activated:Connect(Window.Minimize)
		return { Stroke = Stroke, Corner = Corner, Button = Btn }
	end

	function Window:Set(Val1, Val2)
		if type(Val1) == "string" and type(Val2) == "string" then
			Title.Text = Val1; Title.SubTitle.Text = Val2
		elseif type(Val1) == "string" then
			Title.Text = Val1
		end
	end

	function Window:Dialog(Configs)
		if MainFrame:FindFirstChild("Dialog") then return end
		if Minimized then Window:MinimizeBtn() end

		local DTitle   = Configs[1] or Configs.Title   or "Dialog"
		local DText    = Configs[2] or Configs.Text    or "This is a Dialog"
		local DOptions = Configs[3] or Configs.Options or {}

		local Frame = Create("Frame", {
			Active    = true,
			Size      = UDim2.fromOffset(250 * 1.08, 150 * 1.08),
			Position  = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		}, {
			InsertTheme(Create("TextLabel", {
				Font              = Enum.Font.GothamBold,
				Size              = UDim2.new(1, 0, 0, 22),
				Text              = DTitle,
				TextXAlignment    = "Left",
				TextColor3        = Theme["Color Text"],
				TextSize          = 15,
				Position          = UDim2.fromOffset(15, 6),
				BackgroundTransparency = 1
			}), "Text"),
			InsertTheme(Create("TextLabel", {
				Font              = Enum.Font.GothamMedium,
				Size              = UDim2.new(1, -25),
				AutomaticSize     = "Y",
				Text              = DText,
				TextXAlignment    = "Left",
				TextColor3        = Theme["Color Dark Text"],
				TextSize          = 12,
				Position          = UDim2.fromOffset(15, 28),
				BackgroundTransparency = 1,
				TextWrapped       = true
			}), "DarkText")
		})
		Make("Gradient", Frame, { Rotation = 135 })
		Make("Corner",   Frame)
		Create("UIStroke", Frame, {
			Color           = Theme["Color Stroke"],
			Thickness       = 1.2,
			ApplyStrokeMode = "Border"
		})

		local ButtonsHolder = Create("Frame", Frame, {
			Size        = UDim2.fromScale(1, 0.35),
			Position    = UDim2.fromScale(0, 1),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = 1
		}, {
			Create("UIListLayout", {
				Padding             = UDim.new(0, 10),
				VerticalAlignment   = "Center",
				FillDirection       = "Horizontal",
				HorizontalAlignment = "Center"
			})
		})

		local Screen = InsertTheme(Create("Frame", MainFrame, {
			BackgroundTransparency = 0.5,
			Active                 = true,
			BackgroundColor3       = Color3.fromRGB(10, 10, 10),
			Size                   = UDim2.new(1, 0, 1, 0),
			Name                   = "Dialog"
		}), "Stroke")
		MainCorner:Clone().Parent = Screen
		Frame.Parent = Screen
		CreateTween({Frame,  "Size",         UDim2.fromOffset(250, 150), 0.2})
		CreateTween({Screen, "Transparency", 0.25, 0.15})

		local ButtonCount, Dialog = 1, {}
		function Dialog:Button(Cfg)
			local Name     = Cfg[1] or Cfg.Name or Cfg.Title or ""
			local Callback = Cfg[2] or Cfg.Callback or function() end
			ButtonCount = ButtonCount + 1
			local Btn = Make("Button", ButtonsHolder)
			Make("Corner", Btn)
			SetProps(Btn, {
				Text      = Name,
				Font      = Enum.Font.GothamBold,
				TextColor3= Theme["Color Text"],
				TextSize  = 12
			})
			for _, B in pairs(ButtonsHolder:GetChildren()) do
				if B:IsA("TextButton") then
					B.Size = UDim2.new(1/ButtonCount, -(((ButtonCount-1)*20)/ButtonCount), 0, 32)
				end
			end
			Btn.Activated:Connect(Dialog.Close)
			Btn.Activated:Connect(Callback)
		end
		function Dialog:Close()
			CreateTween({Frame,  "Size",         UDim2.fromOffset(250*1.08, 150*1.08), 0.2})
			CreateTween({Screen, "Transparency", 1, 0.15, true})
			Screen:Destroy()
		end
		for _, B in ipairs(DOptions) do Dialog:Button(B) end
		return Dialog
	end

	function Window:SelectTab(TabSelect)
		if type(TabSelect) == "number" then
			lopklib.Tabs[TabSelect].func:Enable()
		else
			for _, Tab in pairs(lopklib.Tabs) do
				if Tab.Cont == TabSelect.Cont then Tab.func:Enable() end
			end
		end
	end

	--  MakeTab
	local ContainerList = {}
	function Window:MakeTab(paste, Configs)
		if type(paste) == "table" then Configs = paste end
		local TName = Configs[1] or Configs.Title or "Tab!"
		local TIcon = Configs[2] or Configs.Icon  or ""
		TIcon = lopklib:GetIcon(TIcon)
		if not TIcon:find("rbxassetid://") or TIcon:gsub("rbxassetid://",""):len() < 6 then
			TIcon = false
		end

		local TabSelect = Make("Button", MainScroll, {
			Size = UDim2.new(1, 0, 0, 26)
		}) Make("Corner", TabSelect)

		-- أنيميشن حواف التبويب أسود وأبيض لامع
		local TabStroke = Create("UIStroke", TabSelect, {
			Color           = Color3.fromRGB(255, 255, 255),
			Thickness       = 1,
			ApplyStrokeMode = "Border",
			Transparency    = 0.5
		})
		task.spawn(function()
			local angle = math.random(0, 359)
			while TabSelect and TabSelect.Parent do
				angle = (angle + 3) % 360
				local wave = (math.sin(math.rad(angle)) + 1) / 2
				local brightness = math.floor(wave * 255)
				pcall(function()
					TabStroke.Color = Color3.fromRGB(brightness, brightness, brightness)
					TabStroke.Transparency = 0.3 + wave * 0.5
				end)
				task.wait(0.04)
			end
		end)

		local LabelTitle = InsertTheme(Create("TextLabel", TabSelect, {
			Size              = UDim2.new(1, TIcon and -27 or -15, 1),
			Position          = UDim2.fromOffset(TIcon and 27 or 15),
			BackgroundTransparency = 1,
			Font              = Enum.Font.GothamMedium,
			Text              = TName,
			TextColor3        = Theme["Color Text"],
			TextSize          = 10,
			TextXAlignment    = Enum.TextXAlignment.Left,
			TextTransparency  = FirstTab and 0.4 or 0,
			TextTruncate      = "AtEnd"
		}), "Text")

		local LabelIcon = InsertTheme(Create("ImageLabel", TabSelect, {
			Position          = UDim2.new(0, 9, 0.5),
			Size              = UDim2.new(0, 13, 0, 13),
			AnchorPoint       = Vector2.new(0, 0.5),
			Image             = TIcon or "",
			ImageColor3       = Theme["Color Theme"],
			BackgroundTransparency = 1,
			ImageTransparency = FirstTab and 0.4 or 0
		}), "Text")

		local Selected = InsertTheme(Create("Frame", TabSelect, {
			Size              = FirstTab and UDim2.new(0, 3, 0, 3) or UDim2.new(0, 3, 0, 14),
			Position          = UDim2.new(0, 0, 0.5),
			AnchorPoint       = Vector2.new(0, 0.5),
			BackgroundColor3  = Theme["Color Theme"],
			BackgroundTransparency = FirstTab and 1 or 0
		}), "Theme") Make("Corner", Selected, UDim.new(0.5, 0))

		local Container = InsertTheme(Create("ScrollingFrame", {
			Size                    = UDim2.new(1, 0, 1, 0),
			Position                = UDim2.new(0, 0, 1),
			AnchorPoint             = Vector2.new(0, 1),
			ScrollBarThickness      = 1.5,
			BackgroundTransparency  = 1,
			ScrollBarImageTransparency = 0.2,
			ScrollBarImageColor3    = Theme["Color Theme"],
			AutomaticCanvasSize     = "Y",
			ScrollingDirection      = "Y",
			BorderSizePixel         = 0,
			CanvasSize              = UDim2.new(),
			Name = ("Container %i [ %s ]"):format(#ContainerList + 1, TName)
		}, {
			Create("UIPadding", {
				PaddingLeft   = UDim.new(0, 10),
				PaddingRight  = UDim.new(0, 10),
				PaddingTop    = UDim.new(0, 10),
				PaddingBottom = UDim.new(0, 10)
			}),
			Create("UIListLayout", { Padding = UDim.new(0, 5) })
		}), "ScrollBar")

		table.insert(ContainerList, Container)
		if not FirstTab then
			Container.Parent = Containers
		end

		local function Tabs()
			if Container.Parent == Containers then return end
			for _, Frame in pairs(ContainerList) do
				if Frame:IsA("ScrollingFrame") and Frame ~= Container then
					Frame.Parent = nil
				end
			end
			Container.Parent = Containers
			Container.Size   = UDim2.new(1, 0, 1, 0)
			for _, Tab in ipairs(lopklib.Tabs) do
				if Tab.Cont ~= Container then Tab.func:Disable() end
			end
			CreateTween({LabelTitle, "TextTransparency", 0,   0.35})
			CreateTween({LabelIcon,  "ImageTransparency",0,   0.35})
			CreateTween({Selected,   "Size",             UDim2.new(0, 3, 0, 14), 0.35})
			CreateTween({Selected,   "BackgroundTransparency", 0, 0.35})
		end
		TabSelect.Activated:Connect(Tabs)
		FirstTab = true

		local Tab = {}
		table.insert(lopklib.Tabs, { TabInfo = {Name = TName, Icon = TIcon}, func = Tab, Cont = Container })
		Tab.Cont = Container

		function Tab:Disable()
			Container.Parent = nil
			CreateTween({LabelTitle, "TextTransparency", 0.4, 0.35})
			CreateTween({LabelIcon,  "ImageTransparency",0.4, 0.35})
			CreateTween({Selected,   "Size",             UDim2.new(0, 3, 0, 3),  0.35})
			CreateTween({Selected,   "BackgroundTransparency", 1, 0.35})
		end
		function Tab:Enable() Tabs() end
		function Tab:Visible(Bool)
			Funcs:ToggleVisible(TabSelect, Bool)
			Funcs:ToggleParent(Container, Bool, Containers)
		end
		function Tab:Destroy() TabSelect:Destroy(); Container:Destroy() end

		function Tab:AddSection(Configs)
			local SectionName = type(Configs) == "string" and Configs
				or Configs[1] or Configs.Name or Configs.Title or Configs.Section

			local SectionFrame = Create("Frame", Container, {
				Size               = UDim2.new(1, 0, 0, 20),
				BackgroundTransparency = 1,
				Name               = "Option"
			})

			-- Neon line under section title
			local Line = Create("Frame", SectionFrame, {
				Size             = UDim2.new(1, -30, 0, 1),
				Position         = UDim2.new(0, 30, 1, -1),
				BackgroundColor3 = Theme["Color Stroke"],
				BorderSizePixel  = 0,
				BackgroundTransparency = 0.6
			})

			local SectionLabel = InsertTheme(Create("TextLabel", SectionFrame, {
				Font              = Enum.Font.GothamBold,
				Text              = SectionName,
				TextColor3        = Theme["Color Dark Purple"],
				Size              = UDim2.new(1, -25, 1, 0),
				Position          = UDim2.new(0, 30),
				BackgroundTransparency = 1,
				TextTruncate      = "AtEnd",
				TextSize          = 11,
				TextXAlignment    = "Left"
			}), "Text")

			-- Small accent dot
			local Dot = InsertTheme(Create("Frame", SectionFrame, {
				Size             = UDim2.new(0, 5, 0, 5),
				Position         = UDim2.new(0, 22, 0.5),
				AnchorPoint      = Vector2.new(0, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 0, 0)
			}), "Theme") Make("Corner", Dot, UDim.new(0.5, 0))

			local Section = {}
			table.insert(lopklib.Options, {type="Section", Name=SectionName, func=Section})
			function Section:Visible(Bool)
				if Bool == nil then SectionFrame.Visible = not SectionFrame.Visible return end
				SectionFrame.Visible = Bool
			end
			function Section:Destroy() SectionFrame:Destroy() end
			function Section:Set(New) if New then SectionLabel.Text = GetStr(New) end end
			return Section
		end

		function Tab:AddParagraph(Configs)
			local PName = Configs[1] or Configs.Title or "Paragraph"
			local PDesc = Configs[2] or Configs.Text  or ""
			local Frame, LabelFunc = ButtonFrame(Container, PName, PDesc, UDim2.new(1, -20))
			local Paragraph = {}
			function Paragraph:Visible(...)  Funcs:ToggleVisible(Frame, ...) end
			function Paragraph:Destroy()     Frame:Destroy() end
			function Paragraph:SetTitle(Val) LabelFunc:SetTitle(GetStr(Val)) end
			function Paragraph:SetDesc(Val)  LabelFunc:SetDesc(GetStr(Val))  end
			function Paragraph:Set(Val1, Val2)
				if Val1 and Val2 then LabelFunc:SetTitle(GetStr(Val1)); LabelFunc:SetDesc(GetStr(Val2))
				elseif Val1 then LabelFunc:SetDesc(GetStr(Val1)) end
			end
			return Paragraph
		end

		function Tab:AddButton(Configs)
			local BName        = Configs[1] or Configs.Name  or Configs.Title or "Button!"
			local BDescription = Configs.Desc or Configs.Description or ""
			local Callback     = Funcs:GetCallback(Configs, 2)
			local FButton, LabelFunc = ButtonFrame(Container, BName, BDescription, UDim2.new(1, -20))

			-- Chevron icon
			local BIcon = InsertTheme(Create("ImageLabel", FButton, {
				Size               = UDim2.new(0, 13, 0, 13),
				Position           = UDim2.new(1, -10, 0.5),
				AnchorPoint        = Vector2.new(1, 0.5),
				BackgroundTransparency = 1,
				Image              = "rbxassetid://10709791437",
				ImageColor3        = Theme["Color Theme"]
			}), "Theme")

			FButton.Activated:Connect(function()
				Funcs:FireCallback(Callback)
				CreateTween({BIcon, "ImageTransparency", 0.8, 0.1})
				task.delay(0.15, function() CreateTween({BIcon,"ImageTransparency",0,0.15}) end)
			end)

			local Button = {}
			function Button:Visible(...)  Funcs:ToggleVisible(FButton, ...) end
			function Button:Destroy()     FButton:Destroy() end
			function Button:Callback(...) Funcs:InsertCallback(Callback, ...) end
			function Button:Set(Val1, Val2)
				if type(Val1) == "string" and type(Val2) == "string" then
					LabelFunc:SetTitle(Val1); LabelFunc:SetDesc(Val2)
				elseif type(Val1) == "string" then LabelFunc:SetTitle(Val1)
				elseif type(Val1) == "function" then Callback = Val1 end
			end
			return Button
		end

		function Tab:AddToggle(Configs)
			local TName    = Configs[1] or Configs.Name  or Configs.Title or "Toggle"
			local TDesc    = Configs.Desc or Configs.Description or ""
			local Callback = Funcs:GetCallback(Configs, 3)
			local Flag     = Configs[4] or Configs.Flag    or false
			local Default  = Configs[2] or Configs.Default or false
			if CheckFlag(Flag) then Default = GetFlag(Flag) end

			local Button, LabelFunc = ButtonFrame(Container, TName, TDesc, UDim2.new(1, -52))

			-- Track الخارجي (الكبسولة)
			local ToggleHolder = Create("Frame", Button, {
				Size             = UDim2.new(0, 52, 0, 28),
				Position         = UDim2.new(1, -8, 0.5, 0),
				AnchorPoint      = Vector2.new(1, 0.5),
				BackgroundColor3 = Color3.fromRGB(18, 18, 18),
				BorderSizePixel  = 0,
				ClipsDescendants = false,
			})
			Make("Corner", ToggleHolder, UDim.new(0.5, 0))

			-- Stroke خارجي
			local THStroke = Instance.new("UIStroke", ToggleHolder)
			THStroke.Thickness = 1
			THStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			THStroke.Color = Color3.fromRGB(55, 55, 55)

			-- خط علوي لامع (gradient)
			local TopShine = Create("Frame", ToggleHolder, {
				Size             = UDim2.new(1, 0, 0, 1),
				Position         = UDim2.new(0, 0, 0, 0),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel  = 0,
			})
			local ShineGrad = Instance.new("UIGradient", TopShine)
			ShineGrad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0,    Color3.fromRGB(0,0,0)),
				ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255,255,255)),
				ColorSequenceKeypoint.new(0.65, Color3.fromRGB(255,255,255)),
				ColorSequenceKeypoint.new(1,    Color3.fromRGB(0,0,0)),
			})

			-- الكنوب (الدائرة المتحركة)
			local Knob = Create("Frame", ToggleHolder, {
				Size             = UDim2.new(0, 20, 0, 20),
				Position         = UDim2.new(0, 14, 0.5, 0),
				AnchorPoint      = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(55, 55, 55),
				BorderSizePixel  = 0,
				ZIndex           = 3,
			})
			Make("Corner", Knob, UDim.new(0.5, 0))

			-- بريق صغير فوق الكنوب
			local KnobShine = Create("Frame", Knob, {
				Size             = UDim2.new(0, 7, 0, 3),
				Position         = UDim2.new(0, 4, 0, 4),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 0.7,
				BorderSizePixel  = 0,
				ZIndex           = 4,
			})
			Make("Corner", KnobShine, UDim.new(1, 0))

			-- حلقة نبض عند التفعيل
			local function SpawnPulse()
				local ring = Create("Frame", ToggleHolder, {
					Size             = UDim2.new(0, 20, 0, 20),
					Position         = UDim2.new(1, -14, 0.5, 0),
					AnchorPoint      = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					BorderSizePixel  = 0,
					ZIndex           = 2,
				})
				Make("Corner", ring, UDim.new(0.5, 0))
				local stroke = Instance.new("UIStroke", ring)
				stroke.Thickness = 1
				stroke.Color = Color3.fromRGB(255, 255, 255)
				stroke.Transparency = 0.3
				TweenService:Create(ring, TweenInfo.new(0.45, Enum.EasingStyle.Quart), {
					Size = UDim2.new(0, 34, 0, 34),
				}):Play()
				TweenService:Create(stroke, TweenInfo.new(0.45), {
					Transparency = 1
				}):Play()
				task.delay(0.5, function() ring:Destroy() end)
			end

			local WaitClickT
			local function SetToggle(Val)
				if WaitClickT then return end
				WaitClickT, Default = true, Val
				SetFlag(Flag, Default)
				Funcs:FireCallback(Callback, Default)
				if Default then
					-- ON: كنوب يمين أبيض/فضي — AnchorPoint ثابت (0.5,0.5)
					CreateTween({Knob, "Position", UDim2.new(0, 38, 0.5, 0), 0.28})
					CreateTween({Knob, "BackgroundColor3", Color3.fromRGB(235, 235, 235), 0.25})
					CreateTween({ToggleHolder, "BackgroundColor3", Color3.fromRGB(25, 25, 28), 0.25})
					THStroke.Color = Color3.fromRGB(170, 170, 170)
					task.delay(0.05, SpawnPulse)
				else
					-- OFF: كنوب يسار رمادي غامق
					CreateTween({Knob, "Position", UDim2.new(0, 14, 0.5, 0), 0.28})
					CreateTween({Knob, "BackgroundColor3", Color3.fromRGB(55, 55, 55), 0.25})
					CreateTween({ToggleHolder, "BackgroundColor3", Color3.fromRGB(18, 18, 18), 0.25})
					THStroke.Color = Color3.fromRGB(55, 55, 55)
				end
				task.wait(0.3)
				WaitClickT = false
			end; task.spawn(SetToggle, Default)

			Button.Activated:Connect(function() SetToggle(not Default) end)

			local ToggleObj = {}
			function ToggleObj:Visible(...)  Funcs:ToggleVisible(Button, ...) end
			function ToggleObj:Destroy()     Button:Destroy() end
			function ToggleObj:Callback(...) Funcs:InsertCallback(Callback, ...)() end
			function ToggleObj:Set(Val1, Val2)
				if type(Val1) == "string" and type(Val2) == "string" then
					LabelFunc:SetTitle(Val1); LabelFunc:SetDesc(Val2)
				elseif type(Val1) == "string"  then LabelFunc:SetTitle(Val1, false, true)
				elseif type(Val1) == "boolean" then task.spawn(SetToggle, Val1)
				elseif type(Val1) == "function" then Callback = Val1 end
			end
			return ToggleObj
		end

		function Tab:AddDropdown(Configs)
			local DName       = Configs[1] or Configs.Name    or Configs.Title or "Dropdown"
			local DDesc       = Configs.Desc or Configs.Description or ""
			local DOptions    = Configs[2] or Configs.Options  or {}
			local OpDefault   = Configs[3] or Configs.Default  or {}
			local Flag        = Configs[5] or Configs.Flag     or false
			local DMultiSelect= Configs.MultiSelect or false
			local Callback    = Funcs:GetCallback(Configs, 4)

			local Button, LabelFunc = ButtonFrame(Container, DName, DDesc, UDim2.new(1, -180))

			local SelectedFrame = InsertTheme(Create("Frame", Button, {
				Size             = UDim2.new(0, 150, 0, 18),
				Position         = UDim2.new(1, -10, 0.5),
				AnchorPoint      = Vector2.new(1, 0.5),
				BackgroundColor3 = Theme["Color Stroke"]
			}), "Stroke") Make("Corner", SelectedFrame, UDim.new(0, 4))

			local ActiveLabel = InsertTheme(Create("TextLabel", SelectedFrame, {
				Size              = UDim2.new(0.85, 0, 0.85, 0),
				AnchorPoint       = Vector2.new(0.5, 0.5),
				Position          = UDim2.new(0.5, 0, 0.5, 0),
				BackgroundTransparency = 1,
				Font              = Enum.Font.GothamBold,
				TextScaled        = true,
				TextColor3        = Theme["Color Text"],
				Text              = "..."
			}), "Text")

			local Arrow = InsertTheme(Create("ImageLabel", SelectedFrame, {
				Size              = UDim2.new(0, 14, 0, 14),
				Position          = UDim2.new(0, -5, 0.5),
				AnchorPoint       = Vector2.new(1, 0.5),
				Image             = "rbxassetid://10709791523",
				ImageColor3       = Theme["Color Theme"],
				BackgroundTransparency = 1
			}), "Theme")

			local NoClickFrame = Create("TextButton", DropdownHolder, {
				Name               = "AntiClick",
				Size               = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Visible            = false,
				Text               = ""
			})

			local DropFrame = Create("Frame", NoClickFrame, {
				Size               = UDim2.new(SelectedFrame.Size.X, 0, 0),
				BackgroundTransparency = 0.06,
				BackgroundColor3   = Color3.fromRGB(4, 12, 32),
				AnchorPoint        = Vector2.new(0, 1),
				Name               = "DropdownFrame",
				ClipsDescendants   = true,
				Active             = true
			}) Make("Corner", DropFrame) Make("Stroke", DropFrame) Make("Gradient", DropFrame, {Rotation = 135})

			local ScrollFrame = InsertTheme(Create("ScrollingFrame", DropFrame, {
				ScrollBarImageColor3    = Theme["Color Theme"],
				Size                    = UDim2.new(1, 0, 1, 0),
				ScrollBarThickness      = 1.5,
				BackgroundTransparency  = 1,
				BorderSizePixel         = 0,
				CanvasSize              = UDim2.new(),
				ScrollingDirection      = "Y",
				AutomaticCanvasSize     = "Y",
				Active                  = true
			}, {
				Create("UIPadding", {
					PaddingLeft   = UDim.new(0, 8),
					PaddingRight  = UDim.new(0, 8),
					PaddingTop    = UDim.new(0, 5),
					PaddingBottom = UDim.new(0, 5)
				}),
				Create("UIListLayout", { Padding = UDim.new(0, 4) })
			}), "ScrollBar")

			local ScrollSize, WaitClickD = 5
			local function Disable()
				WaitClickD = true
				CreateTween({Arrow,    "Rotation",   0, 0.2})
				CreateTween({DropFrame,"Size",        UDim2.new(0,152,0,0), 0.2, true})
				CreateTween({Arrow,    "ImageColor3", Theme["Color Theme"],  0.2})
				Arrow.Image         = "rbxassetid://10709791523"
				NoClickFrame.Visible = false
				WaitClickD          = false
			end

			local function GetFrameSize() return UDim2.fromOffset(152, ScrollSize) end

			local function CalculateSize()
				local Count = 0
				for _, Frame in pairs(ScrollFrame:GetChildren()) do
					if Frame:IsA("Frame") or Frame.Name == "Option" then Count += 1 end
				end
				ScrollSize = (math.clamp(Count, 0, 10) * 25) + 10
				if NoClickFrame.Visible then
					CreateTween({DropFrame,"Size", GetFrameSize(), 0.2})
				end
			end

			local function Minimize()
				if WaitClickD then return end
				WaitClickD = true
				if NoClickFrame.Visible then
					Arrow.Image = "rbxassetid://10709791523"
					CreateTween({Arrow,    "ImageColor3", Theme["Color Theme"], 0.2})
					CreateTween({DropFrame,"Size",        UDim2.new(0,152,0,0), 0.2, true})
					NoClickFrame.Visible = false
				else
					NoClickFrame.Visible = true
					Arrow.Image = "rbxassetid://10709790948"
					CreateTween({Arrow,    "ImageColor3", Theme["Color Theme"], 0.2})
					CreateTween({DropFrame,"Size",        GetFrameSize(), 0.2, true})
				end
				WaitClickD = false
			end

			local function CalculatePos()
				local FramePos   = SelectedFrame.AbsolutePosition
				local ScreenSize = ScreenGui.AbsoluteSize
				local ClampX     = math.clamp((FramePos.X / UIScale), 0, ScreenSize.X / UIScale - DropFrame.Size.X.Offset)
				local ClampY     = math.clamp((FramePos.Y / UIScale), 0, ScreenSize.Y / UIScale)
				local NewPos     = UDim2.fromOffset(ClampX, ClampY)
				local AnchorP    = FramePos.Y > ScreenSize.Y / 1.4 and 1 or ScrollSize > 80 and 0.5 or 0
				DropFrame.AnchorPoint = Vector2.new(0, AnchorP)
				CreateTween({DropFrame,"Position", NewPos, 0.1})
			end

			local AddNewOptions, GetOptions, AddOption, RemoveOption, SelectedD
			local Options = {}
			SelectedD = DMultiSelect and {} or (CheckFlag(Flag) and GetFlag(Flag) or OpDefault[1])

			if DMultiSelect then
				local DefList = type(OpDefault) ~= "table" and {OpDefault} or OpDefault
				for idx, Value in pairs(CheckFlag(Flag) and GetFlag(Flag) or DefList) do
					if type(idx) == "string" and (DOptions[idx] or table.find(DOptions, idx)) then
						SelectedD[idx] = Value
					elseif DOptions[Value] then SelectedD[Value] = true end
				end
			end

			local function CallbackSelected()
				SetFlag(Flag, DMultiSelect and SelectedD or tostring(SelectedD))
				Funcs:FireCallback(Callback, SelectedD)
			end

			local function UpdateLabel()
				if DMultiSelect then
					local list = {}
					for idx, Value in pairs(SelectedD) do if Value then table.insert(list, idx) end end
					ActiveLabel.Text = #list > 0 and table.concat(list, ", ") or "..."
				else
					ActiveLabel.Text = tostring(SelectedD or "...")
				end
			end

			local function UpdateSelected()
				for _, v in pairs(Options) do
					local nodes, Stats = v.nodes, v.Stats
					if DMultiSelect then
						CreateTween({nodes[2],"BackgroundTransparency", Stats and 0 or 0.8, 0.3})
						CreateTween({nodes[2],"Size",      Stats and UDim2.fromOffset(4,12) or UDim2.fromOffset(4,4), 0.3})
						CreateTween({nodes[3],"TextTransparency", Stats and 0 or 0.4, 0.3})
					else
						local Slt = v.Value == SelectedD
						CreateTween({nodes[2],"BackgroundTransparency", Slt and 0 or 1, 0.3})
						CreateTween({nodes[2],"Size",      Slt and UDim2.fromOffset(4,14) or UDim2.fromOffset(4,4), 0.3})
						CreateTween({nodes[3],"TextTransparency", Slt and 0 or 0.4, 0.3})
					end
				end
				UpdateLabel()
			end

			local function Select(Option)
				if DMultiSelect then
					Option.Stats = not Option.Stats
					SelectedD[Option.Name] = Option.Stats
				else
					SelectedD = Option.Value
				end
				Option.LastCB = tick()
				CallbackSelected()
				UpdateSelected()
			end

			AddOption = function(index, Value)
				local Name = tostring(type(index) == "string" and index or Value)
				if Options[Name] then return end
				Options[Name] = { index=index, Value=Value, Name=Name, Stats=false, LastCB=0 }
				if DMultiSelect then
					local Stats = SelectedD[Name]
					SelectedD[Name]       = Stats or false
					Options[Name].Stats   = Stats
				end

				local Btn = Make("Button", ScrollFrame, {
					Name      = "Option",
					Size      = UDim2.new(1, 0, 0, 22),
					Position  = UDim2.new(0, 0, 0.5),
					AnchorPoint = Vector2.new(0, 0.5)
				}) Make("Corner", Btn, UDim.new(0, 4))

				local IsSelected = InsertTheme(Create("Frame", Btn, {
					Position          = UDim2.new(0, 1, 0.5),
					Size              = UDim2.new(0, 4, 0, 4),
					BackgroundColor3  = Theme["Color Theme"],
					BackgroundTransparency = 1,
					AnchorPoint       = Vector2.new(0, 0.5)
				}), "Theme") Make("Corner", IsSelected, UDim.new(0.5, 0))

				local OptName = InsertTheme(Create("TextLabel", Btn, {
					Size              = UDim2.new(1, 0, 1),
					Position          = UDim2.new(0, 10),
					Text              = Name,
					TextColor3        = Theme["Color Text"],
					Font              = Enum.Font.GothamMedium,
					TextXAlignment    = "Left",
					BackgroundTransparency = 1,
					TextTransparency  = 0.4
				}), "Text")

				Btn.Activated:Connect(function() Select(Options[Name]) end)
				Options[Name].nodes = {Btn, IsSelected, OptName}
			end

			RemoveOption = function(index, Value)
				local Name = tostring(type(index) == "string" and index or Value)
				if Options[Name] then
					if DMultiSelect then SelectedD[Name] = nil else SelectedD = nil end
					Options[Name].nodes[1]:Destroy()
					table.clear(Options[Name])
					Options[Name] = nil
				end
			end

			GetOptions = function() return Options end

			AddNewOptions = function(List, Clear)
				if Clear then for k, v in pairs(Options) do RemoveOption(k, v.Value) end end
				for k, v in pairs(List) do AddOption(k, v) end
				CallbackSelected(); UpdateSelected()
			end

			for k, v in pairs(DOptions) do AddOption(k, v) end
			CallbackSelected(); UpdateSelected()

			Button.Activated:Connect(Minimize)
			NoClickFrame.MouseButton1Down:Connect(Disable)
			NoClickFrame.MouseButton1Click:Connect(Disable)
			MainFrame:GetPropertyChangedSignal("Visible"):Connect(Disable)
			SelectedFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(CalculatePos)
			Button.Activated:Connect(CalculateSize)
			ScrollFrame.ChildAdded:Connect(CalculateSize)
			ScrollFrame.ChildRemoved:Connect(CalculateSize)
			CalculatePos(); CalculateSize()

			local Dropdown = {}
			function Dropdown:Visible(...)  Funcs:ToggleVisible(Button, ...) end
			function Dropdown:Destroy()     Button:Destroy() end
			function Dropdown:Callback(...) Funcs:InsertCallback(Callback, ...)(SelectedD) end
			function Dropdown:Add(...)
				local NewOpts = {...}
				if type(NewOpts[1]) == "table" then
					for _, Name in ipairs(NewOpts[1]) do AddOption(Name) end
				else
					for _, Name in ipairs(NewOpts) do AddOption(Name) end
				end
			end
			function Dropdown:Remove(Option)
				for index, Value in pairs(GetOptions()) do
					if type(Option) == "number" and index == Option
					or Value.Name == Option then RemoveOption(index, Value.Value) end
				end
			end
			function Dropdown:Set(Val1, Clear)
				if type(Val1) == "table" then AddNewOptions(Val1, not Clear)
				elseif type(Val1) == "function" then Callback = Val1 end
			end
			return Dropdown
		end

		function Tab:AddSlider(Configs)
			local SName    = Configs[1] or Configs.Name  or Configs.Title or "Slider!"
			local SDesc    = Configs.Desc or Configs.Description or ""
			local Min      = Configs[2] or Configs.MinValue or Configs.Min or 10
			local Max      = Configs[3] or Configs.MaxValue or Configs.Max or 100
			local Increase = Configs[4] or Configs.Increase or 1
			local Callback = Funcs:GetCallback(Configs, 6)
			local Flag     = Configs[7] or Configs.Flag    or false
			local Default  = Configs[5] or Configs.Default or 25
			if CheckFlag(Flag) then Default = GetFlag(Flag) end
			Min, Max       = Min / Increase, Max / Increase

			local Button, LabelFunc = ButtonFrame(Container, SName, SDesc, UDim2.new(1, -180))

			local SliderHolder = Create("TextButton", Button, {
				Size              = UDim2.new(0.45, 0, 1),
				Position          = UDim2.new(1),
				AnchorPoint       = Vector2.new(1, 0),
				AutoButtonColor   = false,
				Text              = "",
				BackgroundTransparency = 1
			})

			local SliderBar = Create("Frame", SliderHolder, {
				BackgroundColor3  = Color3.fromRGB(22, 22, 22),
				Size              = UDim2.new(1, -20, 0, 6),
				Position          = UDim2.new(0.5, 0, 0.5),
				AnchorPoint       = Vector2.new(0.5, 0.5),
				BorderSizePixel   = 0,
			}) Make("Corner", SliderBar)
			-- stroke رفيع أبيض حول الـ track
			local SBStroke = Instance.new("UIStroke", SliderBar)
			SBStroke.Thickness = 1
			SBStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			SBStroke.Color = Color3.fromRGB(60, 60, 60)

			-- الجزء المملوء (أبيض)
			local Indicator = Create("Frame", SliderBar, {
				BackgroundColor3  = Color3.fromRGB(255, 255, 255),
				Size              = UDim2.fromScale(0.3, 1),
				BorderSizePixel   = 0
			}) Make("Corner", Indicator)
			-- gradient على الـ fill ليكون أكثر عمقاً
			local IndGrad = Instance.new("UIGradient", Indicator)
			IndGrad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 180, 180)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
			})

			-- توهج أسفل الـ fill
			local IndicatorGlow = Create("Frame", SliderBar, {
				BackgroundColor3  = Color3.fromRGB(255, 255, 255),
				Size              = UDim2.fromScale(0.3, 4),
				Position          = UDim2.new(0, 0, 0.5),
				AnchorPoint       = Vector2.new(0, 0.5),
				BackgroundTransparency = 0.82,
				BorderSizePixel   = 0
			}) Make("Corner", IndicatorGlow)

			-- الـ Handle (مقبض الشريط) — مربع فضي صغير
			local SliderIcon = Create("Frame", SliderBar, {
				Size              = UDim2.new(0, 5, 0, 16),
				BackgroundColor3  = Color3.fromRGB(240, 240, 240),
				Position          = UDim2.fromScale(0.3, 0.5),
				AnchorPoint       = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 0,
				BorderSizePixel   = 0,
				ZIndex            = 3,
			}) Make("Corner", SliderIcon, UDim.new(0, 3))
			-- توهج حول الـ handle
			local HGlow = Create("Frame", SliderBar, {
				Size              = UDim2.new(0, 14, 0, 22),
				Position          = UDim2.fromScale(0.3, 0.5),
				AnchorPoint       = Vector2.new(0.5, 0.5),
				BackgroundColor3  = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 0.88,
				BorderSizePixel   = 0,
				ZIndex            = 2,
			}) Make("Corner", HGlow)

			local LabelVal = InsertTheme(Create("TextLabel", SliderHolder, {
				Size              = UDim2.new(0, 14, 0, 14),
				AnchorPoint       = Vector2.new(1, 0.5),
				Position          = UDim2.new(0, 0, 0.5),
				BackgroundTransparency = 1,
				TextColor3        = Theme["Color Text"],
				Font              = Enum.Font.GothamBold,
				TextSize          = 12
			}), "Text")

			local UIScaleV = Create("UIScale", LabelVal)

			local BaseMousePos = Create("Frame", SliderBar, {
				Position  = UDim2.new(0, 0, 0.5, 0),
				Visible   = false
			})

			local function UpdateLabel(NewValue)
				local Number = math.floor(tonumber(NewValue * Increase) * 100) / 100
				Default, LabelVal.Text = Number, tostring(Number)
				SetFlag(Flag, Default)
				Funcs:FireCallback(Callback, Default)
			end

			local function ControlPos()
				local Mouse    = Player:GetMouse()
				local APos     = Mouse.X - BaseMousePos.AbsolutePosition.X
				local ConfigPos= APos / SliderBar.AbsoluteSize.X
				SliderIcon.Position = UDim2.new(math.clamp(ConfigPos, 0, 1), 0, 0.5, 0)
			end

			local function UpdateValues()
				local sp = SliderIcon.Position.X.Scale
				Indicator.Size     = UDim2.new(sp, 0, 1, 0)
				IndicatorGlow.Size = UDim2.new(sp, 0, 4, 0)
				HGlow.Position     = UDim2.fromScale(sp, 0.5)
				local NewValue     = math.floor(((sp * Max) / Max) * (Max - Min) + Min)
				UpdateLabel(NewValue)
			end

			SliderHolder.MouseButton1Down:Connect(function()
				Container.ScrollingEnabled = false
				while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
					task.wait(); ControlPos()
				end
				Container.ScrollingEnabled = true
			end)

			LabelVal:GetPropertyChangedSignal("Text"):Connect(function()
				UIScaleV.Scale = 0.3
				CreateTween({UIScaleV, "Scale", 1.2, 0.1})
				CreateTween({LabelVal, "Rotation", math.random(-1,1)*4, 0.12, true})
				CreateTween({UIScaleV, "Scale", 1, 0.18})
				CreateTween({LabelVal, "Rotation", 0, 0.08})
			end)

			local function SetSlider(NewValue)
				if type(NewValue) ~= "number" then return end
				local MinR = Min * Increase
				local MaxR = Max * Increase
				local SP   = (NewValue - MinR) / (MaxR - MinR)
				CreateTween({SliderIcon, "Position", UDim2.fromScale(math.clamp(SP, 0, 1), 0.5), 0.3, true})
				CreateTween({HGlow,     "Position", UDim2.fromScale(math.clamp(SP, 0, 1), 0.5), 0.3, true})
			end; SetSlider(Default)

			SliderIcon:GetPropertyChangedSignal("Position"):Connect(UpdateValues)
			UpdateValues()

			local SliderObj = {}
			function SliderObj:Set(NewVal1, NewVal2)
				if NewVal1 and NewVal2 then LabelFunc:SetTitle(NewVal1); LabelFunc:SetDesc(NewVal2)
				elseif type(NewVal1) == "string"   then LabelFunc:SetTitle(NewVal1)
				elseif type(NewVal1) == "function"  then Callback = NewVal1
				elseif type(NewVal1) == "number"    then SetSlider(NewVal1) end
			end
			function SliderObj:Callback(...) Funcs:InsertCallback(Callback, ...)(tonumber(Default)) end
			function SliderObj:Visible(...)  Funcs:ToggleVisible(Button, ...) end
			function SliderObj:Destroy()     Button:Destroy() end
			return SliderObj
		end

		function Tab:AddTextBox(Configs)
			local TName           = Configs[1] or Configs.Name  or Configs.Title or "Text Box"
			local TDesc           = Configs.Desc or Configs.Description or ""
			local TDefault        = Configs[2] or Configs.Default or ""
			local TPlaceholderText= Configs[5] or Configs.PlaceholderText or "Input..."
			local TClearText      = Configs[3] or Configs.ClearText or false
			local Callback        = Funcs:GetCallback(Configs, 4)

			if type(TDefault) ~= "string" or TDefault:gsub(" ",""):len() < 1 then
				TDefault = false
			end

			local Button, LabelFunc = ButtonFrame(Container, TName, TDesc, UDim2.new(1, -42))

			local SelectedFrame = InsertTheme(Create("Frame", Button, {
				Size             = UDim2.new(0, 155, 0, 18),
				Position         = UDim2.new(1, -10, 0.5),
				AnchorPoint      = Vector2.new(1, 0.5),
				BackgroundColor3 = Theme["Color Stroke"]
			}), "Stroke") Make("Corner", SelectedFrame, UDim.new(0, 4))

			local TextBoxInput = InsertTheme(Create("TextBox", SelectedFrame, {
				Size              = UDim2.new(0.85, 0, 0.85, 0),
				AnchorPoint       = Vector2.new(0.5, 0.5),
				Position          = UDim2.new(0.5, 0, 0.5, 0),
				BackgroundTransparency = 1,
				Font              = Enum.Font.GothamBold,
				TextScaled        = true,
				TextColor3        = Theme["Color Text"],
				ClearTextOnFocus  = TClearText,
				PlaceholderText   = TPlaceholderText,
				PlaceholderColor3 = Theme["Color Dark Text"],
				Text              = ""
			}), "Text")

			local PencilIcon = InsertTheme(Create("ImageLabel", SelectedFrame, {
				Size              = UDim2.new(0, 11, 0, 11),
				Position          = UDim2.new(0, -5, 0.5),
				AnchorPoint       = Vector2.new(1, 0.5),
				Image             = "rbxassetid://15637081879",
				ImageColor3       = Theme["Color Dark Text"],
				BackgroundTransparency = 1
			}), "DarkText")

			local TextBox = {}
			local function Input()
				local Text = TextBoxInput.Text
				if Text:gsub(" ",""):len() > 0 then
					if TextBox.OnChanging then Text = TextBox.OnChanging(Text) or Text end
					Funcs:FireCallback(Callback, Text)
					TextBoxInput.Text = Text
				end
			end
			TextBoxInput.FocusLost:Connect(Input); Input()
			TextBoxInput.FocusLost:Connect(function()
				CreateTween({PencilIcon, "ImageColor3", Theme["Color Dark Text"], 0.2})
			end)
			TextBoxInput.Focused:Connect(function()
				CreateTween({PencilIcon, "ImageColor3", Theme["Color Theme"], 0.2})
			end)

			TextBox.OnChanging = false
			function TextBox:Visible(...)  Funcs:ToggleVisible(Button, ...) end
			function TextBox:Destroy()     Button:Destroy() end
			return TextBox
		end

		function Tab:AddDiscordInvite(Configs)
			local Title        = Configs[1] or Configs.Name  or Configs.Title or "Discord Server"
			local Description  = Configs[2] or Configs.Desc  or Configs.Description or ""
			local Logo         = Configs[3] or Configs.Icon  or Configs.Logo  or ""
			local Invite       = Configs[4] or Configs.Invite or Configs.Link or ""
			local MembersOnline= Configs.Online  or Configs.MembersOnline or 0
			local TotalMembers = Configs.Members or Configs.TotalMembers  or 0
			local BannerImage  = Configs.Banner  or Configs.BannerImage   or ""

			local InviteHolder = Create("Frame", Container, {
				Size               = UDim2.new(1, 0, 0, 148),
				Name               = "Option",
				BackgroundTransparency = 1
			})

			local InviteLabel = InsertTheme(Create("TextLabel", InviteHolder, {
				Size              = UDim2.new(1, 0, 0, 15),
				Position          = UDim2.new(0, 5),
				TextColor3        = Theme["Color Theme"],
				Font              = Enum.Font.GothamBold,
				TextXAlignment    = "Left",
				BackgroundTransparency = 1,
				TextSize          = 9,
				Text              = Invite
			}), "Text")

			local CardFrame = InsertTheme(Create("Frame", InviteHolder, {
				Size               = UDim2.new(0, 178, 1, -15),
				Position           = UDim2.new(0, 5, 1, 0),
				AnchorPoint        = Vector2.new(0, 1),
				BackgroundColor3   = Theme["Color Hub 2"],
				ClipsDescendants   = true
			}), "Frame")
			Make("Corner", CardFrame, UDim.new(0, 12))
			Make("Stroke",  CardFrame)

			local BannerArea = Create("ImageLabel", CardFrame, {
				Size              = UDim2.new(1, 0, 0.28, 0),
				Image             = BannerImage,
				BackgroundColor3  = Color3.fromRGB(18, 18, 18),
				BackgroundTransparency = BannerImage ~= "" and 1 or 0,
				ScaleType         = Enum.ScaleType.Crop
			}) Make("Corner", BannerArea, UDim.new(0, 12))

			if BannerImage == "" then
				Create("UIGradient", BannerArea, {
					Rotation = -15,
					Color    = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 15)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25))
					})
				})
			end

			local ServerIcon = Create("ImageLabel", CardFrame, {
				Size              = UDim2.new(0, 33, 0, 33),
				Position          = UDim2.new(0, 10, 0.28, 0),
				AnchorPoint       = Vector2.new(0, 0.5),
				Image             = Logo,
				BackgroundTransparency = Logo == "" and 1 or 0,
				BackgroundColor3  = Theme["Color Hub 2"]
			}) Make("Corner", ServerIcon, UDim.new(0, 8))
			if Logo ~= "" then Make("Stroke", ServerIcon, nil, Theme["Color Hub 2"], 2.2) end

			local ServerTitle = InsertTheme(Create("TextLabel", CardFrame, {
				Size              = UDim2.new(1, -20, 0, 10),
				Position          = UDim2.new(0, 10, 0.44, 0),
				TextXAlignment    = "Left",
				BackgroundTransparency = 1,
				TextSize          = 11,
				Text              = Title,
				Font              = Enum.Font.GothamBold,
				TextColor3        = Theme["Color Text"]
			}), "Text")

			local MembersFrame
			if MembersOnline > 0 or TotalMembers > 0 then
				MembersFrame = Create("Frame", CardFrame, {
					Size               = UDim2.new(1, -20, 0, 9),
					Position           = UDim2.new(0, 7, 0.52, 0),
					BackgroundTransparency = 1
				}, {
					Create("UIListLayout", {
						HorizontalAlignment = "Left",
						VerticalAlignment   = "Center",
						FillDirection       = "Horizontal",
						Padding             = UDim.new(0, 4)
					}),
					Create("UIPadding", {
						PaddingLeft  = UDim.new(0, 3),
						PaddingRight = UDim.new(0, 10)
					})
				})

				local function CreateStatusIndicator(color, text)
					local SF  = Create("Frame", MembersFrame, {
						Size               = UDim2.new(0, 0, 1, 0),
						AutomaticSize      = "X",
						BackgroundTransparency = 1
					})
					local Dot = Create("Frame", SF, {
						Size             = UDim2.new(0, 4, 0, 4),
						Position         = UDim2.new(0, 5, 0.5, 0),
						AnchorPoint      = Vector2.new(0, 0.5),
						BackgroundColor3 = color
					}) Make("Corner", Dot, UDim.new(1, 0))
					InsertTheme(Create("TextLabel", SF, {
						Size              = UDim2.new(0, 0, 1, 0),
						Position          = UDim2.new(0, 12, 0.5, 0),
						AnchorPoint       = Vector2.new(0, 0.5),
						AutomaticSize     = "X",
						BackgroundTransparency = 1,
						TextSize          = 7,
						Text              = text,
						Font              = Enum.Font.Gotham,
						TextColor3        = Theme["Color Dark Text"]
					}), "DarkText")
				end

				if MembersOnline > 0 then
					CreateStatusIndicator(Color3.fromRGB(255, 0, 0), MembersOnline .. " Online")
				end
				if TotalMembers > 0 then
					CreateStatusIndicator(Color3.fromRGB(255, 0, 0), TotalMembers .. " Members")
				end
			end

			local DescriptionLabel = InsertTheme(Create("TextLabel", CardFrame, {
				Size              = UDim2.new(1, -60, 0, 8),
				Position          = UDim2.new(0, 10, MembersFrame and 0.6 or 0.56, 0),
				TextXAlignment    = "Left",
				AutomaticSize     = "Y",
				BackgroundTransparency = 1,
				TextSize          = 8,
				Text              = Description,
				TextWrapped       = true,
				Font              = Enum.Font.Gotham,
				TextColor3        = Theme["Color Dark Text"]
			}), "DarkText")

			local BottomSection = InsertTheme(Create("Frame", CardFrame, {
				Size             = UDim2.new(1, 0, Description == "" and 0.28 or 0.42, 0),
				Position         = UDim2.new(0, 0, 1, 0),
				AnchorPoint      = Vector2.new(0, 1),
				BackgroundColor3 = Theme["Color Hub 2"],
				BorderSizePixel  = 0
			}), "Frame")

			if Description ~= "" then
				Create("UIGradient", BottomSection, {
					Rotation = -90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0.00, 0.00),
						NumberSequenceKeypoint.new(0.60, 0.00),
						NumberSequenceKeypoint.new(1.00, 1.00)
					})
				})
			end

			local JoinButton = InsertTheme(Create("TextButton", BottomSection, {
				Position         = UDim2.new(0.5, 0, 1, -9),
				Size             = UDim2.new(1, -18, 0, 18),
				AnchorPoint      = Vector2.new(0.5, 1),
				Text             = "Join Server",
				Font             = Enum.Font.GothamBold,
				TextSize         = 10,
				BackgroundColor3 = Theme["Color Theme"],
				TextColor3       = Color3.fromRGB(255, 255, 255)
			}), "Text") Make("Corner", JoinButton, UDim.new(0.5, 0))

			local clickCooldown = 0
			JoinButton.Activated:Connect(function()
				if tick() - clickCooldown < 5 then return end
				clickCooldown = tick()
				local originalText = JoinButton.Text
				JoinButton.Text = "Copied!"
				if setclipboard then setclipboard(Invite) end
				task.wait(4)
				if JoinButton and JoinButton.Parent then
					JoinButton.Text = originalText
				end
			end)

			local DiscordInvite = {}
			function DiscordInvite:Destroy()  InviteHolder:Destroy() end
			function DiscordInvite:Visible(...)  Funcs:ToggleVisible(InviteHolder, ...) end
			function DiscordInvite:Set(newTitle, newDesc, newInvite)
				if newTitle  then ServerTitle.Text   = newTitle  end
				if newDesc   then DescriptionLabel.Text = newDesc end
				if newInvite then InviteLabel.Text   = newInvite end
			end
			return DiscordInvite
		end

		return Tab
	end

	CloseButton.Activated:Connect(Window.CloseBtn)
	MinimizeButton.Activated:Connect(Window.MinimizeBtn)

	-- اشعار 2: يظهر بعد ما يشتغل السكربت مباشرة (4 ثواني)
	task.delay(0.1, function()
		CyberNotify("✅ تم التفعيل!", "تم تفعيل السكربت بنجاح 🎉", 4, Color3.fromRGB(0, 255, 160))
	end)

	return Window
end

return lopklib