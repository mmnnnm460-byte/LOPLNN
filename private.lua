local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local SAVE_FILE = "SkinApplier_Skins.dat"
local STATS_FILE = "SkinApplier_Stats.dat"
local VERSIONS_FILE = "SkinApplier_Versions.dat"
local MUSIC_FILE = "SkinApplier_Music.dat"

local Theme = { accent = Color3.fromRGB(150, 110, 240), bg = Color3.fromRGB(25, 25, 30), vpBg = Color3.fromRGB(15, 15, 18) }
local function currentTheme() return Theme end

local State = {
    selectedPlayerName = nil,
    isBusy = false,

    originalDescription = nil, originalRigType = nil, hasSavedOriginal = false,
    history = {}, maxHistory = 5,
    log = {}, maxLog = 40, lastErrorRaw = nil,

    settings = {
        includeTopClothing = true, includeBottomClothing = true, includeShoes = true,
        includeFaceLayered = true, applyAnimations = true, applyColors = true, applyScales = true,
        mergeBodyFrom = "Target", mergeOutfitFrom = "Target",
    },

    applyRigMode = "Auto",
    preview = { rigMode = "Auto", rotationSpeed = 0.6, distance = 6, playWalkAnim = false },

    saveNameOverride = "", saveTagOverride = "",
    savedSkins = {}, versions = {}, selectedSavedSkin = nil, tagFilter = "الكل",

    quickSlots = { nil, nil, nil, nil },

    notifyLevel = "Normal", soundEnabled = true,

    remoteHealthy = false,
    backoff = { current = 1.5, min = 1.5, max = 10 }, lastPing = 0,

    descCache = {}, CACHE_TTL = 8,
    joinTimes = {},

    filterMode = "None", filterNames = {},
    queueSelected = {},

    watchEnabled = false, watchTarget = nil, watchSignature = nil, watchAutoSync = false,
    respawnAutoApply = false, lastAppliedProps = nil, lastAppliedRig = nil,

    lastAppliedTarget = nil, lastAppliedTime = 0,
    pendingConfirmTarget = nil, pendingConfirmTime = 0,

    debugMode = false,
    stats = { totalApplied = 0, totalFailed = 0, perSkin = {} },

    music = { volume = 1, currentId = nil, playing = false, sound = nil, savedIds = {} },
}

local UI = {}

local function safeAsset(v)
    local n = tonumber(v)
    if n and n > 0 then return n end
    return 0
end

local function colorToTable(color)
    if typeof(color) ~= "Color3" then color = Color3.fromRGB(245, 205, 48) end
    return { r = color.R * 255, g = color.G * 255, b = color.B * 255, IsRGBTable = true }
end

local function tableToColor3(t)
    if t and t.IsRGBTable then return Color3.fromRGB(t.r, t.g, t.b) end
    return Color3.fromRGB(163, 162, 165)
end

local function vector3ToTable(vec)
    if typeof(vec) ~= "Vector3" then vec = Vector3.new(0, 0, 0) end
    return { X = vec.X, Y = vec.Y, Z = vec.Z, Vector3 = true }
end

local function nowStamp()
    local ok, result = pcall(function() return os.date("%H:%M:%S") end)
    if ok then return result end
    return tostring(os.clock())
end

local function shallowCopy(t)
    local out = {}
    for k, v in pairs(t) do out[k] = v end
    return out
end

local XOR_KEY = 137

local function xorStr(str)
    local out = {}
    for i = 1, #str do out[i] = string.char(bit32.bxor(string.byte(str, i), XOR_KEY)) end
    return table.concat(out)
end

local function protectSave(fileName, luaTable)
    pcall(function()
        local json = HttpService:JSONEncode(luaTable)
        writefile(fileName, HttpService:Base64Encode(xorStr(json)))
    end)
end

local function loadProtected(fileName)
    local ok, content = pcall(function() return readfile(fileName) end)
    if not ok or not content or content == "" then return nil end
    local decodeOk, decoded = pcall(function()
        return HttpService:JSONDecode(xorStr(HttpService:Base64Decode(content)))
    end)
    if decodeOk and type(decoded) == "table" then return decoded end
    return nil
end

local function playNotifySound(kind)
    if not State.soundEnabled then return end
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = (kind == "success") and "rbxasset://sounds/electronicpingshort.wav" or "rbxasset://sounds/impact_water.mp3"
        sound.Volume = 0.5
        sound.Parent = SoundService
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 3)
    end)
end

local function notify(title, content, duration, detailExtra)
    if State.notifyLevel == "Silent" then return end
    if State.notifyLevel == "Detailed" and detailExtra then content = content .. "\n" .. detailExtra end
    Rayfield:Notify({ Title = title, Content = content, Duration = duration or 3 })
end

local DiagnosticKeywords = {
    { key = "Shirt", label = "القميص (Shirt)", settingKeys = {} },
    { key = "Pants", label = "البنطال (Pants)", settingKeys = {} },
    { key = "GraphicTShirt", label = "التيشيرت المطبوع", settingKeys = {} },
    { key = "Face", label = "الوجه (Face)", settingKeys = {} },
    { key = "Layered", label = "الملابس الطبقية", settingKeys = { "includeTopClothing", "includeBottomClothing", "includeShoes", "includeFaceLayered" } },
    { key = "Animation", label = "الأنيميشنز", settingKeys = { "applyAnimations" } },
    { key = "AssetId", label = "معرف أحد العناصر", settingKeys = {} },
    { key = "RigType", label = "نوع الرِج", settingKeys = {} },
    { key = "Accessory", label = "أحد الإكسسوارات", settingKeys = { "includeTopClothing", "includeBottomClothing", "includeShoes", "includeFaceLayered" } },
    { key = "Color", label = "الألوان", settingKeys = { "applyColors" } },
    { key = "Scale", label = "المقاسات", settingKeys = { "applyScales" } },
}

local function diagnoseError(errText)
    local hints, settingKeysToDisable = {}, {}
    local lowerErr = string.lower(errText)
    for _, entry in ipairs(DiagnosticKeywords) do
        if string.find(lowerErr, string.lower(entry.key)) then
            table.insert(hints, entry.label)
            for _, sk in ipairs(entry.settingKeys) do table.insert(settingKeysToDisable, sk) end
        end
    end
    return hints, settingKeysToDisable
end

local function pushLog(target, status, message)
    table.insert(State.log, 1, { time = nowStamp(), target = target, status = status, message = message })
    while #State.log > State.maxLog do table.remove(State.log) end
end

