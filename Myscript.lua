--// PLAYERS PANEL (Friends/Followers + Applied Skins) — v4 //--
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// THEME //--
local THEME = {
    Bg        = Color3.fromRGB(18, 17, 23),
    Panel     = Color3.fromRGB(26, 24, 33),
    Header    = Color3.fromRGB(22, 20, 28),
    Row       = Color3.fromRGB(32, 29, 40),
    RowAlt    = Color3.fromRGB(36, 33, 45),
    Accent    = Color3.fromRGB(150, 80, 240),
    AccentDim = Color3.fromRGB(95, 60, 165),
    Text      = Color3.fromRGB(235, 232, 245),
    SubText   = Color3.fromRGB(150, 145, 170),
    Error     = Color3.fromRGB(235, 90, 90),
    Success   = Color3.fromRGB(90, 210, 140),
    Verified  = Color3.fromRGB(70, 150, 235),
}

--// HTTP ABSTRACTION //--
local reqFunc = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)

local function httpGet(url)
    if reqFunc then
        local ok, res = pcall(reqFunc, {Url = url, Method = "GET"})
        if ok and res then
            if res.StatusCode == 200 then return true, res.Body end
            if res.StatusCode == 429 then return false, "RATE_LIMITED" end
            return false, "HTTP_" .. tostring(res.StatusCode)
        end
        return false, "REQUEST_FAILED"
    else
        local ok, body = pcall(game.HttpGet, game, url)
        if ok then return true, body end
        return false, "HTTPGET_FAILED"
    end
end

local function httpPost(url, bodyTbl)
    if not reqFunc then return false, "POST_UNSUPPORTED" end
    local ok, res = pcall(reqFunc, {
        Url = url,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode(bodyTbl),
    })
    if ok and res then
        if res.StatusCode == 200 then return true, res.Body end
        if res.StatusCode == 429 then return false, "RATE_LIMITED" end
        return false, "HTTP_" .. tostring(res.StatusCode)
    end
    return false, "REQUEST_FAILED"
end

local function safeDecode(body)
    local ok, decoded = pcall(HttpService.JSONDecode, HttpService, body)
    if ok then return decoded end
    return nil
end

local function escapeRich(text)
    text = tostring(text or "")
    text = text:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;")
    return text
end

--// RESOLVE USERNAME -> USERID //--
local function resolveUserId(input)
    input = input:gsub("^%s+", ""):gsub("%s+$", "")
    if tonumber(input) then return true, tonumber(input) end

    local ok, body = httpPost("https://users.roblox.com/v1/usernames/users", {
        usernames = {input},
        excludeBannedUsers = false,
    })
    if not ok then return false, body end

    local decoded = safeDecode(body)
    if decoded and decoded.data and decoded.data[1] then
        return true, decoded.data[1].id
    end
    return false, "USER_NOT_FOUND"
end

--// FETCH RAW ID LISTS //--
local function isValidId(id)
    return type(id) == "number" and id >= 1
end

local function getFriendIds(userId)
    local ids = {}
    local ok, body = httpGet("https://friends.roblox.com/v1/users/" .. userId .. "/friends")
    if ok then
        local decoded = safeDecode(body)
        if decoded and decoded.data then
            for _, e in ipairs(decoded.data) do
                if isValidId(e.id) then table.insert(ids, e.id) end
            end
        end
    end
    return ids
end

