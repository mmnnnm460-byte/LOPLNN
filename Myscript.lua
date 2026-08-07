local HttpService      = game:GetService("HttpService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local SoundService     = game:GetService("SoundService")
local TextService      = game:GetService("TextService")

local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://6895079853"
clickSound.Volume = 0.5
clickSound.Parent = SoundService

local function playClick()
    task.spawn(function()
        if clickSound.IsPlaying then
            clickSound:Stop()
        end
        clickSound:Play()
    end)
end

local httpRequest = (syn and syn.request)
    or (http and http.request)
    or (fluxus and fluxus.request)
    or http_request
    or request

if not httpRequest then
    warn("[PlayerLookup] الاكزكيوتور لا يدعم HTTP requests")
    return
end

-- ================= حفظ الإعدادات (حجم/مكان النافذة - اللغة - الشفافية - الثيم) =================
local SETTINGS_FILE = "PlayerLookup_settings.json"

local function loadPersisted()
    local ok, res = pcall(function()
        if isfile and isfile(SETTINGS_FILE) then
            return HttpService:JSONDecode(readfile(SETTINGS_FILE))
        end
    end)
    if ok and type(res) == "table" then return res end
    return {}
end

local persisted = loadPersisted()

local function savePersisted()
    if not writefile then return end
    pcall(function()
        writefile(SETTINGS_FILE, HttpService:JSONEncode(persisted))
    end)
end

-- ================= الثيمات المتاحة =================
local THEMES = {
    purple  = { accent = Color3.fromRGB(150, 85, 255),  accentB = Color3.fromRGB(185, 120, 255), accentC = Color3.fromRGB(215, 150, 255), compare = Color3.fromRGB(196, 120, 255) },
    azure   = { accent = Color3.fromRGB(55, 145, 255),  accentB = Color3.fromRGB(100, 180, 255), accentC = Color3.fromRGB(150, 210, 255), compare = Color3.fromRGB(90, 200, 255) },
    crimson = { accent = Color3.fromRGB(255, 70, 95),   accentB = Color3.fromRGB(255, 110, 130), accentC = Color3.fromRGB(255, 150, 165), compare = Color3.fromRGB(255, 120, 90) },
    emerald = { accent = Color3.fromRGB(40, 200, 140),  accentB = Color3.fromRGB(90, 225, 170),  accentC = Color3.fromRGB(140, 240, 200), compare = Color3.fromRGB(80, 220, 120) },
    gold    = { accent = Color3.fromRGB(230, 175, 60),  accentB = Color3.fromRGB(245, 200, 100), accentC = Color3.fromRGB(250, 220, 150), compare = Color3.fromRGB(240, 150, 60) },
}
local currentThemeName = (THEMES[persisted.theme] and persisted.theme) or "purple"

-- ================= اللغة =================
local LANG = persisted.lang or "ar"

local STR = {
    ar = {
        subtitle = "ابحث عن أي لاعب بروبلوكس",
        searchPlaceholder = "اكتب يوزر أو ID...",
        recent = "🕘 الأخيرة",
        favorites = "⭐ المفضلة",
        compare = "⚖ قارن",
        tabFriends = "الأصدقاء",
        tabFollowers = "المتابعين",
        tabFollowing = "يتابع",
        loadMore = "تحميل المزيد  ⌤",
        loading = "جاري التحميل...",
        loadingMore = "جاري تحميل المزيد...",
        searching = "جاري البحث...",
        notFound = "ما لقيت هذا اللاعب",
        noResults = "ما فيه نتائج",
        noMore = "خلاص ما فيه أكثر",
        loadFail = "تعذر التحميل (كود: %s)",
        locked = "🔒 هذا القسم محمي من روبلوكس (العداد فوق دقيق وشغال)",
        emptyList = "لا يوجد شيء هنا بعد",
        historyTitle = "🕘 آخر عمليات البحث",
        favTitle = "⭐ المفضلة",
        exportEmpty = "القائمة فاضية",
        comparePrompt = "ابحث عن لاعب أول قبل المقارنة",
        compareSearching = "جاري المقارنة...",
        compareNotFound = "ما لقيت هذا اللاعب",
        comparePlaceholder = "اسم اللاعب الثاني...",
        comparePanelTitle = "⚖ مقارنة لاعبين",
        settingsTitle = "⚙ الإعدادات",
        langLabel = "اللغة",
        transLabel = "شفافية النافذة",
        themeLabel = "لون الثيم",
        friendsCount = "أصدقاء",
        followersCount = "متابعين",
        followingCount = "يتابع",
        accountAge = "عمر الحساب",
        noClipboard = "الاكزكيوتور لا يدعم النسخ",
        yearsShort = "س",
    },
    en = {
        subtitle = "Search for any Roblox player",
        searchPlaceholder = "Enter username or ID...",
        recent = "🕘 Recent",
        favorites = "⭐ Favorites",
        compare = "⚖ Compare",
        tabFriends = "Friends",
        tabFollowers = "Followers",
        tabFollowing = "Following",
        loadMore = "Load more  ⌤",
        loading = "Loading...",
        loadingMore = "Loading more...",
        searching = "Searching...",
        notFound = "Player not found",
        noResults = "No results",
        noMore = "No more results",
        loadFail = "Failed to load (code: %s)",
        locked = "🔒 Protected by Roblox (counter above is live and accurate)",
        emptyList = "Nothing here yet",
        historyTitle = "🕘 Recent Searches",
        favTitle = "⭐ Favorites",
        exportEmpty = "List is empty",
        comparePrompt = "Search a player first to compare",
        compareSearching = "Comparing...",
        compareNotFound = "Player not found",
        comparePlaceholder = "Second player's name...",
        comparePanelTitle = "⚖ Compare Players",
        settingsTitle = "⚙ Settings",
        langLabel = "Language",
        transLabel = "Window transparency",
        themeLabel = "Theme color",
        friendsCount = "Friends",
        followersCount = "Followers",
        followingCount = "Following",
        accountAge = "Account age",
        noClipboard = "Executor does not support clipboard",
        yearsShort = "y",
    },
}

local function T(key)
    return (STR[LANG] and STR[LANG][key]) or STR.ar[key] or key
end

-- ================= الألوان =================
local COLORS = {
    bg       = Color3.fromRGB(13, 10, 20),
    panel    = Color3.fromRGB(22, 17, 33),
    panel2   = Color3.fromRGB(30, 23, 46),
    panel3   = Color3.fromRGB(42, 32, 64),
    accent   = Color3.fromRGB(150, 85, 255),
    accentB  = Color3.fromRGB(185, 120, 255),
    accentC  = Color3.fromRGB(215, 150, 255),
    text     = Color3.fromRGB(248, 245, 255),
    subtext  = Color3.fromRGB(170, 155, 195),
    subtext2 = Color3.fromRGB(110, 95, 135),
    good     = Color3.fromRGB(108, 229, 166),
    warn     = Color3.fromRGB(255, 169, 110),
    danger   = Color3.fromRGB(255, 107, 120),
    compare  = Color3.fromRGB(196, 120, 255),
}

-- تطبيق الثيم المحفوظ فوق الألوان الافتراضية قبل بناء أي عنصر
do
    local t = THEMES[currentThemeName]
    COLORS.accent, COLORS.accentB, COLORS.accentC, COLORS.compare = t.accent, t.accentB, t.accentC, t.compare
end

local TAB_COLORS = {
    friends   = COLORS.accent,
    followers = COLORS.accentB,
    following = COLORS.accentC,
}

local MIN_SIZE = Vector2.new(280, 380)
local MAX_SIZE = Vector2.new(480, 680)

local themeRegistry = {}

local API = {}

local function get(url)
    local ok, res = pcall(httpRequest, {
        Url = url, Method = "GET",
        Headers = {
            ["Referer"] = "https://www.roblox.com/",
            ["Origin"]  = "https://www.roblox.com",
        },
    })
    if not ok or not res then return nil, "request_failed" end
    local status = res.StatusCode or res.status_code or (res.Success and 200)
    if status ~= 200 then return nil, status end
    local ok2, data = pcall(HttpService.JSONDecode, HttpService, res.Body or res.body)
    if not ok2 then return nil, "bad_json" end
    return data, nil
end

local function post(url, bodyTable)
    local ok, res = pcall(httpRequest, {
        Url = url, Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json",
            ["Referer"] = "https://www.roblox.com/",
        },
        Body = HttpService:JSONEncode(bodyTable),
    })
    if ok and res then
        local status = res.StatusCode or res.status_code or (res.Success and 200)
        if status == 200 then
            local ok2, data = pcall(HttpService.JSONDecode, HttpService, res.Body or res.body)
            if ok2 then return data, true end
        end
    end
    return nil, false
end

function API.resolveUser(input)
    if tonumber(input) then
        local d = get("https://users.roblox.com/v1/users/" .. input)
        if d and d.id then
            return { id = d.id, name = d.name, displayName = d.displayName, hasVerifiedBadge = d.hasVerifiedBadge }
        end
        return nil
    end
    local d = post("https://users.roblox.com/v1/usernames/users", {
        usernames = { input }, excludeBannedUsers = false,
    })
    if d and d.data and #d.data > 0 then
        local u = d.data[1]
        return { id = u.id, name = u.name, displayName = u.displayName, hasVerifiedBadge = u.hasVerifiedBadge }
    end
    return nil
end

