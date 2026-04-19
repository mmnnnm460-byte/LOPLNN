--[[
    ╔══════════════════════════════════════════════════════╗
    ║         WindUI Enhanced Extensions v2.0              ║
    ║   تحسينات وإضافات على مكتبة WindUI الأصلية           ║
    ║                                                      ║
    ║  الميزات الجديدة:                                    ║
    ║   • 6 ثيمات جديدة (Cyberpunk, Ocean, Neon, ...)     ║
    ║   • عنصر ProgressBar                                 ║
    ║   • عنصر Badge / Tag                                 ║
    ║   • عنصر NumberInput (سهام للزيادة والنقصان)         ║
    ║   • عنصر RadioGroup                                  ║
    ║   • عنصر MultiToggle (Toggle مع خيارات متعددة)       ║
    ║   • عنصر AlertBanner (تنبيه داخل النافذة)           ║
    ║   • نظام Hotkey Manager محسّن                        ║
    ║   • ProgressBar في شريط العنوان                      ║
    ║   • تحسينات على Button (Ripple Effect)               ║
    ║   • تحسينات على Slider (Snap + Labels)               ║
    ╚══════════════════════════════════════════════════════╝

    الاستخدام:
        local WindUI = loadstring(game:HttpGet("YOUR_WINDUI_URL"))()
        local Extensions = loadstring(game:HttpGet("YOUR_EXTENSIONS_URL"))()
        Extensions:Apply(WindUI)
        
        -- أو إذا كانت المكتبة محلية:
        local WindUI = require(path.to.WindUI)
        local Extensions = require(path.to.Extensions)
        Extensions:Apply(WindUI)
]]

-- ══════════════════════════════════════════════════
-- الخدمات
-- ══════════════════════════════════════════════════
local TweenService   = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService     = game:GetService("RunService")
local HttpService    = game:GetService("HttpService")

-- ══════════════════════════════════════════════════
-- الحزمة الرئيسية
-- ══════════════════════════════════════════════════
local Extensions = {}
Extensions.__index = Extensions

-- ══════════════════════════════════════════════════
-- دوال مساعدة داخلية
-- ══════════════════════════════════════════════════
local function Tween(obj, t, props, style, dir)
    style = style or Enum.EasingStyle.Quint
    dir   = dir   or Enum.EasingDirection.Out
    return TweenService:Create(obj, TweenInfo.new(t, style, dir), props)
end