local function reportFailure(target, err)
    local fullText = tostring(err)
    local hints = diagnoseError(fullText)
    State.lastErrorRaw = fullText
    State.stats.totalFailed += 1

    print("[Skin Applier] فشل التطبيق على " .. tostring(target))
    print(fullText)
    pushLog(target, "فشل", fullText)
    playNotifySound("fail")

    local copied = false
    pcall(function() setclipboard(fullText); copied = true end)

    local hintText = (#hints > 0) and ("\nمحتمل السبب: " .. table.concat(hints, "، ")) or ""
    local shortText = fullText
    if #shortText > 120 then shortText = shortText:sub(1, 120) .. "..." end
    notify("فشل التطبيق", shortText .. hintText .. (copied and "\n(تم نسخ التفاصيل)" or "\n(شوف الـ Console)"), 6)
end

local function reportSuccess(target, rigName, skinName)
    State.stats.totalApplied += 1
    if skinName then State.stats.perSkin[skinName] = (State.stats.perSkin[skinName] or 0) + 1 end
    protectSave(STATS_FILE, State.stats)
    pushLog(target, "نجاح", "تم التطبيق بنمط " .. rigName)
    playNotifySound("success")
    notify("تم بنجاح", "تم نسخ وتطبيق سكن " .. target .. " بنمط (" .. rigName .. ")", 3,
        "Ping: " .. string.format("%.2f", State.lastPing) .. "s | Backoff: " .. string.format("%.1f", State.backoff.current) .. "s")
end

local Event = ReplicatedStorage:FindFirstChild("CatalogGuiRemote")

local function findRemote() return ReplicatedStorage:FindFirstChild("CatalogGuiRemote") end

local function ensureRemote()
    if Event and Event.Parent then State.remoteHealthy = true; return true end
    local found = findRemote()
    if found then
        Event = found
        State.remoteHealthy = true
        pushLog("System", "نجاح", "تم إعادة اكتشاف الريموت تلقائياً")
        notify("إعادة اتصال", "تم اكتشاف الريموت من جديد تلقائياً", 2)
        return true
    end
    State.remoteHealthy = false
    return false
end

ReplicatedStorage.ChildAdded:Connect(function(child)
    if child.Name == "CatalogGuiRemote" then ensureRemote() end
end)

task.spawn(function()
    while true do
        task.wait(5)
        ensureRemote()
        if UI.RemoteHealthLabel then
            pcall(function()
                UI.RemoteHealthLabel:Set({ Title = "الحالة", Content = State.remoteHealthy and "🟢 متصل" or "🔴 غير متصل - يبحث..." })
            end)
        end
    end
end)

local TopClothingTypes = { "Jacket", "Sweater", "TShirt", "Shirt" }
local BottomClothingTypes = { "Pants", "Shorts", "DressSkirt" }
local ShoeTypes = { "LeftShoe", "RightShoe" }
local FaceLayeredTypes = { "Eyebrow", "Eyelash" }

local function matchesAny(str, list)
    for _, t in ipairs(list) do if string.find(str, t) then return true end end
    return false
end

local function categoryAllowed(typeName, settings)
    if matchesAny(typeName, TopClothingTypes) then return settings.includeTopClothing
    elseif matchesAny(typeName, BottomClothingTypes) then return settings.includeBottomClothing
    elseif matchesAny(typeName, ShoeTypes) then return settings.includeShoes
    elseif matchesAny(typeName, FaceLayeredTypes) then return settings.includeFaceLayered end
    return true
end

local function buildLayeredAccessories(desc, settings)
    local result = {}
    pcall(function()
        for _, acc in ipairs(desc:GetAccessories(true)) do
            local id = tonumber(acc.AssetId) or 0
            if id > 0 and acc.IsLayered then
                local typeName = (acc.AccessoryType and acc.AccessoryType.Name) or "Unknown"
                if categoryAllowed(typeName, settings) then
                    table.insert(result, {
                        AssetId = id, AccessoryType = typeName, Order = tonumber(acc.Order) or 1,
                        IsLayered = true, Puffiness = tonumber(acc.Puffiness) or 1,
                        Position = vector3ToTable(acc.Position), Rotation = vector3ToTable(acc.Rotation),
                        Scale = vector3ToTable(acc.Scale),
                    })
                end
            end
        end
    end)
    return result
end

local function buildPropertiesTable(desc, rigType, settings)
    local isR6 = (rigType == Enum.HumanoidRigType.R6)
    local layeredAccs = buildLayeredAccessories(desc, settings)
    local defaultColor = { r = 163, g = 162, b = 165, IsRGBTable = true }

    local props = {
        Shirt = safeAsset(desc.Shirt), Pants = safeAsset(desc.Pants),
        GraphicTShirt = safeAsset(desc.GraphicTShirt), Face = safeAsset(desc.Face),
        Head = safeAsset(desc.Head), Torso = safeAsset(desc.Torso),
        LeftArm = safeAsset(desc.LeftArm), RightArm = safeAsset(desc.RightArm),
        LeftLeg = safeAsset(desc.LeftLeg), RightLeg = safeAsset(desc.RightLeg),
        HatAccessory = (desc.HatAccessory and tostring(desc.HatAccessory)) or "",
        HairAccessory = (desc.HairAccessory and tostring(desc.HairAccessory)) or "",
        FaceAccessory = (desc.FaceAccessory and tostring(desc.FaceAccessory)) or "",
        NeckAccessory = (desc.NeckAccessory and tostring(desc.NeckAccessory)) or "",
        ShouldersAccessory = (desc.ShouldersAccessory and tostring(desc.ShouldersAccessory)) or "",
        FrontAccessory = (desc.FrontAccessory and tostring(desc.FrontAccessory)) or "",
        BackAccessory = (desc.BackAccessory and tostring(desc.BackAccessory)) or "",
        WaistAccessory = (desc.WaistAccessory and tostring(desc.WaistAccessory)) or "",
        MakeupItems = {}, LayeredAccessories = layeredAccs, AccessoryRefinements = {}, StaticFacialAnimation = false,
    }

    if settings.applyColors then
        props.HeadColor = colorToTable(desc.HeadColor); props.TorsoColor = colorToTable(desc.TorsoColor)
        props.LeftArmColor = colorToTable(desc.LeftArmColor); props.RightArmColor = colorToTable(desc.RightArmColor)
        props.LeftLegColor = colorToTable(desc.LeftLegColor); props.RightLegColor = colorToTable(desc.RightLegColor)
    else
        props.HeadColor = defaultColor; props.TorsoColor = defaultColor
        props.LeftArmColor = defaultColor; props.RightArmColor = defaultColor
        props.LeftLegColor = defaultColor; props.RightLegColor = defaultColor
    end

    if settings.applyAnimations and not isR6 then
        props.IdleAnimation = safeAsset(desc.IdleAnimation); props.WalkAnimation = safeAsset(desc.WalkAnimation)
        props.RunAnimation = safeAsset(desc.RunAnimation); props.JumpAnimation = safeAsset(desc.JumpAnimation)
        props.FallAnimation = safeAsset(desc.FallAnimation); props.ClimbAnimation = safeAsset(desc.ClimbAnimation)
        props.SwimAnimation = safeAsset(desc.SwimAnimation); props.MoodAnimation = safeAsset(desc.MoodAnimation)
    else
        props.IdleAnimation = 0; props.WalkAnimation = 0; props.RunAnimation = 0; props.JumpAnimation = 0
        props.FallAnimation = 0; props.ClimbAnimation = 0; props.SwimAnimation = 0; props.MoodAnimation = 0
    end

    if settings.applyScales and not isR6 then
        props.HeadScale = tonumber(desc.HeadScale) or 1; props.HeightScale = tonumber(desc.HeightScale) or 1
        props.WidthScale = tonumber(desc.WidthScale) or 1; props.DepthScale = tonumber(desc.DepthScale) or 1
        props.ProportionScale = tonumber(desc.ProportionScale) or 0; props.BodyTypeScale = tonumber(desc.BodyTypeScale) or 0
    else
        props.HeadScale = 1; props.HeightScale = 1; props.WidthScale = 1
        props.DepthScale = 1; props.ProportionScale = 0; props.BodyTypeScale = 0
    end

    return props
end

local function reconstructDescriptionFromProps(props)
    local ok, desc = pcall(function()
        local d = Instance.new("HumanoidDescription")
        d.Shirt = props.Shirt or 0; d.Pants = props.Pants or 0
        d.GraphicTShirt = props.GraphicTShirt or 0; d.Face = props.Face or 0
        d.Head = props.Head or 0; d.Torso = props.Torso or 0
        d.LeftArm = props.LeftArm or 0; d.RightArm = props.RightArm or 0
        d.LeftLeg = props.LeftLeg or 0; d.RightLeg = props.RightLeg or 0

        d.HeadColor = tableToColor3(props.HeadColor); d.TorsoColor = tableToColor3(props.TorsoColor)
        d.LeftArmColor = tableToColor3(props.LeftArmColor); d.RightArmColor = tableToColor3(props.RightArmColor)
        d.LeftLegColor = tableToColor3(props.LeftLegColor); d.RightLegColor = tableToColor3(props.RightLegColor)

        d.HeadScale = props.HeadScale or 1; d.HeightScale = props.HeightScale or 1
        d.WidthScale = props.WidthScale or 1; d.DepthScale = props.DepthScale or 1
        d.ProportionScale = props.ProportionScale or 0; d.BodyTypeScale = props.BodyTypeScale or 0

        d.IdleAnimation = props.IdleAnimation or 0; d.WalkAnimation = props.WalkAnimation or 0
        d.RunAnimation = props.RunAnimation or 0; d.JumpAnimation = props.JumpAnimation or 0
        d.FallAnimation = props.FallAnimation or 0; d.ClimbAnimation = props.ClimbAnimation or 0
        d.SwimAnimation = props.SwimAnimation or 0; d.MoodAnimation = props.MoodAnimation or 0

        if props.LayeredAccessories then
            local accList = {}
            for _, acc in ipairs(props.LayeredAccessories) do
                table.insert(accList, {
                    AssetId = acc.AssetId,
                    AccessoryType = Enum.AccessoryType[acc.AccessoryType] or Enum.AccessoryType.Unknown,
                    IsLayered = true, Order = acc.Order or 1, Puffiness = acc.Puffiness or 1,
                })
            end
            pcall(function() d:SetAccessories(accList, false) end)
        end
        return d
    end)
    if ok then return desc end
    return nil
end

local function validateProperties(props)
    local warnings = {}
    for _, field in ipairs({ "Shirt","Pants","GraphicTShirt","Face","Head","Torso","LeftArm","RightArm","LeftLeg","RightLeg" }) do
        local v = props[field]
        if type(v) ~= "number" or v < 0 then table.insert(warnings, "⚠ قيمة غير صحيحة بحقل " .. field) end
    end
    if type(props.LayeredAccessories) ~= "table" then
        table.insert(warnings, "⚠ LayeredAccessories مو جدول صحيح")
    else
        for i, acc in ipairs(props.LayeredAccessories) do
            if not acc.AssetId or acc.AssetId <= 0 then table.insert(warnings, "⚠ إكسسوار #" .. i .. " بدون AssetId صحيح") end
        end
    end
    if not props.HeadColor or not props.HeadColor.IsRGBTable then table.insert(warnings, "⚠ HeadColor غير مضبوط بشكل صحيح") end
    return warnings
end

local function extractPalette(desc)
    local ok, palette = pcall(function()
        return {
            { name = "الرأس", color = desc.HeadColor }, { name = "الجذع", color = desc.TorsoColor },
            { name = "الذراع اليسرى", color = desc.LeftArmColor }, { name = "الذراع اليمنى", color = desc.RightArmColor },
            { name = "الرجل اليسرى", color = desc.LeftLegColor }, { name = "الرجل اليمنى", color = desc.RightLegColor },
        }
    end)
    if ok then return palette end
    return {}
end

local function showPaletteSwatches(desc, titleText)
    local theme = currentTheme()
    local guiParent
    pcall(function() guiParent = gethui() end)
    if not guiParent then guiParent = LocalPlayer:WaitForChild("PlayerGui") end

    local gui = Instance.new("ScreenGui")
    gui.Name = "PaletteGui"; gui.ResetOnSpawn = false; gui.DisplayOrder = 999; gui.Parent = guiParent

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 240, 0, 200); frame.Position = UDim2.new(0.5, -120, 0.5, -100)
    frame.BackgroundColor3 = theme.bg; frame.BorderSizePixel = 0; frame.Parent = gui
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0,10); corner.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,-40,0,26); title.Position = UDim2.new(0,10,0,5)
    title.BackgroundTransparency = 1; title.Text = titleText or "لوحة الألوان"
    title.TextColor3 = theme.accent; title.Font = Enum.Font.GothamBold; title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left; title.Parent = frame

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0,24,0,24); closeBtn.Position = UDim2.new(1,-30,0,5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200,60,60); closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1,1,1); closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 12
    closeBtn.Parent = frame
    local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0,6); cc.Parent = closeBtn
    closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

    local list = Instance.new("UIListLayout"); list.Padding = UDim.new(0,4); list.Parent = frame
    local spacer = Instance.new("Frame"); spacer.Size = UDim2.new(1,0,0,30); spacer.BackgroundTransparency = 1; spacer.Parent = frame

    for _, entry in ipairs(extractPalette(desc)) do
        local row = Instance.new("Frame"); row.Size = UDim2.new(1,-20,0,22); row.BackgroundTransparency = 1; row.Parent = frame
        local swatch = Instance.new("Frame")
        swatch.Size = UDim2.new(0,18,0,18); swatch.Position = UDim2.new(0,10,0,2)
        swatch.BackgroundColor3 = entry.color; swatch.BorderSizePixel = 0; swatch.Parent = row
        local sc = Instance.new("UICorner"); sc.CornerRadius = UDim.new(0,4); sc.Parent = swatch
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1,-40,0,20); label.Position = UDim2.new(0,36,0,0)
        label.BackgroundTransparency = 1; label.Text = entry.name
        label.TextColor3 = Color3.fromRGB(220,220,220); label.Font = Enum.Font.Gotham; label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = row
    end