function API.resolveNames(ids)
    local map = {}
    local allOk = true
    for i = 1, #ids, 100 do
        local chunk = {}
        for j = i, math.min(i + 99, #ids) do table.insert(chunk, ids[j]) end
        local d, ok = post("https://users.roblox.com/v1/users", { userIds = chunk, excludeBannedUsers = false })
        if ok and d and d.data then
            for _, u in ipairs(d.data) do
                map[u.id] = { name = u.name, displayName = u.displayName, hasVerifiedBadge = u.hasVerifiedBadge }
            end
        else
            allOk = false
        end
    end
    return map, allOk
end

local function enrichNames(list)
    local needsFix = {}
    for _, u in ipairs(list) do
        if (not u.name or u.name == "") or (not u.displayName or u.displayName == "") then
            table.insert(needsFix, u.id)
        end
    end
    if #needsFix > 0 then
        local resolved, allOk = API.resolveNames(needsFix)
        for _, u in ipairs(list) do
            local r = resolved[u.id]
            if r then
                if not u.name or u.name == "" then u.name = r.name end
                if not u.displayName or u.displayName == "" then u.displayName = r.displayName end
                if u.hasVerifiedBadge == nil then u.hasVerifiedBadge = r.hasVerifiedBadge end
            elseif not allOk and (not u.name or u.name == "") and (not u.displayName or u.displayName == "") then
                u._resolveFailed = true
            end
        end
    end
    return list
end

local function isUnresolvedUser(u)
    return (not u.name or u.name == "") and (not u.displayName or u.displayName == "")
end

function API.getCounts(id)
    local f  = get("https://friends.roblox.com/v1/users/" .. id .. "/friends/count")
    local fl = get("https://friends.roblox.com/v1/users/" .. id .. "/followers/count")
    local fg = get("https://friends.roblox.com/v1/users/" .. id .. "/followings/count")
    return {
        friends   = f  and f.count  or 0,
        followers = fl and fl.count or 0,
        following = fg and fg.count or 0,
    }
end

function API.getUserDetails(id)
    local d = get("https://users.roblox.com/v1/users/" .. id)
    return d
end

function API.getPresence(ids)
    local d = post("https://presence.roblox.com/v1/presence/users", { userIds = ids })
    local map = {}
    if d and d.userPresences then
        for _, p in ipairs(d.userPresences) do
            map[p.userId] = {
                status = p.userPresenceType,
                location = p.lastLocation,
            }
        end
    end
    return map
end

function API.getFriends(id)
    local d, err = get("https://friends.roblox.com/v1/users/" .. id .. "/friends")
    local list = (d and d.data) or {}
    return enrichNames(list), nil, err
end

function API.getFollowers(id, cursor)
    local url = "https://friends.roblox.com/v1/users/" .. id .. "/followers?limit=50&sortOrder=Desc"
    if cursor then url = url .. "&cursor=" .. cursor end
    local d, err = get(url)
    local list = (d and d.data) or {}
    return enrichNames(list), d and d.nextPageCursor, err
end

function API.getFollowings(id, cursor)
    local url = "https://friends.roblox.com/v1/users/" .. id .. "/followings?limit=50&sortOrder=Desc"
    if cursor then url = url .. "&cursor=" .. cursor end
    local d, err = get(url)
    local list = (d and d.data) or {}
    return enrichNames(list), d and d.nextPageCursor, err
end

local function parseISODate(str)
    if not str then return nil end
    local y, m, d = str:match("(%d+)-(%d+)-(%d+)")
    if not y then return nil end
    return tonumber(y), tonumber(m), tonumber(d)
end

local function formatCreatedInfo(createdStr)
    local y, m, d = parseISODate(createdStr)
    if not y then return "" end
    local ok, createdTime = pcall(os.time, { year = y, month = m, day = d, hour = 12 })
    local dateStr = string.format("%04d-%02d-%02d", y, m, d)
    if not ok or not createdTime then return dateStr end
    local days = math.floor((os.time() - createdTime) / 86400)
    local ageText
    if LANG == "en" then
        if days >= 365 then
            local years = math.floor(days / 365.25)
            ageText = years .. (years == 1 and " year" or " years")
        elseif days >= 30 then
            local months = math.floor(days / 30)
            ageText = months .. (months == 1 and " month" or " months")
        else
            local dd = math.max(days, 0)
            ageText = dd .. (dd == 1 and " day" or " days")
        end
    else
        if days >= 365 then
            local years = math.floor(days / 365.25)
            ageText = years .. (years == 1 and " سنة" or " سنوات")
        elseif days >= 30 then
            local months = math.floor(days / 30)
            ageText = months .. (months == 1 and " شهر" or " أشهر")
        else
            ageText = math.max(days, 0) .. " يوم"
        end
    end
    return dateStr .. " • " .. ageText
end

local function new(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do inst[k] = v end
    if parent then inst.Parent = parent end
    return inst
end

local function corner(radius, parent)
    local c = radius
    if typeof(radius) == "number" then c = UDim.new(0, radius) end
    return new("UICorner", { CornerRadius = c }, parent)
end

local function gradient(rotation, colorSeq, parent)
    return new("UIGradient", { Rotation = rotation, Color = colorSeq }, parent)
end

local function tween(inst, props, time, style, dir)
    local t = TweenService:Create(inst, TweenInfo.new(time or 0.25, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function pulseLoop(inst, prop, a, b, time)
    inst[prop] = a
    local t = TweenService:Create(inst, TweenInfo.new(time, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { [prop] = b })
    t:Play()
    return t
end

-- يرجع لون فعلي سواء انمرر اسم "role" (نص) أو Color3 مباشر
local function resolveColor(v)
    if type(v) == "string" then return COLORS[v], v end
    return v, nil
end

local function addHover(btn, hoverColorOrRole, baseColorOrRole)
    btn.MouseEnter:Connect(function()
        local c = resolveColor(hoverColorOrRole)
        tween(btn, { BackgroundColor3 = c }, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        local c = resolveColor(baseColorOrRole)
        tween(btn, { BackgroundColor3 = c }, 0.15)
    end)
end

local function addPress(btn)
    local base = btn.Size
    local small = UDim2.new(base.X.Scale, base.X.Offset - 4, base.Y.Scale, base.Y.Offset - 4)
    btn.MouseButton1Down:Connect(function()
        playClick()
        tween(btn, { Size = small }, 0.08, Enum.EasingStyle.Quad)
    end)
    btn.MouseButton1Up:Connect(function() tween(btn, { Size = base }, 0.18, Enum.EasingStyle.Back) end)
    btn.MouseLeave:Connect(function() tween(btn, { Size = base }, 0.18, Enum.EasingStyle.Back) end)
end

-- تسجيل عنصر يتلون تلقائيًا عند تبديل الثيم
local function themedProp(inst, prop, role)
    inst[prop] = COLORS[role]
    table.insert(themeRegistry, { inst = inst, prop = prop, role = role })
end

local function themedGradient(grad, roles)
    local seq = {}
    for i, r in ipairs(roles) do seq[i] = COLORS[r] end
    grad.Color = (#seq == 1) and ColorSequence.new(seq[1]) or ColorSequence.new(seq[1], seq[#seq])
    table.insert(themeRegistry, { inst = grad, kind = "grad", roles = roles })
end

local rotatingGradients = {}

local metallicSequence = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(35, 15, 55)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(200, 140, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 20, 90)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(200, 140, 255)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(35, 15, 55)),
})

local function applyMetallicStyle(target, thickness)
    local stroke = new("UIStroke", {
        Thickness = thickness or 2,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Color3.fromRGB(255, 255, 255),
    }, target)
    local strokeGrad = new("UIGradient", { Color = metallicSequence }, stroke)
    table.insert(rotatingGradients, strokeGrad)
    return stroke
end

-- roleOrColor: مرر نص مثل "accent" عشان يتلون تلقائيًا مع الثيم، أو Color3 مباشر للألوان الثابتة (danger/good/warn)
local function applyColorGlow(target, roleOrColor, thickness, baseTrans, pulseTrans, speed)
    local color, role = resolveColor(roleOrColor)
    local stroke = new("UIStroke", {
        Thickness = thickness or 1.4,
        Color = color,
        Transparency = baseTrans or 0.35,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, target)
    TweenService:Create(stroke, TweenInfo.new(speed or 1.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Transparency = pulseTrans or 0.85,
    }):Play()
    if role then
        table.insert(themeRegistry, { inst = stroke, prop = "Color", role = role })
    end
    return stroke
end

local function applyTextShine(label, delaySeconds, sweepSeconds)
    local overlay = new("TextLabel", {
        Name = "ShineOverlay",
        Text = label.Text,
        Font = label.Font,
        TextSize = label.TextSize,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        TextXAlignment = label.TextXAlignment,
        TextTruncate = label.TextTruncate,
        ZIndex = (label.ZIndex or 1) + 1,
    }, label)

    local shineGrad = new("UIGradient", {
        Color = ColorSequence.new(Color3.fromRGB(255, 220, 255)),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.42, 1),
            NumberSequenceKeypoint.new(0.5, 0.05),
            NumberSequenceKeypoint.new(0.58, 1),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Offset = Vector2.new(-1, 0),
    }, overlay)

    label:GetPropertyChangedSignal("Text"):Connect(function()
        overlay.Text = label.Text
    end)

    task.spawn(function()
        task.wait(math.random() * (delaySeconds or 1.5))
        while overlay.Parent do
            shineGrad.Offset = Vector2.new(-1, 0)
            local sweep = TweenService:Create(shineGrad, TweenInfo.new(sweepSeconds or 1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Offset = Vector2.new(1, 0),
            })
            sweep:Play()
            sweep.Completed:Wait()
            if not overlay.Parent then break end
            task.wait(delaySeconds or 1.5)
        end
    end)

    return overlay
end

local function measureTextWidth(text, font, size)
    local ok, bounds = pcall(TextService.GetTextSize, TextService, text or "", size, font, Vector2.new(1000, 100))
    if ok then return bounds.X end
    return 0
end

local function addVerifiedBadge(parent, x, y)
    return new("TextLabel", {
        Name = "VerifiedBadge",
        Text = "✔",
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = Color3.fromRGB(120, 190, 255),
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(x, y),
        Size = UDim2.fromOffset(14, 14),
    }, parent)
end

RunService.RenderStepped:Connect(function(dt)
    for _, g in ipairs(rotatingGradients) do
        if g and g.Parent then g.Rotation = (g.Rotation + 45 * dt) % 360 end
    end
end)

local currentUser, currentTab, currentCursor = nil, "friends", nil
local disabledTabs = {}
local tabCache = {}
local requestToken = 0
local compareToken = 0
local performSearch
local closeUI, openUI
local flashStatus
local loadTab
local doCopy
local skeletons = {}
local TOGGLE_SIZE = UDim2.fromOffset(48, 48)
local lastCreatedStr = nil
local windowSize

local applyTheme, applyLanguage, persistWindow, applyTransparency
local openAvatarPreview, closeAvatarPreview
local refreshLangButtons

local recentSearches = {}
local favorites = {}
local favoritesSet = {}
local toggleFavorite, refreshStarIcon, openOverlay
local currentOverlayKind = "history"
local comparePanel
local settingsPanel

-- مراقبة حالة (Watch)
local watchedSet = {}
local watchedLastStatus = {}

local function isFavorite(id)
    return favoritesSet[id] == true
end

local function pushRecent(user)
    if not user or not user.id then return end
    for i = #recentSearches, 1, -1 do
        if recentSearches[i].id == user.id then table.remove(recentSearches, i) end
    end
    table.insert(recentSearches, 1, { id = user.id, name = user.name, displayName = user.displayName, hasVerifiedBadge = user.hasVerifiedBadge })
    while #recentSearches > 8 do table.remove(recentSearches) end
end

local gui = new("ScreenGui", {
    Name = "PlayerLookupUI", ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999,
    IgnoreGuiInset = true,
}, game:GetService("CoreGui"))

local backdrop = new("Frame", {
    Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0),
    BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 0,
    Visible = false,
}, gui)

local main = new("CanvasGroup", {
    Size = UDim2.fromOffset(320, 486), AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = COLORS.bg,
    BorderSizePixel = 0, GroupTransparency = 1, ZIndex = 2,
    Visible = false,
}, gui)

-- استرجاع آخر حجم/مكان محفوظ
if persisted.window then
    local w = math.clamp(persisted.window.w or 320, MIN_SIZE.X, MAX_SIZE.X)
    local h = math.clamp(persisted.window.h or 486, MIN_SIZE.Y, MAX_SIZE.Y)
    main.Size = UDim2.fromOffset(w, h)
    main.Position = UDim2.new(persisted.window.xs or 0.5, persisted.window.xo or 0, persisted.window.ys or 0.5, persisted.window.yo or 0)
end
windowSize = main.Size

corner(16, main)
applyMetallicStyle(main, 2)
applyColorGlow(main, "accent", 2, 0.3, 0.7, 2)

persistWindow = function()
    persisted.window = {
        w = main.Size.X.Offset, h = main.Size.Y.Offset,
        xs = main.Position.X.Scale, xo = main.Position.X.Offset,
        ys = main.Position.Y.Scale, yo = main.Position.Y.Offset,
    }
    savePersisted()
end

local toggleBtn = new("TextButton", {
    Name = "ToggleIcon",
    Size = TOGGLE_SIZE,
    AnchorPoint = Vector2.new(1, 1),
    Position = UDim2.new(1, -20, 1, -20),
    BackgroundColor3 = COLORS.panel,
    Text = "", AutoButtonColor = false,
    Visible = true, ZIndex = 3,
}, gui)
corner(14, toggleBtn)
gradient(135, ColorSequence.new(COLORS.panel3, COLORS.panel), toggleBtn)
applyMetallicStyle(toggleBtn, 2)

local toggleIconImg = new("ImageLabel", {
    Image = "rbxthumb://type=AvatarHeadShot&id=13943153201&w=150&h=150",
    BackgroundTransparency = 1,
    ScaleType = Enum.ScaleType.Crop,
    Size = UDim2.fromScale(1, 1),
    ZIndex = 4,
}, toggleBtn)
corner(UDim.new(1, 0), toggleIconImg)

local watchBadge = new("Frame", {
    Name = "WatchBadge",
    Size = UDim2.fromOffset(12, 12), AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, 2, 0, -2), BackgroundColor3 = COLORS.danger,
    BorderSizePixel = 0, Visible = false, ZIndex = 5,
}, toggleBtn)
corner(UDim.new(1, 0), watchBadge)
new("UIStroke", { Color = COLORS.bg, Thickness = 2 }, watchBadge)
pulseLoop(watchBadge, "BackgroundTransparency", 0, 0.4, 0.6)

task.spawn(function()
    while true do
        task.wait(25)
        local ids = {}
        for id in pairs(watchedSet) do table.insert(ids, id) end
        if #ids > 0 then
            local presenceMap = API.getPresence(ids)
            for _, id in ipairs(ids) do
                local info = presenceMap[id]
                local status = info and info.status or 0
                local wasOnline = (watchedLastStatus[id] or 0) > 0
                local isOnline = status > 0
                if isOnline and not wasOnline then
                    watchBadge.Visible = true
                    playClick()
                end
                watchedLastStatus[id] = status
            end
        end
    end
end)

toggleBtn.MouseLeave:Connect(function()
    if toggleBtn.Visible then tween(toggleBtn, { Size = TOGGLE_SIZE }, 0.18, Enum.EasingStyle.Back) end
end)
toggleBtn.MouseButton1Down:Connect(function()
    playClick()
    tween(toggleBtn, { Size = UDim2.fromOffset(42, 42) }, 0.08, Enum.EasingStyle.Quad)
end)
toggleBtn.MouseButton1Up:Connect(function() if toggleBtn.Visible then tween(toggleBtn, { Size = TOGGLE_SIZE }, 0.18, Enum.EasingStyle.Back) end end)

do
    local dragging, dragStart, startPos, dragMoved = false, nil, nil, false
    toggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragMoved = false
            dragStart = input.Position
            startPos = toggleBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 4 then dragMoved = true end
            toggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    toggleBtn.MouseButton1Click:Connect(function()
        if not dragMoved then openUI() end
    end)
end

-- الهيدر: ZIndex مرفوع فوق مناطق تكبير الحجم (10) عشان زر الإغلاق ما يحتاج أكثر من ضغطة
local header = new("Frame", { Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1, ZIndex = 15 }, main)

local titleDot = new("Frame", {
    Size = UDim2.fromOffset(6, 6), Position = UDim2.fromOffset(16, 22),
    BackgroundColor3 = COLORS.accentC, BorderSizePixel = 0,
}, header)
corner(UDim.new(1, 0), titleDot)
themedProp(titleDot, "BackgroundColor3", "accentC")
pulseLoop(titleDot, "BackgroundTransparency", 0, 0.55, 1.2)

local titleLabel = new("TextLabel", {
    Text = "Player Lookup",
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextColor3 = Color3.fromRGB(220, 150, 255),
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(28, 9),
    Size = UDim2.new(1, -80, 0, 20),
    TextXAlignment = Enum.TextXAlignment.Left,
}, header)

gradient(0, ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 130, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 230, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 130, 255))
}), titleLabel)