local function getFollowerIds(userId, target, onProgress)
    local ids = {}
    local cursor = ""
    local base = "https://friends.roblox.com/v1/users/" .. userId .. "/followers?limit=100&sortOrder=Desc"
    local retries = 0

    while #ids < target do
        local url = base .. (cursor ~= "" and ("&cursor=" .. cursor) or "")
        local ok, body = httpGet(url)

        if not ok then
            if body == "RATE_LIMITED" and retries < 5 then
                retries += 1
                task.wait(1.5 * retries)
            else
                break
            end
        else
            retries = 0
            local decoded = safeDecode(body)
            if not decoded or not decoded.data then break end

            for _, e in ipairs(decoded.data) do
                if isValidId(e.id) then
                    table.insert(ids, e.id)
                    if #ids >= target then break end
                end
            end
            if onProgress then onProgress(#ids) end

            if decoded.nextPageCursor and decoded.nextPageCursor ~= "" and #ids < target then
                cursor = decoded.nextPageCursor
                task.wait(0.3)
            else
                break
            end
        end
    end
    return ids
end

--// BATCH RESOLVE NAMES (+ verified badge) //--
local function batchResolveNames(ids, onProgress)
    local resolved = {}
    local chunkSize = 100
    local total = #ids

    for i = 1, total, chunkSize do
        local chunk = {}
        for j = i, math.min(i + chunkSize - 1, total) do
            table.insert(chunk, ids[j])
        end

        local attempts = 0
        while attempts < 4 do
            local ok, body = httpPost("https://users.roblox.com/v1/users", {
                userIds = chunk,
                excludeBannedUsers = false,
            })
            if ok then
                local decoded = safeDecode(body)
                if decoded and decoded.data then
                    for _, u in ipairs(decoded.data) do
                        resolved[u.id] = {
                            Name = (u.name and u.name ~= "") and u.name or ("id_" .. tostring(u.id)),
                            DisplayName = (u.displayName and u.displayName ~= "") and u.displayName or "?",
                            Verified = u.hasVerifiedBadge == true,
                        }
                    end
                end
                break
            elseif body == "RATE_LIMITED" then
                attempts += 1
                task.wait(1.5 * attempts)
            else
                break
            end
        end

        if onProgress then onProgress(math.min(i + chunkSize - 1, total), total) end
        task.wait(0.25)
    end
    return resolved
end

--// PERSISTENCE (Applied Skins list survives leaving/rejoining) //--
local SAVE_FOLDER = "PlayerListUI"
local SAVE_FILE = SAVE_FOLDER .. "/applied.json"
local canPersist = (writefile ~= nil) and (readfile ~= nil) and (isfile ~= nil)

local function ensureFolder()
    if makefolder then pcall(makefolder, SAVE_FOLDER) end
end

local function loadAppliedFile()
    if not canPersist then return {} end
    local ok, exists = pcall(isfile, SAVE_FILE)
    if ok and exists then
        local okRead, content = pcall(readfile, SAVE_FILE)
        if okRead then
            local decoded = safeDecode(content)
            if decoded then return decoded end
        end
    end
    return {}
end

local function saveAppliedFile(list)
    if not canPersist then return end
    ensureFolder()
    pcall(writefile, SAVE_FILE, HttpService:JSONEncode(list))
end

--// STATE (forward declared) //--
local status
local scrollSearch, scrollApplied
local searchFilterBox, appliedFilterBox
local currentResults = {}
local appliedList = {}
local appliedIds = {}
local renderAppliedTab
local renderSearchRows

--// APPLIED LIST HELPERS //--
local function addApplied(entry)
    if appliedIds[entry.Id] then return end
    appliedIds[entry.Id] = true
    table.insert(appliedList, 1, entry)
    saveAppliedFile(appliedList)
    if renderAppliedTab then renderAppliedTab() end
end

local function removeApplied(id)
    appliedIds[id] = nil
    for idx, e in ipairs(appliedList) do
        if e.Id == id then table.remove(appliedList, idx) break end
    end
    saveAppliedFile(appliedList)
    if renderAppliedTab then renderAppliedTab() end
end

--// APPLY SKIN //--
local function applySkin(entry)
    local evt = ReplicatedStorage:FindFirstChild("ApplyMainAvatar")
    if not evt then
        if status then
            status.Text = "ما لقيت ApplyMainAvatar بهالقيم"
            status.TextColor3 = THEME.Error
        end
        return
    end
    local ok = pcall(function()
        evt:FireServer(entry.Name)
    end)
    if ok then
        if status then
            status.Text = "تم تطبيق سكن: " .. entry.Name
            status.TextColor3 = THEME.Success
        end
        addApplied(entry)
    else
        if status then
            status.Text = "فشل تطبيق السكن"
            status.TextColor3 = THEME.Error
        end
    end
end

--// UI BUILD //--
local gui = Instance.new("ScreenGui")
gui.Name = "PlayersPanelUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = game:GetService("CoreGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 420, 0, 600)
main.Position = UDim2.new(0.5, -210, 0.5, -300)
main.BackgroundColor3 = THEME.Panel
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", main)
stroke.Color = THEME.Accent
stroke.Thickness = 1.5
stroke.Transparency = 0.35

--// HEADER //--
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 56)
header.BackgroundColor3 = THEME.Header
header.BorderSizePixel = 0
header.Parent = main
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

