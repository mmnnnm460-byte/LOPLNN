local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StatsCard"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = player:WaitForChild("PlayerGui")

local CARD_WIDTH = 256
local CARD_HEIGHT = 300
local BASE_CARD_HEIGHT = CARD_HEIGHT
local MAX_CARD_HEIGHT = 460

local card = Instance.new("Frame")
card.Name = "Card"
card.Size = UDim2.fromOffset(CARD_WIDTH, CARD_HEIGHT)
card.Position = UDim2.fromScale(0.02, 0.1)
card.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
card.BorderSizePixel = 0
card.ClipsDescendants = true
card.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = card

local cardShadow = Instance.new("UIShadow")
cardShadow.Color = Color3.fromRGB(0, 0, 0)
cardShadow.Transparency = 0.55
cardShadow.BlurRadius = UDim.new(0, 18)
cardShadow.Offset = UDim2.fromOffset(0, 6)
cardShadow.Parent = card

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.25
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = card

local strokeGradient = Instance.new("UIGradient")
strokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120,120,135)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120,120,135)),
})
strokeGradient.Parent = stroke

task.spawn(function()
    local rot = 0
    while card.Parent do
        rot = (rot + 1) % 360
        strokeGradient.Rotation = rot
        task.wait(0.03)
    end
end)

local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(26,26,31)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(14,14,17)),
})
bgGradient.Rotation = 90
bgGradient.Parent = card

local TAB_TOP = 10
local TAB_HEIGHT = 32
local CONTENT_TOP = 52
local TAB_CONTENT_HEIGHT = 248

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.fromOffset(CARD_WIDTH - 20, TAB_HEIGHT)
tabBar.Position = UDim2.fromOffset(10, TAB_TOP)
tabBar.BackgroundColor3 = Color3.fromRGB(14, 14, 17)
tabBar.BorderSizePixel = 0
tabBar.Parent = card

local tabBarCorner = Instance.new("UICorner")
tabBarCorner.CornerRadius = UDim.new(0, 10)
tabBarCorner.Parent = tabBar

local TAB_PAD = 3
local TAB_BTN_W = 74

local indicator = Instance.new("Frame")
indicator.Size = UDim2.fromOffset(TAB_BTN_W, TAB_HEIGHT - TAB_PAD*2)
indicator.Position = UDim2.fromOffset(TAB_PAD, TAB_PAD)
indicator.BackgroundColor3 = Color3.fromRGB(40, 40, 47)
indicator.BorderSizePixel = 0
indicator.Parent = tabBar

local indicatorCorner = Instance.new("UICorner")
indicatorCorner.CornerRadius = UDim.new(0, 8)
indicatorCorner.Parent = indicator

local indicatorStroke = Instance.new("UIStroke")
indicatorStroke.Thickness = 1
indicatorStroke.Color = Color3.fromRGB(255,255,255)
indicatorStroke.Transparency = 0.85
indicatorStroke.Parent = indicator

local function createTabButton(text, xPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(TAB_BTN_W, TAB_HEIGHT)
    btn.Position = UDim2.fromOffset(xPos, 0)
    btn.BackgroundTransparency = 1
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(140,140,150)
    btn.ZIndex = 2
    btn.Parent = tabBar
    return btn
end

local tabBtnPlayer  = createTabButton("PLAYER",  TAB_PAD)
tabBtnPlayer.TextColor3 = Color3.fromRGB(255,255,255)
local tabBtnPlayers = createTabButton("PLAYERS", TAB_PAD*2 + TAB_BTN_W)
local tabBtnServer  = createTabButton("SERVER",  TAB_PAD*3 + TAB_BTN_W*2)

local PlayerTab = Instance.new("Frame")
PlayerTab.Name = "PlayerTab"
PlayerTab.Size = UDim2.new(1, 0, 0, TAB_CONTENT_HEIGHT)
PlayerTab.Position = UDim2.fromOffset(0, CONTENT_TOP)
PlayerTab.BackgroundTransparency = 1
PlayerTab.Parent = card

local PlayersTab = Instance.new("Frame")
PlayersTab.Name = "PlayersTab"
PlayersTab.Size = UDim2.new(1, 0, 0, 600)
PlayersTab.Position = UDim2.fromOffset(CARD_WIDTH, CONTENT_TOP)
PlayersTab.BackgroundTransparency = 1
PlayersTab.Parent = card

local ServerTab = Instance.new("Frame")
ServerTab.Name = "ServerTab"
ServerTab.Size = UDim2.new(1, 0, 0, TAB_CONTENT_HEIGHT)
ServerTab.Position = UDim2.fromOffset(CARD_WIDTH * 2, CONTENT_TOP)
ServerTab.BackgroundTransparency = 1
ServerTab.Parent = card

local avatar = Instance.new("ImageLabel")
avatar.Name = "Avatar"
avatar.Size = UDim2.fromOffset(44, 44)
avatar.Position = UDim2.fromOffset(12, 12)
avatar.BackgroundColor3 = Color3.fromRGB(36,36,42)
avatar.Parent = PlayerTab

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = avatar

local avatarStroke = Instance.new("UIStroke")
avatarStroke.Thickness = 1.25
avatarStroke.Color = Color3.fromRGB(255,255,255)
avatarStroke.Transparency = 0.55
avatarStroke.Parent = avatar

avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"

local onlineDot = Instance.new("Frame")
onlineDot.Size = UDim2.fromOffset(11, 11)
onlineDot.Position = UDim2.fromOffset(33, 33)
onlineDot.BackgroundColor3 = Color3.fromRGB(90, 220, 130)
onlineDot.BorderSizePixel = 0
onlineDot.ZIndex = 2
onlineDot.Parent = avatar

local onlineDotCorner = Instance.new("UICorner")
onlineDotCorner.CornerRadius = UDim.new(1, 0)
onlineDotCorner.Parent = onlineDot

local onlineDotStroke = Instance.new("UIStroke")
onlineDotStroke.Thickness = 2
onlineDotStroke.Color = Color3.fromRGB(20,20,24)
onlineDotStroke.Parent = onlineDot

local displayName = Instance.new("TextLabel")
displayName.Name = "DisplayName"
displayName.BackgroundTransparency = 1
displayName.Position = UDim2.fromOffset(64, 13)
displayName.Size = UDim2.fromOffset(180, 18)
displayName.Font = Enum.Font.GothamBold
displayName.TextSize = 14
displayName.TextColor3 = Color3.fromRGB(255,255,255)
displayName.TextXAlignment = Enum.TextXAlignment.Left
displayName.TextTruncate = Enum.TextTruncate.AtEnd
displayName.Text = player.DisplayName
displayName.Parent = PlayerTab

local username = Instance.new("TextLabel")
username.Name = "Username"
username.BackgroundTransparency = 1
username.Position = UDim2.fromOffset(64, 32)
username.Size = UDim2.fromOffset(180, 15)
username.Font = Enum.Font.Gotham
username.TextSize = 11
username.TextColor3 = Color3.fromRGB(145,145,155)
username.TextXAlignment = Enum.TextXAlignment.Left
username.TextTruncate = Enum.TextTruncate.AtEnd
username.Text = "@" .. player.Name
username.Parent = PlayerTab

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -24, 0, 1)
divider.Position = UDim2.fromOffset(12, 66)
divider.BackgroundColor3 = Color3.fromRGB(255,255,255)
divider.BorderSizePixel = 0
divider.Parent = PlayerTab

local dividerGradient = Instance.new("UIGradient")
dividerGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0.88),
    NumberSequenceKeypoint.new(1, 1),
})
dividerGradient.Parent = divider

local function createStatBox(parent, xPos, yPos, width, height, label, accentColor)
    local box = Instance.new("Frame")
    box.Size = UDim2.fromOffset(width, height)
    box.Position = UDim2.fromOffset(xPos, yPos)
    box.BackgroundColor3 = Color3.fromRGB(27,27,32)
    box.Parent = parent

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 10)
    boxCorner.Parent = box

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Thickness = 1
    boxStroke.Color = accentColor
    boxStroke.Transparency = 0.82
    boxStroke.Parent = box

    local boxShadow = Instance.new("UIShadow")
    boxShadow.Color = Color3.fromRGB(0,0,0)
    boxShadow.Transparency = 0.75
    boxShadow.BlurRadius = UDim.new(0, 8)
    boxShadow.Offset = UDim2.fromOffset(0, 2)
    boxShadow.Parent = box

    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(5, 5)
    dot.Position = UDim2.fromOffset(9, 9)
    dot.BackgroundColor3 = accentColor
    dot.BorderSizePixel = 0
    dot.Parent = box

    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dot

    local labelText = Instance.new("TextLabel")
    labelText.BackgroundTransparency = 1
    labelText.Size = UDim2.new(1, -20, 0, 14)
    labelText.Position = UDim2.fromOffset(18, 7)
    labelText.Font = Enum.Font.GothamMedium
    labelText.TextSize = 10
    labelText.TextColor3 = Color3.fromRGB(150,150,160)
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Text = label
    labelText.Parent = box

    return box, dot, boxStroke
end

local function createActionButton(parent, yPos, text, accentColor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -24, 0, 40)
    btn.Position = UDim2.fromOffset(12, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(27,27,32)
    btn.AutoButtonColor = false
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = accentColor
    btn.Text = text
    btn.Parent = parent

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Thickness = 1
    btnStroke.Color = accentColor
    btnStroke.Transparency = 0.75
    btnStroke.Parent = btn

    local btnShadow = Instance.new("UIShadow")
    btnShadow.Color = Color3.fromRGB(0,0,0)
    btnShadow.Transparency = 0.75
    btnShadow.BlurRadius = UDim.new(0, 8)
    btnShadow.Offset = UDim2.fromOffset(0, 2)
    btnShadow.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(34,34,40)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(27,27,32)}):Play()
    end)

    return btn
end

local pingBox, pingDot, pingStroke = createStatBox(PlayerTab, 12, 76, 112, 54, "PING", Color3.fromRGB(100,220,130))

local pingValue = Instance.new("TextLabel")
pingValue.Name = "Value"
pingValue.BackgroundTransparency = 1
pingValue.Size = UDim2.fromOffset(90, 20)
pingValue.Position = UDim2.fromOffset(9, 24)
pingValue.Font = Enum.Font.GothamBold
pingValue.TextSize = 17
pingValue.TextColor3 = Color3.fromRGB(255,255,255)
pingValue.TextXAlignment = Enum.TextXAlignment.Left
pingValue.Text = "--"
pingValue.Parent = pingBox

local pingAvg = Instance.new("TextLabel")
pingAvg.BackgroundTransparency = 1
pingAvg.Size = UDim2.fromOffset(90, 12)
pingAvg.Position = UDim2.fromOffset(9, 42)
pingAvg.Font = Enum.Font.Gotham
pingAvg.TextSize = 10
pingAvg.TextColor3 = Color3.fromRGB(115,115,125)
pingAvg.TextXAlignment = Enum.TextXAlignment.Left
pingAvg.Text = "avg: --"
pingAvg.Parent = pingBox

local fpsBox, fpsDot, fpsStroke = createStatBox(PlayerTab, 130, 76, 114, 54, "FPS", Color3.fromRGB(100,220,130))

local fpsValue = Instance.new("TextLabel")
fpsValue.Name = "Value"
fpsValue.BackgroundTransparency = 1
fpsValue.Size = UDim2.new(1, -18, 0, 22)
fpsValue.Position = UDim2.fromOffset(9, 24)
fpsValue.Font = Enum.Font.GothamBold
fpsValue.TextSize = 19
fpsValue.TextColor3 = Color3.fromRGB(255,255,255)
fpsValue.TextXAlignment = Enum.TextXAlignment.Left
fpsValue.Text = "--"
fpsValue.Parent = fpsBox

local timerBox = createStatBox(PlayerTab, 12, 138, 112, 50, "SESSION", Color3.fromRGB(120,160,255))

local timerValue = Instance.new("TextLabel")
timerValue.Name = "Value"
timerValue.BackgroundTransparency = 1
timerValue.Size = UDim2.new(1, -18, 0, 20)
timerValue.Position = UDim2.fromOffset(9, 24)
timerValue.Font = Enum.Font.GothamBold
timerValue.TextSize = 15
timerValue.TextColor3 = Color3.fromRGB(255,255,255)
timerValue.TextXAlignment = Enum.TextXAlignment.Left
timerValue.Text = "00:00:00"
timerValue.Parent = timerBox

local clockBox = createStatBox(PlayerTab, 130, 138, 114, 50, "CLOCK", Color3.fromRGB(200,150,255))

local clockValue = Instance.new("TextLabel")
clockValue.Name = "Value"
clockValue.BackgroundTransparency = 1
clockValue.Size = UDim2.new(1, -18, 0, 20)
clockValue.Position = UDim2.fromOffset(9, 24)
clockValue.Font = Enum.Font.GothamBold
clockValue.TextSize = 15
clockValue.TextColor3 = Color3.fromRGB(255,255,255)
clockValue.TextXAlignment = Enum.TextXAlignment.Left
clockValue.Text = "--:--:--"
clockValue.Parent = clockBox

local gameBox = createStatBox(ServerTab, 12, 12, 232, 46, "GAME", Color3.fromRGB(255,190,90))

local gameNameValue = Instance.new("TextLabel")
gameNameValue.Name = "Value"
gameNameValue.BackgroundTransparency = 1
gameNameValue.Size = UDim2.new(1, -18, 0, 18)
gameNameValue.Position = UDim2.fromOffset(9, 22)
gameNameValue.Font = Enum.Font.GothamBold
gameNameValue.TextSize = 13
gameNameValue.TextColor3 = Color3.fromRGB(255,255,255)
gameNameValue.TextXAlignment = Enum.TextXAlignment.Left
gameNameValue.TextTruncate = Enum.TextTruncate.AtEnd
gameNameValue.Text = "..."
gameNameValue.Parent = gameBox

task.spawn(function()
    local ok, info = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    if ok and info and info.Name then
        gameNameValue.Text = info.Name
    else
        gameNameValue.Text = "Unknown"
    end
end)

local playersBox, playersDot, playersStroke = createStatBox(ServerTab, 12, 66, 112, 54, "PLAYERS", Color3.fromRGB(100,220,130))

local playersValue = Instance.new("TextLabel")
playersValue.Name = "Value"
playersValue.BackgroundTransparency = 1
playersValue.Size = UDim2.fromOffset(90, 20)
playersValue.Position = UDim2.fromOffset(9, 24)
playersValue.Font = Enum.Font.GothamBold
playersValue.TextSize = 17
playersValue.TextColor3 = Color3.fromRGB(255,255,255)
playersValue.TextXAlignment = Enum.TextXAlignment.Left
playersValue.Text = "--/--"
playersValue.Parent = playersBox

local function updatePlayerCount()
    playersValue.Text = tostring(#Players:GetPlayers()) .. "/" .. tostring(Players.MaxPlayers)
end
updatePlayerCount()
Players.PlayerAdded:Connect(updatePlayerCount)
Players.PlayerRemoving:Connect(updatePlayerCount)

local uptimeBox = createStatBox(ServerTab, 130, 66, 114, 54, "UPTIME", Color3.fromRGB(120,160,255))

local uptimeValue = Instance.new("TextLabel")
uptimeValue.Name = "Value"
uptimeValue.BackgroundTransparency = 1
uptimeValue.Size = UDim2.new(1, -18, 0, 20)
uptimeValue.Position = UDim2.fromOffset(9, 24)
uptimeValue.Font = Enum.Font.GothamBold
uptimeValue.TextSize = 15
uptimeValue.TextColor3 = Color3.fromRGB(255,255,255)
uptimeValue.TextXAlignment = Enum.TextXAlignment.Left
uptimeValue.Text = "00:00:00"
uptimeValue.Parent = uptimeBox

task.spawn(function()
    local startServerTime = Workspace:GetServerTimeNow()
    while card.Parent do
        local ok, t = pcall(function()
            return Workspace:GetServerTimeNow()
        end)
        if ok then
            local elapsed = math.floor(t - startServerTime)
            local h = math.floor(elapsed / 3600)
            local m = math.floor((elapsed % 3600) / 60)
            local s = elapsed % 60
            uptimeValue.Text = string.format("%02d:%02d:%02d", h, m, s)
        end
        task.wait(1)
    end
end)

local rejoinBtn = createActionButton(ServerTab, 128, "REJOIN SERVER", Color3.fromRGB(120,160,255))
local hopBtn = createActionButton(ServerTab, 176, "SERVER HOP", Color3.fromRGB(255,160,90))

local function bindAction(btn, callback)
    local busy = false
    btn.MouseButton1Click:Connect(function()
        if busy then return end
        busy = true
        local originalText = btn.Text
        btn.Text = "..."
        local ok = pcall(callback)
        if not ok then
            btn.Text = "FAILED"
            task.delay(1.5, function()
                btn.Text = originalText
                busy = false
            end)
        else
            task.delay(0.6, function()
                btn.Text = originalText
                busy = false
            end)
        end
    end)
end

bindAction(rejoinBtn, function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end)

bindAction(hopBtn, function()
    TeleportService:Teleport(game.PlaceId, player)
end)

local playerRows = {}
local rowCounter = 0
local selectedPlayer = nil

local ROW_HEIGHT = 56
local AV_SIZE = 32

local PLAYERS_LIST_TOP = 8
local PLAYERS_GAP = 8
local LIST_HEADER_HEIGHT = 34
local MAX_LIST_HEIGHT = 150
local TELEPORT_BTN_HEIGHT = 34
local CONTROLS_BAR_HEIGHT = 68
local ESP_BAR_HEIGHT = 68
local BOTTOM_PADDING = 10
local MIN_LIST_HEIGHT = 90
local listExpanded = false

local Camera = Workspace.CurrentCamera
local spectating = false
local spectateCharConn = nil
local following = false
local followConn = nil
local FOLLOW_OFFSET = Vector3.new(0, 5, 12)
local spectateToggle
local followToggle
local spectateLabel
local followLabel

local espSelectedOn = false
local espSelectedHighlight = nil
local espSelectedCharConn = nil
local espAllOn = false
local espAllHighlights = {}
local espAllConns = {}
local espAllPlayerAddedConn = nil
local espSelectedToggle
local espAllToggle
local espSelectedLabel
local espAllLabel

local function formatDuration(totalSeconds)
    totalSeconds = math.max(0, math.floor(totalSeconds))
    local h = math.floor(totalSeconds / 3600)
    local m = math.floor((totalSeconds % 3600) / 60)
    local s = totalSeconds % 60
    if h > 0 then
        return string.format("%dh %02dm", h, m)
    end
    return string.format("%dm %02ds", m, s)
end

local function applySpectateSubject(target)
    Camera = Workspace.CurrentCamera
    if not Camera or not target or not target.Character then return end
    local hum = target.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        Camera.CameraSubject = hum
    end
end

local function refreshControlsLabels()
    if spectateLabel then
        if not selectedPlayer then
            spectateLabel.Text = "SELECT A PLAYER"
        elseif spectating then
            spectateLabel.Text = "SPECTATING • " .. selectedPlayer.Name
        else
            spectateLabel.Text = "WATCH • " .. (selectedPlayer and selectedPlayer.Name or "")
        end
    end
    if followLabel then
        if not selectedPlayer then
            followLabel.Text = "SELECT A PLAYER"
        elseif following then
            followLabel.Text = "FOLLOWING • " .. selectedPlayer.Name
        else
            followLabel.Text = "FOLLOW • " .. (selectedPlayer and selectedPlayer.Name or "")
        end
    end
    if espSelectedLabel then
        if not selectedPlayer then
            espSelectedLabel.Text = "SELECT A PLAYER"
        elseif espSelectedOn then
            espSelectedLabel.Text = "ESP ON • " .. selectedPlayer.Name
        else
            espSelectedLabel.Text = "ESP • " .. selectedPlayer.Name
        end
    end
    if espAllLabel then
        espAllLabel.Text = espAllOn and "ESP ALL • ON" or "ESP • ALL PLAYERS"
    end
end

local function stopFollow(animated)
    if followConn then
        followConn:Disconnect()
        followConn = nil
    end
    if following then
        following = false
        Camera = Workspace.CurrentCamera
        if Camera then
            Camera.CameraType = Enum.CameraType.Custom
            if player.Character then
                local myHum = player.Character:FindFirstChildOfClass("Humanoid")
                if myHum then
                    Camera.CameraSubject = myHum
                end
            end
        end
    end
    if followToggle then followToggle.Set(false, animated ~= false) end
    refreshControlsLabels()
end

local function stopSpectate(animated)
    if spectateCharConn then
        spectateCharConn:Disconnect()
        spectateCharConn = nil
    end
    if spectating then
        spectating = false
        Camera = Workspace.CurrentCamera
        if Camera then
            Camera.CameraType = Enum.CameraType.Custom
            if player.Character then
                local myHum = player.Character:FindFirstChildOfClass("Humanoid")
                if myHum then
                    Camera.CameraSubject = myHum
                end
            end
        end
    end
    if spectateToggle then spectateToggle.Set(false, animated ~= false) end
    refreshControlsLabels()
end

local function startFollow()
    if not selectedPlayer or not selectedPlayer.Parent then
        if followToggle then followToggle.Set(false, false) end
        return
    end
    if spectating then stopSpectate(false) end

    Camera = Workspace.CurrentCamera
    Camera.CameraType = Enum.CameraType.Scriptable
    following = true

    if followConn then followConn:Disconnect() end
    followConn = RunService.RenderStepped:Connect(function()
        if not selectedPlayer or not selectedPlayer.Character then return end
        local root = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root or not Camera then return end
        local behind = root.CFrame * CFrame.new(0, FOLLOW_OFFSET.Y, FOLLOW_OFFSET.Z)
        Camera.CFrame = CFrame.new(behind.Position, root.Position + Vector3.new(0, 1.5, 0))
    end)

    refreshControlsLabels()
end

local function startSpectate()
    if not selectedPlayer or not selectedPlayer.Parent then
        if spectateToggle then spectateToggle.Set(false, false) end
        return
    end
    if following then stopFollow(false) end

    Camera = Workspace.CurrentCamera
    Camera.CameraType = Enum.CameraType.Custom
    applySpectateSubject(selectedPlayer)
    spectating = true

    if spectateCharConn then spectateCharConn:Disconnect() end
    spectateCharConn = selectedPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)
        applySpectateSubject(selectedPlayer)
    end)

    refreshControlsLabels()