applyTextShine(titleLabel, 1.2, 0.8)

task.spawn(function()
    local fullText = "Player Lookup"
    while true do
        task.wait(2.5)
        for i = #fullText, 0, -1 do
            if not titleLabel.Parent then return end
            titleLabel.Text = fullText:sub(1, i)
            task.wait(0.08)
        end
        task.wait(0.6)
        for i = 0, #fullText do
            if not titleLabel.Parent then return end
            titleLabel.Text = fullText:sub(1, i)
            task.wait(0.08)
        end
    end
end)

local subtitleLbl = new("TextLabel", {
    Text = T("subtitle"), Font = Enum.Font.Gotham, TextSize = 10,
    TextColor3 = COLORS.subtext, BackgroundTransparency = 1,
    Position = UDim2.fromOffset(28, 29), Size = UDim2.new(1, -80, 0, 14),
    TextXAlignment = Enum.TextXAlignment.Left,
}, header)

local settingsBtn = new("TextButton", {
    Text = "⚙", Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = COLORS.subtext,
    BackgroundColor3 = COLORS.panel2, Size = UDim2.fromOffset(26, 26),
    Position = UDim2.new(1, -70, 0, 12), AutoButtonColor = false,
}, header)
corner(UDim.new(1, 0), settingsBtn)
addPress(settingsBtn)
applyColorGlow(settingsBtn, "accent", 1.2, 0.5, 0.9, 1.6)
addHover(settingsBtn, "accent", COLORS.panel2)

local closeBtn = new("TextButton", {
    Text = "✖", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = COLORS.subtext,
    BackgroundColor3 = COLORS.panel2, Size = UDim2.fromOffset(26, 26),
    Position = UDim2.new(1, -38, 0, 12), AutoButtonColor = false,
}, header)
corner(UDim.new(1, 0), closeBtn)
addPress(closeBtn)
applyColorGlow(closeBtn, COLORS.danger, 1.2, 0.5, 0.9, 1.6)
closeBtn.MouseEnter:Connect(function() tween(closeBtn, { BackgroundColor3 = COLORS.danger, TextColor3 = Color3.new(1,1,1) }, 0.15) end)
closeBtn.MouseLeave:Connect(function() tween(closeBtn, { BackgroundColor3 = COLORS.panel2, TextColor3 = COLORS.subtext }, 0.15) end)
closeBtn.MouseButton1Click:Connect(function() closeUI() end)

new("Frame", { Size = UDim2.new(1, -24, 0, 1), Position = UDim2.fromOffset(12, 50), BackgroundColor3 = COLORS.panel2, BorderSizePixel = 0 }, main)

do
    local dragging, dragStart, startPos = false, nil, nil
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    persistWindow()
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local searchHolder = new("Frame", {
    Size = UDim2.new(1, -24, 0, 38), Position = UDim2.fromOffset(12, 62),
    BackgroundColor3 = COLORS.panel2, BorderSizePixel = 0,
}, main)
corner(12, searchHolder)
applyMetallicStyle(searchHolder, 1.5)
applyColorGlow(searchHolder, "accent", 1.3, 0.55, 0.9, 1.7)
local searchStroke = new("UIStroke", { Thickness = 1, Transparency = 1 }, searchHolder)
themedProp(searchStroke, "Color", "accent")

new("TextLabel", {
    Text = "🔍", Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = COLORS.subtext,
    BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 0), Size = UDim2.fromOffset(20, 38),
}, searchHolder)

local searchBox = new("TextBox", {
    Size = UDim2.new(1, -88, 1, 0), Position = UDim2.fromOffset(36, 0),
    BackgroundTransparency = 1, Text = "", PlaceholderText = T("searchPlaceholder"),
    Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = COLORS.text,
    PlaceholderColor3 = COLORS.subtext2, TextXAlignment = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false,
}, searchHolder)
searchBox.Focused:Connect(function() tween(searchStroke, { Transparency = 0.35 }, 0.2) end)
searchBox.FocusLost:Connect(function() tween(searchStroke, { Transparency = 1 }, 0.2) end)

local searchBtn = new("TextButton", {
    Size = UDim2.fromOffset(30, 30), Position = UDim2.new(1, -34, 0.5, -15),
    BackgroundColor3 = COLORS.accent, Text = "🔍",
    Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Color3.new(1, 1, 1),
    AutoButtonColor = false,
}, searchHolder)
corner(UDim.new(1, 0), searchBtn)
themedProp(searchBtn, "BackgroundColor3", "accent")
addPress(searchBtn)
addHover(searchBtn, "accentB", "accent")
applyMetallicStyle(searchBtn, 1.3)
applyColorGlow(searchBtn, "accentB", 1.5, 0.25, 0.8, 1.1)

local quickRow = new("Frame", {
    Size = UDim2.new(1, -24, 0, 26), Position = UDim2.fromOffset(12, 104),
    BackgroundTransparency = 1,
}, main)

local historyBtn = new("TextButton", {
    Size = UDim2.new(1/3, -4, 1, 0), Position = UDim2.fromOffset(0, 0),
    BackgroundColor3 = COLORS.panel2, Text = T("recent"),
    Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = COLORS.subtext, AutoButtonColor = false,
}, quickRow)
corner(8, historyBtn)
addHover(historyBtn, COLORS.panel3, COLORS.panel2)
addPress(historyBtn)
applyMetallicStyle(historyBtn, 1.5)
applyColorGlow(historyBtn, "accent", 1.2, 0.4, 0.85, 1.4)

local favBtn = new("TextButton", {
    Size = UDim2.new(1/3, -4, 1, 0), Position = UDim2.new(1/3, 2, 0, 0),
    BackgroundColor3 = COLORS.panel2, Text = T("favorites"),
    Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = COLORS.subtext, AutoButtonColor = false,
}, quickRow)
corner(8, favBtn)
addHover(favBtn, COLORS.panel3, COLORS.panel2)
addPress(favBtn)
applyMetallicStyle(favBtn, 1.5)
applyColorGlow(favBtn, "accentC", 1.2, 0.4, 0.85, 1.4)

local compareBtn = new("TextButton", {
    Size = UDim2.new(1/3, -4, 1, 0), Position = UDim2.new(2/3, 4, 0, 0),
    BackgroundColor3 = COLORS.panel2, Text = T("compare"),
    Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = COLORS.subtext, AutoButtonColor = false,
}, quickRow)
corner(8, compareBtn)
addHover(compareBtn, COLORS.panel3, COLORS.panel2)
addPress(compareBtn)
applyMetallicStyle(compareBtn, 1.5)
applyColorGlow(compareBtn, "compare", 1.2, 0.4, 0.85, 1.4)

local overlayPanel = new("CanvasGroup", {
    Size = UDim2.new(1, -24, 0, 340), Position = UDim2.fromOffset(12, 134),
    BackgroundColor3 = COLORS.bg, BorderSizePixel = 0, Visible = false, ZIndex = 5,
}, main)
corner(12, overlayPanel)
applyMetallicStyle(overlayPanel, 1.5)
applyColorGlow(overlayPanel, "accent", 1.5, 0.35, 0.8, 1.8)