local headerFix = Instance.new("Frame") -- covers bottom rounded corners of header
headerFix.Size = UDim2.new(1, 0, 0, 12)
headerFix.Position = UDim2.new(0, 0, 1, -12)
headerFix.BackgroundColor3 = THEME.Header
headerFix.BorderSizePixel = 0
headerFix.ZIndex = 0
headerFix.Parent = header

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(1, -50, 0, 20)
titleLbl.Position = UDim2.new(0, 14, 0, 8)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "Players"
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextSize = 16
titleLbl.TextColor3 = THEME.Text
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.Parent = header

local subtitleLbl = Instance.new("TextLabel")
subtitleLbl.Size = UDim2.new(1, -50, 0, 16)
subtitleLbl.Position = UDim2.new(0, 14, 0, 28)
subtitleLbl.BackgroundTransparency = 1
subtitleLbl.Text = "Friends & Followers Tool"
subtitleLbl.Font = Enum.Font.Gotham
subtitleLbl.TextSize = 11
subtitleLbl.TextColor3 = THEME.SubText
subtitleLbl.TextXAlignment = Enum.TextXAlignment.Left
subtitleLbl.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 13)
closeBtn.BackgroundColor3 = THEME.Row
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13
closeBtn.TextColor3 = THEME.Text
closeBtn.Parent = header
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- draggable via header
do
    local dragging, dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    header.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

--// TOP TABS: Search / Applied //--
local tabsFrame = Instance.new("Frame")
tabsFrame.Size = UDim2.new(1, -24, 0, 32)
tabsFrame.Position = UDim2.new(0, 12, 0, 64)
tabsFrame.BackgroundColor3 = THEME.Row
tabsFrame.Parent = main
Instance.new("UICorner", tabsFrame).CornerRadius = UDim.new(0, 8)

local searchTabBtn = Instance.new("TextButton")
searchTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
searchTabBtn.BackgroundColor3 = THEME.Accent
searchTabBtn.Text = "Search"
searchTabBtn.Font = Enum.Font.GothamBold
searchTabBtn.TextSize = 12
searchTabBtn.TextColor3 = THEME.Text
searchTabBtn.Parent = tabsFrame
Instance.new("UICorner", searchTabBtn).CornerRadius = UDim.new(0, 8)

local appliedTabBtn = Instance.new("TextButton")
appliedTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
appliedTabBtn.Position = UDim2.new(0.5, 0, 0, 0)
appliedTabBtn.BackgroundColor3 = THEME.Row
appliedTabBtn.Text = "Applied Skins"
appliedTabBtn.Font = Enum.Font.GothamBold
appliedTabBtn.TextSize = 12
appliedTabBtn.TextColor3 = THEME.SubText
appliedTabBtn.Parent = tabsFrame
Instance.new("UICorner", appliedTabBtn).CornerRadius = UDim.new(0, 8)

--// CONTENT AREA //--
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -24, 1, -112)
contentFrame.Position = UDim2.new(0, 12, 0, 104)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = main

--// SEARCH PANEL //--
local searchPanel = Instance.new("Frame")
searchPanel.Size = UDim2.new(1, 0, 1, 0)
searchPanel.BackgroundTransparency = 1
searchPanel.Visible = true
searchPanel.Parent = contentFrame

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, 0, 0, 32)
inputBox.Position = UDim2.new(0, 0, 0, 0)
inputBox.BackgroundColor3 = THEME.Row
inputBox.PlaceholderText = "Username or UserId"
inputBox.Text = ""
inputBox.Font = Enum.Font.Gotham
inputBox.TextSize = 13
inputBox.TextColor3 = THEME.Text
inputBox.PlaceholderColor3 = THEME.SubText
inputBox.ClearTextOnFocus = false
inputBox.Parent = searchPanel
Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 6)

local mode = "Followers"
local toggleFrame = Instance.new("Frame")
toggleFrame.Size = UDim2.new(1, 0, 0, 30)
toggleFrame.Position = UDim2.new(0, 0, 0, 40)
toggleFrame.BackgroundColor3 = THEME.Row
toggleFrame.Parent = searchPanel
Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 6)

local friendsBtn = Instance.new("TextButton")
friendsBtn.Size = UDim2.new(0.5, 0, 1, 0)
friendsBtn.BackgroundColor3 = THEME.Row
friendsBtn.Text = "Friends"
friendsBtn.Font = Enum.Font.GothamBold
friendsBtn.TextSize = 12
friendsBtn.TextColor3 = THEME.SubText
friendsBtn.Parent = toggleFrame
Instance.new("UICorner", friendsBtn).CornerRadius = UDim.new(0, 6)