end

local function computeDiff(propsA, propsB)
    local diffs = {}
    local scalarKeys = { "Shirt","Pants","GraphicTShirt","Face","Head","Torso","LeftArm","RightArm","LeftLeg","RightLeg",
        "HatAccessory","HairAccessory","FaceAccessory","NeckAccessory","ShouldersAccessory","FrontAccessory","BackAccessory","WaistAccessory" }
    for _, k in ipairs(scalarKeys) do
        if tostring(propsA[k]) ~= tostring(propsB[k]) then
            table.insert(diffs, k .. ": " .. tostring(propsA[k]) .. " → " .. tostring(propsB[k]))
        end
    end
    local lenA = propsA.LayeredAccessories and #propsA.LayeredAccessories or 0
    local lenB = propsB.LayeredAccessories and #propsB.LayeredAccessories or 0
    if lenA ~= lenB then table.insert(diffs, "عدد الإكسسوارات الطبقية: " .. lenA .. " → " .. lenB) end
    return diffs
end

local function resolveRigType(mode, nativeRig)
    if mode == "R15" then return Enum.HumanoidRigType.R15
    elseif mode == "R6" then return Enum.HumanoidRigType.R6 end
    return nativeRig or Enum.HumanoidRigType.R15
end

local function guessBestRig(desc, nativeRig)
    if nativeRig then return nativeRig end
    local ok, hasR15Traits = pcall(function()
        return (tonumber(desc.HeadScale) ~= 1) or (tonumber(desc.WalkAnimation) or 0) > 0
    end)
    if ok and hasR15Traits then return Enum.HumanoidRigType.R15 end
    return Enum.HumanoidRigType.R15
end

local function makeRigSafeDescription(desc, targetRig, nativeRig)
    local clone = desc:Clone()
    local crossRig = (nativeRig ~= nil) and (targetRig ~= nativeRig)
    if crossRig then
        clone.Head = 0; clone.Torso = 0; clone.LeftArm = 0; clone.RightArm = 0; clone.LeftLeg = 0; clone.RightLeg = 0
    end
    if targetRig == Enum.HumanoidRigType.R6 then
        clone.HeadScale = 1; clone.HeightScale = 1; clone.WidthScale = 1; clone.DepthScale = 1
        clone.ProportionScale = 0; clone.BodyTypeScale = 0
        clone.IdleAnimation = 0; clone.WalkAnimation = 0; clone.RunAnimation = 0; clone.JumpAnimation = 0
        clone.FallAnimation = 0; clone.ClimbAnimation = 0; clone.SwimAnimation = 0; clone.MoodAnimation = 0
    end
    return clone, crossRig
end

local function applyPartialMerge(baseProps, bodySourceProps, outfitSourceProps)
    if State.settings.mergeBodyFrom == "Self" and bodySourceProps then
        baseProps.Head = bodySourceProps.Head; baseProps.Torso = bodySourceProps.Torso
        baseProps.LeftArm = bodySourceProps.LeftArm; baseProps.RightArm = bodySourceProps.RightArm
        baseProps.LeftLeg = bodySourceProps.LeftLeg; baseProps.RightLeg = bodySourceProps.RightLeg
        baseProps.HeadColor = bodySourceProps.HeadColor; baseProps.TorsoColor = bodySourceProps.TorsoColor
        baseProps.LeftArmColor = bodySourceProps.LeftArmColor; baseProps.RightArmColor = bodySourceProps.RightArmColor
        baseProps.LeftLegColor = bodySourceProps.LeftLegColor; baseProps.RightLegColor = bodySourceProps.RightLegColor
    end
    if State.settings.mergeOutfitFrom == "Self" and outfitSourceProps then
        baseProps.Shirt = outfitSourceProps.Shirt; baseProps.Pants = outfitSourceProps.Pants
        baseProps.GraphicTShirt = outfitSourceProps.GraphicTShirt
        baseProps.LayeredAccessories = outfitSourceProps.LayeredAccessories
    end
    return baseProps
end

local function buildFinalProperties(desc, rigType, settings)
    local props = buildPropertiesTable(desc, rigType, settings)

    if settings.mergeBodyFrom == "Self" or settings.mergeOutfitFrom == "Self" then
        local selfChar = LocalPlayer.Character
        local selfHumanoid = selfChar and selfChar:FindFirstChildOfClass("Humanoid")
        if selfHumanoid then
            local ok, selfDesc = pcall(function() return selfHumanoid:GetAppliedDescription() end)
            if ok and selfDesc then
                local selfProps = buildPropertiesTable(selfDesc, selfHumanoid.RigType, settings)
                props = applyPartialMerge(props, selfProps, selfProps)
            end
        end
    end

    return props
end

local function attemptApply(props, rigType)
    if not ensureRemote() then return false, "الريموت CatalogGuiRemote غير موجود حالياً" end
    local startTime = os.clock()
    local ok, err = pcall(function()
        return Event:InvokeServer({ Action = "CreateAndWearHumanoidDescription", Properties = props, RigType = rigType })
    end)
    State.lastPing = os.clock() - startTime
    if ok then State.backoff.current = State.backoff.min
    else State.backoff.current = math.min(State.backoff.current * 1.6, State.backoff.max) end
    return ok, err
end

local FallbackLevels = {
    { label = "كامل", modify = function(s) end },
    { label = "بدون طبقات الملابس", modify = function(s) s.includeTopClothing=false; s.includeBottomClothing=false; s.includeShoes=false; s.includeFaceLayered=false end },
    { label = "بدون أنيميشن ومقاسات", modify = function(s) s.applyAnimations=false; s.applyScales=false end },
    { label = "أساسي فقط", modify = function(s) s.applyAnimations=false; s.applyScales=false; s.includeTopClothing=false; s.includeBottomClothing=false; s.includeShoes=false; s.includeFaceLayered=false end },
}

local function applyWithSmartRetry(desc, targetRig, baseSettings, targetLabel)
    local lastErr, lastProps
    for i, level in ipairs(FallbackLevels) do
        if i > 1 then
            task.wait(State.backoff.current)
            if not ensureRemote() then return false, "تعذر إيجاد الريموت أثناء إعادة المحاولة", nil end
        end
        local trySettings = shallowCopy(baseSettings)
        level.modify(trySettings)

        local safeDesc = makeRigSafeDescription(desc, targetRig, nil)
        local props = buildFinalProperties(safeDesc, targetRig, trySettings)
        safeDesc:Destroy()

        if State.debugMode then
            print("[Debug] محاولة مستوى: " .. level.label)
            pcall(function() print(HttpService:JSONEncode(props)) end)
        end

        lastProps = props
        local ok, err = attemptApply(props, targetRig)
        if ok then
            if i > 1 then notify("نجح بعد تبسيط", "تم التطبيق بمستوى: " .. level.label, 4) end
            return true, nil, props
        end
        lastErr = err
    end
    return false, lastErr, lastProps
end

local function getTargetDescription(targetPlayer)
    local cached = State.descCache[targetPlayer.UserId]
    if cached and (os.clock() - cached.cachedAt) < State.CACHE_TTL then return cached.desc, cached.rig end

    local targetHumanoid, rigType = nil, Enum.HumanoidRigType.R15
    if targetPlayer.Character then
        targetHumanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
        if targetHumanoid then rigType = targetHumanoid.RigType end
    end

    local desc = nil
    pcall(function() if targetHumanoid then desc = targetHumanoid:GetAppliedDescription() end end)
    if not desc then pcall(function() desc = Players:GetHumanoidDescriptionFromUserId(targetPlayer.UserId) end) end

    if desc then
        rigType = guessBestRig(desc, targetHumanoid and rigType or nil)
        State.descCache[targetPlayer.UserId] = { desc = desc, rig = rigType, cachedAt = os.clock() }
    end
    return desc, rigType
end

for _, plr in ipairs(Players:GetPlayers()) do State.joinTimes[plr.UserId] = os.time() end
Players.PlayerAdded:Connect(function(plr) State.joinTimes[plr.UserId] = os.time() end)

local function passesFilter(plr)
    local lname = string.lower(plr.Name)
    if State.filterMode == "Whitelist" then return table.find(State.filterNames, lname) ~= nil
    elseif State.filterMode == "Blacklist" then return table.find(State.filterNames, lname) == nil end
    return true
end

local function getPlayerNames(recentOnly)
    local names = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and passesFilter(plr) then
            if not recentOnly or (os.time() - (State.joinTimes[plr.UserId] or 0)) <= 300 then
                table.insert(names, plr.Name)
            end
        end
    end
    return names
end

function RefreshAllPlayerDropdowns()
    local names = getPlayerNames()
    if UI.PlayerDropdown then UI.PlayerDropdown:Refresh(names, true) end
    if UI.QueueDropdown then UI.QueueDropdown:Refresh(names, true) end
end

Players.PlayerAdded:Connect(function() task.wait(0.5); RefreshAllPlayerDropdowns() end)
Players.PlayerRemoving:Connect(function(leavingPlr)
    task.wait(0.2)
    State.descCache[leavingPlr.UserId] = nil
    RefreshAllPlayerDropdowns()
end)

local function persistSavedSkins() protectSave(SAVE_FILE, State.savedSkins) end
local function persistVersions() protectSave(VERSIONS_FILE, State.versions) end
local function persistMusic() protectSave(MUSIC_FILE, State.music.savedIds) end

local function loadAllData()
    State.savedSkins = loadProtected(SAVE_FILE) or {}
    State.versions = loadProtected(VERSIONS_FILE) or {}
    local loadedStats = loadProtected(STATS_FILE)
    if loadedStats then State.stats = loadedStats end
    local loadedMusic = loadProtected(MUSIC_FILE)
    if loadedMusic then State.music.savedIds = loadedMusic end
end
loadAllData()

