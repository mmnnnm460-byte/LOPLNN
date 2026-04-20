--[[
    ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗    ██╗   ██╗██╗
    ████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝    ██║   ██║██║
    ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗    ██║   ██║██║
    ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║    ██║   ██║██║
    ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║    ╚██████╔╝██║
    ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝     ╚═════╝ ╚═╝

    NexusUI  v1.0  |  2026  |  Roblox UI Library
    Glassmorphism Design | Video/Image Background | Rich Elements

    ══════════════════════════════════════════════
    الاستخدام السريع:

    local NexusUI = loadstring(game:HttpGet("YOUR_RAW_LINK"))()

    local Window = NexusUI:CreateWindow({
        Title      = "My Hub",
        SubTitle   = "by Developer",
        Theme      = "Midnight",
        Background = {
            Type = "Video",          -- "Color" | "Gradient" | "Image" | "Video"
            URL  = "rbxassetid://...",
        },
        ToggleKey  = Enum.KeyCode.RightShift,
        Transparent = true,
        Blur        = true,
    })

    local Tab = Window:Tab({ Title = "Main", Icon = "home" })
    local Sec = Tab:Section({ Title = "Player" })

    Sec:Toggle({     Title="God Mode",  Value=false,   Callback=function(v) end })
    Sec:Slider({     Title="Speed",     Value={Min=0,Max=300,Default=16}, Callback=function(v) end })
    Sec:Button({     Title="Kill All",  Desc="Kills all players", Callback=function() end })
    Sec:Input({      Title="Username",  Placeholder="Enter name...", Callback=function(v) end })
    Sec:Dropdown({   Title="Team",      Options={"Red","Blue","Green"}, Callback=function(v) end })
    Sec:Keybind({    Title="Fly Key",   Value=Enum.KeyCode.F, Callback=function(v) end })
    Sec:ColorPicker({Title="ESP Color", Value=Color3.new(1,0,0), Callback=function(v) end })
    Sec:ProgressBar({Title="XP",        Value=65 })
    Sec:Badge({      Title="Rank",      Text="VIP", Color="#9d4edd" })
    Sec:NumberInput({Title="Amount",    Value=10, Min=1, Max=100, Step=1, Callback=function(v) end })
    Sec:RadioGroup({ Title="Mode",      Options={"PVP","PVE","Casual"}, Default="PVP", Callback=function(v) end })
    Sec:MultiToggle({Title="Visuals",   Options={{Text="ESP",Value=false},{Text="Chams",Value=true}}, Callback=function(states) end })
    Sec:AlertBanner({Type="warning",    Title="Caution", Message="Use responsibly", Dismissable=true })
    Sec:Divider()
    Sec:Label({ Title = "NexusUI v1.0" })

    NexusUI:Notify({ Title="Done!", Content="Script loaded.", Duration=4 })
    ══════════════════════════════════════════════
]]

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local LocalPlayer      = Players.LocalPlayer

-- ════════════════════════════════════════════
-- Helpers
-- ════════════════════════════════════════════
local function Tween(obj, t, props, style, dir)
    return TweenService:Create(
        obj,
        TweenInfo.new(t, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out),
        props
    )
end

