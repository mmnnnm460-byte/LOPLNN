--[[
    ForgeUI - Professional Roblox UI Library
    ------------------------------------------------
    عناصر المكتبة: Window, Tab, Section, Button, Toggle, Slider,
    Dropdown, Input, Keybind, ColorPicker, Label, Paragraph, Notify,
    SaveConfig/LoadConfig

    مثال استخدام سريع:

    local ForgeUI = loadstring(readfile("ForgeUI.lua"))()

    local Window = ForgeUI:CreateWindow({
        Title = "My Hub",
        SubTitle = "v1.0",
        Size = UDim2.fromOffset(580, 420),
        ConfigFolder = "MyHubConfig",
        ToggleKeybind = Enum.KeyCode.RightControl,
        -- Theme = { Accent = Color3.fromRGB(255, 90, 90) }, -- اختياري: تخصيص الألوان
    })

    local Tab = Window:CreateTab("Main")
    local Section = Tab:CreateSection("General")

    Section:CreateButton({ Name = "Click Me", Callback = function() end })
    Section:CreateToggle({ Name = "Toggle", Default = false, Flag = "MyToggle", Callback = function(v) end })
    Section:CreateSlider({ Name = "Speed", Min = 0, Max = 100, Default = 50, Flag = "Speed", Callback = function(v) end })
    Section:CreateDropdown({ Name = "Mode", Options = {"A","B","C"}, Default = "A", Flag = "Mode", Callback = function(v) end })
    Section:CreateInput({ Name = "Text", PlaceholderText = "اكتب هنا...", Flag = "TextIn", Callback = function(v) end })
    Section:CreateKeybind({ Name = "Keybind", Default = Enum.KeyCode.E, Flag = "MyKey", Callback = function() end })
    Section:CreateColorPicker({ Name = "Color", Default = Color3.fromRGB(255,0,0), Flag = "MyColor", Callback = function(c) end })
    Section:CreateLabel("نص توضيحي بسيط")
    Section:CreateDivider()
    Section:CreateParagraph({ Title = "معلومة", Content = "نص أطول يشرح شي معين هنا." })

    ForgeUI:Notify({ Title = "تم", Content = "تم الحفظ بنجاح", Type = "Success", Duration = 4 })
    -- Type: "Info" (افتراضي) / "Success" / "Warning" / "Error"

    Window:SaveConfig()   -- يحفظ كل الـ Flags في ملف JSON
    Window:LoadConfig()   -- يرجع القيم المحفوظة (طبقها بنفسك على العناصر عبر :Set إذا لزم)
--]]

local ForgeUI = {}

-- ===== Services =====
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- ===== Theme =====
local Theme = {
    Background = Color3.fromRGB(22, 22, 26),
    Container  = Color3.fromRGB(30, 30, 35),
    Elevated   = Color3.fromRGB(40, 40, 47),
    Stroke     = Color3.fromRGB(54, 54, 62),
    Accent     = Color3.fromRGB(120, 130, 255),
    Text       = Color3.fromRGB(240, 240, 245),
    SubText    = Color3.fromRGB(150, 150, 160),
    Font       = Enum.Font.GothamMedium,
    FontBold   = Enum.Font.GothamBold,
}

-- ===== Utilities =====
local function New(className, props)
    local inst = Instance.new(className)
    if inst:IsA("GuiObject") then
        inst.BorderSizePixel = 0
    end
    if className == "TextButton" then
        inst.AutoButtonColor = false
    end
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    return inst
end

local function Tween(obj, props, duration, style, direction)
    local info = TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
    local tw = TweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

local function MakeDraggable(dragHandle, target)
    local dragging = false
    local dragStart, startPos

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function ProtectGui(gui)
    if syn and syn.protect_gui then
        syn.protect_gui(gui)
        gui.Parent = game:GetService("CoreGui")
    elseif gethui then
        gui.Parent = gethui()
    else
        gui.Parent = game:GetService("CoreGui")
    end
end

-- ===== Notifications =====
local NotifHolder