local function NewInst(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then inst[k] = v end
    end
    for _, child in pairs(children or {}) do
        child.Parent = inst
    end
    if props and props.Parent then inst.Parent = props.Parent end
    return inst
end

local function HexToColor(hex)
    hex = hex:gsub("#", "")
    return Color3.fromRGB(
        tonumber(hex:sub(1,2), 16),
        tonumber(hex:sub(3,4), 16),
        tonumber(hex:sub(5,6), 16)
    )
end

-- ══════════════════════════════════════════════════
-- ✨ الثيمات الجديدة
-- ══════════════════════════════════════════════════
Extensions.NewThemes = {

    -- 🌊 Cyberpunk - أزرق وبنفسجي نيون
    Cyberpunk = {
        Name = "Cyberpunk",
        Accent    = HexToColor("#00f5ff"),
        Primary   = HexToColor("#00f5ff"),
        Background = HexToColor("#0a0a1a"),
        BackgroundTransparency = 0,
        Text      = HexToColor("#e0e0ff"),
        Icon      = HexToColor("#00f5ff"),
        Button    = HexToColor("#7b00ff"),
        White     = HexToColor("#ffffff"),
        Black     = HexToColor("#000000"),
        Hover     = HexToColor("#1a1a3e"),
        PanelBackground = HexToColor("#ffffff"),
        PanelBackgroundTransparency = 0.92,
        Tooltip   = HexToColor("#0d0d2b"),
        TooltipText = HexToColor("#00f5ff"),
        TooltipSecondary = HexToColor("#7b00ff"),
        TooltipSecondaryText = HexToColor("#ffffff"),
        Slider    = HexToColor("#00f5ff"),
        SliderThumb = HexToColor("#ffffff"),
        Toggle    = HexToColor("#7b00ff"),
        ToggleBar = HexToColor("#ffffff"),
        Checkbox  = HexToColor("#00f5ff"),
        CheckboxIcon = HexToColor("#000000"),
        CheckboxBorder = HexToColor("#00f5ff"),
        CheckboxBorderTransparency = 0.3,
        -- ألوان عناصر UI
        ElementBackground = HexToColor("#e0e0ff"),
        ElementBackgroundTransparency = 0.95,
        ElementTitle = HexToColor("#e0e0ff"),
        ElementDesc  = HexToColor("#e0e0ff"),
        NotificationTitle = HexToColor("#e0e0ff"),
        NotificationContent = HexToColor("#e0e0ff"),
        NotificationDuration = HexToColor("#00f5ff"),
        SectionExpandIcon = HexToColor("#00f5ff"),
        SearchBarBorder = HexToColor("#00f5ff"),
        LabelBackground = HexToColor("#00f5ff"),
        LabelBackgroundTransparency = 0.9,
        WindowBackground = HexToColor("#0a0a1a"),
        WindowShadow = HexToColor("#000000"),
        TabBackground = HexToColor("#1a1a3e"),
        TabText = HexToColor("#e0e0ff"),
        TabIcon = HexToColor("#00f5ff"),
        Dialog = HexToColor("#00f5ff"),
    },

    -- 🌊 Ocean - ألوان البحر الهادئة
    Ocean = {
        Name = "Ocean",
        Accent    = HexToColor("#0099cc"),
        Primary   = HexToColor("#00b4d8"),
        Background = HexToColor("#023e58"),
        BackgroundTransparency = 0,
        Text      = HexToColor("#caf0f8"),
        Icon      = HexToColor("#90e0ef"),
        Button    = HexToColor("#0077b6"),
        White     = HexToColor("#ffffff"),
        Black     = HexToColor("#000000"),
        Hover     = HexToColor("#03527a"),
        PanelBackground = HexToColor("#ffffff"),
        PanelBackgroundTransparency = 0.93,
        Tooltip   = HexToColor("#012a3a"),
        TooltipText = HexToColor("#caf0f8"),
        TooltipSecondary = HexToColor("#0099cc"),
        TooltipSecondaryText = HexToColor("#ffffff"),
        Slider    = HexToColor("#00b4d8"),
        SliderThumb = HexToColor("#ffffff"),
        Toggle    = HexToColor("#0077b6"),
        ToggleBar = HexToColor("#caf0f8"),
        Checkbox  = HexToColor("#00b4d8"),
        CheckboxIcon = HexToColor("#ffffff"),
        CheckboxBorder = HexToColor("#90e0ef"),
        CheckboxBorderTransparency = 0.4,
        ElementBackground = HexToColor("#caf0f8"),
        ElementBackgroundTransparency = 0.94,
        ElementTitle = HexToColor("#caf0f8"),
        ElementDesc  = HexToColor("#90e0ef"),
        NotificationTitle = HexToColor("#caf0f8"),
        NotificationContent = HexToColor("#90e0ef"),
        NotificationDuration = HexToColor("#00b4d8"),
        SectionExpandIcon = HexToColor("#90e0ef"),
        SearchBarBorder = HexToColor("#00b4d8"),
        LabelBackground = HexToColor("#00b4d8"),
        LabelBackgroundTransparency = 0.88,
        WindowBackground = HexToColor("#023e58"),
        WindowShadow = HexToColor("#000000"),
        TabBackground = HexToColor("#03527a"),
        TabText = HexToColor("#caf0f8"),
        TabIcon = HexToColor("#90e0ef"),
        Dialog = HexToColor("#0099cc"),
    },

    -- 🌿 Forest - ألوان الطبيعة
    Forest = {
        Name = "Forest",
        Accent    = HexToColor("#52b788"),
        Primary   = HexToColor("#52b788"),
        Background = HexToColor("#1b3a2d"),
        BackgroundTransparency = 0,
        Text      = HexToColor("#d8f3dc"),
        Icon      = HexToColor("#95d5b2"),
        Button    = HexToColor("#2d6a4f"),
        White     = HexToColor("#ffffff"),
        Black     = HexToColor("#000000"),
        Hover     = HexToColor("#2d4a3e"),
        PanelBackground = HexToColor("#ffffff"),
        PanelBackgroundTransparency = 0.93,
        Tooltip   = HexToColor("#081c15"),
        TooltipText = HexToColor("#d8f3dc"),
        TooltipSecondary = HexToColor("#52b788"),
        TooltipSecondaryText = HexToColor("#ffffff"),
        Slider    = HexToColor("#52b788"),
        SliderThumb = HexToColor("#ffffff"),
        Toggle    = HexToColor("#2d6a4f"),
        ToggleBar = HexToColor("#d8f3dc"),
        Checkbox  = HexToColor("#52b788"),
        CheckboxIcon = HexToColor("#ffffff"),
        CheckboxBorder = HexToColor("#95d5b2"),
        CheckboxBorderTransparency = 0.4,
        ElementBackground = HexToColor("#d8f3dc"),
        ElementBackgroundTransparency = 0.94,
        ElementTitle = HexToColor("#d8f3dc"),
        ElementDesc  = HexToColor("#95d5b2"),
        NotificationTitle = HexToColor("#d8f3dc"),
        NotificationContent = HexToColor("#95d5b2"),
        NotificationDuration = HexToColor("#52b788"),
        SectionExpandIcon = HexToColor("#95d5b2"),
        SearchBarBorder = HexToColor("#52b788"),
        LabelBackground = HexToColor("#52b788"),
        LabelBackgroundTransparency = 0.88,
        WindowBackground = HexToColor("#1b3a2d"),
        WindowShadow = HexToColor("#000000"),
        TabBackground = HexToColor("#2d4a3e"),
        TabText = HexToColor("#d8f3dc"),
        TabIcon = HexToColor("#95d5b2"),
        Dialog = HexToColor("#52b788"),
    },

    -- 🔴 Crimson - أحمر داكن
    Crimson = {
        Name = "Crimson",
        Accent    = HexToColor("#e63946"),
        Primary   = HexToColor("#e63946"),
        Background = HexToColor("#1a0a0a"),
        BackgroundTransparency = 0,
        Text      = HexToColor("#f1d0d0"),
        Icon      = HexToColor("#e63946"),
        Button    = HexToColor("#9b2226"),
        White     = HexToColor("#ffffff"),
        Black     = HexToColor("#000000"),
        Hover     = HexToColor("#2d1010"),
        PanelBackground = HexToColor("#ffffff"),
        PanelBackgroundTransparency = 0.92,
        Tooltip   = HexToColor("#0d0404"),
        TooltipText = HexToColor("#f1d0d0"),
        TooltipSecondary = HexToColor("#e63946"),
        TooltipSecondaryText = HexToColor("#ffffff"),
        Slider    = HexToColor("#e63946"),
        SliderThumb = HexToColor("#ffffff"),
        Toggle    = HexToColor("#9b2226"),
        ToggleBar = HexToColor("#f1d0d0"),
        Checkbox  = HexToColor("#e63946"),
        CheckboxIcon = HexToColor("#ffffff"),
        CheckboxBorder = HexToColor("#e63946"),
        CheckboxBorderTransparency = 0.3,
        ElementBackground = HexToColor("#f1d0d0"),
        ElementBackgroundTransparency = 0.94,
        ElementTitle = HexToColor("#f1d0d0"),
        ElementDesc  = HexToColor("#c9a0a0"),
        NotificationTitle = HexToColor("#f1d0d0"),
        NotificationContent = HexToColor("#c9a0a0"),
        NotificationDuration = HexToColor("#e63946"),
        SectionExpandIcon = HexToColor("#e63946"),
        SearchBarBorder = HexToColor("#e63946"),
        LabelBackground = HexToColor("#e63946"),
        LabelBackgroundTransparency = 0.88,
        WindowBackground = HexToColor("#1a0a0a"),
        WindowShadow = HexToColor("#000000"),
        TabBackground = HexToColor("#2d1010"),
        TabText = HexToColor("#f1d0d0"),
        TabIcon = HexToColor("#e63946"),
        Dialog = HexToColor("#e63946"),
    },

    -- ☀️ Sunset - ألوان غروب الشمس
    Sunset = {
        Name = "Sunset",
        Accent    = HexToColor("#ff6b35"),
        Primary   = HexToColor("#f7931e"),
        Background = HexToColor("#1a0f0a"),
        BackgroundTransparency = 0,
        Text      = HexToColor("#ffe8d6"),
        Icon      = HexToColor("#ff9a5c"),
        Button    = HexToColor("#c84b0e"),
        White     = HexToColor("#ffffff"),
        Black     = HexToColor("#000000"),
        Hover     = HexToColor("#2d1a0f"),
        PanelBackground = HexToColor("#ffffff"),
        PanelBackgroundTransparency = 0.92,
        Tooltip   = HexToColor("#0d0703"),
        TooltipText = HexToColor("#ffe8d6"),
        TooltipSecondary = HexToColor("#ff6b35"),
        TooltipSecondaryText = HexToColor("#ffffff"),
        Slider    = HexToColor("#ff6b35"),
        SliderThumb = HexToColor("#ffffff"),
        Toggle    = HexToColor("#c84b0e"),
        ToggleBar = HexToColor("#ffe8d6"),
        Checkbox  = HexToColor("#ff6b35"),
        CheckboxIcon = HexToColor("#ffffff"),
        CheckboxBorder = HexToColor("#ff9a5c"),
        CheckboxBorderTransparency = 0.3,
        ElementBackground = HexToColor("#ffe8d6"),
        ElementBackgroundTransparency = 0.94,
        ElementTitle = HexToColor("#ffe8d6"),
        ElementDesc  = HexToColor("#ffb899"),
        NotificationTitle = HexToColor("#ffe8d6"),
        NotificationContent = HexToColor("#ffb899"),
        NotificationDuration = HexToColor("#ff6b35"),
        SectionExpandIcon = HexToColor("#ff9a5c"),
        SearchBarBorder = HexToColor("#ff6b35"),
        LabelBackground = HexToColor("#ff6b35"),
        LabelBackgroundTransparency = 0.88,
        WindowBackground = HexToColor("#1a0f0a"),
        WindowShadow = HexToColor("#000000"),
        TabBackground = HexToColor("#2d1a0f"),
        TabText = HexToColor("#ffe8d6"),
        TabIcon = HexToColor("#ff9a5c"),
        Dialog = HexToColor("#ff6b35"),
    },

    -- 💜 Midnight - بنفسجي داكن فاخر
    Midnight = {
        Name = "Midnight",
        Accent    = HexToColor("#9d4edd"),
        Primary   = HexToColor("#9d4edd"),
        Background = HexToColor("#10001f"),
        BackgroundTransparency = 0,
        Text      = HexToColor("#e8d5f5"),
        Icon      = HexToColor("#c77dff"),
        Button    = HexToColor("#5a189a"),
        White     = HexToColor("#ffffff"),
        Black     = HexToColor("#000000"),
        Hover     = HexToColor("#1e0a30"),
        PanelBackground = HexToColor("#ffffff"),
        PanelBackgroundTransparency = 0.92,
        Tooltip   = HexToColor("#0a0010"),
        TooltipText = HexToColor("#e8d5f5"),
        TooltipSecondary = HexToColor("#9d4edd"),
        TooltipSecondaryText = HexToColor("#ffffff"),
        Slider    = HexToColor("#9d4edd"),
        SliderThumb = HexToColor("#ffffff"),
        Toggle    = HexToColor("#5a189a"),
        ToggleBar = HexToColor("#e8d5f5"),
        Checkbox  = HexToColor("#9d4edd"),
        CheckboxIcon = HexToColor("#ffffff"),
        CheckboxBorder = HexToColor("#c77dff"),
        CheckboxBorderTransparency = 0.3,
        ElementBackground = HexToColor("#e8d5f5"),
        ElementBackgroundTransparency = 0.94,
        ElementTitle = HexToColor("#e8d5f5"),
        ElementDesc  = HexToColor("#c77dff"),
        NotificationTitle = HexToColor("#e8d5f5"),
        NotificationContent = HexToColor("#c77dff"),
        NotificationDuration = HexToColor("#9d4edd"),
        SectionExpandIcon = HexToColor("#c77dff"),
        SearchBarBorder = HexToColor("#9d4edd"),
        LabelBackground = HexToColor("#9d4edd"),
        LabelBackgroundTransparency = 0.88,
        WindowBackground = HexToColor("#10001f"),
        WindowShadow = HexToColor("#000000"),
        TabBackground = HexToColor("#1e0a30"),
        TabText = HexToColor("#e8d5f5"),
        TabIcon = HexToColor("#c77dff"),
        Dialog = HexToColor("#9d4edd"),
    },
}

-- ══════════════════════════════════════════════════
-- 📊 عنصر ProgressBar - شريط التقدم
-- ══════════════════════════════════════════════════
function Extensions:_AddProgressBar(WindUI, Section)
    --[[
        الاستخدام:
        local bar = MySection:ProgressBar({
            Title    = "تحميل البيانات",
            Desc     = "جارٍ التحميل...",
            Value    = 0,          -- القيمة الابتدائية (0-100)
            Color    = "#9d4edd",  -- لون الشريط (اختياري)
            Animated = true,       -- تأثير حركي عند التحديث
        })
        bar:Set(75)           -- تعيين القيمة
        bar:Increment(10)     -- زيادة
        bar:Decrement(5)      -- نقصان
        bar:SetLabel("تحميل...") -- تغيير النص الجانبي
    ]]

    return function(self, config)
        config = config or {}

        local value   = math.clamp(config.Value or 0, 0, 100)
        local color   = config.Color and HexToColor(config.Color) or nil
        local animated = config.Animated ~= false

        -- ── الإطار الخارجي للعنصر ──
        local container = NewInst("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Parent = self.UIElements and self.UIElements.Content or self.Parent,
        })

        -- ── عنوان وصف ──
        local titleLabel
        if config.Title then
            titleLabel = NewInst("TextLabel", {
                Size = UDim2.new(1, -60, 0, 18),
                BackgroundTransparency = 1,
                Text = config.Title,
                TextSize = 14,
                Font = Enum.Font.GothamSemibold,
                TextColor3 = Color3.new(1,1,1),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = container,
            })
        end

        if config.Desc then
            NewInst("TextLabel", {
                Size = UDim2.new(1, -60, 0, 14),
                BackgroundTransparency = 1,
                Text = config.Desc,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextColor3 = Color3.fromRGB(180, 180, 180),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = container,
            })
        end

        -- ── شريط الخلفية ──
        local track = NewInst("Frame", {
            Size = UDim2.new(1, -60, 0, 6),
            BackgroundColor3 = Color3.fromRGB(60, 60, 60),
            AnchorPoint = Vector2.new(0, 0.5),
            Parent = container,
        }, {
            NewInst("UICorner", { CornerRadius = UDim.new(1, 0) }),
        })

        -- ── شريط التقدم ──
        local fill = NewInst("Frame", {
            Size = UDim2.new(value / 100, 0, 1, 0),
            BackgroundColor3 = color or Color3.fromRGB(100, 100, 255),
            Parent = track,
        }, {
            NewInst("UICorner", { CornerRadius = UDim.new(1, 0) }),
            NewInst("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(200,200,200)),
                }),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.3),
                    NumberSequenceKeypoint.new(1, 0),
                }),
                Rotation = 90,
            }),
        })

        -- ── نص النسبة ──
        local percentLabel = NewInst("TextLabel", {
            Size = UDim2.new(0, 50, 0, 18),
            Position = UDim2.new(1, -50, 0, 0),
            BackgroundTransparency = 1,
            Text = value .. "%",
            TextSize = 13,
            Font = Enum.Font.GothamBold,
            TextColor3 = color or Color3.fromRGB(160, 160, 255),
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = container,
        })

        NewInst("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6),
            Parent = container,
        })

        -- ── API العنصر ──
        local api = {
            __type = "ProgressBar",
            Value  = value,
            Container = container,
        }

        local function updateVisuals(newVal, noAnim)
            api.Value = newVal
            percentLabel.Text = math.floor(newVal) .. "%"
            percentLabel.TextColor3 = color or Color3.fromRGB(160, 160, 255)

            if animated and not noAnim then
                Tween(fill, 0.4, {
                    Size = UDim2.new(newVal / 100, 0, 1, 0)
                }):Play()
            else
                fill.Size = UDim2.new(newVal / 100, 0, 1, 0)
            end
        end

        function api:Set(newVal, noAnim)
            newVal = math.clamp(newVal, 0, 100)
            updateVisuals(newVal, noAnim)
        end

        function api:Increment(amount)
            self:Set(math.min(self.Value + (amount or 1), 100))
        end

        function api:Decrement(amount)
            self:Set(math.max(self.Value - (amount or 1), 0))
        end

        function api:SetLabel(text)
            if titleLabel then titleLabel.Text = text end
        end

        function api:SetColor(newColor)
            if typeof(newColor) == "string" then
                color = HexToColor(newColor)
            else
                color = newColor
            end
            fill.BackgroundColor3 = color
            percentLabel.TextColor3 = color
        end

        function api:Destroy()
            container:Destroy()
        end

        return api
    end