local followersBtn = Instance.new("TextButton")
followersBtn.Size = UDim2.new(0.5, 0, 1, 0)
followersBtn.Position = UDim2.new(0.5, 0, 0, 0)
followersBtn.BackgroundColor3 = THEME.Accent
followersBtn.Text = "Followers"
followersBtn.Font = Enum.Font.GothamBold
followersBtn.TextSize = 12
followersBtn.TextColor3 = THEME.Text
followersBtn.Parent = toggleFrame
Instance.new("UICorner", followersBtn).CornerRadius = UDim.new(0, 6)

local function setMode(m)
    mode = m
    if m == "Friends" then
        friendsBtn.BackgroundColor3 = THEME.Accent
        friendsBtn.TextColor3 = THEME.Text
        followersBtn.BackgroundColor3 = THEME.Row
        followersBtn.TextColor3 = THEME.SubText
    else
        followersBtn.BackgroundColor3 = THEME.Accent
        followersBtn.TextColor3 = THEME.Text
        friendsBtn.BackgroundColor3 = THEME.Row
        friendsBtn.TextColor3 = THEME.SubText
    end
end
friendsBtn.MouseButton1Click:Connect(function() setMode("Friends") end)
followersBtn.MouseButton1Click:Connect(function() setMode("Followers") end)

local targetBox = Instance.new("TextBox")
targetBox.Size = UDim2.new(0, 100, 0, 30)
targetBox.Position = UDim2.new(0, 0, 0, 78)
targetBox.BackgroundColor3 = THEME.Row
targetBox.PlaceholderText = "Target"
targetBox.Text = "1000"
targetBox.Font = Enum.Font.Gotham
targetBox.TextSize = 12
targetBox.TextColor3 = THEME.Text
targetBox.Parent = searchPanel
Instance.new("UICorner", targetBox).CornerRadius = UDim.new(0, 6)

local fetchBtn = Instance.new("TextButton")
fetchBtn.Size = UDim2.new(1, -112, 0, 30)
fetchBtn.Position = UDim2.new(0, 112, 0, 78)
fetchBtn.BackgroundColor3 = THEME.Accent
fetchBtn.Text = "Fetch"
fetchBtn.Font = Enum.Font.GothamBold
fetchBtn.TextSize = 13
fetchBtn.TextColor3 = THEME.Text
fetchBtn.Parent = searchPanel
Instance.new("UICorner", fetchBtn).CornerRadius = UDim.new(0, 6)

status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 16)
status.Position = UDim2.new(0, 0, 0, 112)
status.BackgroundTransparency = 1
status.Text = ""
status.Font = Enum.Font.Gotham
status.TextSize = 11
status.TextColor3 = THEME.SubText
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = searchPanel

local copyAllBtn = Instance.new("TextButton")
copyAllBtn.Size = UDim2.new(1, 0, 0, 24)
copyAllBtn.Position = UDim2.new(0, 0, 0, 132)
copyAllBtn.BackgroundColor3 = THEME.Row
copyAllBtn.Text = "Copy All Results"
copyAllBtn.Font = Enum.Font.Gotham
copyAllBtn.TextSize = 11
copyAllBtn.TextColor3 = THEME.SubText
copyAllBtn.Parent = searchPanel
Instance.new("UICorner", copyAllBtn).CornerRadius = UDim.new(0, 6)

searchFilterBox = Instance.new("TextBox")
searchFilterBox.Size = UDim2.new(1, 0, 0, 30)
searchFilterBox.Position = UDim2.new(0, 0, 0, 162)
searchFilterBox.BackgroundColor3 = THEME.Row
searchFilterBox.PlaceholderText = "Search players..."
searchFilterBox.Text = ""
searchFilterBox.Font = Enum.Font.Gotham
searchFilterBox.TextSize = 12
searchFilterBox.TextColor3 = THEME.Text
searchFilterBox.PlaceholderColor3 = THEME.SubText
searchFilterBox.ClearTextOnFocus = false
searchFilterBox.Parent = searchPanel
Instance.new("UICorner", searchFilterBox).CornerRadius = UDim.new(0, 6)

scrollSearch = Instance.new("ScrollingFrame")
scrollSearch.Size = UDim2.new(1, 0, 1, -198)
scrollSearch.Position = UDim2.new(0, 0, 0, 198)
scrollSearch.BackgroundColor3 = THEME.Bg
scrollSearch.BorderSizePixel = 0
scrollSearch.ScrollBarThickness = 4
scrollSearch.ScrollBarImageColor3 = THEME.Accent
scrollSearch.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollSearch.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollSearch.Parent = searchPanel
Instance.new("UICorner", scrollSearch).CornerRadius = UDim.new(0, 8)