local function New(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then pcall(function() inst[k] = v end) end
    end
    for _, c in ipairs(children or {}) do
        if c then c.Parent = inst end
    end
    if props and props.Parent then inst.Parent = props.Parent end
    return inst
end

local function Hex(h)
    h = h:gsub("#","")
    return Color3.fromRGB(
        tonumber(h:sub(1,2),16),
        tonumber(h:sub(3,4),16),
        tonumber(h:sub(5,6),16)
    )
end

local function SafeCall(fn, ...)
    if type(fn)=="function" then
        local ok,e = pcall(fn,...) if not ok then warn("[NexusUI] "..tostring(e)) end
    end
end

local function Corner(r,p)  return New("UICorner",{CornerRadius=UDim.new(0,r),Parent=p}) end
local function Stroke(th,c,tr,p) return New("UIStroke",{Thickness=th,Color=c or Color3.new(1,1,1),Transparency=tr or 0.85,Parent=p}) end
local function Pad(t,b,l,r,p) return New("UIPadding",{PaddingTop=UDim.new(0,t or 0),PaddingBottom=UDim.new(0,b or 0),PaddingLeft=UDim.new(0,l or 0),PaddingRight=UDim.new(0,r or 0),Parent=p}) end
local function List(gap,p) return New("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,gap or 4),Parent=p}) end

-- ════════════════════════════════════════════
-- Themes
-- ════════════════════════════════════════════
local T = {
    Midnight = { Accent=Hex"#7c6af7", AccentH=Hex"#9d8fff", Bg=Hex"#0d0d14", S1=Hex"#13131e", S2=Hex"#1a1a28", Br=Color3.new(1,1,1), BrT=0.88, Tx=Hex"#e8e6f0", TxS=Hex"#6b6890", Tog=Hex"#7c6af7", Sli=Hex"#7c6af7", Btn=Hex"#7c6af7", Ok=Hex"#4ade80", Warn=Hex"#fbbf24", Err=Hex"#f87171", SB=Hex"#0f0f1a", TA=Hex"#7c6af7", TT=Hex"#4a4870", TTA=Hex"#e8e6f0" },
    Neon     = { Accent=Hex"#00f5ff", AccentH=Hex"#33f8ff", Bg=Hex"#030308", S1=Hex"#08080f", S2=Hex"#0f0f1e", Br=Hex"#00f5ff", BrT=0.7,  Tx=Hex"#e0f8ff", TxS=Hex"#3a6870", Tog=Hex"#00f5ff", Sli=Hex"#00f5ff", Btn=Hex"#00c8d4", Ok=Hex"#00ff9d", Warn=Hex"#ffdd00", Err=Hex"#ff4466", SB=Hex"#050510", TA=Hex"#00f5ff", TT=Hex"#1e4850", TTA=Hex"#e0f8ff" },
    Ocean    = { Accent=Hex"#0ea5e9", AccentH=Hex"#38bdf8", Bg=Hex"#020c18", S1=Hex"#061525", S2=Hex"#0b2035", Br=Hex"#0ea5e9", BrT=0.75, Tx=Hex"#bae6fd", TxS=Hex"#2a5068", Tog=Hex"#0ea5e9", Sli=Hex"#0ea5e9", Btn=Hex"#0077b6", Ok=Hex"#34d399", Warn=Hex"#fbbf24", Err=Hex"#f87171", SB=Hex"#030f1e", TA=Hex"#0ea5e9", TT=Hex"#1a4060", TTA=Hex"#bae6fd" },
    Sakura   = { Accent=Hex"#f472b6", AccentH=Hex"#f9a8d4", Bg=Hex"#120812", S1=Hex"#1a0f1a", S2=Hex"#231523", Br=Hex"#f472b6", BrT=0.75, Tx=Hex"#fce7f3", TxS=Hex"#6b3050", Tog=Hex"#f472b6", Sli=Hex"#f472b6", Btn=Hex"#db2777", Ok=Hex"#4ade80", Warn=Hex"#fbbf24", Err=Hex"#f87171", SB=Hex"#0f060f", TA=Hex"#f472b6", TT=Hex"#4a1a38", TTA=Hex"#fce7f3" },
    Crimson  = { Accent=Hex"#ef4444", AccentH=Hex"#f87171", Bg=Hex"#0c0505", S1=Hex"#150a0a", S2=Hex"#1f0f0f", Br=Hex"#ef4444", BrT=0.75, Tx=Hex"#fee2e2", TxS=Hex"#6b2020", Tog=Hex"#ef4444", Sli=Hex"#ef4444", Btn=Hex"#b91c1c", Ok=Hex"#4ade80", Warn=Hex"#fbbf24", Err=Hex"#f87171", SB=Hex"#080303", TA=Hex"#ef4444", TT=Hex"#481010", TTA=Hex"#fee2e2" },
    Gold     = { Accent=Hex"#f59e0b", AccentH=Hex"#fbbf24", Bg=Hex"#0f0a02", S1=Hex"#1a1204", S2=Hex"#241a06", Br=Hex"#f59e0b", BrT=0.75, Tx=Hex"#fef3c7", TxS=Hex"#6b4e10", Tog=Hex"#f59e0b", Sli=Hex"#f59e0b", Btn=Hex"#d97706", Ok=Hex"#4ade80", Warn=Hex"#fbbf24", Err=Hex"#f87171", SB=Hex"#0a0701", TA=Hex"#f59e0b", TT=Hex"#4a3408", TTA=Hex"#fef3c7" },
}

-- ════════════════════════════════════════════
-- Icons
-- ════════════════════════════════════════════
local I = { home="⌂",settings="⚙",eye="◎",sword="⚔",shield="🛡",star="★",user="👤",plus="+",minus="−",check="✓",search="🔍",bell="🔔",heart="♥",fire="🔥",bolt="⚡",globe="🌐",folder="📁",code="⌨",palette="🎨",chart="📊",gun="🎯",skull="💀",run="🏃",fly="✈",esp="👁",speed="⚡",aim="🎯",item="📦",map="🗺",gear="⚙",lock="🔒",unlock="🔓",info="ℹ",warn="⚠",err="✕",ok="✓" }
local function Ico(n) return I[n] or "•" end

-- ════════════════════════════════════════════
-- Element Builders
-- ════════════════════════════════════════════

local function EToggle(p,c,th)
    local val = c.Value or false
    local h = c.Desc and 52 or 40
    local f = New("Frame",{Size=UDim2.new(1,0,0,h),BackgroundColor3=th.S2,BackgroundTransparency=0.3,Parent=p},{Corner(8),Stroke(1,th.Br,th.BrT)})
    Pad(0,0,12,12,f)
    New("TextLabel",{Size=UDim2.new(1,-58,0,20),Position=UDim2.new(0,0,0,c.Desc and 8 or 10),BackgroundTransparency=1,Text=c.Title or"Toggle",TextColor3=th.Tx,TextSize=13,Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
    if c.Desc then New("TextLabel",{Size=UDim2.new(1,-58,0,14),Position=UDim2.new(0,0,0,28),BackgroundTransparency=1,Text=c.Desc,TextColor3=th.TxS,TextSize=11,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,Parent=f}) end
    local track=New("Frame",{Size=UDim2.new(0,42,0,24),AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),BackgroundColor3=val and th.Tog or th.S1,BackgroundTransparency=val and 0 or 0.2,Parent=f},{Corner(99)})
    local dot=New("Frame",{Size=UDim2.new(0,18,0,18),AnchorPoint=Vector2.new(0.5,0.5),Position=val and UDim2.new(0,32,0.5,0) or UDim2.new(0,12,0.5,0),BackgroundColor3=Color3.new(1,1,1),Parent=track},{Corner(99)})
    local hit=New("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",Parent=f})
    local api={Value=val}
    local function set(v,nc)
        val=v api.Value=v
        Tween(track,0.2,{BackgroundColor3=v and th.Tog or th.S1,BackgroundTransparency=v and 0 or 0.2}):Play()
        Tween(dot,0.2,{Position=v and UDim2.new(0,32,0.5,0) or UDim2.new(0,12,0.5,0)}):Play()
        if not nc then SafeCall(c.Callback,v) end
    end
    hit.MouseButton1Click:Connect(function() set(not val) end)
    hit.MouseEnter:Connect(function() Tween(f,0.12,{BackgroundTransparency=0.1}):Play() end)
    hit.MouseLeave:Connect(function() Tween(f,0.12,{BackgroundTransparency=0.3}):Play() end)
    function api:Set(v) set(v,true) end
    return api
end

local function ESlider(p,c,th)
    local mn=(c.Value and c.Value.Min) or c.Min or 0
    local mx=(c.Value and c.Value.Max) or c.Max or 100
    local df=(c.Value and c.Value.Default) or c.Default or mn
    local step=c.Step or 1
    local val=df
    local f=New("Frame",{Size=UDim2.new(1,0,0,54),BackgroundColor3=th.S2,BackgroundTransparency=0.3,Parent=p},{Corner(8),Stroke(1,th.Br,th.BrT)})
    Pad(8,8,12,12,f)
    local row=New("Frame",{Size=UDim2.new(1,0,0,18),BackgroundTransparency=1,Parent=f})
    New("TextLabel",{Size=UDim2.new(0.7,0,1,0),BackgroundTransparency=1,Text=c.Title or"Slider",TextColor3=th.Tx,TextSize=13,Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Left,Parent=row})
    local vl=New("TextLabel",{Size=UDim2.new(0.3,0,1,0),Position=UDim2.new(0.7,0,0,0),BackgroundTransparency=1,Text=tostring(val),TextColor3=th.Accent,TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Right,Parent=row})
    local tr=New("Frame",{Size=UDim2.new(1,0,0,5),AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,0,1,0),BackgroundColor3=th.S1,Parent=f},{Corner(99)})
    local pc=(val-mn)/(mx-mn)
    local fl=New("Frame",{Size=UDim2.new(pc,0,1,0),BackgroundColor3=th.Sli,Parent=tr},{Corner(99)})
    local tb=New("Frame",{Size=UDim2.new(0,14,0,14),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(pc,0,0.5,0),BackgroundColor3=Color3.new(1,1,1),ZIndex=5,Parent=tr},{Corner(99)})
    local hit=New("TextButton",{Size=UDim2.new(1,0,0,24),Position=UDim2.new(0,0,0.5,-12),BackgroundTransparency=1,Text="",ZIndex=6,Parent=tr})
    local api={Value=val}
    local drag=false
    local function upd(ax)
        local r=math.clamp((ax-tr.AbsolutePosition.X)/tr.AbsoluteSize.X,0,1)
        val=math.clamp(math.floor((mn+(mx-mn)*r)/step+0.5)*step,mn,mx)
        api.Value=val
        local p2=(val-mn)/(mx-mn)
        fl.Size=UDim2.new(p2,0,1,0) tb.Position=UDim2.new(p2,0,0.5,0) vl.Text=tostring(val)
        SafeCall(c.Callback,val)
    end
    hit.MouseButton1Down:Connect(function() drag=true end)
    UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType==Enum.UserInputType.MouseMovement then upd(i.Position.X) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end)
    hit.MouseButton1Click:Connect(function() upd(UserInputService:GetMouseLocation().X) end)
    f.MouseEnter:Connect(function() Tween(f,0.12,{BackgroundTransparency=0.1}):Play() end)
    f.MouseLeave:Connect(function() Tween(f,0.12,{BackgroundTransparency=0.3}):Play() end)
    function api:Set(v)
        val=math.clamp(v,mn,mx) api.Value=val
        local p2=(val-mn)/(mx-mn)
        fl.Size=UDim2.new(p2,0,1,0) tb.Position=UDim2.new(p2,0,0.5,0) vl.Text=tostring(val)
    end
    return api