end

-- ══════════════════════════════════════════════════
-- 🏷️ عنصر Badge / Tag - بطاقة ملونة
-- ══════════════════════════════════════════════════
function Extensions:_AddBadge(WindUI, Section)
    --[[
        الاستخدام:
        local badge = MySection:Badge({
            Title = "مميّز",
            Text  = "VIP",
            Color = "#9d4edd",   -- لون البادج
            Style = "Filled",    -- "Filled" | "Outline" | "Subtle"
            Icon  = "star",      -- أيقونة (اختياري)
        })
        badge:SetText("NEW")
        badge:SetColor("#ff6b35")
    ]]

    return function(self, config)
        config = config or {}

        local color  = config.Color and HexToColor(config.Color) or Color3.fromRGB(100, 100, 255)
        local style  = config.Style or "Filled"
        local text   = config.Text or "Badge"

        local container = NewInst("Frame", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1,
            Parent = self.UIElements and self.UIElements.Content or self.Parent,
        })

        -- عنوان على اليسار
        if config.Title then
            NewInst("TextLabel", {
                Size = UDim2.new(0.6, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = config.Title,
                TextSize = 14,
                Font = Enum.Font.GothamSemibold,
                TextColor3 = Color3.new(1,1,1),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = container,
            })
        end

        -- البادج على اليمين
        local bgColor = style == "Filled"  and color
                     or style == "Subtle"  and color
                     or Color3.fromRGB(0,0,0)

        local bgTrans = style == "Filled"  and 0
                     or style == "Subtle"  and 0.8
                     or 1

        local badge = NewInst("Frame", {
            Size = UDim2.new(0, 0, 0, 24),
            AutomaticSize = Enum.AutomaticSize.X,
            Position = UDim2.new(1, 0, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = bgColor,
            BackgroundTransparency = bgTrans,
            Parent = container,
        }, {
            NewInst("UICorner", { CornerRadius = UDim.new(1, 0) }),
            NewInst("UIPadding", {
                PaddingLeft  = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10),
            }),
        })

        -- حدود للـ Outline
        if style == "Outline" then
            NewInst("UIStroke", {
                Color = color,
                Thickness = 1.5,
                Parent = badge,
            })
        end

        local textLabel = NewInst("TextLabel", {
            Size = UDim2.new(0, 0, 1, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            Text = text,
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            TextColor3 = style == "Outline" and color or Color3.new(1,1,1),
            Parent = badge,
        })

        local api = {
            __type = "Badge",
            Container = container,
            Badge = badge,
        }

        function api:SetText(newText)
            textLabel.Text = newText
        end

        function api:SetColor(newColor)
            if typeof(newColor) == "string" then color = HexToColor(newColor)
            else color = newColor end

            if style == "Filled" then
                badge.BackgroundColor3 = color
            elseif style == "Outline" then
                badge:FindFirstChildOfClass("UIStroke").Color = color
                textLabel.TextColor3 = color
            elseif style == "Subtle" then
                badge.BackgroundColor3 = color
            end
        end

        function api:Destroy()
            container:Destroy()
        end

        return api
    end
end

-- ══════════════════════════════════════════════════
-- 🔢 عنصر NumberInput - إدخال رقمي بأسهم
-- ══════════════════════════════════════════════════
function Extensions:_AddNumberInput(WindUI, Section)
    --[[
        الاستخدام:
        local numInput = MySection:NumberInput({
            Title    = "عدد اللاعبين",
            Desc     = "اختر عدد اللاعبين في الفريق",
            Value    = 5,
            Min      = 1,
            Max      = 20,
            Step     = 1,
            Callback = function(val)
                print("القيمة:", val)
            end
        })
        numInput:Set(10)
    ]]

    return function(self, config)
        config = config or {}

        local value    = config.Value or 0
        local minVal   = config.Min or 0
        local maxVal   = config.Max or 100
        local step     = config.Step or 1
        local callback = config.Callback or function() end

        local container = NewInst("Frame", {
            Size = UDim2.new(1, 0, 0, 44),
            BackgroundTransparency = 1,
            Parent = self.UIElements and self.UIElements.Content or self.Parent,
        })

        -- عنوان
        if config.Title then
            NewInst("TextLabel", {
                Size = UDim2.new(1, -130, 1, 0),
                BackgroundTransparency = 1,
                Text = config.Title,
                TextSize = 14,
                Font = Enum.Font.GothamSemibold,
                TextColor3 = Color3.new(1,1,1),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = container,
            })
        end

        -- إطار التحكم
        local controls = NewInst("Frame", {
            Size = UDim2.new(0, 120, 0, 32),
            Position = UDim2.new(1, 0, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            Parent = container,
        }, {
            NewInst("UICorner", { CornerRadius = UDim.new(0, 8) }),
        })

        -- زر الطرح
        local minusBtn = NewInst("TextButton", {
            Size = UDim2.new(0, 32, 1, 0),
            BackgroundTransparency = 1,
            Text = "−",
            TextSize = 18,
            Font = Enum.Font.GothamBold,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            Parent = controls,
        })

        -- حقل الرقم
        local numDisplay = NewInst("TextBox", {
            Size = UDim2.new(1, -64, 1, 0),
            Position = UDim2.new(0, 32, 0, 0),
            BackgroundTransparency = 1,
            Text = tostring(value),
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            TextColor3 = Color3.new(1,1,1),
            TextXAlignment = Enum.TextXAlignment.Center,
            ClearTextOnFocus = false,
            Parent = controls,
        })

        -- زر الجمع
        local plusBtn = NewInst("TextButton", {
            Size = UDim2.new(0, 32, 1, 0),
            Position = UDim2.new(1, -32, 0, 0),
            BackgroundTransparency = 1,
            Text = "+",
            TextSize = 18,
            Font = Enum.Font.GothamBold,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            Parent = controls,
        })

        -- فاصل
        NewInst("Frame", {
            Size = UDim2.new(0, 1, 0.6, 0),
            Position = UDim2.new(0, 32, 0.2, 0),
            BackgroundColor3 = Color3.fromRGB(80, 80, 80),
            Parent = controls,
        })
        NewInst("Frame", {
            Size = UDim2.new(0, 1, 0.6, 0),
            Position = UDim2.new(1, -33, 0.2, 0),
            BackgroundColor3 = Color3.fromRGB(80, 80, 80),
            Parent = controls,
        })

        local api = {
            __type = "NumberInput",
            Value  = value,
            Container = container,
        }

        local function updateValue(newVal)
            newVal = math.clamp(math.floor(newVal / step + 0.5) * step, minVal, maxVal)
            api.Value = newVal
            numDisplay.Text = tostring(newVal)
            task.spawn(function()
                pcall(callback, newVal)
            end)
        end

        minusBtn.MouseButton1Click:Connect(function()
            updateValue(api.Value - step)
            Tween(minusBtn, 0.08, { TextColor3 = Color3.fromRGB(255,255,255) }):Play()
            task.delay(0.1, function()
                Tween(minusBtn, 0.1, { TextColor3 = Color3.fromRGB(200,200,200) }):Play()
            end)
        end)

        plusBtn.MouseButton1Click:Connect(function()
            updateValue(api.Value + step)
            Tween(plusBtn, 0.08, { TextColor3 = Color3.fromRGB(255,255,255) }):Play()
            task.delay(0.1, function()
                Tween(plusBtn, 0.1, { TextColor3 = Color3.fromRGB(200,200,200) }):Play()
            end)
        end)

        numDisplay.FocusLost:Connect(function()
            local v = tonumber(numDisplay.Text)
            if v then
                updateValue(v)
            else
                numDisplay.Text = tostring(api.Value)
            end
        end)

        function api:Set(newVal)
            updateValue(newVal)
        end

        function api:Get()
            return self.Value
        end

        function api:Destroy()
            container:Destroy()
        end

        return api
    end
end

-- ══════════════════════════════════════════════════
-- 🔘 عنصر RadioGroup - اختيار واحد من متعدد
-- ══════════════════════════════════════════════════
function Extensions:_AddRadioGroup(WindUI, Section)
    --[[
        الاستخدام:
        local radio = MySection:RadioGroup({
            Title   = "نوع اللعب",
            Options = { "Solo", "Duo", "Squad" },
            Default = "Solo",
            Callback = function(selected)
                print("تم اختيار:", selected)
            end
        })
        radio:Select("Squad")
        print(radio:GetSelected())
    ]]

    return function(self, config)
        config = config or {}

        local options  = config.Options or {}
        local selected = config.Default or options[1]
        local callback = config.Callback or function() end

        local container = NewInst("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Parent = self.UIElements and self.UIElements.Content or self.Parent,
        })

        if config.Title then
            NewInst("TextLabel", {
                Size = UDim2.new(1, 0, 0, 22),
                BackgroundTransparency = 1,
                Text = config.Title,
                TextSize = 14,
                Font = Enum.Font.GothamSemibold,
                TextColor3 = Color3.new(1,1,1),
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = 0,
                Parent = container,
            })
        end

        NewInst("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 4),
            Parent = container,
        })

        local buttons = {}
        local api = {
            __type    = "RadioGroup",
            Selected  = selected,
            Container = container,
        }

        local function selectOption(opt)
            api.Selected = opt
            for optName, btn in pairs(buttons) do
                local isSelected = (optName == opt)
                Tween(btn.Dot, 0.2, {
                    Size = isSelected and UDim2.new(0, 8, 0, 8) or UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = isSelected and 0 or 1,
                }):Play()
                Tween(btn.Ring, 0.2, {
                    BackgroundColor3 = isSelected
                        and Color3.fromRGB(140, 100, 255)
                        or  Color3.fromRGB(80, 80, 80),
                }):Play()
                Tween(btn.Label, 0.15, {
                    TextColor3 = isSelected and Color3.new(1,1,1) or Color3.fromRGB(160,160,160),
                    TextTransparency = isSelected and 0 or 0.1,
                }):Play()
            end
            task.spawn(function() pcall(callback, opt) end)
        end

        for i, option in ipairs(options) do
            local row = NewInst("Frame", {
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1,
                LayoutOrder = i,
                Parent = container,
            })

            -- دائرة الراديو
            local ring = NewInst("Frame", {
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Color3.fromRGB(80, 80, 80),
                Parent = row,
            }, {
                NewInst("UICorner", { CornerRadius = UDim.new(1, 0) }),
            })

            -- نقطة داخلية
            local dot = NewInst("Frame", {
                Size = UDim2.new(0, 0, 0, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                BackgroundColor3 = Color3.fromRGB(140, 100, 255),
                BackgroundTransparency = 1,
                Parent = ring,
            }, {
                NewInst("UICorner", { CornerRadius = UDim.new(1, 0) }),
            })

            -- نص الخيار
            local label = NewInst("TextLabel", {
                Size = UDim2.new(1, -26, 1, 0),
                Position = UDim2.new(0, 26, 0, 0),
                BackgroundTransparency = 1,
                Text = option,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextColor3 = Color3.fromRGB(160, 160, 160),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = row,
            })

            -- زر شفاف للنقر
            local btn = NewInst("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = row,
            })

            buttons[option] = { Ring = ring, Dot = dot, Label = label }

            btn.MouseButton1Click:Connect(function()
                selectOption(option)
            end)
        end

        -- تفعيل الخيار الابتدائي
        selectOption(selected)

        function api:Select(opt)
            if table.find(options, opt) then
                selectOption(opt)
            end
        end

        function api:GetSelected()
            return self.Selected
        end

        function api:Destroy()
            container:Destroy()
        end

        return api
    end
end

-- ══════════════════════════════════════════════════
-- 📢 عنصر AlertBanner - تنبيه داخل القسم
-- ══════════════════════════════════════════════════
function Extensions:_AddAlertBanner(WindUI, Section)
    --[[
        الاستخدام:
        MySection:AlertBanner({
            Type    = "warning",  -- "info" | "warning" | "error" | "success"
            Title   = "تحذير!",
            Message = "هذه الإعدادات قد تسبب مشاكل في اللعبة.",
            Dismissable = true,   -- يظهر زر إغلاق
        })
    ]]

    return function(self, config)
        config = config or {}

        local alertType = config.Type or "info"
        local colors = {
            info    = { bg = Color3.fromRGB(30,80,150),  icon = "ℹ", accent = Color3.fromRGB(100,160,255) },
            warning = { bg = Color3.fromRGB(120,80,0),   icon = "⚠", accent = Color3.fromRGB(255,180,0)   },
            error   = { bg = Color3.fromRGB(120,20,20),  icon = "✕", accent = Color3.fromRGB(255,80,80)   },
            success = { bg = Color3.fromRGB(20,90,40),   icon = "✓", accent = Color3.fromRGB(80,220,100)  },
        }
        local c = colors[alertType] or colors.info

        local banner = NewInst("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = c.bg,
            BackgroundTransparency = 0.3,
            Parent = self.UIElements and self.UIElements.Content or self.Parent,
        }, {
            NewInst("UICorner", { CornerRadius = UDim.new(0, 8) }),
            NewInst("UIPadding", {
                PaddingLeft   = UDim.new(0, 10),
                PaddingRight  = UDim.new(0, 10),
                PaddingTop    = UDim.new(0, 8),
                PaddingBottom = UDim.new(0, 8),
            }),
            NewInst("UIStroke", {
                Color = c.accent,
                Thickness = 1,
                Transparency = 0.5,
            }),
        })

        -- شريط لوني جانبي
        NewInst("Frame", {
            Size = UDim2.new(0, 3, 1, 0),
            BackgroundColor3 = c.accent,
            Parent = banner,
        }, {
            NewInst("UICorner", { CornerRadius = UDim.new(0, 4) }),
        })

        -- أيقونة
        NewInst("TextLabel", {
            Size = UDim2.new(0, 22, 0, 22),
            Position = UDim2.new(0, 8, 0, 0),
            BackgroundTransparency = 1,
            Text = c.icon,
            TextSize = 16,
            Font = Enum.Font.GothamBold,
            TextColor3 = c.accent,
            Parent = banner,
        })

        -- العنوان
        if config.Title then
            NewInst("TextLabel", {
                Size = UDim2.new(1, -40, 0, 18),
                Position = UDim2.new(0, 35, 0, 0),
                BackgroundTransparency = 1,
                Text = config.Title,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextColor3 = c.accent,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = banner,
            })
        end

        -- الرسالة
        if config.Message then
            NewInst("TextLabel", {
                Size = UDim2.new(1, -40, 0, 0),
                Position = UDim2.new(0, 35, 0, config.Title and 20 or 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Text = config.Message,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextColor3 = Color3.fromRGB(220, 220, 220),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = banner,
            })
        end

        local api = {
            __type  = "AlertBanner",
            Banner  = banner,
        }

        -- زر الإغلاق
        if config.Dismissable then
            local closeBtn = NewInst("TextButton", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -20, 0, 0),
                BackgroundTransparency = 1,
                Text = "✕",
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                TextColor3 = Color3.fromRGB(180, 180, 180),
                Parent = banner,
            })

            closeBtn.MouseButton1Click:Connect(function()
                Tween(banner, 0.2, {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                }):Play()
                task.delay(0.22, function() banner:Destroy() end)
            end)
        end

        function api:Dismiss()
            Tween(banner, 0.2, { BackgroundTransparency = 1, Size = UDim2.new(1,0,0,0) }):Play()
            task.delay(0.22, function() banner:Destroy() end)
        end

        function api:Destroy()
            banner:Destroy()
        end

        return api
    end