local searchListLayout = Instance.new("UIListLayout", scrollSearch)
searchListLayout.SortOrder = Enum.SortOrder.LayoutOrder
searchListLayout.Padding = UDim.new(0, 3)

--// APPLIED PANEL //--
local appliedPanel = Instance.new("Frame")
appliedPanel.Size = UDim2.new(1, 0, 1, 0)
appliedPanel.BackgroundTransparency = 1
appliedPanel.Visible = false
appliedPanel.Parent = contentFrame

appliedFilterBox = Instance.new("TextBox")
appliedFilterBox.Size = UDim2.new(1, 0, 0, 30)
appliedFilterBox.Position = UDim2.new(0, 0, 0, 0)
appliedFilterBox.BackgroundColor3 = THEME.Row
appliedFilterBox.PlaceholderText = "Search applied players..."
appliedFilterBox.Text = ""
appliedFilterBox.Font = Enum.Font.Gotham
appliedFilterBox.TextSize = 12
appliedFilterBox.TextColor3 = THEME.Text
appliedFilterBox.PlaceholderColor3 = THEME.SubText
appliedFilterBox.ClearTextOnFocus = false
appliedFilterBox.Parent = appliedPanel
Instance.new("UICorner", appliedFilterBox).CornerRadius = UDim.new(0, 6)

local clearAllBtn = Instance.new("TextButton")
clearAllBtn.Size = UDim2.new(0, 120, 0, 26)
clearAllBtn.Position = UDim2.new(0, 0, 0, 36)
clearAllBtn.BackgroundColor3 = THEME.Row
clearAllBtn.Text = "Clear All"
clearAllBtn.Font = Enum.Font.Gotham
clearAllBtn.TextSize = 11
clearAllBtn.TextColor3 = THEME.Error
clearAllBtn.Parent = appliedPanel
Instance.new("UICorner", clearAllBtn).CornerRadius = UDim.new(0, 6)

local copyAllAppliedBtn = Instance.new("TextButton")
copyAllAppliedBtn.Size = UDim2.new(1, -128, 0, 26)
copyAllAppliedBtn.Position = UDim2.new(0, 128, 0, 36)
copyAllAppliedBtn.BackgroundColor3 = THEME.Row
copyAllAppliedBtn.Text = "Copy All Applied"
copyAllAppliedBtn.Font = Enum.Font.Gotham
copyAllAppliedBtn.TextSize = 11
copyAllAppliedBtn.TextColor3 = THEME.SubText
copyAllAppliedBtn.Parent = appliedPanel
Instance.new("UICorner", copyAllAppliedBtn).CornerRadius = UDim.new(0, 6)

scrollApplied = Instance.new("ScrollingFrame")
scrollApplied.Size = UDim2.new(1, 0, 1, -70)
scrollApplied.Position = UDim2.new(0, 0, 0, 70)
scrollApplied.BackgroundColor3 = THEME.Bg
scrollApplied.BorderSizePixel = 0
scrollApplied.ScrollBarThickness = 4
scrollApplied.ScrollBarImageColor3 = THEME.Accent
scrollApplied.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollApplied.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollApplied.Parent = appliedPanel
Instance.new("UICorner", scrollApplied).CornerRadius = UDim.new(0, 8)

local appliedListLayout = Instance.new("UIListLayout", scrollApplied)
appliedListLayout.SortOrder = Enum.SortOrder.LayoutOrder
appliedListLayout.Padding = UDim.new(0, 3)

--// TAB SWITCH LOGIC //--
local function setTab(tab)
    if tab == "Search" then
        searchPanel.Visible = true
        appliedPanel.Visible = false
        searchTabBtn.BackgroundColor3 = THEME.Accent
        searchTabBtn.TextColor3 = THEME.Text
        appliedTabBtn.BackgroundColor3 = THEME.Row
        appliedTabBtn.TextColor3 = THEME.SubText
    else
        searchPanel.Visible = false
        appliedPanel.Visible = true
        appliedTabBtn.BackgroundColor3 = THEME.Accent
        appliedTabBtn.TextColor3 = THEME.Text
        searchTabBtn.BackgroundColor3 = THEME.Row
        searchTabBtn.TextColor3 = THEME.SubText
    end
end
searchTabBtn.MouseButton1Click:Connect(function() setTab("Search") end)
appliedTabBtn.MouseButton1Click:Connect(function() setTab("Applied") end)