local function saveSkin(name, props, rigType, tag)
    if not name or name == "" then name = "سكن_" .. nowStamp() end
    if State.savedSkins[name] then
        State.versions[name] = State.versions[name] or {}
        table.insert(State.versions[name], 1, State.savedSkins[name])
        while #State.versions[name] > 3 do table.remove(State.versions[name]) end
        persistVersions()
    end
    State.savedSkins[name] = { props = props, rig = rigType.Name, savedAt = nowStamp(), tag = (tag ~= "" and tag) or "عام" }
    persistSavedSkins()
end

local function needsConfirm(targetName)
    local now = os.clock()
    if State.pendingConfirmTarget == targetName and (now - State.pendingConfirmTime) < 5 then
        State.pendingConfirmTarget = nil
        return false
    end
    if State.lastAppliedTarget == targetName and (now - State.lastAppliedTime) < 5 then
        State.pendingConfirmTarget = targetName
        State.pendingConfirmTime = now
        notify("تأكيد", "طبقت نفس الهدف قبل شوي! اضغط الزر مرة ثانية خلال 5 ثواني للتأكيد", 4)
        return true
    end
    return false
end

local function saveOriginalIfNeeded()
    if State.hasSavedOriginal then return end
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local ok = pcall(function()
        State.originalDescription = humanoid:GetAppliedDescription()
        State.originalRigType = humanoid.RigType
    end)
    if ok then State.hasSavedOriginal = true end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    if not State.respawnAutoApply or not State.lastAppliedProps then return end
    local humanoid = char:WaitForChild("Humanoid", 5)
    if not humanoid then return end
    task.wait(1)
    local ok, err = attemptApply(State.lastAppliedProps, State.lastAppliedRig)
    if ok then
        pushLog("Respawn", "نجاح", "تم إعادة تطبيق آخر سكن بعد الموت تلقائياً")
        notify("Respawn", "تم إعادة تطبيق سكنك تلقائياً بعد الموت", 3)
    else
        pushLog("Respawn", "فشل", tostring(err))
    end
end)

local function isLockedByMovementState()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    local state = humanoid:GetState()
    return state == Enum.HumanoidStateType.Swimming or state == Enum.HumanoidStateType.Climbing or state == Enum.HumanoidStateType.Freefall
end

local function computeSignature(props)
    local ok, json = pcall(function()
        return HttpService:JSONEncode({ props.Shirt, props.Pants, props.Head, props.Torso, props.LeftArm, props.RightArm, props.LeftLeg, props.RightLeg, #props.LayeredAccessories })
    end)
    return ok and json or tostring(os.clock())
end

task.spawn(function()
    while true do
        task.wait(3)
        if State.watchEnabled and State.watchTarget then
            local targetPlayer = Players:FindFirstChild(State.watchTarget)
            if targetPlayer then
                State.descCache[targetPlayer.UserId] = nil
                local desc, rig = getTargetDescription(targetPlayer)
                if desc then
                    local props = buildPropertiesTable(desc, rig, State.settings)
                    local sig = computeSignature(props)
                    if State.watchSignature and sig ~= State.watchSignature then
                        notify("👁️ تغيّر مكتشف", State.watchTarget .. " غيّر شكله بالسيرفر", 4)
                        pushLog("Watch", "تنبيه", State.watchTarget .. " غيّر مظهره")
                        if State.watchAutoSync and not State.isBusy then
                            local ok = applyWithSmartRetry(desc, rig, State.settings, State.watchTarget)
                            if ok then reportSuccess(State.watchTarget, rig.Name, State.watchTarget) end
                        end
                    end
                    State.watchSignature = sig
                end
            end
        end
    end
end)

local function pushHistory(desc, rigType, label)
    table.insert(State.history, { desc = desc, rigType = rigType, label = label })
    while #State.history > State.maxHistory do table.remove(State.history, 1) end
end

local previewGui, previewConnection

local function closePreview()
    if previewConnection then previewConnection:Disconnect(); previewConnection = nil end
    if previewGui then previewGui:Destroy(); previewGui = nil end
end

local function attachWalkAnimation(model, desc)
    if not State.preview.playWalkAnim then return end
    pcall(function()
        local humanoid = model:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local walkId = safeAsset(desc.WalkAnimation)
        if walkId <= 0 then return end
        local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://" .. walkId
        local track = animator:LoadAnimation(anim)
        track.Looped = true
        track:Play()
    end)
end

local function buildPreviewFrame(guiParent, sizeX, posX, theme)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, sizeX, 0, 360); frame.Position = UDim2.new(0.5, posX, 0.5, -180)
    frame.BackgroundColor3 = theme.bg; frame.BorderSizePixel = 0; frame.Parent = guiParent
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0,10); corner.Parent = frame

    local viewport = Instance.new("ViewportFrame")
    viewport.Size = UDim2.new(1,-20,1,-70); viewport.Position = UDim2.new(0,10,0,40)
    viewport.BackgroundColor3 = theme.vpBg; viewport.Parent = frame
    local vc = Instance.new("UICorner"); vc.CornerRadius = UDim.new(0,8); vc.Parent = viewport

    local worldModel = Instance.new("WorldModel"); worldModel.Parent = viewport
    local cam = Instance.new("Camera"); cam.Parent = viewport
    viewport.CurrentCamera = cam

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1,-20,0,24); statusLabel.Position = UDim2.new(0,10,1,-30)
    statusLabel.BackgroundTransparency = 1; statusLabel.Text = "جاري التحميل..."
    statusLabel.TextColor3 = Color3.fromRGB(200,200,200); statusLabel.Font = Enum.Font.Gotham; statusLabel.TextSize = 12
    statusLabel.Parent = frame

    return frame, viewport, worldModel, cam, statusLabel
end

local function loadModelIntoViewport(desc, nativeRig, worldModel, cam, statusLabel)
    local effectiveRig = resolveRigType(State.preview.rigMode, nativeRig)
    local safeDesc = makeRigSafeDescription(desc, effectiveRig, nativeRig)
    local ok, model = pcall(function() return Players:CreateHumanoidModelFromDescriptionAsync(safeDesc, effectiveRig) end)
    if not ok or not model then statusLabel.Text = "تعذر تحميل المعاينة"; safeDesc:Destroy(); return nil, nil end
    model.Parent = worldModel
    attachWalkAnimation(model, safeDesc)
    safeDesc:Destroy()
    local rootPart = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
    statusLabel.Text = "✔ جاهز"
    return model, rootPart
end

local function openPreview(desc, nativeRig, titleText)
    closePreview()
    local theme = currentTheme()
    local guiParent
    pcall(function() guiParent = gethui() end)
    if not guiParent then guiParent = LocalPlayer:WaitForChild("PlayerGui") end

    previewGui = Instance.new("ScreenGui")
    previewGui.Name = "SkinPreviewGui"; previewGui.ResetOnSpawn = false; previewGui.DisplayOrder = 999
    previewGui.Parent = guiParent

    local frame, viewport, worldModel, cam, statusLabel = buildPreviewFrame(previewGui, 260, -130, theme)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1,-40,0,30); titleLabel.Position = UDim2.new(0,10,0,5)
    titleLabel.BackgroundTransparency = 1; titleLabel.Text = titleText or "معاينة السكن"
    titleLabel.TextColor3 = theme.accent; titleLabel.Font = Enum.Font.GothamBold; titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left; titleLabel.Parent = frame

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0,26,0,26); closeBtn.Position = UDim2.new(1,-32,0,6)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200,60,60); closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1,1,1); closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 14
    closeBtn.Parent = frame
    local ccl = Instance.new("UICorner"); ccl.CornerRadius = UDim.new(0,6); ccl.Parent = closeBtn
    closeBtn.MouseButton1Click:Connect(closePreview)

    task.spawn(function()
        local model, rootPart = loadModelIntoViewport(desc, nativeRig, worldModel, cam, statusLabel)
        if not model or not rootPart then return end
        local angle = 0
        previewConnection = RunService.RenderStepped:Connect(function(dt)
            angle += dt * State.preview.rotationSpeed
            local dist = State.preview.distance
            local offset = Vector3.new(math.sin(angle) * dist, 1.5, math.cos(angle) * dist)
            local focusPos = rootPart.Position + Vector3.new(0, 1.5, 0)
            cam.CFrame = CFrame.new(focusPos + offset, focusPos)
        end)
    end)
end

local function openComparePreview(descA, rigA, nameA, descB, rigB, nameB)
    closePreview()
    local theme = currentTheme()
    local guiParent
    pcall(function() guiParent = gethui() end)
    if not guiParent then guiParent = LocalPlayer:WaitForChild("PlayerGui") end

    previewGui = Instance.new("ScreenGui")
    previewGui.Name = "ComparePreviewGui"; previewGui.ResetOnSpawn = false; previewGui.DisplayOrder = 999
    previewGui.Parent = guiParent

    local frameA, viewportA, worldA, camA, statusA = buildPreviewFrame(previewGui, 200, -215, theme)
    local frameB, viewportB, worldB, camB, statusB = buildPreviewFrame(previewGui, 200, 15, theme)

    local labelA = Instance.new("TextLabel")
    labelA.Size = UDim2.new(1,-20,0,26); labelA.Position = UDim2.new(0,10,0,5)
    labelA.BackgroundTransparency = 1; labelA.Text = nameA; labelA.TextColor3 = theme.accent
    labelA.Font = Enum.Font.GothamBold; labelA.TextSize = 13; labelA.Parent = frameA

    local labelB = Instance.new("TextLabel")
    labelB.Size = UDim2.new(1,-20,0,26); labelB.Position = UDim2.new(0,10,0,5)
    labelB.BackgroundTransparency = 1; labelB.Text = nameB; labelB.TextColor3 = theme.accent
    labelB.Font = Enum.Font.GothamBold; labelB.TextSize = 13; labelB.Parent = frameB

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0,80,0,26); closeBtn.Position = UDim2.new(0.5,-40,0.5,190)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200,60,60); closeBtn.Text = "إغلاق"
    closeBtn.TextColor3 = Color3.new(1,1,1); closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 13
    closeBtn.Parent = previewGui
    local ccl = Instance.new("UICorner"); ccl.CornerRadius = UDim.new(0,6); ccl.Parent = closeBtn
    closeBtn.MouseButton1Click:Connect(closePreview)

    task.spawn(function()
        local modelA, rootA = loadModelIntoViewport(descA, rigA, worldA, camA, statusA)
        local modelB, rootB = loadModelIntoViewport(descB, rigB, worldB, camB, statusB)
        local angle = 0
        previewConnection = RunService.RenderStepped:Connect(function(dt)
            angle += dt * State.preview.rotationSpeed
            local dist = State.preview.distance
            if rootA then
                local off = Vector3.new(math.sin(angle)*dist, 1.5, math.cos(angle)*dist)
                local f = rootA.Position + Vector3.new(0,1.5,0)
                camA.CFrame = CFrame.new(f+off, f)
            end
            if rootB then
                local off = Vector3.new(math.sin(angle)*dist, 1.5, math.cos(angle)*dist)
                local f = rootB.Position + Vector3.new(0,1.5,0)
                camB.CFrame = CFrame.new(f+off, f)
            end
        end)
    end)