end

task.spawn(function()
    while card.Parent do
        if spectating and selectedPlayer and selectedPlayer.Parent then
            applySpectateSubject(selectedPlayer)
        end
        task.wait(0.5)
    end
end)

local function makeESPHighlight(character)
    local hl = Instance.new("Highlight")
    hl.FillColor = Color3.fromRGB(255,255,255)
    hl.FillTransparency = 0.65
    hl.OutlineColor = Color3.fromRGB(255,255,255)
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = character

    task.spawn(function()
        while hl.Parent do
            local t1 = TweenService:Create(hl, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {FillTransparency = 0.85})
            t1:Play()
            t1.Completed:Wait()
            if not hl.Parent then break end
            local t2 = TweenService:Create(hl, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {FillTransparency = 0.5})
            t2:Play()
            t2.Completed:Wait()
        end
    end)

    return hl
end

local function disconnectESPSelectedConn()
    if espSelectedCharConn then
        espSelectedCharConn:Disconnect()
        espSelectedCharConn = nil
    end
end

local function destroyESPSelectedHighlight()
    if espSelectedHighlight then
        espSelectedHighlight:Destroy()
        espSelectedHighlight = nil
    end
end

local function attachESPSelected(plr)
    disconnectESPSelectedConn()
    destroyESPSelectedHighlight()
    if not plr then return end
    if plr.Character then
        espSelectedHighlight = makeESPHighlight(plr.Character)
    end
    espSelectedCharConn = plr.CharacterAdded:Connect(function(char)
        destroyESPSelectedHighlight()
        espSelectedHighlight = makeESPHighlight(char)
    end)
end

local function startESPSelected()
    if not selectedPlayer then
        if espSelectedToggle then espSelectedToggle.Set(false, false) end
        return
    end
    espSelectedOn = true
    attachESPSelected(selectedPlayer)
    refreshControlsLabels()
end

local function stopESPSelected()
    espSelectedOn = false
    disconnectESPSelectedConn()
    destroyESPSelectedHighlight()
    if espSelectedToggle then espSelectedToggle.Set(false, true) end
    refreshControlsLabels()
end

local function makeAllESPFor(plr)
    if not plr.Character then return end
    if espAllHighlights[plr] then
        espAllHighlights[plr]:Destroy()
    end
    espAllHighlights[plr] = makeESPHighlight(plr.Character)
end

local function attachESPAllConn(plr)
    if espAllConns[plr] then
        espAllConns[plr]:Disconnect()
    end
    espAllConns[plr] = plr.CharacterAdded:Connect(function(char)
        if espAllHighlights[plr] then
            espAllHighlights[plr]:Destroy()
        end
        espAllHighlights[plr] = makeESPHighlight(char)
    end)
end

local function startESPAll()
    espAllOn = true
    for _, plr in ipairs(Players:GetPlayers()) do
        makeAllESPFor(plr)
        attachESPAllConn(plr)
    end
    espAllPlayerAddedConn = Players.PlayerAdded:Connect(function(plr)
        if espAllOn then
            attachESPAllConn(plr)
            if plr.Character then
                makeAllESPFor(plr)
            end
        end
    end)
    refreshControlsLabels()
end

local function stopESPAll()
    espAllOn = false
    if espAllPlayerAddedConn then
        espAllPlayerAddedConn:Disconnect()
        espAllPlayerAddedConn = nil
    end
    for _, hl in pairs(espAllHighlights) do
        hl:Destroy()
    end
    espAllHighlights = {}
    for _, conn in pairs(espAllConns) do
        conn:Disconnect()
    end
    espAllConns = {}
    if espAllToggle then espAllToggle.Set(false, true) end
    refreshControlsLabels()
end

local function createToggleSwitch(parent, pos, onChanged)
    local state = false

    local track = Instance.new("TextButton")
    track.Text = ""
    track.AutoButtonColor = false
    track.Size = UDim2.fromOffset(44, 24)
    track.Position = pos
    track.BackgroundColor3 = Color3.fromRGB(45,45,52)
    track.BorderSizePixel = 0
    track.Parent = parent

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track

    local trackStroke = Instance.new("UIStroke")
    trackStroke.Thickness = 1
    trackStroke.Color = Color3.fromRGB(255,255,255)
    trackStroke.Transparency = 0.85
    trackStroke.Parent = track

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(18, 18)
    knob.Position = UDim2.fromOffset(3, 3)
    knob.BackgroundColor3 = Color3.fromRGB(210,210,218)
    knob.BorderSizePixel = 0
    knob.Parent = track

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local knobShadow = Instance.new("UIShadow")
    knobShadow.Color = Color3.fromRGB(0,0,0)
    knobShadow.Transparency = 0.6
    knobShadow.BlurRadius = UDim.new(0, 4)
    knobShadow.Offset = UDim2.fromOffset(0, 1)
    knobShadow.Parent = knob

    local function apply(animated)
        local ti = TweenInfo.new(animated and 0.18 or 0, Enum.EasingStyle.Quad)
        local trackColor = state and Color3.fromRGB(80,200,160) or Color3.fromRGB(45,45,52)
        local knobPos = state and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3)
        local knobColor = state and Color3.fromRGB(255,255,255) or Color3.fromRGB(210,210,218)
        TweenService:Create(track, ti, {BackgroundColor3 = trackColor}):Play()
        TweenService:Create(knob, ti, {Position = knobPos, BackgroundColor3 = knobColor}):Play()
    end

    track.MouseButton1Click:Connect(function()
        state = not state
        apply(true)
        if onChanged then onChanged(state) end
    end)

    return {
        Set = function(newState, animated)
            if newState == state then return end
            state = newState
            apply(animated ~= false)
        end,
        Get = function() return state end,
    }
end

local listHeader = Instance.new("TextButton")
listHeader.Size = UDim2.new(1, -20, 0, LIST_HEADER_HEIGHT)
listHeader.Position = UDim2.fromOffset(10, PLAYERS_LIST_TOP)
listHeader.BackgroundColor3 = Color3.fromRGB(27,27,32)
listHeader.AutoButtonColor = false
listHeader.Text = ""
listHeader.Parent = PlayersTab

local listHeaderCorner = Instance.new("UICorner")
listHeaderCorner.CornerRadius = UDim.new(0, 10)
listHeaderCorner.Parent = listHeader

local listHeaderStroke = Instance.new("UIStroke")
listHeaderStroke.Thickness = 1
listHeaderStroke.Color = Color3.fromRGB(255,255,255)
listHeaderStroke.Transparency = 0.85
listHeaderStroke.Parent = listHeader

local listHeaderText = Instance.new("TextLabel")
listHeaderText.BackgroundTransparency = 1
listHeaderText.Position = UDim2.fromOffset(12, 0)
listHeaderText.Size = UDim2.new(1, -46, 1, 0)
listHeaderText.Font = Enum.Font.GothamBold
listHeaderText.TextSize = 11
listHeaderText.TextColor3 = Color3.fromRGB(255,255,255)
listHeaderText.TextXAlignment = Enum.TextXAlignment.Left
listHeaderText.TextTruncate = Enum.TextTruncate.AtEnd
listHeaderText.Text = "SELECT A PLAYER"
listHeaderText.Parent = listHeader

local listHeaderChevron = Instance.new("TextLabel")
listHeaderChevron.BackgroundTransparency = 1
listHeaderChevron.AnchorPoint = Vector2.new(1, 0.5)
listHeaderChevron.Position = UDim2.new(1, -12, 0.5, 0)
listHeaderChevron.Size = UDim2.fromOffset(20, 20)
listHeaderChevron.Font = Enum.Font.GothamBold
listHeaderChevron.TextSize = 14
listHeaderChevron.TextColor3 = Color3.fromRGB(150,150,160)
listHeaderChevron.Text = "v"
listHeaderChevron.Parent = listHeader

local playersList = Instance.new("ScrollingFrame")
playersList.Size = UDim2.new(1, -20, 0, 0)
playersList.Position = UDim2.fromOffset(10, PLAYERS_LIST_TOP + LIST_HEADER_HEIGHT + PLAYERS_GAP)
playersList.BackgroundTransparency = 1
playersList.BorderSizePixel = 0
playersList.ScrollBarThickness = 3
playersList.ScrollBarImageColor3 = Color3.fromRGB(90,90,100)
playersList.ScrollingDirection = Enum.ScrollingDirection.Y
playersList.CanvasSize = UDim2.new(0, 0, 0, 0)
playersList.AutomaticCanvasSize = Enum.AutomaticSize.Y
playersList.Visible = false
playersList.Parent = PlayersTab

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = playersList

local teleportBtn = createActionButton(PlayersTab, 58, "TELEPORT TO PLAYER", Color3.fromRGB(120,160,255))
teleportBtn.Size = UDim2.new(1, -20, 0, 34)
teleportBtn.Position = UDim2.fromOffset(10, 58)

bindAction(teleportBtn, function()
    assert(selectedPlayer, "no selection")
    local targetChar = selectedPlayer.Character
    local myChar = player.Character
    assert(targetChar and myChar, "missing character")
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    assert(targetRoot and myRoot, "missing root part")
    myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 4)
end)

local controlsBar = Instance.new("Frame")
controlsBar.Size = UDim2.new(1, -20, 0, CONTROLS_BAR_HEIGHT)
controlsBar.Position = UDim2.fromOffset(10, 100)
controlsBar.BackgroundColor3 = Color3.fromRGB(27,27,32)
controlsBar.BorderSizePixel = 0
controlsBar.Parent = PlayersTab

local controlsBarCorner = Instance.new("UICorner")
controlsBarCorner.CornerRadius = UDim.new(0, 10)
controlsBarCorner.Parent = controlsBar

local controlsBarStroke = Instance.new("UIStroke")
controlsBarStroke.Thickness = 1
controlsBarStroke.Color = Color3.fromRGB(255,255,255)
controlsBarStroke.Transparency = 0.85
controlsBarStroke.Parent = controlsBar

local controlsDivider = Instance.new("Frame")
controlsDivider.Size = UDim2.new(1, -24, 0, 1)
controlsDivider.Position = UDim2.fromOffset(12, 33)
controlsDivider.BackgroundColor3 = Color3.fromRGB(255,255,255)
controlsDivider.BackgroundTransparency = 0.92
controlsDivider.BorderSizePixel = 0
controlsDivider.Parent = controlsBar

spectateLabel = Instance.new("TextLabel")
spectateLabel.BackgroundTransparency = 1
spectateLabel.Position = UDim2.fromOffset(12, 3)
spectateLabel.Size = UDim2.fromOffset(155, 24)
spectateLabel.Font = Enum.Font.GothamBold
spectateLabel.TextSize = 10
spectateLabel.TextColor3 = Color3.fromRGB(150,150,160)
spectateLabel.TextXAlignment = Enum.TextXAlignment.Left
spectateLabel.TextTruncate = Enum.TextTruncate.AtEnd
spectateLabel.Text = "SELECT A PLAYER"
spectateLabel.Parent = controlsBar

spectateToggle = createToggleSwitch(controlsBar, UDim2.new(1, -54, 0, 5), function(state)
    if state then
        if not selectedPlayer then
            spectateToggle.Set(false, false)
            return
        end
        startSpectate()
    else
        stopSpectate(true)
    end
end)

followLabel = Instance.new("TextLabel")
followLabel.BackgroundTransparency = 1
followLabel.Position = UDim2.fromOffset(12, 37)
followLabel.Size = UDim2.fromOffset(155, 24)
followLabel.Font = Enum.Font.GothamBold
followLabel.TextSize = 10
followLabel.TextColor3 = Color3.fromRGB(150,150,160)
followLabel.TextXAlignment = Enum.TextXAlignment.Left
followLabel.TextTruncate = Enum.TextTruncate.AtEnd
followLabel.Text = "SELECT A PLAYER"
followLabel.Parent = controlsBar

followToggle = createToggleSwitch(controlsBar, UDim2.new(1, -54, 0, 39), function(state)
    if state then
        if not selectedPlayer then
            followToggle.Set(false, false)
            return
        end
        startFollow()
    else
        stopFollow(true)
    end
end)

local espBar = Instance.new("Frame")
espBar.Size = UDim2.new(1, -20, 0, ESP_BAR_HEIGHT)
espBar.Position = UDim2.fromOffset(10, 176)
espBar.BackgroundColor3 = Color3.fromRGB(27,27,32)
espBar.BorderSizePixel = 0
espBar.Parent = PlayersTab

local espBarCorner = Instance.new("UICorner")
espBarCorner.CornerRadius = UDim.new(0, 10)
espBarCorner.Parent = espBar

local espBarStroke = Instance.new("UIStroke")
espBarStroke.Thickness = 1
espBarStroke.Color = Color3.fromRGB(255,255,255)
espBarStroke.Transparency = 0.85
espBarStroke.Parent = espBar

local espDivider = Instance.new("Frame")
espDivider.Size = UDim2.new(1, -24, 0, 1)
espDivider.Position = UDim2.fromOffset(12, 33)
espDivider.BackgroundColor3 = Color3.fromRGB(255,255,255)
espDivider.BackgroundTransparency = 0.92
espDivider.BorderSizePixel = 0
espDivider.Parent = espBar

espSelectedLabel = Instance.new("TextLabel")
espSelectedLabel.BackgroundTransparency = 1
espSelectedLabel.Position = UDim2.fromOffset(12, 3)
espSelectedLabel.Size = UDim2.fromOffset(155, 24)
espSelectedLabel.Font = Enum.Font.GothamBold
espSelectedLabel.TextSize = 10
espSelectedLabel.TextColor3 = Color3.fromRGB(150,150,160)
espSelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
espSelectedLabel.TextTruncate = Enum.TextTruncate.AtEnd
espSelectedLabel.Text = "SELECT A PLAYER"
espSelectedLabel.Parent = espBar

espSelectedToggle = createToggleSwitch(espBar, UDim2.new(1, -54, 0, 5), function(state)
    if state then
        if not selectedPlayer then
            espSelectedToggle.Set(false, false)
            return
        end
        startESPSelected()
    else
        stopESPSelected()
    end
end)

espAllLabel = Instance.new("TextLabel")
espAllLabel.BackgroundTransparency = 1
espAllLabel.Position = UDim2.fromOffset(12, 37)
espAllLabel.Size = UDim2.fromOffset(155, 24)
espAllLabel.Font = Enum.Font.GothamBold
espAllLabel.TextSize = 10
espAllLabel.TextColor3 = Color3.fromRGB(150,150,160)
espAllLabel.TextXAlignment = Enum.TextXAlignment.Left
espAllLabel.TextTruncate = Enum.TextTruncate.AtEnd
espAllLabel.Text = "ESP • ALL PLAYERS"
espAllLabel.Parent = espBar

espAllToggle = createToggleSwitch(espBar, UDim2.new(1, -54, 0, 39), function(state)
    if state then
        startESPAll()
    else
        stopESPAll()
    end
end)

local function computePlayersLayout()
    local rows = 0
    for _ in pairs(playerRows) do rows += 1 end
    if rows < 1 then rows = 1 end

    local rowsHeight = rows * ROW_HEIGHT + math.max(0, rows - 1) * 5
    local listHeight = 0
    if listExpanded then
        listHeight = math.clamp(rowsHeight, MIN_LIST_HEIGHT, MAX_LIST_HEIGHT)
    end

    local headerY = PLAYERS_LIST_TOP
    local listY = headerY + LIST_HEADER_HEIGHT + PLAYERS_GAP
    local teleportY = listY + listHeight + PLAYERS_GAP
    local controlsY = teleportY + TELEPORT_BTN_HEIGHT + PLAYERS_GAP
    local espY = controlsY + CONTROLS_BAR_HEIGHT + PLAYERS_GAP
    local cardHeight = math.clamp(CONTENT_TOP + espY + ESP_BAR_HEIGHT + BOTTOM_PADDING, BASE_CARD_HEIGHT, MAX_CARD_HEIGHT)

    return cardHeight, listHeight, headerY, listY, teleportY, controlsY, espY
end

