local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "HD Admin Panel",
    LoadingTitle = "جاري التحميل...",
    LoadingSubtitle = "by YourName",
    ConfigurationSaving = {
        Enabled = false,
    },
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EventDataService = ReplicatedStorage:WaitForChild("RemoteEvents", 10) and ReplicatedStorage.RemoteEvents:WaitForChild("DataService", 10)
local HDClientSignals = ReplicatedStorage:WaitForChild("HDAdminHDClient", 10) and ReplicatedStorage.HDAdminHDClient:WaitForChild("Signals", 10)

local EventMod = HDClientSignals and HDClientSignals:WaitForChild("RequestCommandModification", 10)
local EventCreateLog = HDClientSignals and HDClientSignals:WaitForChild("CreateLog", 10)
local EventRequestCmd = HDClientSignals and HDClientSignals:WaitForChild("RequestCommand", 10)

local function GetPlayerNames()
    local names = {}
    for _, plr in pairs(Players:GetPlayers()) do
        table.insert(names, plr.Name)
    end
    return names
end

local ActiveMainCmds = {}
local ActiveUnCmds = {}
local ActiveAllCmds = {}

local SelectedPlayer = nil

local AllCommands = {
    "feet", "farm", "popular", "sturdy", "cuteSit", "fakeDeath",
    "hide", "box", "dog", "worm", "takeTheL", "fryDance", "phase",
    "emotes", "car", "aura", "helicopter", "plane", "tank",
    "ratDance", "sit2", "hug", "bop", "applaud",
    "speed", "fast", "slow", "jumpHeight", "superJump", "heavyJump",
    "health", "heal", "god", "damage", "kill", "teleport", "to",
    "fatify", "glass", "ghost", "gold", "bigHead", "dwarf",
    "giantDwarf", "squash", "fat", "thin", "fire", "jump", "sit",
    "paint", "material", "reflectance", "transparency", "nightVision",
    "laserEyes", "ping", "cmdbar", "refresh", "respawn", "shirt", "pants",
    "hat", "clearHats", "face", "head", "name", "hideName",
    "bodyTypeScale", "depth", "headSize", "hipHeight", "potatoHead",
    "char", "cmds",
    "fly", "fly2",
    "apparate", "handTo", "title", "fling", "logs", "chatLogs",
    "ice", "jail", "buffify", "wormify", "chibify", "plushify",
    "freakify", "frogify", "spongify", "bigify", "creepify", "dinofy",
}

local UnCommands = {
    "unfeet", "unfarm", "unpopular", "unsturdy", "uncuteSit", "unfakeDeath",
    "unhide", "unbox", "undog", "unworm", "untakeTheL", "unfryDance", "unphase",
    "unemotes", "uncar", "unaura", "unhelicopter", "unplane", "untank", "unice",
    "unratDance", "unsit2", "unhug", "unbop", "unapplaud",
    "unspeed", "unfast", "unslow", "unjumpHeight", "unsuperJump", "unheavyJump",
    "unhealth", "unheal", "ungod", "undamage", "unkill", "unteleport", "unto",
    "unfatify", "unglass", "unghost", "ungold", "unbigHead", "undwarf",
    "ungiantDwarf", "unsquash", "unfat", "unthin", "unfire", "unjump", "unsit",
    "unpaint", "unmaterial", "unreflectance", "untransparency", "unnightVision",
    "unlaserEyes", "unping", "uncmdbar", "unrefresh", "unrespawn", "unshirt", "unpants",
    "unhat", "unclearHats", "unface", "unhead", "unname", "unhideName",
    "unbodyTypeScale", "undepth", "unheadSize", "unhipHeight", "unpotatoHead",
    "unchar", "uncmds",
    "unfly", "unfly2",
    "unapparate", "unhandTo", "untitle", "unfling", "unlogs", "unchatLogs",
    "unjail", "unbuffify", "unwormify", "unchibify", "unplushify",
    "unfreakify", "unfrogify", "unspongify", "unbigify", "uncreepify", "undinofy",
}

local function SendSingleCommand(cmdText)
    task.spawn(function()
        if EventRequestCmd then
            pcall(function() EventRequestCmd:InvokeServer(cmdText) end)
        end
    end)
    task.spawn(function()
        if EventDataService then
            pcall(function() EventDataService:FireServer(cmdText) end)
        end
    end)
    task.spawn(function()
        if EventMod then
            pcall(function() EventMod:InvokeServer(cmdText) end)
        end
    end)
    task.spawn(function()
        if EventCreateLog then
            pcall(function() EventCreateLog:FireServer(cmdText) end)
        end
    end)
end

task.spawn(function()
    while true do
        if SelectedPlayer and SelectedPlayer ~= "اختر لاعب" then
            for cmd, _ in pairs(ActiveMainCmds) do
                SendSingleCommand(";" .. cmd .. " " .. SelectedPlayer)
            end
        end

        for cmd, _ in pairs(ActiveUnCmds) do
            SendSingleCommand(";" .. cmd .. " " .. LocalPlayer.Name)
        end

        for cmd, _ in pairs(ActiveAllCmds) do
            SendSingleCommand(";" .. cmd)
        end

        task.wait(0.6)
    end
end)

local MainTab = Window:CreateTab("All Commands", 4483362458)

local MainDropdown = MainTab:CreateDropdown({
    Name = "اختر اللاعب",
    Options = GetPlayerNames(),
    CurrentOption = {"اختر لاعب"},
    Flag = "MainPlayerDropdown",
    Callback = function(Option)
        SelectedPlayer = Option[1]
    end,
})

for _, cmdName in ipairs(AllCommands) do
    MainTab:CreateToggle({
        Name = cmdName,
        CurrentValue = false,
        Flag = "Main_" .. cmdName,
        Callback = function(Value)
            if Value then
                if not SelectedPlayer or SelectedPlayer == "اختر لاعب" then
                    Rayfield:Notify({Title = "تنبيه", Content = "اختر لاعب من القائمة ليعمل الأمر عليه", Duration = 3})
                end
                ActiveMainCmds[cmdName] = true
            else
                ActiveMainCmds[cmdName] = nil
            end
        end,
    })
end

Players.PlayerAdded:Connect(function()
    MainDropdown:Refresh(GetPlayerNames())
end)
Players.PlayerRemoving:Connect(function()
    MainDropdown:Refresh(GetPlayerNames())
end)

local UnTab = Window:CreateTab("Un (لي انا)", 4483362458)

for _, cmdName in ipairs(UnCommands) do
    UnTab:CreateToggle({
        Name = cmdName,
        CurrentValue = false,
        Flag = "Un_" .. cmdName,
        Callback = function(Value)
            if Value then
                ActiveUnCmds[cmdName] = true
            else
                ActiveUnCmds[cmdName] = nil
            end
        end,
    })
end

local ServerTab = Window:CreateTab("Server Commands", 4483362458)

for _, cmdName in ipairs(AllCommands) do
    ServerTab:CreateToggle({
        Name = cmdName,
        CurrentValue = false,
        Flag = "Server_" .. cmdName,
        Callback = function(Value)
            if Value then
                ActiveAllCmds[cmdName] = true
            else
                ActiveAllCmds[cmdName] = nil
            end
        end,
    })
end