--// RESIZE HANDLE //--
local resizeHandle = Instance.new("TextButton")
resizeHandle.Size = UDim2.new(0, 18, 0, 18)
resizeHandle.Position = UDim2.new(1, -18, 1, -18)
resizeHandle.BackgroundColor3 = THEME.Accent
resizeHandle.Text = ""
resizeHandle.AutoButtonColor = false
resizeHandle.Parent = main
Instance.new("UICorner", resizeHandle).CornerRadius = UDim.new(0, 4)

do
    local resizing, dragStart, startSize
    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            dragStart = input.Position
            startSize = main.Size
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then resizing = false end
            end)
        end
    end)
    resizeHandle.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            local newX = math.max(360, startSize.X.Offset + delta.X)
            local newY = math.max(440, startSize.Y.Offset + delta.Y)
            main.Size = UDim2.new(0, newX, 0, newY)
        end
    end)
end

--// FLOATING TOGGLE ICON (square, rounded, black border, no text — shows/hides panel) //--
local toggleIcon = Instance.new("TextButton")
toggleIcon.Name = "PlayersPanelToggle"
toggleIcon.Size = UDim2.new(0, 46, 0, 46)
toggleIcon.Position = UDim2.new(0, 20, 0, 140)
toggleIcon.BackgroundColor3 = THEME.Accent
toggleIcon.AutoButtonColor = false
toggleIcon.Text = ""
toggleIcon.ZIndex = 10
toggleIcon.Parent = gui
Instance.new("UICorner", toggleIcon).CornerRadius = UDim.new(0, 10)

local toggleStroke = Instance.new("UIStroke", toggleIcon)
toggleStroke.Color = Color3.fromRGB(0, 0, 0)
toggleStroke.Thickness = 2
toggleStroke.Transparency = 0

do
    local dragging, dragStart, startPos, moved
    toggleIcon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            dragStart = input.Position
            startPos = toggleIcon.Position
        end
    end)
    toggleIcon.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if math.abs(delta.X) > 4 or math.abs(delta.Y) > 4 then moved = true end
            toggleIcon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    toggleIcon.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            if not moved then
                main.Visible = not main.Visible
            end
        end
    end)
end

--// SHARED ROW RENDERER //--
local function copyText(text)
    if setclipboard then
        pcall(setclipboard, text)
        status.Text = "تم النسخ: " .. text
        status.TextColor3 = THEME.SubText
    else
        print(text)
    end
end

local function makeRow(parentScroll, entry, index, buttons, showRemove)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 92)
    row.BackgroundColor3 = (index % 2 == 0) and THEME.RowAlt or THEME.Row
    row.BorderSizePixel = 0
    row.LayoutOrder = index
    row.Parent = parentScroll
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(0, 46, 0, 46)
    avatar.Position = UDim2.new(0, 4, 0, 4)
    avatar.BackgroundColor3 = THEME.Bg
    avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. entry.Id .. "&w=150&h=150"
    avatar.Parent = row
    Instance.new("UICorner", avatar).CornerRadius = UDim.new(0, 8)

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, showRemove and -82 or -58, 0, 18)
    nameLbl.Position = UDim2.new(0, 56, 0, 2)
    nameLbl.BackgroundTransparency = 1
    nameLbl.RichText = true
    nameLbl.Text = escapeRich(entry.DisplayName) .. (entry.Verified and '  <font color="#4696EB" size="13">✔</font>' or "")
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 13
    nameLbl.TextColor3 = THEME.Text
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    nameLbl.Parent = row

    local userLbl = Instance.new("TextLabel")
    userLbl.Size = UDim2.new(1, showRemove and -82 or -58, 0, 14)
    userLbl.Position = UDim2.new(0, 56, 0, 20)
    userLbl.BackgroundTransparency = 1
    userLbl.Text = "@" .. entry.Name
    userLbl.Font = Enum.Font.Gotham
    userLbl.TextSize = 11
    userLbl.TextColor3 = THEME.SubText
    userLbl.TextXAlignment = Enum.TextXAlignment.Left
    userLbl.TextTruncate = Enum.TextTruncate.AtEnd
    userLbl.Parent = row

    if showRemove then
        local removeBtn = Instance.new("TextButton")
        removeBtn.Size = UDim2.new(0, 20, 0, 20)
        removeBtn.Position = UDim2.new(1, -24, 0, 4)
        removeBtn.BackgroundColor3 = THEME.Error
        removeBtn.Text = "✕"
        removeBtn.Font = Enum.Font.GothamBold
        removeBtn.TextSize = 11
        removeBtn.TextColor3 = THEME.Text
        removeBtn.Parent = row
        Instance.new("UICorner", removeBtn).CornerRadius = UDim.new(0, 5)
        removeBtn.MouseButton1Click:Connect(function()
            removeApplied(entry.Id)
        end)
    end

    local btnRow = Instance.new("Frame")
    btnRow.Size = UDim2.new(1, -62, 0, 48)
    btnRow.Position = UDim2.new(0, 56, 0, 38)
    btnRow.BackgroundTransparency = 1
    btnRow.Parent = row

    local btnGrid = Instance.new("UIGridLayout", btnRow)
    btnGrid.CellSize = UDim2.new(0.5, -3, 0, 22)
    btnGrid.CellPadding = UDim2.new(0, 4, 0, 4)
    btnGrid.SortOrder = Enum.SortOrder.LayoutOrder
    btnGrid.FillDirection = Enum.FillDirection.Horizontal

    for order, cfg in ipairs(buttons) do
        local b = Instance.new("TextButton")
        b.BackgroundColor3 = cfg.color or THEME.AccentDim
        b.Text = cfg.text
        b.Font = Enum.Font.Gotham
        b.TextSize = 11
        b.TextColor3 = THEME.Text
        b.LayoutOrder = order
        b.Parent = btnRow
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
        b.MouseButton1Click:Connect(cfg.onClick)
    end

    return row