local function applyPlayersLayout(animated)
    local cardHeight, listHeight, headerY, listY, teleportY, controlsY, espY = computePlayersLayout()
    local ti = TweenInfo.new(animated and 0.28 or 0, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    TweenService:Create(listHeader, ti, {Position = UDim2.fromOffset(10, headerY)}):Play()

    if listHeight > 0 then
        playersList.Visible = true
    end
    local listTween = TweenService:Create(playersList, ti, {
        Position = UDim2.fromOffset(10, listY),
        Size = UDim2.new(1, -20, 0, listHeight),
    })
    listTween:Play()
    listTween.Completed:Connect(function()
        playersList.Visible = listHeight > 0
    end)

    TweenService:Create(teleportBtn, ti, {Position = UDim2.fromOffset(10, teleportY)}):Play()
    TweenService:Create(controlsBar, ti, {Position = UDim2.fromOffset(10, controlsY)}):Play()
    TweenService:Create(espBar, ti, {Position = UDim2.fromOffset(10, espY)}):Play()

    if currentTab == "players" then
        TweenService:Create(card, ti, {Size = UDim2.fromOffset(CARD_WIDTH, cardHeight)}):Play()
    end
end

local function setListExpanded(expanded, animated)
    listExpanded = expanded
    listHeaderChevron.Text = expanded and "^" or "v"
    applyPlayersLayout(animated ~= false)
end

listHeader.MouseButton1Click:Connect(function()
    setListExpanded(not listExpanded, true)
end)

local function updateSelectionVisuals()
    for p, data in pairs(playerRows) do
        local isSel = (p == selectedPlayer)
        TweenService:Create(data.Stroke, TweenInfo.new(0.15), {
            Color = isSel and Color3.fromRGB(120,160,255) or Color3.fromRGB(255,255,255),
            Transparency = isSel and 0.15 or 0.85,
        }):Play()
        TweenService:Create(data.Frame, TweenInfo.new(0.15), {
            BackgroundColor3 = isSel and Color3.fromRGB(36,36,44) or Color3.fromRGB(27,27,32),
        }):Play()
        TweenService:Create(data.CheckDot, TweenInfo.new(0.15), {
            BackgroundTransparency = isSel and 0 or 1,
        }):Play()
        TweenService:Create(data.AccentBar, TweenInfo.new(0.15), {
            BackgroundTransparency = isSel and 0 or 1,
        }):Play()
    end

    if selectedPlayer then
        if spectating then
            applySpectateSubject(selectedPlayer)
            if spectateCharConn then spectateCharConn:Disconnect() end
            spectateCharConn = selectedPlayer.CharacterAdded:Connect(function()
                task.wait(0.5)
                applySpectateSubject(selectedPlayer)
            end)
        end
        if espSelectedOn then
            attachESPSelected(selectedPlayer)
        end
    else
        stopSpectate(false)
        stopFollow(false)
        if espSelectedOn then
            stopESPSelected()
        end
    end
    refreshControlsLabels()
end

local function selectPlayer(plr)
    if selectedPlayer == plr then
        selectedPlayer = nil
    else
        selectedPlayer = plr
    end
    listHeaderText.Text = selectedPlayer and selectedPlayer.DisplayName or "SELECT A PLAYER"
    updateSelectionVisuals()
    if selectedPlayer then
        setListExpanded(false, true)
    end
end

local function createPlayerRow(plr)
    rowCounter += 1

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, ROW_HEIGHT)
    row.BackgroundColor3 = Color3.fromRGB(27,27,32)
    row.BorderSizePixel = 0
    row.LayoutOrder = rowCounter
    row.Parent = playersList

    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 8)
    rowCorner.Parent = row

    local rowStroke = Instance.new("UIStroke")
    rowStroke.Thickness = 1
    rowStroke.Color = Color3.fromRGB(255,255,255)
    rowStroke.Transparency = 0.85
    rowStroke.Parent = row

    local rowShadow = Instance.new("UIShadow")
    rowShadow.Color = Color3.fromRGB(0,0,0)
    rowShadow.Transparency = 0.82
    rowShadow.BlurRadius = UDim.new(0, 5)
    rowShadow.Offset = UDim2.fromOffset(0, 2)
    rowShadow.Parent = row

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 3, 1, 0)
    accentBar.Position = UDim2.fromOffset(0, 0)
    accentBar.BackgroundColor3 = Color3.fromRGB(120,160,255)
    accentBar.BackgroundTransparency = 1
    accentBar.BorderSizePixel = 0
    accentBar.ZIndex = 2
    accentBar.Parent = row

    local rowBtn = Instance.new("TextButton")
    rowBtn.Size = UDim2.new(1, 0, 1, 0)
    rowBtn.BackgroundTransparency = 1
    rowBtn.Text = ""
    rowBtn.ZIndex = 3
    rowBtn.Parent = row

    local av = Instance.new("ImageLabel")
    av.Size = UDim2.fromOffset(AV_SIZE, AV_SIZE)
    av.Position = UDim2.fromOffset(6, (ROW_HEIGHT - AV_SIZE) / 2)
    av.BackgroundColor3 = Color3.fromRGB(36,36,42)
    av.Parent = row

    local avCorner = Instance.new("UICorner")
    avCorner.CornerRadius = UDim.new(1, 0)
    avCorner.Parent = av

    local avStroke = Instance.new("UIStroke")
    avStroke.Thickness = 1
    avStroke.Color = Color3.fromRGB(255,255,255)
    avStroke.Transparency = 0.6
    avStroke.Parent = av

    av.Image = "rbxthumb://type=AvatarHeadShot&id=" .. plr.UserId .. "&w=150&h=150"

    local avDot = Instance.new("Frame")
    avDot.Size = UDim2.fromOffset(8, 8)
    avDot.Position = UDim2.fromOffset(22, 22)
    avDot.BackgroundColor3 = Color3.fromRGB(90, 220, 130)
    avDot.BorderSizePixel = 0
    avDot.ZIndex = 2
    avDot.Parent = av

    local avDotCorner = Instance.new("UICorner")
    avDotCorner.CornerRadius = UDim.new(1, 0)
    avDotCorner.Parent = avDot

    local avDotStroke = Instance.new("UIStroke")
    avDotStroke.Thickness = 1.5
    avDotStroke.Color = Color3.fromRGB(27,27,32)
    avDotStroke.Parent = avDot

    local dName = Instance.new("TextLabel")
    dName.BackgroundTransparency = 1
    dName.Position = UDim2.fromOffset(46, 4)
    dName.Size = UDim2.fromOffset(150, 15)
    dName.Font = Enum.Font.GothamBold
    dName.TextSize = 11
    dName.TextColor3 = Color3.fromRGB(255,255,255)
    dName.TextXAlignment = Enum.TextXAlignment.Left
    dName.TextTruncate = Enum.TextTruncate.AtEnd
    dName.Text = plr.DisplayName
    dName.Parent = row

    local uName = Instance.new("TextLabel")
    uName.BackgroundTransparency = 1
    uName.Position = UDim2.fromOffset(46, 20)
    uName.Size = UDim2.fromOffset(150, 13)
    uName.Font = Enum.Font.Gotham
    uName.TextSize = 9
    uName.TextColor3 = Color3.fromRGB(140,140,150)
    uName.TextXAlignment = Enum.TextXAlignment.Left
    uName.TextTruncate = Enum.TextTruncate.AtEnd
    uName.Text = "@" .. plr.Name
    uName.Parent = row

    local extraInfo = Instance.new("TextLabel")
    extraInfo.Name = "ExtraInfo"
    extraInfo.BackgroundTransparency = 1
    extraInfo.Position = UDim2.fromOffset(46, 36)
    extraInfo.Size = UDim2.fromOffset(150, 13)
    extraInfo.Font = Enum.Font.Gotham
    extraInfo.TextSize = 9
    extraInfo.TextColor3 = Color3.fromRGB(120,160,255)
    extraInfo.TextXAlignment = Enum.TextXAlignment.Left
    extraInfo.TextTruncate = Enum.TextTruncate.AtEnd
    extraInfo.Text = "Age: " .. tostring(plr.AccountAge) .. "d"
    extraInfo.Parent = row

    if plr == player then
        local youBadge = Instance.new("Frame")
        youBadge.Size = UDim2.fromOffset(28, 13)
        youBadge.AnchorPoint = Vector2.new(1, 0.5)
        youBadge.Position = UDim2.new(1, -14, 0.5, 0)
        youBadge.BackgroundColor3 = Color3.fromRGB(120,160,255)
        youBadge.BackgroundTransparency = 0.85
        youBadge.BorderSizePixel = 0
        youBadge.Parent = row

        local youBadgeCorner = Instance.new("UICorner")
        youBadgeCorner.CornerRadius = UDim.new(1, 0)
        youBadgeCorner.Parent = youBadge

        local youBadgeStroke = Instance.new("UIStroke")
        youBadgeStroke.Thickness = 1
        youBadgeStroke.Color = Color3.fromRGB(120,160,255)
        youBadgeStroke.Transparency = 0.4
        youBadgeStroke.Parent = youBadge

        local youBadgeText = Instance.new("TextLabel")
        youBadgeText.BackgroundTransparency = 1
        youBadgeText.Size = UDim2.new(1, 0, 1, 0)
        youBadgeText.Font = Enum.Font.GothamBold
        youBadgeText.TextSize = 7
        youBadgeText.TextColor3 = Color3.fromRGB(120,160,255)
        youBadgeText.Text = "YOU"
        youBadgeText.Parent = youBadge
    end

    local checkDot = Instance.new("Frame")
    checkDot.Size = UDim2.fromOffset(7, 7)
    checkDot.AnchorPoint = Vector2.new(1, 0.5)
    checkDot.Position = UDim2.new(1, -8, 0.5, 0)
    checkDot.BackgroundColor3 = Color3.fromRGB(120,160,255)
    checkDot.BackgroundTransparency = 1
    checkDot.BorderSizePixel = 0
    checkDot.Parent = row

    local checkDotCorner = Instance.new("UICorner")
    checkDotCorner.CornerRadius = UDim.new(1, 0)
    checkDotCorner.Parent = checkDot

    rowBtn.MouseButton1Click:Connect(function()
        selectPlayer(plr)
    end)

    playerRows[plr] = {
        Frame = row,
        Stroke = rowStroke,
        CheckDot = checkDot,
        AccentBar = accentBar,
        ExtraInfo = extraInfo,
        JoinTime = os.clock(),
        AccountAge = plr.AccountAge,
    }
end

local function addPlayerRow(plr)
    createPlayerRow(plr)
    applyPlayersLayout(currentTab == "players")
end

for _, p in ipairs(Players:GetPlayers()) do
    createPlayerRow(p)
end

Players.PlayerAdded:Connect(addPlayerRow)

Players.PlayerRemoving:Connect(function(p)
    local data = playerRows[p]
    if data then
        data.Frame:Destroy()
        playerRows[p] = nil
    end
    if espAllHighlights[p] then
        espAllHighlights[p]:Destroy()
        espAllHighlights[p] = nil
    end
    if espAllConns[p] then
        espAllConns[p]:Disconnect()
        espAllConns[p] = nil
    end
    if selectedPlayer == p then
        selectedPlayer = nil
        listHeaderText.Text = "SELECT A PLAYER"
        updateSelectionVisuals()
    end
    applyPlayersLayout(currentTab == "players")
end)

task.spawn(function()
    while card.Parent do
        for _, data in pairs(playerRows) do
            data.ExtraInfo.Text = "Age: " .. tostring(data.AccountAge) .. "d  •  In: " .. formatDuration(os.clock() - data.JoinTime)
        end
        task.wait(1)
    end
end)

task.spawn(function()
    local networkStats = Stats.Network
    local longSum, longCount = 0, 0

    while card.Parent do
        local ok, ping = pcall(function()
            return networkStats.ServerStatsItem["Data Ping"]:GetValue()
        end)
        if ok then
            local displayPing = math.floor(ping + 0.5)
            pingValue.Text = displayPing .. " ms"

            longSum += ping
            longCount += 1
            local avg = math.floor(longSum / longCount)
            pingAvg.Text = "avg: " .. avg .. " ms"

            local color
            if displayPing < 80 then
                color = Color3.fromRGB(100, 220, 130)
            elseif displayPing < 150 then
                color = Color3.fromRGB(240, 200, 90)
            else
                color = Color3.fromRGB(240, 90, 90)
            end
            pingValue.TextColor3 = color
            TweenService:Create(pingDot, TweenInfo.new(0.3), {BackgroundColor3 = color}):Play()
            TweenService:Create(pingStroke, TweenInfo.new(0.3), {Color = color, Transparency = 0.45}):Play()
        end
        task.wait(1)
    end
end)

do
    local frames = 0
    local elapsed = 0
    RunService.RenderStepped:Connect(function(dt)
        if not card.Parent then return end
        frames += 1
        elapsed += dt
        if elapsed >= 0.5 then
            local fps = math.floor(frames / elapsed)
            fpsValue.Text = tostring(fps)

            local color
            if fps >= 50 then
                color = Color3.fromRGB(100, 220, 130)
            elseif fps >= 30 then
                color = Color3.fromRGB(240, 200, 90)
            else
                color = Color3.fromRGB(240, 90, 90)
            end
            fpsValue.TextColor3 = color
            TweenService:Create(fpsDot, TweenInfo.new(0.3), {BackgroundColor3 = color}):Play()
            TweenService:Create(fpsStroke, TweenInfo.new(0.3), {Color = color, Transparency = 0.45}):Play()

            elapsed = 0
            frames = 0
        end
    end)
end

task.spawn(function()
    local startTime = os.clock()
    while card.Parent do
        local elapsed = math.floor(os.clock() - startTime)
        local h = math.floor(elapsed / 3600)
        local m = math.floor((elapsed % 3600) / 60)
        local s = elapsed % 60
        timerValue.Text = string.format("%02d:%02d:%02d", h, m, s)
        task.wait(1)
    end
end)

task.spawn(function()
    while card.Parent do
        local now = DateTime.now():ToLocalTime()
        local hour12 = now.Hour % 12
        if hour12 == 0 then hour12 = 12 end
        clockValue.Text = string.format("%d:%02d:%02d", hour12, now.Minute, now.Second)
        task.wait(1)
    end
end)

currentTab = "player"
local tabOrder = {"player", "players", "server"}
local tabPanels = {player = PlayerTab, players = PlayersTab, server = ServerTab}
local tabButtons = {player = tabBtnPlayer, players = tabBtnPlayers, server = tabBtnServer}

local function indexOf(tab)
    for i, v in ipairs(tabOrder) do
        if v == tab then return i end
    end
end

function switchTab(tab)
    if tab == currentTab then return end
    local newIdx = indexOf(tab)
    local previousTab = currentTab
    currentTab = tab
    local moveInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local colorInfo = TweenInfo.new(0.2)

    for _, name in ipairs(tabOrder) do
        local idx = indexOf(name)
        local targetX = (idx - newIdx) * CARD_WIDTH
        TweenService:Create(tabPanels[name], moveInfo, {Position = UDim2.fromOffset(targetX, CONTENT_TOP)}):Play()
        TweenService:Create(tabButtons[name], colorInfo, {
            TextColor3 = (name == tab) and Color3.fromRGB(255,255,255) or Color3.fromRGB(140,140,150)
        }):Play()
    end

    local indicatorX = TAB_PAD + (newIdx - 1) * (TAB_BTN_W + TAB_PAD)
    TweenService:Create(indicator, moveInfo, {Position = UDim2.fromOffset(indicatorX, TAB_PAD)}):Play()

    if tab == "players" then
        applyPlayersLayout(true)
    elseif previousTab == "players" then
        TweenService:Create(card, moveInfo, {Size = UDim2.fromOffset(CARD_WIDTH, BASE_CARD_HEIGHT)}):Play()
    end
end

tabBtnPlayer.MouseButton1Click:Connect(function() switchTab("player") end)
tabBtnPlayers.MouseButton1Click:Connect(function() switchTab("players") end)
tabBtnServer.MouseButton1Click:Connect(function() switchTab("server") end)

do
    local dragging = false
    local dragStart, startPos

    card.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = card.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            card.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleButton"
toggleBtn.Text = ""
toggleBtn.AutoButtonColor = false
toggleBtn.Size = UDim2.fromOffset(40, 40)
toggleBtn.AnchorPoint = Vector2.new(0, 1)
toggleBtn.Position = UDim2.new(0, 12, 1, -12)
toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
toggleBtn.BorderSizePixel = 0
toggleBtn.ZIndex = 5
toggleBtn.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggleBtn

local toggleShadow = Instance.new("UIShadow")
toggleShadow.Color = Color3.fromRGB(0, 0, 0)
toggleShadow.Transparency = 0.55
toggleShadow.BlurRadius = UDim.new(0, 14)
toggleShadow.Offset = UDim2.fromOffset(0, 4)
toggleShadow.Parent = toggleBtn

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Thickness = 1.25
toggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
toggleStroke.Parent = toggleBtn

local toggleStrokeGradient = Instance.new("UIGradient")
toggleStrokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120,120,135)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120,120,135)),
})
toggleStrokeGradient.Parent = toggleStroke

task.spawn(function()
    local rot = 0
    while toggleBtn.Parent do
        rot = (rot + 1) % 360
        toggleStrokeGradient.Rotation = rot
        task.wait(0.03)
    end
end)

local bar1 = Instance.new("Frame")
bar1.Size = UDim2.fromOffset(18, 2)
bar1.AnchorPoint = Vector2.new(0.5, 0.5)
bar1.Position = UDim2.new(0.5, 0, 0.5, -4)
bar1.BackgroundColor3 = Color3.fromRGB(235, 235, 240)
bar1.BorderSizePixel = 0
bar1.Parent = toggleBtn

local bar1Corner = Instance.new("UICorner")
bar1Corner.CornerRadius = UDim.new(1, 0)
bar1Corner.Parent = bar1

local bar2 = bar1:Clone()
bar2.Position = UDim2.new(0.5, 0, 0.5, 4)
bar2.Parent = toggleBtn

toggleBtn.MouseEnter:Connect(function()
    TweenService:Create(toggleBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 30, 36)}):Play()
end)
toggleBtn.MouseLeave:Connect(function()
    TweenService:Create(toggleBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(20, 20, 24)}):Play()
end)

local isOpen = true

local function setIconState(open)
    if open then
        TweenService:Create(bar1, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Rotation = 45, Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
        TweenService:Create(bar2, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Rotation = -45, Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    else
        TweenService:Create(bar1, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Rotation = 0, Position = UDim2.new(0.5, 0, 0.5, -4)}):Play()
        TweenService:Create(bar2, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Rotation = 0, Position = UDim2.new(0.5, 0, 0.5, 4)}):Play()
    end
end

toggleBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    setIconState(isOpen)

    if isOpen then
        card.Visible = true
        card.Size = UDim2.fromOffset(CARD_WIDTH, 0)
        card.BackgroundTransparency = 1
        local targetHeight = BASE_CARD_HEIGHT
        if currentTab == "players" then
            targetHeight = select(1, computePlayersLayout())
        end
        TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(CARD_WIDTH, targetHeight),
            BackgroundTransparency = 0,
        }):Play()
    else
        local closeTween = TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.fromOffset(CARD_WIDTH, 0),
            BackgroundTransparency = 1,
        })
        closeTween:Play()
        closeTween.Completed:Connect(function()
            if not isOpen then
                card.Visible = false
            end
        end)
    end
end)

card.Size = UDim2.fromOffset(CARD_WIDTH, 0)
card.BackgroundTransparency = 1
TweenService:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.fromOffset(CARD_WIDTH, CARD_HEIGHT),
    BackgroundTransparency = 0,
}):Play()

applyPlayersLayout(false)


