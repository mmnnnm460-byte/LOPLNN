--[[
    Players Viewer v6 | واجهة اللاعبين
    جديد في v5:
    - ظل ناعم دائري الزوايا (طبقات) بدل الظل المربع
    - تدرّج متحرك حول النافذة + قوائم اللاعبين + الأزرار
    - ألوان مخصصة لكل جزء (الواجهة / الأزرار / القوائم) من ⚙ الإعدادات + حفظ تلقائي
    - ايقونة عائمة تفتح/تسكر الواجهة بنفس التصميم + توهج (Bloom) أبيض/فضي لامع متحرك
    - تحسين السلاسة: التحريك 30Hz فقط للصفحة الظاهرة + يتوقف عند اخفاء الواجهة
]]

local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local TweenService       = game:GetService("TweenService")
local UserInputService   = game:GetService("UserInputService")
local HttpService        = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer        = Players.LocalPlayer

if _G.__PlayersViewerCleanup then pcall(_G.__PlayersViewerCleanup) end

-- ================= الحالة العامة =================
local alive = true
local connections = {}
local rotConn
local windowOpen = true
local winToken = 0
local savedPos
local animOn = true
local httpEnabled = true
local function track(c) connections[#connections + 1] = c return c end

-- ================= الثيم (iOS) =================
local function RGB(r, g, b) return Color3.fromRGB(r, g, b) end
local C = {
    bg     = RGB(28, 28, 30),
    card   = RGB(44, 44, 46),
    card2  = RGB(58, 58, 60),
    blue   = RGB(10, 132, 255),
    green  = RGB(48, 209, 88),
    red    = RGB(255, 69, 58),
    yellow = RGB(255, 214, 10),
    orange = RGB(255, 159, 10),
    white  = RGB(255, 255, 255),
    black  = RGB(0, 0, 0),
    gray   = RGB(152, 152, 157),
}
local FM = Enum.Font.GothamMedium
local FB = Enum.Font.GothamBold
local HEADER_H = 52
local NEAR_STUDS = 150
local ANIM_STEP = 1 / 30

-- ================= الألوان المخصصة =================
local PALETTES = {
    {name = "أزرق",     a = RGB(10, 132, 255),  b = RGB(90, 220, 255)},
    {name = "بنفسجي",   a = RGB(175, 82, 222),  b = RGB(255, 105, 180)},
    {name = "أخضر",     a = RGB(48, 209, 88),   b = RGB(90, 240, 200)},
    {name = "برتقالي",  a = RGB(255, 149, 0),   b = RGB(255, 214, 10)},
    {name = "أحمر",     a = RGB(255, 69, 58),   b = RGB(255, 120, 160)},
    {name = "فضي",      a = RGB(190, 190, 200), b = RGB(255, 255, 255)},
    {name = "قوس قزح",  a = RGB(10, 132, 255),  b = RGB(255, 55, 150), rainbow = true},
}
local DEFAULT_IDX = {window = 1, button = 2, list = 3}
local themeIdx = {window = 1, button = 2, list = 3}
local theme = {window = PALETTES[1], button = PALETTES[2], list = PALETTES[3]}
local reg = {window = {}, button = {}, list = {}}

-- تحميل الألوان المحفوظة (اذا الاكسكيوتر يدعم الملفات)
pcall(function()
    if not (isfile and readfile and isfile("PV_theme.json")) then return end
    local d = HttpService:JSONDecode(readfile("PV_theme.json"))
    if type(d) ~= "table" then return end
    local keys = {window = "w", button = "b", list = "l"}
    for cat, key in pairs(keys) do
        local i = d[key]
        if type(i) == "number" and PALETTES[i] then
            themeIdx[cat] = i
            theme[cat] = PALETTES[i]
        end
    end
    if d.a == false then animOn = false end
    if d.h == false then httpEnabled = false end
end)

local function saveTheme()
    pcall(function()
        if not writefile then return end
        local data = HttpService:JSONEncode({
            w = themeIdx.window, b = themeIdx.button, l = themeIdx.list, a = animOn, h = httpEnabled,
        })
        writefile("PV_theme.json", data)
    end)
end

-- تسجيل دالة تتحدث لما يتغير لون الفئة (ترجع false اذا العنصر انحذف)
local function register(cat, fn)
    reg[cat][#reg[cat] + 1] = fn
    pcall(fn, theme[cat])
end

local function applyTheme(cat)
    local p = theme[cat]
    local keep = {}
    for _, fn in ipairs(reg[cat]) do
        local ok, res = pcall(fn, p)
        if ok and res ~= false then keep[#keep + 1] = fn end
    end
    reg[cat] = keep
end

-- ================= أدوات عامة =================
local function new(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props) do o[k] = v end
    if parent then o.Parent = parent end
    return o
end

local function corner(o, r)
    return new("UICorner", {CornerRadius = UDim.new(0, r)}, o)
end

local function tw(o, t, props, style, dir)
    local tween = TweenService:Create(o,
        TweenInfo.new(t, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local function twDelay(o, t, delay, props, style)
    local tween = TweenService:Create(o,
        TweenInfo.new(t, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, delay or 0), props)
    tween:Play()
    return tween
end

local function label(parent, text, size, color, bold, pos, sz, align)
    return new("TextLabel", {
        BackgroundTransparency = 1,
        Text = text,
        TextSize = size,
        TextColor3 = color,
        Font = bold and FB or FM,
        TextXAlignment = align or Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Position = pos,
        Size = sz,
    }, parent)
end

-- ================= التدرجات المتحركة =================
local function CSK(t, c) return ColorSequenceKeypoint.new(t, c) end
local function NSK(t, v) return NumberSequenceKeypoint.new(t, v) end

local function colorSeq(p)
    if p.rainbow then
        return ColorSequence.new({
            CSK(0, RGB(255, 69, 58)), CSK(0.2, RGB(255, 214, 10)), CSK(0.4, RGB(48, 209, 88)),
            CSK(0.6, RGB(90, 220, 255)), CSK(0.8, RGB(175, 82, 222)), CSK(1, RGB(255, 69, 58)),
        })
    end
    local mid = p.a:Lerp(p.b, 0.5)
    return ColorSequence.new({
        CSK(0, p.a), CSK(0.25, mid), CSK(0.5, p.b), CSK(0.75, mid), CSK(1, p.a),
    })
end

-- قوس فاتح يلف حول الاطار
local function alphaSeq(base, peak)
    local function L(t) return base + (peak - base) * t end
    return NumberSequence.new({
        NSK(0, L(0.25)), NSK(0.05, base), NSK(0.28, base), NSK(0.37, L(0.35)), NSK(0.45, L(0.8)),
        NSK(0.5, peak), NSK(0.55, L(0.8)), NSK(0.63, L(0.35)), NSK(0.72, base), NSK(0.95, base),
        NSK(1, L(0.25)),
    })
end

local SILVER = ColorSequence.new({
    CSK(0, RGB(255, 255, 255)), CSK(0.25, RGB(170, 176, 188)), CSK(0.5, RGB(255, 255, 255)),
    CSK(0.75, RGB(170, 176, 188)), CSK(1, RGB(255, 255, 255)),
})

local animList = {}
local curTag = "window"
local function addAnim(g, speed, phase, tag, host, scroll)
    animList[#animList + 1] = {
        g = g, speed = speed, phase = phase or math.random() * 360, tag = tag or curTag,
        host = host, scroll = scroll,
    }
end

-- اطار متدرج (متحرك أو ثابت) يتلون حسب الفئة
local function addBorder(obj, cat, o)
    o = o or {}
    local stroke = new("UIStroke", {
        Color = C.white,
        Thickness = o.thick or 1.2,
        Transparency = 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, obj)
    local g = new("UIGradient", {Rotation = o.phase or 0}, stroke)
    if o.anim then
        g.Transparency = alphaSeq(o.base or 0.88, o.peak or 0.1)
        addAnim(g, o.speed or 80, o.phase, o.tag, o.host, o.scroll)
    else
        g.Transparency = NumberSequence.new(o.static or 0.7)
    end
    register(cat, function(p)
        if not g.Parent then return false end
        g.Color = colorSeq(p)
        return true
    end)
    return stroke, g
end

-- اطار منفصل (ما يتأثر بتدرج خلفية الأب)
local function glowFrame(parent, radius, cat, o)
    local f = new("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = (o and o.z) or 2,
    }, parent)
    corner(f, radius)
    local st, g = addBorder(f, cat, o)
    return f, st, g
end

-- لون الخلفية عند نسبة ارتفاع معينة (للتلاشي) حسب ثيم الواجهة
local GRAD_TOP = RGB(46, 46, 50)
local GRAD_BOT = RGB(24, 24, 27)
local function windowColors(p, topMix, botMix)
    return GRAD_TOP:Lerp(p.a, topMix or 0.10), GRAD_BOT:Lerp(p.b, botMix or 0.05)
end
local function bgAtP(f, p)
    local top, bot = windowColors(p)
    return top:Lerp(bot, math.clamp(f, 0, 1))
end

local function windowGradient(frame, topMix, botMix)
    local g = new("UIGradient", {Rotation = 90}, frame)
    register("window", function(p)
        if not g.Parent then return false end
        local top, bot = windowColors(p, topMix, botMix)
        g.Color = ColorSequence.new(top, bot)
        return true
    end)
    return g
end

-- ================= ظل ناعم دائري (طبقات) + توهج =================
-- ظل حقيقي: صورة PNG ناعمة (blur) تتولد محلياً مرة وحدة وتنحفظ، وتتمدد 9-slice
local shadowImg
local setupShadow
do
    local SHADOW_M = 36 -- مدى الظل حول الواجهة

    local function buildShadowPng()
        local S, R, half, sigma, A = 120, 22, 24, 10, 0.78
        local c = S / 2
        local function alphaAt(x, y)
            local qx = math.abs(x + 0.5 - c) - half + R
            local qy = math.abs(y + 0.5 - c) - half + R
            local ox, oy = math.max(qx, 0), math.max(qy, 0)
            local d = math.sqrt(ox * ox + oy * oy) + math.min(math.max(qx, qy), 0) - R
            local a = A / (1 + math.exp(1.702 * d / sigma))
            return math.floor(a * 255 + 0.5)
        end
        local tab = {}
        for i = 0, 255 do
            local cr = i
            for _ = 1, 8 do
                if bit32.band(cr, 1) == 1 then cr = bit32.bxor(bit32.rshift(cr, 1), 0xEDB88320)
                else cr = bit32.rshift(cr, 1) end
            end
            tab[i] = cr
        end
        local function crc(str)
            local cr = 0xFFFFFFFF
            for i = 1, #str do
                cr = bit32.bxor(tab[bit32.band(bit32.bxor(cr, str:byte(i)), 0xFF)], bit32.rshift(cr, 8))
            end
            return bit32.bxor(cr, 0xFFFFFFFF)
        end
        local function u32(n)
            return string.char(bit32.rshift(n, 24) % 256, bit32.rshift(n, 16) % 256,
                bit32.rshift(n, 8) % 256, n % 256)
        end
        local function chunk(typ, data)
            return u32(#data) .. typ .. data .. u32(crc(typ .. data))
        end
        local rowsT = {}
        for y = 0, S - 1 do
            local r = {"\0"}
            for x = 0, S - 1 do r[#r + 1] = string.char(0, 0, 0, alphaAt(x, y)) end
            rowsT[#rowsT + 1] = table.concat(r)
        end
        local raw = table.concat(rowsT)
        local a1, a2 = 1, 0
        for i = 1, #raw do
            a1 = (a1 + raw:byte(i)) % 65521
            a2 = (a2 + a1) % 65521
        end
        local z = {"\120\1"}
        local pos, len = 1, #raw
        while pos <= len do
            local n = math.min(65535, len - pos + 1)
            local final = (pos + n > len) and 1 or 0
            local nn = 65535 - n
            z[#z + 1] = string.char(final, n % 256, math.floor(n / 256), nn % 256, math.floor(nn / 256))
            z[#z + 1] = raw:sub(pos, pos + n - 1)
            pos = pos + n
        end
        z[#z + 1] = u32(a2 * 65536 + a1)
        local ihdr = u32(S) .. u32(S) .. string.char(8, 6, 0, 0, 0)
        return "\137PNG\r\n\26\n" .. chunk("IHDR", ihdr) .. chunk("IDAT", table.concat(z)) .. chunk("IEND", "")
    end

    setupShadow = function(parent)
        shadowImg = new("ImageLabel", {
            Name = "Shadow",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, -SHADOW_M, 0, -SHADOW_M + 10),
            Size = UDim2.new(1, SHADOW_M * 2, 1, SHADOW_M * 2),
            Image = "",
            ImageColor3 = C.black,
            ImageTransparency = 1,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(58, 58, 62, 62),
            ZIndex = 0,
        }, parent)
        task.spawn(function()
            local url
            if writefile and getcustomasset then
                pcall(function()
                    local path = "PV_shadow_v1.png"
                    if not (isfile and isfile(path)) then writefile(path, buildShadowPng()) end
                    url = getcustomasset(path)
                end)
            end
            if not (alive and shadowImg.Parent) then return end
            if url then
                shadowImg.Image = url
                tw(shadowImg, 0.6, {ImageTransparency = 0.1})
            else
                -- بديل اذا الاكسكيوتر ما يدعم الملفات
                shadowImg.Image = "rbxassetid://5028857084"
                shadowImg.SliceCenter = Rect.new(24, 24, 276, 276)
                shadowImg.Position = UDim2.new(0, -26, 0, -16)
                shadowImg.Size = UDim2.new(1, 52, 1, 52)
                tw(shadowImg, 0.6, {ImageTransparency = 0.45})
            end
        end)
    end
end

-- توهج أبيض يتنفس حول الايقونة
local function makeBloom(parent, baseSize, layers, step, radius)
    for i = 1, layers do
        local s = baseSize + i * step * 2
        local f = new("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.fromOffset(s, s),
            BackgroundColor3 = C.white,
            BackgroundTransparency = 0.9 + i * 0.01,
            BorderSizePixel = 0,
            ZIndex = 0,
        }, parent)
        corner(f, radius + i * step)
        TweenService:Create(f,
            TweenInfo.new(1.2 + 0.2 * i, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {BackgroundTransparency = 0.975}):Play()
    end
end

-- ================= أزرار =================
-- role: "a" / "b" (ألوان فئة الأزرار) أو Color3 ثابت
local function tinted(parent, text, role, pos, sz, textSize, opts)
    opts = opts or {}
    local animated = (opts.anim ~= false)
    local holder = new("Frame", {Position = pos, Size = sz, BackgroundTransparency = 1}, parent)
    corner(holder, 9)
    local fill = new("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = C.white,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
    }, holder)
    corner(fill, 9)
    local fg = new("UIGradient", {
        Rotation = 35,
        Transparency = NumberSequence.new({NSK(0, 0.45), NSK(1, 0.88)}),
    }, fill)
    local b = new("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        Font = FB,
        TextSize = textSize or 12,
        TextColor3 = C.white,
        AutoButtonColor = false,
    }, holder)
    local us = new("UIScale", {Scale = 1}, holder)

    addBorder(holder, "button", {
        thick = 1.2, anim = animated, speed = opts.speed or 90, base = 0.8, peak = 0.05, tag = opts.tag,
    })
    if animated then addAnim(fg, 35, nil, opts.tag) end

    register("button", function(p)
        if not b.Parent then return false end
        local col
        if role == "a" then col = p.a elseif role == "b" then col = p.b else col = role end
        b.TextColor3 = col
        if type(role) == "string" then
            fg.Color = (role == "a") and colorSeq(p) or ColorSequence.new({CSK(0, p.b), CSK(0.5, p.a), CSK(1, p.b)})
            if p.rainbow then fg.Color = colorSeq(p) end
        else
            fg.Color = ColorSequence.new(role)
        end
        return true
    end)

    b.MouseButton1Down:Connect(function()
        tw(fill, 0.08, {BackgroundTransparency = 0})
        tw(us, 0.1, {Scale = 0.95})
    end)
    local function up()
        tw(fill, 0.25, {BackgroundTransparency = 0.1})
        tw(us, 0.35, {Scale = 1}, Enum.EasingStyle.Back)
    end
    b.InputEnded:Connect(up)
    b.MouseLeave:Connect(up)
    return b
end

-- أزرار خفيفة (بدون اطار/تدرج) لصفوف العناصر عشان ما تتقل الواجهة
local LB = {list = {}}
function LB.paint(it, p)
    local col = (it.role == "a") and p.a or p.b
    it.b.TextColor3 = col
    it.b.BackgroundColor3 = col
end
function LB.repaint()
    local keep = {}
    for _, it in ipairs(LB.list) do
        if it.b.Parent then
            LB.paint(it, theme.button)
            keep[#keep + 1] = it
        end
    end
    LB.list = keep
end
function LB.new(parent, text, role, pos, sz, textSize)
    local b = new("TextButton", {
        Position = pos, Size = sz,
        BackgroundColor3 = C.white, BackgroundTransparency = 0.8,
        Text = text, Font = FB, TextSize = textSize or 12,
        TextColor3 = C.white, AutoButtonColor = false,
    }, parent)
    corner(b, 9)
    local it = {b = b, role = role}
    LB.list[#LB.list + 1] = it
    LB.paint(it, theme.button)
    b.MouseButton1Down:Connect(function() tw(b, 0.08, {BackgroundTransparency = 0.5}) end)
    local function up() tw(b, 0.25, {BackgroundTransparency = 0.8}) end
    b.InputEnded:Connect(up)
    b.MouseLeave:Connect(up)
    return b
end

-- Segmented control عام
local function segmented(parent, pos, size, opts, onChange)
    local n = #opts
    local f = new("Frame", {
        Position = pos, Size = size,
        BackgroundColor3 = C.card2, BackgroundTransparency = 0.35,
    }, parent)
    corner(f, 10)
    local ind = new("Frame", {
        Size = UDim2.new(1 / n, -4, 1, -4),
        Position = UDim2.new(0, 2, 0, 2),
        BackgroundColor3 = RGB(99, 99, 102),
    }, f)
    corner(ind, 8)
    local btns = {}
    local function set(i, animate)
        local p = UDim2.new((i - 1) / n, 2, 0, 2)
        if animate then tw(ind, 0.28, {Position = p}, Enum.EasingStyle.Back) else ind.Position = p end
        for j, b in ipairs(btns) do
            b.TextColor3 = (j == i) and C.white or C.gray
        end
    end
    for i, o in ipairs(opts) do
        local b = new("TextButton", {
            Position = UDim2.new((i - 1) / n, 0, 0, 0),
            Size = UDim2.new(1 / n, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = o, Font = FB, TextSize = 13, TextColor3 = C.gray,
        }, f)
        btns[i] = b
        b.MouseButton1Click:Connect(function()
            set(i, true)
            onChange(i)
        end)
    end
    set(1, false)
    return {frame = f, set = set}
end

-- طبقة تلاشي ناعمة (تظهر فقط لما فيه محتوى مخفي)
local function fadeOverlay(parent, pos, size, frac, bottomSide, z)
    local o = new("Frame", {
        Position = pos, Size = size,
        BackgroundColor3 = bgAtP(frac, theme.window),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = z or 3,
    }, parent)
    new("UIGradient", {
        Transparency = bottomSide and NumberSequence.new(1, 0) or NumberSequence.new(0, 1),
        Rotation = 90,
    }, o)
    register("window", function(p)
        if not o.Parent then return false end
        o.BackgroundColor3 = bgAtP(frac, p)
        return true
    end)
    return o
end

local function bindFade(scroll, topO, botO)
    local lastTop, lastBot = nil, nil
    local function upd()
        local maxY = scroll.AbsoluteCanvasSize.Y - scroll.AbsoluteWindowSize.Y
        local y = scroll.CanvasPosition.Y
        local showTop = y > 6
        local showBot = (maxY - y) > 6
        if showTop ~= lastTop then
            lastTop = showTop
            tw(topO, 0.2, {BackgroundTransparency = showTop and 0 or 1})
        end
        if showBot ~= lastBot then
            lastBot = showBot
            tw(botO, 0.2, {BackgroundTransparency = showBot and 0 or 1})
        end
    end
    scroll:GetPropertyChangedSignal("CanvasPosition"):Connect(upd)
    scroll:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(upd)
    scroll:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(upd)
    upd()
end

-- هيكل تحميل (shimmer)
local function skeleton(parent, pos, size)
    local f = new("Frame", {
        Position = pos, Size = size,
        BackgroundColor3 = C.card2,
        BackgroundTransparency = 0.4,
    }, parent)
    corner(f, 5)
    TweenService:Create(f,
        TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {BackgroundTransparency = 0.82}):Play()
    return f
end

local function dropSkel(item, key)
    local s = item[key]
    if s then
        item[key] = nil
        pcall(function() s:Destroy() end)
    end
end

-- بطاقة (صف) مع اطار متدرج متحرك: slot > inner(scale) > row(canvas) + glow
local function makeCard(parent, height, radius, order, delay, tag)
    local slot = new("Frame", {
        Name = "Slot", Size = UDim2.new(1, -4, 0, height),
        BackgroundTransparency = 1, LayoutOrder = order,
    }, parent)
    local inner = new("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1}, slot)
    local sc = new("UIScale", {Scale = 0.92}, inner)
    local row = new("Frame", {
        Name = "Row", Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = C.card, BackgroundTransparency = 1, BorderSizePixel = 0,
    }, inner)
    corner(row, radius)
    local _, stroke = glowFrame(inner, radius, "list", {
        thick = 1.4, anim = true, speed = 70, base = 0.9, peak = 0.2, tag = tag, z = 3,
        host = slot, scroll = parent,
    })
    stroke.Transparency = 1
    twDelay(row, 0.35, delay, {BackgroundTransparency = 0})
    twDelay(sc, 0.5, delay, {Scale = 1}, Enum.EasingStyle.Back)
    twDelay(stroke, 0.45, delay, {Transparency = 0})
    register("list", function(p)
        if not row.Parent then return false end
        row.BackgroundColor3 = C.card:Lerp(p.a, 0.07)
        return true
    end)
    return slot, inner, row, sc, stroke
end

-- ================= نسخ + HTTPS =================
local function copy(text)
    local f = setclipboard or toclipboard or (Clipboard and Clipboard.set)
    if f then return (pcall(f, tostring(text))) end
    return false
end

-- حاكم الانترنت: طلب وحداً وحد، واذا طلب تأخر يوقف باقي الطلبات فترة (يمنع التعليق)
local Http = {busy = false, blockedUntil = 0, strikes = 0}
function Http.ready()
    return httpEnabled and os.clock() >= Http.blockedUntil
end
function Http.raw(url)
    if not Http.ready() then return nil end
    local w0 = os.clock()
    while Http.busy and os.clock() - w0 < 6 do task.wait(0.05) end
    if Http.busy or not Http.ready() then return nil end
    Http.busy = true
    local t0 = os.clock()
    local body
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if ok and type(res) == "string" and #res > 0 then
        body = res
    elseif os.clock() - t0 < 1.5 then
        local req = (syn and syn.request) or http_request or request or (http and http.request)
        if req then
            local ok2, r = pcall(req, {Url = url, Method = "GET"})
            if ok2 and type(r) == "table" and type(r.Body) == "string" and #r.Body > 0
                and (r.StatusCode == nil or r.StatusCode == 200) then
                body = r.Body
            end
        end
    end
    local dt = os.clock() - t0
    Http.busy = false
    if dt > 2.5 then
        Http.strikes = Http.strikes + 1
        Http.blockedUntil = os.clock() + math.min(20 * Http.strikes, 240)
    end
    return body, dt
end

local function httpGet(url)
    local r, dt = Http.raw(url)
    if r then return r end
    if dt and dt < 1.5 and Http.ready() then
        local alt = url:gsub("roblox%.com", "roproxy.com")
        if alt ~= url then return (Http.raw(alt)) end
    end
    return nil
end


local function jsonDecode(s)
    local ok, d = pcall(function() return HttpService:JSONDecode(s) end)
    if ok then return d end
    return nil
end

local function getJson(url)
    local b = httpGet(url)
    if not b then return nil end
    return jsonDecode(b)
end

local function fmtNum(n)
    if type(n) ~= "number" then return "—" end
    if n >= 1e6 then return string.format("%.1fM", n / 1e6) end
    if n >= 1e3 then return string.format("%.1fK", n / 1e3) end
    return tostring(n)
end

-- ================= تحميل الصور الذكي =================
local imgCache = {}

local function httpThumb(kind, id)
    local key = kind .. id
    if imgCache[key] then return imgCache[key] end
    if not (writefile and getcustomasset) then return nil end

    local api
    if kind == "asset" then
        api = "https://thumbnails.roblox.com/v1/assets?assetIds=" .. id .. "&size=150x150&format=Png&isCircular=false"
    elseif kind == "avatar" then
        api = "https://thumbnails.roblox.com/v1/users/avatar?userIds=" .. id .. "&size=420x420&format=Png&isCircular=false"
    elseif kind == "head" then
        api = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. id .. "&size=150x150&format=Png&isCircular=false"
    else
        return nil
    end

    local d = getJson(api)
    local e = d and d.data and d.data[1]
    if not (e and e.state == "Completed" and e.imageUrl) then return nil end
    local bin = httpGet(e.imageUrl)
    if not bin then return nil end

    local assetUrl
    pcall(function()
        if makefolder and isfolder and not isfolder("PV_cache") then makefolder("PV_cache") end
    end)
    local ok = pcall(function()
        local path = "PV_cache/" .. key .. ".png"
        writefile(path, bin)
        assetUrl = getcustomasset(path)
    end)
    if not ok or not assetUrl then
        pcall(function()
            local path = "PV_" .. key .. ".png"
            writefile(path, bin)
            assetUrl = getcustomasset(path)
        end)
    end
    if assetUrl then imgCache[key] = assetUrl end
    return assetUrl
end

local function smartImage(img, kind, id)
    local rbx
    if kind == "asset" then rbx = "rbxthumb://type=Asset&id=" .. id .. "&w=150&h=150"
    elseif kind == "avatar" then rbx = "rbxthumb://type=Avatar&id=" .. id .. "&w=420&h=420"
    elseif kind == "head" then rbx = "rbxthumb://type=AvatarHeadShot&id=" .. id .. "&w=150&h=150"
    else rbx = tostring(id) end

    local stamp = rbx .. "|" .. tostring(os.clock())
    img:SetAttribute("pvStamp", stamp)
    img.Image = rbx

    -- اعادة المحاولة بفواصل طويلة (4,5,7,10.. ثانية) عشان ما نقطع التحميل ونزحم الشبكة
    task.spawn(function()
        local waits = {4, 5, 7, 10, 14, 20, 28, 40}
        local attempts, httpUrl, triedHttp = 0, nil, false
        while alive and img.Parent do
            task.wait(waits[math.min(attempts + 1, #waits)])
            if img:GetAttribute("pvStamp") ~= stamp then return end
            if img.Image ~= "" and img.IsLoaded then return end
            if img.Visible then
                attempts = attempts + 1
                if attempts > 8 then return end
                -- بديل HTTPS: بس لصورة اللاعب الكبيرة، مرة وحدة، وعن طريق الحاكم
                if kind == "avatar" and attempts >= 2 and not triedHttp and Http.ready() then
                    triedHttp = true
                    httpUrl = httpThumb(kind, id)
                end
                local target = httpUrl or rbx
                img.Image = ""
                task.wait(0.05)
                if img:GetAttribute("pvStamp") ~= stamp then return end
                img.Image = target
            end
        end
    end)
end

-- ================= الواجهة الأساسية =================
local gui = Instance.new("ScreenGui")
gui.Name = "PlayersViewerUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if not pcall(function()
    gui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
end) or not gui.Parent then
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

_G.__PlayersViewerCleanup = function()
    alive = false
    for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
    if rotConn then pcall(function() rotConn:Disconnect() end) end
    pcall(function() gui:Destroy() end)
    _G.__PV_switchMode = nil
    _G.__PV_api = nil
end

local vs = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(800, 400)
local W = math.min(380, vs.X - 20)
local H = math.max(math.min(580, vs.Y - 56), 260)
local DEFAULT_POS = UDim2.new(0.5, 0, 0.5, -H / 2)

-- الجذر (مرتكز من منتصف الأعلى عشان التصغير والفتح من الايقونة يضبطون)
curTag = "window"
local root = new("Frame", {
    Name = "Root",
    AnchorPoint = Vector2.new(0.5, 0),
    Size = UDim2.fromOffset(W, H),
    Position = DEFAULT_POS,
    BackgroundTransparency = 1,
}, gui)
local rootScale = new("UIScale", {Scale = 0.92}, root)

-- ظل حقيقي حول الواجهة
setupShadow(root)

local main = new("Frame", {
    Name = "Main",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = C.white,
    BackgroundTransparency = 0.03,
    ClipsDescendants = true,
    ZIndex = 1,
}, root)
corner(main, 22)
windowGradient(main)

-- اطار الواجهة المتدرج المتحرك (فوق كل شي، ما يمنع اللمس)
glowFrame(root, 22, "window", {thick = 5, anim = true, speed = 55, base = 0.94, peak = 0.8, phase = 0, tag = "window", z = 19})
glowFrame(root, 22, "window", {thick = 1.8, anim = true, speed = 55, base = 0.78, peak = 0.0, phase = 0, tag = "window", z = 20})

-- ===== الهيدر =====
local header = new("Frame", {
    Size = UDim2.new(1, 0, 0, HEADER_H),
    BackgroundTransparency = 1,
    Active = true,
    ZIndex = 10,
}, main)

local closeDot = new("TextButton", {
    Size = UDim2.fromOffset(14, 14), Position = UDim2.new(0, 18, 0.5, -7),
    BackgroundColor3 = C.red, Text = "", AutoButtonColor = false,
}, header)
corner(closeDot, 7)
local minDot = new("TextButton", {
    Size = UDim2.fromOffset(14, 14), Position = UDim2.new(0, 40, 0.5, -7),
    BackgroundColor3 = C.yellow, Text = "", AutoButtonColor = false,
}, header)
corner(minDot, 7)

label(header, "اللاعبين", 17, C.white, true,
    UDim2.new(0, 68, 0, 0), UDim2.new(0, 120, 1, 0))

local gearBtn = new("TextButton", {
    Position = UDim2.new(1, -134, 0.5, -14),
    Size = UDim2.fromOffset(28, 28),
    BackgroundTransparency = 1,
    Text = "⚙",
    TextColor3 = C.gray,
    Font = FB,
    TextSize = 20,
}, header)

local countPill = new("TextLabel", {
    Size = UDim2.fromOffset(78, 26),
    Position = UDim2.new(1, -92, 0.5, -13),
    BackgroundColor3 = C.green,
    BackgroundTransparency = 0.8,
    Text = "0 / 0",
    TextColor3 = C.green,
    Font = FB,
    TextSize = 14,
}, header)
corner(countPill, 13)
local countScale = new("UIScale", {Scale = 1}, countPill)

-- خط تحت الهيدر (تدرج يمشي)
do
local sep = new("Frame", {
    Position = UDim2.new(0, 0, 0, HEADER_H),
    Size = UDim2.new(1, 0, 0, 2),
    BackgroundColor3 = C.white,
    BorderSizePixel = 0,
    ZIndex = 10,
}, main)
local sepGrad = new("UIGradient", {
    Transparency = NumberSequence.new({NSK(0, 1), NSK(0.5, 0.35), NSK(1, 1)}),
}, sep)
register("window", function(p)
    if not sepGrad.Parent then return false end
    sepGrad.Color = colorSeq(p)
    return true
end)
sepGrad.Offset = Vector2.new(-1, 0)
TweenService:Create(sepGrad,
    TweenInfo.new(2.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Offset = Vector2.new(1, 0)}):Play()
end

local capBg = new("Frame", {
    Position = UDim2.new(0, 16, 0, HEADER_H + 7),
    Size = UDim2.new(1, -32, 0, 4),
    BackgroundColor3 = C.card2,
    ZIndex = 10,
}, main)
corner(capBg, 2)
local capFill = new("Frame", {
    Size = UDim2.new(0, 0, 1, 0),
    BackgroundColor3 = C.green,
}, capBg)
corner(capFill, 2)

-- سحب النافذة (ترتفع شوي وقت السحب)
do
    local dragging, startIn, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startIn = input.Position
            startPos = root.Position
            if shadowImg then tw(shadowImg, 0.25, {ImageTransparency = 0}) end
            tw(rootScale, 0.25, {Scale = 1.02})
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if shadowImg then tw(shadowImg, 0.35, {ImageTransparency = 0.1}) end
                    tw(rootScale, 0.4, {Scale = 1}, Enum.EasingStyle.Back)
                end
            end)
        end
    end)
    track(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - startIn
            root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end))
end

-- ===== الجسم (قائمة اللاعبين) =====
curTag = "main"
local BODY_Y = HEADER_H + 16
local LIST_Y = 82
local body = new("Frame", {
    Position = UDim2.new(0, 0, 0, BODY_Y),
    Size = UDim2.new(1, 0, 1, -BODY_Y),
    BackgroundTransparency = 1,
}, main)

local searchBox = new("TextBox", {
    Position = UDim2.new(0, 14, 0, 4),
    Size = UDim2.new(1, -28 - 96, 0, 34),
    BackgroundColor3 = C.card2,
    BackgroundTransparency = 0.35,
    PlaceholderText = "بحث عن لاعب",
    PlaceholderColor3 = C.gray,
    Text = "",
    TextColor3 = C.white,
    Font = FM,
    TextSize = 14,
    ClearTextOnFocus = false,
    TextXAlignment = Enum.TextXAlignment.Left,
}, body)
corner(searchBox, 10)
new("UIPadding", {PaddingLeft = UDim.new(0, 34)}, searchBox)
label(body, "🔍", 14, C.gray, false,
    UDim2.new(0, 24, 0, 4), UDim2.new(0, 20, 0, 34), Enum.TextXAlignment.Center)

-- زر الترتيب
local sortBtn = tinted(body, "", "a", UDim2.new(1, -100, 0, 4), UDim2.fromOffset(86, 34), 12)
label(sortBtn, "ترتيب", 10, C.gray, false,
    UDim2.new(0, 0, 0, 3), UDim2.new(1, 0, 0, 13), Enum.TextXAlignment.Center)
local sortVal = label(sortBtn, "الدخول", 13, C.white, true,
    UDim2.new(0, 0, 0, 15), UDim2.new(1, 0, 0, 18), Enum.TextXAlignment.Center)

-- فلاتر
local filterMode, sortMode = "all", "join"
local applyFilter
do
    local FILTERS = {"all", "friends", "near"}
    segmented(body, UDim2.new(0, 14, 0, 44), UDim2.new(1, -28, 0, 30),
        {"الكل", "الأصدقاء", "قريب"}, function(i)
            filterMode = FILTERS[i]
            applyFilter()
        end)
end

local list = new("ScrollingFrame", {
    Position = UDim2.new(0, 14, 0, LIST_Y),
    Size = UDim2.new(1, -28, 1, -LIST_Y - 14),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = C.gray,
    ScrollBarImageTransparency = 0.4,
    ElasticBehavior = Enum.ElasticBehavior.Always,
    CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, body)
new("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, list)
new("UIPadding", {PaddingTop = UDim.new(0, 2), PaddingBottom = UDim.new(0, 2)}, list)

local emptyLbl = label(body, "ما في نتائج", 14, C.gray, true,
    UDim2.new(0, 14, 0, LIST_Y + 30), UDim2.new(1, -28, 0, 30), Enum.TextXAlignment.Center)
emptyLbl.Visible = false

do
    local topO = fadeOverlay(body, UDim2.new(0, 14, 0, LIST_Y), UDim2.new(1, -28, 0, 12),
        (BODY_Y + LIST_Y) / H, false, 3)
    local botO = fadeOverlay(body, UDim2.new(0, 14, 1, -14 - 26), UDim2.new(1, -28, 0, 26),
        (H - 14) / H, true, 3)
    bindFade(list, topO, botO)
end

-- ===== Toast =====
local toastLbl = new("TextLabel", {
    Size = UDim2.fromOffset(210, 34),
    Position = UDim2.new(0.5, -105, 1, 10),
    BackgroundColor3 = RGB(20, 20, 22),
    BackgroundTransparency = 0.1,
    TextColor3 = C.white,
    Font = FB,
    TextSize = 13,
    Text = "",
    ZIndex = 100,
}, main)
corner(toastLbl, 17)
new("UIStroke", {Color = C.white, Transparency = 0.85, Thickness = 1,
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, toastLbl)
local toastTok = 0
local function toast(text)
    toastTok = toastTok + 1
    local my = toastTok
    toastLbl.Text = text
    tw(toastLbl, 0.4, {Position = UDim2.new(0.5, -105, 1, -52)}, Enum.EasingStyle.Back)
    task.delay(1.7, function()
        if my == toastTok then tw(toastLbl, 0.3, {Position = UDim2.new(0.5, -105, 1, 10)}) end
    end)
end

local function doCopy(text, okMsg)
    if copy(text) then toast(okMsg or "✓ تم النسخ")
    else toast("الاكسكيوتر ما يدعم النسخ") end
end

-- ================= صفحات (تفاصيل / إعدادات) =================
local closeDetail, closeSettings -- تتعرف لاحقاً

local function makePage(z)
    local f = new("Frame", {
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(1, -2, 1, -2),
        BackgroundColor3 = C.white,
        BackgroundTransparency = 0.03,
        Visible = false,
        Active = true,
        ZIndex = z,
    }, main)
    corner(f, 21)
    windowGradient(f)
    local sc = new("UIScale", {Scale = 1}, f)
    return f, sc
end

local function backButton(parent, text, onClick)
    local b = new("TextButton", {
        Position = UDim2.new(0, 10, 0, BODY_Y),
        Size = UDim2.fromOffset(150, 34),
        BackgroundTransparency = 1,
        Text = "",
    }, parent)
    local ch = label(b, "‹", 28, C.blue, true,
        UDim2.new(0, 4, 0, -2), UDim2.new(0, 16, 1, 0), Enum.TextXAlignment.Center)
    local tx = label(b, text, 15, C.blue, true,
        UDim2.new(0, 24, 0, 0), UDim2.new(1, -24, 1, 0))
    register("window", function(p)
        if not b.Parent then return false end
        ch.TextColor3 = p.a
        tx.TextColor3 = p.a
        return true
    end)
    b.MouseButton1Click:Connect(onClick)
    return b
end

local function makeScroll(parent, y)
    local s = new("ScrollingFrame", {
        Position = UDim2.new(0, 14, 0, y),
        Size = UDim2.new(1, -28, 1, -y - 14),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.gray,
        ScrollBarImageTransparency = 0.4,
        ElasticBehavior = Enum.ElasticBehavior.Always,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, parent)
    new("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, s)
    new("UIPadding", {PaddingBottom = UDim.new(0, 6)}, s)
    return s
end

local SCROLL_Y = BODY_Y + 38

-- ----- صفحة التفاصيل -----
curTag = "detail"
local detail, detailScale = makePage(5)
backButton(detail, "اللاعبين", function() closeDetail() end) -- @skip
local detailScroll = makeScroll(detail, SCROLL_Y)

do
    local topO = fadeOverlay(detail, UDim2.new(0, 14, 0, SCROLL_Y), UDim2.new(1, -28, 0, 12),
        SCROLL_Y / H, false, 3)
    local botO = fadeOverlay(detail, UDim2.new(0, 14, 1, -14 - 28), UDim2.new(1, -28, 0, 28),
        (H - 14) / H, true, 3)
    bindFade(detailScroll, topO, botO)
end

-- ----- كرت البطل -----
local hero = new("Frame", {
    Size = UDim2.new(1, -4, 0, 222),
    BackgroundColor3 = C.white,
    LayoutOrder = 1,
}, detailScroll)
corner(hero, 18)
new("UIGradient", {
    Color = ColorSequence.new(RGB(60, 60, 66), RGB(42, 42, 46)),
    Rotation = 90,
}, hero)
glowFrame(hero, 18, "window", {thick = 1.5, anim = true, speed = 60, base = 0.85, peak = 0.12, tag = "detail", z = 4})

local previewBox = new("Frame", {
    Position = UDim2.fromOffset(10, 10),
    Size = UDim2.fromOffset(120, 202),
    BackgroundColor3 = RGB(24, 24, 28),
}, hero)
corner(previewBox, 14)

local vp = new("ViewportFrame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Ambient = RGB(190, 190, 190),
    LightColor = RGB(255, 255, 255),
    LightDirection = Vector3.new(-1, -1, -1),
    Visible = false,
}, previewBox)
corner(vp, 14)

local thumb = new("ImageLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ScaleType = Enum.ScaleType.Fit,
    Visible = true,
}, previewBox)
corner(thumb, 14)

local nameLbl = label(hero, "", 18, C.white, true,
    UDim2.new(0, 142, 0, 10), UDim2.new(1, -152, 0, 24))
local userLbl = label(hero, "", 13, C.gray, false,
    UDim2.new(0, 142, 0, 36), UDim2.new(1, -152, 0, 18))
local idLbl = label(hero, "", 11, C.gray, false,
    UDim2.new(0, 142, 0, 55), UDim2.new(1, -152, 0, 16))

local btnRow = new("Frame", {
    Position = UDim2.new(0, 142, 0, 78),
    Size = UDim2.new(1, -152, 0, 28),
    BackgroundTransparency = 1,
}, hero)
local btnCopyId   = tinted(btnRow, "نسخ ID", "a", UDim2.new(0, 0, 0, 0), UDim2.new(0.5, -3, 1, 0), 13)
local btnCopyUser = tinted(btnRow, "نسخ اليوزر", "a", UDim2.new(0.5, 3, 0, 0), UDim2.new(0.5, -3, 1, 0), 13)
local btnProfile  = tinted(hero, "نسخ رابط البروفايل", "b",
    UDim2.new(0, 142, 0, 112), UDim2.new(1, -152, 0, 28), 13)

local seg = segmented(hero, UDim2.new(0, 142, 0, 150), UDim2.new(1, -152, 0, 32),
    {"داخل الماب", "الحساب"}, function(i)
        if _G.__PV_switchMode then _G.__PV_switchMode(i == 1 and "map" or "account") end
    end)

local liveDot = new("Frame", {
    Position = UDim2.new(0, 144, 0, 197),
    Size = UDim2.fromOffset(8, 8),
    BackgroundColor3 = C.green,
}, hero)
corner(liveDot, 4)
TweenService:Create(liveDot,
    TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {BackgroundTransparency = 0.75}):Play()
label(hero, "تحديث تلقائي مباشر", 12, C.gray, false,
    UDim2.new(0, 158, 0, 192), UDim2.new(1, -168, 0, 18))

-- ----- الاحصائيات (HTTPS) -----
local chipVals = {}
do
local statsRow = new("Frame", {
    Size = UDim2.new(1, -4, 0, 56),
    BackgroundTransparency = 1,
    LayoutOrder = 2,
}, detailScroll)
local chipDefs = {
    {"friends", "الأصدقاء"}, {"followers", "المتابعين"},
    {"following", "يتابع"}, {"created", "انضم"},
}
for i, def in ipairs(chipDefs) do
    local chip = new("Frame", {
        Position = UDim2.new((i - 1) * 0.25, (i == 1) and 0 or 3, 0, 0),
        Size = UDim2.new(0.25, -3, 1, 0),
        BackgroundColor3 = C.card,
    }, statsRow)
    corner(chip, 14)
    glowFrame(chip, 14, "window", {thick = 1, anim = false, static = 0.8, z = 2})
    chipVals[def[1]] = label(chip, "—", def[1] == "created" and 12 or 16, C.white, true,
        UDim2.new(0, 2, 0, 8), UDim2.new(1, -4, 0, 22), Enum.TextXAlignment.Center)
    label(chip, def[2], 11, C.gray, false,
        UDim2.new(0, 2, 0, 32), UDim2.new(1, -4, 0, 16), Enum.TextXAlignment.Center)
end
end

-- ----- أزرار نسخ الكل -----
local btnAllIds, btnAllNames, btnAllLinks
do
    local allBtns = new("Frame", {
        Size = UDim2.new(1, -4, 0, 34),
        BackgroundTransparency = 1,
        LayoutOrder = 3,
    }, detailScroll)
    btnAllIds   = tinted(allBtns, "كل الـ IDs", "a", UDim2.new(0, 0, 0, 0), UDim2.new(1 / 3, -4, 1, 0), 13)
    btnAllNames = tinted(allBtns, "كل الأسماء", "a", UDim2.new(1 / 3, 2, 0, 0), UDim2.new(1 / 3, -4, 1, 0), 13)
    btnAllLinks = tinted(allBtns, "كل الروابط", "b", UDim2.new(2 / 3, 4, 0, 0), UDim2.new(1 / 3, -4, 1, 0), 13)
end

-- ----- عنوان قسم العناصر -----
local setSection
do
local secRow = new("Frame", {
    Size = UDim2.new(1, -4, 0, 26),
    BackgroundTransparency = 1,
    LayoutOrder = 4,
}, detailScroll)
label(secRow, "العناصر", 15, C.white, true,
    UDim2.new(0, 2, 0, 0), UDim2.new(0, 64, 1, 0))
local countBadge = new("TextLabel", {
    Position = UDim2.new(0, 70, 0.5, -10),
    Size = UDim2.fromOffset(34, 20),
    BackgroundColor3 = C.blue,
    BackgroundTransparency = 0.8,
    Text = "0",
    TextColor3 = C.blue,
    Font = FB,
    TextSize = 12,
}, secRow)
corner(countBadge, 10)
register("list", function(p)
    if not countBadge.Parent then return false end
    countBadge.TextColor3 = p.a
    countBadge.BackgroundColor3 = p.a
    return true
end)
local sourceLbl = label(secRow, "", 12, C.gray, false,
    UDim2.new(0, 110, 0, 0), UDim2.new(1, -110, 1, 0), Enum.TextXAlignment.Right)

setSection = function(count, src)
    countBadge.Text = count and tostring(count) or "…"
    sourceLbl.Text = src or ""
end
end

-- ----- صفحة الإعدادات (ألوان مخصصة) -----
curTag = "settings"
local settings, settingsScale = makePage(6)
backButton(settings, "الإعدادات", function() closeSettings() end) -- @skip
do
local setScroll = makeScroll(settings, SCROLL_Y)

local swatchRings = {window = {}, button = {}, list = {}}
local paletteNameLbls = {}

local function markSwatches(cat)
    for i, ring in ipairs(swatchRings[cat]) do
        tw(ring, 0.25, {Transparency = (i == themeIdx[cat]) and 0 or 1})
    end
    local nl = paletteNameLbls[cat]
    if nl then nl.Text = PALETTES[themeIdx[cat]].name end
end

local function setPalette(cat, i)
    if not PALETTES[i] then return end
    themeIdx[cat] = i
    theme[cat] = PALETTES[i]
    applyTheme(cat)
    if cat == "button" then LB.repaint() end
    markSwatches(cat)
    saveTheme()
end

local SWS = math.clamp(math.floor((W - 28 - 4 - 28 - 6 * 8) / 7), 26, 36)

local function paletteCard(order, title, cat)
    local card = new("Frame", {
        Size = UDim2.new(1, -4, 0, 100),
        BackgroundColor3 = C.card,
        LayoutOrder = order,
    }, setScroll)
    corner(card, 16)
    glowFrame(card, 16, cat, {thick = 1.4, anim = true, speed = 65, base = 0.85, peak = 0.15, tag = "settings", z = 2})
    label(card, title, 15, C.white, true,
        UDim2.new(0, 14, 0, 10), UDim2.new(0.5, 0, 0, 24))
    paletteNameLbls[cat] = label(card, "", 12, C.gray, false,
        UDim2.new(0.5, 0, 0, 10), UDim2.new(0.5, -14, 0, 24), Enum.TextXAlignment.Right)
    local rowF = new("Frame", {
        Position = UDim2.new(0, 14, 0, 46),
        Size = UDim2.new(1, -28, 0, SWS + 6),
        BackgroundTransparency = 1,
    }, card)
    new("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, rowF)
    for i, p in ipairs(PALETTES) do
        local sw = new("TextButton", {
            Size = UDim2.fromOffset(SWS, SWS),
            BackgroundColor3 = C.white,
            Text = "",
            AutoButtonColor = false,
            LayoutOrder = i,
        }, rowF)
        corner(sw, SWS / 2)
        new("UIGradient", {Color = colorSeq(p), Rotation = 45}, sw)
        local ring = new("UIStroke", {
            Color = C.white, Thickness = 2.5, Transparency = 1,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        }, sw)
        swatchRings[cat][i] = ring
        sw.MouseButton1Click:Connect(function() setPalette(cat, i) end)
    end
    markSwatches(cat)
    return card
end

paletteCard(1, "ألوان الواجهة", "window")
paletteCard(2, "ألوان الأزرار", "button")
paletteCard(3, "ألوان القوائم", "list")

-- مفاتيح (حركة التدرج / بيانات الانترنت)
local function switchCard(order, title, initial, onChange)
    local card = new("Frame", {
        Size = UDim2.new(1, -4, 0, 56),
        BackgroundColor3 = C.card,
        LayoutOrder = order,
    }, setScroll)
    corner(card, 16)
    label(card, title, 15, C.white, true,
        UDim2.new(0, 14, 0, 0), UDim2.new(0.7, 0, 1, 0))
    local state = initial
    local trk = new("TextButton", {
        Position = UDim2.new(1, -64, 0.5, -14),
        Size = UDim2.fromOffset(50, 28),
        BackgroundColor3 = state and C.green or C.card2,
        Text = "",
        AutoButtonColor = false,
    }, card)
    corner(trk, 14)
    local knob = new("Frame", {
        Size = UDim2.fromOffset(24, 24),
        Position = state and UDim2.new(1, -26, 0, 2) or UDim2.new(0, 2, 0, 2),
        BackgroundColor3 = C.white,
    }, trk)
    corner(knob, 12)
    trk.MouseButton1Click:Connect(function() -- @switch
        state = not state
        tw(trk, 0.25, {BackgroundColor3 = state and C.green or C.card2})
        tw(knob, 0.3, {Position = state and UDim2.new(1, -26, 0, 2) or UDim2.new(0, 2, 0, 2)},
            Enum.EasingStyle.Back)
        onChange(state)
    end)
end
switchCard(4, "حركة التدرج", animOn, function(v) animOn = v; saveTheme() end)
switchCard(5, "بيانات الانترنت (HTTPS)", httpEnabled, function(v) httpEnabled = v; saveTheme() end)

-- أزرار اعادة الضبط / اغلاق نهائي
local setBtns = new("Frame", {
    Size = UDim2.new(1, -4, 0, 38),
    BackgroundTransparency = 1,
    LayoutOrder = 6,
}, setScroll)
local btnReset = tinted(setBtns, "الألوان الافتراضية", "a",
    UDim2.new(0, 0, 0, 0), UDim2.new(0.5, -4, 1, 0), 13, {tag = "settings"})
btnReset.MouseButton1Click:Connect(function()
    for cat, i in pairs(DEFAULT_IDX) do setPalette(cat, i) end
    toast("✓ رجعت الألوان الافتراضية")
end)
local btnKill = tinted(setBtns, "إغلاق نهائي", C.red,
    UDim2.new(0.5, 4, 0, 0), UDim2.new(0.5, -4, 1, 0), 13, {tag = "settings"})
btnKill.MouseButton1Click:Connect(function() -- @skip
    if _G.__PlayersViewerCleanup then _G.__PlayersViewerCleanup() end
end)
end

-- ================= الايقونة العائمة (تفتح/تسكر الواجهة) =================
curTag = "launcher"
local launcher, lScale, setLauncherCount, hideWindow, showWindow, toggleWindow, resetToList
do
local LS = 58
launcher = new("Frame", {
    Name = "Launcher",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromOffset(46, 118),
    Size = UDim2.fromOffset(LS, LS),
    BackgroundTransparency = 1,
    ZIndex = 50,
}, gui)
lScale = new("UIScale", {Scale = 0.01}, launcher)

makeBloom(launcher, LS, 7, 4, 20)

local function silverBorder(parent, thick, speed, base, peak, phase)
    local st = new("UIStroke", {
        Color = C.white, Thickness = thick, Transparency = 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, parent)
    local g = new("UIGradient", {Color = SILVER, Transparency = alphaSeq(base, peak)}, st)
    addAnim(g, speed, phase, "launcher")
    return st, g
end

local ringOuter = new("Frame", {
    Position = UDim2.new(0, -5, 0, -5), Size = UDim2.new(1, 10, 1, 10),
    BackgroundTransparency = 1, ZIndex = 1,
}, launcher)
corner(ringOuter, 25)
silverBorder(ringOuter, 2.5, 120, 0.7, 0, 0)

local ringInner = new("Frame", {
    Position = UDim2.new(0, -2, 0, -2), Size = UDim2.new(1, 4, 1, 4),
    BackgroundTransparency = 1, ZIndex = 1,
}, launcher)
corner(ringInner, 22)
silverBorder(ringInner, 1.5, -75, 0.78, 0.05, 90)

local lBody = new("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = C.white,
    ZIndex = 2,
}, launcher)
corner(lBody, 20)
do
    local lg = new("UIGradient", {Rotation = 90}, lBody)
    register("window", function(p)
        if not lg.Parent then return false end
        local top, bot = windowColors(p, 0.16, 0.09)
        lg.Color = ColorSequence.new(top, bot)
        return true
    end)
end

local lHl = new("Frame", {
    Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 3,
}, launcher)
corner(lHl, 20)
do
    local st = new("UIStroke", {
        Color = C.white, Thickness = 1, Transparency = 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, lHl)
    new("UIGradient", {
        Transparency = NumberSequence.new({NSK(0, 0.35), NSK(0.5, 0.8), NSK(1, 0.9)}),
        Rotation = 90,
    }, st)
end

-- لمعة تمر على الايقونة
local shineClip = new("CanvasGroup", {
    Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 3,
}, launcher)
corner(shineClip, 20)
local band = new("Frame", {
    Position = UDim2.new(-0.6, 0, -0.3, 0),
    Size = UDim2.new(0.35, 0, 1.6, 0),
    Rotation = 20,
    BackgroundColor3 = C.white,
    BorderSizePixel = 0,
}, shineClip)
new("UIGradient", {
    Transparency = NumberSequence.new({NSK(0, 1), NSK(0.5, 0.45), NSK(1, 1)}),
}, band)
TweenService:Create(band,
    TweenInfo.new(1.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, false, 2.0),
    {Position = UDim2.new(1.2, 0, -0.3, 0)}):Play()

new("TextLabel", {
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 1, 0),
    Text = "👥",
    TextSize = 26,
    Font = FB,
    TextColor3 = C.white,
    ZIndex = 4,
}, launcher)

local lBadge = new("TextLabel", {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, 4, 0, -5),
    Size = UDim2.fromOffset(26, 20),
    BackgroundColor3 = C.blue,
    Text = "0",
    TextColor3 = C.white,
    Font = FB,
    TextSize = 12,
    ZIndex = 6,
}, launcher)
corner(lBadge, 10)
register("window", function(p)
    if not lBadge.Parent then return false end
    lBadge.BackgroundColor3 = p.a
    return true
end)

setLauncherCount = function(n)
    lBadge.Text = tostring(n)
end

local lHit = new("TextButton", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "",
    ZIndex = 7,
}, launcher)

-- فتح / اغلاق الواجهة (تنزل داخل الايقونة وتطلع منها)
hideWindow = function()
    if not windowOpen then return end
    windowOpen = false
    winToken = winToken + 1
    local my = winToken
    savedPos = root.Position
    tw(rootScale, 0.38, {Scale = 0.06}, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    tw(root, 0.38, {Position = launcher.Position}, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    task.delay(0.4, function()
        if winToken == my and not windowOpen then
            root.Visible = false
            resetToList() -- لما ترجع تفتح الواجهة تلقاها على قائمة اللاعبين
        end
    end)
end

showWindow = function()
    if windowOpen then return end
    windowOpen = true
    winToken = winToken + 1
    root.Position = launcher.Position
    rootScale.Scale = 0.06
    root.Visible = true
    tw(rootScale, 0.5, {Scale = 1}, Enum.EasingStyle.Back)
    tw(root, 0.45, {Position = savedPos or DEFAULT_POS})
end

toggleWindow = function()
    if windowOpen then hideWindow() else showWindow() end
end

-- سحب الايقونة (وضغطة قصيرة = فتح/اغلاق)
do
    local dragging, moved, startIn, startPos
    lHit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            startIn = input.Position
            startPos = launcher.Position
            tw(lScale, 0.12, {Scale = 0.92})
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    tw(lScale, 0.4, {Scale = 1}, Enum.EasingStyle.Back)
                    if not moved then toggleWindow() end
                end
            end)
        end
    end)
    track(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - startIn
            if d.Magnitude > 8 then moved = true end
            if moved then
                local nx = math.clamp(startPos.X.Offset + d.X, LS / 2, vs.X - LS / 2)
                local ny = math.clamp(startPos.Y.Offset + d.Y, LS / 2, vs.Y - LS / 2)
                launcher.Position = UDim2.fromOffset(nx, ny)
            end
        end
    end))
end

tw(lScale, 0.7, {Scale = 1}, Enum.EasingStyle.Back)
end

-- ================= جلب العناصر =================
local TYPE_PROPS = {"Shirt", "Pants", "GraphicTShirt", "Face", "Head", "Torso",
    "LeftArm", "RightArm", "LeftLeg", "RightLeg"}
local ANIM_PROPS = {"IdleAnimation", "WalkAnimation", "RunAnimation", "JumpAnimation",
    "FallAnimation", "ClimbAnimation", "SwimAnimation"}

local function numFrom(s)
    return tonumber(tostring(s or ""):match("%d+"))
end

local nameById = {}

local function collectMap(plr)
    local items = {}
    local char = plr.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local gotAccessory = false

    if hum then
        local ok, desc = pcall(function() return hum:GetAppliedDescription() end)
        if ok and desc then
            local okA, accs = pcall(function() return desc:GetAccessories(true) end)
            if okA and accs then
                for _, a in ipairs(accs) do
                    if a.AssetId and a.AssetId > 0 then
                        gotAccessory = true
                        items[#items + 1] = {
                            id = a.AssetId,
                            type = (tostring(a.AccessoryType):gsub("Enum.AccessoryType.", "")),
                        }
                    end
                end
            end
            for _, p in ipairs(TYPE_PROPS) do
                local okP, v = pcall(function() return desc[p] end)
                if okP and type(v) == "number" and v > 0 then
                    items[#items + 1] = {id = v, type = p}
                end
            end
            for _, p in ipairs(ANIM_PROPS) do
                local okP, v = pcall(function() return desc[p] end)
                if okP and type(v) == "number" and v > 0 then
                    items[#items + 1] = {id = v, type = p}
                end
            end
            pcall(function() desc:Destroy() end)
        end
    end

    if char and not gotAccessory then
        for _, acc in ipairs(char:GetChildren()) do
            if acc:IsA("Accessory") then
                local h = acc:FindFirstChild("Handle")
                local meshId
                if h then
                    local sm = h:FindFirstChildOfClass("SpecialMesh")
                    if sm then meshId = sm.MeshId
                    elseif h:IsA("MeshPart") then meshId = h.MeshId end
                end
                items[#items + 1] = {
                    id = numFrom(meshId), name = acc.Name,
                    type = "Accessory (Mesh ID)", noResolve = true,
                }
            end
        end
    end

    local function addTool(t)
        local tex = tostring(t.TextureId or "")
        items[#items + 1] = {
            id = numFrom(tex), name = t.Name, type = "Tool (Texture ID)",
            noResolve = true, image = (tex ~= "" and tex) or nil,
        }
    end
    if char then
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") then addTool(t) end
        end
    end
    local bp = plr:FindFirstChildOfClass("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then addTool(t) end
        end
    end
    return items
end

local function rawSig(plr)
    local char = plr.Character
    if not char then return "none" end
    local t = {}
    for _, c in ipairs(char:GetChildren()) do
        if c:IsA("Accessory") or c:IsA("Tool") then t[#t + 1] = c.Name
        elseif c:IsA("Shirt") then t[#t + 1] = "S" .. c.ShirtTemplate
        elseif c:IsA("Pants") then t[#t + 1] = "P" .. c.PantsTemplate
        elseif c:IsA("ShirtGraphic") then t[#t + 1] = "G" .. c.Graphic end
    end
    local head = char:FindFirstChild("Head")
    local face = head and head:FindFirstChildOfClass("Decal")
    if face then t[#t + 1] = "F" .. face.Texture end
    local bp = plr:FindFirstChildOfClass("Backpack")
    if bp then
        for _, c in ipairs(bp:GetChildren()) do t[#t + 1] = "B" .. c.Name end
    end
    table.sort(t)
    return table.concat(t, "|")
end

local accCache, accFail = {}, {}
local function collectAccountCached(userId)
    local e = accCache[userId]
    if not (e and os.clock() - e.t < 60) then
        local f = accFail[userId]
        if f and os.clock() - f < 8 then return {} end

        local items = {}
        local assets
        local ok, info = pcall(function() return Players:GetCharacterAppearanceInfoAsync(userId) end)
        if ok and info and info.assets then assets = info.assets end
        if not assets then
            local d = getJson("https://avatar.roblox.com/v1/users/" .. userId .. "/avatar")
            if d then assets = d.assets end
        end
        if assets then
            for _, a in ipairs(assets) do
                items[#items + 1] = {
                    id = a.id, name = a.name,
                    type = (a.assetType and a.assetType.name) or "Asset",
                }
                if a.id and a.name then nameById[a.id] = a.name end
            end
        end
        if #items == 0 then
            accFail[userId] = os.clock()
            return {}
        end
        e = {t = os.clock(), items = items}
        accCache[userId] = e
    end
    local copyList = {}
    for _, it in ipairs(e.items) do
        copyList[#copyList + 1] = {id = it.id, name = it.name, type = it.type}
    end
    return copyList
end

local infoCache = {}
local function getInfo(id)
    if infoCache[id] then return infoCache[id] end

    local info
    local finished = false
    task.spawn(function()
        local ok, r = pcall(function()
            return MarketplaceService:GetProductInfo(id, Enum.InfoType.Asset)
        end)
        if ok and type(r) == "table" and r.Name then info = r end
        finished = true
    end)
    local t0 = os.clock()
    while not finished and os.clock() - t0 < 8 do task.wait(0.05) end

    -- الانترنت بس اذا GetProductInfo فشل (مو لكل عنصر)
    if not info and finished and Http.ready() then
        local d = getJson("https://economy.roblox.com/v2/assets/" .. id .. "/details")
        if d and d.Name then info = d end
    end

    if not info then
        if nameById[id] then
            return {name = nameById[id], creator = "?", price = "—", partial = true}
        end
        return nil
    end

    local price
    if info.IsLimited or info.IsLimitedUnique then price = "Limited"
    elseif type(info.PriceInRobux) == "number" and info.PriceInRobux > 0 then price = "R$ " .. info.PriceInRobux
    elseif info.PriceInRobux == 0 or info.IsPublicDomain then price = "مجاني"
    else price = "غير معروض" end

    local res = {
        name = info.Name,
        creator = (info.Creator and info.Creator.Name) or "?",
        price = price,
    }
    infoCache[id] = res
    return res
end

local statsCache = {}
local function fetchStats(uid)
    if statsCache[uid] then return statsCache[uid] end
    local s = {}
    local d = getJson("https://friends.roblox.com/v1/users/" .. uid .. "/friends/count")
    s.friends = d and d.count
    d = getJson("https://friends.roblox.com/v1/users/" .. uid .. "/followers/count")
    s.followers = d and d.count
    d = getJson("https://friends.roblox.com/v1/users/" .. uid .. "/followings/count")
    s.following = d and d.count
    d = getJson("https://users.roblox.com/v1/users/" .. uid)
    if d and d.created then s.created = tostring(d.created):sub(1, 10) end
    if s.friends or s.followers or s.created then
        statsCache[uid] = s
        return s
    end
    return nil
end

-- ================= المعاينة (داخل الماب) =================
local VP = {angle = 0}

local function clearPreview()
    if rotConn then rotConn:Disconnect() rotConn = nil end
    vp:ClearAllChildren()
    vp.CurrentCamera = nil
    vp.Visible = false
    VP.clone, VP.cam = nil, nil
    thumb.Visible = true
end

local function updateViewport(char)
    local ok = pcall(function()
        char.Archivable = true
        local clone = char:Clone()
        if not clone then error("no clone") end
        for _, d in ipairs(clone:GetDescendants()) do
            if d:IsA("BaseScript") or d:IsA("Sound") or d:IsA("BillboardGui") then d:Destroy() end
        end
        local hum = clone:FindFirstChildOfClass("Humanoid")
        if hum then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
        if not clone:FindFirstChild("HumanoidRootPart") then error("no hrp") end

        clone.Parent = vp
        clone:PivotTo(CFrame.new(0, 0, 0))
        if VP.clone then VP.clone:Destroy() end
        VP.clone = clone

        if not VP.cam then
            VP.cam = Instance.new("Camera")
            VP.cam.FieldOfView = 35
            VP.cam.Parent = vp
            vp.CurrentCamera = VP.cam
        end
        local cf, size = clone:GetBoundingBox()
        VP.center = cf.Position
        VP.dist = (size.Y / 2) / math.tan(math.rad(VP.cam.FieldOfView / 2)) + size.Z / 2 + 1.5

        if not rotConn then
            rotConn = RunService.RenderStepped:Connect(function(dt)
                if not windowOpen or not VP.cam or not VP.center then return end
                VP.angle = VP.angle + dt * 0.9
                local pos = VP.center + (CFrame.Angles(0, VP.angle, 0) * Vector3.new(0, 0, -VP.dist))
                VP.cam.CFrame = CFrame.lookAt(pos, VP.center)
            end)
        end
    end)
    return ok
end

-- ================= صفوف العناصر =================
local currentPlayer, currentMode = nil, "map"
local currentItems = {}
local itemRows = {}
local token = 0
local busy = false
local lastSig, lastChar = nil, nil

local function itemKey(item)
    return tostring(item.type) .. "|" .. tostring(item.id or item.name)
end

local function applyInfo(item, info)
    if not (item.row and item.row.Parent) then return end
    if not item.name then item.name = info.name end
    if item.nameLabel then item.nameLabel.Text = item.name end
    dropSkel(item, "skelName")
    if not info.partial then
        item.info = info
        if item.metaLabel then
            item.metaLabel.Text = "👤 " .. info.creator .. "  •  " .. info.price
        end
        dropSkel(item, "skelMeta")
    end
end

local function fillNames()
    for _, e in pairs(itemRows) do
        local it = e.item
        if it.id and not it.name and nameById[it.id] then
            it.name = nameById[it.id]
            if it.nameLabel then it.nameLabel.Text = it.name end
            dropSkel(it, "skelName")
        end
    end
end

local queueInfo
do
local infoQueue = {}
queueInfo = function(item) infoQueue[#infoQueue + 1] = item end

local function failItem(item)
    if not (item.row and item.row.Parent) then return end
    if not item.name then
        item.name = "Item " .. tostring(item.id)
        if item.nameLabel then item.nameLabel.Text = item.name end
    end
    if item.metaLabel then item.metaLabel.Text = "—" end
    dropSkel(item, "skelName")
    dropSkel(item, "skelMeta")
end

local function infoWorker()
    while alive do
        local item = table.remove(infoQueue, 1)
        if item then
            if item.row and item.row.Parent and not item.info then
                local info = getInfo(item.id)
                if info then
                    applyInfo(item, info)
                    if info.partial then
                        item.tries = (item.tries or 0) + 1
                        if item.tries < 3 then
                            task.delay(4, function() queueInfo(item) end)
                        else
                            failItem(item)
                        end
                    end
                else
                    item.tries = (item.tries or 0) + 1
                    if item.tries < 4 then
                        task.delay(3, function() queueInfo(item) end)
                    else
                        failItem(item)
                    end
                end
            end
            task.wait(0.03)
        else
            task.wait(0.2)
        end
    end
end
for _ = 1, 4 do task.spawn(infoWorker) end
end

local queueBuild
do
    local buildQ, buildBusy = {}, false
    queueBuild = function(job)
        buildQ[#buildQ + 1] = job
        if buildBusy then return end
        buildBusy = true
        task.spawn(function()
            while alive and #buildQ > 0 do
                for _ = 1, 3 do
                    local j = table.remove(buildQ, 1)
                    if not j then break end
                    pcall(j)
                end
                task.wait()
            end
            buildBusy = false
        end)
    end
end

local function addItemRow(item, entry, delay)
    if not item.name and item.id and nameById[item.id] then item.name = nameById[item.id] end

    local slot, _, row, _, stroke = makeCard(detailScroll, 82, 14, entry.order, delay, "detail")

    local ic = new("ImageLabel", {
        Size = UDim2.fromOffset(56, 56),
        Position = UDim2.new(0, 10, 0.5, -28),
        BackgroundColor3 = C.card2,
        ScaleType = Enum.ScaleType.Fit,
    }, row)
    corner(ic, 12)
    if item.image then
        smartImage(ic, "url", item.image)
    elseif item.id and not item.noResolve then
        smartImage(ic, "asset", item.id)
    else
        label(ic, "🧩", 22, C.white, false,
            UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0), Enum.TextXAlignment.Center)
    end

    item.nameLabel = label(row, item.name or "", 13, C.white, true,
        UDim2.new(0, 76, 0, 9), UDim2.new(1, -76 - 76, 0, 18))
    label(row, tostring(item.type) .. (item.id and ("  •  " .. item.id) or ""), 11, C.gray, false,
        UDim2.new(0, 76, 0, 29), UDim2.new(1, -76 - 76, 0, 16))
    item.metaLabel = label(row, item.noResolve and "من اللعبة" or "", 12, C.gray, false,
        UDim2.new(0, 76, 0, 48), UDim2.new(1, -76 - 76, 0, 18))
    item.row = row

    if not item.name then
        item.skelName = skeleton(row, UDim2.new(0, 76, 0, 12), UDim2.fromOffset(120, 12))
    end
    if not item.noResolve then
        item.skelMeta = skeleton(row, UDim2.new(0, 76, 0, 52), UDim2.fromOffset(90, 10))
    end

    if item.id then
        local b1 = LB.new(row, "ID", "a", UDim2.new(1, -68, 0, 7), UDim2.fromOffset(60, 22), 12)
        b1.MouseButton1Click:Connect(function() doCopy(item.id, "✓ تم نسخ ID") end)
    end
    local b2 = LB.new(row, "الاسم", "a", UDim2.new(1, -68, 0, 30), UDim2.fromOffset(60, 22), 13)
    b2.MouseButton1Click:Connect(function()
        doCopy(item.name or tostring(item.id or ""), "✓ تم نسخ الاسم")
    end)
    if item.id and not item.noResolve then
        local b3 = LB.new(row, "رابط", "b", UDim2.new(1, -68, 0, 53), UDim2.fromOffset(60, 22), 13)
        b3.MouseButton1Click:Connect(function()
            doCopy("https://www.roblox.com/catalog/" .. item.id, "✓ تم نسخ الرابط")
        end)
    end

    entry.row, entry.rowFrame, entry.stroke, entry.pending = slot, row, stroke, nil
    if item.id and not item.noResolve then queueInfo(item) end
end

local function removeRow(entry)
    local s = entry.row
    if not s then return end
    s.ClipsDescendants = true
    tw(entry.rowFrame, 0.25, {BackgroundTransparency = 1})
    tw(entry.stroke, 0.2, {Transparency = 1})
    tw(s, 0.25, {Size = UDim2.new(1, -4, 0, 0)})
    task.delay(0.27, function() pcall(function() s:Destroy() end) end)
end

local function clearRows()
    for _, e in pairs(itemRows) do
        e.cancel = true
        if e.row then pcall(function() e.row:Destroy() end) end
    end
    itemRows = {}
    currentItems = {}
end

local function syncItems(newList, source)
    local seen, final = {}, {}
    for i, item in ipairs(newList) do
        local base = itemKey(item)
        local key, n = base, 1
        while seen[key] do
            n = n + 1
            key = base .. "#" .. n
        end
        seen[key] = true
        local e = itemRows[key]
        if e then
            e.order = 10 + i
            if e.row then e.row.LayoutOrder = e.order end
            final[#final + 1] = e.item
        else
            local entry = {item = item, pending = true, order = 10 + i}
            itemRows[key] = entry
            local myToken = token
            queueBuild(function()
                if myToken ~= token or entry.cancel or itemRows[key] ~= entry then return end
                addItemRow(item, entry, 0)
            end)
            final[#final + 1] = item
        end
    end
    for key, e in pairs(itemRows) do
        if not seen[key] then
            itemRows[key] = nil
            if e.pending then e.cancel = true else removeRow(e) end
        end
    end
    currentItems = final
    setSection(#final, source)
    fillNames()
end

local function refreshItems()
    if busy or not currentPlayer then return end
    busy = true
    pcall(function()
        local plr, mode, my = currentPlayer, currentMode, token
        local items, source
        if mode == "map" then
            items = collectMap(plr)
            source = "داخل الماب"
            if #items == 0 then
                items = collectAccountCached(plr.UserId)
                source = "الحساب (ما في شي داخل الماب)"
            end
        else
            items = collectAccountCached(plr.UserId)
            source = "الحساب"
        end
        if my ~= token or plr ~= currentPlayer then return end

        local keys = {}
        for _, it in ipairs(items) do keys[#keys + 1] = itemKey(it) end
        table.sort(keys)
        local char = plr.Character
        local sig = ((mode == "map") and rawSig(plr) or "acc") .. "#" .. table.concat(keys, ",")
        if sig == lastSig and (mode ~= "map" or char == lastChar) then return end
        lastSig, lastChar = sig, char

        syncItems(items, source)

        if mode == "map" and char and updateViewport(char) then
            vp.Visible = true
            thumb.Visible = false
        end
    end)
    busy = false
end

-- ================= فتح / اغلاق الصفحات =================
local function loadStats(plr)
    for _, l in pairs(chipVals) do l.Text = "…" end
    task.spawn(function()
        task.wait(1.2) -- ما نطلب الانترنت الا بعد ما تفتح الصفحة وتستقر
        local s
        if currentPlayer == plr and Http.ready() then s = fetchStats(plr.UserId) end
        if currentPlayer ~= plr then return end
        if s then
            chipVals.friends.Text = fmtNum(s.friends)
            chipVals.followers.Text = fmtNum(s.followers)
            chipVals.following.Text = fmtNum(s.following)
            chipVals.created.Text = s.created or "—"
        else
            for _, l in pairs(chipVals) do l.Text = "—" end
        end
    end)
end

local function openDetail(plr)
    token = token + 1
    currentPlayer, currentMode = plr, "map"
    lastSig, lastChar = nil, nil
    clearRows()
    clearPreview()
    nameLbl.Text = plr.DisplayName
    userLbl.Text = "@" .. plr.Name
    idLbl.Text = "ID: " .. plr.UserId
    seg.set(1, false)
    thumb.Image = ""
    smartImage(thumb, "avatar", plr.UserId)
    loadStats(plr)
    setSection(nil, "جاري التحميل")
    detailScroll.CanvasPosition = Vector2.new(0, 0)

    detailScale.Scale = 0.94
    detail.Visible = true
    tw(detailScale, 0.4, {Scale = 1}, Enum.EasingStyle.Back)

    task.spawn(refreshItems)
    task.spawn(function()
        collectAccountCached(plr.UserId)
        if alive and currentPlayer == plr then fillNames() end
    end)
end

closeDetail = function()
    token = token + 1
    currentPlayer = nil
    tw(detailScale, 0.22, {Scale = 0.94})
    task.delay(0.24, function()
        if not currentPlayer then
            detail.Visible = false
            clearPreview()
            clearRows()
        end
    end)
end

local settingsOpen = false
local function openSettings()
    settingsOpen = true
    settingsScale.Scale = 0.94
    settings.Visible = true
    tw(settingsScale, 0.4, {Scale = 1}, Enum.EasingStyle.Back)
end

closeSettings = function()
    settingsOpen = false
    tw(settingsScale, 0.22, {Scale = 0.94})
    task.delay(0.24, function()
        if not settingsOpen then settings.Visible = false end
    end)
end

resetToList = function()
    token = token + 1
    currentPlayer = nil
    settingsOpen = false
    detail.Visible = false
    settings.Visible = false
    clearPreview()
    clearRows()
end

gearBtn.MouseButton1Click:Connect(function()
    if settingsOpen then closeSettings() else openSettings() end
end)

local function switchMode(mode)
    if not currentPlayer or mode == currentMode then return end
    token = token + 1
    currentMode = mode
    lastSig, lastChar = nil, nil
    clearRows()
    setSection(nil, "جاري التحميل")
    if mode == "account" then
        if rotConn then rotConn:Disconnect() rotConn = nil end
        vp.Visible = false
        thumb.Visible = true
    end
    task.spawn(refreshItems)
end
_G.__PV_switchMode = switchMode
_G.__PV_api = {
    show = showWindow, hide = hideWindow, toggle = toggleWindow,
    current = function() return currentPlayer and currentPlayer.Name or nil end,
    isOpen = function() return windowOpen end,
    detailVisible = function() return detail.Visible end,
}

btnCopyId.MouseButton1Click:Connect(function()
    if currentPlayer then doCopy(currentPlayer.UserId, "✓ تم نسخ ID اللاعب") end
end)
btnCopyUser.MouseButton1Click:Connect(function()
    if currentPlayer then doCopy(currentPlayer.Name, "✓ تم نسخ اليوزر") end
end)
btnProfile.MouseButton1Click:Connect(function()
    if currentPlayer then
        doCopy("https://www.roblox.com/users/" .. currentPlayer.UserId .. "/profile", "✓ تم نسخ رابط البروفايل")
    end
end)
btnAllIds.MouseButton1Click:Connect(function()
    local t = {}
    for _, it in ipairs(currentItems) do
        if it.id then t[#t + 1] = tostring(it.id) end
    end
    if #t == 0 then toast("ما في IDs") return end
    doCopy(table.concat(t, "\n"), "✓ تم نسخ كل الـ IDs")
end)
btnAllNames.MouseButton1Click:Connect(function()
    local t = {}
    for _, it in ipairs(currentItems) do
        t[#t + 1] = it.name or tostring(it.id or "?")
    end
    if #t == 0 then toast("ما في أسماء") return end
    doCopy(table.concat(t, "\n"), "✓ تم نسخ كل الأسماء")
end)
btnAllLinks.MouseButton1Click:Connect(function()
    local t = {}
    for _, it in ipairs(currentItems) do
        if it.id and not it.noResolve then
            t[#t + 1] = "https://www.roblox.com/catalog/" .. it.id
        end
    end
    if #t == 0 then toast("ما في روابط") return end
    doCopy(table.concat(t, "\n"), "✓ تم نسخ كل الروابط")
end)

-- حلقة التحديث التلقائي الصامت (ما تشتغل والواجهة مخفية)
task.spawn(function()
    local lastAcc, tickN = 0, 0
    while alive do
        task.wait(1)
        tickN = tickN + 1
        local plr = currentPlayer
        if plr and windowOpen and detail.Visible and plr.Parent then
            if currentMode == "map" then
                if tickN % 2 == 0 then refreshItems() end
            elseif #currentItems == 0 and (lastSig == nil or os.clock() - lastAcc > 4) then
                lastAcc = os.clock()
                refreshItems()
            end
        end
    end
end)

-- ================= قائمة اللاعبين (ترتيب + فلترة + مسافة) =================
local rows = {}
local rowParts = {}
if _G.__PV_api then
    _G.__PV_api.rowCount = function()
        local n = 0
        for _ in pairs(rows) do n = n + 1 end
        return n
    end
end
local joinCounter = 0
local joinIdx, dists, distLbls, tagLbls, friendCache = {}, {}, {}, {}, {}

local function distOf(plr)
    return dists[plr] or math.huge
end

local function reorder()
    local arr = {}
    for plr in pairs(rows) do arr[#arr + 1] = plr end
    table.sort(arr, function(a, b)
        if a == LocalPlayer then return b ~= LocalPlayer end
        if b == LocalPlayer then return false end
        if sortMode == "name" then
            local an, bn = a.DisplayName:lower(), b.DisplayName:lower()
            if an ~= bn then return an < bn end
        elseif sortMode == "dist" then
            local ad, bd = distOf(a), distOf(b)
            if ad ~= bd then return ad < bd end
        end
        return (joinIdx[a] or 0) < (joinIdx[b] or 0)
    end)
    for i, plr in ipairs(arr) do rows[plr].LayoutOrder = i end
end

applyFilter = function()
    local q = searchBox.Text:lower()
    local shown = 0
    for plr, row in pairs(rows) do
        local ok = (q == "")
            or (plr.Name:lower():find(q, 1, true) ~= nil)
            or (plr.DisplayName:lower():find(q, 1, true) ~= nil)
        if ok and filterMode == "friends" then
            ok = (friendCache[plr.UserId] == true)
        end
        if ok and filterMode == "near" then
            local d = dists[plr]
            ok = (plr == LocalPlayer) or (d ~= nil and d <= NEAR_STUDS)
        end
        row.Visible = ok
        if ok then shown = shown + 1 end
    end
    emptyLbl.Visible = (shown == 0)
end
track(searchBox:GetPropertyChangedSignal("Text"):Connect(applyFilter))

do
local SORTS = {{"join", "الدخول"}, {"name", "أبجدي"}, {"dist", "المسافة"}}
local sortIdx = 1
sortBtn.MouseButton1Click:Connect(function() -- @sort
    sortIdx = sortIdx % #SORTS + 1
    sortMode = SORTS[sortIdx][1]
    sortVal.Text = SORTS[sortIdx][2]
    reorder()
end)
end

local lastCountText = ""
local function updateCount(exclude)
    local n = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= exclude then n = n + 1 end
    end
    local max = Players.MaxPlayers
    local text = n .. " / " .. max
    countPill.Text = text
    setLauncherCount(n)
    if text ~= lastCountText then
        lastCountText = text
        countScale.Scale = 1.18
        tw(countScale, 0.45, {Scale = 1}, Enum.EasingStyle.Back)
    end
    local ratio = math.clamp(n / math.max(max, 1), 0, 1)
    local col = (ratio < 0.7 and C.green) or (ratio < 0.9 and C.orange) or C.red
    tw(capFill, 0.5, {Size = UDim2.new(ratio, 0, 1, 0), BackgroundColor3 = col})
    countPill.TextColor3 = col
    countPill.BackgroundColor3 = col
end

local function updateTag(plr)
    local tag = tagLbls[plr]
    if not tag then return end
    if plr == LocalPlayer then
        tag.Text = "أنت"
        tag.TextColor3 = C.green
        tag.BackgroundColor3 = C.green
        tag.Visible = true
    elseif friendCache[plr.UserId] == true then
        tag.Text = "صديق"
        tag.TextColor3 = C.blue
        tag.BackgroundColor3 = C.blue
        tag.Visible = true
    else
        tag.Visible = false
    end
end

local function resolveFriend(plr)
    if plr == LocalPlayer then return end
    task.spawn(function()
        local ok, r = pcall(function() return LocalPlayer:IsFriendsWith(plr.UserId) end)
        if ok then friendCache[plr.UserId] = (r == true) end
        if alive and rows[plr] then
            updateTag(plr)
            applyFilter()
        end
    end)
end

local queued = {}
local function buildPlayerRow(plr)
    joinCounter = joinCounter + 1
    joinIdx[plr] = joinCounter

    local slot, _, row, rs, stroke = makeCard(list, 62, 16, joinCounter, 0, "main")

    local isMe = (plr == LocalPlayer)
    local av = new("ImageLabel", {
        Size = UDim2.fromOffset(46, 46),
        Position = UDim2.new(0, 10, 0.5, -23),
        BackgroundColor3 = C.card2,
    }, row)
    corner(av, 23)
    new("UIStroke", {
        Color = isMe and C.green or C.white,
        Transparency = isMe and 0.15 or 0.85,
        Thickness = isMe and 2 or 1,
    }, av)
    smartImage(av, "head", plr.UserId)

    label(row, plr.DisplayName, 15, C.white, true,
        UDim2.new(0, 68, 0, 11), UDim2.new(1, -68 - 90, 0, 20))
    label(row, "@" .. plr.Name, 12, C.gray, false,
        UDim2.new(0, 68, 0, 33), UDim2.new(1, -68 - 90, 0, 18))

    local tag = new("TextLabel", {
        Size = UDim2.fromOffset(46, 20),
        Position = UDim2.new(1, -78, 0, 10),
        BackgroundColor3 = C.green,
        BackgroundTransparency = 0.8,
        Text = "",
        TextColor3 = C.green,
        Font = FB,
        TextSize = 12,
        Visible = false,
    }, row)
    corner(tag, 10)
    tagLbls[plr] = tag

    distLbls[plr] = label(row, "", 11, C.gray, false,
        UDim2.new(1, -78, 0, 34), UDim2.fromOffset(46, 18), Enum.TextXAlignment.Center)

    label(row, "›", 24, C.gray, true,
        UDim2.new(1, -28, 0, 0), UDim2.new(0, 20, 1, 0), Enum.TextXAlignment.Center)

    local hit = new("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 5,
    }, row)
    hit.MouseButton1Down:Connect(function()
        tw(rs, 0.12, {Scale = 0.965})
        tw(row, 0.12, {BackgroundTransparency = 0.3})
    end)
    local function up()
        tw(rs, 0.4, {Scale = 1}, Enum.EasingStyle.Back)
        tw(row, 0.25, {BackgroundTransparency = 0})
    end
    hit.InputEnded:Connect(up)
    hit.MouseLeave:Connect(up)
    hit.MouseButton1Click:Connect(function() openDetail(plr) end) -- @hit

    rows[plr] = slot
    rowParts[plr] = {row = row, stroke = stroke}
    updateTag(plr)
    resolveFriend(plr)
    reorder()
    applyFilter()
end

-- الاضافة تتم تدريجياً (3 صفوف لكل فريم) عشان ما تعلق الشاشة
local function addPlayer(plr)
    if rows[plr] or queued[plr] then return end
    queued[plr] = true
    updateCount()
    queueBuild(function()
        queued[plr] = nil
        if alive and plr.Parent and not rows[plr] then buildPlayerRow(plr) end
    end)
end

local function removePlayer(plr)
    queued[plr] = nil
    local slot = rows[plr]
    local parts = rowParts[plr]
    rows[plr] = nil
    rowParts[plr] = nil
    tagLbls[plr], distLbls[plr], dists[plr] = nil, nil, nil
    updateCount(plr)
    if slot then
        slot.ClipsDescendants = true
        if parts then
            tw(parts.row, 0.25, {BackgroundTransparency = 1})
            tw(parts.stroke, 0.2, {Transparency = 1})
        end
        tw(slot, 0.3, {Size = UDim2.new(1, -4, 0, 0)})
        task.delay(0.32, function() pcall(function() slot:Destroy() end) end)
    end
    reorder()
    applyFilter()
    -- اللاعب اللي كنت داخل صفحته طلع من السيرفر => رجعني لقائمة اللاعبين
    if currentPlayer == plr then
        closeDetail()
        toast("اللاعب خرج — رجعتك لقائمة اللاعبين")
    end
end

for i, p in ipairs(Players:GetPlayers()) do
    addPlayer(p, math.min((i - 1) * 0.03, 0.6))
end
track(Players.PlayerAdded:Connect(function(p) addPlayer(p, 0) end))
track(Players.PlayerRemoving:Connect(removePlayer))
updateCount()

-- المسافات (كل نص ثانية) + اعادة الترتيب/الفلترة عند الحاجة
task.spawn(function()
    local lastHeavy = 0
    while alive do
        task.wait(0.5)
        if windowOpen then
            local myChar = LocalPlayer.Character
            local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
            for plr in pairs(rows) do
                if plr ~= LocalPlayer then
                    local char = plr.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    local d
                    if myHrp and hrp then d = (hrp.Position - myHrp.Position).Magnitude end
                    dists[plr] = d
                    local lbl = distLbls[plr]
                    if lbl then
                        lbl.Text = d and (math.floor(d * 0.28) .. " m") or ""
                    end
                end
            end
            if os.clock() - lastHeavy > 1.5 then
                lastHeavy = os.clock()
                if sortMode == "dist" then reorder() end
                if filterMode == "near" then applyFilter() end
            end
        end
    end
end)

-- ================= محرك التدرج المتحرك (خفيف وذكي) =================
-- يشتغل بس على الصفحة الظاهرة، والصفوف اللي داخل الشاشة فقط، ويخفف نفسه اذا الـ FPS نزل
do
    local acc, cleanT, dtAvg = 0, 0, 1 / 60
    local step, rowBudget = 1 / 30, 14
    track(RunService.Heartbeat:Connect(function(dt)
        dtAvg = dtAvg * 0.92 + dt * 0.08
        if dtAvg > 0.034 then
            step, rowBudget = 1 / 15, 0
        elseif dtAvg < 0.024 then
            step, rowBudget = 1 / 30, 14
        end
        acc = acc + dt
        if acc < step then return end
        acc = 0
        local now = os.clock()
        local win = windowOpen
        local active = {
            window = win and animOn,
            main = win and animOn and not detail.Visible and not settings.Visible,
            detail = win and animOn and detail.Visible and not settings.Visible,
            settings = win and animOn and settings.Visible,
            launcher = true,
        }
        local left = rowBudget
        for i = 1, #animList do
            local e = animList[i]
            if active[e.tag] then
                local g = e.g
                if g.Parent then
                    local ok = true
                    if e.host then
                        if left <= 0 then
                            ok = false
                        else
                            local hp, hs = e.host.AbsolutePosition, e.host.AbsoluteSize
                            local sp, ss = e.scroll.AbsolutePosition, e.scroll.AbsoluteSize
                            ok = (hp.Y + hs.Y > sp.Y) and (hp.Y < sp.Y + ss.Y)
                            if ok then left = left - 1 end
                        end
                    end
                    if ok then g.Rotation = (now * e.speed + e.phase) % 360 end
                end
            end
        end
        cleanT = cleanT + step
        if cleanT > 12 then
            cleanT = 0
            local keep = {}
            for i = 1, #animList do
                local e = animList[i]
                if e.g.Parent then keep[#keep + 1] = e end
            end
            animList = keep
            -- تنظيف دوال الألوان القديمة (عناصر انحذفت)
            applyTheme("window")
            applyTheme("button")
            applyTheme("list")
        end
    end))
end

-- ================= تصغير / اغلاق =================
do
local minimized = false
minDot.MouseButton1Click:Connect(function()
    minimized = not minimized
    body.Visible = not minimized
    capBg.Visible = not minimized
    detail.Visible = (not minimized) and (currentPlayer ~= nil)
    settings.Visible = (not minimized) and settingsOpen
    tw(root, 0.35, {Size = minimized and UDim2.fromOffset(W, HEADER_H) or UDim2.fromOffset(W, H)},
        Enum.EasingStyle.Quint)
end)
closeDot.MouseButton1Click:Connect(function()
    hideWindow()
end)
end

-- حركة الفتح
tw(rootScale, 0.5, {Scale = 1}, Enum.EasingStyle.Back)