end

-- ══════════════════════════════════════════════════
-- 🎛️ عنصر MultiToggle - خيارات متعددة من أزرار
-- ══════════════════════════════════════════════════
function Extensions:_AddMultiToggle(WindUI, Section)
    --[[
        الاستخدام:
        local multi = MySection:MultiToggle({
            Title   = "العروض",
            Options = {
                { Text = "ESP",       Value = false },
                { Text = "Aimbot",    Value = false },
                { Text = "Speed",     Value = true  },
            },
            Callback = function(states)
                print("ESP:", states.ESP)
                print("Aimbot:", states.Aimbot)
            end
        })
        multi:SetState("ESP", true)
        local states = multi:GetStates()
    ]]

    return function(self, config)
        config = config or {}

        local options  = config.Options or {}
        local callback = config.Callback or function() end

        local container = NewInst("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Parent = self.UIElements and self.UIElements.Content or self.Parent,
        })

        if config.Title then
            NewInst("TextLabel", {
                Size = UDim2.new(1, 0, 0, 22),
                BackgroundTransparency = 1,
                Text = config.Title,
                TextSize = 14,
                Font = Enum.Font.GothamSemibold,
                TextColor3 = Color3.new(1,1,1),
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = 0,
                Parent = container,
            })
        end

        -- إطار الأزرار
        local btnFrame = NewInst("Frame", {
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            Parent = container,
        })

        NewInst("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 4),
            Parent = btnFrame,
        })

        NewInst("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6),
            Parent = container,
        })

        local states  = {}
        local btnObjs = {}
        local api     = { __type = "MultiToggle", Container = container }

        local function fireCallback()
            local result = {}
            for _, opt in ipairs(options) do
                result[opt.Text] = states[opt.Text]
            end
            task.spawn(function() pcall(callback, result) end)
        end

        local function updateBtn(text, state)
            local obj = btnObjs[text]
            if not obj then return end
            if state then
                Tween(obj.Bg, 0.18, { BackgroundTransparency = 0.05 }):Play()
                Tween(obj.Label, 0.18, { TextColor3 = Color3.new(1,1,1) }):Play()
            else
                Tween(obj.Bg, 0.18, { BackgroundTransparency = 0.75 }):Play()
                Tween(obj.Label, 0.18, { TextColor3 = Color3.fromRGB(150,150,150) }):Play()
            end
        end

        for i, opt in ipairs(options) do
            states[opt.Text] = opt.Value or false

            local count = #options
            local bg = NewInst("Frame", {
                Size = UDim2.new(1 / count, -(4 * (count - 1)) / count, 1, 0),
                BackgroundColor3 = Color3.fromRGB(100, 100, 255),
                BackgroundTransparency = opt.Value and 0.05 or 0.75,
                LayoutOrder = i,
                Parent = btnFrame,
            }, {
                NewInst("UICorner", { CornerRadius = UDim.new(0, 6) }),
            })

            local label = NewInst("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = opt.Text,
                TextSize = 13,
                Font = Enum.Font.GothamSemibold,
                TextColor3 = opt.Value and Color3.new(1,1,1) or Color3.fromRGB(150,150,150),
                Parent = bg,
            })

            local clickBtn = NewInst("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = bg,
            })

            btnObjs[opt.Text] = { Bg = bg, Label = label }

            clickBtn.MouseButton1Click:Connect(function()
                states[opt.Text] = not states[opt.Text]
                updateBtn(opt.Text, states[opt.Text])
                fireCallback()
            end)
        end

        function api:SetState(text, state)
            if states[text] ~= nil then
                states[text] = state
                updateBtn(text, state)
                fireCallback()
            end
        end

        function api:GetStates()
            local result = {}
            for k, v in pairs(states) do result[k] = v end
            return result
        end

        function api:Destroy()
            container:Destroy()
        end

        return api
    end