task.spawn(function()
local LocalPlayer = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local nonSlipMaterial = PhysicalProperties.new(1, 100, 0, 100, 1)

local rotatingGradients = {}

local metallicSequence = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)),       
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(220, 220, 220)), 
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 50, 50)),     
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(220, 220, 220)), 
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))        
})

local function applyMetallicStyle(targetFrame, borderThickness)
    borderThickness = borderThickness or 2

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = borderThickness
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Parent = targetFrame

    local strokeGradient = Instance.new("UIGradient")
    strokeGradient.Color = metallicSequence
    strokeGradient.Parent = stroke
    
    table.insert(rotatingGradients, strokeGradient)
end

local rotationAngle = 0
RunService.RenderStepped:Connect(function(delta)
    rotationAngle = (rotationAngle + (60 * delta)) % 360
    for i = #rotatingGradients, 1, -1 do
        local gradient = rotatingGradients[i]
        if gradient and gradient.Parent then
            gradient.Rotation = rotationAngle
        else
            table.remove(rotatingGradients, i)
        end
    end
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlatformGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Name = "PlatformBtn"
button.Size = UDim2.new(0, 55, 0, 55)
button.Position = UDim2.new(0.8, 0, 0.5, 0)
button.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
button.BackgroundTransparency = 0.45
button.Text = "" 
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 12
button.Font = Enum.Font.GothamBlack
button.AutoButtonColor = true
button.Parent = screenGui

local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
bgGradient.Rotation = 45
bgGradient.Parent = button

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 14)
uiCorner.Parent = button

applyMetallicStyle(button, 2)

task.spawn(function()
    local textToType = "BLACK"
    while true do
        for i = 1, #textToType do
            button.Text = string.sub(textToType, 1, i)
            task.wait(0.18)
        end
        
        task.wait(2)
        
        for i = #textToType, 0, -1 do
            button.Text = string.sub(textToType, 1, i)
            task.wait(0.12)
        end
        
        task.wait(0.5)
    end
end)

local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = button.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

button.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local hrp = character.HumanoidRootPart
    local spawnPos = hrp.Position - Vector3.new(0, 3.1, 0)

    local brick = Instance.new("Part")
    brick.Name = "DarkBrick"
    brick.Size = Vector3.new(4.2, 1, 5)
    brick.BrickColor = BrickColor.new("Black")
    brick.Material = Enum.Material.SmoothPlastic
    brick.Reflectance = 0.4
    brick.TopSurface = Enum.SurfaceType.Smooth
    brick.BottomSurface = Enum.SurfaceType.Smooth
    brick.CustomPhysicalProperties = nonSlipMaterial

    brick.CFrame = CFrame.new(spawnPos, spawnPos + Vector3.new(hrp.CFrame.LookVector.X, 0, hrp.CFrame.LookVector.Z))
    brick.Anchored = true
    brick.CanCollide = true

    local brickAttachment = Instance.new("Attachment")
    brickAttachment.Parent = brick

    local brickSmoke = Instance.new("ParticleEmitter")
    brickSmoke.Color = ColorSequence.new(Color3.fromRGB(10, 10, 10))
    brickSmoke.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 2), NumberSequenceKeypoint.new(1, 4)})
    brickSmoke.Texture = "rbxassetid://2413819000"
    brickSmoke.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 1)})
    brickSmoke.Lifetime = NumberRange.new(0.5, 1)
    brickSmoke.Rate = 30
    brickSmoke.Speed = NumberRange.new(1, 3)
    brickSmoke.VelocitySpread = 180
    brickSmoke.Parent = brickAttachment

    brick.Parent = workspace

    Debris:AddItem(brick, 1)
end)
end) 


task.spawn(function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local rotatingGradients = {}

local glowSequences = {
	green = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 40, 10)),
		ColorSequenceKeypoint.new(0.3, Color3.fromRGB(180, 255, 180)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 150, 30)),
		ColorSequenceKeypoint.new(0.7, Color3.fromRGB(180, 255, 180)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 40, 10)),
	}),
	yellow = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 40, 5)),
		ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 245, 150)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 140, 10)),
		ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 245, 150)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 40, 5)),
	}),
	red = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 5, 5)),
		ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 150, 150)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 10, 10)),
		ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 150, 150)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 5, 5)),
	}),
}

local colorCycleColors = {
	green = {
		Color3.fromRGB(40, 180, 40),
		Color3.fromRGB(140, 255, 140),
		Color3.fromRGB(0, 255, 150),
		Color3.fromRGB(80, 220, 80),
	},
	yellow = {
		Color3.fromRGB(255, 210, 40),
		Color3.fromRGB(255, 250, 170),
		Color3.fromRGB(255, 183, 0),
		Color3.fromRGB(255, 225, 100),
	},
	red = {
		Color3.fromRGB(230, 40, 40),
		Color3.fromRGB(255, 140, 140),
		Color3.fromRGB(220, 20, 60),
		Color3.fromRGB(255, 90, 90),
	},
}

local ROTATION_SPEED = 110

local function startRotationLoop()
	return RunService.RenderStepped:Connect(function()
		local rotationAngle = (os.clock() * ROTATION_SPEED) % 360
		for _, gradient in ipairs(rotatingGradients) do
			if gradient and gradient.Parent then
				gradient.Rotation = rotationAngle
			end
		end
	end)
end

if getgenv then
	if getgenv().__HealthDisplayRotationConn then
		getgenv().__HealthDisplayRotationConn:Disconnect()
	end
	getgenv().__HealthDisplayRotationConn = startRotationLoop()
else
	startRotationLoop()
end

local function addTextShine(label, cycleTime)
	cycleTime = cycleTime or 1.6
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(190, 190, 190)),
		ColorSequenceKeypoint.new(0.45, Color3.fromRGB(190, 190, 190)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.55, Color3.fromRGB(190, 190, 190)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 190, 190)),
	})
	gradient.Offset = Vector2.new(-0.3, 0)
	gradient.Parent = label

	TweenService:Create(gradient, TweenInfo.new(cycleTime, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false), {
		Offset = Vector2.new(1.3, 0)
	}):Play()
end

local function startColorCycle(instance, colors, segmentTime)
	segmentTime = segmentTime or 0.9
	local running = true
	local index = 1
	local currentTween

	local function playNext()
		if not running then return end
		local nextIndex = (index % #colors) + 1
		currentTween = TweenService:Create(instance, TweenInfo.new(segmentTime, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			BackgroundColor3 = colors[nextIndex]
		})
		currentTween.Completed:Connect(function(state)
			if running and state == Enum.PlaybackState.Completed then
				index = nextIndex
				playNext()
			end
		end)
		currentTween:Play()
	end

	instance.BackgroundColor3 = colors[1]
	playNext()

	return function()
		running = false
		if currentTween then
			currentTween:Cancel()
		end
	end
end

local function addHealthDisplay(character)
	local humanoid = character:WaitForChild("Humanoid", 10)
	local head = character:WaitForChild("Head", 10)
	if not humanoid or not head then return end

	local old = head:FindFirstChild("HealthDisplay")
	if old then old:Destroy() end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "HealthDisplay"
	billboard.Adornee = head
	billboard.Size = UDim2.new(6, 0, 1.7, 0)
	billboard.StudsOffset = Vector3.new(0, 5.5, 0) -- تم رفعها الى 5.7
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 1000
	billboard.Parent = head

	local plr = Players:GetPlayerFromCharacter(character)

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, 0, 0.35, 0)
	nameLabel.Position = UDim2.new(0, 0, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextScaled = true
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextStrokeTransparency = 0
	nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	nameLabel.Text = plr and plr.Name or character.Name
	nameLabel.Parent = billboard
	addTextShine(nameLabel, 2)

	local barOuter = Instance.new("Frame")
	barOuter.Size = UDim2.new(1, 0, 0.32, 0)
	barOuter.Position = UDim2.new(0, 0, 0.62, 0)
	barOuter.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	barOuter.BorderSizePixel = 0
	barOuter.ZIndex = 2
	barOuter.Parent = billboard
	Instance.new("UICorner", barOuter).CornerRadius = UDim.new(1, 0)

	local shineStroke = Instance.new("UIStroke")
	shineStroke.Thickness = 3
	shineStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	shineStroke.Color = Color3.fromRGB(255, 255, 255)
	shineStroke.Parent = barOuter
	local shineGradient = Instance.new("UIGradient")
	shineGradient.Color = glowSequences.green
	shineGradient.Parent = shineStroke
	table.insert(rotatingGradients, shineGradient)

	local barBackground = Instance.new("Frame")
	barBackground.Size = UDim2.new(1, -6, 1, -6)
	barBackground.Position = UDim2.new(0, 3, 0, 3)
	barBackground.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	barBackground.BorderSizePixel = 0
	barBackground.ClipsDescendants = true
	barBackground.ZIndex = 2
	barBackground.Parent = barOuter
	Instance.new("UICorner", barBackground).CornerRadius = UDim.new(1, 0)

	local barFill = Instance.new("Frame")
	barFill.Size = UDim2.new(1, 0, 1, 0)
	barFill.BackgroundColor3 = colorCycleColors.green[1]
	barFill.BorderSizePixel = 0
	barFill.ZIndex = 3
	barFill.Parent = barBackground
	Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

	local damageFlash = Instance.new("Frame")
	damageFlash.Size = UDim2.new(1, 0, 1, 0)
	damageFlash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	damageFlash.BackgroundTransparency = 1
	damageFlash.BorderSizePixel = 0
	damageFlash.ZIndex = 5
	damageFlash.Parent = barBackground
	Instance.new("UICorner", damageFlash).CornerRadius = UDim.new(1, 0)

	local healthText = Instance.new("TextLabel")
	healthText.Size = UDim2.new(1, 0, 1, 0)
	healthText.BackgroundTransparency = 1
	healthText.TextScaled = true
	healthText.Font = Enum.Font.GothamBold
	healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
	healthText.TextStrokeTransparency = 0
	healthText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	healthText.Text = math.floor(humanoid.Health) .. " / " .. math.floor(humanoid.MaxHealth)
	healthText.ZIndex = 6
	healthText.Parent = barOuter
	addTextShine(healthText, 1.6)

	local currentState = nil
	local stopColorCycle = nil

	local function setGlowState(state)
		if state == currentState then return end
		currentState = state
		shineGradient.Color = glowSequences[state]
		if stopColorCycle then stopColorCycle() end
		stopColorCycle = startColorCycle(barFill, colorCycleColors[state])
	end

	local lastHealth = humanoid.Health

	local function updateHealth()
		local percent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)

		TweenService:Create(barFill, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
			Size = UDim2.new(percent, 0, 1, 0)
		}):Play()

		healthText.Text = math.floor(humanoid.Health) .. " / " .. math.floor(humanoid.MaxHealth)

		local state
		if percent > 0.5 then
			state = "green"
		elseif percent > 0.25 then
			state = "yellow"
		else
			state = "red"
		end

		setGlowState(state)

		if humanoid.Health < lastHealth then
			damageFlash.BackgroundTransparency = 0.4
			TweenService:Create(damageFlash, TweenInfo.new(0.35), { BackgroundTransparency = 1 }):Play()
		end
		lastHealth = humanoid.Health
	end

	humanoid.HealthChanged:Connect(updateHealth)
	updateHealth()

	character.AncestryChanged:Connect(function(_, parent)
		if not parent then
			if stopColorCycle then stopColorCycle() end
			for i, g in ipairs(rotatingGradients) do
				if g == shineGradient then
					table.remove(rotatingGradients, i)
					break
				end
			end
			billboard:Destroy()
		end
	end)
end

local function onPlayerAdded(player)
	player.CharacterAdded:Connect(addHealthDisplay)
	if player.Character then
		addHealthDisplay(player.Character)
	end
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end

Players.PlayerRemoving:Connect(function(player)
	local character = player.Character
	if character then
		local head = character:FindFirstChild("Head")
		if head then
			local billboard = head:FindFirstChild("HealthDisplay")
			if billboard then
				billboard:Destroy()
			end
		end
	end
end)
end)


task.spawn(function()
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- إنشاء الواجهة
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KillButtonGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- الزر الأول (القتل)
local button = Instance.new("ImageButton")
button.Name = "KillButton"
button.Size = UDim2.new(0, 50, 0, 50)
button.Position = UDim2.new(1, -70, 0.5, -25)
button.BackgroundTransparency = 1
button.Image = "rbxassetid://12222223187"
button.Parent = screenGui

-- صوت النقر
local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://126840987050328"
clickSound.Parent = button

-- الزر الثاني (تحت الأول)
local button2 = Instance.new("ImageButton")
button2.Name = "KillButton"
button2.Size = UDim2.new(0, 50, 0, 50)
button2.Position = UDim2.new(1, -70, 0.5, 35) -- تحت الزر الأول
button2.BackgroundTransparency = 1
button2.Image = "rbxassetid://10927329515"
button2.Parent = screenGui

-- منطق السحب (دالة عامة تشتغل لأي زر)
local function makeDraggable(btn)
    local dragging = false
    local dragStart, startPos

    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = btn.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            btn.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

makeDraggable(button)
makeDraggable(button2)

-- أنميشن الضغط (دالة عامة)
local function playClickAnimation(btn)
    local originalSize = btn.Size

    local shrink = TweenService:Create(
        btn,
        TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset - 12, originalSize.Y.Scale, originalSize.Y.Offset - 12),
          Rotation = 15 }
    )
    shrink:Play()

    shrink.Completed:Connect(function()
        local bounceBack = TweenService:Create(
            btn,
            TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            { Size = originalSize, Rotation = 0 }
        )
        bounceBack:Play()
    end)
end

-- دالة رش النجوم (تشتغل من موقع أي زر)
local function spawnStars(btn)
    local starCount = 5

    for i = 1, starCount do
        for _, direction in ipairs({-1, 1}) do
            local star = Instance.new("TextLabel")
            star.Text = "٭"
            star.TextColor3 = Color3.fromRGB(255, 255, 255)
            star.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            star.TextStrokeTransparency = 0.5
            star.Font = Enum.Font.GothamBold
            star.TextScaled = true
            star.Size = UDim2.new(0, 20, 0, 20)
            star.BackgroundTransparency = 1
            star.AnchorPoint = Vector2.new(0.5, 0.5)
            star.Position = UDim2.new(
                btn.Position.X.Scale, btn.Position.X.Offset + btn.Size.X.Offset / 2,
                btn.Position.Y.Scale, btn.Position.Y.Offset + btn.Size.Y.Offset / 2
            )
            star.ZIndex = 5
            star.Rotation = math.random(-30, 30)
            star.Parent = screenGui

            local distanceX = direction * math.random(60, 140)
            local distanceY = math.random(-60, 60)

            local targetPos = UDim2.new(
                star.Position.X.Scale, star.Position.X.Offset + distanceX,
                star.Position.Y.Scale, star.Position.Y.Offset + distanceY
            )

            local flyTween = TweenService:Create(
                star,
                TweenInfo.new(0.5 + math.random() * 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { Position = targetPos, TextTransparency = 1, TextStrokeTransparency = 1, Rotation = star.Rotation + math.random(-90, 90) }
            )
            flyTween:Play()

            flyTween.Completed:Connect(function()
                star:Destroy()
            end)
        end
    end
end

-- منطق القتل عند ضغط الزر الأول
button.MouseButton1Click:Connect(function()
    clickSound:Play()
    playClickAnimation(button)
    spawnStars(button)

    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = 0
        end
    end
end)

button2.MouseButton1Click:Connect(function()
    clickSound:Play()
    playClickAnimation(button2)
    spawnStars(button2)
    
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = 1
        end
    end
end)
end) 


task.spawn(function()
--[[
    إشعارات دخول وخروج وطرد اللاعبين - نسخة فاخرة نهائية
    (دمج إعادة الاتصال + ظل وتوهج بواسطة UIShadow الأصلي من روبلوكس)
    ضع هذا السكربت كـ LocalScript داخل StarterGui
--]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ====== إعدادات الصوت ======
local JOIN_SOUND_ID = "rbxassetid://128707491647978"
local LEAVE_SOUND_ID = "rbxassetid://128707491647978"
local KICK_SOUND_ID = "rbxassetid://128707491647978"
local SOUND_VOLUME = 0.55
local DISPLAY_DURATION = 4.5
local CARD_WIDTH = 290
local CARD_HEIGHT = 90

-- ====== إعدادات قوة ظهور الظل والتوهج (UIShadow) — عدّلتها لظل أوضح بحواف محددة ======
local DROP_SHADOW_NEAR_ALPHA = 0.35
local DROP_SHADOW_FAR_ALPHA = 0.78
local AMBIENT_GLOW_ALPHA = 0.6

-- ====== إعداد دمج إعادة الاتصال (خفضتها من ١٢ إلى ٢ ثانية عشان يبين إشعار الخروج بسرعة) ======
local RECONNECT_GRACE_PERIOD = 2

local function playSound(soundId)
	local sound = Instance.new("Sound")
	sound.SoundId = soundId
	sound.Volume = SOUND_VOLUME
	sound.Parent = SoundService
	sound:Play()
	Debris:AddItem(sound, 5)
end

-- ====== تتبع مدة البقاء وعدد الدخول/الخروج ======
local sessionStats = {}
local function getStats(userId)
	if not sessionStats[userId] then
		sessionStats[userId] = { joins = 0, leaves = 0, joinTime = nil }
	end
	return sessionStats[userId]
end

for _, existingPlayer in ipairs(Players:GetPlayers()) do
	if existingPlayer ~= player then
		local stats = getStats(existingPlayer.UserId)
		stats.joins = 1
		stats.joinTime = os.time()
	end
end

local function formatDuration(seconds)
	seconds = math.max(0, math.floor(seconds))
	if seconds < 60 then
		return "Stayed " .. seconds .. "s"
	elseif seconds < 3600 then
		local minutes = math.floor(seconds / 60)
		return "Stayed " .. minutes .. "m"
	else
		local hours = math.floor(seconds / 3600)
		local minutes = math.floor((seconds % 3600) / 60)
		return "Stayed " .. hours .. "h " .. minutes .. "m"
	end
end

-- ====== تنظيف النص من أحرف التحكم الخفية ======
local BIDI_CONTROL_CHARS = {
	[0x200E] = true, [0x200F] = true, [0x202A] = true, [0x202B] = true,
	[0x202C] = true, [0x202D] = true, [0x202E] = true, [0x2066] = true,
	[0x2067] = true, [0x2068] = true, [0x2069] = true, [0x061C] = true,
	[0x200B] = true, [0x200C] = true, [0x200D] = true, [0xFEFF] = true,
}

local function sanitizeText(text)
	local ok, result = pcall(function()
		local cleaned = {}
		for _, codepoint in utf8.codes(text) do
			if not BIDI_CONTROL_CHARS[codepoint] then
				table.insert(cleaned, utf8.char(codepoint))
			end
		end
		return table.concat(cleaned)
	end)
	if ok and result ~= "" then
		return result
	end
	return text
end

-- ====== فحص الاتجاه بأول "حرف قوي" بس ======
local function getFirstStrongDirection(text)
	local ok, isRTL = pcall(function()
		for _, codepoint in utf8.codes(text) do
			local isArabic = (codepoint >= 0x0600 and codepoint <= 0x06FF)
				or (codepoint >= 0x0750 and codepoint <= 0x077F)
				or (codepoint >= 0xFB50 and codepoint <= 0xFDFF)
				or (codepoint >= 0xFE70 and codepoint <= 0xFEFF)
			local isLatin = (codepoint >= 0x0041 and codepoint <= 0x005A)
				or (codepoint >= 0x0061 and codepoint <= 0x007A)
			if isArabic then
				return true
			elseif isLatin then
				return false
			end
		end
		return false
	end)
	if ok then return isRTL end
	return false
end

local function applyTextDirection(label, rawText, forceLTR)
	label.AutoLocalize = false
	local cleanText = sanitizeText(rawText)
	label.RichText = false
	label.Text = cleanText

	if forceLTR then
		label.TextDirection = Enum.TextDirection.LeftToRight
		label.TextXAlignment = Enum.TextXAlignment.Left
		return
	end

	label.TextDirection = Enum.TextDirection.Auto

	if getFirstStrongDirection(cleanText) then
		label.TextXAlignment = Enum.TextXAlignment.Right
	else
		label.TextXAlignment = Enum.TextXAlignment.Left
	end
end

-- ====== أنظمة الألوان اللامعة ======
local rotatingGradients = {}

local greenGlossySequence = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 40, 20)),
	ColorSequenceKeypoint.new(0.3, Color3.fromRGB(120, 255, 150)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 120, 60)),
	ColorSequenceKeypoint.new(0.7, Color3.fromRGB(120, 255, 150)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 40, 20)),
})