local overlayHeader = new("Frame", { Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, ZIndex = 6 }, overlayPanel)
local overlayTitle = new("TextLabel", {
    Text = "", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = COLORS.text,
    BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -50, 1, 0),
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6,
}, overlayHeader)

local overlayExport = new("TextButton", {
    Text = "📤", Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = COLORS.subtext,
    BackgroundColor3 = COLORS.panel2, Size = UDim2.fromOffset(24, 24), Position = UDim2.new(1, -60, 0, 4),
    AutoButtonColor = false, ZIndex = 6,
}, overlayHeader)
corner(UDim.new(1, 0), overlayExport)
addPress(overlayExport)
addHover(overlayExport, "accent", COLORS.panel2)

local overlayClose = new("TextButton", {
    Text = "✖", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = COLORS.subtext,
    BackgroundColor3 = COLORS.panel2, Size = UDim2.fromOffset(24, 24), Position = UDim2.new(1, -32, 0, 4),
    AutoButtonColor = false, ZIndex = 6,
}, overlayHeader)
corner(UDim.new(1, 0), overlayClose)
addPress(overlayClose)
overlayClose.MouseEnter:Connect(function() tween(overlayClose, { BackgroundColor3 = COLORS.danger, TextColor3 = Color3.new(1,1,1) }, 0.15) end)
overlayClose.MouseLeave:Connect(function() tween(overlayClose, { BackgroundColor3 = COLORS.panel2, TextColor3 = COLORS.subtext }, 0.15) end)
overlayClose.MouseButton1Click:Connect(function() overlayPanel.Visible = false end)

local overlayList = new("ScrollingFrame", {
    Size = UDim2.new(1, -12, 1, -40), Position = UDim2.fromOffset(6, 34),
    BackgroundTransparency = 1, BorderSizePixel = 0,
    ScrollBarThickness = 3, ScrollBarImageColor3 = COLORS.accent,
    CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ZIndex = 6,
}, overlayPanel)
new("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder }, overlayList)

local overlayEmptyLbl = new("TextLabel", {
    Text = T("emptyList"), Font = Enum.Font.Gotham, TextSize = 11,
    TextColor3 = COLORS.subtext2, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30),
    Visible = false, ZIndex = 6,
}, overlayList)

local function clearOverlayList()
    for _, child in ipairs(overlayList:GetChildren()) do
        if child.Name == "OverlayEntry" then child:Destroy() end
    end
end

local function addOverlayEntry(entry, kind)
    local row = new("CanvasGroup", {
        Name = "OverlayEntry", Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = COLORS.panel2, BorderSizePixel = 0, ZIndex = 6,
    }, overlayList)
    corner(8, row)

    local img = new("ImageLabel", {
        Size = UDim2.fromOffset(30, 30), Position = UDim2.fromOffset(6, 6),
        BackgroundColor3 = COLORS.panel3, ClipsDescendants = true, ZIndex = 7,
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. entry.id .. "&w=48&h=48",
    }, row)
    corner(8, img)
    applyColorGlow(img, COLORS.accentB, 1, 0.5, 0.9, 1.4)

    local overlayNameText = (entry.displayName ~= "" and entry.displayName) or entry.name or ("ID " .. entry.id)
    local overlayNameLbl = new("TextLabel", {
        Text = overlayNameText,
        Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = COLORS.text, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(44, 5), Size = UDim2.new(1, -106, 0, 16),
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 7,
    }, row)
    applyTextShine(overlayNameLbl, 2.2, 1.0)
    if entry.hasVerifiedBadge then
        local w = math.min(measureTextWidth(overlayNameText, Enum.Font.GothamBold, 12), 140)
        local badge = addVerifiedBadge(row, 44 + w + 4, 6)
        badge.ZIndex = 7
    end

    local overlayUserLbl = new("TextLabel", {
        Text = entry.name and entry.name ~= "" and ("@" .. entry.name) or "",
        Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = COLORS.subtext, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(44, 21), Size = UDim2.new(1, -90, 0, 14),
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 7,
    }, row)
    applyTextShine(overlayUserLbl, 2.4, 1.0)

    local actionBtn = new("TextButton", {
        Size = UDim2.fromOffset(26, 26), Position = UDim2.new(1, -32, 0.5, -13),
        BackgroundColor3 = COLORS.panel3,
        Text = kind == "favorites" and "🗑" or (isFavorite(entry.id) and "⭐" or "☆"),
        Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = COLORS.text, AutoButtonColor = false, ZIndex = 7,
    }, row)
    corner(UDim.new(1, 0), actionBtn)
    addPress(actionBtn)
    addHover(actionBtn, COLORS.accent, COLORS.panel3)
    applyMetallicStyle(actionBtn, 1.2)
    applyColorGlow(actionBtn, COLORS.accentC, 1, 0.45, 0.85, 1.3)
    actionBtn.MouseButton1Click:Connect(function()
        toggleFavorite(entry)
        if kind == "favorites" then
            openOverlay("favorites")
        else
            actionBtn.Text = isFavorite(entry.id) and "⭐" or "☆"
        end
    end)

    local zoneRightGap = 70
    if kind == "favorites" then
        local watchBtn = new("TextButton", {
            Size = UDim2.fromOffset(26, 26), Position = UDim2.new(1, -64, 0.5, -13),
            BackgroundColor3 = COLORS.panel3,
            Text = watchedSet[entry.id] and "👁" or "🔕",
            Font = Enum.Font.Gotham, TextSize = 11,
            TextColor3 = watchedSet[entry.id] and COLORS.good or COLORS.subtext,
            AutoButtonColor = false, ZIndex = 7,
        }, row)
        corner(UDim.new(1, 0), watchBtn)
        addPress(watchBtn)
        addHover(watchBtn, COLORS.accent, COLORS.panel3)
        applyMetallicStyle(watchBtn, 1.2)
        applyColorGlow(watchBtn, COLORS.good, 1, 0.45, 0.85, 1.3)
        watchBtn.MouseButton1Click:Connect(function()
            if watchedSet[entry.id] then
                watchedSet[entry.id] = nil
                watchedLastStatus[entry.id] = nil
                watchBtn.Text = "🔕"
                watchBtn.TextColor3 = COLORS.subtext
            else
                watchedSet[entry.id] = true
                watchBtn.Text = "👁"
                watchBtn.TextColor3 = COLORS.good
            end
        end)
        zoneRightGap = 104
    end

    local clickZone = new("TextButton", {
        Size = UDim2.new(1, -zoneRightGap, 1, 0), Position = UDim2.fromOffset(40, 0),
        BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 7,
    }, row)
    clickZone.MouseEnter:Connect(function() tween(row, { BackgroundColor3 = COLORS.panel3 }, 0.15) end)
    clickZone.MouseLeave:Connect(function() tween(row, { BackgroundColor3 = COLORS.panel2 }, 0.15) end)
    clickZone.MouseButton1Click:Connect(function()
        playClick()
        overlayPanel.Visible = false
        searchBox.Text = (entry.name and entry.name ~= "") and entry.name or tostring(entry.id)
        performSearch()
    end)
end

openOverlay = function(kind)
    currentOverlayKind = kind
    if comparePanel then comparePanel.Visible = false end
    if settingsPanel then settingsPanel.Visible = false end
    clearOverlayList()
    local list = kind == "favorites" and favorites or recentSearches
    overlayTitle.Text = kind == "favorites" and T("favTitle") or T("historyTitle")
    overlayEmptyLbl.Text = T("emptyList")
    overlayEmptyLbl.Visible = #list == 0
    for _, entry in ipairs(list) do
        addOverlayEntry(entry, kind)
    end
    overlayPanel.Visible = true
end

historyBtn.MouseButton1Click:Connect(function() openOverlay("history") end)
favBtn.MouseButton1Click:Connect(function() openOverlay("favorites") end)

overlayExport.MouseButton1Click:Connect(function()
    local list = currentOverlayKind == "favorites" and favorites or recentSearches
    if #list == 0 then
        flashStatus(T("exportEmpty"), COLORS.warn)
        return
    end
    local lines = {}
    for _, entry in ipairs(list) do
        local nm = (entry.displayName ~= "" and entry.displayName) or entry.name or ("ID " .. entry.id)
        table.insert(lines, nm .. " (@" .. (entry.name or "?") .. ") - ID: " .. entry.id)
    end
    doCopy(table.concat(lines, "\n"), overlayExport)
end)

comparePanel = new("CanvasGroup", {
    Size = UDim2.new(1, -24, 0, 340), Position = UDim2.fromOffset(12, 134),
    BackgroundColor3 = COLORS.bg, BorderSizePixel = 0, Visible = false, ZIndex = 5,
}, main)
corner(12, comparePanel)
applyMetallicStyle(comparePanel, 1.5)
applyColorGlow(comparePanel, "compare", 1.5, 0.35, 0.8, 1.8)

local compareHeader = new("Frame", { Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, ZIndex = 6 }, comparePanel)
local compareTitleLbl = new("TextLabel", {
    Text = T("comparePanelTitle"), Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = COLORS.text,
    BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -50, 1, 0),
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6,
}, compareHeader)
local compareClose = new("TextButton", {
    Text = "✖", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = COLORS.subtext,
    BackgroundColor3 = COLORS.panel2, Size = UDim2.fromOffset(24, 24), Position = UDim2.new(1, -32, 0, 4),
    AutoButtonColor = false, ZIndex = 6,
}, compareHeader)
corner(UDim.new(1, 0), compareClose)
addPress(compareClose)
compareClose.MouseEnter:Connect(function() tween(compareClose, { BackgroundColor3 = COLORS.danger, TextColor3 = Color3.new(1,1,1) }, 0.15) end)
compareClose.MouseLeave:Connect(function() tween(compareClose, { BackgroundColor3 = COLORS.panel2, TextColor3 = COLORS.subtext }, 0.15) end)
compareClose.MouseButton1Click:Connect(function() comparePanel.Visible = false end)

local compareSearchHolder = new("Frame", {
    Size = UDim2.new(1, -12, 0, 32), Position = UDim2.fromOffset(6, 34),
    BackgroundColor3 = COLORS.panel2, BorderSizePixel = 0, ZIndex = 6,
}, comparePanel)
corner(10, compareSearchHolder)
local compareSearchBox = new("TextBox", {
    Size = UDim2.new(1, -70, 1, 0), Position = UDim2.fromOffset(10, 0),
    BackgroundTransparency = 1, Text = "", PlaceholderText = T("comparePlaceholder"),
    Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = COLORS.text,
    PlaceholderColor3 = COLORS.subtext2, TextXAlignment = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false, ZIndex = 6,
}, compareSearchHolder)
local compareSearchBtn = new("TextButton", {
    Size = UDim2.fromOffset(26, 26), Position = UDim2.new(1, -30, 0.5, -13),
    BackgroundColor3 = COLORS.compare, Text = "🔍",
    Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Color3.new(1, 1, 1), AutoButtonColor = false, ZIndex = 6,
}, compareSearchHolder)
corner(UDim.new(1, 0), compareSearchBtn)
themedProp(compareSearchBtn, "BackgroundColor3", "compare")
addPress(compareSearchBtn)
applyMetallicStyle(compareSearchBtn, 1.2)
applyColorGlow(compareSearchBtn, "compare", 1.3, 0.4, 0.85, 1.3)