end

-- ══════════════════════════════════════════════════
-- ⌨️ Hotkey Manager محسّن
-- ══════════════════════════════════════════════════
Extensions.HotkeyManager = {}
Extensions.HotkeyManager.__index = Extensions.HotkeyManager

function Extensions.HotkeyManager.new()
    local self = setmetatable({}, Extensions.HotkeyManager)
    self._binds    = {}
    self._active   = true
    self._conn     = nil

    self._conn = UserInputService.InputBegan:Connect(function(input, gameProc)
        if gameProc or not self._active then return end
        for id, bind in pairs(self._binds) do
            if input.KeyCode == bind.Key then
                task.spawn(function() pcall(bind.Callback) end)
            end
        end
    end)

    return self
end

function Extensions.HotkeyManager:Bind(id, key, callback, description)
    self._binds[id] = {
        Key         = key,
        Callback    = callback,
        Description = description or "",
    }
end

function Extensions.HotkeyManager:Unbind(id)
    self._binds[id] = nil
end

function Extensions.HotkeyManager:SetEnabled(state)
    self._active = state
end

function Extensions.HotkeyManager:GetBinds()
    return self._binds
end

function Extensions.HotkeyManager:Destroy()
    if self._conn then self._conn:Disconnect() end
    self._binds = {}