local redGlossySequence = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 10, 10)),
	ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 110, 110)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 25, 25)),
	ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 110, 110)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 10, 10)),
})

local kickGlossySequence = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(4, 4, 4)),
	ColorSequenceKeypoint.new(0.3, Color3.fromRGB(150, 20, 20)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(35, 4, 4)),
	ColorSequenceKeypoint.new(0.7, Color3.fromRGB(150, 20, 20)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 4, 4)),
})

local blueGlossySequence = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 20, 40)),
	ColorSequenceKeypoint.new(0.3, Color3.fromRGB(110, 190, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 80, 130)),
	ColorSequenceKeypoint.new(0.7, Color3.fromRGB(110, 190, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 20, 40)),
})

local function applyMetallicStyle(targetFrame, borderThickness, colorSequence)
	borderThickness = borderThickness or 2

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = borderThickness
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Transparency = 1
	stroke.Parent = targetFrame

	local strokeGradient = Instance.new("UIGradient")
	strokeGradient.Color = colorSequence
	strokeGradient.Parent = stroke

	table.insert(rotatingGradients, strokeGradient)
	return stroke, strokeGradient
end

local function removeGradient(gradient)
	for i, g in ipairs(rotatingGradients) do
		if g == gradient then
			table.remove(rotatingGradients, i)
			break
		end
	end
end

local rotationAngle = 0
RunService.RenderStepped:Connect(function(delta)
	rotationAngle = rotationAngle + (45 * delta)
	for _, gradient in ipairs(rotatingGradients) do
		if gradient and gradient.Parent then
			gradient.Rotation = rotationAngle
		end
	end
end)

-- ====== الواجهة الأساسية ======
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JoinLeaveNotifications"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 100
screenGui.Parent = playerGui

local container = Instance.new("Frame")
container.Name = "Container"
container.AnchorPoint = Vector2.new(1, 0)
container.Position = UDim2.new(1, -20, 0, 90)
container.Size = UDim2.new(0, 300, 1, -110)
container.BackgroundTransparency = 1
container.Parent = screenGui

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 10)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = container

local function addCorner(instance, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 12)
	corner.Parent = instance
	return corner
end

local function addGradient(instance, colorSeq, rotation, transparencySeq)
	local gradient = Instance.new("UIGradient")
	gradient.Color = colorSeq
	gradient.Rotation = rotation or 90
	if transparencySeq then
		gradient.Transparency = transparencySeq
	end
	gradient.Parent = instance
	return gradient
end

local orderCounter = 0
local function nextOrder()
	orderCounter += 1
	return orderCounter
end

-- ====== ظل وتوهج أصليين بواسطة UIShadow (يحل محل تكديس الفريمات والصور القديمة) ======
-- UIShadow: Instance حديث من روبلوكس يعطي بلور حقيقي بدون أي صورة خارجية،
-- ومحصور تلقائيًا بشكل العنصر الأب (card) — ما يصير له "تسريب" خارج حدوده أبدًا.
local function createUIShadow(parent, color, blurRadius, offsetY, spread, zIndex)
	local shadow = Instance.new("UIShadow")
	shadow.Name = "UIShadow"
	shadow.Color = color
	shadow.Transparency = 1
	shadow.BlurRadius = UDim.new(0, blurRadius)
	shadow.Offset = UDim2.new(0, 0, 0, offsetY)
	shadow.Spread = UDim2.new(0, spread, 0, spread)
	shadow.ZIndex = zIndex
	shadow.Parent = parent
	return shadow
end

-- ====== دالة إنشاء إشعار ======
local function createNotification(playerObj, eventType)
	local isJoining = eventType == "join"
	local isKicked = eventType == "kick"
	local isReconnect = eventType == "reconnect"

	if isJoining or isReconnect then
		playSound(JOIN_SOUND_ID)
	elseif isKicked then
		playSound(KICK_SOUND_ID)
	else
		playSound(LEAVE_SOUND_ID)
	end

	local glossColorSeq, haloColor, cardBgColor
	if isKicked then
		glossColorSeq = kickGlossySequence
		haloColor = Color3.fromRGB(190, 35, 35)
		cardBgColor = Color3.fromRGB(9, 4, 4)
	elseif isReconnect then
		glossColorSeq = blueGlossySequence
		haloColor = Color3.fromRGB(110, 190, 255)
		cardBgColor = Color3.fromRGB(12, 12, 15)
	elseif isJoining then
		glossColorSeq = greenGlossySequence
		haloColor = Color3.fromRGB(90, 235, 150)
		cardBgColor = Color3.fromRGB(12, 12, 15)
	else
		glossColorSeq = redGlossySequence
		haloColor = Color3.fromRGB(235, 90, 90)
		cardBgColor = Color3.fromRGB(12, 12, 15)
	end

	local slot = Instance.new("Frame")
	slot.Name = "NotificationSlot"
	slot.Size = UDim2.new(0, CARD_WIDTH, 0, CARD_HEIGHT)
	slot.BackgroundTransparency = 1
	slot.ClipsDescendants = false
	slot.LayoutOrder = nextOrder()
	slot.Parent = container

	local card = Instance.new("Frame")
	card.Name = "NotificationCard"
	card.Size = UDim2.new(0, CARD_WIDTH, 0, CARD_HEIGHT)
	card.BackgroundColor3 = cardBgColor
	card.BackgroundTransparency = 0.22
	card.ClipsDescendants = true
	card.ZIndex = 2
	card.Parent = slot

	local cardScale = Instance.new("UIScale")
	cardScale.Scale = 0.9
	cardScale.Parent = card

	addCorner(card, 18)
	local mainStroke, mainGradient = applyMetallicStyle(card, 1.5, glossColorSeq)

	-- الظل: طبقتين (قريبة حادة تعطي حافة واضحة + بعيدة ناعمة تعطي عمق)، وفوقها توهج ملوّن حسب نوع الحدث
	local dropShadowFar = createUIShadow(card, Color3.fromRGB(0, 0, 0), 20, 7, 2, -3)
	local dropShadowNear = createUIShadow(card, Color3.fromRGB(0, 0, 0), 5, 2, 1, -2)
	local ambientGlow = createUIShadow(card, haloColor, 34, 0, 3, -1)

	addGradient(
		card,
		ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 42)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 10)),
		}),
		115
	)

	local gloss = Instance.new("Frame")
	gloss.Name = "Gloss"
	gloss.Size = UDim2.new(1, 0, 0.5, 0)
	gloss.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	gloss.BackgroundTransparency = 1
	gloss.BorderSizePixel = 0
	gloss.ZIndex = 2
	gloss.Parent = card
	addCorner(gloss, 18)
	addGradient(gloss, ColorSequence.new(Color3.fromRGB(255, 255, 255)), 90, NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.9),
		NumberSequenceKeypoint.new(1, 1),
	}))

	-- ====== تظليل خفيف بالأسفل (يقابل اللمعة فوق = إحساس منحوت/ثلاثي الأبعاد) ======
	local shade = Instance.new("Frame")
	shade.Name = "Shade"
	shade.AnchorPoint = Vector2.new(0, 1)
	shade.Position = UDim2.new(0, 0, 1, 0)
	shade.Size = UDim2.new(1, 0, 0.5, 0)
	shade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	shade.BackgroundTransparency = 1
	shade.BorderSizePixel = 0
	shade.ZIndex = 2
	shade.Parent = card
	addCorner(shade, 18)
	addGradient(shade, ColorSequence.new(Color3.fromRGB(0, 0, 0)), 90, NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(1, 0.55),
	}))

	local avatarFrame = Instance.new("Frame")
	avatarFrame.Name = "AvatarFrame"
	avatarFrame.Size = UDim2.new(0, 46, 0, 46)
	avatarFrame.Position = UDim2.new(0, 14, 0, 10)
	avatarFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
	avatarFrame.ZIndex = 3
	avatarFrame.Parent = card
	addCorner(avatarFrame, 100)

	-- ملاحظة: توهج الأفاتار خلّيناه بنفس أسلوب الصورة القديم (ImageLabel) عن قصد،
	-- لأن UIShadow حاليًا يعطي حواف مسننة على الأشكال الدائرية الكاملة زي هالإطار.
	local pulseGlow = Instance.new("ImageLabel")
	pulseGlow.Name = "PulseGlow"
	pulseGlow.AnchorPoint = Vector2.new(0.5, 0.5)
	pulseGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
	pulseGlow.Size = UDim2.new(1, 20, 1, 20)
	pulseGlow.BackgroundTransparency = 1
	pulseGlow.Image = "rbxassetid://5028857084"
	pulseGlow.ImageColor3 = haloColor
	pulseGlow.ImageTransparency = 0.5
	pulseGlow.ZIndex = 1
	pulseGlow.Parent = avatarFrame

	local avatarStroke = Instance.new("UIStroke")
	avatarStroke.Thickness = 2.5
	avatarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	avatarStroke.Color = Color3.fromRGB(255, 255, 255)
	avatarStroke.Transparency = 0.15
	avatarStroke.Parent = avatarFrame

	local avatarGradient = Instance.new("UIGradient")
	avatarGradient.Color = glossColorSeq
	avatarGradient.Parent = avatarStroke
	table.insert(rotatingGradients, avatarGradient)

	local avatarImage = Instance.new("ImageLabel")
	avatarImage.Name = "AvatarImage"
	avatarImage.Size = UDim2.new(1, 0, 1, 0)
	avatarImage.BackgroundTransparency = 1
	avatarImage.Image = ""
	avatarImage.ImageTransparency = 1
	avatarImage.ZIndex = 5
	avatarImage.Parent = avatarFrame
	addCorner(avatarImage, 100)

	task.spawn(function()
		local ok, content = pcall(function()
			return Players:GetUserThumbnailAsync(
				playerObj.UserId,
				Enum.ThumbnailType.HeadShot,
				Enum.ThumbnailSize.Size420x420
			)
		end)
		if ok and avatarImage.Parent then
			avatarImage.Image = content
			TweenService:Create(avatarImage, TweenInfo.new(0.3), { ImageTransparency = 0 }):Play()
		end
	end)

	local glowRunning = true
	task.spawn(function()
		while glowRunning and pulseGlow.Parent do
			local grow = TweenService:Create(pulseGlow, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Size = UDim2.new(1, 34, 1, 34),
				ImageTransparency = 0.75,
			})
			grow:Play()
			grow.Completed:Wait()
			if not (glowRunning and pulseGlow.Parent) then break end
			local shrink = TweenService:Create(pulseGlow, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Size = UDim2.new(1, 20, 1, 20),
				ImageTransparency = 0.5,
			})
			shrink:Play()
			shrink.Completed:Wait()
		end
	end)

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "NameLabel"
	nameLabel.BackgroundTransparency = 1
	nameLabel.Position = UDim2.new(0, 72, 0, 10)
	nameLabel.Size = UDim2.new(1, -96, 0, 20)
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 15
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
	nameLabel.ZIndex = 3
	nameLabel.Parent = card
	applyTextDirection(nameLabel, playerObj.DisplayName)

	-- ====== نقطة مؤشر LED نابضة بلون الحدث ======
	local statusDot = Instance.new("Frame")
	statusDot.Name = "StatusDot"
	statusDot.AnchorPoint = Vector2.new(1, 0)
	statusDot.Position = UDim2.new(1, -10, 0, 10)
	statusDot.Size = UDim2.new(0, 8, 0, 8)
	statusDot.BackgroundColor3 = haloColor
	statusDot.BackgroundTransparency = 1
	statusDot.BorderSizePixel = 0
	statusDot.ZIndex = 4
	statusDot.Parent = card
	addCorner(statusDot, 100)

	local statusDotStroke = Instance.new("UIStroke")
	statusDotStroke.Thickness = 1
	statusDotStroke.Color = Color3.fromRGB(255, 255, 255)
	statusDotStroke.Transparency = 0.4
	statusDotStroke.Parent = statusDot

	TweenService:Create(
		statusDotStroke,
		TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
		{ Transparency = 0.9 }
	):Play()

	local usernameTag = Instance.new("TextLabel")
	usernameTag.Name = "UsernameTag"
	usernameTag.BackgroundTransparency = 1
	usernameTag.Position = UDim2.new(0, 72, 0, 31)
	usernameTag.Size = UDim2.new(0.5, -84, 0, 16)
	usernameTag.Font = Enum.Font.Gotham
	usernameTag.TextSize = 12
	usernameTag.TextColor3 = Color3.fromRGB(170, 170, 178)
	usernameTag.TextXAlignment = Enum.TextXAlignment.Left
	usernameTag.TextDirection = Enum.TextDirection.LeftToRight
	usernameTag.TextTruncate = Enum.TextTruncate.AtEnd
	usernameTag.RichText = false
	usernameTag.AutoLocalize = false
	usernameTag.Text = "@" .. sanitizeText(playerObj.Name)
	usernameTag.ZIndex = 3
	usernameTag.Parent = card

	local statusText
	if isKicked then
		statusText = "Kicked"
	elseif isReconnect then
		statusText = "Reconnected"
	elseif isJoining then
		statusText = "Joined the game"
	else
		statusText = "Left the game"
	end

	local statusTag = Instance.new("TextLabel")
	statusTag.Name = "StatusTag"
	statusTag.BackgroundTransparency = 1
	statusTag.Position = UDim2.new(0.45, 0, 0, 31)
	statusTag.Size = UDim2.new(0.55, -12, 0, 16)
	statusTag.Font = (isKicked or isReconnect) and Enum.Font.GothamBold or Enum.Font.Gotham
	statusTag.TextSize = 12
	statusTag.TextColor3 = isKicked and Color3.fromRGB(255, 90, 90) or (isReconnect and Color3.fromRGB(140, 210, 255) or Color3.fromRGB(170, 170, 178))
	statusTag.TextXAlignment = Enum.TextXAlignment.Right
	statusTag.TextDirection = Enum.TextDirection.LeftToRight
	statusTag.TextTruncate = Enum.TextTruncate.AtEnd
	statusTag.RichText = false
	statusTag.AutoLocalize = false
	statusTag.Text = statusText
	statusTag.ZIndex = 3
	statusTag.Parent = card

	local stats = getStats(playerObj.UserId)
	local extraParts = {}
	if (eventType == "leave" or eventType == "kick") and stats.joinTime then
		table.insert(extraParts, formatDuration(os.time() - stats.joinTime))
	end
	table.insert(extraParts, "Joins: " .. stats.joins .. " | Leaves: " .. stats.leaves)
	local extraText = table.concat(extraParts, "  •  ")

	local extraLabel = Instance.new("TextLabel")
	extraLabel.Name = "ExtraInfoLabel"
	extraLabel.BackgroundTransparency = 1
	extraLabel.Position = UDim2.new(0, 72, 0, 50)
	extraLabel.Size = UDim2.new(1, -84, 0, 14)
	extraLabel.Font = Enum.Font.Gotham
	extraLabel.TextSize = 11
	extraLabel.TextColor3 = Color3.fromRGB(140, 140, 148)
	extraLabel.TextXAlignment = Enum.TextXAlignment.Left
	extraLabel.TextDirection = Enum.TextDirection.LeftToRight
	extraLabel.TextTruncate = Enum.TextTruncate.AtEnd
	extraLabel.RichText = false
	extraLabel.AutoLocalize = false
	extraLabel.Text = extraText
	extraLabel.ZIndex = 3
	extraLabel.Parent = card

	local progressTrack = Instance.new("Frame")
	progressTrack.Name = "ProgressTrack"
	progressTrack.Size = UDim2.new(1, -24, 0, 4)
	progressTrack.Position = UDim2.new(0, 12, 1, -12)
	progressTrack.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	progressTrack.BackgroundTransparency = 0.9
	progressTrack.BorderSizePixel = 0
	progressTrack.ZIndex = 3
	progressTrack.Parent = card
	addCorner(progressTrack, 100)

	local progressGlow = Instance.new("UIStroke")
	progressGlow.Thickness = 1.5
	progressGlow.Color = haloColor
	progressGlow.Transparency = 0.4
	progressGlow.Parent = progressTrack

	TweenService:Create(
		progressGlow,
		TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
		{ Transparency = 0.9 }
	):Play()

	local progressBar = Instance.new("Frame")
	progressBar.Name = "ProgressBar"
	progressBar.Size = UDim2.new(1, 0, 1, 0)
	progressBar.BackgroundColor3 = haloColor
	progressBar.BorderSizePixel = 0
	progressBar.ClipsDescendants = true
	progressBar.ZIndex = 4
	progressBar.Parent = progressTrack
	addCorner(progressBar, 100)

	local shine = Instance.new("Frame")
	shine.Name = "Shine"
	shine.Size = UDim2.new(0, 30, 1, 0)
	shine.Position = UDim2.new(0, -30, 0, 0)
	shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	shine.BorderSizePixel = 0
	shine.ZIndex = 5
	shine.Parent = progressBar
	addGradient(shine, ColorSequence.new(Color3.fromRGB(255, 255, 255)), 0, NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.5, 0.35),
		NumberSequenceKeypoint.new(1, 1),
	}))

	local shineRunning = true
	task.spawn(function()
		while shineRunning and shine.Parent do
			shine.Position = UDim2.new(0, -30, 0, 0)
			local sweep = TweenService:Create(shine, TweenInfo.new(1, Enum.EasingStyle.Linear), {
				Position = UDim2.new(1, 30, 0, 0),
			})
			sweep:Play()
			sweep.Completed:Wait()
			task.wait(0.35)
		end
	end)

	card.Position = UDim2.new(1, 60, 0, 0)
	card.BackgroundTransparency = 1
	gloss.BackgroundTransparency = 1
	shade.BackgroundTransparency = 1
	nameLabel.TextTransparency = 1
	usernameTag.TextTransparency = 1
	statusTag.TextTransparency = 1
	statusDot.BackgroundTransparency = 1
	extraLabel.TextTransparency = 1
	avatarFrame.BackgroundTransparency = 1
	progressTrack.BackgroundTransparency = 1

	local slideIn = TweenService:Create(card, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 0.22,
	})
	TweenService:Create(cardScale, TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Scale = 1 }):Play()
	TweenService:Create(gloss, TweenInfo.new(0.4), { BackgroundTransparency = 0.94 }):Play()
	TweenService:Create(shade, TweenInfo.new(0.4), { BackgroundTransparency = 0.5 }):Play()
	TweenService:Create(nameLabel, TweenInfo.new(0.35), { TextTransparency = 0 }):Play()
	TweenService:Create(usernameTag, TweenInfo.new(0.35), { TextTransparency = 0 }):Play()
	TweenService:Create(statusTag, TweenInfo.new(0.35), { TextTransparency = 0 }):Play()
	TweenService:Create(statusDot, TweenInfo.new(0.35), { BackgroundTransparency = 0 }):Play()
	TweenService:Create(extraLabel, TweenInfo.new(0.35), { TextTransparency = 0.15 }):Play()
	TweenService:Create(avatarFrame, TweenInfo.new(0.35), { BackgroundTransparency = 0 }):Play()
	TweenService:Create(mainStroke, TweenInfo.new(0.35), { Transparency = 0.1 }):Play()
	TweenService:Create(progressTrack, TweenInfo.new(0.35), { BackgroundTransparency = 0.9 }):Play()
	TweenService:Create(dropShadowFar, TweenInfo.new(0.45), { Transparency = DROP_SHADOW_FAR_ALPHA }):Play()
	TweenService:Create(dropShadowNear, TweenInfo.new(0.45), { Transparency = DROP_SHADOW_NEAR_ALPHA }):Play()
	TweenService:Create(ambientGlow, TweenInfo.new(0.5), { Transparency = AMBIENT_GLOW_ALPHA }):Play()
	slideIn:Play()

	TweenService:Create(progressBar, TweenInfo.new(DISPLAY_DURATION, Enum.EasingStyle.Linear), {
		Size = UDim2.new(0, 0, 1, 0),
	}):Play()

	task.delay(DISPLAY_DURATION, function()
		if not card.Parent then return end

		glowRunning = false
		shineRunning = false

		local fadeOut = TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
			Position = UDim2.new(1, 60, 0, 0),
			BackgroundTransparency = 1,
		})
		TweenService:Create(cardScale, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Scale = 0.92 }):Play()
		TweenService:Create(gloss, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
		TweenService:Create(shade, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
		TweenService:Create(nameLabel, TweenInfo.new(0.25), { TextTransparency = 1 }):Play()
		TweenService:Create(usernameTag, TweenInfo.new(0.25), { TextTransparency = 1 }):Play()
		TweenService:Create(statusTag, TweenInfo.new(0.25), { TextTransparency = 1 }):Play()
		TweenService:Create(statusDot, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
		TweenService:Create(extraLabel, TweenInfo.new(0.25), { TextTransparency = 1 }):Play()
		TweenService:Create(avatarFrame, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
		TweenService:Create(mainStroke, TweenInfo.new(0.25), { Transparency = 1 }):Play()
		TweenService:Create(progressTrack, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
		TweenService:Create(dropShadowFar, TweenInfo.new(0.3), { Transparency = 1 }):Play()
		TweenService:Create(dropShadowNear, TweenInfo.new(0.3), { Transparency = 1 }):Play()
		TweenService:Create(ambientGlow, TweenInfo.new(0.3), { Transparency = 1 }):Play()

		fadeOut:Play()
		fadeOut.Completed:Wait()
		removeGradient(mainGradient)
		removeGradient(avatarGradient)
		slot:Destroy()
	end)
end

-- ====== نظام دمج إعادة الاتصال ======
local pendingLeaves = {}
local leaveTokenCounter = 0

-- ====== ربط الأحداث ======
Players.PlayerAdded:Connect(function(playerObj)
	if playerObj == player then return end

	if pendingLeaves[playerObj.UserId] then
		pendingLeaves[playerObj.UserId] = nil
		createNotification(playerObj, "reconnect")
		return
	end

	local stats = getStats(playerObj.UserId)
	stats.joins += 1
	stats.joinTime = os.time()
	createNotification(playerObj, "join")
end)

Players.PlayerRemoving:Connect(function(playerObj)
	local wasKicked = playerObj:GetAttribute("WasKicked") == true

	if wasKicked then
		local stats = getStats(playerObj.UserId)
		stats.leaves += 1
		createNotification(playerObj, "kick")
		return
	end

	local userId = playerObj.UserId
	leaveTokenCounter += 1
	local myToken = leaveTokenCounter

	pendingLeaves[userId] = {
		token = myToken,
		name = playerObj.Name,
		displayName = playerObj.DisplayName,
		userId = userId,
		reconnected = false,
	}

	task.delay(RECONNECT_GRACE_PERIOD, function()
		local pending = pendingLeaves[userId]
		if pending and pending.token == myToken and not pending.reconnected then
			pendingLeaves[userId] = nil
			local stats = getStats(userId)
			stats.leaves += 1
			createNotification({
				UserId = pending.userId,
				Name = pending.name,
				DisplayName = pending.displayName,
			}, "leave")
		end
	end)
end)
end)

task.spawn(function()
----------------------------------------------------------------
-- 1) تحميل Rayfield + إعداد الخدمات
----------------------------------------------------------------
local rayfieldOk, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)
if not rayfieldOk or not Rayfield then
    warn("تعذر تحميل مكتبة الواجهة Rayfield - تحقق من اتصالك بالإنترنت")
    return
end

local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
pcall(function() HttpService.HttpEnabled = true end)

-- حدث تطبيق السكن (يُبحث عنه بأمان حتى ما يوقف السكربت لو تغيّر مساره)
local ApplyMainAvatarEvent = ReplicatedStorage:FindFirstChild("ApplyMainAvatar")

----------------------------------------------------------------
-- 2) ألوان الثيم (أسود + أبيض + لامع)
----------------------------------------------------------------
local UI_BASE_BLACK = Color3.fromRGB(5, 5, 5)
local UI_CARD_BLACK = Color3.fromRGB(22, 22, 22)
local UI_WHITE      = Color3.fromRGB(255, 255, 255)
local UI_LIGHTGRAY  = Color3.fromRGB(190, 190, 190)

local function applyGlossyDark(instance, baseColor)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 60)),
        ColorSequenceKeypoint.new(0.5, baseColor),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30)),
    })
    gradient.Rotation = 90
    gradient.Parent = instance
    return gradient