local compareResults = new("ScrollingFrame", {
    Size = UDim2.new(1, -12, 1, -74), Position = UDim2.fromOffset(6, 70),
    BackgroundTransparency = 1, BorderSizePixel = 0,
    ScrollBarThickness = 3, ScrollBarImageColor3 = COLORS.compare,
    CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ZIndex = 6,
}, comparePanel)
new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, compareResults)

local function clearCompareResults()
    for _, child in ipairs(compareResults:GetChildren()) do
        if child:IsA("GuiObject") then child:Destroy() end
    end
end

local function addCompareStatRow(label, valA, valB)
    local numA, numB = tonumber(valA), tonumber(valB)
    local row = new("Frame", { Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, ZIndex = 6 }, compareResults)
    new("TextLabel", {
        Text = tostring(valA), Font = Enum.Font.GothamBold, TextSize = 12,
        TextColor3 = (numA and numB and numA > numB) and COLORS.good or COLORS.text,
        BackgroundTransparency = 1, Size = UDim2.new(0.35, 0, 1, 0), Position = UDim2.fromScale(0, 0),
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6,
    }, row)
    new("TextLabel", {
        Text = label, Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = COLORS.subtext,
        BackgroundTransparency = 1, Size = UDim2.new(0.3, 0, 1, 0), Position = UDim2.fromScale(0.35, 0),
        TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 6,
    }, row)
    new("TextLabel", {
        Text = tostring(valB), Font = Enum.Font.GothamBold, TextSize = 12,
        TextColor3 = (numA and numB and numB > numA) and COLORS.good or COLORS.text,
        BackgroundTransparency = 1, Size = UDim2.new(0.35, 0, 1, 0), Position = UDim2.fromScale(0.65, 0),
        TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 6,
    }, row)
end

local function runCompare(targetInput)
    local query = targetInput:gsub("^%s+", ""):gsub("%s+$", "")
    if query == "" or not currentUser then return end
    compareToken += 1
    local myCompareToken = compareToken
    clearCompareResults()
    new("TextLabel", {
        Text = T("compareSearching"), Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = COLORS.subtext2,
        BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), ZIndex = 6,
    }, compareResults)

    task.spawn(function()
        local userB = API.resolveUser(query)
        if myCompareToken ~= compareToken then return end
        if not userB then
            clearCompareResults()
            new("TextLabel", {
                Text = T("compareNotFound"), Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = COLORS.danger,
                BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), ZIndex = 6,
            }, compareResults)
            return
        end

        local userA = currentUser
        local countsA = API.getCounts(userA.id)
        local countsB = API.getCounts(userB.id)
        local detailsA = API.getUserDetails(userA.id)
        local detailsB = API.getUserDetails(userB.id)

        if myCompareToken ~= compareToken then return end
        clearCompareResults()

        local headerRow = new("Frame", { Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, ZIndex = 6 }, compareResults)
        new("TextLabel", {
            Text = (userA.displayName ~= "" and userA.displayName) or userA.name,
            Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = COLORS.accentC,
            BackgroundTransparency = 1, Size = UDim2.new(0.45, 0, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 6,
        }, headerRow)
        new("TextLabel", {
            Text = "VS", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = COLORS.subtext2,
            BackgroundTransparency = 1, Size = UDim2.new(0.1, 0, 1, 0), Position = UDim2.fromScale(0.45, 0),
            TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 6,
        }, headerRow)
        new("TextLabel", {
            Text = (userB.displayName ~= "" and userB.displayName) or userB.name,
            Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = COLORS.compare,
            BackgroundTransparency = 1, Size = UDim2.new(0.45, 0, 1, 0), Position = UDim2.fromScale(0.55, 0),
            TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 6,
        }, headerRow)

        addCompareStatRow(T("friendsCount"), countsA.friends, countsB.friends)
        addCompareStatRow(T("followersCount"), countsA.followers, countsB.followers)
        addCompareStatRow(T("followingCount"), countsA.following, countsB.following)

        local yA = detailsA and detailsA.created and select(1, parseISODate(detailsA.created))
        local yB = detailsB and detailsB.created and select(1, parseISODate(detailsB.created))
        if yA and yB then
            local mA, dA = select(2, parseISODate(detailsA.created)), select(3, parseISODate(detailsA.created))
            local mB, dB = select(2, parseISODate(detailsB.created)), select(3, parseISODate(detailsB.created))
            local okA, tA = pcall(os.time, { year = yA, month = mA, day = dA, hour = 12 })
            local okB, tB = pcall(os.time, { year = yB, month = mB, day = dB, hour = 12 })
            if okA and okB then
                local ageA = math.floor((os.time() - tA) / 86400 / 365.25)
                local ageB = math.floor((os.time() - tB) / 86400 / 365.25)
                addCompareStatRow(T("accountAge"), ageA .. T("yearsShort"), ageB .. T("yearsShort"))
            end
        end
    end)
end

compareBtn.MouseButton1Click:Connect(function()
    if not currentUser then
        flashStatus(T("comparePrompt"), COLORS.warn)
        return
    end
    overlayPanel.Visible = false
    if settingsPanel then settingsPanel.Visible = false end
    clearCompareResults()
    comparePanel.Visible = true
end)

compareSearchBtn.MouseButton1Click:Connect(function() runCompare(compareSearchBox.Text) end)
compareSearchBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then runCompare(compareSearchBox.Text) end
end)

local statusLabel = new("TextLabel", {
    Text = "", Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = COLORS.subtext,
    BackgroundTransparency = 1, Size = UDim2.new(1, -24, 0, 18), Position = UDim2.fromOffset(12, 134),
    TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
}, main)

local card = new("CanvasGroup", {
    Size = UDim2.new(1, -24, 0, 112), Position = UDim2.fromOffset(12, 154),
    BackgroundColor3 = COLORS.panel, BorderSizePixel = 0, Visible = false,
}, main)
corner(12, card)
local cardStroke = new("UIStroke", { Thickness = 1, Transparency = 0.8 }, card)
themedProp(cardStroke, "Color", "accent")

local avatarRing = new("Frame", {
    Size = UDim2.fromOffset(56, 56), Position = UDim2.fromOffset(11, 11),
    BackgroundColor3 = COLORS.accent, BorderSizePixel = 0,
}, card)
corner(UDim.new(1, 0), avatarRing)
local avatarRingGrad = gradient(45, ColorSequence.new(COLORS.accent, COLORS.accentB), avatarRing)
themedGradient(avatarRingGrad, {"accent", "accentB"})

local avatar = new("ImageLabel", {
    Size = UDim2.fromOffset(50, 50), Position = UDim2.fromOffset(3, 3),
    BackgroundColor3 = COLORS.panel2, ZIndex = 1,
}, avatarRing)
corner(UDim.new(1, 0), avatar)

-- معاينة أفتار كبيرة: اضغط على الأفتار بالكرت يفتح معاينة كبيرة
local avatarClickZone = new("TextButton", {
    Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 3,
}, avatarRing)
avatarClickZone.MouseButton1Click:Connect(function() if openAvatarPreview then openAvatarPreview() end end)

local presenceDot = new("Frame", {
    Size = UDim2.fromOffset(14, 14), Position = UDim2.fromOffset(53, 53),
    BackgroundColor3 = COLORS.subtext2, BorderSizePixel = 0, ZIndex = 2,
}, card)
corner(UDim.new(1, 0), presenceDot)
new("UIStroke", { Color = COLORS.bg, Thickness = 2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, presenceDot)

local function updatePresenceDot(status)
    local color = COLORS.subtext2
    if status == 1 then color = COLORS.good
    elseif status == 2 then color = COLORS.accentB
    elseif status == 3 then color = COLORS.warn
    end
    tween(presenceDot, { BackgroundColor3 = color }, 0.2)
end

local displayNameLbl = new("TextLabel", {
    Text = "", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = COLORS.text,
    BackgroundTransparency = 1, Size = UDim2.new(1, -180, 0, 18), Position = UDim2.fromOffset(78, 10),
    TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
}, card)
applyTextShine(displayNameLbl, 1.6, 1.1)

local usernameLbl = new("TextLabel", {
    Text = "", Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = COLORS.subtext,
    BackgroundTransparency = 1, Size = UDim2.new(1, -180, 0, 14), Position = UDim2.fromOffset(78, 28),
    TextXAlignment = Enum.TextXAlignment.Left,
}, card)
applyTextShine(usernameLbl, 1.9, 1.0)

local idBadge = new("Frame", {
    AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 0, 16),
    Position = UDim2.fromOffset(78, 46), BackgroundColor3 = COLORS.panel3, BorderSizePixel = 0,
}, card)
corner(5, idBadge)
new("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) }, idBadge)
local idLbl = new("TextLabel", {
    Text = "", Font = Enum.Font.Code, TextSize = 10, TextColor3 = COLORS.subtext,
    BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0),
    TextXAlignment = Enum.TextXAlignment.Left,
}, idBadge)

local createdLbl = new("TextLabel", {
    Text = "", Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = COLORS.subtext2,
    BackgroundTransparency = 1, Position = UDim2.fromOffset(78, 64), Size = UDim2.new(1, -90, 0, 14),
    TextXAlignment = Enum.TextXAlignment.Left,
}, card)

local gameLbl = new("TextLabel", {
    Text = "", Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = COLORS.accentB,
    BackgroundTransparency = 1, Position = UDim2.fromOffset(78, 80), Size = UDim2.new(1, -90, 0, 14),
    TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
}, card)

local starBtn = new("TextButton", {
    Size = UDim2.fromOffset(24, 24), Position = UDim2.new(1, -88, 0, 8),
    BackgroundColor3 = COLORS.panel3, Text = "☆",
    Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = COLORS.subtext, AutoButtonColor = false,
}, card)
corner(UDim.new(1, 0), starBtn)
addHover(starBtn, "accent", COLORS.panel3)
addPress(starBtn)
applyMetallicStyle(starBtn, 1.2)
applyColorGlow(starBtn, "accentC", 1, 0.45, 0.85, 1.3)

local linkBtn = new("TextButton", {
    Size = UDim2.fromOffset(24, 24), Position = UDim2.new(1, -60, 0, 8),
    BackgroundColor3 = COLORS.panel3, Text = "🔗",
    Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = COLORS.text, AutoButtonColor = false,
}, card)
corner(UDim.new(1, 0), linkBtn)
addHover(linkBtn, "accent", COLORS.panel3)
addPress(linkBtn)
applyMetallicStyle(linkBtn, 1.2)
applyColorGlow(linkBtn, "accent", 1, 0.45, 0.85, 1.3)

local copyBtn = new("TextButton", {
    Size = UDim2.fromOffset(24, 24), Position = UDim2.new(1, -32, 0, 8),
    BackgroundColor3 = COLORS.panel3, Text = "📋",
    Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = COLORS.text, AutoButtonColor = false,
}, card)
corner(UDim.new(1, 0), copyBtn)
addHover(copyBtn, "accent", COLORS.panel3)
addPress(copyBtn)
applyMetallicStyle(copyBtn, 1.2)
applyColorGlow(copyBtn, "accentB", 1, 0.45, 0.85, 1.3)

