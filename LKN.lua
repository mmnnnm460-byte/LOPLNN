-- NexusCore.lua
-- Library for Roblox UI - Redesigned Version

local NexusCore = {}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Internal Variables
local NexusInstances = {}
local NexusFlags = {}
local NexusSettings = {
    WindowSize = {520, 400},
    TabWidth = 155,
    Theme = "DarkRed"
}

local NexusThemes = {
    DarkRed = {
        Gradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 0, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 10, 10)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 0, 0))
        }),
        Background = Color3.fromRGB(20, 5, 5),
        Stroke = Color3.fromRGB(180, 20, 20),
        Accent = Color3.fromRGB(220, 40, 40),
        Text = Color3.fromRGB(255, 220, 220),
        TextDim = Color3.fromRGB(180, 100, 100)
    },
    Shadow = {
        Gradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 25)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(35, 35, 45)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
        }),
        Background = Color3.fromRGB(20, 20, 30),
        Stroke = Color3.fromRGB(100, 100, 140),
        Accent = Color3.fromRGB(80, 80, 220),
        Text = Color3.fromRGB(230, 230, 255),
        TextDim = Color3.fromRGB(150, 150, 180)
    }
}

-- Helper Functions
local function CreateInstance(className, parent, properties, children)
    local obj = Instance.new(className)
    obj.Parent = parent
    if properties then
        for prop, val in pairs(properties) do
            obj[prop] = val
        end
    end
    if children then
        for _, child in ipairs(children) do
            child.Parent = obj
        end
    end
    return obj
end