end

local function EButton(p,c,th)
    local h=c.Desc and 52 or 40
    local f=New("Frame",{Size=UDim2.new(1,0,0,h),BackgroundColor3=th.S2,BackgroundTransparency=0.3,Parent=p},{Corner(8),Stroke(1,th.Br,th.BrT)})
    Pad(0,0,12,44,f)
    New("TextLabel",{Size=UDim2.new(1,0,0,20),Position=UDim2.new(0,0,0,c.Desc and 8 or 10),BackgroundTransparency=1,Text=c.Title or"Button",TextColor3=th.Tx,TextSize=13,Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
    if c.Desc then New("TextLabel",{Size=UDim2.new(1,0,0,14),Position=UDim2.new(0,0,0,28),BackgroundTransparency=1,Text=c.Desc,TextColor3=th.TxS,TextSize=11,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,Parent=f}) end
    local arr=New("Frame",{Size=UDim2.new(0,30,0,30),AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-6,0.5,0),BackgroundColor3=th.Btn,BackgroundTransparency=0.6,Parent=f},{Corner(8)})
    New("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="→",TextColor3=th.Accent,TextSize=15,Font=Enum.Font.GothamBold,Parent=arr})
    local hit=New("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",Parent=f})
    hit.MouseEnter:Connect(function() Tween(f,0.12,{BackgroundTransparency=0.05}):Play() Tween(arr,0.12,{BackgroundTransparency=0.3}):Play() end)
    hit.MouseLeave:Connect(function() Tween(f,0.12,{BackgroundTransparency=0.3}):Play() Tween(arr,0.12,{BackgroundTransparency=0.6}):Play() end)
    hit.MouseButton1Down:Connect(function() Tween(f,0.06,{BackgroundTransparency=0.0}):Play() end)
    hit.MouseButton1Up:Connect(function() Tween(f,0.15,{BackgroundTransparency=0.3}):Play() SafeCall(c.Callback) end)
    return {Value=nil}
end

local function EInput(p,c,th)
    local f=New("Frame",{Size=UDim2.new(1,0,0,56),BackgroundColor3=th.S2,BackgroundTransparency=0.3,Parent=p},{Corner(8),Stroke(1,th.Br,th.BrT)})
    Pad(8,8,12,12,f)
    New("TextLabel",{Size=UDim2.new(1,0,0,16),BackgroundTransparency=1,Text=c.Title or"Input",TextColor3=th.Tx,TextSize=12,Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
    local bg=New("Frame",{Size=UDim2.new(1,0,0,26),Position=UDim2.new(0,0,0,22),BackgroundColor3=th.S1,BackgroundTransparency=0.3,Parent=f},{Corner(6),Stroke(1,th.Br,0.9)})
    local box=New("TextBox",{Size=UDim2.new(1,-16,1,0),Position=UDim2.new(0,8,0,0),BackgroundTransparency=1,Text=c.Default or"",PlaceholderText=c.Placeholder or"Type...",PlaceholderColor3=th.TxS,TextColor3=th.Tx,TextSize=12,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,ClearTextOnFocus=c.ClearOnFocus~=false,Parent=bg})
    local api={Value=box.Text}
    box.Focused:Connect(function() Tween(bg,0.12,{BackgroundTransparency=0.05}):Play() end)
    box.FocusLost:Connect(function(enter) Tween(bg,0.12,{BackgroundTransparency=0.3}):Play() api.Value=box.Text SafeCall(c.Callback,box.Text,enter) end)
    function api:Set(v) box.Text=v api.Value=v end
    return api
end

local function EDropdown(p,c,th)
    local opts=c.Options or {}
    local sel=c.Default or opts[1] or ""
    local open=false
    local f=New("Frame",{Size=UDim2.new(1,0,0,40),BackgroundColor3=th.S2,BackgroundTransparency=0.3,ClipsDescendants=false,ZIndex=10,Parent=p},{Corner(8),Stroke(1,th.Br,th.BrT)})
    Pad(0,0,12,12,f)
    New("TextLabel",{Size=UDim2.new(0.5,0,1,0),BackgroundTransparency=1,Text=c.Title or"Dropdown",TextColor3=th.Tx,TextSize=13,Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
    local sl=New("TextLabel",{Size=UDim2.new(0.45,0,1,0),Position=UDim2.new(0.5,0,0,0),BackgroundTransparency=1,Text=sel,TextColor3=th.Accent,TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Right,Parent=f})
    local ar=New("TextLabel",{Size=UDim2.new(0,20,1,0),Position=UDim2.new(1,-20,0,0),BackgroundTransparency=1,Text="▾",TextColor3=th.Accent,TextSize=14,Font=Enum.Font.GothamBold,Parent=f})
    local df=New("Frame",{Size=UDim2.new(1,0,0,0),Position=UDim2.new(0,0,1,4),BackgroundColor3=th.S1,BackgroundTransparency=0.05,ClipsDescendants=true,ZIndex=20,Visible=false,Parent=f},{Corner(8),Stroke(1,th.Br,th.BrT)})
    local dl=New("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,ZIndex=21,Parent=df})
    List(0,dl) Pad(4,4,0,0,dl)
    local api={Value=sel}
    local function pick(opt)
        sel=opt api.Value=opt sl.Text=opt
        open=false ar.Text="▾"
        Tween(df,0.18,{Size=UDim2.new(1,0,0,0)}):Play()
        task.delay(0.2,function() df.Visible=false end)
        SafeCall(c.Callback,opt)
    end
    for _,opt in ipairs(opts) do
        local b=New("TextButton",{Size=UDim2.new(1,0,0,32),BackgroundColor3=th.S2,BackgroundTransparency=1,Text="",ZIndex=22,Parent=dl})
        New("TextLabel",{Size=UDim2.new(1,-16,1,0),Position=UDim2.new(0,12,0,0),BackgroundTransparency=1,Text=opt,TextColor3=opt==sel and th.Accent or th.Tx,TextSize=12,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=23,Parent=b})
        b.MouseEnter:Connect(function() Tween(b,0.1,{BackgroundTransparency=0.7}):Play() end)
        b.MouseLeave:Connect(function() Tween(b,0.1,{BackgroundTransparency=1}):Play() end)
        b.MouseButton1Click:Connect(function() pick(opt) end)
    end
    local hit=New("TextButton",{Size=UDim2.new(1,0,0,40),BackgroundTransparency=1,Text="",ZIndex=11,Parent=f})
    hit.MouseButton1Click:Connect(function()
        open=not open
        if open then
            local h2=math.min(#opts*32+8,200)
            df.Visible=true df.Size=UDim2.new(1,0,0,0)
            Tween(df,0.22,{Size=UDim2.new(1,0,0,h2)}):Play()
            ar.Text="▴"
        else
            ar.Text="▾"
            Tween(df,0.18,{Size=UDim2.new(1,0,0,0)}):Play()
            task.delay(0.2,function() df.Visible=false end)
        end
    end)
    hit.MouseEnter:Connect(function() Tween(f,0.12,{BackgroundTransparency=0.1}):Play() end)
    hit.MouseLeave:Connect(function() Tween(f,0.12,{BackgroundTransparency=0.3}):Play() end)
    function api:Select(v) pick(v) end
    return api
end

local function EKeybind(p,c,th)
    local val=c.Value or Enum.KeyCode.Unknown
    local binding=false
    local f=New("Frame",{Size=UDim2.new(1,0,0,40),BackgroundColor3=th.S2,BackgroundTransparency=0.3,Parent=p},{Corner(8),Stroke(1,th.Br,th.BrT)})
    Pad(0,0,12,12,f)
    New("TextLabel",{Size=UDim2.new(1,-90,1,0),BackgroundTransparency=1,Text=c.Title or"Keybind",TextColor3=th.Tx,TextSize=13,Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
    local kb=New("TextButton",{Size=UDim2.new(0,80,0,26),AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),BackgroundColor3=th.S1,Text=val.Name,TextColor3=th.Accent,TextSize=12,Font=Enum.Font.GothamBold,Parent=f},{Corner(6),Stroke(1,th.Accent,0.6)})
    local api={Value=val}
    kb.MouseButton1Click:Connect(function()
        if binding then return end
        binding=true kb.Text="..." kb.TextColor3=th.Warn
        local conn
        conn=UserInputService.InputBegan:Connect(function(i,gp)
            if gp then return end
            if i.UserInputType==Enum.UserInputType.Keyboard then
                val=i.KeyCode api.Value=val kb.Text=val.Name kb.TextColor3=th.Accent
                binding=false conn:Disconnect() SafeCall(c.Callback,val)
            end
        end)
    end)
    function api:Set(v) val=v api.Value=v kb.Text=v.Name end
    return api
end

local function EColorPicker(p,c,th)
    local val=c.Value or Color3.new(1,0,0)
    local open=false
    local f=New("Frame",{Size=UDim2.new(1,0,0,40),BackgroundColor3=th.S2,BackgroundTransparency=0.3,Parent=p},{Corner(8),Stroke(1,th.Br,th.BrT)})
    Pad(0,0,12,12,f)
    New("TextLabel",{Size=UDim2.new(1,-56,1,0),BackgroundTransparency=1,Text=c.Title or"Color",TextColor3=th.Tx,TextSize=13,Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
    local prev=New("Frame",{Size=UDim2.new(0,44,0,26),AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),BackgroundColor3=val,Parent=f},{Corner(6),Stroke(1,th.Br,0.7)})
    local pk=New("Frame",{Size=UDim2.new(1,0,0,0),Position=UDim2.new(0,0,1,4),BackgroundColor3=th.S1,BackgroundTransparency=0.05,ClipsDescendants=false,ZIndex=30,Visible=false,Parent=f},{Corner(8),Stroke(1,th.Br,th.BrT)})
    local rVal,gVal,bVal=val.R,val.G,val.B
    local rBox,gBox,bBox
    local function updateColor()
        val=Color3.new(rVal,gVal,bVal)
        prev.BackgroundColor3=val SafeCall(c.Callback,val)
    end
    local function makeRow(lbl,ypos,dv,cb)
        local rf=New("Frame",{Size=UDim2.new(1,-16,0,26),Position=UDim2.new(0,8,0,ypos),BackgroundTransparency=1,ZIndex=31,Parent=pk})
        New("TextLabel",{Size=UDim2.new(0,16,1,0),BackgroundTransparency=1,Text=lbl,TextColor3=th.TxS,TextSize=11,Font=Enum.Font.GothamBold,ZIndex=32,Parent=rf})
        local bx=New("TextBox",{Size=UDim2.new(1,-20,1,0),Position=UDim2.new(0,20,0,0),BackgroundColor3=th.S2,BackgroundTransparency=0.3,Text=tostring(math.floor(dv*255)),TextColor3=th.Tx,TextSize=11,Font=Enum.Font.Gotham,ClearTextOnFocus=false,ZIndex=32,Parent=rf},{Corner(4)})
        bx.FocusLost:Connect(function() local v=tonumber(bx.Text) if v then cb(math.clamp(v,0,255)/255) end end)
        return bx
    end
    rBox=makeRow("R",6, val.R, function(v) rVal=v updateColor() end)
    gBox=makeRow("G",36,val.G, function(v) gVal=v updateColor() end)
    bBox=makeRow("B",66,val.B, function(v) bVal=v updateColor() end)
    local hit=New("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=11,Parent=f})
    hit.MouseButton1Click:Connect(function()
        open=not open
        if open then pk.Visible=true pk.Size=UDim2.new(1,0,0,0) Tween(pk,0.22,{Size=UDim2.new(1,0,0,104)}):Play()
        else Tween(pk,0.18,{Size=UDim2.new(1,0,0,0)}):Play() task.delay(0.2,function() pk.Visible=false end) end
    end)
    local api={Value=val}
    function api:Set(col) val=col prev.BackgroundColor3=col rBox.Text=tostring(math.floor(col.R*255)) gBox.Text=tostring(math.floor(col.G*255)) bBox.Text=tostring(math.floor(col.B*255)) rVal,gVal,bVal=col.R,col.G,col.B end
    return api
end

local function EProgressBar(p,c,th)
    local val=math.clamp(c.Value or 0,0,100)
    local f=New("Frame",{Size=UDim2.new(1,0,0,50),BackgroundColor3=th.S2,BackgroundTransparency=0.3,Parent=p},{Corner(8),Stroke(1,th.Br,th.BrT)})
    Pad(8,8,12,12,f)
    local row=New("Frame",{Size=UDim2.new(1,0,0,18),BackgroundTransparency=1,Parent=f})
    New("TextLabel",{Size=UDim2.new(0.7,0,1,0),BackgroundTransparency=1,Text=c.Title or"Progress",TextColor3=th.Tx,TextSize=13,Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Left,Parent=row})
    local pl=New("TextLabel",{Size=UDim2.new(0.3,0,1,0),Position=UDim2.new(0.7,0,0,0),BackgroundTransparency=1,Text=val.."%",TextColor3=th.Accent,TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Right,Parent=row})
    local tr=New("Frame",{Size=UDim2.new(1,0,0,6),AnchorPoint=Vector2.new(0,1),Position=UDim2.new(0,0,1,0),BackgroundColor3=th.S1,Parent=f},{Corner(99)})
    local fl=New("Frame",{Size=UDim2.new(val/100,0,1,0),BackgroundColor3=th.Sli,Parent=tr},{Corner(99)})
    local api={Value=val}
    function api:Set(v,na) v=math.clamp(v,0,100) api.Value=v pl.Text=math.floor(v).."%"
        if na then fl.Size=UDim2.new(v/100,0,1,0) else Tween(fl,0.4,{Size=UDim2.new(v/100,0,1,0)}):Play() end end
    function api:Increment(n) api:Set(api.Value+(n or 1)) end
    function api:Decrement(n) api:Set(api.Value-(n or 1)) end
    return api
end

local function EBadge(p,c,th)
    local f=New("Frame",{Size=UDim2.new(1,0,0,38),BackgroundColor3=th.S2,BackgroundTransparency=0.3,Parent=p},{Corner(8),Stroke(1,th.Br,th.BrT)})
    Pad(0,0,12,12,f)
    New("TextLabel",{Size=UDim2.new(1,-90,1,0),BackgroundTransparency=1,Text=c.Title or"Badge",TextColor3=th.Tx,TextSize=13,Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
    local bc=c.Color and(type(c.Color)=="string" and Hex(c.Color) or c.Color) or th.Accent
    local b=New("Frame",{Size=UDim2.new(0,0,0,22),AutomaticSize=Enum.AutomaticSize.X,AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),BackgroundColor3=bc,BackgroundTransparency=0.1,Parent=f},{Corner(99),Pad(0,0,8,8)})
    local txt=New("TextLabel",{Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,Text=c.Text or"Badge",TextColor3=Color3.new(1,1,1),TextSize=11,Font=Enum.Font.GothamBold,Parent=b})
    local api={}
    function api:SetText(t) txt.Text=t end
    return api
end

local function ENumberInput(p,c,th)
    local val=c.Value or 0
    local mn=c.Min or 0 local mx=c.Max or 100 local st=c.Step or 1
    local f=New("Frame",{Size=UDim2.new(1,0,0,40),BackgroundColor3=th.S2,BackgroundTransparency=0.3,Parent=p},{Corner(8),Stroke(1,th.Br,th.BrT)})
    Pad(0,0,12,12,f)
    New("TextLabel",{Size=UDim2.new(1,-120,1,0),BackgroundTransparency=1,Text=c.Title or"Number",TextColor3=th.Tx,TextSize=13,Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
    local ctrl=New("Frame",{Size=UDim2.new(0,108,0,28),AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),BackgroundColor3=th.S1,BackgroundTransparency=0.3,Parent=f},{Corner(8)})
    local mi=New("TextButton",{Size=UDim2.new(0,28,1,0),BackgroundTransparency=1,Text="−",TextColor3=th.Accent,TextSize=16,Font=Enum.Font.GothamBold,Parent=ctrl})
    local nb=New("TextBox",{Size=UDim2.new(1,-56,1,0),Position=UDim2.new(0,28,0,0),BackgroundTransparency=1,Text=tostring(val),TextColor3=th.Tx,TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Center,ClearTextOnFocus=false,Parent=ctrl})
    local pl=New("TextButton",{Size=UDim2.new(0,28,1,0),Position=UDim2.new(1,-28,0,0),BackgroundTransparency=1,Text="+",TextColor3=th.Accent,TextSize=16,Font=Enum.Font.GothamBold,Parent=ctrl})
    New("Frame",{Size=UDim2.new(0,1,0.6,0),Position=UDim2.new(0,28,0.2,0),BackgroundColor3=th.Br,BackgroundTransparency=0.7,Parent=ctrl})
    New("Frame",{Size=UDim2.new(0,1,0.6,0),Position=UDim2.new(1,-29,0.2,0),BackgroundColor3=th.Br,BackgroundTransparency=0.7,Parent=ctrl})
    local api={Value=val}
    local function upd(v)
        v=math.clamp(math.floor(v/st+0.5)*st,mn,mx)
        val=v api.Value=v nb.Text=tostring(v) SafeCall(c.Callback,v)
    end
    mi.MouseButton1Click:Connect(function() upd(val-st) end)
    pl.MouseButton1Click:Connect(function() upd(val+st) end)
    nb.FocusLost:Connect(function() local v=tonumber(nb.Text) if v then upd(v) else nb.Text=tostring(val) end end)
    function api:Set(v) upd(v) end
    return api
end

local function ERadioGroup(p,c,th)
    local opts=c.Options or {}
    local sel=c.Default or opts[1] or ""
    local cont=New("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Parent=p})
    List(2,cont)
    if c.Title then New("TextLabel",{Size=UDim2.new(1,0,0,22),BackgroundTransparency=1,Text=c.Title,TextColor3=th.TxS,TextSize=11,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=0,Parent=cont}) end
    local btns={}
    local api={Value=sel}
    local function pick(opt)
        sel=opt api.Value=opt
        for o,b in pairs(btns) do
            local on=o==opt
            Tween(b.Ring,0.18,{BackgroundTransparency=on and 0 or 1}):Play()
            Tween(b.Dot,0.15,{Size=on and UDim2.new(0,8,0,8) or UDim2.new(0,0,0,0)}):Play()
            Tween(b.Lbl,0.15,{TextTransparency=on and 0 or 0.45}):Play()
        end
        SafeCall(c.Callback,opt)
    end
    for i,opt in ipairs(opts) do
        local row=New("Frame",{Size=UDim2.new(1,0,0,32),BackgroundColor3=th.S2,BackgroundTransparency=0.5,LayoutOrder=i,Parent=cont},{Corner(6)})
        Pad(0,0,12,12,row)
        local ring=New("Frame",{Size=UDim2.new(0,16,0,16),AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,0,0.5,0),BackgroundColor3=th.Accent,BackgroundTransparency=1,Parent=row},{Corner(99),Stroke(2,th.Accent,0.3)})
        local dot=New("Frame",{Size=UDim2.new(0,0,0,0),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),BackgroundColor3=th.Accent,Parent=ring},{Corner(99)})
        local lbl=New("TextLabel",{Size=UDim2.new(1,-26,1,0),Position=UDim2.new(0,24,0,0),BackgroundTransparency=1,Text=opt,TextColor3=th.Tx,TextSize=13,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,TextTransparency=0.45,Parent=row})
        New("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",Parent=row}).MouseButton1Click:Connect(function() pick(opt) end)
        btns[opt]={Ring=ring,Dot=dot,Lbl=lbl}
    end
    pick(sel)
    function api:Select(v) pick(v) end
    return api
end

local function EMultiToggle(p,c,th)
    local opts=c.Options or {}
    local states={} for _,o in ipairs(opts) do states[o.Text]=o.Value or false end
    local cont=New("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Parent=p})
    List(4,cont)
    if c.Title then New("TextLabel",{Size=UDim2.new(1,0,0,22),BackgroundTransparency=1,Text=c.Title,TextColor3=th.TxS,TextSize=11,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,LayoutOrder=0,Parent=cont}) end
    local brow=New("Frame",{Size=UDim2.new(1,0,0,32),BackgroundTransparency=1,LayoutOrder=1,Parent=cont})
    New("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,4),Parent=brow})
    local count=#opts local objs={}
    local api={States=states}
    local function fire() local r={} for k,v in pairs(states) do r[k]=v end SafeCall(c.Callback,r) end
    for i,opt in ipairs(opts) do
        local on=states[opt.Text]
        local bg=New("Frame",{Size=UDim2.new(1/count,-(4*(count-1)/count),1,0),BackgroundColor3=th.Accent,BackgroundTransparency=on and 0.1 or 0.8,LayoutOrder=i,Parent=brow},{Corner(6)})
        local lbl=New("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text=opt.Text,TextColor3=th.Tx,TextSize=12,Font=Enum.Font.GothamSemibold,TextTransparency=on and 0 or 0.5,Parent=bg})
        New("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",Parent=bg}).MouseButton1Click:Connect(function()
            states[opt.Text]=not states[opt.Text]
            local s=states[opt.Text]
            Tween(bg,0.18,{BackgroundTransparency=s and 0.1 or 0.8}):Play()
            Tween(lbl,0.18,{TextTransparency=s and 0 or 0.5}):Play()
            fire()
        end)
        objs[opt.Text]={Bg=bg,Lbl=lbl}
    end
    function api:SetState(k,v)
        if states[k]~=nil then states[k]=v local o=objs[k]
            if o then Tween(o.Bg,0.18,{BackgroundTransparency=v and 0.1 or 0.8}):Play() Tween(o.Lbl,0.18,{TextTransparency=v and 0 or 0.5}):Play() end fire() end end
    return api
end

local function EAlertBanner(p,c,th)
    local sc={{info={c=th.Accent,i="ℹ"}},{warning={c=th.Warn,i="⚠"}},{error={c=th.Err,i="✕"}},{success={c=th.Ok,i="✓"}}}
    local sm={info={c=th.Accent,i="ℹ"},warning={c=th.Warn,i="⚠"},error={c=th.Err,i="✕"},success={c=th.Ok,i="✓"}}
    local s=sm[c.Type or"info"] or sm.info
    local f=New("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=s.c,BackgroundTransparency=0.8,Parent=p},{Corner(8),Stroke(1,s.c,0.5),Pad(8,8,10,10)})
    New("Frame",{Size=UDim2.new(0,3,1,0),BackgroundColor3=s.c,Parent=f},{Corner(4)})
    local tr=New("Frame",{Size=UDim2.new(1,-12,0,18),Position=UDim2.new(0,12,0,0),BackgroundTransparency=1,Parent=f})
    New("TextLabel",{Size=UDim2.new(0,18,1,0),BackgroundTransparency=1,Text=s.i,TextColor3=s.c,TextSize=14,Font=Enum.Font.GothamBold,Parent=tr})
    New("TextLabel",{Size=UDim2.new(1,-22,1,0),Position=UDim2.new(0,22,0,0),BackgroundTransparency=1,Text=c.Title or"Alert",TextColor3=s.c,TextSize=12,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,Parent=tr})
    if c.Message then New("TextLabel",{Size=UDim2.new(1,-12,0,0),Position=UDim2.new(0,12,0,22),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Text=c.Message,TextColor3=th.Tx,TextSize=11,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,TextTransparency=0.1,Parent=f}) end
    if c.Dismissable then
        local cb=New("TextButton",{Size=UDim2.new(0,18,0,18),Position=UDim2.new(1,-20,0,6),BackgroundTransparency=1,Text="✕",TextColor3=th.TxS,TextSize=11,Font=Enum.Font.GothamBold,ZIndex=5,Parent=f})
        cb.MouseButton1Click:Connect(function() Tween(f,0.2,{BackgroundTransparency=1,Size=UDim2.new(1,0,0,0)}):Play() task.delay(0.25,function() f:Destroy() end) end)
    end
    local api={} function api:Dismiss() Tween(f,0.2,{BackgroundTransparency=1}):Play() task.delay(0.25,function() f:Destroy() end) end
    return api
end

local function EDivider(p,_,th)
    New("Frame",{Size=UDim2.new(1,0,0,1),BackgroundColor3=th.Br,BackgroundTransparency=0.85,Parent=p},{Corner(99)})
    return {}
end

local function ELabel(p,c,th)
    local f=New("Frame",{Size=UDim2.new(1,0,0,30),BackgroundColor3=th.Accent,BackgroundTransparency=0.88,Parent=p},{Corner(6),Pad(0,0,10,10)})
    New("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text=c.Title or"",TextColor3=th.Accent,TextSize=12,Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Left,Parent=f})
    return {}
end

-- ════════════════════════════════════════════
-- Section
-- ════════════════════════════════════════════
local function MakeSec(scrollF, cfg, th)
    local sec = {}

    if cfg.Title then
        local hdr = New("Frame",{Size=UDim2.new(1,0,0,30),BackgroundTransparency=1,Parent=scrollF})
        New("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text=cfg.Title:upper(),TextColor3=th.TxS,TextSize=10,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,LetterSpacing=2,Parent=hdr})
        New("Frame",{Size=UDim2.new(0,22,0,2),Position=UDim2.new(0,0,1,-2),BackgroundColor3=th.Accent,Parent=hdr},{Corner(99)})
    end

    local elF = New("Frame",{Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Parent=scrollF})
    List(4,elF)

    local builders = {
        Toggle=EToggle, Slider=ESlider, Button=EButton, Input=EInput,
        Dropdown=EDropdown, Keybind=EKeybind, ColorPicker=EColorPicker,
        ProgressBar=EProgressBar, Badge=EBadge, NumberInput=ENumberInput,
        RadioGroup=ERadioGroup, MultiToggle=EMultiToggle,
        AlertBanner=EAlertBanner, Divider=EDivider, Label=ELabel,
    }

    for name, fn in pairs(builders) do
        sec[name] = function(self, c2)
            return fn(elF, c2 or {}, th)
        end
    end

    return sec
end

-- ════════════════════════════════════════════
-- Background
-- ════════════════════════════════════════════
local function ApplyBg(frame, bg, th)
    if not bg then return end
    local t = bg.Type or "Color"

    if t == "Color" then
        frame.BackgroundColor3 = bg.Color or th.Bg

    elseif t == "Gradient" then
        frame.BackgroundColor3 = Color3.new(1,1,1)
        local cols = bg.Colors or {"#0d0d14","#1a0a2e"}
        local kps = {}
        for i,h2 in ipairs(cols) do
            kps[#kps+1] = ColorSequenceKeypoint.new((i-1)/(#cols-1), Hex(h2))
        end
        New("UIGradient",{Color=ColorSequence.new(kps),Rotation=bg.Rotation or 135,Parent=frame})

    elseif t == "Image" then
        frame.BackgroundColor3 = th.Bg
        New("ImageLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Image=bg.URL or"",ScaleType=Enum.ScaleType.Crop,ImageTransparency=bg.Transparency or 0,ZIndex=0,Parent=frame})

    elseif t == "Video" then
        frame.BackgroundColor3 = Color3.new(0,0,0)
        local vid = New("VideoFrame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Video=bg.URL or"",ZIndex=0,Parent=frame})
        vid.Looped = true
        pcall(function() vid:Play() end)
        -- dim overlay
        New("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=bg.DimTransparency or 0.4,ZIndex=1,Parent=frame})
    end
end

-- ════════════════════════════════════════════
-- NexusUI
-- ════════════════════════════════════════════
local NexusUI = {}
NexusUI.__index = NexusUI

function NexusUI:CreateWindow(cfg)
    cfg = cfg or {}
    local th = T[cfg.Theme] or T.Midnight
    local wsz = cfg.Size or UDim2.fromOffset(640, 490)
    local vp  = workspace.CurrentCamera.ViewportSize

    -- ScreenGui
    local gui = New("ScreenGui",{
        Name = "NexusUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = pcall(function() return CoreGui end) and CoreGui or LocalPlayer.PlayerGui,
    })

    -- Main frame
    local main = New("Frame",{
        Size = wsz,
        Position = UDim2.fromOffset((vp.X-wsz.X.Offset)/2, (vp.Y-wsz.Y.Offset)/2),
        BackgroundColor3 = th.Bg,
        BackgroundTransparency = cfg.Transparent and 0.06 or 0,
        ClipsDescendants = true,
        Parent = gui,
    },{Corner(14)})

    -- Outer glow/shadow
    New("ImageLabel",{
        Size=UDim2.new(1,60,1,60),Position=UDim2.new(0,-30,0,-30),
        BackgroundTransparency=1,
        Image="rbxassetid://6015897843",
        ImageColor3=th.Accent,
        ImageTransparency=0.7,
        ScaleType=Enum.ScaleType.Slice,
        SliceCenter=Rect.new(49,49,450,450),
        ZIndex=0,Parent=main
    })

    -- Background layer
    local bgF = New("Frame",{
        Size=UDim2.new(1,0,1,0),
        BackgroundColor3=th.Bg,
        ZIndex=1,ClipsDescendants=true,
        Parent=main,
    },{Corner(14)})
    ApplyBg(bgF, cfg.Background, th)

    -- Glass overlay
    if cfg.Blur or cfg.Transparent then
        New("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=th.Bg,BackgroundTransparency=0.68,ZIndex=2,Parent=main})
    end

    -- Top accent line (animated glow)
    local topLine = New("Frame",{Size=UDim2.new(1,0,0,2),BackgroundColor3=th.Accent,ZIndex=10,Parent=main},{Corner(99)})
    New("UIGradient",{Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,th.Bg),
        ColorSequenceKeypoint.new(0.3,th.Accent),
        ColorSequenceKeypoint.new(0.7,th.AccentH),
        ColorSequenceKeypoint.new(1,th.Bg),
    }),Parent=topLine})

    -- Sidebar
    local sb = New("Frame",{
        Size=UDim2.new(0,185,1,0),
        BackgroundColor3=th.SB,
        BackgroundTransparency=cfg.Transparent and 0.25 or 0,
        ZIndex=5,Parent=main,
    })
    Pad(58,10,6,6,sb)
    List(2,sb)

    -- Sidebar right border
    New("Frame",{Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,0,0,0),BackgroundColor3=th.Br,BackgroundTransparency=0.88,ZIndex=6,Parent=main})

    -- Logo area in sidebar (top)
    local logoArea = New("Frame",{
        Size=UDim2.new(1,0,0,50),
        Position=UDim2.new(0,0,0,0),
        BackgroundTransparency=1,
        ZIndex=6,Parent=main,
    })
    Pad(0,0,12,0,logoArea)

    if cfg.Icon then
        New("ImageLabel",{
            Size=UDim2.new(0,26,0,26),
            AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,0,0.5,0),
            BackgroundTransparency=1,Image=cfg.Icon,ZIndex=7,Parent=logoArea
        },{Corner(6)})
    end

    New("TextLabel",{
        Size=UDim2.new(1,cfg.Icon and -34 or 0,0,20),
        Position=UDim2.new(0,cfg.Icon and 32 or 0,0,8),
        BackgroundTransparency=1,Text=cfg.Title or"NexusUI",
        TextColor3=th.Tx,TextSize=14,Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left,ZIndex=7,Parent=logoArea
    })

    if cfg.SubTitle then
        New("TextLabel",{
            Size=UDim2.new(1,0,0,14),
            Position=UDim2.new(0,cfg.Icon and 32 or 0,0,28),
            BackgroundTransparency=1,Text=cfg.SubTitle,
            TextColor3=th.TxS,TextSize=11,Font=Enum.Font.Gotham,
            TextXAlignment=Enum.TextXAlignment.Left,ZIndex=7,Parent=logoArea
        })
    end

    -- Topbar (thin, just window controls)
    local topbar = New("Frame",{
        Size=UDim2.new(1,0,0,50),
        BackgroundColor3=th.SB,
        BackgroundTransparency=cfg.Transparent and 0.6 or 0.1,
        ZIndex=6,Parent=main,
    })

    -- Bottom border topbar
    New("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),BackgroundColor3=th.Br,BackgroundTransparency=0.9,ZIndex=7,Parent=topbar})

    -- Window controls (close, minimize)
    local closeBtn = New("TextButton",{
        Size=UDim2.new(0,24,0,24),AnchorPoint=Vector2.new(1,0.5),
        Position=UDim2.new(1,-12,0.5,0),
        BackgroundColor3=th.Err,BackgroundTransparency=0.45,
        Text="",ZIndex=9,Parent=topbar,
    },{Corner(99)})
    New("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="✕",TextColor3=Color3.new(1,1,1),TextSize=11,Font=Enum.Font.GothamBold,Parent=closeBtn})

    local minBtn = New("TextButton",{
        Size=UDim2.new(0,24,0,24),AnchorPoint=Vector2.new(1,0.5),
        Position=UDim2.new(1,-42,0.5,0),
        BackgroundColor3=th.Warn,BackgroundTransparency=0.55,
        Text="",ZIndex=9,Parent=topbar,
    },{Corner(99)})
    New("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="−",TextColor3=Color3.new(1,1,1),TextSize=13,Font=Enum.Font.GothamBold,Parent=minBtn})

    closeBtn.MouseEnter:Connect(function() Tween(closeBtn,0.12,{BackgroundTransparency=0}):Play() end)
    closeBtn.MouseLeave:Connect(function() Tween(closeBtn,0.12,{BackgroundTransparency=0.45}):Play() end)
    closeBtn.MouseButton1Click:Connect(function()
        Tween(main,0.25,{BackgroundTransparency=1,Size=UDim2.new(wsz.X.Scale,wsz.X.Offset,0,0)}):Play()
        task.delay(0.28, function() gui:Destroy() end)
    end)

    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        Tween(main,0.3,{Size=minimized and UDim2.new(wsz.X.Scale,wsz.X.Offset,0,50) or wsz}):Play()
    end)

    -- Content area
    local contentArea = New("Frame",{
        Size=UDim2.new(1,-185,1,-50),
        Position=UDim2.new(0,185,0,50),
        BackgroundTransparency=1,
        ClipsDescendants=true,
        ZIndex=5,Parent=main,
    })

    -- Drag
    local dragging,ds,dp=false,nil,nil
    topbar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true ds=i.Position dp=main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-ds
            main.Position=UDim2.new(dp.X.Scale,dp.X.Offset+d.X,dp.Y.Scale,dp.Y.Offset+d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
    end)

    -- ToggleKey
    if cfg.ToggleKey then
        UserInputService.InputBegan:Connect(function(i,gp)
            if gp then return end
            if i.KeyCode==cfg.ToggleKey then main.Visible=not main.Visible end
        end)
    end

    -- Entrance animation
    main.BackgroundTransparency=1
    main.Position=UDim2.fromOffset((vp.X-wsz.X.Offset)/2,(vp.Y-wsz.Y.Offset)/2+18)
    task.spawn(function()
        Tween(main,0.38,{
            BackgroundTransparency=cfg.Transparent and 0.06 or 0,
            Position=UDim2.fromOffset((vp.X-wsz.X.Offset)/2,(vp.Y-wsz.Y.Offset)/2)
        }):Play()
    end)

    -- ── Tab System ──────────────────────────────────────────
    local tabs = {}
    local activeIdx = nil
    local tabCount = 0

    local winAPI = {}

    function winAPI:Tab(tabCfg)
        tabCfg = tabCfg or {}
        tabCount = tabCount + 1
        local idx = tabCount

        -- sidebar button
        local btn = New("Frame",{
            Size=UDim2.new(1,0,0,38),
            BackgroundColor3=th.TA,
            BackgroundTransparency=1,
            LayoutOrder=idx,Parent=sb,
        },{Corner(9)})
        Pad(0,0,8,8,btn)

        local indicator = New("Frame",{
            Size=UDim2.new(0,3,0,20),AnchorPoint=Vector2.new(0,0.5),
            Position=UDim2.new(0,-6,0.5,0),
            BackgroundColor3=th.TA,BackgroundTransparency=1,
            Parent=btn,
        },{Corner(99)})

        local icoLbl = New("TextLabel",{
            Size=UDim2.new(0,22,1,0),BackgroundTransparency=1,
            Text=Ico(tabCfg.Icon or ""),
            TextColor3=th.TT,TextSize=15,Font=Enum.Font.GothamBold,
            Parent=btn,
        })

        local tabLbl = New("TextLabel",{
            Size=UDim2.new(1,-30,1,0),Position=UDim2.new(0,28,0,0),
            BackgroundTransparency=1,Text=tabCfg.Title or"Tab",
            TextColor3=th.TT,TextSize=13,Font=Enum.Font.GothamSemibold,
            TextXAlignment=Enum.TextXAlignment.Left,Parent=btn,
        })

        -- scroll for content
        local scroll = New("ScrollingFrame",{
            Size=UDim2.new(1,0,1,0),
            BackgroundTransparency=1,
            ScrollBarThickness=3,
            ScrollBarImageColor3=th.Accent,
            ScrollBarImageTransparency=0.5,
            CanvasSize=UDim2.new(0,0,0,0),
            AutomaticCanvasSize=Enum.AutomaticSize.Y,
            Visible=false,ZIndex=5,Parent=contentArea,
        })
        Pad(12,12,14,14,scroll)
        List(6,scroll)

        local hit = New("TextButton",{
            Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",Parent=btn,
        })

        local function activate()
            for _,t in ipairs(tabs) do
                t.scroll.Visible=false
                Tween(t.btn,0.18,{BackgroundTransparency=1}):Play()
                Tween(t.ico,0.18,{TextColor3=th.TT}):Play()
                Tween(t.lbl,0.18,{TextColor3=th.TT}):Play()
                Tween(t.ind,0.18,{BackgroundTransparency=1}):Play()
            end
            scroll.Visible=true
            Tween(btn,0.18,{BackgroundTransparency=0.9}):Play()
            Tween(icoLbl,0.18,{TextColor3=th.TTA}):Play()
            Tween(tabLbl,0.18,{TextColor3=th.TTA}):Play()
            Tween(indicator,0.18,{BackgroundTransparency=0}):Play()
            activeIdx=idx
        end

        hit.MouseButton1Click:Connect(activate)
        hit.MouseEnter:Connect(function() if activeIdx~=idx then Tween(btn,0.12,{BackgroundTransparency=0.95}):Play() end end)
        hit.MouseLeave:Connect(function() if activeIdx~=idx then Tween(btn,0.12,{BackgroundTransparency=1}):Play() end end)

        local tabObj={btn=btn,ico=icoLbl,lbl=tabLbl,scroll=scroll,ind=indicator}
        table.insert(tabs,tabObj)

        if #tabs==1 then activate() end

        local tabAPI = {}
        function tabAPI:Section(sc2)
            return MakeSec(scroll, sc2 or {}, th)
        end
        -- shorthand: direct elements without section wrapper
        local ds2 = MakeSec(scroll, {}, th)
        for k,v in pairs(ds2) do tabAPI[k]=v end
        return tabAPI
    end

    function winAPI:Toggle()
        main.Visible = not main.Visible
    end

    function winAPI:Destroy()
        gui:Destroy()
    end

    function winAPI:Notify(nc)
        NexusUI:Notify(nc)
    end

    return winAPI
end

-- ════════════════════════════════════════════
-- Notify
-- ════════════════════════════════════════════
function NexusUI:Notify(cfg)
    cfg = cfg or {}
    local th = T[cfg.Theme or "Midnight"]

    local ok, guiTarget = pcall(function() return CoreGui end)
    local gui = New("ScreenGui",{
        Name="NexusUI_Notify",ResetOnSpawn=false,
        Parent = ok and guiTarget or LocalPlayer.PlayerGui,
    })

    local f = New("Frame",{
        Size=UDim2.new(0,290,0,0),AutomaticSize=Enum.AutomaticSize.Y,
        Position=UDim2.new(1,-306,1,20),AnchorPoint=Vector2.new(0,1),
        BackgroundColor3=th.S1,BackgroundTransparency=0.05,
        Parent=gui,
    },{Corner(10),Stroke(1,th.Accent,0.55),Pad(12,12,14,14)})

    -- top accent
    New("Frame",{Size=UDim2.new(1,0,0,2),BackgroundColor3=th.Accent,Parent=f},{Corner(99)})

    New("TextLabel",{Size=UDim2.new(1,0,0,18),Position=UDim2.new(0,0,0,8),BackgroundTransparency=1,Text=cfg.Title or"Notification",TextColor3=th.Accent,TextSize=13,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,Parent=f})

    if cfg.Content then
        New("TextLabel",{Size=UDim2.new(1,0,0,0),Position=UDim2.new(0,0,0,30),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Text=cfg.Content,TextColor3=th.Tx,TextSize=12,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,TextTransparency=0.1,Parent=f})
    end

    Tween(f,0.32,{Position=UDim2.new(1,-306,1,-16)}):Play()

    task.delay(cfg.Duration or 5,function()
        Tween(f,0.28,{Position=UDim2.new(1,8,1,-16),BackgroundTransparency=1}):Play()
        task.delay(0.32,function() gui:Destroy() end)
    end)
end

-- ════════════════════════════════════════════
-- Utils
-- ════════════════════════════════════════════
function NexusUI:GetThemes()
    local r={} for k in pairs(T) do r[#r+1]=k end return r
end

print("\n  ╔══════════════════════════════╗")
print("  ║  NexusUI v1.0  —  Loaded ✓  ║")
print("  ║  Themes: Midnight Neon       ║")
print("  ║         Ocean Sakura         ║")
print("  ║         Crimson Gold         ║")
print("  ╚══════════════════════════════╝\n")

return NexusUI