refreshStarIcon = function()
    if not currentUser then return end
    local fav = isFavorite(currentUser.id)
    starBtn.Text = fav and "⭐" or "☆"
    starBtn.TextColor3 = fav and COLORS.accentC or COLORS.subtext
end

toggleFavorite = function(entry)
    if not entry or not entry.id then return end
    if favoritesSet[entry.id] then
        favoritesSet[entry.id] = nil
        for i, f in ipairs(favorites) do
            if f.id == entry.id then table.remove(favorites, i) break end
        end
    else
        favoritesSet[entry.id] = true
        table.insert(favorites, 1, { id = entry.id, name = entry.name, displayName = entry.displayName, hasVerifiedBadge = entry.hasVerifiedBadge })
    end
    if currentUser and currentUser.id == entry.id then
        refreshStarIcon()
    end
end

local tabsHolder = new("Frame", {
    Size = UDim2.new(1, -24, 0, 32), Position = UDim2.fromOffset(12, 274),
    BackgroundColor3 = COLORS.panel2, BorderSizePixel = 0, Visible = false,
}, main)
corner(10, tabsHolder)

local tabIndicator = new("Frame", {
    Size = UDim2.new(1/3, -4, 1, -6),
    Position = UDim2.new(0, 2, 0, 3),
    BackgroundColor3 = COLORS.accent, BorderSizePixel = 0, ZIndex = 1,
}, tabsHolder)
corner(8, tabIndicator)
local tabIndicatorGlow = applyColorGlow(tabIndicator, COLORS.accent, 1.2, 0.25, 0.7, 1.0)

local tabNames = { "friends", "followers", "following" }
local tabLabels = { friends = T("tabFriends"), followers = T("tabFollowers"), following = T("tabFollowing") }
local tabs = {}

for i, key in ipairs(tabNames) do
    local btn = new("TextButton", {
        Size = UDim2.new(1/3, 0, 1, 0),
        Position = UDim2.new((i - 1) / 3, 0, 0, 0),
        BackgroundTransparency = 1, Text = tabLabels[key] .. " (0)",
        Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = COLORS.subtext,
        ZIndex = 2, AutoButtonColor = false,
    }, tabsHolder)
    addPress(btn)
    tabs[key] = btn
end

local function setActiveTab(key)
    local index = table.find(tabNames, key) or 1
    local targetPos = UDim2.new((index - 1) / 3, 2, 0, 3)
    local activeColor = disabledTabs[key] and COLORS.warn or (TAB_COLORS[key] or COLORS.accent)

    tween(tabIndicator, { Position = targetPos, BackgroundColor3 = activeColor }, 0.25)
    tabIndicatorGlow.Color = activeColor

    for k, btn in pairs(tabs) do
        tween(btn, { TextColor3 = (k == key) and Color3.new(1, 1, 1) or (disabledTabs[k] and COLORS.warn or COLORS.subtext) }, 0.15)
    end
end

local listFrame = new("ScrollingFrame", {
    Size = UDim2.new(1, -24, 1, -324), Position = UDim2.fromOffset(12, 314),
    BackgroundColor3 = COLORS.panel, BorderSizePixel = 0,
    ScrollBarThickness = 3, ScrollBarImageColor3 = COLORS.accent,
    CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
    Visible = false,
}, main)
corner(10, listFrame)
new("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder }, listFrame)
new("UIPadding", {
    PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6),
    PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6),
}, listFrame)

local loadMoreBtn = new("TextButton", {
    Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = COLORS.panel2,
    Text = T("loadMore"), Font = Enum.Font.GothamBold, TextSize = 11,
    TextColor3 = COLORS.text, Visible = false, LayoutOrder = 9999, AutoButtonColor = false,
}, listFrame)
corner(8, loadMoreBtn)
addHover(loadMoreBtn, COLORS.panel3, COLORS.panel2)
addPress(loadMoreBtn)

flashStatus = function(text, color)
    statusLabel.Text = text
    statusLabel.TextColor3 = color or COLORS.subtext
end

doCopy = function(text, btn)
    local clip = setclipboard or toclipboard
    if not clip then
        flashStatus(T("noClipboard"), COLORS.warn)
        return
    end
    clip(text)
    local old = btn.Text
    btn.Text = "✓"
    task.delay(1, function() btn.Text = old end)
end
copyBtn.MouseButton1Click:Connect(function() if currentUser then doCopy(currentUser.name, copyBtn) end end)
linkBtn.MouseButton1Click:Connect(function()
    if currentUser then
        doCopy("https://www.roblox.com/users/" .. currentUser.id .. "/profile", linkBtn)
    end
end)
starBtn.MouseButton1Click:Connect(function()
    if currentUser then
        toggleFavorite(currentUser)
        refreshStarIcon()
    end
end)

local function hideSkeletons()
    for _, s in ipairs(skeletons) do s:Destroy() end
    table.clear(skeletons)
end

local function showSkeletons()
    for i = 1, 4 do
        local row = new("CanvasGroup", { Size = UDim2.new(1, 0, 0, 42), BackgroundColor3 = COLORS.panel2, BorderSizePixel = 0 }, listFrame)
        corner(8, row)
        corner(6, new("Frame", { Size = UDim2.fromOffset(30, 30), Position = UDim2.fromOffset(6, 6), BackgroundColor3 = COLORS.panel3, BorderSizePixel = 0 }, row))
        corner(4, new("Frame", { Size = UDim2.new(0, 100, 0, 10), Position = UDim2.fromOffset(42, 8), BackgroundColor3 = COLORS.panel3, BorderSizePixel = 0 }, row))
        corner(4, new("Frame", { Size = UDim2.new(0, 70, 0, 9), Position = UDim2.fromOffset(42, 23), BackgroundColor3 = COLORS.panel3, BorderSizePixel = 0 }, row))
        pulseLoop(row, "GroupTransparency", 0, 0.5, 0.7 + i * 0.05)
        table.insert(skeletons, row)
    end
end

local function clearList()
    for _, child in ipairs(listFrame:GetChildren()) do
        if child.Name == "Entry" then child:Destroy() end
    end
    hideSkeletons()
    loadMoreBtn.Visible = false
end

local function addEntry(userData)
    local row = new("CanvasGroup", {
        Name = "Entry", Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = COLORS.panel2, BorderSizePixel = 0, GroupTransparency = 1,
    }, listFrame)
    corner(8, row)

    local loadFailed = userData._resolveFailed == true
    local unresolved = (not loadFailed) and isUnresolvedUser(userData)

    local img = new("ImageLabel", {
        Size = UDim2.fromOffset(30, 30), Position = UDim2.fromOffset(6, 6),
        BackgroundColor3 = COLORS.panel3, ClipsDescendants = true,
        Image = (unresolved or loadFailed) and "" or ("rbxthumb://type=AvatarHeadShot&id=" .. userData.id .. "&w=48&h=48"),
    }, row)
    corner(8, img)
    applyColorGlow(img, COLORS.accentB, 1, 0.5, 0.9, 1.4)
    if loadFailed then
        new("TextLabel", {
            Text = "⚠", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = COLORS.warn,
            BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center,
        }, img)
    elseif unresolved then
        new("TextLabel", {
            Text = "❔", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = COLORS.subtext2,
            BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center,
        }, img)
    end

    local nameText
    if loadFailed then
        nameText = "تعذر تحميل الاسم — اضغط للمحاولة"
    elseif unresolved then
        nameText = "حساب غير معروف"
    else
        nameText = (userData.displayName ~= "" and userData.displayName) or userData.name or ("ID " .. userData.id)
    end

    local nameLbl = new("TextLabel", {
        Text = nameText,
        Font = Enum.Font.GothamBold, TextSize = 12,
        TextColor3 = loadFailed and COLORS.warn or (unresolved and COLORS.subtext2 or COLORS.text),
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(44, 5), Size = UDim2.new(1, -116, 0, 16),
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
    }, row)
    if not (unresolved or loadFailed) then applyTextShine(nameLbl, 2.2, 1.0) end
    if userData.hasVerifiedBadge and not (unresolved or loadFailed) then
        local w = math.min(measureTextWidth(nameText, Enum.Font.GothamBold, 12), 150)
        addVerifiedBadge(row, 44 + w + 4, 6)
    end

    local userLbl = new("TextLabel", {
        Text = loadFailed and ("ID: " .. userData.id .. " (اضغط لإعادة المحاولة)")
            or (unresolved and ("ID: " .. userData.id) or (userData.name and userData.name ~= "" and ("@" .. userData.name) or "")),
        Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = COLORS.subtext, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(44, 21), Size = UDim2.new(1, -100, 0, 14),
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
    }, row)
    if not (unresolved or loadFailed) then applyTextShine(userLbl, 2.4, 1.0) end

    local rowCopy = new("TextButton", {
        Size = UDim2.fromOffset(26, 26), Position = UDim2.new(1, -32, 0.5, -13),
        BackgroundColor3 = COLORS.panel3, Text = "📋",
        Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = COLORS.text, AutoButtonColor = false,
    }, row)
    corner(UDim.new(1, 0), rowCopy)
    addPress(rowCopy)
    addHover(rowCopy, COLORS.accent, COLORS.panel3)
    applyMetallicStyle(rowCopy, 1.2)
    applyColorGlow(rowCopy, COLORS.accentB, 1, 0.45, 0.85, 1.3)
    rowCopy.MouseButton1Click:Connect(function()
        if userData.name and userData.name ~= "" then
            doCopy(userData.name, rowCopy)
        else
            doCopy(tostring(userData.id), rowCopy)
        end
    end)

    local clickZone = new("TextButton", {
        Size = UDim2.new(1, -100, 1, 0), Position = UDim2.fromOffset(40, 0),
        BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
    }, row)
    clickZone.MouseEnter:Connect(function() tween(row, { BackgroundColor3 = COLORS.panel3 }, 0.15) end)
    clickZone.MouseLeave:Connect(function() tween(row, { BackgroundColor3 = COLORS.panel2 }, 0.15) end)
    clickZone.MouseButton1Click:Connect(function()
        playClick()
        if userData.name and userData.name ~= "" then
            searchBox.Text = userData.name
            performSearch()
        elseif userData.id then
            searchBox.Text = tostring(userData.id)
            performSearch()
        end
    end)

    tween(row, { GroupTransparency = 0 }, 0.25)
end