end

local mergeGui

local function closeMergeBuilder()
    if mergeGui then mergeGui:Destroy(); mergeGui = nil end
end

local function openMergeBuilder()
    closeMergeBuilder()
    local theme = currentTheme()
    local guiParent
    pcall(function() guiParent = gethui() end)
    if not guiParent then guiParent = LocalPlayer:WaitForChild("PlayerGui") end

    mergeGui = Instance.new("ScreenGui")
    mergeGui.Name = "MergeBuilderGui"; mergeGui.ResetOnSpawn = false; mergeGui.DisplayOrder = 999
    mergeGui.Parent = guiParent

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 260); frame.Position = UDim2.new(0.5, -150, 0.5, -130)
    frame.BackgroundColor3 = theme.bg; frame.BorderSizePixel = 0; frame.Parent = mergeGui
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0,10); corner.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,-40,0,32); title.Position = UDim2.new(0,10,0,5)
    title.BackgroundTransparency = 1
    title.Text = "اسحب أي بطاقة وأفلتها فوق مربع الجسم أو الملابس لتحديد مصدرها"
    title.TextColor3 = theme.accent; title.Font = Enum.Font.GothamBold; title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left; title.TextWrapped = true; title.Parent = frame

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0,24,0,24); closeBtn.Position = UDim2.new(1,-30,0,5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200,60,60); closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1,1,1); closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 12
    closeBtn.Parent = frame
    local ccl = Instance.new("UICorner"); ccl.CornerRadius = UDim.new(0,6); ccl.Parent = closeBtn
    closeBtn.MouseButton1Click:Connect(closeMergeBuilder)

    local function makeDropZone(labelText, posX, currentVal)
        local zone = Instance.new("Frame")
        zone.Size = UDim2.new(0,130,0,90); zone.Position = UDim2.new(0,posX,0,50)
        zone.BackgroundColor3 = theme.vpBg; zone.Parent = frame
        local zc = Instance.new("UICorner"); zc.CornerRadius = UDim.new(0,8); zc.Parent = zone

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1,0,0,20); lbl.Position = UDim2.new(0,0,0,4)
        lbl.BackgroundTransparency = 1; lbl.Text = labelText
        lbl.TextColor3 = Color3.fromRGB(220,220,220); lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12
        lbl.Parent = zone

        local status = Instance.new("TextLabel")
        status.Size = UDim2.new(1,-10,0,50); status.Position = UDim2.new(0,5,0,28)
        status.BackgroundTransparency = 1; status.Text = "الحالي: " .. currentVal
        status.TextColor3 = theme.accent; status.Font = Enum.Font.Gotham; status.TextSize = 11
        status.TextWrapped = true; status.Parent = zone

        return zone, status
    end

    local bodyZone, bodyStatus = makeDropZone("🧍 الجسم", 15, State.settings.mergeBodyFrom)
    local outfitZone, outfitStatus = makeDropZone("👕 الملابس", 155, State.settings.mergeOutfitFrom)

    local function isOverZone(card, zone)
        local cardCenter = card.AbsolutePosition + card.AbsoluteSize / 2
        local zp, zs = zone.AbsolutePosition, zone.AbsoluteSize
        return cardCenter.X >= zp.X and cardCenter.X <= zp.X + zs.X and cardCenter.Y >= zp.Y and cardCenter.Y <= zp.Y + zs.Y
    end

    local function makeDraggableCard(labelText, sourceValue, startPos)
        local card = Instance.new("TextButton")
        card.Size = UDim2.new(0,110,0,40); card.Position = startPos
        card.BackgroundColor3 = theme.accent; card.Text = labelText
        card.TextColor3 = Color3.new(1,1,1); card.Font = Enum.Font.GothamBold; card.TextSize = 13
        card.ZIndex = 5; card.Active = true; card.Parent = frame
        local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0,8); cc.Parent = card

        card.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            local dragStart = input.Position
            local startPosVal = card.Position

            local moveConn, endConn
            moveConn = UserInputService.InputChanged:Connect(function(moveInput)
                if moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch then
                    local delta = moveInput.Position - dragStart
                    card.Position = UDim2.new(startPosVal.X.Scale, startPosVal.X.Offset + delta.X, startPosVal.Y.Scale, startPosVal.Y.Offset + delta.Y)
                end
            end)

            endConn = UserInputService.InputEnded:Connect(function(endInput)
                if endInput.UserInputType ~= Enum.UserInputType.MouseButton1 and endInput.UserInputType ~= Enum.UserInputType.Touch then return end
                if moveConn then moveConn:Disconnect() end
                if endConn then endConn:Disconnect() end

                if isOverZone(card, bodyZone) then
                    State.settings.mergeBodyFrom = sourceValue
                    bodyStatus.Text = "الحالي: " .. sourceValue
                    notify("✔ تم الربط", "🧍 الجسم الآن من: " .. sourceValue, 2)
                elseif isOverZone(card, outfitZone) then
                    State.settings.mergeOutfitFrom = sourceValue
                    outfitStatus.Text = "الحالي: " .. sourceValue
                    notify("✔ تم الربط", "👕 الملابس الآن من: " .. sourceValue, 2)
                end

                TweenService:Create(card, TweenInfo.new(0.2), { Position = startPos }):Play()
            end)
        end)

        return card
    end

    makeDraggableCard("🎯 Target", "Target", UDim2.new(0,45,0,160))
    makeDraggableCard("🪞 Self", "Self", UDim2.new(0,165,0,160))

    local hint = Instance.new("TextLabel")
    hint.Size = UDim2.new(1,-20,0,40); hint.Position = UDim2.new(0,10,1,-45)
    hint.BackgroundTransparency = 1; hint.TextWrapped = true
    hint.Text = "اسحب Target أو Self وأفلتها على أي مربع فوق. البطاقة ترجع مكانها تلقائياً فتقدر تستخدمها للمربع الثاني."
    hint.TextColor3 = Color3.fromRGB(160,160,170); hint.Font = Enum.Font.Gotham; hint.TextSize = 10
    hint.Parent = frame
end

local function sanitizeSongId(text)
    if not text or text == "" then return nil end
    local id = string.match(text, "rbxassetid://(%d+)")
    if id then return id end
    id = string.match(text, "roblox%.com/[%a]+/(%d+)")
    if id then return id end
    local longest = ""
    for chunk in string.gmatch(text, "%d+") do
        if #chunk > #longest then longest = chunk end
    end
    if longest ~= "" then return longest end
    return nil
end

local function stopMusic()
    if State.music.sound then
        pcall(function() State.music.sound:Stop() end)
        pcall(function() State.music.sound:Destroy() end)
        State.music.sound = nil
    end
    State.music.playing = false
end

local function playMusic(id)
    stopMusic()
    local sound = Instance.new("Sound")
    sound.Name = "SA_Music"
    sound.SoundId = "rbxassetid://" .. tostring(id)
    sound.Volume = State.music.volume
    sound.Looped = true
    sound.Parent = SoundService
    local ok = pcall(function() sound:Play() end)
    if ok then
        State.music.sound = sound
        State.music.currentId = id
        State.music.playing = true
    else
        sound:Destroy()
        notify("خطأ", "تعذر تشغيل الأغنية", 3)
    end
end