end

-- بدون أي تأثير ليزر
local function addLaserScanEffect(panel)
    -- لا شيء
end

----------------------------------------------------------------
-- 2.5) تأثيرات فضية لامعة: إطار دوّار + نص لامع (بدون خلفية متحركة)
----------------------------------------------------------------
local function applySilverSpinBorder(frame, thickness, customColorSequence)
    local stroke = frame:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke")
    stroke.Thickness = thickness or 1.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.LineJoinMode = Enum.LineJoinMode.Round
    stroke.Color = UI_WHITE
    stroke.Parent = frame

    local gradient = stroke:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")
    gradient.Color = customColorSequence or ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(90, 90, 90)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
    })
    gradient.Parent = stroke

    local rotationConnection
    rotationConnection = RunService.RenderStepped:Connect(function(delta)
        if not gradient or not gradient.Parent then
            rotationConnection:Disconnect()
            return
        end
        gradient.Rotation = (gradient.Rotation + (75 * delta)) % 360
    end)
end

local function applyGlossyContrastStyle(textLabel, customColorSequence)
    textLabel.TextColor3 = UI_WHITE
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.TextStrokeTransparency = 0.2

    local gradient = textLabel:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient", textLabel)
    gradient.Rotation = 0
    gradient.Color = customColorSequence or ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 150, 150)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(220, 220, 220)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(220, 220, 220)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 150)),
    })

    local speed = 0.034
    local offset = -1.2
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not gradient.Parent then
            conn:Disconnect()
            return
        end
        offset = offset + speed
        if offset > 1.2 then offset = -1.2 end
        gradient.Offset = Vector2.new(offset, 0)
    end)
end

----------------------------------------------------------------
-- 3) أدوات عامة
----------------------------------------------------------------
local function copyToClipboard(text)
    local fn = setclipboard or toclipboard
    if not fn then return false end
    return pcall(fn, text)
end

local function safeDecode(body)
    if not body or body == "" then return false, nil end
    local ok, data = pcall(HttpService.JSONDecode, HttpService, body)
    if not ok or type(data) ~= "table" then return false, nil end
    return true, data
end

local function sendToast(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 5})
    end)
end

----------------------------------------------------------------
-- 4) طبقة HttpService قوية (مهلة زمنية + تصاعد زمني + تمييز الأخطاء)
----------------------------------------------------------------
local MAX_ATTEMPTS = 4
local REQUEST_TIMEOUT = 10
local BASE_BACKOFF = 0.5

local function performRawRequest(options)
    if syn and syn.request then return syn.request(options)
    elseif fluxus and fluxus.request then return fluxus.request(options)
    elseif http and http.request then return http.request(options)
    elseif http_request then return http_request(options)
    elseif request then return request(options)
    else
        local res = HttpService:RequestAsync({
            Url = options.Url, Method = options.Method,
            Headers = options.Headers, Body = options.Body,
        })
        return {StatusCode = res.StatusCode, Body = res.Body}
    end
end

local function requestWithTimeout(options, timeoutSeconds)
    local completed = false
    local ok, result
    task.spawn(function()
        ok, result = pcall(performRawRequest, options)
        completed = true
    end)
    local elapsed, step = 0, 0.05
    while not completed and elapsed < timeoutSeconds do
        task.wait(step)
        elapsed += step
    end
    if not completed then return false, nil, "timeout" end
    if not ok then return false, nil, "exception" end
    return true, result, nil
end

local function httpRequest(options)
    local lastErrorMessage = "تعذر الاتصال بالخادم بعد عدة محاولات"
    for attempt = 1, MAX_ATTEMPTS do
        local success, result, failKind = requestWithTimeout(options, REQUEST_TIMEOUT)
        if success and result then
            local status = result.StatusCode
            if status and status >= 200 and status < 300 and result.Body then
                return true, result.Body
            elseif status == 429 then
                lastErrorMessage = "تم تجاوز الحد المسموح من الطلبات"
                task.wait(BASE_BACKOFF * (2 ^ (attempt - 1)) + math.random() * 0.3)
            elseif status and status >= 500 then
                lastErrorMessage = "الخادم لا يستجيب حالياً"
                task.wait(BASE_BACKOFF * attempt)
            elseif status and status >= 400 then
                return false, "طلب غير صالح (كود " .. tostring(status) .. ")"
            else
                lastErrorMessage = "استجابة غير متوقعة من الخادم"
                task.wait(BASE_BACKOFF * attempt)
            end
        elseif failKind == "timeout" then
            lastErrorMessage = "انتهت المهلة الزمنية للطلب، تحقق من اتصالك بالإنترنت"
            task.wait(BASE_BACKOFF * attempt)
        else
            lastErrorMessage = "تعذر الاتصال بالخادم"
            task.wait(BASE_BACKOFF * attempt)
        end
    end
    return false, lastErrorMessage
end

----------------------------------------------------------------
-- 5) الكاش
----------------------------------------------------------------
local CACHE_TTL = 60
local searchCache = {}

local function getCached(key)
    local entry = searchCache[key:lower()]
    if entry and (tick() - entry.time) < CACHE_TTL then return entry end
    return nil
end

local function setCached(key, data)
    data.time = tick()
    searchCache[key:lower()] = data
end

----------------------------------------------------------------
-- 6) المفضلة (محفوظة بملف محلي إذا المنفذ يدعم ذلك)
----------------------------------------------------------------
local FAVORITES_FILE = "player_lookup_favorites.json"
local favorites = {}

local function loadFavorites()
    if not (isfile and readfile) then return end
    local existsOk, exists = pcall(isfile, FAVORITES_FILE)
    if existsOk and exists then
        local readOk, raw = pcall(readfile, FAVORITES_FILE)
        if readOk then
            local decodeOk, data = safeDecode(raw)
            if decodeOk and type(data) == "table" then favorites = data end
        end
    end
end

local function saveFavorites()
    if not writefile then return end
    pcall(writefile, FAVORITES_FILE, HttpService:JSONEncode(favorites))
end

----------------------------------------------------------------
-- 7) دوال Roblox API
----------------------------------------------------------------
local function resolveUsername(username)
    local body = HttpService:JSONEncode({usernames = {username}, excludeBannedUsers = false})
    local ok, res = httpRequest({
        Url = "https://users.roblox.com/v1/usernames/users", Method = "POST",
        Headers = {["Content-Type"] = "application/json"}, Body = body,
    })
    if not ok then return nil, res end
    local decodeOk, data = safeDecode(res)
    if not decodeOk then return nil, "تعذر قراءة استجابة الخادم" end
    if not data.data or #data.data == 0 then return nil, "لم يتم العثور على هذا المستخدم" end
    local u = data.data[1]
    return {id = u.id, name = u.name, displayName = u.displayName}
end

local function getUserDetails(userId)
    local ok, res = httpRequest({Url = "https://users.roblox.com/v1/users/"..userId, Method = "GET"})
    if not ok then return nil end
    local decodeOk, data = safeDecode(res)
    if not decodeOk then return nil end
    return data
end

local function resolveUserInput(input)
    local trimmed = input:match("^%s*(.-)%s*$")
    local asId = trimmed:match("^%d+$")
    if asId then
        local details = getUserDetails(asId)
        if not details or not details.name then
            return nil, "لم يتم العثور على مستخدم بهذا المعرف"
        end
        return {id = tonumber(asId), name = details.name, displayName = details.displayName}
    end
    return resolveUsername(trimmed)
end

local function formatAccountAge(createdIso)
    local ok, dt = pcall(function() return DateTime.fromIsoDate(createdIso) end)
    if not ok or not dt then return "غير معروف" end
    local days = math.floor((DateTime.now().UnixTimestamp - dt.UnixTimestamp) / 86400)
    local years = math.floor(days / 365)
    if years >= 1 then
        return string.format("%d سنة تقريباً (%d يوم)", years, days)
    end
    return string.format("%d يوم", days)
end

local function getBadgeInfo(userId)
    local ok, res = httpRequest({Url = "https://badges.roblox.com/v1/users/"..userId.."/badges?limit=100&sortOrder=Asc", Method = "GET"})
    if not ok then return "غير متاح" end
    local decodeOk, data = safeDecode(res)
    if not decodeOk or not data.data then return "غير متاح" end
    local count = tostring(#data.data)
    if data.nextPageCursor then count = count .. "+" end
    return count
end

local function getFriends(userId)
    local ok, res = httpRequest({Url = "https://friends.roblox.com/v1/users/"..userId.."/friends", Method = "GET"})
    if not ok then return {}, res end
    local decodeOk, data = safeDecode(res)
    if not decodeOk or not data.data then return {}, "تعذر قراءة قائمة الأصدقاء" end
    return data.data, nil
end

local function getCount(userId, kind)
    local ok, res = httpRequest({Url = "https://friends.roblox.com/v1/users/"..userId.."/"..kind.."/count", Method = "GET"})
    if not ok then return "غير متاح" end
    local decodeOk, data = safeDecode(res)
    if not decodeOk or not data.count then return "غير متاح" end
    return tostring(data.count)
end

local function getPresence(userId)
    local body = HttpService:JSONEncode({userIds = {userId}})
    local ok, res = httpRequest({
        Url = "https://presence.roblox.com/v1/presence/users", Method = "POST",
        Headers = {["Content-Type"] = "application/json"}, Body = body,
    })
    if not ok then return nil end
    local decodeOk, data = safeDecode(res)
    if not decodeOk or not data.userPresences or not data.userPresences[1] then return nil end
    return data.userPresences[1]
end

local function formatPresence(presence)
    if not presence then return "غير معروف" end
    local presenceType = presence.userPresenceType
    if presenceType == 0 then
        return "غير متصل"
    elseif presenceType == 1 then
        return "متصل (خارج لعبة)"
    elseif presenceType == 2 then
        return "داخل لعبة: "..(presence.lastLocation or "غير معروف")
    elseif presenceType == 3 then
        return "داخل استوديو روبلوكس"
    end
    return "غير معروف"
end

local function getUsersBatch(ids)
    local map = {}
    local chunkSize = 90
    for start = 1, #ids, chunkSize do
        local chunk = {}
        for i = start, math.min(start + chunkSize - 1, #ids) do table.insert(chunk, ids[i]) end
        local body = HttpService:JSONEncode({userIds = chunk, excludeBannedUsers = false})
        local ok, res = httpRequest({
            Url = "https://users.roblox.com/v1/users", Method = "POST",
            Headers = {["Content-Type"] = "application/json"}, Body = body,
        })
        if ok then
            local decodeOk, data = safeDecode(res)
            if decodeOk and data.data then
                for _, u in ipairs(data.data) do
                    map[u.id] = {name = u.name, displayName = u.displayName}
                end
            end
        end
        if start + chunkSize <= #ids then task.wait(0.2) end
    end
    return map
end

-- حالة الأونلاين لكل الأصدقاء دفعة وحدة (تستخدم لترتيب القائمة: الأونلاين أول)
local function getPresenceBatch(ids)
    local map = {}
    if #ids == 0 then return map end
    local chunkSize = 50
    for start = 1, #ids, chunkSize do
        local chunk = {}
        for i = start, math.min(start + chunkSize - 1, #ids) do table.insert(chunk, ids[i]) end
        local body = HttpService:JSONEncode({userIds = chunk})
        local ok, res = httpRequest({
            Url = "https://presence.roblox.com/v1/presence/users", Method = "POST",
            Headers = {["Content-Type"] = "application/json"}, Body = body,
        })
        if ok then
            local decodeOk, data = safeDecode(res)
            if decodeOk and data.userPresences then
                for _, p in ipairs(data.userPresences) do
                    map[p.userId] = p
                end
            end
        end
        if start + chunkSize <= #ids then task.wait(0.2) end
    end
    return map
end

-- تاريخ الأسماء السابقة (Username History) - يفيد لمعرفة لو اللاعب غيّر يوزره قبل
local function getUsernameHistory(userId)
    local ok, res = httpRequest({
        Url = "https://users.roblox.com/v1/users/"..userId.."/username-history?limit=10&sortOrder=Desc",
        Method = "GET",
    })
    if not ok then return {} end
    local decodeOk, data = safeDecode(res)
    if not decodeOk or not data.data then return {} end
    local names = {}
    for _, entry in ipairs(data.data) do
        if entry.name then table.insert(names, entry.name) end
    end
    return names
end

-- الملابس/العناصر المرتداة حالياً (بديل قانوني عن "لبس السكن" اللي روبلوكس منعها من الكلاينت)
local function getCurrentlyWearing(userId)
    local ok, res = httpRequest({
        Url = "https://avatar.roblox.com/v1/users/"..userId.."/currently-wearing",
        Method = "GET",
    })
    if not ok then return {} end
    local decodeOk, data = safeDecode(res)
    if not decodeOk or not data.assetIds then return {} end
    return data.assetIds
end

----------------------------------------------------------------
-- 8) تصريحات مسبقة لعناصر الواجهة
----------------------------------------------------------------
local StatusLabel, NameLabel, UsernameLabel, IdLabel
local FollowersLabel, FollowingLabel, FriendsCountLabel
local AccountAgeLabel, VerifiedLabel, BadgesLabel, PresenceLabel
local PastUsernamesLabel, WearingCountLabel
local AvatarImage, FullBodyImage
local RecentDropdown, FavoritesDropdown
local FriendsScroll, FriendsLayout, FriendsPanel, FriendsTitle
local BatchStatusLabel, BatchResultsScroll, BatchResultsLayout, BatchResultsPanel, BatchResultsTitle

local usernameValue, batchInputValue = "", ""
local isSearching, isBatchSearching = false, false
local currentUser = nil
local recentSearches = {}
local MAX_RECENT = 8

-- حالة فلترة/ترتيب قائمة الأصدقاء + بيانات آخر تحميل لها
local lastFriendsRaw, lastFriendsUsersMap, lastFriendsPresenceMap = {}, {}, {}
local friendsFilterText = ""
local friendsSortOnlineFirst = false

-- تتبع تغييرات أصدقاء اللاعب المبحوث عنه (إضافة/حذف) بالخلفية
local friendsWatchEnabled = false
local FRIENDS_WATCH_INTERVAL = 25

-- (جديد) خاص بتبويب تطبيق السكن
local SkinApplyStatusLabel, SkinHistoryDropdown
local skinApplyInputValue = ""
local skinHistory = {}
local applySkinToSelf -- تُعرَّف فعليًا بالقسم 10.5، متاحة هنا مسبقاً عشان صفوف اللاعبين تقدر تستدعيها

----------------------------------------------------------------
-- 9) دوال مساعدة للـ GUI
----------------------------------------------------------------
local function updateScrollCanvas(scroll, layout)
    task.spawn(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)
end

local function createScrollPanel(parentGui, titleText, size, position)
    local panel = Instance.new("Frame")
    panel.Size = size
    panel.Position = position
    panel.BackgroundColor3 = UI_BASE_BLACK
    panel.BorderSizePixel = 0
    panel.Parent = parentGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = panel

    local title = Instance.new("TextLabel")
    title.Name = "PanelTitle"
    title.Size = UDim2.new(1, 0, 0, 28)
    title.BackgroundTransparency = 1
    title.Text = titleText
    title.TextColor3 = UI_WHITE
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.AutoLocalize = false
    title.ZIndex = 2
    title.Parent = panel

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -34)
    scroll.Position = UDim2.new(0, 5, 0, 30)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = UI_WHITE
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ZIndex = 2
    scroll.Parent = panel

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.Parent = scroll

    return scroll, layout, panel, title