local function InitNotifications(screenGui)
    NotifHolder = New("Frame", {
        Name = "Notifications",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -16, 1, -16),
        Size = UDim2.new(0, 300, 1, -32),
        Parent = screenGui,
    })
    New("UIListLayout", {
        Parent = NotifHolder,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
end

local NotifColors = {
    Info = Theme.Accent,
    Success = Color3.fromRGB(90, 200, 130),
    Warning = Color3.fromRGB(230, 180, 70),
    Error = Color3.fromRGB(230, 90, 90),
}

function ForgeUI:Notify(config)
    config = config or {}
    local title = config.Title or "Notification"
    local content = config.Content or ""
    local duration = config.Duration or 4
    local barColor = NotifColors[config.Type] or Theme.Accent

    if not NotifHolder then return end

    local card = New("Frame", {
        BackgroundColor3 = Theme.Elevated,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true,
        Parent = NotifHolder,
    })
    New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = card })
    New("UIStroke", { Color = Theme.Stroke, Thickness = 1, Parent = card })
    New("UIPadding", {
        PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 12),
        Parent = card,
    })
    local accent = New("Frame", {
        BackgroundColor3 = barColor,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 3, 1, 0),
        Parent = card,
    })
    New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = accent })

    local titleLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 6, 0, 0),
        Size = UDim2.new(1, -6, 0, 18),
        Font = Theme.FontBold,
        Text = title,
        TextColor3 = Theme.Text,
        TextTransparency = 1,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = card,
    })
    local contentLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 6, 0, 20),
        Size = UDim2.new(1, -6, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Font = Theme.Font,
        Text = content,
        TextColor3 = Theme.SubText,
        TextTransparency = 1,
        TextSize = 13,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = card,
    })

    Tween(card, { BackgroundTransparency = 0 }, 0.25)
    Tween(accent, { BackgroundTransparency = 0 }, 0.25)
    Tween(titleLabel, { TextTransparency = 0 }, 0.25)
    Tween(contentLabel, { TextTransparency = 0 }, 0.25)

    task.delay(duration, function()
        Tween(card, { BackgroundTransparency = 1 }, 0.25)
        Tween(accent, { BackgroundTransparency = 1 }, 0.25)
        Tween(titleLabel, { TextTransparency = 1 }, 0.25)
        Tween(contentLabel, { TextTransparency = 1 }, 0.25)
        task.wait(0.3)
        card:Destroy()
    end)
end