local function BuildUI()
    if State.Window then pcall(function() State.Window:Destroy() end) end
    UI = {}

    local Window = Rayfield:CreateWindow({
        Name = "Skin Applier Tool - Pro", LoadingTitle = "Skin Applier Tool - Pro", LoadingSubtitle = "by jksu",
        ConfigurationSaving = { Enabled = false },
    })
    State.Window = Window

    local TabApply = Window:CreateTab("⚡ التطبيق", 4483362458)
    local TabSaved = Window:CreateTab("💾 السكنات المحفوظة", 4483362458)
    local TabQueue = Window:CreateTab("🧭 الطابور والفلاتر", 4483362458)
    local TabWatch = Window:CreateTab("👁️ المراقبة", 4483362458)
    local TabMusic = Window:CreateTab("🎵 الأغاني", 4483362458)
    local TabStats = Window:CreateTab("📊 الإحصائيات و Debug", 4483362458)

    TabApply:CreateSection("البحث والاختيار")

    TabApply:CreateInput({
        Name = "🔍 بحث عن لاعب", PlaceholderText = "اكتب اسم اللاعب...", RemoveTextAfterFocusLost = false,
        Callback = function(text)
            local allNames = getPlayerNames()
            if text == "" then UI.PlayerDropdown:Refresh(allNames, true); return end
            local filtered = {}
            local lowerText = string.lower(text)
            for _, name in ipairs(allNames) do
                if string.find(string.lower(name), lowerText, 1, true) then table.insert(filtered, name) end
            end
            if #filtered == 0 then notify("بحث", "ما فيه لاعب يطابق البحث", 2); return end
            UI.PlayerDropdown:Refresh(filtered, true)
        end,
    })

    UI.PlayerDropdown = TabApply:CreateDropdown({
        Name = "اختر لاعب من السيرفر", Options = getPlayerNames(), CurrentOption = {}, MultipleOptions = false,
        Callback = function(Option) State.selectedPlayerName = type(Option) == "table" and Option[1] or Option end,
    })

    TabApply:CreateDropdown({
        Name = "نمط تطبيق السكن (Auto / R15 / R6)", Options = { "Auto", "R15", "R6" }, CurrentOption = { State.applyRigMode }, MultipleOptions = false,
        Callback = function(Option) State.applyRigMode = type(Option)=="table" and Option[1] or Option end,
    })

    TabApply:CreateInput({
        Name = "اسم لحفظ السكن (اختياري)", PlaceholderText = "اتركه فاضي لاستخدام اسم اللاعب", RemoveTextAfterFocusLost = false,
        Callback = function(text) State.saveNameOverride = text end,
    })

    TabApply:CreateInput({
        Name = "وسم/تصنيف السكن (Tag)", PlaceholderText = "مثلاً: PVP، كاجوال، احتفال", RemoveTextAfterFocusLost = false,
        Callback = function(text) State.saveTagOverride = text end,
    })

    TabApply:CreateSection("دمج جزئي (سحب وإفلات حقيقي)")

    TabApply:CreateButton({ Name = "🧲 فتح أداة الدمج بالسحب والإفلات", Callback = openMergeBuilder })

    TabApply:CreateSection("المعاينة")

    TabApply:CreateDropdown({
        Name = "نمط الرِج بالمعاينة", Options = { "Auto", "R15", "R6" }, CurrentOption = { "Auto" }, MultipleOptions = false,
        Callback = function(Option) State.preview.rigMode = type(Option)=="table" and Option[1] or Option end,
    })
    TabApply:CreateSlider({
        Name = "سرعة دوران الكاميرا", Range = { 0, 2 }, Increment = 0.1, Suffix = "x", CurrentValue = State.preview.rotationSpeed,
        Callback = function(Value) State.preview.rotationSpeed = Value end,
    })
    TabApply:CreateSlider({
        Name = "مسافة الكاميرا", Range = { 3, 12 }, Increment = 0.5, Suffix = " studs", CurrentValue = State.preview.distance,
        Callback = function(Value) State.preview.distance = Value end,
    })
    TabApply:CreateToggle({
        Name = "▶️ تشغيل حركة المشي بالمعاينة", CurrentValue = false,
        Callback = function(Value) State.preview.playWalkAnim = Value end,
    })

    TabApply:CreateButton({
        Name = "🔍 معاينة السكن قبل التطبيق",
        Callback = function()
            if not State.selectedPlayerName then notify("تنبيه", "يرجى اختيار لاعب أولاً!", 3); return end
            local targetPlayer = Players:FindFirstChild(State.selectedPlayerName)
            if not targetPlayer then notify("خطأ", "اللاعب غير متواجد!", 3); return end
            local desc, nativeRig = getTargetDescription(targetPlayer)
            if not desc then notify("فشل", "تعذر جلب بيانات المعاينة!", 3); return end
            openPreview(desc, nativeRig, "معاينة: " .. State.selectedPlayerName)
        end,
    })

    TabApply:CreateButton({
        Name = "🎨 عرض لوحة الألوان",
        Callback = function()
            if not State.selectedPlayerName then notify("تنبيه", "اختر لاعب أولاً", 3); return end
            local targetPlayer = Players:FindFirstChild(State.selectedPlayerName)
            if not targetPlayer then return end
            local desc = getTargetDescription(targetPlayer)
            if desc then showPaletteSwatches(desc, "ألوان: " .. State.selectedPlayerName) end
        end,
    })

    TabApply:CreateSection("التطبيق")

    local function doApply()
        if State.isBusy then notify("انتظر قليلاً", "يرجى الانتظار لتجنب الـ Rate limit", 2); return end
        if not State.selectedPlayerName then notify("تنبيه", "يرجى اختيار لاعب أولاً!", 3); return end
        if isLockedByMovementState() then notify("مقفول مؤقتاً", "لا يمكن التطبيق أثناء السباحة/التسلق/السقوط الحر", 3); return end
        if needsConfirm(State.selectedPlayerName) then return end

        local targetPlayer = Players:FindFirstChild(State.selectedPlayerName)
        if not targetPlayer then notify("خطأ", "اللاعب غير متواجد!", 3); return end
        if not ensureRemote() then notify("خطأ", "لم يتم العثور على ريموت السكن!", 3); return end

        State.isBusy = true
        saveOriginalIfNeeded()

        local desc, nativeRig = getTargetDescription(targetPlayer)
        if not desc then State.isBusy = false; notify("فشل", "تعذر سحب بيانات سكن اللاعب!", 3); return end

        local targetRig = resolveRigType(State.applyRigMode, nativeRig)
        local ok, err, propertiesTable = applyWithSmartRetry(desc, targetRig, State.settings, State.selectedPlayerName)

        if ok then
            local saveName = (State.saveNameOverride ~= "" and State.saveNameOverride) or State.selectedPlayerName
            pushHistory(desc, targetRig, State.selectedPlayerName)
            saveSkin(saveName, propertiesTable, targetRig, State.saveTagOverride)
            RefreshSavedSkinsDropdown()

            State.lastAppliedProps = propertiesTable; State.lastAppliedRig = targetRig
            State.lastAppliedTarget = State.selectedPlayerName; State.lastAppliedTime = os.clock()

            reportSuccess(State.selectedPlayerName, targetRig.Name, saveName)
        else
            reportFailure(State.selectedPlayerName, err)
        end

        task.delay(State.backoff.current, function() State.isBusy = false end)
    end

    TabApply:CreateButton({ Name = "👕 تطبيق سكن اللاعب المختار", Callback = doApply })

    TabApply:CreateButton({
        Name = "🔎 فحص محلي قبل الإرسال (Dry Run)",
        Callback = function()
            if not State.selectedPlayerName then notify("تنبيه", "اختر لاعب أولاً", 3); return end
            local targetPlayer = Players:FindFirstChild(State.selectedPlayerName)
            if not targetPlayer then return end
            local desc, nativeRig = getTargetDescription(targetPlayer)
            if not desc then notify("فشل", "تعذر جلب البيانات", 3); return end
            local targetRig = resolveRigType(State.applyRigMode, nativeRig)
            local safeDesc = makeRigSafeDescription(desc, targetRig, nativeRig)
            local props = buildFinalProperties(safeDesc, targetRig, State.settings)
            safeDesc:Destroy()
            local warnings = validateProperties(props)
            if #warnings == 0 then
                notify("✔ Dry Run ناجح", "كل شي يبدو سليم، جاهز للتطبيق الفعلي", 4)
            else
                notify("⚠ Dry Run", #warnings .. " ملاحظة، شوف الـ Console للتفاصيل", 5)
                print("[Dry Run] الملاحظات:")
                for _, w in ipairs(warnings) do print(w) end
            end
        end,
    })

    TabApply:CreateToggle({ Name = "🐞 وضع Debug متقدم", CurrentValue = State.debugMode, Callback = function(Value) State.debugMode = Value end })

    TabApply:CreateButton({
        Name = "💡 أفضل تخمين لإصلاح آخر فشل",
        Callback = function()
            if not State.lastErrorRaw then notify("تنبيه", "ما فيه خطأ مسجل للتحليل", 3); return end
            local hints, settingKeys = diagnoseError(State.lastErrorRaw)
            if #settingKeys == 0 then notify("تخمين", "ما قدرت أحدد إعداد معين للتعديل تلقائياً", 3); return end
            for _, key in ipairs(settingKeys) do State.settings[key] = false end
            notify("💡 تم التعديل", "عطّلت تلقائياً: " .. table.concat(settingKeys, "، ") .. " — جرب التطبيق ثانية", 5)
        end,
    })

    TabApply:CreateSection("الحماية والتأكيد")
    TabApply:CreateParagraph({
        Title = "ملاحظة أمان",
        Content = "الأداة تمنع التطبيق أثناء السباحة/التسلق/السقوط الحر، وتطلب تأكيد ثاني لو حاولت تطبق نفس الهدف مرتين بسرعة.",
    })

    TabSaved:CreateSection("قائمة السكنات المحفوظة")

    local function tagList()
        local set = { ["الكل"] = true }
        for _, entry in pairs(State.savedSkins) do set[entry.tag or "عام"] = true end
        local list = {}
        for k, _ in pairs(set) do table.insert(list, k) end
        table.sort(list)
        return list
    end

    UI.TagFilterDropdown = TabSaved:CreateDropdown({
        Name = "فلترة حسب الوسم", Options = tagList(), CurrentOption = { "الكل" }, MultipleOptions = false,
        Callback = function(Option) State.tagFilter = type(Option)=="table" and Option[1] or Option; RefreshSavedSkinsDropdown() end,
    })

    function RefreshSavedSkinsDropdown()
        local names = {}
        for name, entry in pairs(State.savedSkins) do
            if State.tagFilter == "الكل" or (entry.tag or "عام") == State.tagFilter then table.insert(names, name) end
        end
        table.sort(names)
        if UI.SavedSkinsDropdown then UI.SavedSkinsDropdown:Refresh(names, true) end
        if UI.TagFilterDropdown then UI.TagFilterDropdown:Refresh(tagList(), true) end
    end

    UI.SavedSkinsDropdown = TabSaved:CreateDropdown({
        Name = "اختر سكن محفوظ",
        Options = (function() local n={}; for k,_ in pairs(State.savedSkins) do table.insert(n,k) end; table.sort(n); return n end)(),
        CurrentOption = {}, MultipleOptions = false,
        Callback = function(Option) State.selectedSavedSkin = type(Option)=="table" and Option[1] or Option end,
    })

    TabSaved:CreateButton({
        Name = "✅ تطبيق سكن محفوظ",
        Callback = function()
            if not State.selectedSavedSkin or not State.savedSkins[State.selectedSavedSkin] then notify("تنبيه", "يرجى اختيار سكن محفوظ أولاً", 3); return end
            if State.isBusy then notify("انتظر قليلاً", "يرجى الانتظار ثانية", 2); return end
            if isLockedByMovementState() then notify("مقفول مؤقتاً", "لا يمكن التطبيق أثناء الحركة الخاصة", 3); return end

            State.isBusy = true
            local entry = State.savedSkins[State.selectedSavedSkin]
            local rigType = Enum.HumanoidRigType[entry.rig] or Enum.HumanoidRigType.R15
            local ok, err = attemptApply(entry.props, rigType)

            if ok then
                State.lastAppliedProps = entry.props; State.lastAppliedRig = rigType
                pushLog(State.selectedSavedSkin, "نجاح", "تم تطبيق سكن محفوظ")
                reportSuccess(State.selectedSavedSkin, rigType.Name, State.selectedSavedSkin)
            else
                reportFailure(State.selectedSavedSkin, err)
            end
            task.delay(State.backoff.current, function() State.isBusy = false end)
        end,
    })

    TabSaved:CreateButton({
        Name = "🗑️ حذف السكن المحفوظ المختار",
        Callback = function()
            if not State.selectedSavedSkin or not State.savedSkins[State.selectedSavedSkin] then notify("تنبيه", "يرجى اختيار سكن محفوظ أولاً", 3); return end
            State.savedSkins[State.selectedSavedSkin] = nil
            persistSavedSkins(); RefreshSavedSkinsDropdown()
            notify("تم الحذف", "تم حذف السكن المحفوظ", 3)
            State.selectedSavedSkin = nil
        end,
    })

    TabSaved:CreateSection("أزرار سريعة (Quick Slots)")
    local quickSlotLabels = {}
    for i = 1, 4 do
        quickSlotLabels[i] = TabSaved:CreateParagraph({ Title = "سلوت " .. i, Content = State.quickSlots[i] or "فارغ" })
        TabSaved:CreateButton({
            Name = "⭐ سلوت " .. i,
            Callback = function()
                if State.quickSlots[i] then
                    local entry = State.savedSkins[State.quickSlots[i]]
                    if not entry then notify("خطأ", "السكن المحفوظ بهذا السلوت ما عاد موجود", 3); return end
                    if State.isBusy then return end
                    State.isBusy = true
                    local rigType = Enum.HumanoidRigType[entry.rig] or Enum.HumanoidRigType.R15
                    local ok, err = attemptApply(entry.props, rigType)
                    if ok then reportSuccess(State.quickSlots[i], rigType.Name, State.quickSlots[i])
                    else reportFailure(State.quickSlots[i], err) end
                    task.delay(State.backoff.current, function() State.isBusy = false end)
                else
                    if not State.selectedSavedSkin then notify("تنبيه", "اختر سكن من القائمة فوق ثم اضغط سلوت فاضي لربطه", 4); return end
                    State.quickSlots[i] = State.selectedSavedSkin
                    pcall(function() quickSlotLabels[i]:Set({ Title = "سلوت " .. i, Content = State.quickSlots[i] }) end)
                    notify("تم الحفظ", "تم ربط سلوت " .. i .. " بسكن: " .. State.selectedSavedSkin, 4)
                end
            end,
        })
    end

    TabSaved:CreateSection("دفتر الأزياء (Look Book)")
    TabSaved:CreateButton({
        Name = "📚 حفظ دفتر أزياء لكل اللاعبين الحاليين",
        Callback = function()
            local count = 0
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    local desc, rig = getTargetDescription(plr)
                    if desc then
                        local props = buildPropertiesTable(desc, rig, State.settings)
                        saveSkin(plr.Name .. "_LookBook_" .. nowStamp(), props, rig, "LookBook")
                        count += 1
                    end
                end
            end
            persistSavedSkins(); RefreshSavedSkinsDropdown()
            notify("📚 دفتر الأزياء", "تم حفظ " .. count .. " سكن من اللاعبين الحاليين", 4)
        end,
    })

    TabSaved:CreateSection("التصدير/الاستيراد والمشاركة")
    TabSaved:CreateButton({
        Name = "⬆️ تصدير كل السكنات (JSON)",
        Callback = function()
            local ok, json = pcall(function() return HttpService:JSONEncode(State.savedSkins) end)
            if not ok then notify("خطأ", "فشل التصدير", 3); return end
            local copied = false
            pcall(function() setclipboard(json); copied = true end)
            notify(copied and "تم النسخ" or "تعذر النسخ", copied and "تم نسخ كل السكنات كـ JSON للحافظة" or "شوف الـ Console", 4)
            if not copied then print(json) end
        end,
    })
    TabSaved:CreateInput({
        Name = "⬇️ استيراد سكنات (الصق JSON هنا)", PlaceholderText = "الصق نص JSON ثم اضغط Enter", RemoveTextAfterFocusLost = true,
        Callback = function(text)
            if text == "" then return end
            local ok, decoded = pcall(function() return HttpService:JSONDecode(text) end)
            if not ok or type(decoded) ~= "table" then notify("خطأ", "الـ JSON غير صالح", 3); return end
            local count = 0
            for name, entry in pairs(decoded) do State.savedSkins[name] = entry; count += 1 end
            persistSavedSkins(); RefreshSavedSkinsDropdown()
            notify("✔ تم الاستيراد", "تم استيراد " .. count .. " سكن", 4)
        end,
    })
    TabSaved:CreateButton({
        Name = "📦 تصدير كود مضغوط للسكن المختار",
        Callback = function()
            if not State.selectedSavedSkin or not State.savedSkins[State.selectedSavedSkin] then notify("تنبيه", "اختر سكن محفوظ أولاً", 3); return end
            local ok, json = pcall(function() return HttpService:JSONEncode(State.savedSkins[State.selectedSavedSkin]) end)
            if not ok then return end
            local code = HttpService:Base64Encode(json)
            local copied = false
            pcall(function() setclipboard(code); copied = true end)
            notify(copied and "تم النسخ" or "تعذر النسخ", copied and "كود المشاركة بالحافظة، أرسله لصديقك" or "شوف الـ Console", 4)
            if not copied then print(code) end
        end,
    })
    TabSaved:CreateInput({
        Name = "استيراد كود سكن مشارك", PlaceholderText = "الصق الكود المضغوط هنا", RemoveTextAfterFocusLost = true,
        Callback = function(code)
            if code == "" then return end
            local ok, entry = pcall(function() return HttpService:JSONDecode(HttpService:Base64Decode(code)) end)
            if not ok or type(entry) ~= "table" then notify("خطأ", "كود غير صالح", 3); return end
            local name = "مستورد_" .. nowStamp()
            State.savedSkins[name] = entry
            persistSavedSkins(); RefreshSavedSkinsDropdown()
            notify("✔ تم", "تم استيراد السكن باسم: " .. name, 4)
        end,
    })

    TabSaved:CreateSection("سجل النسخ (Version History)")
    TabSaved:CreateButton({
        Name = "↩️ استرجاع نسخة سابقة",
        Callback = function()
            if not State.selectedSavedSkin then notify("تنبيه", "اختر سكن محفوظ أولاً", 3); return end
            local versions = State.versions[State.selectedSavedSkin]
            if not versions or #versions == 0 then notify("تنبيه", "ما فيه نسخ سابقة لهذا السكن", 3); return end
            local latest = versions[1]
            table.remove(versions, 1)
            State.savedSkins[State.selectedSavedSkin] = latest
            persistSavedSkins(); persistVersions()
            notify("↩️ تم الاسترجاع", "تم استرجاع نسخة سابقة من: " .. State.selectedSavedSkin, 4)
        end,
    })

    TabSaved:CreateButton({
        Name = "📊 مقارنة نصية (Diff) بين المحفوظ واللاعب المختار",
        Callback = function()
            if not State.selectedSavedSkin or not State.selectedPlayerName then notify("تنبيه", "اختر سكن محفوظ ولاعب من تاب التطبيق أولاً", 4); return end
            local targetPlayer = Players:FindFirstChild(State.selectedPlayerName)
            if not targetPlayer then return end
            local desc, rig = getTargetDescription(targetPlayer)
            if not desc then return end
            local liveProps = buildFinalProperties(desc, rig, State.settings)
            local savedProps = State.savedSkins[State.selectedSavedSkin].props
            local diffs = computeDiff(savedProps, liveProps)
            if #diffs == 0 then
                notify("Diff", "لا فرق بين السكنين", 3)
            else
                notify("Diff", #diffs .. " فرق موجود، شوف الـ Console", 4)
                print("[Diff View]")
                for _, d in ipairs(diffs) do print(d) end
            end
        end,
    })

    TabSaved:CreateButton({
        Name = "🆚 معاينة مقارنة A/B (السكن المحفوظ ضد اللاعب المختار)",
        Callback = function()
            if not State.selectedSavedSkin or not State.selectedPlayerName then notify("تنبيه", "اختر سكن محفوظ ولاعب أولاً", 4); return end
            local targetPlayer = Players:FindFirstChild(State.selectedPlayerName)
            if not targetPlayer then return end

            local descA, rigA = getTargetDescription(targetPlayer)
            if not descA then notify("فشل", "تعذر جلب بيانات اللاعب", 3); return end

            local savedEntry = State.savedSkins[State.selectedSavedSkin]
            local descB = reconstructDescriptionFromProps(savedEntry.props)
            local rigB = Enum.HumanoidRigType[savedEntry.rig] or Enum.HumanoidRigType.R15
            if not descB then notify("فشل", "تعذر إعادة بناء السكن المحفوظ للمعاينة", 3); return end

            openComparePreview(descA, rigA, State.selectedPlayerName, descB, rigB, State.selectedSavedSkin)
        end,
    })

    TabQueue:CreateSection("طابور التطبيق")

    UI.QueueDropdown = TabQueue:CreateDropdown({
        Name = "اختر عدة لاعبين للطابور", Options = getPlayerNames(), CurrentOption = {}, MultipleOptions = true,
        Callback = function(Options) State.queueSelected = type(Options) == "table" and Options or { Options } end,
    })

    TabQueue:CreateButton({
        Name = "▶️ تشغيل الطابور",
        Callback = function()
            if #State.queueSelected == 0 then notify("تنبيه", "اختر لاعبين للطابور أولاً", 3); return end
            if State.isBusy then notify("انتظر", "الأداة مشغولة حالياً", 2); return end

            task.spawn(function()
                State.isBusy = true
                local successCount, failCount = 0, 0
                for _, playerName in ipairs(State.queueSelected) do
                    local targetPlayer = Players:FindFirstChild(playerName)
                    if targetPlayer and not isLockedByMovementState() then
                        local desc, nativeRig = getTargetDescription(targetPlayer)
                        if desc then
                            local targetRig = resolveRigType(State.applyRigMode, nativeRig)
                            local ok, err, props = applyWithSmartRetry(desc, targetRig, State.settings, playerName)
                            if ok then
                                successCount += 1
                                saveSkin(playerName, props, targetRig, "Queue")
                                pushLog(playerName, "نجاح", "طبّق من الطابور")
                            else
                                failCount += 1
                                pushLog(playerName, "فشل", tostring(err))
                            end
                        else
                            failCount += 1
                        end
                    else
                        failCount += 1
                    end
                    task.wait(State.backoff.current)
                end
                RefreshSavedSkinsDropdown()
                State.isBusy = false
                notify("✔ انتهى الطابور", "نجح: " .. successCount .. " | فشل: " .. failCount, 5)
            end)
        end,
    })

    TabQueue:CreateSection("فلاتر اللاعبين")
    TabQueue:CreateToggle({
        Name = "إظهار من انضم آخر 5 دقائق فقط", CurrentValue = false,
        Callback = function(Value)
            local names = getPlayerNames(Value)
            if UI.PlayerDropdown then UI.PlayerDropdown:Refresh(names, true) end
            if UI.QueueDropdown then UI.QueueDropdown:Refresh(names, true) end
        end,
    })

    TabQueue:CreateSection("القائمة البيضاء/السوداء")
    TabQueue:CreateDropdown({
        Name = "وضع الفلترة", Options = { "None", "Whitelist", "Blacklist" }, CurrentOption = { "None" }, MultipleOptions = false,
        Callback = function(Option) State.filterMode = type(Option)=="table" and Option[1] or Option; RefreshAllPlayerDropdowns() end,
    })
    TabQueue:CreateInput({
        Name = "أسماء (مفصولة بفاصلة) للقائمة", PlaceholderText = "name1, name2, name3", RemoveTextAfterFocusLost = false,
        Callback = function(text)
            State.filterNames = {}
            for name in string.gmatch(text, "([^,]+)") do
                table.insert(State.filterNames, string.lower(string.gsub(name, "^%s*(.-)%s*$", "%1")))
            end
            RefreshAllPlayerDropdowns()
        end,
    })

    TabWatch:CreateSection("وضع المراقبة")
    TabWatch:CreateParagraph({ Title = "ملاحظة", Content = "المراقبة تستخدم اللاعب المختار حالياً بتاب التطبيق كهدف." })
    TabWatch:CreateToggle({
        Name = "تفعيل مراقبة اللاعب المختار", CurrentValue = State.watchEnabled,
        Callback = function(Value)
            State.watchEnabled = Value
            State.watchTarget = State.selectedPlayerName
            State.watchSignature = nil
        end,
    })
    TabWatch:CreateToggle({ Name = "مزامنة تلقائية (تطبيق تلقائي عند التغيّر)", CurrentValue = State.watchAutoSync, Callback = function(Value) State.watchAutoSync = Value end })

    TabWatch:CreateSection("إعادة تطبيق تلقائي بعد الموت")
    TabWatch:CreateToggle({ Name = "إعادة تطبيق تلقائي بعد الموت", CurrentValue = State.respawnAutoApply, Callback = function(Value) State.respawnAutoApply = Value end })

    TabWatch:CreateSection("صحة الاتصال بالريموت")
    UI.RemoteHealthLabel = TabWatch:CreateParagraph({ Title = "الحالة", Content = State.remoteHealthy and "🟢 متصل" or "🔴 يبحث عن الريموت..." })

    TabMusic:CreateSection("تشغيل الأغاني")

    TabMusic:CreateInput({
        Name = "أدخل ID الأغنية أو الرابط",
        PlaceholderText = "مثال: 1836617658 أو رابط roblox.com/library/...",
        RemoveTextAfterFocusLost = false,
        Callback = function(text)
            local id = sanitizeSongId(text)
            if not id then notify("خطأ", "ما قدرت ألقى رقم ID صحيح بالنص المدخل", 3); return end
            State.music.currentId = id
            notify("تم التحديد", "ID المحدد الآن: " .. id, 3)
        end,
    })

    UI.MusicDropdown = TabMusic:CreateDropdown({
        Name = "الأغاني المحفوظة", Options = State.music.savedIds, CurrentOption = {}, MultipleOptions = false,
        Callback = function(Option)
            local id = type(Option) == "table" and Option[1] or Option
            State.music.currentId = id
            if State.music.playing then playMusic(id) end
        end,
    })

    TabMusic:CreateToggle({
        Name = "▶️ تشغيل/إيقاف الأغنية", CurrentValue = State.music.playing,
        Callback = function(Value)
            if Value then
                if not State.music.currentId then
                    notify("تنبيه", "أدخل أو اختر ID أغنية أولاً", 3)
                    return
                end
                playMusic(State.music.currentId)
                if not table.find(State.music.savedIds, State.music.currentId) then
                    table.insert(State.music.savedIds, State.music.currentId)
                    persistMusic()
                    if UI.MusicDropdown then UI.MusicDropdown:Refresh(State.music.savedIds, true) end
                end
            else
                stopMusic()
            end
        end,
    })

    TabMusic:CreateSlider({
        Name = "مستوى الصوت", Range = { 0.1, 10 }, Increment = 0.1, Suffix = "x", CurrentValue = State.music.volume,
        Callback = function(Value)
            State.music.volume = Value
            if State.music.sound then State.music.sound.Volume = Value end
        end,
    })

    TabMusic:CreateButton({
        Name = "🗑️ حذف الأغنية المختارة من القائمة",
        Callback = function()
            if not State.music.currentId then notify("تنبيه", "اختر أغنية أولاً", 3); return end
            local idx = table.find(State.music.savedIds, State.music.currentId)
            if idx then
                table.remove(State.music.savedIds, idx)
                persistMusic()
                if UI.MusicDropdown then UI.MusicDropdown:Refresh(State.music.savedIds, true) end
                notify("تم الحذف", "تم حذف الأغنية من القائمة", 3)
            end
        end,
    })

    TabStats:CreateSection("إحصائيات الاستخدام")

    TabStats:CreateButton({
        Name = "📊 عرض الإحصائيات",
        Callback = function()
            local lines = { "إجمالي ناجح: " .. State.stats.totalApplied, "إجمالي فاشل: " .. State.stats.totalFailed, "" }
            for name, count in pairs(State.stats.perSkin) do table.insert(lines, name .. ": " .. count .. " مرة") end
            print("[إحصائيات الاستخدام]")
            print(table.concat(lines, "\n"))
            notify("📊 الإحصائيات", "ناجح: " .. State.stats.totalApplied .. " | فاشل: " .. State.stats.totalFailed .. " (التفاصيل بالـ Console)", 5)
        end,
    })

    TabStats:CreateSection("السجل والتشخيص")

    local function doUndo()
        if #State.history < 2 then notify("تنبيه", "ما فيه خطوة سابقة للتراجع إليها", 3); return end
        if State.isBusy then notify("انتظر قليلاً", "يرجى الانتظار ثانية", 2); return end
        State.isBusy = true
        table.remove(State.history)
        local previous = State.history[#State.history]
        local fullSettings = { includeTopClothing=true, includeBottomClothing=true, includeShoes=true, includeFaceLayered=true, applyAnimations=true, applyColors=true, applyScales=true }
        local propertiesTable = buildPropertiesTable(previous.desc, previous.rigType, fullSettings)
        local ok, err = attemptApply(propertiesTable, previous.rigType)
        if ok then
            pushLog(previous.label, "نجاح", "تم التراجع لهذه الحالة")
            notify("تم التراجع", "رجعت لسكن: " .. tostring(previous.label), 3)
        else
            reportFailure("تراجع", err)
        end
        task.delay(State.backoff.current, function() State.isBusy = false end)
    end
    TabStats:CreateButton({ Name = "⏪ تراجع خطوة واحدة", Callback = doUndo })

    local function doRestoreOriginal()
        if not State.hasSavedOriginal or not State.originalDescription then notify("تنبيه", "ما فيه شكل أصلي محفوظ بعد", 3); return end
        if State.isBusy then notify("انتظر قليلاً", "يرجى الانتظار ثانية", 2); return end
        State.isBusy = true
        local fullSettings = { includeTopClothing=true, includeBottomClothing=true, includeShoes=true, includeFaceLayered=true, applyAnimations=true, applyColors=true, applyScales=true }
        local propertiesTable = buildPropertiesTable(State.originalDescription, State.originalRigType, fullSettings)
        local ok, err = attemptApply(propertiesTable, State.originalRigType)
        if ok then
            pushLog("شكلي الأصلي", "نجاح", "تم الاسترجاع")
            notify("تم", "تم استرجاع شكلك الأصلي", 3)
        else
            reportFailure("استرجاع الشكل الأصلي", err)
        end
        task.delay(State.backoff.current, function() State.isBusy = false end)
    end
    TabStats:CreateButton({ Name = "↩️ استرجاع شكلي الأصلي", Callback = doRestoreOriginal })

    TabStats:CreateButton({
        Name = "📋 نسخ السجل الكامل للحافظة",
        Callback = function()
            if #State.log == 0 then notify("تنبيه", "السجل فاضي حالياً", 3); return end
            local lines = {}
            for _, entry in ipairs(State.log) do
                table.insert(lines, string.format("[%s] %s - %s: %s", entry.time, entry.target, entry.status, entry.message))
            end
            local fullText = table.concat(lines, "\n")
            local copied = false
            pcall(function() setclipboard(fullText); copied = true end)
            notify(copied and "تم النسخ" or "تعذر النسخ", copied and ("تم نسخ آخر " .. #State.log .. " عملية") or "شوف الـ Console", 3)
            if not copied then print(fullText) end
        end,
    })

    TabStats:CreateButton({
        Name = "📄 نسخ آخر خطأ خام",
        Callback = function()
            if not State.lastErrorRaw then notify("تنبيه", "ما فيه أي خطأ مسجل بعد", 3); return end
            local copied = false
            pcall(function() setclipboard(State.lastErrorRaw); copied = true end)
            notify(copied and "تم النسخ" or "تعذر النسخ", copied and "تم نسخ آخر خطأ خام" or "شوف الـ Console", 3)
        end,
    })
end

BuildUI()