end

local function createPlayerRow(parent, layout, id, displayName, usernameText, copyValue, isFriendRow)
    -- صفوف الأصدقاء أصغر من صفوف البحث الجماعي
    local rowHeight = isFriendRow and 34 or 46
    local avatarSize = isFriendRow and 26 or 36
    local nameSize = isFriendRow and 11 or 13
    local userSize = isFriendRow and 9 or 12
    local btnW = isFriendRow and 26 or 34
    local btnH = isFriendRow and 22 or 28
    -- فيه زرّين الآن (نسخ + تطبيق) بدل زر وحد، فحجزنا مساحة أكبر للاسم واليوزر
    local reservedWidth = -(avatarSize + 8 + (btnW * 2 + 4) + 14)

    local entry = Instance.new("Frame")
    entry.Size = UDim2.new(1, 0, 0, rowHeight)
    entry.BackgroundColor3 = UI_CARD_BLACK
    entry.BorderSizePixel = 0
    entry.ZIndex = 2
    entry.Parent = parent

    local entryCorner = Instance.new("UICorner")
    entryCorner.CornerRadius = UDim.new(0, 8)
    entryCorner.Parent = entry

    local entryStroke = Instance.new("UIStroke")
    entryStroke.Color = UI_WHITE
    entryStroke.Thickness = 1
    entryStroke.Transparency = isFriendRow and 0.15 or 0.7
    entryStroke.Parent = entry

    applyGlossyDark(entry, UI_CARD_BLACK)

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(0, avatarSize, 0, avatarSize)
    img.Position = UDim2.new(0, 4, 0.5, -avatarSize / 2)
    img.BackgroundTransparency = 1
    img.ZIndex = 3
    img.Image = "rbxthumb://type=AvatarHeadShot&id="..id.."&w=150&h=150"
    img.Parent = entry

    local imgCorner = Instance.new("UICorner")
    imgCorner.CornerRadius = UDim.new(0, avatarSize / 2)
    imgCorner.Parent = img

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, reservedWidth, 0, isFriendRow and 14 or 20)
    nameLabel.Position = UDim2.new(0, avatarSize + 8, 0, isFriendRow and 1 or 2)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = displayName
    nameLabel.TextColor3 = UI_WHITE
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = nameSize
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.AutoLocalize = false
    nameLabel.ZIndex = 3
    nameLabel.Parent = entry

    local usernameLabel = Instance.new("TextLabel")
    usernameLabel.Size = UDim2.new(1, reservedWidth, 0, isFriendRow and 14 or 18)
    usernameLabel.Position = UDim2.new(0, avatarSize + 8, 0, isFriendRow and 16 or 22)
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.Text = usernameText
    usernameLabel.TextColor3 = UI_LIGHTGRAY
    usernameLabel.Font = Enum.Font.Gotham
    usernameLabel.TextSize = userSize
    usernameLabel.TextXAlignment = Enum.TextXAlignment.Left
    usernameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    usernameLabel.AutoLocalize = false
    usernameLabel.ZIndex = 3
    usernameLabel.Parent = entry

    applyGlossyContrastStyle(nameLabel)
    applyGlossyContrastStyle(usernameLabel, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(110, 110, 110)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(210, 210, 210)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 110, 110)),
    }))

    if isFriendRow then
        applySilverSpinBorder(entry, 1.5)
    end

    -- (جديد) زر تطبيق السكن - يسار زر النسخ
    local applyButton = Instance.new("TextButton")
    applyButton.Size = UDim2.new(0, btnW, 0, btnH)
    applyButton.Position = UDim2.new(1, -(btnW * 2 + 10), 0.5, -btnH / 2)
    applyButton.BackgroundColor3 = UI_WHITE
    applyButton.Text = isFriendRow and "سكن" or "تطبيق"
    applyButton.TextColor3 = Color3.fromRGB(10, 10, 10)
    applyButton.Font = Enum.Font.GothamBold
    applyButton.TextSize = isFriendRow and 9 or 10
    applyButton.AutoButtonColor = true
    applyButton.AutoLocalize = false
    applyButton.ZIndex = 3
    applyButton.Parent = entry

    local applyButtonCorner = Instance.new("UICorner")
    applyButtonCorner.CornerRadius = UDim.new(0, 8)
    applyButtonCorner.Parent = applyButton

    applySilverSpinBorder(applyButton, 1.2)

    applyButton.MouseButton1Click:Connect(function()
        -- copyValue هو نفس يوزر اللاعب المستخدم بزر النسخ
        if applySkinToSelf then
            applySkinToSelf(copyValue)
        end
        applyButton.Text = "تم"
        task.delay(1, function()
            applyButton.Text = isFriendRow and "سكن" or "تطبيق"
        end)
    end)

    local copyButton = Instance.new("TextButton")
    copyButton.Size = UDim2.new(0, btnW, 0, btnH)
    copyButton.Position = UDim2.new(1, -(btnW + 6), 0.5, -btnH / 2)
    copyButton.BackgroundColor3 = UI_WHITE
    copyButton.Text = "نسخ"
    copyButton.TextColor3 = Color3.fromRGB(10, 10, 10)
    copyButton.Font = Enum.Font.GothamBold
    copyButton.TextSize = isFriendRow and 9 or 10
    copyButton.AutoButtonColor = true
    copyButton.AutoLocalize = false
    copyButton.ZIndex = 3
    copyButton.Parent = entry

    local copyButtonCorner = Instance.new("UICorner")
    copyButtonCorner.CornerRadius = UDim.new(0, 8)
    copyButtonCorner.Parent = copyButton

    applySilverSpinBorder(copyButton, 1.2)

    copyButton.MouseButton1Click:Connect(function()
        local ok = copyToClipboard(copyValue)
        copyButton.Text = ok and "تم" or "خطأ"
        task.delay(1, function() copyButton.Text = "نسخ" end)
    end)

    updateScrollCanvas(parent, layout)
    return entry
end

local function addEmptyNotice(parent, layout, text)
    local notice = Instance.new("TextLabel")
    notice.Size = UDim2.new(1, 0, 0, 30)
    notice.BackgroundTransparency = 1
    notice.Text = text
    notice.TextColor3 = UI_LIGHTGRAY
    notice.Font = Enum.Font.Gotham
    notice.TextSize = 13
    notice.AutoLocalize = false
    notice.ZIndex = 2
    notice.Parent = parent
    updateScrollCanvas(parent, layout)
end

local function clearScroll(scroll)
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then child:Destroy() end
    end
end

local function renderFriendsList()
    clearScroll(FriendsScroll)

    local filterLower = friendsFilterText:lower()
    local filtered = {}
    for _, friend in ipairs(lastFriendsRaw) do
        local info = lastFriendsUsersMap[friend.id]
        local displayName = (info and info.displayName) or ""
        local username = (info and info.name) or ""
        if filterLower == "" or displayName:lower():find(filterLower, 1, true)
            or username:lower():find(filterLower, 1, true) then
            table.insert(filtered, friend)
        end
    end

    if friendsSortOnlineFirst then
        table.sort(filtered, function(a, b)
            local pa = lastFriendsPresenceMap[a.id]
            local pb = lastFriendsPresenceMap[b.id]
            local sa = pa and pa.userPresenceType or 0
            local sb = pb and pb.userPresenceType or 0
            return sa > sb
        end)
    end

    if #filtered == 0 then
        local emptyText = (#lastFriendsRaw == 0) and "لا يوجد أصدقاء أو القائمة خاصة" or "ما فيه نتائج تطابق الفلتر"
        addEmptyNotice(FriendsScroll, FriendsLayout, emptyText)
    else
        for _, friend in ipairs(filtered) do
            local info = lastFriendsUsersMap[friend.id]
            local displayName = (info and info.displayName) or "غير معروف"
            local username = (info and info.name) or "غير معروف"
            createPlayerRow(FriendsScroll, FriendsLayout, friend.id, displayName, "@"..username, username, true)
        end
    end
end

local function populateFriendsUI(friends, usersMap)
    lastFriendsRaw = friends
    lastFriendsUsersMap = usersMap

    local ids = {}
    for _, friend in ipairs(friends) do table.insert(ids, friend.id) end
    lastFriendsPresenceMap = getPresenceBatch(ids)

    renderFriendsList()
end

----------------------------------------------------------------
-- 10) المفضلة وآخر عمليات البحث
----------------------------------------------------------------
local function refreshRecentDropdown()
    local options = #recentSearches > 0 and recentSearches or {"لا يوجد بعد"}
    pcall(function() RecentDropdown:Refresh(options) end)
end

local function pushRecentSearch(username)
    for i = #recentSearches, 1, -1 do
        if recentSearches[i]:lower() == username:lower() then table.remove(recentSearches, i) end
    end
    table.insert(recentSearches, 1, username)
    while #recentSearches > MAX_RECENT do table.remove(recentSearches, #recentSearches) end
    refreshRecentDropdown()
end

local function refreshFavoritesDropdown()
    local options = #favorites > 0 and favorites or {"لا يوجد بعد"}
    pcall(function() FavoritesDropdown:Refresh(options) end)
end

----------------------------------------------------------------
-- 10.5) سجل تطبيق السكنات (Skin History) + تطبيق السكن فعليًا
----------------------------------------------------------------
local SKIN_HISTORY_FILE = "player_lookup_skin_history.json"

local function loadSkinHistory()
    if not (isfile and readfile) then return end
    local existsOk, exists = pcall(isfile, SKIN_HISTORY_FILE)
    if existsOk and exists then
        local readOk, raw = pcall(readfile, SKIN_HISTORY_FILE)
        if readOk then
            local decodeOk, data = safeDecode(raw)
            if decodeOk and type(data) == "table" then skinHistory = data end
        end
    end
end

local function saveSkinHistory()
    if not writefile then return end
    pcall(writefile, SKIN_HISTORY_FILE, HttpService:JSONEncode(skinHistory))
end

local function refreshSkinHistoryDropdown()
    local options = {}
    for _, entry in ipairs(skinHistory) do
        table.insert(options, entry.name.." (x"..tostring(entry.count)..")")
    end
    if #options == 0 then options = {"لا يوجد بعد"} end
    pcall(function() SkinHistoryDropdown:Refresh(options) end)
end

-- يسجل تطبيق سكن جديد: لو اليوزر موجود يزيد العداد فقط، ولو جديد يضيفه
-- السجل يبقى محفوظ دايمًا (ما يُمسح تلقائيًا) ومرتب من الأكثر استخدامًا للأقل
local function recordSkinApplication(username)
    local lowerName = username:lower()
    local found
    for _, entry in ipairs(skinHistory) do
        if entry.name:lower() == lowerName then
            found = entry
            break
        end
    end
    if found then
        found.count += 1
    else
        table.insert(skinHistory, {name = username, count = 1})
    end
    table.sort(skinHistory, function(a, b) return a.count > b.count end)
    saveSkinHistory()
    refreshSkinHistoryDropdown()
end

-- تطبيق سكن لاعب على نفسي فورًا وبدون أي تأخير أو انتظار
applySkinToSelf = function(username)
    username = username and username:match("^%s*(.-)%s*$") or ""
    if username == "" then
        if SkinApplyStatusLabel then SkinApplyStatusLabel:Set("اكتب يوزر أولاً") end
        return
    end

    if not ApplyMainAvatarEvent then
        ApplyMainAvatarEvent = ReplicatedStorage:FindFirstChild("ApplyMainAvatar")
    end
    if not ApplyMainAvatarEvent then
        if SkinApplyStatusLabel then
            SkinApplyStatusLabel:Set("لم يتم العثور على حدث ApplyMainAvatar - تحقق من اللعبة")
        end
        return
    end

    local ok, err = pcall(function()
        ApplyMainAvatarEvent:FireServer(username)
    end)

    if ok then
        if SkinApplyStatusLabel then
            SkinApplyStatusLabel:Set("تم تطبيق سكن: "..username)
        end
        sendToast("تطبيق السكن", "تم إرسال طلب تطبيق سكن "..username)
        recordSkinApplication(username)
    else
        if SkinApplyStatusLabel then
            SkinApplyStatusLabel:Set("فشل تطبيق السكن: "..tostring(err))
        end
    end
end