-- ===== Window =====
function ForgeUI:CreateWindow(config)
    config = config or {}
    local title = config.Title or "ForgeUI"
    local subtitle = config.SubTitle or ""
    local size = config.Size or UDim2.fromOffset(560, 400)
    local configFolder = config.ConfigFolder or "ForgeUI"
    local toggleKey = config.ToggleKeybind or Enum.KeyCode.RightControl

    if config.Theme then
        for k, v in pairs(config.Theme) do
            Theme[k] = v
        end
    end

    local ScreenGui = New("ScreenGui", {
        Name = "ForgeUI_" .. HttpService:GenerateGUID(false),
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999,
    })
    ProtectGui(ScreenGui)
    InitNotifications(ScreenGui)

    local Shadow = New("Frame", {
        Name = "Shadow",
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.55,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 4),
        Size = UDim2.new(size.X.Scale, size.X.Offset + 10, size.Y.Scale, size.Y.Offset + 10),
        Parent = ScreenGui,
    })
    New("UICorner", { CornerRadius = UDim.new(0, 14), Parent = Shadow })

    local Main = New("Frame", {
        Name = "Main",
        BackgroundColor3 = Theme.Background,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(size.X.Scale, 0, size.Y.Scale, 0),
        ClipsDescendants = true,
        Parent = ScreenGui,
    })
    New("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Main })
    New("UIStroke", { Color = Theme.Stroke, Thickness = 1, Parent = Main })

    local TopBar = New("Frame", {
        Name = "TopBar",
        BackgroundColor3 = Theme.Container,
        Size = UDim2.new(1, 0, 0, 44),
        Parent = Main,
    })
    New("UICorner", { CornerRadius = UDim.new(0, 10), Parent = TopBar })
    New("Frame", {
        BackgroundColor3 = Theme.Container,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -10),
        Size = UDim2.new(1, 0, 0, 10),
        Parent = TopBar,
    })
    New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0, 5),
        Size = UDim2.new(1, -60, 0, 20),
        Font = Theme.FontBold,
        Text = title,
        TextColor3 = Theme.Text,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar,
    })
    New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0, 23),
        Size = UDim2.new(1, -60, 0, 16),
        Font = Theme.Font,
        Text = subtitle,
        TextColor3 = Theme.SubText,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar,
    })
    local CloseBtn = New("TextButton", {
        BackgroundColor3 = Theme.Elevated,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.new(0, 26, 0, 26),
        Font = Theme.FontBold,
        Text = "X",
        TextColor3 = Theme.SubText,
        TextSize = 13,
        Parent = TopBar,
    })
    New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = CloseBtn })
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui.Enabled = false
    end)

    MakeDraggable(TopBar, Main)

    local TabBar = New("Frame", {
        Name = "TabBar",
        BackgroundColor3 = Theme.Container,
        Position = UDim2.new(0, 0, 0, 44),
        Size = UDim2.new(0, 130, 1, -44),
        Parent = Main,
    })
    New("UIListLayout", {
        Parent = TabBar,
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    New("UIPadding", {
        PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8),
        Parent = TabBar,
    })

    local PageHolder = New("Frame", {
        Name = "Pages",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 130, 0, 44),
        Size = UDim2.new(1, -130, 1, -44),
        Parent = Main,
    })

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == toggleKey then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    local Window = {}
    Window.ScreenGui = ScreenGui
    Window.Tabs = {}
    Window.Flags = {}
    Window.ConfigFolder = configFolder
    local firstTab = true

    function Window:CreateTab(name)
        local TabButton = New("TextButton", {
            BackgroundColor3 = Theme.Elevated,
            BackgroundTransparency = firstTab and 0 or 1,
            Size = UDim2.new(1, 0, 0, 32),
            Font = firstTab and Theme.FontBold or Theme.Font,
            Text = name,
            TextColor3 = firstTab and Theme.Text or Theme.SubText,
            TextSize = 13,
            Parent = TabBar,
        })
        New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = TabButton })

        local Page = New("ScrollingFrame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            Visible = firstTab,
            Parent = PageHolder,
        })
        New("UIListLayout", {
            Parent = Page,
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })
        New("UIPadding", {
            PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12),
            PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12),
            Parent = Page,
        })

        firstTab = false

        local Tab = { Button = TabButton, Page = Page }
        table.insert(Window.Tabs, Tab)

        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(Window.Tabs) do
                t.Page.Visible = false
                t.Button.Font = Theme.Font
                Tween(t.Button, { BackgroundTransparency = 1, TextColor3 = Theme.SubText }, 0.15)
            end
            Page.Visible = true
            TabButton.Font = Theme.FontBold
            Tween(TabButton, { BackgroundTransparency = 0, TextColor3 = Theme.Text }, 0.15)
        end)

        function Tab:CreateSection(sectionName)
            local Section = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = Page,
            })
            New("UIListLayout", {
                Parent = Section,
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder,
            })
            if sectionName then
                New("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 18),
                    Font = Theme.FontBold,
                    Text = sectionName,
                    TextColor3 = Theme.SubText,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Section,
                })
            end

            local SectionObj = {}

            local function BaseCard(height)
                local Card = New("Frame", {
                    BackgroundColor3 = Theme.Container,
                    Size = UDim2.new(1, 0, 0, height or 38),
                    Parent = Section,
                })
                New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Card })
                New("UIStroke", { Color = Theme.Stroke, Thickness = 1, Parent = Card })
                return Card
            end

            -- Hover highlight: wire on the topmost interactive control since it
            -- fully covers the card and would otherwise swallow the hover events.
            local function AttachHover(control, card)
                control.MouseEnter:Connect(function()
                    Tween(card, { BackgroundColor3 = Theme.Elevated }, 0.15)
                end)
                control.MouseLeave:Connect(function()
                    Tween(card, { BackgroundColor3 = Theme.Container }, 0.15)
                end)
            end

            function SectionObj:CreateButton(cfg)
                cfg = cfg or {}
                local Card = BaseCard(38)
                local Btn = New("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Theme.Font,
                    Text = cfg.Name or "Button",
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    Parent = Card,
                })
                Btn.MouseButton1Click:Connect(function()
                    Tween(Card, { BackgroundColor3 = Theme.Accent }, 0.1)
                    task.wait(0.1)
                    Tween(Card, { BackgroundColor3 = Theme.Container }, 0.15)
                    if cfg.Callback then cfg.Callback() end
                end)
                AttachHover(Btn, Card)
                return Btn
            end

            function SectionObj:CreateToggle(cfg)
                cfg = cfg or {}
                local state = cfg.Default or false
                local Card = BaseCard(38)
                New("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(1, -60, 1, 0),
                    Font = Theme.Font,
                    Text = cfg.Name or "Toggle",
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Card,
                })
                local Switch = New("Frame", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -12, 0.5, 0),
                    Size = UDim2.new(0, 38, 0, 20),
                    BackgroundColor3 = state and Theme.Accent or Theme.Elevated,
                    Parent = Card,
                })
                New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Switch })
                local Dot = New("Frame", {
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = Switch,
                })
                New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Dot })
                local Click = New("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    Parent = Card,
                })
                Click.MouseButton1Click:Connect(function()
                    state = not state
                    Tween(Switch, { BackgroundColor3 = state and Theme.Accent or Theme.Elevated }, 0.15)
                    Tween(Dot, { Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8) }, 0.15)
                    if cfg.Flag then Window.Flags[cfg.Flag] = state end
                    if cfg.Callback then cfg.Callback(state) end
                end)
                AttachHover(Click, Card)
                if cfg.Flag then Window.Flags[cfg.Flag] = state end
                return {
                    Set = function(_, v)
                        state = v
                        Switch.BackgroundColor3 = state and Theme.Accent or Theme.Elevated
                        Dot.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    end
                }
            end

            function SectionObj:CreateSlider(cfg)
                cfg = cfg or {}
                local min = cfg.Min or 0
                local max = cfg.Max or 100
                local value = cfg.Default or min
                local Card = BaseCard(46)
                New("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 4),
                    Size = UDim2.new(1, -70, 0, 16),
                    Font = Theme.Font,
                    Text = cfg.Name or "Slider",
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Card,
                })
                local ValueLabel = New("TextLabel", {
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -12, 0, 4),
                    Size = UDim2.new(0, 50, 0, 16),
                    Font = Theme.Font,
                    Text = tostring(value),
                    TextColor3 = Theme.SubText,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = Card,
                })
                local Track = New("Frame", {
                    Position = UDim2.new(0, 12, 0, 28),
                    Size = UDim2.new(1, -24, 0, 6),
                    BackgroundColor3 = Theme.Elevated,
                    Parent = Card,
                })
                New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Track })
                local Fill = New("Frame", {
                    Active = false,
                    Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
                    BackgroundColor3 = Theme.Accent,
                    Parent = Track,
                })
                New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Fill })

                local dragging = false
                local function updateFromInput(input)
                    local rel = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                    value = math.floor(min + (max - min) * rel)
                    Fill.Size = UDim2.new(rel, 0, 1, 0)
                    ValueLabel.Text = tostring(value)
                    if cfg.Flag then Window.Flags[cfg.Flag] = value end
                    if cfg.Callback then cfg.Callback(value) end
                end
                Track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        updateFromInput(input)
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        updateFromInput(input)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                if cfg.Flag then Window.Flags[cfg.Flag] = value end
            end

            function SectionObj:CreateDropdown(cfg)
                cfg = cfg or {}
                local options = cfg.Options or {}
                local selected = cfg.Default or options[1]
                local open = false
                local Card = BaseCard(38)
                New("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Font = Theme.Font,
                    Text = cfg.Name or "Dropdown",
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Card,
                })
                local SelectedLabel = New("TextLabel", {
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -30, 0.5, 0),
                    Size = UDim2.new(0.4, 0, 0, 18),
                    Font = Theme.Font,
                    Text = tostring(selected or ""),
                    TextColor3 = Theme.SubText,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = Card,
                })
                local OpenBtn = New("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    Parent = Card,
                })
                local ListFrame = New("Frame", {
                    BackgroundColor3 = Theme.Elevated,
                    Position = UDim2.new(0, 0, 1, 4),
                    Size = UDim2.new(1, 0, 0, 0),
                    ClipsDescendants = true,
                    ZIndex = 5,
                    Parent = Card,
                })
                New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = ListFrame })
                New("UIStroke", { Color = Theme.Stroke, Thickness = 1, Parent = ListFrame })
                New("UIListLayout", { Parent = ListFrame, SortOrder = Enum.SortOrder.LayoutOrder })

                for _, opt in ipairs(options) do
                    local OptBtn = New("TextButton", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 26),
                        Font = Theme.Font,
                        Text = tostring(opt),
                        TextColor3 = Theme.Text,
                        TextSize = 12,
                        ZIndex = 6,
                        Parent = ListFrame,
                    })
                    OptBtn.MouseButton1Click:Connect(function()
                        selected = opt
                        SelectedLabel.Text = tostring(opt)
                        open = false
                        Tween(ListFrame, { Size = UDim2.new(1, 0, 0, 0) }, 0.15)
                        if cfg.Flag then Window.Flags[cfg.Flag] = opt end
                        if cfg.Callback then cfg.Callback(opt) end
                    end)
                end
                OpenBtn.MouseButton1Click:Connect(function()
                    open = not open
                    local h = #options * 26
                    Tween(ListFrame, { Size = UDim2.new(1, 0, 0, open and h or 0) }, 0.15)
                end)
                AttachHover(OpenBtn, Card)
                if cfg.Flag then Window.Flags[cfg.Flag] = selected end
            end

            function SectionObj:CreateInput(cfg)
                cfg = cfg or {}
                local Card = BaseCard(38)
                New("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(0.4, 0, 1, 0),
                    Font = Theme.Font,
                    Text = cfg.Name or "Input",
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Card,
                })
                local Box = New("TextBox", {
                    BackgroundColor3 = Theme.Elevated,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0.5, 0, 0, 26),
                    Font = Theme.Font,
                    PlaceholderText = cfg.PlaceholderText or "",
                    Text = cfg.Default or "",
                    TextColor3 = Theme.Text,
                    TextSize = 12,
                    ClearTextOnFocus = false,
                    Parent = Card,
                })
                New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Box })
                New("UIPadding", { PaddingLeft = UDim.new(0, 8), Parent = Box })
                Box.FocusLost:Connect(function()
                    if cfg.Flag then Window.Flags[cfg.Flag] = Box.Text end
                    if cfg.Callback then cfg.Callback(Box.Text) end
                end)
                if cfg.Flag then Window.Flags[cfg.Flag] = Box.Text end
            end

            function SectionObj:CreateKeybind(cfg)
                cfg = cfg or {}
                local bound = cfg.Default or Enum.KeyCode.Unknown
                local listening = false
                local Card = BaseCard(38)
                local function KeyText()
                    return bound == Enum.KeyCode.Unknown and "None" or bound.Name
                end
                New("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Font = Theme.Font,
                    Text = cfg.Name or "Keybind",
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Card,
                })
                local KeyBtn = New("TextButton", {
                    BackgroundColor3 = Theme.Elevated,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 80, 0, 26),
                    Font = Theme.Font,
                    Text = KeyText(),
                    TextColor3 = Theme.Text,
                    TextSize = 12,
                    Parent = Card,
                })
                New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = KeyBtn })
                KeyBtn.MouseButton1Click:Connect(function()
                    listening = true
                    KeyBtn.Text = "..."
                end)
                UserInputService.InputBegan:Connect(function(input, gpe)
                    if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                        bound = input.KeyCode
                        KeyBtn.Text = KeyText()
                        listening = false
                        if cfg.Flag then Window.Flags[cfg.Flag] = bound end
                    elseif not listening and not gpe and input.KeyCode == bound then
                        if cfg.Callback then cfg.Callback() end
                    end
                end)
                AttachHover(KeyBtn, Card)
                if cfg.Flag then Window.Flags[cfg.Flag] = bound end
            end

            function SectionObj:CreateColorPicker(cfg)
                cfg = cfg or {}
                local color = cfg.Default or Color3.fromRGB(255, 255, 255)
                local Card = BaseCard(38)
                New("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(0.6, 0, 1, 0),
                    Font = Theme.Font,
                    Text = cfg.Name or "Color",
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Card,
                })
                local Swatch = New("TextButton", {
                    BackgroundColor3 = color,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 26, 0, 26),
                    Text = "",
                    Parent = Card,
                })
                New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Swatch })
                New("UIStroke", { Color = Theme.Stroke, Thickness = 1, Parent = Swatch })

                local Popup = New("Frame", {
                    BackgroundColor3 = Theme.Elevated,
                    Position = UDim2.new(0, 0, 1, 4),
                    Size = UDim2.new(1, 0, 0, 0),
                    ClipsDescendants = true,
                    ZIndex = 5,
                    Parent = Card,
                })
                New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Popup })
                New("UIPadding", {
                    PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10),
                    Parent = Popup,
                })
                New("UIListLayout", { Parent = Popup, Padding = UDim.new(0, 6) })

                local r = math.floor(color.R * 255)
                local g = math.floor(color.G * 255)
                local b = math.floor(color.B * 255)

                local function updateColor()
                    color = Color3.fromRGB(r, g, b)
                    Swatch.BackgroundColor3 = color
                    if cfg.Flag then Window.Flags[cfg.Flag] = color end
                    if cfg.Callback then cfg.Callback(color) end
                end

                local function channelSlider(labelText, initial, onChange)
                    local Row = New("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18), Parent = Popup })
                    New("TextLabel", {
                        BackgroundTransparency = 1, Size = UDim2.new(0, 16, 1, 0),
                        Font = Theme.Font, Text = labelText, TextColor3 = Theme.SubText, TextSize = 11, Parent = Row,
                    })
                    local Track = New("Frame", {
                        Position = UDim2.new(0, 20, 0.5, -3), Size = UDim2.new(1, -20, 0, 6),
                        BackgroundColor3 = Theme.Background, Parent = Row,
                    })
                    New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Track })
                    local Fill = New("Frame", {
                        Active = false,
                        Size = UDim2.new(initial / 255, 0, 1, 0), BackgroundColor3 = Theme.Accent, Parent = Track,
                    })
                    New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Fill })
                    local dragging = false
                    Track.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = true
                        end
                    end)
                    UserInputService.InputChanged:Connect(function(input)
                        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                            local rel = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                            Fill.Size = UDim2.new(rel, 0, 1, 0)
                            onChange(math.floor(rel * 255))
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = false
                        end
                    end)
                end

                channelSlider("R", r, function(v)
                    r = v
                    updateColor()
                end)
                channelSlider("G", g, function(v)
                    g = v
                    updateColor()
                end)
                channelSlider("B", b, function(v)
                    b = v
                    updateColor()
                end)

                local open = false
                Swatch.MouseButton1Click:Connect(function()
                    open = not open
                    Tween(Popup, { Size = UDim2.new(1, 0, 0, open and 86 or 0) }, 0.15)
                end)
                AttachHover(Swatch, Card)
                if cfg.Flag then Window.Flags[cfg.Flag] = color end
            end

            function SectionObj:CreateLabel(text)
                return New("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 18),
                    Font = Theme.Font,
                    Text = text,
                    TextColor3 = Theme.SubText,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Section,
                })
            end

            function SectionObj:CreateParagraph(cfg)
                cfg = cfg or {}
                local Card = New("Frame", {
                    BackgroundColor3 = Theme.Container,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Parent = Section,
                })
                New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Card })
                New("UIStroke", { Color = Theme.Stroke, Thickness = 1, Parent = Card })
                New("UIPadding", {
                    PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12),
                    Parent = Card,
                })
                New("UIListLayout", { Parent = Card, Padding = UDim.new(0, 4) })
                New("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 16),
                    Font = Theme.FontBold,
                    Text = cfg.Title or "",
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Card,
                })
                New("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Font = Theme.Font,
                    Text = cfg.Content or "",
                    TextColor3 = Theme.SubText,
                    TextSize = 12,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Card,
                })
            end

            function SectionObj:CreateDivider()
                return New("Frame", {
                    BackgroundColor3 = Theme.Stroke,
                    Size = UDim2.new(1, 0, 0, 1),
                    Parent = Section,
                })
            end

            return SectionObj
        end

        return Tab
    end

    function Window:SaveConfig(name)
        if not (writefile and isfile and makefolder and isfolder) then return end
        local ok, encoded = pcall(function()
            return HttpService:JSONEncode(Window.Flags)
        end)
        if ok then
            if not isfolder(Window.ConfigFolder) then
                makefolder(Window.ConfigFolder)
            end
            writefile(Window.ConfigFolder .. "/" .. (name or "config") .. ".json", encoded)
        end
    end

    function Window:LoadConfig(name)
        if not (readfile and isfile) then return Window.Flags end
        local path = Window.ConfigFolder .. "/" .. (name or "config") .. ".json"
        if isfile(path) then
            local ok, decoded = pcall(function()
                return HttpService:JSONDecode(readfile(path))
            end)
            if ok and type(decoded) == "table" then
                for k, v in pairs(decoded) do
                    Window.Flags[k] = v
                end
            end
        end
        return Window.Flags
    end

    function Window:Destroy()
        ScreenGui:Destroy()
    end

    Tween(Main, { Size = size }, 0.35, Enum.EasingStyle.Back)

    return Window
end

return ForgeUI