loadTab = function(key, append)
    if not currentUser then return end

    if disabledTabs[key] and not append then
        clearList()
        currentTab = key
        setActiveTab(key)
        flashStatus(T("locked"), COLORS.warn)
        return
    end

    if not append and tabCache[key] then
        currentTab = key
        setActiveTab(key)
        clearList()
        currentCursor = tabCache[key].cursor
        for _, u in ipairs(tabCache[key].results) do addEntry(u) end
        loadMoreBtn.Parent = nil
        loadMoreBtn.Parent = listFrame
        loadMoreBtn.Text = T("loadMore")
        loadMoreBtn.Visible = tabCache[key].cursor ~= nil
        flashStatus(#tabCache[key].results == 0 and T("noResults") or "")
        return
    end

    requestToken += 1
    local myToken = requestToken
    local userAtRequest = currentUser

    currentTab = key
    setActiveTab(key)
    if not append then
        clearList()
        currentCursor = nil
        showSkeletons()
    end

    flashStatus(append and T("loadingMore") or "")
    local cursorAtRequest = currentCursor

    task.spawn(function()
        local results, nextCursor, err
        if key == "friends" then
            results, nextCursor, err = API.getFriends(userAtRequest.id)
        elseif key == "followers" then
            results, nextCursor, err = API.getFollowers(userAtRequest.id, cursorAtRequest)
        else
            results, nextCursor, err = API.getFollowings(userAtRequest.id, cursorAtRequest)
        end

        if myToken ~= requestToken then return end

        if not append then hideSkeletons() end
        for i, u in ipairs(results) do
            task.delay((i - 1) * 0.03, function()
                if myToken ~= requestToken then return end
                addEntry(u)
            end)
        end

        if not err then
            tabCache[key] = tabCache[key] or { results = {}, cursor = nil }
            if append then
                for _, u in ipairs(results) do table.insert(tabCache[key].results, u) end
            else
                tabCache[key].results = results
            end
            tabCache[key].cursor = nextCursor
        end

        loadMoreBtn.Parent = nil
        loadMoreBtn.Parent = listFrame
        loadMoreBtn.Text = T("loadMore")
        currentCursor = nextCursor
        loadMoreBtn.Visible = nextCursor ~= nil

        if #results > 0 then
            flashStatus("")
        elseif err == 401 or err == 403 then
            disabledTabs[key] = true
            setActiveTab(key)
            flashStatus(T("locked"), COLORS.warn)
        elseif err then
            flashStatus(string.format(T("loadFail"), tostring(err)), COLORS.warn)
        elseif append then
            flashStatus(T("noMore"))
        else
            flashStatus(T("noResults"))
        end
    end)
end

loadMoreBtn.MouseButton1Click:Connect(function()
    loadMoreBtn.Text = T("loading")
    loadTab(currentTab, true)
end)

for key, btn in pairs(tabs) do
    btn.MouseButton1Click:Connect(function() loadTab(key, false) end)
end

performSearch = function()
    local query = searchBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
    if query == "" then return end

    requestToken += 1
    local myToken = requestToken

    flashStatus(T("searching"))
    searchBox:ReleaseFocus()
    currentUser = nil
    disabledTabs = {}
    tabCache = {}
    card.Visible = false
    tabsHolder.Visible = false
    listFrame.Visible = false
    createdLbl.Text = ""
    gameLbl.Text = ""
    lastCreatedStr = nil
    updatePresenceDot(0)
    starBtn.Text = "☆"
    starBtn.TextColor3 = COLORS.subtext
    clearList()
    overlayPanel.Visible = false
    if comparePanel then comparePanel.Visible = false end
    if settingsPanel then settingsPanel.Visible = false end

    task.spawn(function()
        local user = API.resolveUser(query)
        if myToken ~= requestToken then return end
        if not user then
            flashStatus(T("notFound"), COLORS.danger)
            return
        end
        currentUser = user

        avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. user.id .. "&w=150&h=150"
        displayNameLbl.Text = user.displayName
        usernameLbl.Text = "@" .. user.name
        idLbl.Text = "ID " .. user.id

        local oldBadge = card:FindFirstChild("VerifiedBadge")
        if oldBadge then oldBadge:Destroy() end
        if user.hasVerifiedBadge then
            local w = math.min(measureTextWidth(user.displayName, Enum.Font.GothamBold, 14), 160)
            addVerifiedBadge(card, 78 + w + 5, 11)
        end

        card.Visible = true
        card.GroupTransparency = 1
        card.Size = UDim2.new(1, -24, 0, 102)
        tween(card, { GroupTransparency = 0, Size = UDim2.new(1, -24, 0, 112) }, 0.3, Enum.EasingStyle.Back)

        pushRecent(user)
        refreshStarIcon()

        task.spawn(function()
            local details = API.getUserDetails(user.id)
            if myToken ~= requestToken then return end
            lastCreatedStr = details and details.created
            createdLbl.Text = lastCreatedStr and ("🗓 " .. formatCreatedInfo(lastCreatedStr)) or ""
        end)

        task.spawn(function()
            local presenceMap = API.getPresence({ user.id })
            if myToken ~= requestToken then return end
            local info = presenceMap[user.id]
            updatePresenceDot(info and info.status or 0)
            if info and info.status == 2 and info.location and info.location ~= "" then
                gameLbl.Text = "🎮 " .. info.location
            else
                gameLbl.Text = ""
            end
        end)

        local counts = API.getCounts(user.id)
        if myToken ~= requestToken then return end
        tabs.friends.Text = tabLabels.friends .. " (" .. counts.friends .. ")"
        tabs.followers.Text = tabLabels.followers .. " (" .. counts.followers .. ")"
        tabs.following.Text = tabLabels.following .. " (" .. counts.following .. ")"

        tabsHolder.Visible = true
        listFrame.Visible = true
        loadTab("friends", false)
    end)
end

searchBtn.MouseButton1Click:Connect(performSearch)
searchBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then performSearch() end
end)

closeUI = function()
    overlayPanel.Visible = false
    if comparePanel then comparePanel.Visible = false end
    if settingsPanel then settingsPanel.Visible = false end
    if closeAvatarPreview then closeAvatarPreview() end
    persistWindow()
    local shrinkSize = UDim2.fromOffset(math.max(windowSize.X.Offset - 20, MIN_SIZE.X), math.max(windowSize.Y.Offset - 20, MIN_SIZE.Y))
    tween(backdrop, { BackgroundTransparency = 1 }, 0.25)
    tween(main, { GroupTransparency = 1, Size = shrinkSize }, 0.25, Enum.EasingStyle.Quad)
    task.delay(0.2, function()
        backdrop.Visible = false
        main.Visible = false
        main.Size = windowSize
        toggleBtn.Visible = true
        toggleBtn.Size = UDim2.fromOffset(0, 0)
        tween(toggleBtn, { Size = TOGGLE_SIZE }, 0.3, Enum.EasingStyle.Back)
    end)
end

openUI = function()
    watchBadge.Visible = false
    local openSize = windowSize
    tween(toggleBtn, { Size = UDim2.fromOffset(0, 0) }, 0.2, Enum.EasingStyle.Quad)
    task.delay(0.18, function()
        toggleBtn.Visible = false
        backdrop.Visible = true
        main.Visible = true
        main.Size = UDim2.fromOffset(math.max(openSize.X.Offset - 20, MIN_SIZE.X), math.max(openSize.Y.Offset - 20, MIN_SIZE.Y))
        tween(backdrop, { BackgroundTransparency = 0.5 }, 0.3)
        tween(main, { GroupTransparency = 0, Size = openSize }, 0.4, Enum.EasingStyle.Back)
    end)
end

settingsBtn.MouseButton1Click:Connect(function()
    playClick()
    overlayPanel.Visible = false
    if comparePanel then comparePanel.Visible = false end
    if settingsPanel then settingsPanel.Visible = true end
end)

-- Resize by dragging any of the 4 corners (touch-friendly, no visible button)
local CORNER_SIZE = 28

local cornerConfigs = {
    { name = "TL", anchor = Vector2.new(0, 0), pos = UDim2.new(0, 0, 0, 0), sx = -1, sy = -1 },
    { name = "TR", anchor = Vector2.new(1, 0), pos = UDim2.new(1, 0, 0, 0), sx =  1, sy = -1 },
    { name = "BL", anchor = Vector2.new(0, 1), pos = UDim2.new(0, 0, 1, 0), sx = -1, sy =  1 },
    { name = "BR", anchor = Vector2.new(1, 1), pos = UDim2.new(1, 0, 1, 0), sx =  1, sy =  1 },
}

for _, cfg in ipairs(cornerConfigs) do
    local zone = new("Frame", {
        Name = "ResizeZone_" .. cfg.name,
        Size = UDim2.fromOffset(CORNER_SIZE, CORNER_SIZE),
        AnchorPoint = cfg.anchor,
        Position = cfg.pos,
        BackgroundTransparency = 1,
        Active = true,
        ZIndex = 10,
    }, main)

    local resizing, startInput, startSize, startPos = false, nil, nil, nil

    zone.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            startInput = input.Position
            startSize = main.Size
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resizing = false
                    persistWindow()
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local dx = input.Position.X - startInput.X
            local dy = input.Position.Y - startInput.Y

            local newW = math.clamp(startSize.X.Offset + cfg.sx * dx, MIN_SIZE.X, MAX_SIZE.X)
            local newH = math.clamp(startSize.Y.Offset + cfg.sy * dy, MIN_SIZE.Y, MAX_SIZE.Y)

            local deltaW = newW - startSize.X.Offset
            local deltaH = newH - startSize.Y.Offset

            local centerShiftX = cfg.sx * deltaW / 2
            local centerShiftY = cfg.sy * deltaH / 2

            main.Size = UDim2.fromOffset(newW, newH)
            main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + centerShiftX,
                startPos.Y.Scale, startPos.Y.Offset + centerShiftY
            )
            windowSize = main.Size
        end
    end)
end

-- ================= واجهة الإعدادات (لغة / شفافية / ثيم) =================
settingsPanel = new("CanvasGroup", {
    Size = UDim2.new(1, -24, 0, 340), Position = UDim2.fromOffset(12, 134),
    BackgroundColor3 = COLORS.bg, BorderSizePixel = 0, Visible = false, ZIndex = 5,
}, main)
corner(12, settingsPanel)
applyMetallicStyle(settingsPanel, 1.5)
applyColorGlow(settingsPanel, "accent", 1.5, 0.35, 0.8, 1.8)

local settingsHeader = new("Frame", { Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, ZIndex = 6 }, settingsPanel)
local settingsTitleLbl = new("TextLabel", {
    Text = T("settingsTitle"), Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = COLORS.text,
    BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -50, 1, 0),
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6,
}, settingsHeader)
local settingsClose = new("TextButton", {
    Text = "✖", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = COLORS.subtext,
    BackgroundColor3 = COLORS.panel2, Size = UDim2.fromOffset(24, 24), Position = UDim2.new(1, -32, 0, 4),
    AutoButtonColor = false, ZIndex = 6,
}, settingsHeader)
corner(UDim.new(1, 0), settingsClose)
addPress(settingsClose)
applyColorGlow(settingsClose, COLORS.danger, 1.2, 0.5, 0.9, 1.6)
settingsClose.MouseEnter:Connect(function() tween(settingsClose, { BackgroundColor3 = COLORS.danger, TextColor3 = Color3.new(1,1,1) }, 0.15) end)
settingsClose.MouseLeave:Connect(function() tween(settingsClose, { BackgroundColor3 = COLORS.panel2, TextColor3 = COLORS.subtext }, 0.15) end)
settingsClose.MouseButton1Click:Connect(function() settingsPanel.Visible = false end)