end

local function clearScroll(scrollFrame)
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
end

local function searchButtonsFor(entry)
    return {
        {text = "Copy ID", onClick = function() copyText(tostring(entry.Id)) end},
        {text = "Copy User", onClick = function() copyText(entry.Name) end},
        {text = "Copy Name", onClick = function() copyText(entry.DisplayName) end},
        {text = "Apply Skin", color = THEME.Accent, onClick = function() applySkin(entry) end},
    }
end

renderSearchRows = function(list)
    clearScroll(scrollSearch)
    local query = searchFilterBox.Text:lower()
    local idx = 0
    for _, entry in ipairs(list) do
        local matches = query == "" or entry.Name:lower():find(query, 1, true) or entry.DisplayName:lower():find(query, 1, true)
        if matches then
            idx += 1
            makeRow(scrollSearch, entry, idx, searchButtonsFor(entry), false)
            if idx % 40 == 0 then task.wait() end
        end
    end
end

renderAppliedTab = function()
    clearScroll(scrollApplied)
    local query = appliedFilterBox.Text:lower()
    local idx = 0
    for _, entry in ipairs(appliedList) do
        local matches = query == "" or entry.Name:lower():find(query, 1, true) or entry.DisplayName:lower():find(query, 1, true)
        if matches then
            idx += 1
            makeRow(scrollApplied, entry, idx, searchButtonsFor(entry), true)
            if idx % 40 == 0 then task.wait() end
        end
    end
end

searchFilterBox:GetPropertyChangedSignal("Text"):Connect(function()
    renderSearchRows(currentResults)
end)

appliedFilterBox:GetPropertyChangedSignal("Text"):Connect(function()
    renderAppliedTab()
end)

--// FETCH FLOW //--
local fetching = false
fetchBtn.MouseButton1Click:Connect(function()
    if fetching then return end
    fetching = true
    fetchBtn.Text = "..."
    status.Text = "جاري التحليل..."
    status.TextColor3 = THEME.SubText
    clearScroll(scrollSearch)

    local input = inputBox.Text
    if input == "" then
        status.Text = "اكتب يوزرنيم أو UserId"
        status.TextColor3 = THEME.Error
        fetchBtn.Text = "Fetch"
        fetching = false
        return
    end

    task.spawn(function()
        local ok, userId = resolveUserId(input)
        if not ok then
            status.Text = "فشل: " .. tostring(userId)
            status.TextColor3 = THEME.Error
            fetchBtn.Text = "Fetch"
            fetching = false
            return
        end

        local ids
        if mode == "Friends" then
            status.Text = "جاري جلب قائمة الأصدقاء..."
            ids = getFriendIds(userId)
        else
            local target = tonumber(targetBox.Text) or 1000
            status.Text = "جاري جلب قائمة المتابعين..."
            ids = getFollowerIds(userId, target, function(count)
                status.Text = "جلب IDs: " .. count .. " / " .. target
            end)
        end

        if #ids == 0 then
            status.Text = "ما فيه نتائج صحيحة (قائمة خاصة أو فارغة)"
            status.TextColor3 = THEME.Error
            fetchBtn.Text = "Fetch"
            fetching = false
            return
        end

        local names = batchResolveNames(ids, function(done, total)
            status.Text = "استخراج الأسماء: " .. done .. " / " .. total
        end)

        local results = {}
        for _, id in ipairs(ids) do
            local info = names[id]
            table.insert(results, {
                Id = id,
                Name = info and info.Name or ("id_" .. tostring(id)),
                DisplayName = info and info.DisplayName or "?",
                Verified = info and info.Verified or false,
            })
        end

        currentResults = results
        renderSearchRows(currentResults)
        status.Text = "تم — الإجمالي: " .. #results
        status.TextColor3 = THEME.SubText
        fetchBtn.Text = "Fetch"
        fetching = false
    end)
end)