local function AddCorner(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or UDim.new(0, 6)
    corner.Parent = obj
    return corner
end

local function AddStroke(obj, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or NexusThemes[NexusSettings.Theme].Stroke
    stroke.Thickness = thickness or 1
    stroke.Parent = obj
    table.insert(NexusInstances, {obj = stroke, type = "Stroke"})
    return stroke
end

local function AddGradient(obj, rotation)
    local grad = Instance.new("UIGradient")
    grad.Color = NexusThemes[NexusSettings.Theme].Gradient
    grad.Rotation = rotation or 45
    grad.Parent = obj
    table.insert(NexusInstances, {obj = grad, type = "Gradient"})
    return grad
end

local function ApplyTheme()
    local theme = NexusThemes[NexusSettings.Theme]
    for _, item in ipairs(NexusInstances) do
        if item.type == "Gradient" then
            item.obj.Color = theme.Gradient
        elseif item.type == "Stroke" then
            item.obj.Color = theme.Stroke
        elseif item.type == "Background" then
            item.obj.BackgroundColor3 = theme.Background
        elseif item.type == "Accent" then
            if item.obj:IsA("Frame") then
                item.obj.BackgroundColor3 = theme.Accent
            else
                item.obj.TextColor3 = theme.Accent
            end
        elseif item.type == "Text" then
            item.obj.TextColor3 = theme.Text
        elseif item.type == "TextDim" then
            item.obj.TextColor3 = theme.TextDim
        end
    end
end

-- Notification System
local NotificationContainer = nil

local function CreateNotificationContainer()
    if NotificationContainer then return end
    local screenGui = CoreGui:FindFirstChild("NexusUI")
    if not screenGui then return end
    NotificationContainer = CreateInstance("Frame", screenGui, {
        Name = "NotificationContainer",
        Size = UDim2.new(0, 280, 1, 0),
        Position = UDim2.new(1, -300, 1, -20),
        AnchorPoint = Vector2.new(0, 1),
        BackgroundTransparency = 1,
        ZIndex = 999
    })
    CreateInstance("UIListLayout", NotificationContainer, {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        VerticalAlignment = Enum.VerticalAlignment.Bottom
    })
end

function NexusCore:Notify(config)
    local title = config.Title or "Notification"
    local description = config.Description or config.Text or ""
    local duration = config.Duration or 5
    local notifType = config.Type or "Info"
    
    if not NotificationContainer then
        CreateNotificationContainer()
    end
    if not NotificationContainer then return end
    
    local colors = {
        Info = Color3.fromRGB(88, 101, 242),
        Success = Color3.fromRGB(82, 75, 87),
        Warning = Color3.fromRGB(255, 193, 7),
        Error = Color3.fromRGB(255, 17, 0)
    }
    local typeColor = colors[notifType] or colors.Info
    
    local frame = CreateInstance("Frame", NotificationContainer, {
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = Color3.fromRGB(12, 2, 2),
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        ClipsDescendants = true
    })
    AddCorner(frame, UDim.new(0, 12))
    local stroke = AddStroke(frame, Color3.fromRGB(180, 20, 20), 2)
    
    CreateInstance("TextLabel", frame, {
        Size = UDim2.new(1, -50, 0, 16),
        Position = UDim2.new(0, 44, 0, 4),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    CreateInstance("TextLabel", frame, {
        Size = UDim2.new(1, -50, 0, 20),
        Position = UDim2.new(0, 44, 0, 15),
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = Color3.fromRGB(180, 180, 180),
        TextSize = 9,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true
    })
    
    local icon = CreateInstance("ImageLabel", frame, {
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(0, 6, 0.5, -20),
        BackgroundTransparency = 1,
        Image = "rbxassetid://113449060491896"
    })
    
    local counter = CreateInstance("TextLabel", frame, {
        Size = UDim2.new(0, 30, 0, 16),
        Position = UDim2.new(1, -35, 0, 4),
        BackgroundTransparency = 1,
        Text = tostring(duration),
        TextColor3 = typeColor,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    
    frame.Position = UDim2.new(1, 50, 0, 0)
    TweenService:Create(frame, TweenInfo.new(0.4), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    
    local function remove()
        TweenService:Create(frame, TweenInfo.new(0.3), {Position = UDim2.new(1, 50, 0, 0)}):Play()
        TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
        task.wait(0.3)
        frame:Destroy()
    end
    
    if duration > 0 then
        task.spawn(function()
            local timeLeft = duration
            while timeLeft > 0 do
                task.wait(0.1)
                timeLeft = timeLeft - 0.1
                counter.Text = string.format("%.1f", timeLeft)
            end
            remove()
        end)
    end
    
    return {Remove = remove}
end

-- Main Window Function
function NexusCore:CreateWindow(config)
    local winTitle = config.Title or "Nexus Hub"
    local winSubtitle = config.Subtitle or "Advanced UI"
    local saveFile = config.SaveFile or false
    
    -- Load saved settings
    if saveFile and readfile and isfile and isfile(saveFile) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(saveFile))
        end)
        if success and type(data) == "table" then
            if data.WindowSize then NexusSettings.WindowSize = data.WindowSize end
            if data.TabWidth then NexusSettings.TabWidth = data.TabWidth end
            if data.Theme and NexusThemes[data.Theme] then NexusSettings.Theme = data.Theme end
            if data.Flags then
                for k, v in pairs(data.Flags) do
                    NexusFlags[k] = v
                end
            end
        end
    end
    
    -- Create ScreenGui
    local screenGui = CreateInstance("ScreenGui", CoreGui, {Name = "NexusUI"})
    local existing = CoreGui:FindFirstChild("NexusUI")
    if existing and existing ~= screenGui then existing:Destroy() end
    
    local uiScale = CreateInstance("UIScale", screenGui, {Scale = 1})
    
    -- Main Window Frame
    local window = CreateInstance("ImageButton", screenGui, {
        Size = UDim2.fromOffset(NexusSettings.WindowSize[1], NexusSettings.WindowSize[2]),
        Position = UDim2.new(0.5, -NexusSettings.WindowSize[1]/2, 0.5, -NexusSettings.WindowSize[2]/2),
        BackgroundTransparency = 0.15,
        Name = "MainWindow",
        AutoButtonColor = false,
        Active = true
    })
    AddGradient(window, 45)
    AddCorner(window, UDim.new(0, 8))
    table.insert(NexusInstances, {obj = window, type = "Background"})
    
    -- Dragging
    local dragStart, startPos, dragging = nil, nil, false
    window.MouseButton1Down:Connect(function()
        dragging = true
        startPos = window.Position
        dragStart = UserInputService:GetMouseLocation()
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging then
            local delta = UserInputService:GetMouseLocation() - dragStart
            window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Top Bar
    local topBar = CreateInstance("Frame", window, {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        Name = "TopBar"
    })
    
    local titleLabel = CreateInstance("TextLabel", topBar, {
        Position = UDim2.new(0, 15, 0.5),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.XY,
        Text = winTitle,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        BackgroundTransparency = 1
    })
    table.insert(NexusInstances, {obj = titleLabel, type = "Text"})
    
    local subtitleLabel = CreateInstance("TextLabel", titleLabel, {
        Position = UDim2.new(1, 5, 0.9),
        AnchorPoint = Vector2.new(0, 1),
        Size = UDim2.new(0, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Text = winSubtitle,
        TextSize = 9,
        Font = Enum.Font.Gotham,
        BackgroundTransparency = 1
    })
    table.insert(NexusInstances, {obj = subtitleLabel, type = "TextDim"})
    
    -- Close Button
    local closeBtn = CreateInstance("ImageButton", topBar, {
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(1, -10, 0.5),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://10747384394"
    })
    
    -- Minimize Button
    local minBtn = CreateInstance("ImageButton", topBar, {
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(1, -35, 0.5),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://10734896206"
    })
    
    -- Tab Panel
    local tabPanel = CreateInstance("ScrollingFrame", window, {
        Size = UDim2.new(0, NexusSettings.TabWidth, 1, -28),
        Position = UDim2.new(0, 0, 1, 0),
        AnchorPoint = Vector2.new(0, 1),
        ScrollBarThickness = 1.5,
        BackgroundTransparency = 1,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
        ScrollingDirection = Enum.ScrollingDirection.Y,
        BorderSizePixel = 0
    })
    CreateInstance("UIPadding", tabPanel, {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 10)})
    CreateInstance("UIListLayout", tabPanel, {Padding = UDim.new(0, 5)})
    table.insert(NexusInstances, {obj = tabPanel, type = "ScrollBar"})
    
    -- Content Panel
    local contentPanel = CreateInstance("Frame", window, {
        Size = UDim2.new(1, -NexusSettings.TabWidth, 1, -28),
        Position = UDim2.new(1, 0, 1, 0),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1,
        ClipsDescendants = true
    })
    
    -- Resize Handles
    local resizeHandleX = CreateInstance("ImageButton", window, {
        Size = UDim2.new(0, 35, 0, 35),
        Position = window.Size,
        AnchorPoint = Vector2.new(0.8, 0.8),
        BackgroundTransparency = 1,
        Active = true
    })
    local resizeHandleY = CreateInstance("ImageButton", window, {
        Size = UDim2.new(0, 20, 1, -30),
        Position = UDim2.new(0, NexusSettings.TabWidth, 1, 0),
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundTransparency = 1,
        Active = true
    })
    
    local function updateSizes()
        tabPanel.Size = UDim2.new(0, math.clamp(resizeHandleY.Position.X.Offset, 120, 250), 1, -28)
        contentPanel.Size = UDim2.new(1, -tabPanel.Size.X.Offset, 1, -28)
        window.Size = resizeHandleX.Position
        NexusSettings.WindowSize = {window.Size.X.Offset, window.Size.Y.Offset}
        NexusSettings.TabWidth = tabPanel.Size.X.Offset
    end
    
    resizeHandleX:GetPropertyChangedSignal("Position"):Connect(updateSizes)
    resizeHandleY:GetPropertyChangedSignal("Position"):Connect(updateSizes)
    updateSizes()
    
    -- Particle System
    local particleContainer = CreateInstance("Frame", contentPanel, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = -5,
        ClipsDescendants = true
    })
    
    local particles = {}
    local lastSpawn = 0
    
    RunService.Heartbeat:Connect(function()
        for i = #particles, 1, -1 do
            local p = particles[i]
            if not p.Frame or not p.Frame.Parent then
                table.remove(particles, i)
            else
                p.Frame.Position = UDim2.new(p.Frame.Position.X.Scale, p.Frame.Position.X.Offset, p.Frame.Position.Y.Scale, p.Frame.Position.Y.Offset - p.Speed * 0.016)
                if p.Frame.Position.Y.Offset < -50 then
                    p.Frame:Destroy()
                    table.remove(particles, i)
                end
            end
        end
        
        if tick() - lastSpawn > 0.1 and #particles < 30 then
            lastSpawn = tick()
            local size = math.random(4, 8)
            local particle = CreateInstance("Frame", particleContainer, {
                Size = UDim2.fromOffset(size, size),
                Position = UDim2.fromOffset(math.random(10, contentPanel.AbsoluteSize.X - 10), contentPanel.AbsoluteSize.Y + 20),
                BackgroundColor3 = NexusThemes[NexusSettings.Theme].Accent,
                BackgroundTransparency = 0.3
            })
            AddCorner(particle, UDim.new(0.5, 0))
            table.insert(particles, {Frame = particle, Speed = math.random(10, 20)})
        end
    end)
    
    -- Tab Management
    local tabs = {}
    local currentTab = nil
    local tabButtons = {}
    
    -- Helper for creating option rows
    local function createOptionRow(parent, title, desc)
        local row = CreateInstance("Frame", parent, {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = NexusThemes[NexusSettings.Theme].Background,
            AutomaticSize = Enum.AutomaticSize.Y,
            Name = "Option"
        })
        AddCorner(row, UDim.new(0, 6))
        AddStroke(row)
        table.insert(NexusInstances, {obj = row, type = "Background"})
        
        local titleLabel = CreateInstance("TextLabel", row, {
            Position = UDim2.new(0, 10, 0.5),
            AnchorPoint = Vector2.new(0, 0.5),
            Size = UDim2.new(1, -20, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Text = title,
            TextSize = 11,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd
        })
        table.insert(NexusInstances, {obj = titleLabel, type = "Text"})
        
        local descLabel = CreateInstance("TextLabel", row, {
            Position = UDim2.new(0, 12, 0, 15),
            Size = UDim2.new(1, -20, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Text = desc,
            TextSize = 9,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Visible = desc and desc ~= ""
        })
        table.insert(NexusInstances, {obj = descLabel, type = "TextDim"})
        
        if desc == "" or not desc then
            descLabel.Visible = false
            titleLabel.Position = UDim2.new(0, 10, 0.5)
        else
            titleLabel.Position = UDim2.new(0, 10, 0.3)
        end
        
        return row, {SetTitle = function(t) titleLabel.Text = t end, SetDesc = function(d) 
            descLabel.Text = d 
            descLabel.Visible = d and d ~= ""
            if d and d ~= "" then
                titleLabel.Position = UDim2.new(0, 10, 0.3)
            else
                titleLabel.Position = UDim2.new(0, 10, 0.5)
            end
        end}
    end
    
    -- Create Tab Function
    local function createTab(tabName, tabIcon)
        local tabBtn = CreateInstance("TextButton", tabPanel, {
            Size = UDim2.new(1, 0, 0, 24),
            Text = "",
            BackgroundColor3 = NexusThemes[NexusSettings.Theme].Background,
            AutoButtonColor = false
        })
        AddCorner(tabBtn, UDim.new(0, 6))
        table.insert(NexusInstances, {obj = tabBtn, type = "Background"})
        
        local iconImg = nil
        if tabIcon and tabIcon ~= "" then
            iconImg = CreateInstance("ImageLabel", tabBtn, {
                Position = UDim2.new(0, 8, 0.5),
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 13, 0, 13),
                Image = tabIcon,
                BackgroundTransparency = 1
            })
            table.insert(NexusInstances, {obj = iconImg, type = "Text"})
        end
        
        local label = CreateInstance("TextLabel", tabBtn, {
            Position = UDim2.new(iconImg and 25 or 15, 0, 0.5),
            AnchorPoint = Vector2.new(0, 0.5),
            Size = UDim2.new(1, iconImg and -25 or -15, 1),
            BackgroundTransparency = 1,
            Text = tabName,
            TextSize = 10,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd
        })
        table.insert(NexusInstances, {obj = label, type = "Text"})
        
        local indicator = CreateInstance("Frame", tabBtn, {
            Position = UDim2.new(0, 1, 0.5),
            AnchorPoint = Vector2.new(0, 0.5),
            Size = UDim2.new(0, 4, 0, 4),
            BackgroundColor3 = NexusThemes[NexusSettings.Theme].Accent
        })
        AddCorner(indicator, UDim.new(0.5, 0))
        table.insert(NexusInstances, {obj = indicator, type = "Accent"})
        
        local container = CreateInstance("ScrollingFrame", contentPanel, {
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 1, 0),
            AnchorPoint = Vector2.new(0, 1),
            ScrollBarThickness = 1.5,
            BackgroundTransparency = 1,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(),
            ScrollingDirection = Enum.ScrollingDirection.Y,
            BorderSizePixel = 0,
            Visible = false
        })
        CreateInstance("UIPadding", container, {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10)})
        CreateInstance("UIListLayout", container, {Padding = UDim.new(0, 5)})
        table.insert(NexusInstances, {obj = container, type = "ScrollBar"})
        
        tabBtn.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.container.Visible = false
                if currentTab.indicator then
                    TweenService:Create(currentTab.indicator, TweenInfo.new(0.2), {Size = UDim2.new(0, 4, 0, 4)}):Play()
                end
            end
            container.Visible = true
            TweenService:Create(indicator, TweenInfo.new(0.2), {Size = UDim2.new(0, 4, 0, 12)}):Play()
            currentTab = {container = container, indicator = indicator}
        end)
        
        if #tabs == 0 then
            tabBtn.MouseButton1Click:Fire()
        end
        
        local tabObj = {
            container = container,
            AddSection = function(sectionConfig)
                local sectionName = type(sectionConfig) == "string" and sectionConfig or sectionConfig.Title or "Section"
                local sectionFrame = CreateInstance("Frame", container, {
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1
                })
                local sectionLabel = CreateInstance("TextLabel", sectionFrame, {
                    Position = UDim2.new(0, 30, 0.5),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(1, -25, 1, 0),
                    BackgroundTransparency = 1,
                    Text = sectionName,
                    TextSize = 11,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd
                })
                table.insert(NexusInstances, {obj = sectionLabel, type = "TextDim"})
                return {
                    Set = function(newName) sectionLabel.Text = newName end,
                    Destroy = function() sectionFrame:Destroy() end,
                    Visible = function(bool) sectionFrame.Visible = bool end
                }
            end,
            AddParagraph = function(paraConfig)
                local title = paraConfig.Title or "Paragraph"
                local text = paraConfig.Text or ""
                local row, labels = createOptionRow(container, title, text)
                return {
                    SetTitle = labels.SetTitle,
                    SetDesc = labels.SetDesc,
                    Destroy = function() row:Destroy() end,
                    Visible = function(bool) row.Visible = bool end
                }
            end,
            AddButton = function(btnConfig)
                local title = btnConfig.Title or "Button"
                local desc = btnConfig.Desc or ""
                local callback = btnConfig.Callback or function() end
                local row, labels = createOptionRow(container, title, desc)
                local btn = CreateInstance("TextButton", row, {
                    Size = UDim2.new(0, 60, 0, 20),
                    Position = UDim2.new(1, -10, 0.5),
                    AnchorPoint = Vector2.new(1, 0.5),
                    Text = "Execute",
                    TextSize = 9,
                    Font = Enum.Font.GothamBold,
                    BackgroundColor3 = NexusThemes[NexusSettings.Theme].Accent,
                    TextColor3 = NexusThemes[NexusSettings.Theme].Text,
                    AutoButtonColor = false
                })
                AddCorner(btn, UDim.new(0, 4))
                table.insert(NexusInstances, {obj = btn, type = "Accent"})
                btn.MouseButton1Click:Connect(callback)
                return {
                    Set = function(newTitle, newDesc) 
                        if newTitle then labels.SetTitle(newTitle) end
                        if newDesc then labels.SetDesc(newDesc) end
                    end,
                    Destroy = function() row:Destroy() end,
                    Visible = function(bool) row.Visible = bool end
                }
            end,
            AddToggle = function(togConfig)
                local title = togConfig.Title or "Toggle"
                local desc = togConfig.Desc or ""
                local flag = togConfig.Flag
                local default = togConfig.Default or false
                local callback = togConfig.Callback or function() end
                
                if flag and NexusFlags[flag] ~= nil then
                    default = NexusFlags[flag]
                end
                
                local row, labels = createOptionRow(container, title, desc)
                local toggleHolder = CreateInstance("Frame", row, {
                    Size = UDim2.new(0, 35, 0, 18),
                    Position = UDim2.new(1, -10, 0.5),
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = NexusThemes[NexusSettings.Theme].Stroke
                })
                AddCorner(toggleHolder, UDim.new(0.5, 0))
                table.insert(NexusInstances, {obj = toggleHolder, type = "Stroke"})
                
                local toggleSlider = CreateInstance("Frame", toggleHolder, {
                    Size = UDim2.new(0, 12, 0, 12),
                    Position = UDim2.new(default and 1 or 0, 0, 0.5),
                    AnchorPoint = Vector2.new(default and 1 or 0, 0.5),
                    BackgroundColor3 = NexusThemes[NexusSettings.Theme].Accent
                })
                AddCorner(toggleSlider, UDim.new(0.5, 0))
                table.insert(NexusInstances, {obj = toggleSlider, type = "Accent"})
                
                local function setToggle(value)
                    default = value
                    if flag then NexusFlags[flag] = value end
                    callback(value)
                    local targetPos = value and 1 or 0
                    TweenService:Create(toggleSlider, TweenInfo.new(0.2), {
                        Position = UDim2.new(targetPos, 0, 0.5),
                        AnchorPoint = Vector2.new(targetPos, 0.5)
                    }):Play()
                end
                
                row.MouseButton1Click:Connect(function()
                    setToggle(not default)
                end)
                
                setToggle(default)
                
                return {
                    Set = function(newTitle, newDesc, newValue)
                        if newTitle and newDesc then
                            labels.SetTitle(newTitle)
                            labels.SetDesc(newDesc)
                        elseif newTitle then
                            labels.SetTitle(newTitle)
                        elseif type(newValue) == "boolean" then
                            setToggle(newValue)
                        end
                    end,
                    Destroy = function() row:Destroy() end,
                    Visible = function(bool) row.Visible = bool end
                }
            end,
            AddDropdown = function(dropConfig)
                local title = dropConfig.Title or "Dropdown"
                local desc = dropConfig.Desc or ""
                local options = dropConfig.Options or {}
                local default = dropConfig.Default or (type(options[1]) == "table" and options[1].Value or options[1]) or ""
                local multi = dropConfig.MultiSelect or false
                local flag = dropConfig.Flag
                local callback = dropConfig.Callback or function() end
                
                if flag and NexusFlags[flag] ~= nil then
                    default = NexusFlags[flag]
                end
                
                local row, labels = createOptionRow(container, title, desc)
                local selectedFrame = CreateInstance("Frame", row, {
                    Size = UDim2.new(0, 130, 0, 18),
                    Position = UDim2.new(1, -10, 0.5),
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = NexusThemes[NexusSettings.Theme].Stroke
                })
                AddCorner(selectedFrame, UDim.new(0, 4))
                table.insert(NexusInstances, {obj = selectedFrame, type = "Stroke"})
                
                local selectedText = CreateInstance("TextLabel", selectedFrame, {
                    Size = UDim2.new(0.85, 0, 0.85, 0),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Text = default,
                    TextSize = 9,
                    Font = Enum.Font.GothamBold,
                    TextScaled = true
                })
                table.insert(NexusInstances, {obj = selectedText, type = "Text"})
                
                local arrow = CreateInstance("ImageLabel", selectedFrame, {
                    Size = UDim2.new(0, 12, 0, 12),
                    Position = UDim2.new(0, -5, 0.5),
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = "rbxassetid://10709791523",
                    BackgroundTransparency = 1
                })
                
                local dropdownOpen = false
                local dropdownFrame = nil
                local backdrop = nil
                
                local function closeDropdown()
                    if dropdownFrame then
                        TweenService:Create(dropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 134, 0, 0)}):Play()
                        if backdrop then backdrop.Visible = false end
                        dropdownOpen = false
                    end
                end
                
                selectedFrame.MouseButton1Click:Connect(function()
                    if dropdownOpen then
                        closeDropdown()
                        return
                    end
                    
                    if not backdrop then
                        backdrop = CreateInstance("TextButton", screenGui, {
                            Size = UDim2.new(1, 0, 1, 0),
                            BackgroundTransparency = 1,
                            Text = "",
                            Visible = false
                        })
                        backdrop.MouseButton1Click:Connect(closeDropdown)
                    end
                    
                    backdrop.Visible = true
                    
                    dropdownFrame = CreateInstance("Frame", backdrop, {
                        Size = UDim2.new(0, 134, 0, 0),
                        BackgroundColor3 = NexusThemes[NexusSettings.Theme].Background,
                        ClipsDescendants = true
                    })
                    AddCorner(dropdownFrame, UDim.new(0, 6))
                    AddStroke(dropdownFrame)
                    table.insert(NexusInstances, {obj = dropdownFrame, type = "Background"})
                    
                    local scroll = CreateInstance("ScrollingFrame", dropdownFrame, {
                        Size = UDim2.new(1, 0, 1, 0),
                        ScrollBarThickness = 1.5,
                        BackgroundTransparency = 1,
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        CanvasSize = UDim2.new(),
                        ScrollingDirection = Enum.ScrollingDirection.Y,
                        BorderSizePixel = 0
                    })
                    CreateInstance("UIListLayout", scroll, {Padding = UDim.new(0, 2)})
                    CreateInstance("UIPadding", scroll, {PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4)})
                    
                    for _, opt in ipairs(options) do
                        local optName = type(opt) == "table" and opt.Name or opt
                        local optValue = type(opt) == "table" and opt.Value or opt
                        local optBtn = CreateInstance("TextButton", scroll, {
                            Size = UDim2.new(1, -8, 0, 22),
                            Text = optName,
                            TextSize = 9,
                            Font = Enum.Font.Gotham,
                            BackgroundColor3 = NexusThemes[NexusSettings.Theme].Background,
                            AutoButtonColor = false
                        })
                        AddCorner(optBtn, UDim.new(0, 4))
                        table.insert(NexusInstances, {obj = optBtn, type = "Background"})
                        
                        optBtn.MouseButton1Click:Connect(function()
                            selectedText.Text = optName
                            if flag then NexusFlags[flag] = optValue end
                            callback(optValue)
                            closeDropdown()
                        end)
                    end
                    
                    local pos = selectedFrame.AbsolutePosition
                    local size = selectedFrame.AbsoluteSize
                    dropdownFrame.Position = UDim2.fromOffset(pos.X, pos.Y + size.Y)
                    TweenService:Create(dropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 134, 0, math.min(200, scroll.AbsoluteContentSize.Y + 10))}):Play()
                    dropdownOpen = true
                end)
                
                return {
                    Set = function(newTitle, newDesc, newOptions)
                        if newTitle and newDesc then
                            labels.SetTitle(newTitle)
                            labels.SetDesc(newDesc)
                        elseif newTitle then
                            labels.SetTitle(newTitle)
                        elseif newOptions then
                            -- Would need full rebuild, skip for brevity
                        end
                    end,
                    Destroy = function() row:Destroy() end,
                    Visible = function(bool) row.Visible = bool end
                }
            end,
            AddSlider = function(sliderConfig)
                local title = sliderConfig.Title or "Slider"
                local desc = sliderConfig.Desc or ""
                local min = sliderConfig.Min or 0
                local max = sliderConfig.Max or 100
                local default = sliderConfig.Default or 50
                local flag = sliderConfig.Flag
                local callback = sliderConfig.Callback or function() end
                
                if flag and NexusFlags[flag] ~= nil then
                    default = NexusFlags[flag]
                end
                
                local row, labels = createOptionRow(container, title, desc)
                local valueLabel = CreateInstance("TextLabel", row, {
                    Position = UDim2.new(1, -50, 0.5),
                    AnchorPoint = Vector2.new(1, 0.5),
                    Size = UDim2.new(0, 35, 0, 14),
                    BackgroundTransparency = 1,
                    Text = tostring(default),
                    TextSize = 10,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                table.insert(NexusInstances, {obj = valueLabel, type = "Text"})
                
                local sliderBar = CreateInstance("Frame", row, {
                    Size = UDim2.new(0, 120, 0, 4),
                    Position = UDim2.new(1, -120, 0.5),
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = NexusThemes[NexusSettings.Theme].Stroke
                })
                AddCorner(sliderBar, UDim.new(0.5, 0))
                table.insert(NexusInstances, {obj = sliderBar, type = "Stroke"})
                
                local fill = CreateInstance("Frame", sliderBar, {
                    Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                    BackgroundColor3 = NexusThemes[NexusSettings.Theme].Accent
                })
                AddCorner(fill, UDim.new(0.5, 0))
                table.insert(NexusInstances, {obj = fill, type = "Accent"})
                
                local knob = CreateInstance("Frame", sliderBar, {
                    Size = UDim2.new(0, 8, 0, 12),
                    Position = UDim2.new((default - min) / (max - min), 0, 0.5),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = NexusThemes[NexusSettings.Theme].Accent
                })
                AddCorner(knob, UDim.new(0.5, 0))
                table.insert(NexusInstances, {obj = knob, type = "Accent"})
                
                local dragging = false
                local function updateSlider(input)
                    local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + (max - min) * pos)
                    fill.Size = UDim2.new(pos, 0, 1, 0)
                    knob.Position = UDim2.new(pos, 0, 0.5)
                    valueLabel.Text = tostring(value)
                    if flag then NexusFlags[flag] = value end
                    callback(value)
                end
                
                sliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        updateSlider(input)
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                return {
                    Set = function(newTitle, newDesc, newValue)
                        if newTitle and newDesc then
                            labels.SetTitle(newTitle)
                            labels.SetDesc(newDesc)
                        elseif newTitle then
                            labels.SetTitle(newTitle)
                        elseif type(newValue) == "number" then
                            local pos = (newValue - min) / (max - min)
                            fill.Size = UDim2.new(pos, 0, 1, 0)
                            knob.Position = UDim2.new(pos, 0, 0.5)
                            valueLabel.Text = tostring(newValue)
                            callback(newValue)
                        end
                    end,
                    Destroy = function() row:Destroy() end,
                    Visible = function(bool) row.Visible = bool end
                }
            end,
            AddTextbox = function(textConfig)
                local title = textConfig.Title or "Text Box"
                local desc = textConfig.Desc or ""
                local placeholder = textConfig.Placeholder or "Input..."
                local callback = textConfig.Callback or function() end
                
                local row, labels = createOptionRow(container, title, desc)
                local textBox = CreateInstance("TextBox", row, {
                    Size = UDim2.new(0, 130, 0, 20),
                    Position = UDim2.new(1, -10, 0.5),
                    AnchorPoint = Vector2.new(1, 0.5),
                    PlaceholderText = placeholder,
                    Text = "",
                    TextSize = 9,
                    Font = Enum.Font.Gotham,
                    BackgroundColor3 = NexusThemes[NexusSettings.Theme].Stroke,
                    TextColor3 = NexusThemes[NexusSettings.Theme].Text,
                    ClearTextOnFocus = true
                })
                AddCorner(textBox, UDim.new(0, 4))
                table.insert(NexusInstances, {obj = textBox, type = "Text"})
                table.insert(NexusInstances, {obj = textBox, type = "Stroke"})
                
                textBox.FocusLost:Connect(function()
                    if textBox.Text ~= "" then
                        callback(textBox.Text)
                    end
                end)
                
                return {
                    Set = function(newTitle, newDesc)
                        if newTitle then labels.SetTitle(newTitle) end
                        if newDesc then labels.SetDesc(newDesc) end
                    end,
                    Destroy = function() row:Destroy() end,
                    Visible = function(bool) row.Visible = bool end
                }
            end
        }
        
        table.insert(tabs, tabObj)
        return tabObj
    end
    
    -- Window Controls
    local minimized = false
    local savedSize = nil
    
    minBtn.MouseButton1Click:Connect(function()
        if minimized then
            minBtn.Image = "rbxassetid://10734896206"
            TweenService:Create(window, TweenInfo.new(0.25), {Size = savedSize}):Play()
            resizeHandleX.Visible = true
            resizeHandleY.Visible = true
            minimized = false
        else
            minBtn.Image = "rbxassetid://10734924532"
            savedSize = window.Size
            resizeHandleX.Visible = false
            resizeHandleY.Visible = false
            TweenService:Create(window, TweenInfo.new(0.25), {Size = UDim2.fromOffset(window.Size.X.Offset, 28)}):Play()
            minimized = true
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        NexusCore:Notify({Title = "Closed", Description = "UI has been closed", Duration = 2})
        screenGui:Destroy()
    end)
    
    -- Save on close (if saveFile)
    if saveFile and writefile then
        screenGui.AncestryChanged:Connect(function()
            if not screenGui.Parent then
                local saveData = {
                    WindowSize = NexusSettings.WindowSize,
                    TabWidth = NexusSettings.TabWidth,
                    Theme = NexusSettings.Theme,
                    Flags = NexusFlags
                }
                pcall(function()
                    writefile(saveFile, HttpService:JSONEncode(saveData))
                end)
            end
        end)
    end
    
    return {
        CreateTab = createTab,
        Notify = NexusCore.Notify,
        SetTheme = function(themeName)
            if NexusThemes[themeName] then
                NexusSettings.Theme = themeName
                ApplyTheme()
            end
        end
    }
end

return NexusCore