----------------------------------------------------------------
-- 11) تطبيق نتيجة بحث على الواجهة + دالة البحث الرئيسية
----------------------------------------------------------------
local function applySearchResult(data)
    local user = data.user
    currentUser = {
        id = user.id, name = user.name, displayName = user.displayName,
        accountAge = data.accountAge, verified = data.verified, badgeCount = data.badgeCount,
        followers = data.followers, following = data.following,
        friendsCount = #data.friends, presenceText = formatPresence(data.presence),
        wearingAssetIds = data.wearingAssetIds,
    }

    AvatarImage.Image = "rbxthumb://type=AvatarHeadShot&id="..user.id.."&w=420&h=420"
    FullBodyImage.Image = "rbxthumb://type=Avatar&id="..user.id.."&w=420&h=420"
    NameLabel:Set("الاسم الظاهر: "..user.displayName)
    UsernameLabel:Set("اسم المستخدم: @"..user.name)
    IdLabel:Set("المعرف: "..tostring(user.id))
    FollowersLabel:Set("المتابعون: "..data.followers)
    FollowingLabel:Set("يتابع: "..data.following)
    FriendsCountLabel:Set("عدد الأصدقاء: "..tostring(#data.friends))
    AccountAgeLabel:Set("عمر الحساب: "..(data.accountAge or "غير متاح"))
    VerifiedLabel:Set("موثق: "..(data.verified and "نعم ✔️" or "لا"))
    BadgesLabel:Set("عدد الشارات: "..(data.badgeCount or "غير متاح"))
    PresenceLabel:Set("الحالة الآن: "..currentUser.presenceText)

    local pastNames = data.pastUsernames or {}
    PastUsernamesLabel:Set(#pastNames > 0 and ("أسماء سابقة: "..table.concat(pastNames, ", ")) or "أسماء سابقة: لا يوجد")
    WearingCountLabel:Set("عدد الملابس الحالية: "..tostring(#(data.wearingAssetIds or {})))

    populateFriendsUI(data.friends, data.usersMap)
end

local function performSearch()
    if isSearching then return end
    if usernameValue == "" then
        StatusLabel:Set("اكتب يوزر أو ID أولاً")
        return
    end

    isSearching = true
    StatusLabel:Set("جاري البحث...")

    local cached = getCached(usernameValue)
    if cached then
        applySearchResult(cached)
        StatusLabel:Set("تم الجلب من الذاكرة المؤقتة")
        isSearching = false
        return
    end

    local user, err = resolveUserInput(usernameValue)
    if not user then
        StatusLabel:Set(err or "حدث خطأ")
        isSearching = false
        return
    end

    local details = getUserDetails(user.id)
    local accountAge = (details and details.created) and formatAccountAge(details.created) or "غير متاح"
    local verified = details and details.hasVerifiedBadge or false

    local followers = getCount(user.id, "followers")
    local following = getCount(user.id, "followings")
    local badgeCount = getBadgeInfo(user.id)
    local presence = getPresence(user.id)
    local friends, friendsErr = getFriends(user.id)
    local pastUsernames = getUsernameHistory(user.id)
    local wearingAssetIds = getCurrentlyWearing(user.id)

    local ids = {}
    for _, friend in ipairs(friends) do table.insert(ids, friend.id) end
    local usersMap = getUsersBatch(ids)

    local result = {
        user = user, followers = followers, following = following,
        friends = friends, usersMap = usersMap, accountAge = accountAge,
        verified = verified, badgeCount = badgeCount, presence = presence,
        pastUsernames = pastUsernames, wearingAssetIds = wearingAssetIds,
    }

    setCached(usernameValue, result)
    applySearchResult(result)
    pushRecentSearch(user.name)
    sendToast("بحث اللاعبين", "تم العثور على "..user.displayName)

    StatusLabel:Set(friendsErr and ("تم البحث، بس صار خطأ بقائمة الأصدقاء: "..friendsErr) or "تم البحث بنجاح")
    isSearching = false
end

----------------------------------------------------------------
-- 12) بحث جماعي
----------------------------------------------------------------
local function runBatchSearch()
    if isBatchSearching then return end
    if batchInputValue == "" then
        BatchStatusLabel:Set("اكتب يوزرات أولاً (افصل بفاصلة)")
        return
    end

    isBatchSearching = true
    clearScroll(BatchResultsScroll)

    local usernames = {}
    for name in batchInputValue:gmatch("[^,]+") do
        local trimmed = name:match("^%s*(.-)%s*$")
        if trimmed ~= "" then table.insert(usernames, trimmed) end
    end

    if #usernames == 0 then
        BatchStatusLabel:Set("ما فيه يوزرات صحيحة")
        isBatchSearching = false
        return
    end

    BatchStatusLabel:Set("جاري البحث عن "..#usernames.." يوزر...")
    local successCount = 0

    for i, uname in ipairs(usernames) do
        local user, err = resolveUserInput(uname)
        if user then
            successCount += 1
            createPlayerRow(BatchResultsScroll, BatchResultsLayout, user.id, user.displayName,
                "@"..user.name.." | "..tostring(user.id), user.name, false)
        else
            local errorLabel = Instance.new("TextLabel")
            errorLabel.Size = UDim2.new(1, 0, 0, 26)
            errorLabel.BackgroundTransparency = 1
            errorLabel.Text = uname..": "..(err or "خطأ")
            errorLabel.TextColor3 = Color3.fromRGB(230, 80, 80)
            errorLabel.Font = Enum.Font.Gotham
            errorLabel.TextSize = 12
            errorLabel.TextXAlignment = Enum.TextXAlignment.Left
            errorLabel.AutoLocalize = false
            errorLabel.ZIndex = 2
            errorLabel.Parent = BatchResultsScroll
            updateScrollCanvas(BatchResultsScroll, BatchResultsLayout)
        end
        if i < #usernames then task.wait(0.3) end
    end

    BatchStatusLabel:Set("انتهى البحث: "..successCount.."/"..#usernames.." نجح")
    isBatchSearching = false
end

----------------------------------------------------------------
-- 13) بناء الواجهة
----------------------------------------------------------------
local Window = Rayfield:CreateWindow({
    Name = "بحث عن لاعب روبلوكس",
    LoadingTitle = "بحث لاعب",
    LoadingSubtitle = "جاري التحميل",
    Theme = "Light",
    ConfigurationSaving = {Enabled = false},
})

local Tab = Window:CreateTab("بحث", nil)

Tab:CreateInput({
    Name = "اسم المستخدم أو المعرف (ID)",
    PlaceholderText = "اكتب يوزر أو ID واضغط Enter أو زر بحث",
    RemoveTextAfterFocusLost = true,
    Callback = function(text)
        usernameValue = text
        performSearch()
    end,
})

StatusLabel = Tab:CreateLabel("اكتب يوزر أو ID واضغط بحث")
NameLabel = Tab:CreateLabel("")
UsernameLabel = Tab:CreateLabel("")
IdLabel = Tab:CreateLabel("")
PresenceLabel = Tab:CreateLabel("")
AccountAgeLabel = Tab:CreateLabel("")
VerifiedLabel = Tab:CreateLabel("")
BadgesLabel = Tab:CreateLabel("")
FollowersLabel = Tab:CreateLabel("")
FollowingLabel = Tab:CreateLabel("")
FriendsCountLabel = Tab:CreateLabel("")
PastUsernamesLabel = Tab:CreateLabel("")
WearingCountLabel = Tab:CreateLabel("")

Tab:CreateButton({
    Name = "بحث",
    Callback = performSearch,
})

Tab:CreateButton({
    Name = "نسخ تقرير كامل",
    Callback = function()
        if not currentUser then
            StatusLabel:Set("ابحث عن لاعب أولاً")
            return
        end
        local report = table.concat({
            "الاسم الظاهر: "..currentUser.displayName,
            "اسم المستخدم: @"..currentUser.name,
            "المعرف: "..tostring(currentUser.id),
            "الحالة الآن: "..(currentUser.presenceText or "غير معروف"),
            "عمر الحساب: "..(currentUser.accountAge or "غير متاح"),
            "موثق: "..(currentUser.verified and "نعم" or "لا"),
            "الشارات: "..(currentUser.badgeCount or "غير متاح"),
            "المتابعون: "..(currentUser.followers or "غير متاح"),
            "يتابع: "..(currentUser.following or "غير متاح"),
            "عدد الأصدقاء: "..(currentUser.friendsCount or "غير متاح"),
            "رابط الملف الشخصي: https://www.roblox.com/users/"..currentUser.id.."/profile",
        }, "\n")
        StatusLabel:Set(copyToClipboard(report) and "تم نسخ التقرير الكامل" or "النسخ غير مدعوم بهذا المنفذ")
    end,
})

Tab:CreateButton({
    Name = "نسخ اسم المستخدم",
    Callback = function()
        if not currentUser then StatusLabel:Set("ابحث عن لاعب أولاً") return end
        StatusLabel:Set(copyToClipboard(currentUser.name) and "تم نسخ اسم المستخدم" or "النسخ غير مدعوم")
    end,
})

Tab:CreateButton({
    Name = "نسخ المعرف",
    Callback = function()
        if not currentUser then StatusLabel:Set("ابحث عن لاعب أولاً") return end
        StatusLabel:Set(copyToClipboard(tostring(currentUser.id)) and "تم نسخ المعرف" or "النسخ غير مدعوم")
    end,
})

Tab:CreateButton({
    Name = "نسخ رابط الملف الشخصي",
    Callback = function()
        if not currentUser then StatusLabel:Set("ابحث عن لاعب أولاً") return end
        local link = "https://www.roblox.com/users/"..currentUser.id.."/profile?username="..HttpService:UrlEncode(currentUser.name)
        StatusLabel:Set(copyToClipboard(link) and "تم نسخ الرابط" or "النسخ غير مدعوم")
    end,
})

Tab:CreateButton({
    Name = "إضافة/إزالة من المفضلة",
    Callback = function()
        if not currentUser then StatusLabel:Set("ابحث عن لاعب أولاً") return end
        local foundIndex
        for i, fav in ipairs(favorites) do
            if fav:lower() == currentUser.name:lower() then foundIndex = i break end
        end
        if foundIndex then
            table.remove(favorites, foundIndex)
            StatusLabel:Set("تمت الإزالة من المفضلة")
        else
            table.insert(favorites, currentUser.name)
            StatusLabel:Set("تمت الإضافة للمفضلة")
        end
        saveFavorites()
        refreshFavoritesDropdown()
    end,
})

Tab:CreateButton({
    Name = "نسخ روابط الملابس الحالية",
    Callback = function()
        if not currentUser then StatusLabel:Set("ابحث عن لاعب أولاً") return end
        StatusLabel:Set("جاري جلب الملابس الحالية...")
        task.spawn(function()
            local assetIds = getCurrentlyWearing(currentUser.id)
            if #assetIds == 0 then
                StatusLabel:Set("ما لقيت ملابس أو الحساب خاص")
                return
            end
            local links = {}
            for _, assetId in ipairs(assetIds) do
                table.insert(links, "https://www.roblox.com/catalog/"..tostring(assetId))
            end
            local text = table.concat(links, "\n")
            StatusLabel:Set(copyToClipboard(text) and ("تم نسخ "..#assetIds.." رابط ملبس") or "النسخ غير مدعوم")
        end)
    end,
})

-- (جديد) زر تطبيق سكن اللاعب المعروض حاليًا على نفسك مباشرة
Tab:CreateButton({
    Name = "تطبيق سكن هذا اللاعب على نفسي",
    Callback = function()
        if not currentUser then
            StatusLabel:Set("ابحث عن لاعب أولاً")
            return
        end
        applySkinToSelf(currentUser.name)
    end,
})

RecentDropdown = Tab:CreateDropdown({
    Name = "عمليات البحث الأخيرة",
    Options = {"لا يوجد بعد"},
    CurrentOption = {"لا يوجد بعد"},
    Callback = function(selected)
        local pick = type(selected) == "table" and selected[1] or selected
        if pick and pick ~= "لا يوجد بعد" then usernameValue = pick performSearch() end
    end,
})

FavoritesDropdown = Tab:CreateDropdown({
    Name = "المفضلة",
    Options = {"لا يوجد بعد"},
    CurrentOption = {"لا يوجد بعد"},
    Callback = function(selected)
        local pick = type(selected) == "table" and selected[1] or selected
        if pick and pick ~= "لا يوجد بعد" then usernameValue = pick performSearch() end
    end,
})

local ToggleButton
local parentGui = (gethui and gethui()) or game:GetService("CoreGui")
local AvatarGui = Instance.new("ScreenGui")
AvatarGui.Name = "AvatarPreviewGui"
AvatarGui.ResetOnSpawn = false
AvatarGui.Parent = parentGui

local AvatarFrame = Instance.new("Frame")
AvatarFrame.Size = UDim2.new(0, 110, 0, 110)
AvatarFrame.Position = UDim2.new(0, 20, 0, 20)
AvatarFrame.BackgroundColor3 = UI_BASE_BLACK
AvatarFrame.BorderSizePixel = 0
AvatarFrame.Parent = AvatarGui
Instance.new("UICorner", AvatarFrame).CornerRadius = UDim.new(0, 12)
applyGlossyDark(AvatarFrame, UI_BASE_BLACK)
applySilverSpinBorder(AvatarFrame, 2)

AvatarImage = Instance.new("ImageLabel")
AvatarImage.Name = "TargetAvatar"
AvatarImage.Size = UDim2.new(1, -10, 1, -10)
AvatarImage.Position = UDim2.new(0, 5, 0, 5)
AvatarImage.BackgroundTransparency = 1
AvatarImage.ZIndex = 2
AvatarImage.Parent = AvatarFrame
Instance.new("UICorner", AvatarImage).CornerRadius = UDim.new(0, 10)

local FullBodyFrame = Instance.new("Frame")
FullBodyFrame.Size = UDim2.new(0, 110, 0, 190)
FullBodyFrame.Position = UDim2.new(0, 20, 0, 140)
FullBodyFrame.BackgroundColor3 = UI_BASE_BLACK
FullBodyFrame.BorderSizePixel = 0
FullBodyFrame.Parent = AvatarGui
Instance.new("UICorner", FullBodyFrame).CornerRadius = UDim.new(0, 12)
applyGlossyDark(FullBodyFrame, UI_BASE_BLACK)
applySilverSpinBorder(FullBodyFrame, 2)

FullBodyImage = Instance.new("ImageLabel")
FullBodyImage.Name = "TargetAvatar"
FullBodyImage.Size = UDim2.new(1, -10, 1, -10)
FullBodyImage.Position = UDim2.new(0, 5, 0, 5)
FullBodyImage.BackgroundTransparency = 1
FullBodyImage.ZIndex = 2
FullBodyImage.Parent = FullBodyFrame
Instance.new("UICorner", FullBodyImage).CornerRadius = UDim.new(0, 10)

FriendsScroll, FriendsLayout, FriendsPanel, FriendsTitle = createScrollPanel(AvatarGui, "قائمة الأصدقاء", UDim2.new(0, 320, 0, 320), UDim2.new(0, 150, 0, 20))
applyGlossyDark(FriendsPanel, UI_BASE_BLACK)
applySilverSpinBorder(FriendsPanel, 2)
applyGlossyContrastStyle(FriendsTitle)

----------------------------------------------------------------
-- شريط فلترة + ترتيب قائمة الأصدقاء (فوق القائمة مباشرة)
----------------------------------------------------------------
local FriendsFilterBar = Instance.new("Frame")
FriendsFilterBar.Size = UDim2.new(1, -10, 0, 26)
FriendsFilterBar.Position = UDim2.new(0, 5, 0, 30)
FriendsFilterBar.BackgroundTransparency = 1
FriendsFilterBar.ZIndex = 2
FriendsFilterBar.Parent = FriendsPanel

local FriendsFilterBg = Instance.new("Frame")
FriendsFilterBg.Size = UDim2.new(1, -60, 1, 0)
FriendsFilterBg.BackgroundColor3 = UI_CARD_BLACK
FriendsFilterBg.BorderSizePixel = 0
FriendsFilterBg.ZIndex = 2
FriendsFilterBg.Parent = FriendsFilterBar
Instance.new("UICorner", FriendsFilterBg).CornerRadius = UDim.new(0, 6)
applySilverSpinBorder(FriendsFilterBg, 1.2)

local FriendsFilterBox = Instance.new("TextBox")
FriendsFilterBox.Size = UDim2.new(1, -10, 1, 0)
FriendsFilterBox.Position = UDim2.new(0, 5, 0, 0)
FriendsFilterBox.BackgroundTransparency = 1
FriendsFilterBox.PlaceholderText = "فلترة بالاسم..."
FriendsFilterBox.Text = ""
FriendsFilterBox.PlaceholderColor3 = UI_LIGHTGRAY
FriendsFilterBox.Font = Enum.Font.Gotham
FriendsFilterBox.TextSize = 12
FriendsFilterBox.TextXAlignment = Enum.TextXAlignment.Left
FriendsFilterBox.ClearTextOnFocus = false
FriendsFilterBox.AutoLocalize = false
FriendsFilterBox.ZIndex = 3
FriendsFilterBox.Parent = FriendsFilterBg
applyGlossyContrastStyle(FriendsFilterBox)

local FriendsSortButton = Instance.new("TextButton")
FriendsSortButton.Size = UDim2.new(0, 54, 1, 0)
FriendsSortButton.Position = UDim2.new(1, -54, 0, 0)
FriendsSortButton.BackgroundColor3 = UI_WHITE
FriendsSortButton.Text = "ترتيب"
FriendsSortButton.TextColor3 = Color3.fromRGB(10, 10, 10)
FriendsSortButton.Font = Enum.Font.GothamBold
FriendsSortButton.TextSize = 11
FriendsSortButton.AutoButtonColor = true
FriendsSortButton.AutoLocalize = false
FriendsSortButton.ZIndex = 3
FriendsSortButton.Parent = FriendsFilterBar
Instance.new("UICorner", FriendsSortButton).CornerRadius = UDim.new(0, 6)
applySilverSpinBorder(FriendsSortButton, 1.2)

FriendsScroll.Position = UDim2.new(0, 5, 0, 60)
FriendsScroll.Size = UDim2.new(1, -10, 1, -64)
FriendsLayout.Padding = UDim.new(0, 4)

FriendsFilterBox:GetPropertyChangedSignal("Text"):Connect(function()
    friendsFilterText = FriendsFilterBox.Text
    renderFriendsList()
end)

FriendsSortButton.MouseButton1Click:Connect(function()
    friendsSortOnlineFirst = not friendsSortOnlineFirst
    FriendsSortButton.Text = friendsSortOnlineFirst and "أونلاين" or "ترتيب"
    renderFriendsList()
end)

ToggleButton = Tab:CreateButton({
    Name = "إخفاء الواجهة",
    Callback = function()
        AvatarGui.Enabled = not AvatarGui.Enabled
        if ToggleButton.Set then
            ToggleButton:Set(AvatarGui.Enabled and "إخفاء الواجهة" or "إظهار الواجهة")
        end
    end,
})

Tab:CreateToggle({
    Name = "تتبع تغييرات أصدقاء اللاعب (إضافة/حذف)",
    CurrentValue = false,
    Callback = function(value)
        friendsWatchEnabled = value
        StatusLabel:Set(value and "التتبع شغّال - بيبلغك لو ضاف أو حذف صديق" or "التتبع متوقف")
    end,
})

task.spawn(function()
    while true do
        task.wait(FRIENDS_WATCH_INTERVAL)
        if friendsWatchEnabled and currentUser then
            local watchedId = currentUser.id
            local freshFriends, watchErr = getFriends(watchedId)
            if not watchErr and currentUser and currentUser.id == watchedId then
                local oldIds, freshIds = {}, {}
                for _, f in ipairs(lastFriendsRaw) do oldIds[f.id] = true end
                for _, f in ipairs(freshFriends) do freshIds[f.id] = true end

                local newOnes, removedOnes = {}, {}
                for _, f in ipairs(freshFriends) do
                    if not oldIds[f.id] then table.insert(newOnes, f) end
                end
                for _, f in ipairs(lastFriendsRaw) do
                    if not freshIds[f.id] then table.insert(removedOnes, f) end
                end

                if #newOnes > 0 or #removedOnes > 0 then
                    local allIds = {}
                    for _, f in ipairs(freshFriends) do table.insert(allIds, f.id) end
                    local usersMap = getUsersBatch(allIds)

                    for _, f in ipairs(newOnes) do
                        local info = usersMap[f.id]
                        sendToast("صديق جديد", (info and info.displayName or "لاعب").." ضاف صداقة "..currentUser.displayName)
                    end
                    for _, f in ipairs(removedOnes) do
                        local info = lastFriendsUsersMap[f.id]
                        sendToast("إزالة صداقة", (info and info.displayName or "لاعب").." ما عاد صديق لـ"..currentUser.displayName)
                    end

                    populateFriendsUI(freshFriends, usersMap)
                end
            end
        end
    end
end)

local BatchTab = Window:CreateTab("بحث جماعي", nil)
BatchTab:CreateInput({
    Name = "يوزرات أو IDs (افصل بينهم بفاصلة ,)",
    PlaceholderText = "user1, 123456, user2",
    RemoveTextAfterFocusLost = false,
    Callback = function(text) batchInputValue = text end,
})
BatchStatusLabel = BatchTab:CreateLabel("اكتب يوزرات وافصل بينهم بفاصلة")
BatchTab:CreateButton({ Name = "بحث جماعي", Callback = runBatchSearch })
BatchResultsScroll, BatchResultsLayout, BatchResultsPanel, BatchResultsTitle = createScrollPanel(AvatarGui, "نتائج البحث الجماعي", UDim2.new(0, 320, 0, 320), UDim2.new(0, 480, 0, 20))
applyGlossyDark(BatchResultsPanel, UI_BASE_BLACK)
applySilverSpinBorder(BatchResultsPanel, 2)
applyGlossyContrastStyle(BatchResultsTitle)

local BatchToggleButton
BatchToggleButton = BatchTab:CreateButton({
    Name = "إخفاء واجهة الجماعي",
    Callback = function()
        BatchResultsPanel.Visible = not BatchResultsPanel.Visible
        if BatchToggleButton.Set then
            BatchToggleButton:Set(BatchResultsPanel.Visible and "إخفاء واجهة الجماعي" or "إظهار واجهة الجماعي")
        end
    end,
})

----------------------------------------------------------------
-- (جديد) تبويب ثالث: تطبيق سكن لاعب على نفسك مباشرة
----------------------------------------------------------------
local SkinTab = Window:CreateTab("تطبيق السكن", nil)

SkinTab:CreateInput({
    Name = "يوزر اللاعب المراد تطبيق سكنه",
    PlaceholderText = "اكتب يوزر واضغط Enter",
    RemoveTextAfterFocusLost = true,
    Callback = function(text)
        skinApplyInputValue = text
        applySkinToSelf(text)
    end,
})

SkinApplyStatusLabel = SkinTab:CreateLabel("اكتب يوزر لاعب، بيتطبق سكنه عليك فورًا بدون أي تأخير")

SkinTab:CreateButton({
    Name = "تطبيق السكن الآن",
    Callback = function()
        applySkinToSelf(skinApplyInputValue)
    end,
})

SkinHistoryDropdown = SkinTab:CreateDropdown({
    Name = "سجل السكنات المطبقة (الأكثر استخدامًا أولاً)",
    Options = {"لا يوجد بعد"},
    CurrentOption = {"لا يوجد بعد"},
    Callback = function(selected)
        local pick = type(selected) == "table" and selected[1] or selected
        if pick and pick ~= "لا يوجد بعد" then
            local rawName = pick:gsub("%s*%(x%d+%)$", "")
            applySkinToSelf(rawName)
        end
    end,
})

local SettingsTab = Window:CreateTab("الإعدادات", nil)
SettingsTab:CreateSlider({
    Name = "مهلة الطلب (ثواني)",
    Range = {3, 30}, Increment = 1, CurrentValue = REQUEST_TIMEOUT,
    Callback = function(value) REQUEST_TIMEOUT = value end,
})
SettingsTab:CreateSlider({
    Name = "مدة الكاش (ثواني)",
    Range = {10, 300}, Increment = 10, CurrentValue = CACHE_TTL,
    Callback = function(value) CACHE_TTL = value end,
})

----------------------------------------------------------------
-- 14) تحميل البيانات المحفوظة عند بدء التشغيل
----------------------------------------------------------------
loadFavorites()
refreshFavoritesDropdown()
loadSkinHistory()
refreshSkinHistoryDropdown()
end)