local settingsList = new("ScrollingFrame", {
    Size = UDim2.new(1, -12, 1, -40), Position = UDim2.fromOffset(6, 34),
    BackgroundTransparency = 1, BorderSizePixel = 0,
    ScrollBarThickness = 3, ScrollBarImageColor3 = COLORS.accent,
    CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ZIndex = 6,
}, settingsPanel)
new("UIListLayout", { Padding = UDim.new(0, 14), SortOrder = Enum.SortOrder.LayoutOrder }, settingsList)
new("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 10) }, settingsList)

-- صف اللغة
local langRow = new("Frame", { Size = UDim2.new(1, -12, 0, 52), BackgroundTransparency = 1, ZIndex = 6 }, settingsList)
local langLabelLbl = new("TextLabel", {
    Text = T("langLabel"), Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = COLORS.subtext,
    BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6,
}, langRow)
local langARBtn = new("TextButton", {
    Text = "عربي", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Color3.new(1,1,1),
    Size = UDim2.fromOffset(64, 28), Position = UDim2.fromOffset(0, 20),
    BackgroundColor3 = COLORS.panel3, AutoButtonColor = false, ZIndex = 6,
}, langRow)
corner(8, langARBtn)
addPress(langARBtn)
local langENBtn = new("TextButton", {
    Text = "EN", Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Color3.new(1,1,1),
    Size = UDim2.fromOffset(64, 28), Position = UDim2.fromOffset(70, 20),
    BackgroundColor3 = COLORS.panel3, AutoButtonColor = false, ZIndex = 6,
}, langRow)
corner(8, langENBtn)
addPress(langENBtn)

refreshLangButtons = function()
    langARBtn.BackgroundColor3 = LANG == "ar" and COLORS.accent or COLORS.panel3
    langENBtn.BackgroundColor3 = LANG == "en" and COLORS.accent or COLORS.panel3
end
refreshLangButtons()

langARBtn.MouseButton1Click:Connect(function()
    if LANG == "ar" then return end
    LANG = "ar"; persisted.lang = "ar"; savePersisted()
    refreshLangButtons()
    applyLanguage()
end)
langENBtn.MouseButton1Click:Connect(function()
    if LANG == "en" then return end
    LANG = "en"; persisted.lang = "en"; savePersisted()
    refreshLangButtons()
    applyLanguage()
end)

-- صف الشفافية
local transRow = new("Frame", { Size = UDim2.new(1, -12, 0, 52), BackgroundTransparency = 1, ZIndex = 6 }, settingsList)
local transLabelLbl = new("TextLabel", {
    Text = T("transLabel"), Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = COLORS.subtext,
    BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6,
}, transRow)
local sliderTrack = new("Frame", {
    Size = UDim2.new(1, -8, 0, 6), Position = UDim2.fromOffset(4, 30),
    BackgroundColor3 = COLORS.panel3, BorderSizePixel = 0, Active = true, ZIndex = 6,
}, transRow)
corner(3, sliderTrack)
local sliderFill = new("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = COLORS.accent, BorderSizePixel = 0, ZIndex = 7 }, sliderTrack)
corner(3, sliderFill)
themedProp(sliderFill, "BackgroundColor3", "accent")
local sliderKnob = new("Frame", {
    Size = UDim2.fromOffset(16, 16), AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = COLORS.accentB, BorderSizePixel = 0, ZIndex = 8,
}, sliderTrack)
corner(UDim.new(1, 0), sliderKnob)
themedProp(sliderKnob, "BackgroundColor3", "accentB")
new("UIStroke", { Color = Color3.new(1,1,1), Thickness = 1.5, Transparency = 0.6 }, sliderKnob)

local function setSliderVisual(v)
    v = math.clamp(v, 0, 1)
    sliderFill.Size = UDim2.new(v, 0, 1, 0)
    sliderKnob.Position = UDim2.new(v, 0, 0.5, 0)
end

applyTransparency = function(value)
    value = math.clamp(value, 0, 1)
    main.BackgroundTransparency = value * 0.65
    persisted.transparency = value
end

do
    local initV = persisted.transparency or 0
    setSliderVisual(initV)
    applyTransparency(initV)
end

local draggingSlider = false
local function sliderInputToValue(pos)
    local rel = (pos.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X
    return math.clamp(rel, 0, 1)
end
sliderTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = true
        local v = sliderInputToValue(input.Position)
        setSliderVisual(v)
        applyTransparency(v)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local v = sliderInputToValue(input.Position)
        setSliderVisual(v)
        applyTransparency(v)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        draggingSlider = false
        savePersisted()
    end
end)

-- صف الثيم
local themeRow = new("Frame", { Size = UDim2.new(1, -12, 0, 60), BackgroundTransparency = 1, ZIndex = 6 }, settingsList)
local themeLabelLbl = new("TextLabel", {
    Text = T("themeLabel"), Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = COLORS.subtext,
    BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6,
}, themeRow)
local themeOrder = { "purple", "azure", "crimson", "emerald", "gold" }
local themeSwatches = {}
for i, name in ipairs(themeOrder) do
    local sw = new("TextButton", {
        Size = UDim2.fromOffset(30, 30), Position = UDim2.fromOffset((i - 1) * 38, 22),
        BackgroundColor3 = THEMES[name].accent, Text = "", AutoButtonColor = false, ZIndex = 6,
    }, themeRow)
    corner(UDim.new(1, 0), sw)
    local ring = new("UIStroke", {
        Color = Color3.new(1, 1, 1), Thickness = 2,
        Transparency = (name == currentThemeName) and 0.2 or 1,
    }, sw)
    themeSwatches[name] = ring
    addPress(sw)
    sw.MouseButton1Click:Connect(function()
        playClick()
        applyTheme(name)
        for n, r in pairs(themeSwatches) do r.Transparency = (n == name) and 0.2 or 1 end
    end)
end

applyTheme = function(name)
    local t = THEMES[name]
    if not t then return end
    currentThemeName = name
    COLORS.accent, COLORS.accentB, COLORS.accentC, COLORS.compare = t.accent, t.accentB, t.accentC, t.compare
    TAB_COLORS.friends, TAB_COLORS.followers, TAB_COLORS.following = t.accent, t.accentB, t.accentC
    for _, e in ipairs(themeRegistry) do
        if e.inst and e.inst.Parent then
            if e.kind == "grad" then
                local seq = {}
                for i, r in ipairs(e.roles) do seq[i] = COLORS[r] end
                e.inst.Color = (#seq == 1) and ColorSequence.new(seq[1]) or ColorSequence.new(seq[1], seq[#seq])
            else
                e.inst[e.prop] = COLORS[e.role]
            end
        end
    end
    setActiveTab(currentTab)
    persisted.theme = name
    savePersisted()
end

applyLanguage = function()
    subtitleLbl.Text = T("subtitle")
    searchBox.PlaceholderText = T("searchPlaceholder")
    historyBtn.Text = T("recent")
    favBtn.Text = T("favorites")
    compareBtn.Text = T("compare")
    tabLabels.friends = T("tabFriends")
    tabLabels.followers = T("tabFollowers")
    tabLabels.following = T("tabFollowing")
    for _, key in ipairs(tabNames) do
        local btn = tabs[key]
        local countPart = btn.Text:match("%((%d+)%)")
        btn.Text = tabLabels[key] .. " (" .. (countPart or "0") .. ")"
    end
    loadMoreBtn.Text = T("loadMore")
    compareSearchBox.PlaceholderText = T("comparePlaceholder")
    compareTitleLbl.Text = T("comparePanelTitle")
    settingsTitleLbl.Text = T("settingsTitle")
    langLabelLbl.Text = T("langLabel")
    transLabelLbl.Text = T("transLabel")
    themeLabelLbl.Text = T("themeLabel")
    overlayEmptyLbl.Text = T("emptyList")
    if overlayPanel.Visible then
        overlayTitle.Text = currentOverlayKind == "favorites" and T("favTitle") or T("historyTitle")
    end
    if currentUser and lastCreatedStr then
        createdLbl.Text = "🗓 " .. formatCreatedInfo(lastCreatedStr)
    end
end

-- ================= معاينة أفتار كبيرة =================
local avatarPreviewBackdrop = new("TextButton", {
    Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1,
    Text = "", AutoButtonColor = false, ZIndex = 49, Visible = false,
}, gui)

local avatarPreview = new("CanvasGroup", {
    Size = UDim2.fromOffset(260, 300), AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = COLORS.bg,
    BorderSizePixel = 0, Visible = false, ZIndex = 50, GroupTransparency = 1,
}, gui)
corner(18, avatarPreview)
applyMetallicStyle(avatarPreview, 2)
applyColorGlow(avatarPreview, "accent", 2, 0.3, 0.7, 1.8)

local bigAvatarImg = new("ImageLabel", {
    Size = UDim2.fromOffset(220, 220), Position = UDim2.fromOffset(20, 20),
    BackgroundColor3 = COLORS.panel2, ZIndex = 51,
}, avatarPreview)
corner(14, bigAvatarImg)

local bigAvatarName = new("TextLabel", {
    Text = "", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = COLORS.text,
    BackgroundTransparency = 1, Position = UDim2.fromOffset(20, 244), Size = UDim2.new(1, -40, 0, 20),
    TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 51,
}, avatarPreview)

local avatarPreviewClose = new("TextButton", {
    Text = "✖", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = COLORS.subtext,
    BackgroundColor3 = COLORS.panel2, Size = UDim2.fromOffset(26, 26), Position = UDim2.new(1, -36, 0, 10),
    AutoButtonColor = false, ZIndex = 52,
}, avatarPreview)
corner(UDim.new(1, 0), avatarPreviewClose)
addPress(avatarPreviewClose)
applyColorGlow(avatarPreviewClose, COLORS.danger, 1.2, 0.5, 0.9, 1.6)
avatarPreviewClose.MouseEnter:Connect(function() tween(avatarPreviewClose, { BackgroundColor3 = COLORS.danger, TextColor3 = Color3.new(1,1,1) }, 0.15) end)
avatarPreviewClose.MouseLeave:Connect(function() tween(avatarPreviewClose, { BackgroundColor3 = COLORS.panel2, TextColor3 = COLORS.subtext }, 0.15) end)

closeAvatarPreview = function()
    if not avatarPreview.Visible then return end
    tween(avatarPreview, { GroupTransparency = 1 }, 0.2)
    tween(avatarPreviewBackdrop, { BackgroundTransparency = 1 }, 0.2)
    task.delay(0.18, function()
        avatarPreview.Visible = false
        avatarPreviewBackdrop.Visible = false
    end)
end
avatarPreviewClose.MouseButton1Click:Connect(function() closeAvatarPreview() end)
avatarPreviewBackdrop.MouseButton1Click:Connect(function() closeAvatarPreview() end)

openAvatarPreview = function()
    if not currentUser then return end
    playClick()
    bigAvatarImg.Image = "rbxthumb://type=AvatarThumbnail&id=" .. currentUser.id .. "&w=420&h=420"
    bigAvatarName.Text = (currentUser.displayName ~= "" and currentUser.displayName) or currentUser.name
    avatarPreviewBackdrop.Visible = true
    avatarPreview.Visible = true
    avatarPreview.Size = UDim2.fromOffset(230, 270)
    tween(avatarPreviewBackdrop, { BackgroundTransparency = 0.4 }, 0.25)
    tween(avatarPreview, { GroupTransparency = 0, Size = UDim2.fromOffset(260, 300) }, 0.3, Enum.EasingStyle.Back)
end