end

-- ══════════════════════════════════════════════════
-- 🎨 تحسين الـ Button بتأثير Ripple
-- ══════════════════════════════════════════════════
function Extensions:_ApplyRippleToButton(button, color)
    color = color or Color3.fromRGB(255, 255, 255)

    local function createRipple(parent, x, y)
        local absSize = parent.AbsoluteSize
        local absPos  = parent.AbsolutePosition

        local relX = x - absPos.X
        local relY = y - absPos.Y

        local maxDist = math.sqrt(absSize.X^2 + absSize.Y^2)

        local ripple = NewInst("Frame", {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0, relX, 0, relY),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = color,
            BackgroundTransparency = 0.6,
            ZIndex = 10,
            Parent = parent,
        }, {
            NewInst("UICorner", { CornerRadius = UDim.new(1, 0) }),
        })

        local targetSize = maxDist * 2
        Tween(ripple, 0.5, {
            Size = UDim2.new(0, targetSize, 0, targetSize),
            BackgroundTransparency = 1,
        }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Play()

        task.delay(0.5, function()
            ripple:Destroy()
        end)
    end

    button.MouseButton1Down:Connect(function()
        local mouse = UserInputService:GetMouseLocation()
        createRipple(button, mouse.X, mouse.Y)
    end)
end

-- ══════════════════════════════════════════════════
-- 🔧 تطبيق التحسينات على WindUI
-- ══════════════════════════════════════════════════
function Extensions:Apply(WindUI)
    if not WindUI then
        error("Extensions:Apply() - يجب تمرير WindUI كأول معامل")
        return
    end

    -- ── إضافة الثيمات الجديدة ──
    for name, theme in pairs(self.NewThemes) do
        if WindUI.AddTheme then
            WindUI:AddTheme(theme)
        end
    end

    -- ── إضافة Hotkey Manager ──
    WindUI.HotkeyManager = self.HotkeyManager.new()

    -- ── دالة مساعدة: تطبيق العناصر الجديدة على Section/Tab ──
    local ext = self
    local function extendContainer(container)
        if not container then return end

        -- ProgressBar
        if not container.ProgressBar then
            container.ProgressBar = ext:_AddProgressBar(WindUI)
        end

        -- Badge
        if not container.Badge then
            container.Badge = ext:_AddBadge(WindUI)
        end

        -- NumberInput
        if not container.NumberInput then
            container.NumberInput = ext:_AddNumberInput(WindUI)
        end

        -- RadioGroup
        if not container.RadioGroup then
            container.RadioGroup = ext:_AddRadioGroup(WindUI)
        end

        -- AlertBanner
        if not container.AlertBanner then
            container.AlertBanner = ext:_AddAlertBanner(WindUI)
        end

        -- MultiToggle
        if not container.MultiToggle then
            container.MultiToggle = ext:_AddMultiToggle(WindUI)
        end
    end

    -- ── تعديل CreateWindow لتطبيق العناصر تلقائياً ──
    local originalCreateWindow = WindUI.CreateWindow
    WindUI.CreateWindow = function(self, config)
        local window = originalCreateWindow(self, config)
        if window then
            -- تطبيق على Tab الجديد تلقائياً
            local originalTab = window.Tab
            window.Tab = function(self, tabConfig)
                local tab = originalTab(self, tabConfig)
                if tab then
                    local originalSection = tab.Section
                    if originalSection then
                        tab.Section = function(self, secConfig)
                            local section = originalSection(self, secConfig)
                            if section then
                                extendContainer(section)
                            end
                            return section
                        end
                    end
                    extendContainer(tab)
                end
                return tab
            end
        end
        return window
    end

    print("✅ [WindUI Extensions] تم تطبيق التحسينات بنجاح!")
    print("   📦 الثيمات الجديدة: " .. #(function()
        local t = {}
        for k in pairs(self.NewThemes) do t[#t+1] = k end
        return t
    end()) .. " ثيم")
    print("   🎛️ العناصر الجديدة: ProgressBar, Badge, NumberInput, RadioGroup, AlertBanner, MultiToggle")
    print("   ⌨️  Hotkey Manager: متاح على WindUI.HotkeyManager")

    return WindUI
end

-- ══════════════════════════════════════════════════
-- استخدام مستقل بدون Apply (تطبيق يدوي)
-- ══════════════════════════════════════════════════
function Extensions:ExtendSection(section)
    local ext = self
    section.ProgressBar  = ext:_AddProgressBar(nil)
    section.Badge        = ext:_AddBadge(nil)
    section.NumberInput  = ext:_AddNumberInput(nil)
    section.RadioGroup   = ext:_AddRadioGroup(nil)
    section.AlertBanner  = ext:_AddAlertBanner(nil)
    section.MultiToggle  = ext:_AddMultiToggle(nil)
    return section
end

-- ══════════════════════════════════════════════════
-- مثال الاستخدام الكامل (كتعليق للمرجع)
-- ══════════════════════════════════════════════════
--[[

    ═══════════════════════════════════════════════
    مثال كامل على الاستخدام
    ═══════════════════════════════════════════════

    local WindUI     = loadstring(...)()
    local Extensions = loadstring(...)()

    -- تطبيق التحسينات
    Extensions:Apply(WindUI)

    -- إنشاء النافذة بالطريقة العادية
    local Window = WindUI:CreateWindow({
        Title    = "اسم السكريبت",
        SubTitle = "by Dev",
        Theme    = "Midnight",   -- ← أحد الثيمات الجديدة
        -- أو: "Cyberpunk" | "Ocean" | "Forest" | "Crimson" | "Sunset"
    })

    local Tab = Window:Tab({ Title = "الرئيسية", Icon = "home" })

    local Section = Tab:Section({ Title = "إعدادات" })

    -- ── ProgressBar ──
    local myBar = Section:ProgressBar({
        Title    = "صحة اللاعب",
        Value    = 75,
        Color    = "#52b788",
        Animated = true,
    })
    myBar:Set(100)
    myBar:Decrement(30)

    -- ── Badge ──
    Section:Badge({
        Title  = "مستوى الحساب",
        Text   = "VIP",
        Color  = "#9d4edd",
        Style  = "Filled",
    })

    -- ── NumberInput ──
    local numInput = Section:NumberInput({
        Title    = "عدد اللاعبين",
        Value    = 5,
        Min      = 1,
        Max      = 20,
        Step     = 1,
        Callback = function(val) print("القيمة:", val) end,
    })

    -- ── RadioGroup ──
    local radio = Section:RadioGroup({
        Title   = "صعوبة اللعبة",
        Options = { "سهل", "متوسط", "صعب" },
        Default = "متوسط",
        Callback = function(sel) print("الاختيار:", sel) end,
    })

    -- ── AlertBanner ──
    Section:AlertBanner({
        Type    = "warning",
        Title   = "تحذير!",
        Message = "هذا الخيار قد يؤثر على الأداء",
        Dismissable = true,
    })

    -- ── MultiToggle ──
    local multi = Section:MultiToggle({
        Title   = "خصائص مفعّلة",
        Options = {
            { Text = "ESP",    Value = false },
            { Text = "NoFog",  Value = true  },
            { Text = "Bright", Value = false },
        },
        Callback = function(states)
            print("ESP:", states.ESP)
        end,
    })

    -- ── Hotkey ──
    WindUI.HotkeyManager:Bind("toggle", Enum.KeyCode.RightShift, function()
        Window:Toggle()
    end, "فتح/إغلاق النافذة")

]]

return Extensions
