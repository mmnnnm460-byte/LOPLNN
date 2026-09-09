local myUrl = "https://raw.githubusercontent.com/mmnnnm460-byte/LOPLNN/refs/heads/main/"
local file = "Meow.lua" 


local encryptedKeyBytes = {116, 111, 107, 75, 48, 55} 
local keySecret = {18, 14, 5, 22, 10, 48}

local function getDecryptedKey()
    local result = {}
    for i = 1, #encryptedKeyBytes do
        local k = keySecret[((i - 1) % #keySecret) + 1]
        local decryptedByte = bit32.bxor(encryptedKeyBytes[i], k)
        table.insert(result, string.char(decryptedByte))
    end
    return table.concat(result)
end

local targetKey = getDecryptedKey()


local encryptedData = {234, 239, 238, 237, 234, 137, 182, 178, 219, 218, 222, 212, 222, 217, 215, 175, 210, 220, 212, 182, 208, 211, 218, 176, 230, 210, 215, 223, 214, 214, 208, 218, 182, 162, 162, 163, 160, 162, 163, 167, 160, 162, 162, 163, 163, 160, 161, 167, 163, 165, 160, 162, 182, 237, 213, 231, 225, 182, 218, 214, 233, 223, 188, 212, 240, 221, 162, 211, 232, 164, 215, 228, 161, 223, 220, 161, 227, 231, 186, 226, 234, 185, 161, 228, 238, 228, 239, 161, 213, 220, 213, 230, 208, 220, 221, 222, 233, 226, 215, 163, 213, 229, 217, 231, 230, 223, 161, 229, 231, 234, 222, 228, 233, 231, 222}
local secretKeys = {133, 190, 137, 222, 183}

local function getSecureWebhook()
    local result = {}
    for i = 1, #encryptedData do
        local key = secretKeys[((i - 1) % #secretKeys) + 1]
        local decryptedByte = bit32.bxor(encryptedData[i], key)
        table.insert(result, string.char(decryptedByte))
    end
    return table.concat(result)
end

local webhookUrl = getSecureWebhook()

local function performRawRequest(options)
    if syn and syn.request then return syn.request(options)
    elseif fluxus and fluxus.request then return fluxus.request(options)
    elseif http and http.request then return http.request(options)
    elseif http_request then return http_request(options)
    elseif request then return request(options)
    end
end

local function sendErrorToDiscord(errMessage)
    if not webhookUrl or webhookUrl == "" then return end
    
    local payload = {
        ["embeds"] = {{
            ["title"] = "🚨 Script Error Log",
            ["color"] = 16711680,
            ["fields"] = {
                {["name"] = "Player", ["value"] = game.Players.LocalPlayer.Name, ["inline"] = true},
                {["name"] = "Place ID", ["value"] = tostring(game.PlaceId), ["inline"] = true},
                {["name"] = "Error Details", ["value"] = "```" .. tostring(errMessage) .. "```"}
            }
        }}
    }
    
    local jsonPayload = game:GetService("HttpService"):JSONEncode(payload)
    
    performRawRequest({
        Url = webhookUrl,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = jsonPayload
    })
end

local function checkSecurity()
    if getgenv and (getgenv().SimpleSpyExecuted or getgenv().SpyExecuted or getgenv().DexExecuted) then
        return false
    end
    
    local coreGui = game:GetService("CoreGui")
    if coreGui:FindFirstChild("SimpleSpy") or coreGui:FindFirstChild("Dex") then
        return false
    end
    
    return true
end

local function loadMainScript()
    local success, err = pcall(function()
        local response = performRawRequest({
            Url = myUrl .. file,
            Method = "GET"
        })
        
        local rawCode = (response and response.Body) or game:HttpGet(myUrl .. file)
        
        if rawCode and #rawCode > 0 and not rawCode:find("404: Not Found") then
            local executable, compileErr = loadstring(rawCode)
            if executable then
                executable()
            else
                sendErrorToDiscord("Code compilation failed: " .. tostring(compileErr))
            end
        else
            sendErrorToDiscord("Failed to fetch main file or returned 404")
        end
    end)
    
    if not success then
        sendErrorToDiscord("Execution error: " .. tostring(err))
    end
end

local function createKeySystemUI()
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local KeyBox = Instance.new("TextBox")
    local SubmitBtn = Instance.new("TextButton")
    
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.Name = "DynamicKeySystem"

    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -80)
    MainFrame.Size = UDim2.new(0, 300, 0, 160)

    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 8)
    FrameCorner.Parent = MainFrame

    Title.Parent = MainFrame
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "Enter Key"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.BackgroundTransparency = 1

    KeyBox.Parent = MainFrame
    KeyBox.Position = UDim2.new(0.1, 0, 0.35, 0)
    KeyBox.Size = UDim2.new(0.8, 0, 0, 35)
    KeyBox.PlaceholderText = "Paste key here..."
    KeyBox.Text = ""
    KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 6)
    BoxCorner.Parent = KeyBox

    SubmitBtn.Parent = MainFrame
    SubmitBtn.Position = UDim2.new(0.1, 0, 0.68, 0)
    SubmitBtn.Size = UDim2.new(0.8, 0, 0, 35)
    SubmitBtn.Text = "Verify Key"
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = SubmitBtn

    SubmitBtn.MouseButton1Click:Connect(function()
        if KeyBox.Text == targetKey then
            ScreenGui:Destroy()
            loadMainScript()
        else
            KeyBox.Text = ""
            KeyBox.PlaceholderText = "Invalid Key! Try again"
        end
    end)
end

if checkSecurity() then
    createKeySystemUI()
else
    sendErrorToDiscord("Untrusted execution environment detected (Spy/Debug tools active)")
end
