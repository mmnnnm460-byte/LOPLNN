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
    FontBold   = Enum.Font.FredokaOne,
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

    local card = New("CanvasGroup", {
        BackgroundColor3 = Theme.Elevated,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true,
        Parent = NotifHolder,
    })
    New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = card })
    New("UIStroke", { Color = Theme.Stroke, Thickness = 1, Parent = card })

    -- شريط اللون: بار داخلي رفيع، بعيد عن أي UIPadding عشان يطلع نظيف وما ينضغط
    local accent = New("Frame", {
        BackgroundColor3 = barColor,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 6, 0.5, 0),
        Size = UDim2.new(0, 3, 1, -12),
        Parent = card,
    })
    New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = accent })

    -- المحتوى النصي بإطار داخلي منفصل يحمل الـ UIPadding، عشان ما يأثر على شريط اللون
    local inner = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = card,
    })
    New("UIPadding", {
        PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 18), PaddingRight = UDim.new(0, 12),
        Parent = inner,
    })

    local titleLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 18),
        Font = Theme.FontBold,
        Text = title,
        TextColor3 = Theme.Text,
        TextTransparency = 1,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = inner,
    })
    local contentLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 20),
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Font = Theme.Font,
        Text = content,
        TextColor3 = Theme.SubText,
        TextTransparency = 1,
        TextSize = 13,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = inner,
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

    -- حجم البداية: نفس نسب الهدف لكن بأوفست أصغر شوي (مو صفر) عشان حركة "تكبّر"
    -- ناعمة بدون أن تتضخم النافذة مؤقتًا أكبر من المطلوب وتطلع خارج الشاشة.
    local startSize = UDim2.new(size.X.Scale, size.X.Offset * 0.92, size.Y.Scale, size.Y.Offset * 0.92)

    local Main = New("CanvasGroup", {
        Name = "Main",
        BackgroundColor3 = Theme.Background,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = startSize,
        ClipsDescendants = true,
        Parent = ScreenGui,
    })
    New("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Main })
    New("UIStroke", { Color = Theme.Stroke, Thickness = 1, Parent = Main })

    -- ظل حقيقي (UIShadow الأصلي في Roblox) بدل إطار مسطح.
    -- هذا العنصر لا يتأثر بالـ ClipsDescendants ويتبع حجم/حركة Main تلقائيًا،
    -- فما راح تشوف أي زاوية أو مربع يطلع أو ينفصل عن الإطار عند الفتح أو السحب.
    -- ملفوف بـ pcall لأن UIShadow ميزة جديدة نسبيًا، فبعض الـ executors القديمة
    -- قد ما تكون دعمتها بعد؛ ولو صار كذا، النافذة تشتغل عادي بدون الظل فقط.
    pcall(function()
        local shadowCfg = config.Shadow or {}
        New("UIShadow", {
            Color = shadowCfg.Color or Color3.fromRGB(0, 0, 0),
            Transparency = shadowCfg.Transparency or 0.55,
            BlurRadius = shadowCfg.BlurRadius or UDim.new(0, 26),
            Offset = shadowCfg.Offset or UDim2.new(0, 0, 0, 6),
            Spread = shadowCfg.Spread or UDim2.new(0, 0, 0, 0),
            ZIndex = -1,
            Parent = Main,
        })
    end)

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

    -- أيقونة النافذة (اختيارية) - توضع داخل الـ TopBar بشكل طبيعي بدل ما تكون
    -- عنصر منفصل لاصق أو طايح خارج حدود المكتبة.
    local textStartX = 16
    if config.Icon then
        New("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0.5, -12),
            Size = UDim2.new(0, 24, 0, 24),
            Image = config.Icon,
            ImageColor3 = config.IconColor or Theme.Accent,
            Parent = TopBar,
        })
        textStartX = 48
    end

    New("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, textStartX, 0, 5),
        Size = UDim2.new(1, -(textStartX + 76), 0, 20),
        Font = Theme.FontBold,
        Text = title,
        TextColor3 = Theme.Text,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = TopBar,
    })
    New("TextLabel", {
        Name = "SubTitle",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, textStartX, 0, 23),
        Size = UDim2.new(1, -(textStartX + 76), 0, 16),
        Font = Theme.Font,
        Text = subtitle,
        TextColor3 = Theme.SubText,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
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
    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, { BackgroundColor3 = Color3.fromRGB(200, 70, 70), TextColor3 = Theme.Text }, 0.15)
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, { BackgroundColor3 = Theme.Elevated, TextColor3 = Theme.SubText }, 0.15)
    end)

    -- نافذة تأكيد قبل حذف/إغلاق المكتبة بالكامل
    local ConfirmOverlay = New("Frame", {
        Name = "ConfirmOverlay",
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Visible = false,
        ZIndex = 50,
        Parent = Main,
    })
    local ConfirmBox = New("CanvasGroup", {
        BackgroundColor3 = Theme.Container,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.fromOffset(240, 122),
        GroupTransparency = 1,
        ZIndex = 51,
        Parent = ConfirmOverlay,
    })
    New("UICorner", { CornerRadius = UDim.new(0, 10), Parent = ConfirmBox })
    New("UIStroke", { Color = Theme.Stroke, Thickness = 1, Parent = ConfirmBox })
    New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 16),
        Size = UDim2.new(1, -24, 0, 44),
        Font = Theme.FontBold,
        Text = "هل تريد حذف الواجهة؟",
        TextColor3 = Theme.Text,
        TextSize = 15,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = ConfirmBox,
    })
    local YesBtn = New("TextButton", {
        BackgroundColor3 = Color3.fromRGB(200, 70, 70),
        Position = UDim2.new(0, 16, 1, -46),
        Size = UDim2.new(0.5, -22, 0, 32),
        Font = Theme.FontBold,
        Text = "نعم",
        TextColor3 = Theme.Text,
        TextSize = 14,
        Parent = ConfirmBox,
    })
    New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = YesBtn })
    local NoBtn = New("TextButton", {
        BackgroundColor3 = Theme.Elevated,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -16, 1, -46),
        Size = UDim2.new(0.5, -22, 0, 32),
        Font = Theme.FontBold,
        Text = "لا",
        TextColor3 = Theme.Text,
        TextSize = 14,
        Parent = ConfirmBox,
    })
    New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = NoBtn })
    NoBtn.MouseEnter:Connect(function() Tween(NoBtn, { BackgroundColor3 = Theme.Stroke }, 0.15) end)
    NoBtn.MouseLeave:Connect(function() Tween(NoBtn, { BackgroundColor3 = Theme.Elevated }, 0.15) end)

    local function openConfirm()
        ConfirmOverlay.Visible = true
        Tween(ConfirmOverlay, { BackgroundTransparency = 0.35 }, 0.15)
        Tween(ConfirmBox, { GroupTransparency = 0 }, 0.15)
    end
    local function closeConfirm()
        Tween(ConfirmOverlay, { BackgroundTransparency = 1 }, 0.15)
        Tween(ConfirmBox, { GroupTransparency = 1 }, 0.15)
        task.delay(0.15, function()
            if ConfirmBox.GroupTransparency > 0.9 then ConfirmOverlay.Visible = false end
        end)
    end
    CloseBtn.MouseButton1Click:Connect(openConfirm)
    NoBtn.MouseButton1Click:Connect(closeConfirm)
    YesBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local MinimizeBtn = New("TextButton", {
        BackgroundColor3 = Theme.Elevated,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -46, 0.5, 0),
        Size = UDim2.new(0, 26, 0, 26),
        Font = Theme.FontBold,
        Text = "-",
        TextColor3 = Theme.SubText,
        TextSize = 16,
        Parent = TopBar,
    })
    New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = MinimizeBtn })
    MinimizeBtn.MouseEnter:Connect(function()
        Tween(MinimizeBtn, { BackgroundColor3 = Theme.Stroke, TextColor3 = Theme.Text }, 0.15)
    end)
    MinimizeBtn.MouseLeave:Connect(function()
        Tween(MinimizeBtn, { BackgroundColor3 = Theme.Elevated, TextColor3 = Theme.SubText }, 0.15)
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

    local minimized = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        MinimizeBtn.Text = minimized and "+" or "-"
        TabBar.Visible = not minimized
        PageHolder.Visible = not minimized
        if minimized then
            Tween(Main, { Size = UDim2.new(size.X.Scale, size.X.Offset, 0, 44) }, 0.22)
        else
            Tween(Main, { Size = size }, 0.22)
        end
    end)

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
    Window._closeActivePopup = nil -- يضمن إغلاق أي Dropdown/ColorPicker مفتوح عند فتح غيره
    local firstTab = true

    function Window:CreateTab(cfg)
        if type(cfg) == "string" then
            cfg = { Name = cfg }
        end
        cfg = cfg or {}
        local name = cfg.Name or "Tab"

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
        if cfg.Icon then
            New("UIPadding", { PaddingLeft = UDim.new(0, 26), Parent = TabButton })
            New("ImageLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 8, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16),
                Image = cfg.Icon,
                ImageColor3 = firstTab and Theme.Text or Theme.SubText,
                Parent = TabButton,
            })
        end

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
                -- CanvasGroup مو Frame عادي: هذا يضمن إن أي عنصر داخل الكرت
                -- (صفوف الدروب داون، بوب أب اللون، إلخ) يتقص فعليًا على شكل
                -- الزوايا الدائرية بدل ما يطلع ركن مربع بارز خارج حواف الكرت.
                local Card = New("CanvasGroup", {
                    BackgroundColor3 = Theme.Container,
                    Size = UDim2.new(1, 0, 0, height or 38),
                    ClipsDescendants = true,
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
                local headerHeight = 38
                local rowHeight = 26

                local Card = BaseCard(headerHeight)
                New("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(0.5, 0, 0, headerHeight),
                    Font = Theme.Font,
                    Text = cfg.Name or "Dropdown",
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Card,
                })
                local SelectedLabel = New("TextLabel", {
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -30, 0, 0),
                    Size = UDim2.new(0.4, 0, 0, headerHeight),
                    Font = Theme.Font,
                    Text = tostring(selected or ""),
                    TextColor3 = Theme.SubText,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = Card,
                })
                New("TextLabel", {
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -12, 0, 0),
                    Size = UDim2.new(0, 14, 0, headerHeight),
                    Font = Theme.FontBold,
                    Text = "˅",
                    TextColor3 = Theme.SubText,
                    TextSize = 14,
                    Parent = Card,
                })
                local OpenBtn = New("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, headerHeight),
                    Text = "",
                    Parent = Card,
                })

                local ListFrame = New("Frame", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, headerHeight),
                    Size = UDim2.new(1, 0, 0, #options * rowHeight),
                    Parent = Card,
                })
                New("Frame", {
                    BackgroundColor3 = Theme.Stroke,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -20, 0, 1),
                    Parent = ListFrame,
                })
                New("UIListLayout", { Parent = ListFrame, SortOrder = Enum.SortOrder.LayoutOrder })
                New("UIPadding", { PaddingTop = UDim.new(0, 4), Parent = ListFrame })

                local function closeDropdown()
                    if open then
                        open = false
                        Tween(Card, { Size = UDim2.new(1, 0, 0, headerHeight) }, 0.18)
                    end
                end

                for _, opt in ipairs(options) do
                    local OptBtn = New("TextButton", {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, rowHeight),
                        Font = Theme.Font,
                        Text = tostring(opt),
                        TextColor3 = Theme.Text,
                        TextSize = 12,
                        Parent = ListFrame,
                    })
                    OptBtn.MouseEnter:Connect(function() Tween(OptBtn, { TextColor3 = Theme.Accent }, 0.1) end)
                    OptBtn.MouseLeave:Connect(function() Tween(OptBtn, { TextColor3 = Theme.Text }, 0.1) end)
                    OptBtn.MouseButton1Click:Connect(function()
                        selected = opt
                        SelectedLabel.Text = tostring(opt)
                        closeDropdown()
                        if cfg.Flag then Window.Flags[cfg.Flag] = opt end
                        if cfg.Callback then cfg.Callback(opt) end
                    end)
                end
                OpenBtn.MouseButton1Click:Connect(function()
                    if open then
                        closeDropdown()
                    else
                        if Window._closeActivePopup then Window._closeActivePopup() end
                        open = true
                        Tween(Card, { Size = UDim2.new(1, 0, 0, headerHeight + 8 + (#options * rowHeight)) }, 0.18)
                        Window._closeActivePopup = closeDropdown
                    end
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
                local headerHeight = 38
                local popupHeight = 96
                local Card = BaseCard(headerHeight)
                New("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(0.6, 0, 0, headerHeight),
                    Font = Theme.Font,
                    Text = cfg.Name or "Color",
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Card,
                })
                local Swatch = New("TextButton", {
                    BackgroundColor3 = color,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -10, 0, 6),
                    Size = UDim2.new(0, 26, 0, 26),
                    Text = "",
                    Parent = Card,
                })
                New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Swatch })
                New("UIStroke", { Color = Theme.Stroke, Thickness = 1, Parent = Swatch })

                local Popup = New("Frame", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, headerHeight),
                    Size = UDim2.new(1, 0, 0, popupHeight),
                    Parent = Card,
                })
                New("Frame", {
                    BackgroundColor3 = Theme.Stroke,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -20, 0, 1),
                    Parent = Popup,
                })
                New("UIPadding", {
                    PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12),
                    Parent = Popup,
                })
                New("UIListLayout", { Parent = Popup, Padding = UDim.new(0, 8) })

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
                local function closePopup()
                    if open then
                        open = false
                        Tween(Card, { Size = UDim2.new(1, 0, 0, headerHeight) }, 0.18)
                    end
                end
                Swatch.MouseButton1Click:Connect(function()
                    if open then
                        closePopup()
                    else
                        if Window._closeActivePopup then Window._closeActivePopup() end
                        open = true
                        Tween(Card, { Size = UDim2.new(1, 0, 0, headerHeight + popupHeight) }, 0.18)
                        Window._closeActivePopup = closePopup
                    end
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

    Tween(Main, { Size = size }, 0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    return Window
end

return ForgeUI