copyAllBtn.MouseButton1Click:Connect(function()
    if #currentResults == 0 then return end
    local lines = {}
    for _, e in ipairs(currentResults) do
        table.insert(lines, e.Name .. " | " .. e.DisplayName .. " | " .. e.Id)
    end
    local text = table.concat(lines, "\n")
    if setclipboard then
        pcall(setclipboard, text)
        status.Text = "تم نسخ " .. #currentResults .. " سطر"
    else
        print(text)
    end
end)

copyAllAppliedBtn.MouseButton1Click:Connect(function()
    if #appliedList == 0 then return end
    local lines = {}
    for _, e in ipairs(appliedList) do
        table.insert(lines, e.Name .. " | " .. e.DisplayName .. " | " .. e.Id)
    end
    local text = table.concat(lines, "\n")
    if setclipboard then
        pcall(setclipboard, text)
        status.Text = "تم نسخ قائمة الأبلايد"
    else
        print(text)
    end
end)

clearAllBtn.MouseButton1Click:Connect(function()
    appliedList = {}
    appliedIds = {}
    saveAppliedFile(appliedList)
    renderAppliedTab()
end)

--// INITIAL LOAD (persisted applied list) //--
appliedList = loadAppliedFile()
for _, e in ipairs(appliedList) do
    appliedIds[e.Id] = true
end
renderAppliedTab()




task.spawn(function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local highlights = {}
local tracers = {}

local function createHighlight(player, character)
    if highlights[player] then highlights[player]:Destroy() end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.FillColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.75
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0.5
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = character
    highlight.Parent = character
    
    highlights[player] = highlight
end

local function createTracer(player)
    if tracers[player] then tracers[player]:Remove() end
    
    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Color = Color3.fromRGB(255, 255, 255)
    tracer.Thickness = 1
    tracer.Transparency = 0.25
    
    tracers[player] = tracer
end

local function setupPlayer(player)
    if player == LocalPlayer then return end
    
    createTracer(player)
    
    if player.Character then
        createHighlight(player, player.Character)
    end
    
    player.CharacterAdded:Connect(function(character)
        createHighlight(player, character)
    end)
end

local function removePlayer(player)
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
    if tracers[player] then
        tracers[player]:Remove()
        tracers[player] = nil
    end
end

RunService.RenderStepped:Connect(function()
    local camera = workspace.CurrentCamera
    local time = tick() * 3
    local pulse = (math.sin(time) + 1) / 2
    
    local colorValue = 180 + (pulse * 75)
    local animatedColor = Color3.fromRGB(colorValue, colorValue, colorValue)
    
    local fillTransparencyPulse = 0.65 + (pulse * 0.25)
    local outlineTransparencyPulse = 0.3 + (pulse * 0.4)

    for _, highlight in pairs(highlights) do
        if highlight and highlight.Parent then
            highlight.FillTransparency = fillTransparencyPulse
            highlight.OutlineTransparency = outlineTransparencyPulse
        end
    end
    
    for player, tracer in pairs(tracers) do
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        
        if root and hum and hum.Health > 0 then
            local screenPos, onScreen = camera:WorldToViewportPoint(root.Position)
            if onScreen then
                tracer.From = Vector2.new(camera.ViewportSize.X / 2, 0)
                tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                tracer.Color = animatedColor
                tracer.Visible = true
            else
                tracer.Visible = false
            end
        else
            tracer.Visible = false
        end
    end
end)

for _, player in ipairs(Players:GetPlayers()) do
    setupPlayer(player)
end

Players.PlayerAdded:Connect(setupPlayer)
Players.PlayerRemoving:Connect(removePlayer)
end)


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
