----------------------script start-------------------------------

function Notify(tt, tx)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = tt,
        Text = tx,
        Duration = 4
    })
end
function getcurrentgun(plr)
    local char = plr.Character
    if not char then return nil, nil end
    local invchar = game.ReplicatedStorage.Players:FindFirstChild(game.Players.LocalPlayer.Name).Inventory
    if not invchar then return nil, nil end

    local gun = nil
    local gunname = nil
    local guninv = nil

    for _, desc in ipairs(char:GetDescendants()) do
        if desc:IsA("Model") and desc:FindFirstChild("ItemRoot") and desc:FindFirstChild("Attachments") then
            gun = desc
            gunname = desc.Name
            guninv = invchar:FindFirstChild(gunname)
        end
    end

    return gunname, gun, guninv
end
function getcurrentammo(gun)
    if not gun then return nil end
    local loadedfold = gun:FindFirstChild("LoadedAmmo", true)
    if not loadedfold then return nil end
    local firstammo = loadedfold:FindFirstChild("1")
    if not firstammo then return nil end

    local ammoname = firstammo:GetAttribute("AmmoType")
    local ammo = game.ReplicatedStorage.AmmoTypes:FindFirstChild(ammoname)
    if not ammo then return nil end

    return ammo
end

--startup--

print("Loading start")

if _G.HihiHub then
    Notify("HihiHub", "Script is already loaded")
    return
end

local exec = identifyexecutor()
if string.match(exec, "Synapse") == nil and string.match(exec, "Macsploit") == nil and string.match(exec, "Seliware") == nil and string.match(exec, "Wave") == nil and string.match(exec, "Nihon") == nil and string.match(exec, "AWP") == nil then

    local reqtest = pcall(function()
        require(game.ReplicatedStorage.Modules.FPS)
    end)
    local filetest = pcall(function()
        isfile("HihiHub.mp3")
    end)
    local connecttest = pcall(function()
        getconnections(game.ChildAdded)
    end)
    if reqtest == true and filetest == true and connecttest == true then else
        Notify("HihiHub", "Sorry, your executor cant run this script")
        return
    end

    local libtest = pcall(function()
        local drawing1 = Drawing.new("Square")
        drawing1.Visible = false
        drawing1:Destroy()
    end)
    if libtest == false then
        Notify("HihiHub", "script loading....weee")
        local lib = game:HttpGet("https://drive.google.com/uc?export=download&id=1xDwhcJeZMMaGsOhRTM1oZw0TgklkDIwP")
        loadstring(lib)()
        Notify("HihiHub", "Script is loading....")
    else
        Notify("HihiHub", "Loading. Using " .. exec .. " (Half supported)")
    end

    Notify("WARNING", "you executor is dont work ")
else
    Notify("HihiHub", "Loading. Using " .. exec .. " (Full supported)")
end

if not isfile("HihiHub.png") then
    writefile("HihiHub.png", game:HttpGet("https://drive.google.com/uc?export=download&id=19FdURGTl36cVgYlS_zTjrRrjnXGAp80K"));
end

if game.Players.LocalPlayer.Character == nil or not game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
    Notify("HihiHub", "waiting for the game to load~~~")

    while game.Players.LocalPlayer.Character == nil or not game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") do
        wait(0.2)
    end
end
wait(0.5)

print("variables")

--variables--

local wcamera = workspace.CurrentCamera
local localplayer = game.Players.LocalPlayer
local runs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local scriptloading = true
local ACBYPASS_SYNC = false
local keybindlist = false
local keylist_gui 
local keylist_items = {}

local aimbool = false
local aimdebug1 = false
local aimdebug2 = false
local aimdebug3 = false
local aimselftrack = false
local aimbots = false
local aimvischeck = false
local aimdistcheck = false
local aimbang = true
local aimtrigger = false
local aiminfrange = false
local aimtarget = nil
local aimtargetpart = nil
local aimdynamicfov = false
local aimpart = "Head"
local aimtype = "Instant Hit"
local aimfov = 150
local aimsnapline = Drawing.new("Line")
local snaplinebool = false
local aimdistance = 800 -- meters
local aimchance = 100
local aimfakewait = 0
local aimfovcircle = Drawing.new("Circle")
local aimtargetname = Drawing.new("Text")
local aimtargetshots = Drawing.new("Text")
local aimogfunc = require(game.ReplicatedStorage.Modules.FPS.Bullet).CreateBullet
local aimmodfunc -- will change later in script
local aimignoreparts = {}
for i,v in ipairs(workspace:GetDescendants()) do
    if v:GetAttribute("PassThrough") then
        table.insert(aimignoreparts, v)
    end
end

local selftrack_data = {}
local selftrack_update = 0

local hitsoundbool = false
local hitsoundhead = "Ding"
local hitsoundbody = "Blackout"
local hitsoundlib = {
    ["TF2"]       = "rbxassetid://8255306220",
    ["Gamesense"] = "rbxassetid://4817809188",
    ["Rust"]      = "rbxassetid://1255040462",
    ["Neverlose"] = "rbxassetid://8726881116",
    ["Bubble"]    = "rbxassetid://198598793",
    ["Quake"]     = "rbxassetid://1455817260",
    ["Among-Us"]  = "rbxassetid://7227567562",
    ["Ding"]      = "rbxassetid://2868331684",
    ["Minecraft"] = "rbxassetid://6361963422",
    ["Blackout"]  = "rbxassetid://3748776946",
    ["Osu!"]      = "rbxassetid://7151989073",
}
local hitsoundlibUI = {}
for i,v in hitsoundlib do
    hitsoundlibUI[v] = i
end

local rapidfire = false
local crapidfire = false
local crapidfirenum = 0.001
local unlockmodes = false
local multitaps = 1
local instrelOGfunc = require(game.ReplicatedStorage.Modules.FPS).reload
local instrelMODfunc -- changed later
local instaequip = false
local noswaybool = false

local aimFRIENDLIST = {}
local friendlistmode = "Blacklist"
local friendlistbots = false

local esptextcolor = Color3.fromRGB(255,255,255)
local esptable = {}
--[[ esptable template
    drawingobj = {
        primary = instance
        type = string --(highlight, name, hp, hotbar, distance, skelet, box)
        otype = string --(plr, bot, dead, extract, loot)
    }      
]] 
local espbool = false
local espname = false
local esphp = false
local espdistance = false
local espdistmode = "Meters"
local espbots = false
local esphigh = false
local espdead = false
local esphotbar = false
local esploot = false
local espexit = false
local esptextline = false
local esprenderdist = 1000 -- meters
local espchamsfill = 0.5
local espchamsline = 0
local esptextsize = 14
local espboxcolor = Color3.fromRGB(255,255,255)
local espfillcolor = Color3.fromRGB(255,0,0)
local esplinecolor = Color3.fromRGB(255,255,255)

local invcheck = false
local invchecktext = Drawing.new("Text")

local tracbool = false
local tracwait = 2
local traccolor = Color3.fromRGB(255,255,255)
local tractexture = nil
local tractextures = {
    ["None"] = nil,
    ["Glow"] = "http://www.roblox.com/asset/?id=78260707920108",
    ["Lighting"] = "http://www.roblox.com/asset/?id=131326755401058",
}

local crossbool = false
local crosscolor = Color3.fromRGB(255,255,255)
local crosssizeog = UDim2.new(0.017, 0, 0.03, 0)
local crosssizek = 2
local crossrot = 0
local crossimg = getcustomasset("HihiHub.png")
local crossgui = Instance.new("ScreenGui", localplayer.PlayerGui)
crossgui.ClipToDeviceSafeArea = false
crossgui.ResetOnSpawn = false
crossgui.ScreenInsets = 0
local crosshair = Instance.new("ImageLabel", crossgui)
crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
crosshair.Size = UDim2.new(crosssizeog.X.Scale * crosssizek, 0, crosssizeog.Y.Scale * crosssizek, 0)
crosshair.Image = crossimg
crosshair.ImageColor3 = crosscolor
crosshair.BackgroundTransparency = 1
crosshair.Visible = false

local camthirdp = false
local camthirdpX = 2
local camthirdpY = 2
local camthirdpZ = 5
local basefov = 120
local zoomfov = 5
local antimaskbool = false
local camzoomfunctionOG = require(game.ReplicatedStorage.Modules.CameraSystem).SetZoomTarget
local camzoomfunction --changed later

local viewmod_materials = {
    ["Forcefield"] = Enum.Material.ForceField,
    ["Neon"] = Enum.Material.Neon,
    ["Plastic"] = Enum.Material.SmoothPlastic
}
local viewmodbool = false
local viewmodhandmat = Enum.Material.Plastic
local viewmodgunmat = Enum.Material.Plastic
local viewmodhandcolor = Color3.fromRGB(255,255,255)
local viewmodguncolor = Color3.fromRGB(255,255,255)
local viewmodoffset = false
local viewmodX = -2
local viewmodY = -2
local viewmodZ = 0

local scbool = false
local scgui = nil --later
local scselected = nil

local speedbool = false
local speedboost = 1.2
local nojumpcd = false
local nofall = false
local instafall = false
local changerbool = false
local changergrav = 95
local changerspeed = 20
local changerheight = 2
local changerjump = 3
local charsemifly = false
local charsemiflydist = 6
local charsemiflyspeed = 30
local semifly_bodyvel = nil
local semifly_pos = CFrame.new()
local semifly_posconnect = nil
local instantleanOGfunc --changed later
local instantleanMODfunc --changed later

local worldleaves = false
local folcheck = workspace:FindFirstChild("SpawnerZones")
local worldclock = 14
local waterplatforms = Instance.new("Folder", workspace)
waterplatforms.Name = "ArdourWaterPlatforms"
local worldjesus
local worldambient = Color3.fromRGB(255,255,255)
local worldoutdoor = Color3.fromRGB(255,255,255)
local worldexpo = 0
local colorcorrectbool = false
local colorcorrectbright = 0
local colorcorrectcontrast = 0
local colorcorrectsatur = 0
local colorcorrecttint = Color3.fromRGB(255,255,255)

local instantrespawn = false
local espmapactive = false
local handleESPMAP = function() do end end
local espmapmarkers = {}
local detectedmods = {}
local detectmods = false

local valcache = {
    ["6B45"] = 16,
    ["AS Val"] = 16,
    ["ATC Key"] = 6,
    ["Airfield Key"] = 6,
    ["Altyn"] = 16,
    ["Altyn Visor"] = 8,
    ["Maska Visor"] = 8,
    ["Attak-5 60L"] = 16,
    ["Bolts"] = 1,
    ["Crane Key"] = 6,
    ["DAGR"] = 12,
    ["Duct Tape"] = 1,
    ["Fast MT"] = 10,
    ["Flare Gun"] = 20,
    ["Fueling Station Key"] = 2,
    ["Garage Key"] = 4,
    ["Hammer"] = 1,
    ["JPC"] = 10,
    ["Lighthouse Key"] = 6,
    ["M4A1"] = 12,
    ["Nails"] = 1,
    ["Nuts"] = 1,
    ["Saiga 12"] = 8,
    ["Super Glue"] = 1,
    ["Village Key"] = 2,
    ["Wrench"] = 1,
    ["SPSh-44"] = 12,
    ["R700"] = 16,
    ["AKMN"] = 12,
    ["Mosin"] = 12,
    ["SVD"] = 12,
    ["7.62x39AP"] = 0.15,
    ["7.62x54AP"] = 0,15,
}
--drawing setup--

aimfovcircle.Visible = false
aimfovcircle.Radius = aimfov
aimfovcircle.Thickness = 2
aimfovcircle.Filled = false
aimfovcircle.Transparency = 1
aimfovcircle.Color = Color3.fromRGB(255, 255, 255)
aimfovcircle.Position = Vector2.new(wcamera.ViewportSize.X / 2, wcamera.ViewportSize.Y / 2)
aimtargetname.Text = "None"
aimtargetname.Position = Vector2.new(wcamera.ViewportSize.X / 2, wcamera.ViewportSize.Y / 2 + aimfov + 20) 
aimtargetname.Size = 24
aimtargetname.Color = Color3.fromRGB(255,255,255)
aimtargetname.Visible = false
aimtargetname.Center = true
aimtargetname.Outline = true
aimtargetname.OutlineColor = Color3.new(0, 0, 0)
aimtargetshots.Text = " "
aimtargetshots.Position = Vector2.new(wcamera.ViewportSize.X / 2, wcamera.ViewportSize.Y / 2 + aimfov + 30) 
aimtargetshots.Size = 20
aimtargetshots.Color = Color3.fromRGB(255,255,255)
aimtargetshots.Visible = false
aimtargetshots.Center = true
aimtargetshots.Outline = true
aimtargetshots.OutlineColor = Color3.new(0, 0, 0)
invchecktext.Text = " "
invchecktext.Position = Vector2.new(100, wcamera.ViewportSize.Y / 2)
invchecktext.Size = 18
invchecktext.Color = Color3.fromRGB(255,255,255)
invchecktext.Visible = true
invchecktext.Center = false
invchecktext.Outline = true
invchecktext.OutlineColor = Color3.new(0, 0, 0)
aimsnapline.From = Vector2.new(20, 20)
aimsnapline.To = Vector2.new(50, 50)
aimsnapline.Color = Color3.fromRGB(255,255,255)
aimsnapline.Thickness = 1
aimsnapline.Visible = false
--gui setup--

if _G.HihiHub then
    Notify("HihiHub", "Script is already loaded")
    return
end

print('loading gui library....')
--gui library load--
local library = nil
task.spawn(function()
    local newlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/HihiHubv2/roblox-hub/refs/heads/main/UI", true))()

    if library ~= nil then 
        newlib.GUI:Destroy()
        return 
    end
    library = newlib

    if game.CoreGui:FindFirstChild("PCR_1") then
        game.CoreGui.PCR_1.Enabled = false
    end
end)
task.wait(2)
while library == nil do
    task.spawn(function()
        local newlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/HihiHubv2/roblox-hub/refs/heads/main/UI", true))()

        if library ~= nil then 
            newlib.GUI:Destroy()
            return 
        end
        library = newlib
    
        if game.CoreGui:FindFirstChild("PCR_1") then
            game.CoreGui.PCR_1.Enabled = false
        end
    end)

    task.wait(2)
    if library == nil then
        continue
    end
end
if _G.HihiHub then
    return
end
_G.HihiHub = true
game.CoreGui.PCR_1.Enabled = false
do
    local bg = game.CoreGui.PCR_1:FindFirstChild("BG", true)
    if bg then 
        Instance.new("UICorner", bg.Parent).CornerRadius = UDim.new(0.02, 0)
    end
end
library.GUI.ScreenInsets = Enum.ScreenInsets.None
local librarymaingui = library.GUI.MAIN
--keybind list--
print('loading keybind list')
do
    local a=Instance.new"Frame"
    a.Name="Keybinds"
    a.Size=UDim2.new(0.099531,0,0.2842593,0)
    a.BorderColor3=Color3.fromRGB(0,0,0)
    a.Position=UDim2.new(0.0057322,0,0.0495185,0)
    a.BorderSizePixel=0
    a.BackgroundColor3=Color3.fromRGB(44,44,44)
    a.Visible = false
    local b=Instance.new"UICorner"
    b.CornerRadius=UDim.new(0.05,0)
    b.Parent=a
    local c=Instance.new"UIStroke"
    c.ApplyStrokeMode=1
    c.Thickness=2.5999999
    c.Color=Color3.fromRGB(91,133,197)
    c.Parent=a
    local d=Instance.new"Frame"
    d.Name="Title"
    d.Size=UDim2.new(0.9994792,0,0.0781759,0)
    d.BorderColor3=Color3.fromRGB(0,0,0)
    d.BackgroundTransparency=0.75
    d.Position=UDim2.new(0,0,0,0)
    d.BorderSizePixel=0
    d.BackgroundColor3=Color3.fromRGB(0,0,0)
    d.Parent=a
    local e=Instance.new"TextLabel"
    e.Name="Label"
    e.Size=UDim2.new(0.7853403,0,0.7083333,0)
    e.BorderColor3=Color3.fromRGB(0,0,0)
    e.BackgroundTransparency=1
    e.Position=UDim2.new(0.1046575,0,0.144544,0)
    e.BorderSizePixel=0
    e.BackgroundColor3=Color3.fromRGB(255,255,255)
    e.FontSize=5
    e.TextStrokeTransparency=0
    e.TextSize=14
    e.RichText=true
    e.TextColor3=Color3.fromRGB(255,255,255)
    e.Text="Keybinds"
    e.TextWrapped=true
    e.TextWrap=true
    e.Font=100
    e.TextScaled=true
    e.Parent=d
    local f=Instance.new"UICorner"
    f.CornerRadius=UDim.new(0.5,0)
    f.Parent=d
    local g=Instance.new"Frame"
    g.Name="Items"
    g.Size=UDim2.new(0.9105204,0,0.8794788,0)
    g.BorderColor3=Color3.fromRGB(0,0,0)
    g.BackgroundTransparency=0.75
    g.Position=UDim2.new(0.041863,0,0.0977199,0)
    g.BorderSizePixel=0
    g.BackgroundColor3=Color3.fromRGB(0,0,0)
    g.Parent=a
    local h=Instance.new"UICorner"
    h.CornerRadius=UDim.new(0.05,0)
    h.Parent=g
    local i=Instance.new"UIStroke"
    i.ApplyStrokeMode=1
    i.Thickness=1.8
    i.Color=Color3.fromRGB(54,54,54)
    i.Parent=g
    local j=Instance.new"UIListLayout"
    j.SortOrder=2
    j.Wraps=true
    j.HorizontalFlex=2
    j.ItemLineAlignment=2
    j.Padding=UDim.new(0.02,0)
    j.Parent=g
    local k=Instance.new"Configuration"
    k.Name="Templates"
    k.Parent=a
    local l=Instance.new"TextLabel"
    l.Name="Keytemplate"
    l.Size=UDim2.new(0.9080459,0,0.08,0)
    l.BorderColor3=Color3.fromRGB(0,0,0)
    l.BackgroundTransparency=1
    l.Position=UDim2.new(0.091954,0,0,0)
    l.BorderSizePixel=0
    l.BackgroundColor3=Color3.fromRGB(255,255,255)
    l.FontSize=5
    l.TextStrokeTransparency=0
    l.TextSize=14
    l.TextColor3=Color3.fromRGB(255,255,255)
    l.Text="[Insert] Toggle GUI"
    l.TextWrapped=true
    l.TextWrap=true
    l.Font=100
    l.TextXAlignment=0
    l.TextScaled=true
    l.Parent=k

    a.Parent = library.GUI
    keylist_gui = a
end
local function keylist_removekey(funcname)
    local oldkey = keylist_items[funcname]
    if oldkey == nil then return end
    oldkey:Destroy()
end
local function keylist_addkey(funcname, keyname)
    local newkey = keylist_gui.Templates.Keytemplate:Clone()
    newkey.Name = funcname
    newkey.Text = '['..keyname..'] '..funcname
    newkey.Parent = keylist_gui.Items
    keylist_items[funcname] = newkey
end

print('setting up gui')

library:ChangeWeb("discord.gg/nJaZ88C3zE")

local home = library:AddWindow('Home')
local combat = library:AddWindow('Combat')
local visual = library:AddWindow('Visuals')
local other = library:AddWindow('Other')
local editwatermark
editwatermark = library.GUI.ChildAdded:Connect(function(ch)
    if ch:IsA("Frame") then
        ch.AnchorPoint = Vector2.new(0.5, 0.5)
        ch.Position = UDim2.new(0.5, 0, 0.05, 0)
        Instance.new("UICorner", ch).CornerRadius = UDim.new(0.2, 0)
    end
    editwatermark:Disconnect()
end)
local watermark = library:AddWatermark('HihiHub[Paid]')
watermark.AnchorPoint = Vector2.new(0.5, 0.5)
watermark.Position = UDim2.new(0.5, 0, 0.05, 0)

local mainhome = home:AddSection('Info')
local aim = combat:AddSection('Aim')
local gunmods = combat:AddSection('Gun Mods')
local tarinfo = combat:AddSection('Target')
local friendman = combat:AddSection('Friend manager')
local wh = visual:AddSection('ESP')
local cross = visual:AddSection('Crosshair')
local tracers = visual:AddSection('Tracers')
local camer = visual:AddSection('Camera')
local viewmod = visual:AddSection('View Model')
local speedh = other:AddSection('Character')
local worldh = other:AddSection('World')
local vmisc = other:AddSection('Misc')
mainhome:AddLabel('腳本版本是 "v10" (The script version is "v10")')
mainhome:AddKeyBind('切換 GUI (Toggle GUI)', Enum.KeyCode.Insert, function() 
    if scriptloading then return end
    game.CoreGui.PCR_1.Enabled = not game.CoreGui.PCR_1.Enabled
end)
mainhome:AddToggle('Keybind list', true, nil, function(v)
    keybindlist = v
    keylist_gui.Visible = v
end)

aim:AddLabel('無後座/散佈在靜默瞄準時啟用 (No Recoil/Spread enables with Silent Aim)')
-----------------------------------------------
-- 用於擊中通知的 UI 控制
aim:AddToggle('擊中通知 (Hitmarker)', true, nil, function(v)
    hitmarkerEnabled = v -- 用來控制擊中通知是否啟用
    if not v then
        -- 禁用擊中通知時，清除所有現有通知
        for _, layers in ipairs(notifications) do
            for _, layer in ipairs(layers) do
                layer:Remove()
            end
        end
        notifications = {}
    end
end)

local notifications = {}
local center = (workspace.CurrentCamera.ViewportSize / 2)

-- 更新擊中通知的位置
function hitmarker_update()
    for i = 1, #notifications do
        for _, layer in ipairs(notifications[i]) do
            layer.Position = Vector2.new(center.X, (center.Y + 150) + (i * 24)) -- 每條通知的垂直間隔
        end
    end
end

-- 創建擊中通知
function hitmarker(hitpart, username, duration)
    if not hitmarkerEnabled then return end -- 如果未啟用，直接返回

    task.spawn(function()
        local layers = {}
        local offsets = {
            Vector2.new(-1, 0),  -- 左
            Vector2.new(1, 0),   -- 右
            Vector2.new(0, -1),  -- 上
            Vector2.new(0, 1),   -- 下
        }

        -- 創建文字邊框（輪廓）
        for _, offset in ipairs(offsets) do
            for i = -1, 1 do -- 模擬更粗的邊框
                for j = -1, 1 do
                    if not (i == 0 and j == 0) then -- 避免中心重疊
                        local outline = Drawing.new('Text')
                        outline.Size = 18 -- 文字大小
                        outline.Font = 4  -- 文字字體
                        outline.Text = string.format("HihiHub damage inflicted to %s on %s", username, hitpart)
                        outline.Visible = true
                        outline.ZIndex = 2
                        outline.Center = true
                        outline.Color = Color3.fromRGB(0, 0, 0) -- 黑色輪廓
                        outline.Position = center + offset + Vector2.new(i, j) -- 偏移模擬粗輪廓
                        table.insert(layers, outline)
                    end
                end
            end
        end

        -- 創建主要文字，將 HihiHub 部分設為紫色，其餘為白色
        local hitlog = Drawing.new('Text')
        hitlog.Size = 18 -- 文字大小
        hitlog.Font = 4  -- 文字字體
        hitlog.Visible = true
        hitlog.ZIndex = 3
        hitlog.Center = true
        hitlog.Text = string.format("HihiHub damage inflicted to %s on %s", username, hitpart)

        -- 高亮 "HihiHub" 部分
        local startIndex = hitlog.Text:find("HihiHub")
        if startIndex then
            hitlog.Color = Color3.fromRGB(138, 43, 226) -- 紫色
        else
            hitlog.Color = Color3.fromRGB(255, 255, 255) -- 白色
        end

        table.insert(layers, hitlog)

        -- 插入通知並更新位置
        table.insert(notifications, layers)
        hitmarker_update()

        -- 等待指定持續時間
        wait(duration)

        -- 慢慢淡化通知
        for transparency = 0, 1, 0.1 do
            for _, layer in ipairs(layers) do
                layer.Transparency = transparency
            end
            wait(0.1)
        end

        -- 移除所有文字層
        for _, layer in ipairs(layers) do
            layer:Remove()
        end
        table.remove(notifications, table.find(notifications, layers))
        hitmarker_update()
    end)
end

-- 攔截 FireServer 方法
local namecall
namecall = hookmetamethod(game, '__namecall', function(self, ...)
    local args = { ... }
    local method = getnamecallmethod()

    -- 當執行 FireServer 時檢查是否為 "ProjectileInflict"
    if method == "FireServer" and self.Name == "ProjectileInflict" then
        -- 檢查並解析目標和部位
        local username = args[1] and args[1].Name or "Unknown"
        local hitpart = args[2] and args[2].Name or "Unknown"

        -- 添加擊中通知，顯示時間設定為 5 秒
        hitmarker(hitpart, username, 5)
    end

    return namecall(self, unpack(args))
end)


----------------------------------------
aim:AddToggle('靜默瞄準 (Silent Aim)', true, nil, function(v)
    aimbool = v
    if v == true then
        require(game.ReplicatedStorage.Modules.FPS.Bullet).CreateBullet = aimmodfunc
    else
        require(game.ReplicatedStorage.Modules.FPS.Bullet).CreateBullet = aimogfunc
    end
end)

aim:AddToggle('Visibility check (可見性檢查)', true, nil, function(v)
    aimvischeck = v
end)
aim:AddToggle('Ping check (延遲檢查)', true, nil, function(v)
    aimselftrack = v
end)
aim:AddToggle('Ammo distance check (子彈距離檢查)', true, nil, function(v)
    aimdistcheck = v
end)
aim:AddToggle('Trigger Bot (觸發機器人)', true, nil, function(v)
    aimtrigger = v
end)
aim:AddToggle('Target AI (目標AI)', true, nil, function(v)
    aimbots = v
end)
aim:AddToggle('Fake wait (instant hit only) (假等待，只限即時擊中)', true, nil, function(v)
    aimfakewait = v
end)
aim:AddToggle('Dynamic FOV (動態視場)', true, nil, function(v)
    aimdynamicfov = v
end)
aim:AddSlider('Aim FOV (瞄準視場)', 250, 0, 150, function(c) 
    aimfov = c
end)
aim:AddSlider('Aim Distance (Meters) (瞄準距離，米)', 950, 50, 800, function(c) 
    aimdistance = c
end)
aim:AddSlider('Hit Chance (命中機率)', 100, 0, 100, function(c) 
    aimchance = c
end)
aim:AddDropdown('Aim Part (瞄準部位)', {'Head', 'HeadTop', "Face", 'Torso', 'Scripted', "Random"}, 'Head', function(a)
    aimpart = a
end)
aim:AddDropdown('Aim Type (瞄準類型)', {'Prediction', 'Instant Hit'}, 'Instant Hit', function(a)
    aimtype = a
end)
aim:AddSeparateBar()
aim:AddToggle('Show FOV (顯示視場)', true, nil, function(v)
    aimfovcircle.Visible = v
end)
aim:AddColorPallete('FOV Color (視場顏色)', Color3.fromRGB(255, 255, 255),function(a) 
   aimfovcircle.Color = a
end)
aim:AddSeparateBar()
aim:AddToggle('Snapline', true, nil, function(v)
    snaplinebool = v
end)
aim:AddSlider('Thickness', 5, 0.01, 1, function(c) 
    aimsnapline.Thickness = c
end)
aim:AddColorPallete('Color', Color3.fromRGB(255, 255, 255),function(a) 
    aimsnapline.Color = a
end)
aim:AddSeparateBar()
aim:AddToggle('HitSound', true, nil, function(v)
    hitsoundbool = v
end)
aim:AddDropdown('Head Sound', hitsoundlibUI, hitsoundhead, function(a)
    hitsoundhead = a

    local preview = Instance.new("Sound", workspace)
    preview.SoundId = hitsoundlib[a]
    preview:Play()
    task.wait(1)
    preview:Destroy()
end)
aim:AddDropdown('Body Sound', hitsoundlibUI, hitsoundbody, function(a)
    hitsoundbody = a

    local preview = Instance.new("Sound", workspace)
    preview.SoundId = hitsoundlib[a]
    preview:Play()
    task.wait(1)
    preview:Destroy()
end)

gunmods:AddToggle('Rapid Fire [IF HOLD GUN - REEQUIP IT] (快速射擊 [如果按住槍 - 重新裝備])', true, nil, function(v)
    rapidfire = v
    if v == true then
        local inv = game.ReplicatedStorage.Players:FindFirstChild(localplayer.Name).Inventory
        for i,v in ipairs(inv:GetChildren()) do
            local sett = require(v.SettingsModule)
            sett.FireRate = 0.002
        end
    else
        local inv = game.ReplicatedStorage.Players:FindFirstChild(localplayer.Name).Inventory
        for i,v in ipairs(inv:GetChildren()) do
            local sett = require(v.SettingsModule)
            local toset = 0.05
            toset = 60 / v.ItemProperties.Tool:GetAttribute("FireRate")
            sett.FireRate = toset
        end
    end
end)
gunmods:AddToggle('Custom rapidfire', true, nil, function(v)
    crapidfire = v
end)
gunmods:AddToggle('Unlock firemodes [IF HOLD GUN - REEQUIP IT] (解鎖射擊模式 [如果按住槍 - 重新裝備])', true, nil, function(v)
    unlockmodes = v
end)
gunmods:AddToggle('Instant Reload (即時重新裝填)', true, nil, function(v)
    if scriptloading then return end
    if v then 
        require(game.ReplicatedStorage.Modules.FPS).reload = instrelMODfunc
    else
        require(game.ReplicatedStorage.Modules.FPS).reload = instrelOGfunc
    end
end)
gunmods:AddToggle('Instant Equip', true, nil, function(v)
    instaequip = v
end)
gunmods:AddToggle('No sway', true, nil, function(v)
    noswaybool = v
end)
gunmods:AddSlider('Multitaps (多次點擊)', 5, 1, 1, function(c)
    multitaps = c
end)
gunmods:AddTextBox('Custom rapidfire delay', nil, false, 5, function(a)
    local num = tonumber(a)
    if num ~= nil then
        crapidfirenum = num
        Notify("Ardour", "Set custom rapidfire delay")
    end
end)
tarinfo:AddLabel('If it shows the name of target, then target is visible (如果顯示目標的名稱，則目標可見)')
tarinfo:AddToggle('Show Name (顯示名稱)', true, nil, function(v)
    aimtargetname.Visible = v
end)
tarinfo:AddToggle('Shots left (剩餘子彈)', true, nil, function(v)
    aimtargetshots.Visible = v
end)


friendman:AddTextBox('Add name (添加名稱)', nil, false, 5, function(plrname) 
    if game.Players:FindFirstChild(plrname) or workspace.AiZones:FindFirstChild(plrname, true) then 
        if table.find(aimFRIENDLIST, plrname) ~= nil then return end
        table.insert(aimFRIENDLIST, plrname)
        Notify("HihiHub", "Added "..plrname.." to friendlist (已將 "..plrname.." 添加至好友列表)" )
    end
end)
friendman:AddTextBox('Remove name (移除名稱)', nil, false, 5, function(plrname)
    local iter = table.find(aimFRIENDLIST, plrname)
    if iter ~= nil then 
        table.remove(aimFRIENDLIST, iter)
        Notify("HihiHub", "Removed "..plrname.." from friendlist (已從好友列表移除 "..plrname..")" )
    end
end)
friendman:AddToggle('Include bots (包含機器人)', true, nil, function(v)
    friendlistbots = v
end)
friendman:AddDropdown('Friendlist mode (好友列表模式)', {'Blacklist (黑名單)', 'Whitelist (白名單)'}, 'Blacklist (黑名單)', function(a)
    friendlistmode = a
end)
friendman:AddButton('Print friendlist (console) (列印好友列表（控制台）)', function()
    if #aimFRIENDLIST == 0 then 
        print("No one in friendlist (好友列表沒有任何人)")
        return
    end
    print("HihiHub friendlist (HihiHub 好友列表):")
    for i,v in aimFRIENDLIST do
        print("["..i.."] "..v)
    end
    print("HihiHub friendlist end (HihiHub 好友列表結束)")
end)
friendman:AddButton('Clear friendlist (清空好友列表)', function()
    table.clear(aimFRIENDLIST)
end)
wh:AddToggle('ESP (ESP顯示)', true, nil, function(v)
    espbool = v
end)
wh:AddToggle('Name (名稱)', true, nil, function(v)
    espname = v
end)
wh:AddToggle('HP (血量)', true, nil, function(v)
    esphp = v
end)
wh:AddToggle('Distance (距離)', true, nil, function(v)
    espdistance = v
end)
wh:AddToggle('Chams (外觀)', true, nil, function(v)
    esphigh = v
end)
wh:AddToggle('Active Gun (使用中槍支)', true, nil, function(v)
    esphotbar = v
end)
wh:AddToggle('Dead (死亡)', true, nil, function(v)
    espdead = v
end)
wh:AddToggle('Bots (機器人)', true, nil, function(v)
    espbots = v
end)
wh:AddToggle('Loot (戰利品)', true, nil, function(v)
    esploot = v
end)
wh:AddToggle('Extract (退出)', true, nil, function(v)
    espexit = v
end)
wh:AddDropdown('Distance type (距離類型)', {'Meters', 'Studs'}, 'Meters', function(a)
    espdistmode = a
end)
wh:AddSlider('Render Distance (Meters) (渲染距離 - 米)', 1200, 50, 1000, function(c) 
    esprenderdist = c
end)
wh:AddSlider('Text Size (文字大小)', 35, 1, 14, function(c) 
    esptextsize = c
end)
wh:AddToggle('Text outline (文字輪廓)', true, nil, function(v)
    esptextline = v
end)
wh:AddSlider('Chams Outline Transparency (外觀輪廓透明度)', 1, 0, 0, function(c) 
    espchamsline = c
end)
wh:AddSlider('Chams Fill Transparency (外觀填充透明度)', 1, 0, 0.5, function(c) 
    espchamsfill = c
end)
wh:AddColorPallete('Text Color (文字顏色)', Color3.fromRGB(55, 0, 255),function(a) 
    esptextcolor = a
end)
wh:AddColorPallete('Chams Outline Color (外觀輪廓顏色)', Color3.fromRGB(204, 0, 255),function(a) 
    esplinecolor = a
end)
wh:AddColorPallete('Chams Fill Color (外觀填充顏色)', Color3.fromRGB(121, 252, 208),function(a) 
    espfillcolor = a
end)


cross:AddToggle('Crosshair (準星)', true, nil, function(v)
    crossbool = v
end)
cross:AddLabel('Example: HihiHub.png')
cross:AddTextBox('Image', nil, false, 5, function(a) 
    if isfile(a) then
        if getcustomasset(a) ~= nil then
            crossimg = getcustomasset(a)
        else
            Notify("HihiHub Error", "File is not a image")
            return
        end
    else
        Notify("HihiHub Error", "Cant find the image")
        return
    end
end)
cross:AddSlider('Size (大小)', 30, 0.5, 2, function(c) 
    crosssizek = c
end)
cross:AddSlider('Rotation Speed (旋轉速度)', 10, -10, 0, function(c) 
    crossrot = c
end)
cross:AddColorPallete('Color (顏色)', Color3.fromRGB(96, 207, 207),function(a) 
    crosscolor = a
end)


tracers:AddToggle('Enabled (啟用)', true, nil, function(v)
    tracbool = v
end)
tracers:AddSlider('Remove time (移除時間)', 10, 0, 2, function(c) 
    tracwait = c
end)
tracers:AddColorPallete('Tracers Color (彈道顏色)', Color3.fromRGB(255, 0, 191),function(a) 
    traccolor = a
end)
tracers:AddDropdown('Texture (紋理)', {'None', 'Lighting', "Glow"}, 'None', function(a)
    tractexture = tractextures[a]
end)
print("third-person by _hai_hai")

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 偏移量變數
local camthirdp = true
local camthirdpX, camthirdpY, camthirdpZ = 0, 2, 5 -- 初始偏移

-- 更新透明度函數
local function updateTransparency(character, setTransparency)
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.LocalTransparencyModifier = setTransparency
        end
    end
end

-- 渲染步驟：根據角色位置與攝像機當前角度動態更新視角
RunService.RenderStepped:Connect(function()
    if camthirdp then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local rootPart = character.HumanoidRootPart

            -- 基於當前攝像機角度計算偏移
            local offset = Vector3.new(camthirdpX, camthirdpY, camthirdpZ)
            local cameraRotation = Camera.CFrame - Camera.CFrame.Position -- 提取攝像機的旋轉角度

            -- 設置攝像機位置：當前視角 + 偏移量
            Camera.CFrame = CFrame.new(rootPart.Position) * cameraRotation + cameraRotation:VectorToWorldSpace(offset)

            -- 更新透明度（可選）
            updateTransparency(character, 0.5) -- 半透明
        end
    end
end)
-- 添加 UI 控件
camer:AddToggle('Third Person (第三人稱視角)', true, Enum.KeyCode.KeypadSix, function(v)
    camthirdp = v
end)

camer:AddSlider('Offset X (X 偏移)', 10, -10, 2, function(c)
    camthirdpX = c
end)

camer:AddSlider('Offset Y (Y 偏移)', 10, -10, 2, function(c)
    camthirdpY = c
end)

camer:AddSlider('Offset Z (Z 偏移)', 10, -10, 5, function(c)
    camthirdpZ = c
end)

camer:AddToggle('Anti mask (防面具)', true, nil, function(v)
    if v == true then
        game.Players.LocalPlayer.PlayerGui.MainGui.MainFrame.ScreenEffects.HelmetMask.TitanShield.Size = UDim2.new(0,0,1,0)
        game.Players.LocalPlayer.PlayerGui.MainGui.MainFrame.ScreenEffects.Mask.GP5.Size = UDim2.new(0,0,1,0)
        for i,v in ipairs(game.Players.LocalPlayer.PlayerGui.MainGui.MainFrame.ScreenEffects.Visor:GetChildren()) do
            v.Size = UDim2.new(0,0,1,0)
        end
    else
        game.Players.LocalPlayer.PlayerGui.MainGui.MainFrame.ScreenEffects.HelmetMask.TitanShield.Size = UDim2.new(1,0,1,0)
        game.Players.LocalPlayer.PlayerGui.MainGui.MainFrame.ScreenEffects.Mask.GP5.Size = UDim2.new(1,0,1,0)
        for i,v in ipairs(game.Players.LocalPlayer.PlayerGui.MainGui.MainFrame.ScreenEffects.Visor:GetChildren()) do
            v.Size = UDim2.new(1,0,1,0)
        end
    end
end)
camer:AddToggle('Anti flash (防閃光)', true, nil, function(v)
    if v == true then
        game.Players.LocalPlayer.PlayerGui.MainGui.MainFrame.ScreenEffects.Flashbang.Size = UDim2.new(0,0,1,0)
    else
        game.Players.LocalPlayer.PlayerGui.MainGui.MainFrame.ScreenEffects.Flashbang.Size = UDim2.new(1,0,1,0)
    end
end)
speedh:AddToggle('InstaFall(瞬間墜落)', true, nil, function(v)
    instafall = v
end)
speedh:AddSeparateBar()
-- UI 控制
gunmods:AddToggle('快速裝備 (Insta Equip)', true, nil, function(v)
    instaequip = v -- 開關控制變數
end)

-- 快速裝備功能
workspace.Camera.ChildAdded:Connect(function(ch)
    if instaequip and ch:IsA("Model") then -- 根據開關狀態啟用或禁用功能
        task.wait(0.015)
        for i, v in ipairs(ch.Humanoid.Animator:GetPlayingAnimationTracks()) do
            if v.Animation.Name == "Equip" then
                v.TimePosition = v.Length - 0.01 -- 快速跳過裝備動畫
            end
        end
    end
end)

speedh:AddToggle('NoFall', true, nil, function(v)
    nofall = v
end)
camer:AddSeparateBar()
camer:AddToggle('Modify Zoom (修改縮放)', true, nil, function(v)
    if scriptloading then return end

    if v == true then
        require(game.ReplicatedStorage.Modules.CameraSystem).SetZoomTarget = camzoomfunction
    else
        require(game.ReplicatedStorage.Modules.CameraSystem).SetZoomTarget = camzoomfunctionOG
    end
end)
camer:AddSlider('Base FOV (基本視場)', 150, 10, 120, function(c) 
    basefov = c
end)
camer:AddSlider('Zoom FOV (縮放視場)', 50, 0, 5, function(c) 
    zoomfov = c
end)

viewmod:AddToggle('SkinChanger menu (換膚菜單)', true, Enum.KeyCode.KeypadEight, function(v)
    if scriptloading then return end
    scgui.Visible = v
end)
viewmod:AddSeparateBar()
viewmod:AddToggle('Texture changer (材質更換)', true, nil, function(v)
    viewmodbool = v
end)
viewmod:AddDropdown('Hand Material (手材質)', {'Neon', 'Forcefield', "Plastic"}, 'Plastic', function(a)
    if viewmod_materials[a] then
        viewmodhandmat = viewmod_materials[a]
    else
        warn('no material in mat table : ' .. a)
    end
end)
viewmod:AddDropdown('Gun Material (槍材質)', {'Neon', 'Forcefield', "Plastic"}, 'Plastic', function(a)
    if viewmod_materials[a] then
        viewmodgunmat = viewmod_materials[a]
    else
        warn('no material in mat table : ' .. a)
    end
end)
viewmod:AddColorPallete('Hand Color (手顏色)', Color3.fromRGB(215, 255, 105),function(a) 
    viewmodhandcolor = a
end)
viewmod:AddColorPallete('Gun Color (槍顏色)', Color3.fromRGB(0, 89, 255),function(a) 
    viewmodguncolor = a
end)
viewmod:AddSeparateBar()
viewmod:AddToggle('Offset changer (偏移更換)', true, nil, function(v)
    viewmodoffset = v
end)
viewmod:AddSlider('Offset X (X 偏移)', 5, -5, -2, function(c) 
    viewmodX = c
end)
viewmod:AddSlider('Offset Y (Y 偏移)', 5, -5, -2, function(c) 
    viewmodY = c
end)
viewmod:AddSlider('Offset Z (Z 偏移)', 5, -5, 0, function(c) 
    viewmodZ = c
end)

speedh:AddToggle('Jesus (耶穌)', true, nil, function(v)
    worldjesus = v
    if v then
        while worldjesus do
            wait()

            local hitPart = workspace:Raycast(localplayer.Character:FindFirstChild("HumanoidRootPart").Position, Vector3.new(0, -5, 0) + localplayer.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 5, RaycastParams.new())
            if hitPart and hitPart.Material == Enum.Material.Water then
                local clone = Instance.new("Part")
                clone.Parent = waterplatforms
                clone.Position = hitPart.Position
                clone.Anchored = true
                clone.CanCollide = true
                clone.Size = Vector3.new(10,0.2,10)
                clone.Transparency = 1 --original = https://devforum.roblox.com/t/how-do-i-make-water-walking-passive-like-this/1589924/10
            end
        end
    else
        for i,v in ipairs(waterplatforms:GetChildren()) do
            v:Destroy()
        end
    end
end)
speedh:AddSeparateBar()
speedh:AddToggle('Auto Respawn (自動重生)', true, nil, function(v)
    instantrespawn = v
end)
speedh:AddSeparateBar()
speedh:AddToggle('TP Speed (傳送速度)', true, nil, function(v)
    speedbool = v
    startspeedhack()
end)
speedh:AddSlider('TP Speed Boost (傳送速度增益)', 1.5, 0, 1.2, function(c) 
    speedboost = c
end)
speedh:AddSeparateBar()
speedh:AddToggle('No Jump Cooldown (無跳躍冷卻)', true, nil, function(v)
    nojumpcd = v
    startnojumpcd()
end)
speedh:AddSeparateBar()
speedh:AddToggle('Instant Lean (即時傾斜)', true, nil, function(v)
    if scriptloading then return end
    if v then 
        require(game.ReplicatedStorage.Modules.FPS).changeLean = instantleanMODfunc
    else
        require(game.ReplicatedStorage.Modules.FPS).changeLean = instantleanOGfunc
    end
end)
speedh:AddSeparateBar()
speedh:AddToggle('Stop water effect update (停止水效更新)', true, nil, function(v)
    if scriptloading then return end

    localplayer.PlayerGui.MainGui.Scripts.HealthLocal.Disabled = v
    localplayer.PlayerGui.MainGui.Scripts.HealthLocal.Enabled = not v
end)
speedh:AddSeparateBar()
speedh:AddToggle('Humanoid changer (人型改變)', true, nil, function(v)
    changerbool = v
end)
speedh:AddSlider('Humanoid Speed (人型速度)', 21, 0, 20, function(c) 
    changerspeed = c
end)
speedh:AddSlider('Humanoid Jumpheight (人型跳躍高度)', 8, 0, 3, function(c) 
    changerjump = c
end)
speedh:AddSlider('Humanoid Height (人型高度)', 6, 0, 2, function(c) 
    changerheight = c
end)
speedh:AddSlider('Gravity (重力)', 150, 0, 75, function(c) 
    changergrav = c
end)
speedh:AddSeparateBar()
speedh:AddToggle('Semi-Fly (半空飛行)', true, Enum.KeyCode.KeypadFive, function(v) 
    if scriptloading then return end

    if localplayer.Character and localplayer.Character:FindFirstChild("HumanoidRootPart") then
        if ACBYPASS_SYNC == false then
            Notify("HihiHub", "Action in queue, wait for anticheat bypass update (動作在隊列中，請等待反作弊繞過更新)")

            while ACBYPASS_SYNC == false do
                wait(0.5)
            end
        end

        if v == false then
			semifly_bodyvel:Destroy()

            for i,v in ipairs(localplayer.Character.HumanoidRootPart:GetChildren()) do
                if v:IsA("BodyVelocity") then
                    v:Destroy()
                end
            end

            localplayer.Character.Humanoid.PlatformStand = false
		elseif v == true then
			semifly_bodyvel = Instance.new("BodyVelocity", localplayer.Character.HumanoidRootPart)
			semifly_bodyvel.Velocity = Vector3.new(0,0,0)
            localplayer.Character.Humanoid.PlatformStand = true
		end

        charsemifly = v
    else
        charsemifly = false
    end
end)
speedh:AddSlider('Semi-Fly Distance (半空飛行距離)', 6, 0.1, 5, function(c) 
    charsemiflydist = c
end)
speedh:AddSlider('Semi-Fly Speed (半空飛行速度)', 50, 5, 30, function(c) 
    charsemiflyspeed = c
end)

vmisc:AddToggle('Inventory Checker (背包檢查)', true, nil, function(v)
    invcheck = v
end)
vmisc:AddToggle('Mod notify (模組通知)', true, nil, function(v)
    if scriptloading then return end

    detectmods = v
    if v == false then
        table.clear(detectedmods)
    end
end)
vmisc:AddToggle('ESP Map (ESP 地圖)', true, Enum.KeyCode.KeypadSeven, function(v)
    if scriptloading then return end
    espmapactive = v
    handleESPMAP(v)
end)

local Legit = library:AddWindow('Skybox')
local watermark = library:AddWatermark('')

local e = Legit:AddSection('Skybox Selector')

-- Skybox 設置
local Lighting = game:GetService("Lighting")
local Sky = Lighting:FindFirstChildOfClass("Sky")
if not Sky then
    Sky = Instance.new("Sky", Lighting)
end

local SkyBoxes = {
    ["Standard"] = {
        SkyboxBk = "rbxassetid://123456",  
        SkyboxDn = "rbxassetid://123457",
        SkyboxFt = "rbxassetid://123458",
        SkyboxLf = "rbxassetid://123459",
        SkyboxRt = "rbxassetid://123460",
        SkyboxUp = "rbxassetid://123461"
    },
    ["Among Us"] = {
        SkyboxBk = "rbxassetid://5752463190",
        SkyboxDn = "rbxassetid://5752463190",
        SkyboxFt = "rbxassetid://5752463190",
        SkyboxLf = "rbxassetid://5752463190",
        SkyboxRt = "rbxassetid://5752463190",
        SkyboxUp = "rbxassetid://5752463190"
    },
    ["Spongebob"] = {
        SkyboxBk = "rbxassetid://277099484",
        SkyboxDn = "rbxassetid://277099500",
        SkyboxFt = "rbxassetid://277099554",
        SkyboxLf = "rbxassetid://277099531",
        SkyboxRt = "rbxassetid://277099589",
        SkyboxUp = "rbxassetid://277101591"
    },
    ["Deep Space"] = {
        SkyboxBk = "rbxassetid://159248188",
        SkyboxDn = "rbxassetid://159248183",
        SkyboxFt = "rbxassetid://159248187",
        SkyboxLf = "rbxassetid://159248173",
        SkyboxRt = "rbxassetid://159248192",
        SkyboxUp = "rbxassetid://159248176"
    },
    ["Winter"] = {
        SkyboxBk = "rbxassetid://510645155",
        SkyboxDn = "rbxassetid://510645130",
        SkyboxFt = "rbxassetid://510645179",
        SkyboxLf = "rbxassetid://510645117",
        SkyboxRt = "rbxassetid://510645146",
        SkyboxUp = "rbxassetid://510645195"
    },
    ["Clouded Sky"] = {
        SkyboxBk = "rbxassetid://252760981",
        SkyboxDn = "rbxassetid://252763035",
        SkyboxFt = "rbxassetid://252761439",
        SkyboxLf = "rbxassetid://252760980",
        SkyboxRt = "rbxassetid://252760986",
        SkyboxUp = "rbxassetid://252762652"
    },
}

-- 創建 Skybox 按鈕來更改天空盒並顯示提示訊息
local function changeSkybox(skyboxName)
    local selected = SkyBoxes[skyboxName]
    if selected then
        Sky.SkyboxBk = selected.SkyboxBk
        Sky.SkyboxDn = selected.SkyboxDn
        Sky.SkyboxFt = selected.SkyboxFt
        Sky.SkyboxLf = selected.SkyboxLf
        Sky.SkyboxRt = selected.SkyboxRt
        Sky.SkyboxUp = selected.SkyboxUp
        -- 顯示提示訊息
        library:AddNotification("Skybox Changed", "Skybox has been changed to '" .. skyboxName .. "'", 3)
    else
        print("Invalid Skybox: " .. skyboxName)
    end
end

-- 使用 AddDropdown 代替 AddRadioButton
local dropdown = e:AddDropdown('Select Skybox', {"Standard", "Among Us", "Spongebob", "Deep Space", "Winter", "Clouded Sky"}, false, function(skyboxName)
    changeSkybox(skyboxName)
end)

wait(2)
watermark:Visible(true)

worldh:AddToggle('Disable Grass (禁用草地)', true, nil, function(v)
    sethiddenproperty(workspace.Terrain, "Decoration", not v)
end)
worldh:AddToggle('Disable Leaves (禁用樹葉)', true, nil, function(v)
    worldleaves = v
end)
worldh:AddToggle('No clouds (無雲)', true, nil, function(v)
    if workspace.Terrain:FindFirstChild("Clouds") then
        workspace.Terrain.Clouds.Enabled = not v
    end
end)
worldh:AddSlider('Exposure (曝光)', 4, -4, 0, function(c)
    worldexpo = c
    game.Lighting.ExposureCompensation = c
end)
worldh:AddSlider('Clock time (時鐘時間)', 24, 0, 14, function(c) 
    worldclock = c
    game.Lighting.ClockTime = c
end)
-- 添加開關來編輯後期效果
worldh:AddToggle('Edit PostEffects (編輯後期效果)', true, nil, function(v)
    colorcorrectbool = v
    game.Lighting.GeographicLatitude += 0.1 -- 暫時調整以刷新效果
    game.Lighting.GeographicLatitude -= 0.1
end)

-- 添加亮度調節滑桿
worldh:AddSlider('Brightness (亮度)', 3, -3, 0, function(c) 
    colorcorrectbright = c
    game.Lighting.GeographicLatitude += 0.1 -- 暫時調整以刷新效果
    game.Lighting.GeographicLatitude -= 0.1
end)

-- 添加飽和度調節滑桿
worldh:AddSlider('Saturation (飽和度)', 3, -3, 0, function(c) 
    colorcorrectsatur = c
    game.Lighting.GeographicLatitude += 0.1 -- 暫時調整以刷新效果
    game.Lighting.GeographicLatitude -= 0.1
end)

-- 添加對比度調節滑桿
worldh:AddSlider('Contrast (對比度)', 3, -3, 0, function(c) 
    colorcorrectcontrast = c
    game.Lighting.GeographicLatitude += 0.1 -- 暫時調整以刷新效果
    game.Lighting.GeographicLatitude -= 0.1
end)

-- 添加色調顏色調節調色盤
worldh:AddColorPallete('Tint color (色調顏色)', Color3.fromRGB(255, 255, 255), function(a) 
    colorcorrecttint = a
    game.Lighting.GeographicLatitude += 0.1 -- 暫時調整以刷新效果
    game.Lighting.GeographicLatitude -= 0.1
end)

-- 添加分隔條
worldh:AddSeparateBar()

-- 添加環境光顏色調節調色盤
worldh:AddColorPallete('Ambient Color (環境光顏色)', Color3.fromRGB(255, 255, 255), function(a) 
    worldambient = a
    game.Lighting.Ambient = worldambient -- 設定環境光顏色
end)

-- 添加室外環境光顏色調節調色盤
worldh:AddColorPallete('Outdoor Ambient Color (室外環境光顏色)', Color3.fromRGB(255, 255, 255), function(a) 
    worldoutdoor = a
    game.Lighting.OutdoorAmbient = worldoutdoor -- 設定室外環境光顏色
end)
print("loading anti aim by _hai_hai")
-- UI 窗口
local AntiAim = library:AddWindow('Anti-Aim')
local watermark = library:AddWatermark('')

-- Anti-Aim 功能區域
local aaSection = AntiAim:AddSection('Anti-Aim Settings')

-- 參數設置
local yawBase = "None"
local yawOffset = 0
local pitchBase = "Down"
local antiAimEnabled = false

-- UI 選項
aaSection:AddDropdown('Yaw Base', {'None', 'Random', 'Spin', 'Targets'}, 'None', function(selected)
    yawBase = selected
    print("Yaw Base 已設置為: ", yawBase)
end)

aaSection:AddSlider('Yaw Offset', 180, -180, 0, function(value)
    yawOffset = value
    print("Yaw 偏移已設置為: ", yawOffset)
end)

aaSection:AddDropdown('Pitch Base', {'Down', 'Up', 'Nod', 'Random'}, 'Down', function(selected)
    pitchBase = selected
    print("Pitch Base 已設置為: ", pitchBase)
end)

aaSection:AddToggle('Enable Anti-Aim', true, nil, function(state)
    antiAimEnabled = state
    print("Anti-Aim 已設置為: ", state and "開啟" or "關閉")
end)

-- 線性插值的平滑旋轉
local function smoothCFrame(current, target, alpha)
    return current:Lerp(target, alpha)
end

-- Anti-Aim 功能邏輯
spawn(function()
    while wait(0.05) do -- 0.05 秒間隔
        if antiAimEnabled then
            local player = game.Players.LocalPlayer
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local root = humanoid and humanoid.RootPart
            local camera = workspace.CurrentCamera

            if humanoid and root and camera then
                humanoid.AutoRotate = false -- 禁用自動旋轉

                -- 計算 Yaw 角度
                local angle = -math.atan2(camera.CFrame.LookVector.Z, camera.CFrame.LookVector.X) + math.rad(-90)
                if yawBase == "Random" then
                    angle = math.rad(math.random(0, 360))
                elseif yawBase == "Spin" then
                    angle = tick() * 10 % 360
                end

                local offset = math.rad(yawOffset or 0)
                local targetYaw = CFrame.new(root.Position) * CFrame.Angles(0, angle + offset, 0)

                -- 平滑過渡 Yaw
                root.CFrame = smoothCFrame(root.CFrame, targetYaw, 0.1) -- 平滑度 0.1

                -- 計算 Pitch 角度
                local pitch = 0
                if pitchBase == "Down" then
                    pitch = -1
                elseif pitchBase == "Up" then
                    pitch = 1
                elseif pitchBase == "Nod" then
                    pitch = math.sin(tick() * 2)
                elseif pitchBase == "Random" then
                    pitch = math.random() / 10
                end

                -- 傳送 Pitch 值
                game.ReplicatedStorage.Remotes.UpdateTilt:FireServer(pitch)
            end
        end
    end
end)

--tracers--
print("loading tracers by _hai_hai")
local function runtracer(start, endp)
    local beam = Instance.new("Beam")
    beam.Name = "LineBeam"
    beam.Parent = game.Workspace
    local startpart = Instance.new("Part")
    startpart.CanCollide = false
    startpart.CanQuery = false
    startpart.Transparency = 1
    startpart.Position = start
    startpart.Parent = workspace
    startpart.Anchored = true
    startpart.Size = Vector3.new(0.01, 0.01, 0.01)
    local endpart = Instance.new("Part")
    endpart.CanCollide = false
    endpart.CanQuery = false
    endpart.Transparency = 1
    endpart.Position = endp
    endpart.Parent = workspace
    endpart.Anchored = true
    endpart.Size = Vector3.new(0.01, 0.01, 0.01)
    beam.Attachment0 = Instance.new("Attachment", startpart)
    beam.Attachment1 = Instance.new("Attachment", endpart)
    beam.Color = ColorSequence.new(traccolor,  traccolor)
    beam.Width0 = 0.05
    beam.Width1 = 0.05
    beam.FaceCamera = true
    beam.Transparency = NumberSequence.new(0)
    beam.LightEmission = 1

    if tractexture ~= nil then
        beam.Texture = tractexture
        if tractexture == "http://www.roblox.com/asset/?id=131326755401058" then
            beam.TextureSpeed = 3
            beam.TextureLength = (endp - start).Magnitude
            beam.Width0 = 0.3
            beam.Width1 = 0.3
        end
    end

    wait(tracwait)

    beam:Destroy()
    startpart:Destroy()
    endpart:Destroy()
end
--silent aim--
print("loading silent aim by _hai_hai")
local function isonscreen(object)
    local _, bool = wcamera:WorldToScreenPoint(object.Position)
    return bool
end
local v311 = require(game.ReplicatedStorage.Modules:WaitForChild("UniversalTables"))
local globalist11 = v311.ReturnTable("GlobalIgnoreListProjectile")
local function isvisible(char, object)
    if not localplayer.Character or not localplayer.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    if aimvischeck == false then
        return true
    end

    local origin = localplayer.Character.HumanoidRootPart.Position + Vector3.new(0, 1, 0)
    if aimselftrack then
        local plrping = localplayer:GetNetworkPing()
        local key = math.floor((plrping + 5) / 10) * 10

        if selftrack_data[key] ~= nil then
            origin = selftrack_data[key]
        end
    end

    local pos = object.Position
    local dir = pos - origin
    local dist = dir.Magnitude + 5
    local penetrated = true
    dir = dir.Unit

    local params = RaycastParams.new()
    params.IgnoreWater = true
    params.CollisionGroup = "WeaponRay"
    params.FilterDescendantsInstances = {
        localplayer.Character:GetChildren(),
        wcamera:GetChildren(),
        globalist11,
        aimignoreparts
    }

    local ray = workspace:Raycast(origin, dir * dist, params)
    if aimbang then
        if ray and ray.Instance:IsDescendantOf(char) then
            return true
        elseif ray and ray.Instance.Name ~= "Terrain" and not ray.Instance:GetAttribute("NoPen") then
            local armorpen4 = 10
            if globalammo then
                armorpen4 = globalammo:GetAttribute("ArmorPen")
            end

            local FunctionLibraryExtension = require(game.ReplicatedStorage.Modules.FunctionLibraryExtension)
            local armorpen1, newpos2 = FunctionLibraryExtension.Penetration(FunctionLibraryExtension, ray.Instance, ray.Position, dir, armorpen4)
            if armorpen1 == nil or newpos2 == nil then
                return false
            end

            local neworigin = ray.Position + dir * 0.01
            local newray = workspace:Raycast(neworigin, dir * (dist - (neworigin - origin).Magnitude), params)
            if newray and newray.Instance:IsDescendantOf(char) then
                return true
            end
        end
    else
        if ray and ray.Instance:IsDescendantOf(char) then
            return true
        end
    end

    return false
end
local function predictpos(tpart, bulletspeed, bulletdrop)
    local velocity = tpart.Velocity
    local distance = (wcamera.CFrame.Position - tpart.CFrame.Position).Magnitude
    local tth = (distance / bulletspeed)
    local predict1 = tpart.CFrame.Position + (velocity * tth)
    local delta = (predict1 - tpart.CFrame.Position).Magnitude
    local finalspeed = bulletspeed - 0.013 * bulletspeed ^ 2 * tth ^ 2
    tth += (delta / finalspeed)
    local predictres1 = tpart.CFrame.Position + (velocity * tth)
    local predictres2 = bulletdrop * tth ^ 2
    if tostring(drop_timing):find("nan") then
        predictres2 = 0
    end
    return predictres1 -- + Vector3.new(0,predictres2,0)
end
local function choosetarget()
    local cent = Vector2.new(wcamera.ViewportSize.X / 2, wcamera.ViewportSize.Y / 2)
    local cdist = math.huge
    local ctar = nil
    local cpart = nil

    local ammodistance = 999999999
    if aimdistcheck and globalammo then
        ammodistance = globalammo:GetAttribute("MuzzleVelocity")
    end

    local bparts = {
        "Head",
        "HeadTopHitBox",
        "FaceHitBox",
        "UpperTorso",
        "LowerTorso",
        "LeftUpperArm",
        "RightUpperArm",
        "LeftLowerArm",
        "RightLowerArm",
        "LeftHand",
        "RightHand",
        "LeftUpperLeg",
        "RightUpperLeg",
        "LeftLowerLeg",
        "RightLowerLeg",
        "LeftFoot",
        "RightFoot"
    }

    local function chooseTpart(charact)
        if aimpart == "Head" then
            return charact:FindFirstChild("Head")
        elseif aimpart == "HeadTop" then
            return charact:FindFirstChild("HeadTopHitBox")
        elseif aimpart == "Face" then
            return charact:FindFirstChild("FaceHitBox")
        elseif aimpart == "Torso" then
            return charact:FindFirstChild("UpperTorso")
        elseif aimpart == "Scripted" then
            local head = charact:FindFirstChild("Head")
            local upperTorso = charact:FindFirstChild("UpperTorso")
            if not isvisible(charact, head) then
                return upperTorso
            else
                return head
            end
        elseif aimpart == "Random" then
            return charact:FindFirstChild(bparts[math.random(1, #bparts)])
        end
    end

    if aimbots then --priority 2 (bots)
        for _, botfold in ipairs(workspace.AiZones:GetChildren()) do
            for _, bot in ipairs(botfold:GetChildren()) do
                if bot:IsA("Model") and bot:FindFirstChild("Humanoid") and bot.Humanoid.Health > 0 then
                    if friendlistbots then
                        if friendlistmode == "Blacklist" then 
                            if table.find(aimFRIENDLIST, bot.Name) ~= nil then
                                continue
                            end
                        elseif friendlistmode == "Whitelist" then 
                            if table.find(aimFRIENDLIST, bot.Name) == nil then
                                continue
                            end
                        end
                    end

                    local potroot = chooseTpart(bot)
                    if potroot and localplayer.Character then
                        local spoint = wcamera:WorldToViewportPoint(potroot.Position)
                        local optpoint = Vector2.new(spoint.X, spoint.Y)
                        local dist = (optpoint - cent).Magnitude
                        
                        local betweendist = (localplayer.Character.PrimaryPart.Position - potroot.Position).Magnitude * 0.3336
                        local betweendistSTUDS = (localplayer.Character.PrimaryPart.Position - potroot.Position).Magnitude
                        if dist <= aimfovcircle.Radius and dist < cdist and betweendist < aimdistance and betweendistSTUDS < ammodistance then
                            local canvis = isvisible(bot, potroot)
                            if canvis and isonscreen(potroot) then
                                cdist = dist
                                ctar = bot
                                cpart = potroot
                            end
                        end
                    end
                end
            end
        end
    end

    for _, pottar in ipairs(game.Players:GetPlayers()) do --priority 1 (players)
        if pottar ~= localplayer and pottar.Character and localplayer.Character.PrimaryPart ~= nil then
            if friendlistmode == "Blacklist" then 
                if table.find(aimFRIENDLIST, pottar.Name) ~= nil then
                    continue
                end
            elseif friendlistmode == "Whitelist" then 
                if table.find(aimFRIENDLIST, pottar.Name) == nil then
                    continue
                end
            end

            local potroot = chooseTpart(pottar.Character)
            if potroot then
                local spoint = wcamera:WorldToViewportPoint(potroot.Position)
                local optpoint = Vector2.new(spoint.X, spoint.Y)
                local dist = (optpoint - cent).Magnitude
                
                local betweendist = (localplayer.Character.PrimaryPart.Position - potroot.Position).Magnitude * 0.3336
                local betweendistSTUDS = (localplayer.Character.PrimaryPart.Position - potroot.Position).Magnitude
                if dist <= aimfovcircle.Radius and dist < cdist and betweendist < aimdistance and betweendistSTUDS < ammodistance then
                    local canvis = isvisible(pottar.Character, potroot)
                    if canvis and isonscreen(potroot) then
                        cdist = dist
                        ctar = pottar
                        cpart = potroot
                    end
                end
            end
        end
    end

    if ctar == nil then
        aimtarget = nil
        aimtargetpart = nil
    else
        aimtarget = ctar
        aimtargetpart = cpart
    end
end

aimmodfunc = function(prikol, p49, p50, p_u_51, _, p52, p53, p54, p55)
    local v_u_6 = game.ReplicatedStorage.Remotes.VisualProjectile
    local v_u_108 = 1
    local v_u_106 = 0
    local v_u_7 = game.ReplicatedStorage.Remotes.FireProjectile
    local target = aimtarget
    local target_part
    local v_u_4 = require(game.ReplicatedStorage.Modules:WaitForChild("FunctionLibraryExtension"))
    local v_u_15 = localplayer
    local v_u_115 = v_u_4:GetEstimatedCameraPosition(v_u_15)
    local v_u_103
    local v_u_114
    local v_u_16 = game.ReplicatedStorage.Players:FindFirstChild(v_u_15.Name)
    local v_u_64 = v_u_16.Status.GameplayVariables:GetAttribute("EquipId")
    local v_u_13 = game.ReplicatedStorage:WaitForChild("VFX")
    local v_u_2 = require(game.ReplicatedStorage.Modules:WaitForChild("VFX"))
    local v3 = require(game.ReplicatedStorage.Modules:WaitForChild("UniversalTables"))
    local v_u_5 = game.ReplicatedStorage.Remotes.ProjectileInflict
    local v_u_10 = game:GetService("ReplicatedStorage")
    local v_u_12 = v_u_10:WaitForChild("RangedWeapons")
    local v_u_17 = game.ReplicatedStorage.Temp
    local v_u_56 = v_u_15.Character
    local v135 = 500000
    local v_u_18 = v3.ReturnTable("GlobalIgnoreListProjectile")
    local v_u_115 = v_u_4:GetEstimatedCameraPosition(v_u_15)
    local v65 = v_u_10.AmmoTypes:FindFirstChild(p52)
    local v_u_74 = v65:GetAttribute("Pellets")
    local v60 = p50.ItemRoot
    local v61 = p49.ItemProperties
    local v62 = v_u_12:FindFirstChild(p49.Name)
    local v63 = v61:FindFirstChild("SpecialProperties")
    local v_u_66 = v63 and v63:GetAttribute("TracerColor") or v62:GetAttribute("ProjectileColor")
    local itemprop = require(v_u_16.Inventory:FindFirstChild(p49.Name).SettingsModule)
    local bulletspeed = v65:GetAttribute("MuzzleVelocity")
    local armorpen4 = v65:GetAttribute("ArmorPen")
    local tracerendpos = Vector3.zero
    local v79 = {
        ["x"] = {
            ["Value"] = 0
        },
        ["y"] = {
            ["Value"] = 0
        }
    }

    if v_u_56:FindFirstChild(p49.Name) then
        local v83 = 0.001 
        local v82 = 0.001
        local v81 = 10000
        if v61.Tool:GetAttribute("MuzzleDevice") or "Default" == "Suppressor" then
            if tick() - p53 < 0.8 then
                v_u_4:PlaySoundV2(v60.FireSoundSupressed, v60.FireSoundSupressed.TimeLength, v_u_17)
            else
                v_u_4:PlaySoundV2(v60.FireSoundSupressed, v60.FireSoundSupressed.TimeLength, v_u_17)
            end
        elseif tick() - p53 < 0.8 then
            v_u_4:PlaySoundV2(v60.FireSound, v60.FireSound.TimeLength, v_u_17)
        else
            v_u_4:PlaySoundV2(v60.FireSound, v60.FireSound.TimeLength, v_u_17)
        end
        local v_u_59
        if p_u_51.Item.Attachments:FindFirstChild("Front") then
            v_u_59 = p_u_51.Item.Attachments.Front:GetChildren()[1].Barrel
            local _ = p50.Attachments.Front:GetChildren()[1].Barrel
        else
            v_u_59 = p_u_51.Item.Barrel
            local _ = p50.Barrel
        end

        if target ~= nil and aimtargetpart ~= nil then
            target_part = aimtargetpart
            if aimtype == "Prediction" then
                local buldrop = v65:GetAttribute("ProjectileDrop")
                local bulsp = v65:GetAttribute("MuzzleVelocity")
                target_part = predictpos(target_part, bulsp, buldrop)
                v_u_103 = CFrame.new(v_u_115, target_part).LookVector
            else
                v_u_103 = CFrame.new(v_u_115, target_part.Position).LookVector
            end
            v_u_114 = v_u_103
        else
            target_part = p55
            v_u_103 = CFrame.new(v_u_115, v_u_15:GetMouse().Hit.Position).LookVector
            v_u_114 = v_u_103
        end

        function v185()
            local v_u_110 = RaycastParams.new()
            v_u_110.FilterType = Enum.RaycastFilterType.Exclude
            local v_u_111 = { v_u_56, p_u_51, v_u_18, aimignoreparts}
            v_u_110.FilterDescendantsInstances = v_u_111
            v_u_110.CollisionGroup = "WeaponRay"
            v_u_110.IgnoreWater = true

            v_u_106 += 1

            local usethisvec = v_u_114
            if aimdebug1 then
                usethisvec = Vector3.new(0,1,0)
            end

            if v_u_106 == 1 then
                task.spawn(function()
                    for i=1, multitaps do
                        if aimtype == "Instant Hit" then
                            if not v_u_7:InvokeServer(usethisvec, v_u_108, tick()-15) then 
                                game.ReplicatedStorage.Modules.FPS.Binds.AdjustBullets:Fire(v_u_64, 1)
                            end
                        else
                            if not v_u_7:InvokeServer(usethisvec, v_u_108, tick()) then 
                                game.ReplicatedStorage.Modules.FPS.Binds.AdjustBullets:Fire(v_u_64, 1)
                            end
                        end
                    end
                end)
            elseif 1 < v_u_106 then
                for i=1, multitaps do
                    v_u_6:FireServer(usethisvec, v_u_108)
                end
            end

            local v_u_131 = nil
            local v_u_132 = 0
            local v_u_133 = 0

            if (aimtype == "Prediction" or aimfakewait) and target ~= nil then
                local tpart 
                if target:IsA("Model") then
                    tpart = target.HumanoidRootPart
                else
                    tpart = target.Character.HumanoidRootPart
                end
                local velocity = tpart.Velocity
                local distance = (wcamera.CFrame.Position - tpart.CFrame.Position).Magnitude
                local tth = (distance / bulletspeed)
                task.wait(tth + 0.01)

                if aimtarget ~= nil and aimtargetpart ~= nil then
                    target_part = aimtargetpart
                    if aimtype == "Prediction" then
                        local buldrop = v65:GetAttribute("ProjectileDrop")
                        local bulsp = v65:GetAttribute("MuzzleVelocity")
                        target_part = predictpos(target_part, bulsp, buldrop)
                        v_u_103 = CFrame.new(v_u_115, target_part).LookVector
                    else
                        v_u_103 = CFrame.new(v_u_115, target_part.Position).LookVector
                    end
                    v_u_114 = v_u_103
                else
                    target_part = p55
                    v_u_103 = CFrame.new(v_u_115, v_u_15:GetMouse().Hit.Position).LookVector
                    v_u_114 = v_u_103
                end
            end

            local penetrated = false

            function v184(p134)
                v_u_132 = v_u_132 + p134
                if true then
                    v_u_133 = v_u_133 + v_u_132
                    local v136 = workspace:Raycast(v_u_115, v_u_114 * v135, v_u_110)
                    local v137 = nil
                    local v138 = nil
                    local v139 = nil
                    local v140
                    if v136 then
                        v137 = v136.Instance
                        v140 = v136.Position
                        v138 = v136.Normal
                        v139 = v136.Material
                    else
                        v140 = v_u_115 + v_u_114 * v135
                    end

                    if v137 == nil then
                        v_u_131:Disconnect()
                        return
                    end

                    tracerendpos = v140

                    local v171 = v_u_4:FindDeepAncestor(v137, "Model")
                    if v171:FindFirstChild("Humanoid") then -- if hit target
                        local ran = math.random(1, 100)
                        local ranbool = ran <= aimchance
                        if ranbool then
                            local v175 = v137.CFrame:ToObjectSpace(CFrame.new(v140))

                            if target_part and penetrated == false then
                                v_u_5:FireServer(target_part, v175, v_u_108, tick())
                            else
                                v_u_5:FireServer(v137, v175, v_u_108, tick())
                            end
                        else
                            local v175 = v137.CFrame:ToObjectSpace(CFrame.new(v140))
                            v_u_5:FireServer(p55, v175, v_u_108, tick())
                        end

                        v_u_2.Impact(v137, v140, v138, v139, v_u_114, "Ranged", true)
                    elseif v137.Name == "Terrain" then -- if hit terrain
                        local v175 = v137.CFrame:ToObjectSpace(CFrame.new(v140))
                        v_u_5:FireServer(v137, v175, v_u_108, tick())

                        v_u_2.Impact(v137, v140, v138, v139, v_u_114, "Ranged", true)
                    else -- if hit not target then try wallpen
                        v_u_2.Impact(v137, v140, v138, v139, v_u_114, "Ranged", true)

                        local arg1, arg2, arg3 = v_u_4.Penetration(v_u_4, v137, v140, v_u_114, armorpen4)
                        if arg1 == nil or arg2 == nil then
                            local v175 = v137.CFrame:ToObjectSpace(CFrame.new(v140))
                            v_u_5:FireServer(v137, v175, v_u_108, tick())
                            v_u_131:Disconnect()
                            return
                        end

                        armorpen4 = arg1
                        if armorpen4 > 0 then
                            v_u_115 = arg2
                            v_u_2.Impact(unpack(arg3))
                            penetrated = true
                            return
                        end

                        v_u_131:Disconnect()
                        return
                    end
                end

                v_u_131:Disconnect()
                return
            end
            v_u_131 = game:GetService("RunService").RenderStepped:Connect(v184)
            return
        end
        if v_u_74 == nil then
            task.spawn(v185)
        else
            for _ = 1, v_u_74 do
                task.spawn(v185)
            end
        end

        if tracbool then
            task.spawn(function()
                task.wait(0.05)
                if tracerendpos == Vector3.zero then return end
                runtracer(v60.Position, tracerendpos)
            end)
        end

        return v83, v82, v81, v79
    end
end
--esp--
print("loading ESP functions/connections")
local function setupesp(obj, dtype, otype1)
    if not obj then return end

    local dobj
    local tableinfo
    if dtype == "Name" then
        dobj = Drawing.new("Text")
        dobj.Visible = espbool
        dobj.Center = true
        dobj.Outline = true
        dobj.Size = esptextsize
        dobj.Color = esptextcolor
        dobj.OutlineColor = Color3.new(0, 0, 0)
        tableinfo = {
            primary = obj,
            type = "Name",
            otype = otype1
        }
    elseif dtype == "HP" then
        dobj = Drawing.new("Text")
        dobj.Visible = espbool
        dobj.Center = true
        dobj.Outline = true
        dobj.Size = esptextsize
        dobj.Color = esptextcolor
        dobj.OutlineColor = Color3.new(0, 0, 0)
        tableinfo = {
            primary = obj,
            type = "HP",
            otype = otype1
        }
    elseif dtype == "Distance" then
        dobj = Drawing.new("Text")
        dobj.Visible = espbool
        dobj.Center = true
        dobj.Outline = true
        dobj.Size = esptextsize
        dobj.Color = esptextcolor
        dobj.OutlineColor = Color3.new(0, 0, 0)
        tableinfo = {
            primary = obj,
            type = "Distance",
            otype = otype1
        }
    elseif dtype == "Hotbar" then
        dobj = Drawing.new("Text")
        dobj.Visible = espbool
        dobj.Center = true
        dobj.Outline = true
        dobj.Size = esptextsize
        dobj.Color = esptextcolor
        dobj.OutlineColor = Color3.new(0, 0, 0)
        tableinfo = {
            primary = obj,
            type = "Hotbar",
            otype = otype1
        }
    elseif dtype == "Highlight" then
        dobj = Instance.new("Highlight")
        dobj.Name = "HihiHub highlight solter dont delete PLS"
        dobj.FillColor = espfillcolor
        dobj.OutlineColor = esplinecolor
        dobj.FillTransparency = espchamsfill
        dobj.OutlineTransparency = espchamsline
        if obj.Parent:IsA("Model") then
            dobj.Parent = obj.Parent
        else
            dobj:Destroy()
            return
        end

        dobj.Enabled = esphigh
        tableinfo = {
            primary = obj,
            type = "Highlight",
            otype = otype1
        }
    end

    if dobj == nil or tableinfo == nil then return end

    local function selfdestruct() --destroy esp object
        if dtype == "Highlight" then
            dobj.Enabled = false
            dobj:Destroy()
        else
            dobj.Visible = false
            dobj:Remove()
        end
        if removing then
            removing:Disconnect()
            removing = nil
        end
        return
    end

    if esptable[dobj] ~= nil then --if in table then cancel
        selfdestruct()
        return
    else
        esptable[dobj] = tableinfo
    end

    removing = workspace.DescendantRemoving:Connect(function(what)
        if what == obj then
            esptable[dobj] = nil
            selfdestruct()
        end
    end)
end
local function startesp(v, otype) --start esp for model
    if not v then return end

    task.spawn(function()
        if otype == "Extract" then
            setupesp(v, "Name", otype)
            setupesp(v, "Distance", otype)
        elseif otype == "Loot" then
            local Amount
            local TotalPrice = 0
            local Value = 0

            if v.Parent and v.Parent:FindFirstChild("Inventory") then else
                return
            end

            for _, i in ipairs(v.Parent.Inventory:GetChildren()) do
                Amount = i.ItemProperties:GetAttribute("Amount") or 1
                TotalPrice += i.ItemProperties:GetAttribute("Price") or 0
                Value += (valcache[i.ItemProperties:GetAttribute("CallSign")] or 0) * Amount
            end --original = https://rbxscript.com/post/ProjectDeltaLootEsp-P7xaS

            if Value >= 4 then
                setupesp(v, "Name", otype)
                setupesp(v, "Hotbar", otype)
                setupesp(v, "Distance", otype)
            end
        elseif otype == "Dead333" then
            local hd = v:WaitForChild("Head",1)
            if hd == nil then return end
            setupesp(hd, "Name", otype)
            setupesp(hd, "Distance", otype)
        else
            local hd = v:WaitForChild("Head",1)
            if hd == nil then return end
            setupesp(hd, "Name", otype)
            setupesp(hd, "HP", otype)
            setupesp(hd, "Distance", otype)
            setupesp(hd, "Hotbar", otype)
            setupesp(hd, "Highlight", otype) 
        end
    end)
end
for i,v in ipairs(workspace:GetDescendants()) do
    if v and v:FindFirstChild("Humanoid") and v ~= localplayer.Character then
        if game.Players:FindFirstChild(v.Name) and not v:FindFirstAncestor("DroppedItems") then
            startesp(v, "Plr")
        elseif v:FindFirstAncestor("AiZones") then
            startesp(v, "Bot333")
        elseif v:FindFirstAncestor("DroppedItems") then
            startesp(v, "Dead333")
        end
    elseif v.Parent == workspace:FindFirstChild("NoCollision"):FindFirstChild("ExitLocations") then
        startesp(v, "Extract")
    elseif v:FindFirstAncestor("Containers") and v:IsA("MeshPart") then
        if v.Parent:IsA("Model") then
            startesp(v, "Loot")
        end
    end
end
workspace.DescendantAdded:Connect(function(v)
    if v and v.Parent and v:IsA("BasePart") and v.Name == "Head" then
        local hum = v.Parent:WaitForChild("Humanoid", 2)
        if hum and v.Parent ~= localplayer.Character then
            if game.Players:FindFirstChild(v.Parent.Name) and not v:FindFirstAncestor("DroppedItems") then
                startesp(v.Parent, "Plr")
            elseif v:FindFirstAncestor("AiZones") then
                startesp(v.Parent, "Bot333")
            elseif v:FindFirstAncestor("DroppedItems") then
                startesp(v.Parent, "Dead333")
            end
        end
    elseif v.Parent == workspace:FindFirstChild("NoCollision"):FindFirstChild("ExitLocations") then
        startesp(v, "Extract")
    elseif v:FindFirstAncestor("Containers") and v:IsA("MeshPart") then
        if v.Parent:IsA("Model") then
            startesp(v, "Loot")
        end
    end
end)
--speedhack--
print("loading speedhack function by _hai_hai")
function startspeedhack() --paste2
    local speaker = game:GetService("Players").LocalPlayer
    local chr = speaker.Character
    local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
    local hb = game:GetService("RunService").Heartbeat
    while speedbool and chr and hum and hum.Parent do
        local delta = hb:Wait()
        if hum.MoveDirection.Magnitude > 0 then
            chr:TranslateBy(hum.MoveDirection * tonumber(speedboost) * delta * 10)
        else
            chr:TranslateBy(hum.MoveDirection * delta * 10)
        end
    end
end

--no jump cd--
print("loading bunnyhop functionby _hai_hai")
function startnojumpcd() --btw this not paste i found it myself
    while nojumpcd do
        task.wait(0.01)
        if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid:SetAttribute("JumpCooldown", tick())
        else
            wait(1)
        end
    end
end

--fullbright--
print("loading fullbright")
pcall(function() --paste1
    local lighting = game:GetService("Lighting");
    lighting.Ambient = worldambient
    lighting.OutdoorAmbient = worldoutdoor
    lighting.Brightness = 1;
    lighting.FogEnd = 100000
    lighting.GlobalShadows = false
	for i,v in pairs(lighting:GetDescendants()) do
		if v:IsA("Atmosphere") then
			v:Destroy()
		end
	end
    for i, v in pairs(lighting:GetDescendants()) do
        if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") then
            v.Enabled = false;
        end;
    end;
    lighting.Changed:Connect(function()
        lighting.Ambient = worldambient
        lighting.Brightness = 1;
        lighting.FogEnd = 100000
        lighting.OutdoorAmbient = worldoutdoor
        lighting.ClockTime = worldclock
        lighting.ExposureCompensation = worldexpo

        if colorcorrectbool then
            lighting.PostEffects.Enabled = true
            lighting.PostEffects.Brightness = colorcorrectbright
            lighting.PostEffects.Saturation = colorcorrectsatur
            lighting.PostEffects.Contrast = colorcorrectcontrast
            lighting.PostEffects.TintColor = colorcorrecttint
        else
            lighting.PostEffects.Enabled = false
        end

        local atmo = lighting:FindFirstChildOfClass("Atmosphere")
        if atmo then
            atmo:Destroy()
        end
    end);
    --[[
    spawn(function()
        local character = localplayer.Character;
        while wait(2) do
            repeat wait(2) until character ~= nil;
            if character:FindFirstChild("HumanoidRootPart") and not character.HumanoidRootPart:FindFirstChildWhichIsA("PointLight") then
                local headlight = Instance.new("PointLight", character.HumanoidRootPart);
                headlight.Brightness = 1;
                headlight.Range = 60;
            end;
        end;
    end);
    ]]
end)


--camera--
print("loading fov changer by _hai_hai")
do --fov changer
    local csys = require(game.ReplicatedStorage.Modules.CameraSystem)
    local dop2 = require(game.ReplicatedStorage.Modules.spring).new(Vector3.new(), Vector3.new(), Vector3.new(), 15, 0.5)
    local dop3 = game:GetService("TweenService")
    local dop4 = workspace.Camera
    local dop5 = false
    local dop6 = 1
    local dop7 = false
    local dop8 = 1
    local dop9 = 1
    local dop10 = nil
    local function FieldOfViewUpdate(p11, p12, p13) 
        local v14 = p12 or Enum.EasingStyle.Quad
        local v15 = p13 or Enum.EasingDirection.Out
        local targetfov
        if dop8 > 1 then
            targetfov = zoomfov
        else
            targetfov = basefov
        end
        local v16 = dop9 ~= 1 and dop9 or dop5 and dop6 or targetfov
        dop3:Create(dop4, TweenInfo.new(p11, v14, v15), {
            ["FieldOfView"] = v16 > 1 and dop7 and v16 or v16
        }):Play()
        if dop10 then
            local v_u_17 = dop10
            task.spawn(function() 
                local v_u_18 = v_u_17:FindFirstChild("Head") or v_u_17.PrimaryPart
                dop2.p = v_u_18.Position
                local v_u_19 = nil
                v_u_19 = game:GetService("RunService").RenderStepped:Connect(function(p20)
                    dop4.CFrame = CFrame.lookAt(dop4.CFrame.Position, dop2.p)
                    dop2.target = v_u_18.Position
                    dop2:update(p20)
                    if dop10 ~= v_u_17 then
                        v_u_19:Disconnect()
                    end
                end)
            end)
        end
    end
    camzoomfunction = function(_, p21, p22, p23, p24, p25)
        dop7 = p22
        dop8 = p21
        FieldOfViewUpdate(p23, p24, p25)
    end
end
--insta equip 
print("loading insta equip")
workspace.Camera.ChildAdded:Connect(function(ch)
    if instaequip and ch:IsA("Model") then
        task.wait(0.015)
        for i,v in ch.Humanoid.Animator:GetPlayingAnimationTracks() do
            if v.Animation.Name == "Equip" then
                --v:AdjustSpeed(15)
                v.TimePosition = v.Length - 0.01
            end
        end
    end
end)
--instant reload--
print("loading instant reload function by _hai_hai")
    instrelMODfunc = function(a1,a2)
        local function aaa(a1)
            local v27_2_ = a1.weapon
            local v27_1_ = v27_2_.Attachments
            local v27_3_ = "Magazine"
            v27_1_ = v27_1_:FindFirstChild(v27_3_)
            if v27_1_ then
                local v27_4_ = a1.weapon
                v27_3_ = v27_4_.Attachments
                v27_2_ = v27_3_.Magazine
                v27_2_ = v27_2_:GetChildren()
                v27_1_ = v27_2_[-1]
                if v27_1_ then
                    v27_2_ = v27_1_.ItemProperties
                    v27_4_ = "LoadedAmmo"
                    v27_2_ = v27_2_:GetAttribute(v27_4_)
                    a1.Bullets = v27_2_
                    v27_2_ = {}
                    a1.BulletsList = v27_2_
                    v27_3_ = v27_1_.ItemProperties
                    v27_2_ = v27_3_.LoadedAmmo
                    v27_3_ = v27_2_:GetChildren()
                    local v27_6_ = 1
                    v27_4_ = #v27_3_
                    local v27_5_ = 1
                    for v27_6_ = v27_6_, v27_4_, v27_5_ do
                        local v27_7_ = a1.BulletsList
                        local v27_10_ = v27_3_[v27_6_]
                        local v27_9_ = v27_10_.Name
                        local v27_8_ = tonumber
                        v27_8_ = v27_8_(v27_9_)
                        v27_9_ = {}
                        v27_10_ = v27_3_[v27_6_]
                        local v27_12_ = "AmmoType"
                        v27_10_ = v27_10_:GetAttribute(v27_12_)
                        v27_9_.AmmoType = v27_10_
                        v27_10_ = v27_3_[v27_6_]
                        v27_12_ = "Amount"
                        v27_10_ = v27_10_:GetAttribute(v27_12_)
                        v27_9_.Amount = v27_10_
                        v27_7_[v27_8_] = v27_9_
                    end
                end
                v27_2_ = 0
                a1.movementModifier = v27_2_
                v27_2_ = a1.weapon
                if v27_2_ then
                    v27_2_ = a1.movementModifier
                    local v27_6_ = a1.weapon
                    local v27_5_ = v27_6_.ItemProperties
                    v27_4_ = v27_5_.Tool
                    v27_6_ = "MovementModifer"
                    v27_4_ = v27_4_:GetAttribute(v27_6_)
                    v27_3_ = v27_4_ or 0.000000
                    v27_2_ += v27_3_
                    a1.movementModifier = v27_2_
                    v27_2_ = a1.weapon
                    v27_4_ = "Attachments"
                    v27_2_ = v27_2_:FindFirstChild(v27_4_)
                    if v27_2_ then
                        v27_3_ = a1.weapon
                        v27_2_ = v27_3_.Attachments
                        v27_2_ = v27_2_:GetChildren()
                        v27_5_ = 1
                        v27_3_ = #v27_2_
                        v27_4_ = 1
                        for v27_5_ = v27_5_, v27_3_, v27_4_ do
                            v27_6_ = v27_2_[v27_5_]
                            local v27_8_ = "StringValue"
                            v27_6_ = v27_6_:FindFirstChildOfClass(v27_8_)
                            if v27_6_ then
                                local v27_7_ = v27_6_.ItemProperties
                                local v27_9_ = "Attachment"
                                v27_7_ = v27_7_:FindFirstChild(v27_9_)
                                if v27_7_ then
                                    v27_7_ = a1.movementModifier
                                    local v27_10_ = v27_6_.ItemProperties
                                    v27_9_ = v27_10_.Attachment
                                    local v27_11_ = "MovementModifer"
                                    v27_9_ = v27_9_:GetAttribute(v27_11_)
                                    v27_8_ = v27_9_ or 0.000000
                                    v27_7_ += v27_8_
                                    a1.movementModifier = v27_7_
                                end
                            end
                            return
                        end
                    end
                end
            end
            v27_2_ = a1.weapon
            v27_1_ = v27_2_.ItemProperties
            v27_3_ = "LoadedAmmo"
            v27_1_ = v27_1_:GetAttribute(v27_3_)
            a1.Bullets = v27_1_
            v27_1_ = {}
            a1.BulletsList = v27_1_
            v27_3_ = a1.weapon
            v27_2_ = v27_3_.ItemProperties
            v27_1_ = v27_2_.LoadedAmmo
            v27_2_ = v27_1_:GetChildren()
            local v27_5_ = 1
            v27_3_ = #v27_2_
            local v27_4_ = 1
            for v27_5_ = v27_5_, v27_3_, v27_4_ do
                local v27_6_ = a1.BulletsList
                local v27_9_ = v27_2_[v27_5_]
                local v27_8_ = v27_9_.Name
                local v27_7_ = tonumber
                v27_7_ = v27_7_(v27_8_)
                v27_8_ = {}
                v27_9_ = v27_2_[v27_5_]
                local v27_11_ = "AmmoType"
                v27_9_ = v27_9_:GetAttribute(v27_11_)
                v27_8_.AmmoType = v27_9_
                v27_9_ = v27_2_[v27_5_]
                v27_11_ = "Amount"
                v27_9_ = v27_9_:GetAttribute(v27_11_)
                v27_8_.Amount = v27_9_
                v27_6_[v27_7_] = v27_8_
            end
        end
        local v103_2_ = a1.viewModel
        if v103_2_ then
            local v103_3_ = a1.viewModel
            v103_2_ = v103_3_.Item
            local v103_4_ = "AmmoTypes"
            v103_2_ = v103_2_:FindFirstChild(v103_4_)
            if v103_2_ then
                local v103_5_ = a1.weapon
                v103_4_ = v103_5_.ItemProperties
                v103_3_ = v103_4_.AmmoType
                v103_2_ = v103_3_.Value
                v103_5_ = a1.viewModel
                v103_4_ = v103_5_.Item
                v103_3_ = v103_4_.AmmoTypes
                v103_3_ = v103_3_:GetChildren()
                local v103_6_ = 1
                v103_4_ = #v103_3_
                v103_5_ = 1
                for v103_6_ = v103_6_, v103_4_, v103_5_ do
                    local v103_7_ = v103_3_[v103_6_]
                    local v103_8_ = 1
                    v103_7_.Transparency = v103_8_
                end
                v103_6_ = a1.viewModel
                v103_5_ = v103_6_.Item
                v103_4_ = v103_5_.AmmoTypes
                v103_6_ = v103_2_
                v103_4_ = v103_4_:FindFirstChild(v103_6_)
                v103_5_ = 0
                v103_4_.Transparency = v103_5_
                v103_5_ = a1.viewModel
                v103_4_ = v103_5_.Item
                v103_6_ = "AmmoTypes2"
                v103_4_ = v103_4_:FindFirstChild(v103_6_)
                if v103_4_ then
                    v103_6_ = a1.viewModel
                    v103_5_ = v103_6_.Item
                    v103_4_ = v103_5_.AmmoTypes2
                    v103_4_ = v103_4_:GetChildren()
                    local v103_7_ = 1
                    v103_5_ = #v103_4_
                    v103_6_ = 1
                    for v103_7_ = v103_7_, v103_5_, v103_6_ do
                        local v103_8_ = v103_4_[v103_7_]
                        local v103_9_ = 1
                        v103_8_.Transparency = v103_9_
                    end
                    v103_7_ = a1.viewModel
                    v103_6_ = v103_7_.Item
                    v103_5_ = v103_6_.AmmoTypes2
                    v103_7_ = v103_2_
                    v103_5_ = v103_5_:FindFirstChild(v103_7_)
                    v103_6_ = 0
                    v103_5_.Transparency = v103_6_
                end
            end
            v103_2_ = a1.reloading
            if v103_2_ == false then
                v103_2_ = a1.cancellingReload
                if v103_2_ == false then
                    v103_2_ = a1.MaxAmmo
                    v103_3_ = 0
                    if v103_3_ < v103_2_ then
                        v103_3_ = true
                        local v103_6_ = 1
                        local v103_7_ = a1.CancelTables
                        v103_4_ = #v103_7_
                        local v103_5_ = 1
                        for v103_6_ = v103_6_, v103_4_, v103_5_ do
                            local v103_9_ = a1.CancelTables
                            local v103_8_ = v103_9_[v103_6_]
                            v103_7_ = v103_8_.Visible
                            if v103_7_ == true then
                                v103_3_ = false
                            else
                            end
                        end
                        v103_2_ = v103_3_
                        if v103_2_ then
                            v103_3_ = a1.clientAnimationTracks
                            v103_2_ = v103_3_.Inspect
                            if v103_2_ then
                                v103_3_ = a1.clientAnimationTracks
                                v103_2_ = v103_3_.Inspect
                                v103_2_:Stop()
                                v103_3_ = a1.serverAnimationTracks
                                v103_2_ = v103_3_.Inspect
                                v103_2_:Stop()
                                v103_4_ = a1.WeldedTool
                                v103_3_ = v103_4_.ItemRoot
                                v103_2_ = v103_3_.Inspect
                                v103_2_:Stop()
                            end
                            v103_3_ = a1.settings
                            v103_2_ = v103_3_.AimWhileActing
                            if not v103_2_ then
                                v103_2_ = a1.isAiming
                                if v103_2_ then
                                    v103_4_ = false
                                    a1:aim(v103_4_)
                                end
                            end
                            
                            if a1.reloadType == "loadByHand" then
                                local count = a1.Bullets
                                local maxcount = a1.MaxAmmo
    
                                for i=count, maxcount do 
                                    game.ReplicatedStorage.Remotes.Reload:InvokeServer(nil, 0.001, nil)
                                end
    
                                aaa(a1)
                            else
                                game.ReplicatedStorage.Remotes.Reload:InvokeServer(nil, 0.001, nil)
    
                                require(game.ReplicatedStorage.Modules.FPS).equip(a1, a1.weapon, nil)
    
                                aaa(a1)
                            end      
                        end
                    end
                end
            end
        end
    end

--instant lean--
print("loading instant lean functions!!! by hai_hai")
instantleanMODfunc = function(a1,a2,a3)
    --a1 = player table 
    if a2 == 0 then 
        if a1.lean == 0 then return end
    end
    local carv = a1.rs_Vehicle.CurrentSeat.Value
    if carv then 
        if a1.lean == 0 then return end
    end
    if a1.humanoid:GetState() == Enum.HumanoidStateType.Swimming then 
        if a1.lean == 0 then return end
    end
    if a1.sprinting == true then 
        if a1.lean == 0 then return end
    end
    
    if a2 == a1.lean then 
        a1.lean = 0
    else 
        a1.lean = a2
    end
    
    local springs = a1.springs
    local lalpha = springs.leanAlpha
    springs.leanAlpha.Speed = 15
    local currentlean = a1.lean
    local vectorposidk = Vector3.new(-currentlean, 0,0)
    lalpha.Target = vectorposidk
    local valuetoserver = nil
    
    if lalpha.Target.X == 1 then 
        valuetoserver = true
    elseif lalpha.Target.X == -1 then
        valuetoserver = false
    end

    game.ReplicatedStorage.Remotes.UpdateLeaning:FireServer(valuetoserver)
end
instantleanOGfunc = function(a1,a2,a3)
    --a1 = player table 
    if a2 == 0 then 
        if a1.lean == 0 then return end
    end
    local carv = a1.rs_Vehicle.CurrentSeat.Value
    if carv then 
        if a1.lean == 0 then return end
    end
    if a1.humanoid:GetState() == Enum.HumanoidStateType.Swimming then 
        if a1.lean == 0 then return end
    end
    if a1.sprinting == true then 
        if a1.lean == 0 then return end
    end
    
    if a2 == a1.lean then 
        a1.lean = 0
    else 
        a1.lean = a2
    end
    
    local springs = a1.springs
    local lalpha = springs.leanAlpha
    springs.leanAlpha.Speed = 5
    local currentlean = a1.lean
    local vectorposidk = Vector3.new(-currentlean, 0,0)
    lalpha.Target = vectorposidk
    local valuetoserver = nil
    
    if lalpha.Target.X == 1 then 
        valuetoserver = true
    elseif lalpha.Target.X == -1 then
        valuetoserver = false
    end

    game.ReplicatedStorage.Remotes.UpdateLeaning:FireServer(valuetoserver)
end


print("hitsound UP~~~ _hai_hai ")
localplayer.CharacterAdded:Connect(function(lchar)
    local maingui = localplayer.PlayerGui:WaitForChild("MainGui")
    if maingui then
        maingui.ChildAdded:Connect(function(Sound)
            if Sound:IsA("Sound") and hitsoundbool then
                if Sound.SoundId == "rbxassetid://4585351098" or Sound.SoundId == "rbxassetid://4585382589" then --headshot
                    Sound.SoundId = hitsoundlib[hitsoundhead]
                elseif Sound.SoundId == "rbxassetid://4585382046" or Sound.SoundId == "rbxassetid://4585364605" then --bodyshot
                    Sound.SoundId = hitsoundlib[hitsoundbody]
                end
            end
        end)
    end
end)
localplayer.PlayerGui.MainGui.ChildAdded:Connect(function(Sound)
    if Sound:IsA("Sound") and hitsoundbool then
        if Sound.SoundId == "rbxassetid://4585351098" or Sound.SoundId == "rbxassetid://4585382589" then --headshot
            Sound.SoundId = hitsoundlib[hitsoundhead]
        elseif Sound.SoundId == "rbxassetid://4585382046" or Sound.SoundId == "rbxassetid://4585364605" then --bodyshot
            Sound.SoundId = hitsoundlib[hitsoundbody]
        end
    end
end)

--esp map--
print("loading espmap function!!! by _hai_hai and Ardour")
    handleESPMAP = function(bool)
        if bool then
            local map = game.Players.LocalPlayer.PlayerGui.MainGui.MainFrame.MapFrame.MainFrame.Maps.EstonianBorderMap
            local mapFrame = game.Players.LocalPlayer.PlayerGui.MainGui.MainFrame.MapFrame.MainFrame
            mapFrame.Size = UDim2.fromScale(1, 1)
            mapFrame.Position = UDim2.new(0.5, 0, 0.49, 0)
    
            mapFrame.Parent.Visible = true
            game.UserInputService.MouseIconEnabled = true
            game.Players.LocalPlayer.PlayerGui.MainGui.ModalButton.Modal = true
    
            for _,v in ipairs(mapFrame.Markers:GetChildren()) do
                v:Destroy()
            end
    
            local selfMarker = game.Players.LocalPlayer.PlayerGui.MainGui.MainFrame.MapFrame.MainFrame.MarkerDotTemplate:Clone()
            selfMarker.Name = "SelfMarker"
            selfMarker.Visible = true
            selfMarker.Parent = game.Players.LocalPlayer.PlayerGui.MainGui.MainFrame.MapFrame.MainFrame.Markers
            selfMarker.TextLabel.Visible = true
            espmapmarkers.Me = {
                playerRef = game.Players.LocalPlayer,
                markerRef = selfMarker,
            }
    
            for _,v in ipairs(game.Players:GetChildren()) do
                if v ~= localplayer then
                    local plrMarker = game.Players.LocalPlayer.PlayerGui.MainGui.MainFrame.MapFrame.MainFrame.MarkerDotTemplate:Clone()
                    plrMarker.ImageColor3 = Color3.fromRGB(227, 36, 36)
                    plrMarker.Name = "TeamMarker"
                    plrMarker.Visible = true
                    plrMarker.TextLabel.Text = v.Name
                    plrMarker.TextLabel.Visible = true
                    plrMarker.TextLabel.Size = UDim2.fromScale(2, 0.5)
                    plrMarker.TextLabel.Position = UDim2.fromScale(-0.5, 0)
                    plrMarker.Parent = game.Players.LocalPlayer.PlayerGui.MainGui.MainFrame.MapFrame.MainFrame.Markers
                    espmapmarkers[v.Name] = {
                        playerRef = v,
                        markerRef = plrMarker,
                    }
                end
            end
            
            task.spawn(function()
                while task.wait(0.1) do
                    if espmapactive == false then return end
    
                    for ind, markerData in espmapmarkers do
                        if markerData.markerRef == nil then
                            table.remove(espmapmarkers, ind)
                        else
                            local playerRef = markerData.playerRef
                            if playerRef then
                                local character = playerRef.Character
                                if character then
                                    local chpos = game.ReplicatedStorage.Players:FindFirstChild(playerRef.Name).Status.UAC:GetAttribute("LastVerifiedPos")
                                    local xPos = (chpos.X - 208) / map:GetAttribute("SizeReal")
                                    local zPos = (chpos.Z + 203) / map:GetAttribute("SizeReal")
                                    markerData.markerRef.Position = UDim2.new(0.5 + xPos, 0, 0.5 + zPos, 0)
                                    markerData.markerRef.Visible = true
                                    if markerData.playerRef ~= localplayer then 
                                        if table.find(aimFRIENDLIST, markerData.playerRef.Name) ~= nil then
                                            markerData.markerRef.ImageColor3 = Color3.fromRGB(102, 245, 66)
                                        else
                                            markerData.markerRef.ImageColor3 = Color3.fromRGB(227, 36, 36)
                                        end
                                    end
                                else
                                    markerData.markerRef.Visible = false
                                end
                            end
                        end
                    end
                end
            end)
    
            mapFrame.Markers.Visible = true
        else
            if game.Players.LocalPlayer.PlayerGui.MainGui.MainFrame.MapFrame.Visible == true then
                game.Players.LocalPlayer.PlayerGui.MainGui.MainFrame.MapFrame.Visible = false
                game.Players.LocalPlayer.PlayerGui.MainGui.ModalButton.Modal = false
                game.UserInputService.MouseIconEnabled = false
            end
        end
    end
    


-- semi fly --
print("loading semifly functions!!!by _hai_hai")
local function fly_move(dir)
    local hrp = localplayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

	local newPos = hrp.CFrame + (dir * 1)
	hrp.CFrame = newPos
end
local function fly_getclosestpoint()
    local hrp = localplayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

	local dirs = {
        Vector3.new(1, 0, 0),
        Vector3.new(-1, 0, 0),
        Vector3.new(0, 1, 0),
        Vector3.new(0, -1, 0),
        Vector3.new(0, 0, 1),
        Vector3.new(0, 0, -1),
        Vector3.new(1, 1, 0),
        Vector3.new(1, -1, 0),
        Vector3.new(-1, 1, 0),
        Vector3.new(-1, -1, 0),
        Vector3.new(1, 0, 1),
        Vector3.new(1, 0, -1),
        Vector3.new(-1, 0, 1),
        Vector3.new(-1, 0, -1),
        Vector3.new(0, 1, 1),
        Vector3.new(0, 1, -1),
        Vector3.new(0, -1, 1),
        Vector3.new(0, -1, -1),
        Vector3.new(1, 1, 1),
        Vector3.new(1, 1, -1),
        Vector3.new(1, -1, 1),
        Vector3.new(1, -1, -1),
        Vector3.new(-1, 1, 1),
        Vector3.new(-1, 1, -1),
        Vector3.new(-1, -1, 1),
        Vector3.new(-1, -1, -1)
    }

	local fcp = nil
	local cd = math.huge

    local playerslist = game.Players:GetPlayers()
    local ignorl = {localplayer.Character, wcamera}

    for _, player in ipairs(playerslist) do
        if player.Character then
            table.insert(ignorl, player.Character)
        end
    end

	for _, dir in ipairs(dirs) do
		local ray = Ray.new(hrp.Position, dir * 200)
		local part, pos = workspace:FindPartOnRayWithIgnoreList(ray, ignorl)
		if part and pos then
			local d = (hrp.Position - pos).Magnitude
			if d < cd then
				cd = d
				fcp = pos
			end
		end
	end

	return fcp
end
local function fly_getoffset(dir)
	local offset = Vector3.new(0.1, 0.1, 0.1)
	if dir.X > 0 then
		offset = Vector3.new(0.1, 0, 0)
	elseif dir.X < 0 then
		offset = Vector3.new(-0.1, 0, 0)
	elseif dir.Y > 0 then
		offset = Vector3.new(0, 0.1, 0)
	elseif dir.Y < 0 then
		offset = Vector3.new(0, -0.1, 0)
	elseif dir.Z > 0 then
		offset = Vector3.new(0, 0, 0.1)
	elseif dir.Z < 0 then
		offset = Vector3.new(0, 0, -0.1)
	end
	return offset
end

--anticheat bypass--
print("loading anticheat bypass~~~!")  --method by discord.gg/exothium
local function handleClientAntiCheatBypass()
    if ACBYPASS_SYNC == true then return end

    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local Method = getnamecallmethod()
        local Args = {...}
        if Method == "FireServer" and self.Name == "ProjectileInflict" and true then
            if Args[1] == game.Players.LocalPlayer.Character.HumanoidRootPart then
                return coroutine.yield()
            end
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)

    ACBYPASS_SYNC = true
end
handleClientAntiCheatBypass()


--selftrack(ping check)
print("loading ping check!!! (BY Ardour)")
for i = 10, 1000, 10 do
    selftrack_data[i] = localplayer.Character.Head.Position
end
local function updateselfpos()
    for time = 990, 10, -10 do
        selftrack_data[time + 10] = selftrack_data[time]
    end
    selftrack_data[10] = localplayer.Character.Head.Position
end


--thirdperson fix--
local function ThirdPersonFix()
    local mt = getrawmetatable(game)
    local oldIndex = mt.__newindex
    setreadonly(mt, false)
    mt.__newindex = newcclosure(function(self, index, value)
        if tostring(self) == "Humanoid" and index == "CameraOffset" and camthirdp == true then
            return oldIndex(self, index, Vector3.new(camthirdpX, camthirdpY, camthirdpZ))
        end
        return oldIndex(self, index, value)
    end)
    setreadonly(mt, true)
end
ThirdPersonFix()


--fps table editor--
print("loading fps table editor by _hai_hai")
do
    local mod = require(game.ReplicatedStorage.Modules.FPS)
    local ogfunc = mod.updateClient

    mod.updateClient = function(a1,a2,a3)
        arg1, arg2, arg3 = ogfunc(a1,a2,a3)
        
        if noswaybool then
            a1.springs.sway.Speed = 0
            a1.springs.walkCycle.Speed = 0
            a1.springs.sprintCycle.Speed = 0
            a1.springs.strafeTilt.Speed = 0
            a1.springs.jumpTilt.Speed = 0
        else
            a1.springs.sway.Speed = 4
            a1.springs.walkCycle.Speed = 4
            a1.springs.sprintCycle.Speed = 4
            a1.springs.strafeTilt.Speed = 4
            a1.springs.jumpTilt.Speed = 4
        end

        return arg1, arg2, arg3
    end
end


--skin changer--
print("loading skinchanger (BY Ardour)")
local function createskinchangergui()
	local a=Instance.new"Frame"
	a.Name="SkinMain"
	a.Size=UDim2.new(0.193, 0, 0.478, 0)
	a.BorderColor3=Color3.fromRGB(0,0,0)
	a.Position=UDim2.new(0.709, 0, 0.499, 0)
	a.BorderSizePixel=0
	a.BackgroundColor3=Color3.fromRGB(35,35,35)
    a.AnchorPoint = Vector2.new(0, 0.5)
	local b=Instance.new"UICorner"
	b.Archivable=false
	b.CornerRadius=UDim.new(0.03,0)
	b.Parent=a
	local c=Instance.new"Frame"
	c.Name="Title"
	c.Size=UDim2.new(0.9995077,0,0.0345098,0)
	c.BorderColor3=Color3.fromRGB(0,0,0)
	c.BackgroundTransparency=0.8
	c.Position=UDim2.new(3e-07,0,0,0)
	c.BorderSizePixel=0
	c.BackgroundColor3=Color3.fromRGB(0,0,0)
	c.Parent=a
	local d=Instance.new"UICorner"
	d.Archivable=false
	d.CornerRadius=UDim.new(0.5,0)
	d.Parent=c
	local e=Instance.new"TextLabel"
	e.Name="Label"
	e.Size=UDim2.new(1,0,0.8636364,0)
	e.BorderColor3=Color3.fromRGB(0,0,0)
	e.BackgroundTransparency=1
	e.Position=UDim2.new(0,0,0.0950089,0)
	e.BorderSizePixel=0
	e.BackgroundColor3=Color3.fromRGB(255,255,255)
	e.FontSize=5
	e.TextSize=14
	e.TextColor3=Color3.fromRGB(255,255,255)
	e.Text="Skin Changer v0.1"
	e.TextWrapped=true
	e.TextWrap=true
	e.Font=100
	e.TextScaled=true
	e.Parent=c
	local f=Instance.new"Frame"
	f.Name="Guns"
	f.Size=UDim2.new(0.9502814,0,0.4,0)
	f.BorderColor3=Color3.fromRGB(0,0,0)
	f.BackgroundTransparency=0.85
	f.Position=UDim2.new(0.0235427,0,0.0972549,0)
	f.BorderSizePixel=0
	f.BackgroundColor3=Color3.fromRGB(0,0,0)
	f.Parent=a
	local g=Instance.new"UICorner"
	g.Archivable=false
	g.CornerRadius=UDim.new(0.03,0)
	g.Parent=f
	local h=Instance.new"ScrollingFrame"
	h.Name="Bar"
	h.Size=UDim2.new(0.9414414,0,0.9058824,0)
	h.BorderColor3=Color3.fromRGB(0,0,0)
	h.BackgroundTransparency=1
	h.Position=UDim2.new(0.0292793,0,0.0509804,0)
	h.Active=true
	h.BorderSizePixel=0
	h.BackgroundColor3=Color3.fromRGB(255,255,255)
	h.ScrollingDirection=2
	h.CanvasSize=UDim2.new(0,0,1,0)
	h.ScrollBarThickness=4
	h.Parent=f
	local i=Instance.new"UIListLayout"
	i.SortOrder=2
	i.Wraps=true
	i.HorizontalFlex=1
	i.VerticalFlex=1
	i.Padding=UDim.new(0.005,0)
	i.Parent=h
	local j=Instance.new"TextLabel"
	j.Name="GunsLabel"
	j.Size=UDim2.new(0.8946342,0,0.0407843,0)
	j.BorderColor3=Color3.fromRGB(0,0,0)
	j.BackgroundTransparency=1
	j.Position=UDim2.new(0.0513673,0,0.0454902,0)
	j.BorderSizePixel=0
	j.BackgroundColor3=Color3.fromRGB(255,255,255)
	j.FontSize=5
	j.TextSize=14
	j.TextColor3=Color3.fromRGB(255,255,255)
	j.Text="Your guns : "
	j.TextWrapped=true
	j.TextWrap=true
	j.Font=100
	j.TextScaled=true
	j.Parent=a
	local k=Instance.new"Frame"
	k.Name="Skins"
	k.Size=UDim2.new(0.9502814,0,0.4188235,0)
	k.BorderColor3=Color3.fromRGB(0,0,0)
	k.BackgroundTransparency=0.85
	k.Position=UDim2.new(0.0235427,0,0.5631372,0)
	k.BorderSizePixel=0
	k.BackgroundColor3=Color3.fromRGB(0,0,0)
	k.Parent=a
	local l=Instance.new"UICorner"
	l.Archivable=false
	l.CornerRadius=UDim.new(0.03,0)
	l.Parent=k
	local m=Instance.new"ScrollingFrame"
	m.Name="Bar"
	m.Size=UDim2.new(0.9414414,0,0.9058824,0)
	m.BorderColor3=Color3.fromRGB(0,0,0)
	m.BackgroundTransparency=1
	m.Position=UDim2.new(0.0292793,0,0.0509804,0)
	m.Active=true
	m.BorderSizePixel=0
	m.BackgroundColor3=Color3.fromRGB(255,255,255)
	m.ScrollingDirection=2
	m.CanvasSize=UDim2.new(0,0,2.5,0)
	m.ScrollBarThickness=4
	m.Parent=k
	local n=Instance.new"UIListLayout"
	n.SortOrder=2
	n.Wraps=true
	n.HorizontalFlex=1
	n.VerticalFlex=1
	n.Padding=UDim.new(0.005,0)
	n.Parent=m
	local o=Instance.new"TextLabel"
	o.Name="SkinsLabel"
	o.Size=UDim2.new(0.8946342,0,0.0407843,0)
	o.BorderColor3=Color3.fromRGB(0,0,0)
	o.BackgroundTransparency=1
	o.Position=UDim2.new(0.0513673,0,0.5129412,0)
	o.BorderSizePixel=0
	o.BackgroundColor3=Color3.fromRGB(255,255,255)
	o.FontSize=5
	o.TextSize=14
	o.TextColor3=Color3.fromRGB(255,255,255)
	o.Text="Available skins (For None) : "
	o.TextWrapped=true
	o.TextWrap=true
	o.Font=100
	o.TextScaled=true
	o.Parent=a
	local p=Instance.new"UIStroke"
	p.ApplyStrokeMode=1
	p.Thickness=3.5999999
	p.Color=Color3.fromRGB(75,118,197)
	p.Parent=a
	local q=Instance.new"Configuration"
	q.Name="Templates"
	q.Parent=a
	local r=Instance.new"Frame"
	r.Name="SkinTemplate"
	r.Size=UDim2.new(0,411,0,55)
	r.BorderColor3=Color3.fromRGB(0,0,0)
	r.BorderSizePixel=0
	r.BackgroundColor3=Color3.fromRGB(54,54,54)
	r.Parent=q
	local s=Instance.new"TextLabel"
	s.Name="SkinName"
	s.Size=UDim2.new(0.5425791,0,0.6363636,0)
	s.BorderColor3=Color3.fromRGB(0,0,0)
	s.BackgroundTransparency=1
	s.Position=UDim2.new(0.0358852,0,0.1794467,0)
	s.BorderSizePixel=0
	s.BackgroundColor3=Color3.fromRGB(255,255,255)
	s.FontSize=5
	s.TextStrokeTransparency=0
	s.TextSize=14
	s.RichText=true
	s.TextColor3=Color3.fromRGB(255,255,255)
	s.Text="White Death"
	s.TextWrapped=true
	s.TextWrap=true
	s.Font=100
	s.TextXAlignment=0
	s.TextScaled=true
	s.Parent=r
	local t=Instance.new"TextButton"
	t.Name="Set"
	t.Size=UDim2.new(0.377129,0,0.6363636,0)
	t.BorderColor3=Color3.fromRGB(0,0,0)
	t.Position=UDim2.new(0.5926771,0,0.1794467,0)
	t.BorderSizePixel=0
	t.BackgroundColor3=Color3.fromRGB(135,255,92)
	t.FontSize=5
	t.TextStrokeTransparency=0
	t.TextSize=14
	t.RichText=true
	t.TextColor3=Color3.fromRGB(255,255,255)
	t.Text="Set"
	t.TextWrapped=true
	t.TextWrap=true
	t.Font=100
	t.TextScaled=true
	t.Parent=r
	local u=Instance.new"UICorner"
	u.Archivable=false
	u.CornerRadius=UDim.new(0.2,0)
	u.Parent=t
	local v=Instance.new"UICorner"
	v.Archivable=false
	v.CornerRadius=UDim.new(0.1,0)
	v.Parent=r
	local w=Instance.new"UIAspectRatioConstraint"
	w.AspectRatio=7.3200002
	w.DominantAxis=1
	w.Parent=r
	local x=Instance.new"Frame"
	x.Name="GunTemplate"
	x.Size=UDim2.new(0,411,0,55)
	x.BorderColor3=Color3.fromRGB(0,0,0)
	x.BorderSizePixel=0
	x.BackgroundColor3=Color3.fromRGB(54,54,54)
	x.Parent=q
	local y=Instance.new"TextLabel"
	y.Name="GunName"
	y.Size=UDim2.new(0.5425791,0,0.6363636,0)
	y.BorderColor3=Color3.fromRGB(0,0,0)
	y.BackgroundTransparency=1
	y.Position=UDim2.new(0.0358852,0,0.1794467,0)
	y.BorderSizePixel=0
	y.BackgroundColor3=Color3.fromRGB(255,255,255)
	y.FontSize=5
	y.TextStrokeTransparency=0
	y.TextSize=14
	y.RichText=true
	y.TextColor3=Color3.fromRGB(255,255,255)
	y.Text="TFZ98"
	y.TextWrapped=true
	y.TextWrap=true
	y.Font=100
	y.TextXAlignment=0
	y.TextScaled=true
	y.Parent=x
	local z=Instance.new"TextButton"
	z.Name="Select"
	z.Size=UDim2.new(0.377129,0,0.6363636,0)
	z.BorderColor3=Color3.fromRGB(0,0,0)
	z.Position=UDim2.new(0.5926771,0,0.1794467,0)
	z.BorderSizePixel=0
	z.BackgroundColor3=Color3.fromRGB(135,255,92)
	z.FontSize=5
	z.TextStrokeTransparency=0
	z.TextSize=14
	z.RichText=true
	z.TextColor3=Color3.fromRGB(255,255,255)
	z.Text="Select"
	z.TextWrapped=true
	z.TextWrap=true
	z.Font=100
	z.TextScaled=true
	z.Parent=x
	local A=Instance.new"UICorner"
	A.Archivable=false
	A.CornerRadius=UDim.new(0.2,0)
	A.Parent=z
	local B=Instance.new"UICorner"
	B.Archivable=false
	B.CornerRadius=UDim.new(0.1,0)
	B.Parent=x
	local C=Instance.new"UIAspectRatioConstraint"
	C.AspectRatio=7.3200002
	C.DominantAxis=1
	C.Parent=x
    return a
end
function sc_setskin(skin)
    local gun = scselected
    gun.ItemProperties:SetAttribute("Skin", skin.Name)

    for _,att in ipairs(gun.Attachments:GetDescendants()) do
        if att:IsA("StringValue") and att:FindFirstChild("ItemProperties") then
            att.ItemProperties:SetAttribute("Skin", skin.Name)
        end
    end
end
function sc_additem(gui, obj, itemtype)
    local skintemp = gui.Templates.SkinTemplate
    local guntemp = gui.Templates.GunTemplate

    if itemtype == "Skin" then
        local temp = skintemp:Clone()
        temp.Name = obj.Name
        temp.SkinName.Text = obj.name
        temp.Parent = gui.Skins.Bar
        temp.Set.Activated:Connect(function()
            sc_setskin(obj)
            Notify("Skin Changer", "Set " .. scselected.Name .. " skin to " .. obj.Name)
        end)
    else
        local temp = guntemp:Clone()
        temp.Name = obj.Name
        temp.GunName.Text = obj.name
        temp.Parent = gui.Guns.Bar
        temp.Select.Activated:Connect(function()
            scselected = obj
            sc_loadskins(gui, obj)
        end)
    end
end
function sc_removeitem(gui, gunname)
    if scselected ~= nil and scselected.Name == gunname then
        scselected = nil
        sc_clearskins(gui)
    end
    local gunitem = gui.Guns.Bar:FindFirstChild(gunname)
    if gunitem then
        gunitem:Destroy()
    end
end
function sc_clearskins(gui)
    for _,delet in ipairs(gui.Skins.Bar:GetChildren()) do
        if delet:IsA("Frame") then  
            delet:Destroy()
        end
    end
end
function sc_loadskins(gui, gun)
    sc_clearskins(gui)

    local skinsfold = game.ReplicatedStorage.Skins:FindFirstChild(gun.Name)
    if skinsfold then
        for _, skin in ipairs(skinsfold:GetChildren()) do
            sc_additem(gui, skin, "Skin")
        end
    end
end
local function skinchangerhandler()
    local skingui = createskinchangergui()
    skingui.Visible = false
    skingui.Parent = library.GUI
    scgui = skingui

    local skinsbar = skingui.Skins.Bar
    local gunsbar = skingui.Guns.Bar

    for _,gun in ipairs(game.ReplicatedStorage.Players:FindFirstChild(localplayer.Name).Inventory:GetChildren()) do
        sc_additem(skingui, gun, "Gun")
    end

    game.ReplicatedStorage.Players:FindFirstChild(localplayer.Name).Inventory.ChildAdded:Connect(function(child)
        sc_additem(skingui, child, "Gun")
    end)
    game.ReplicatedStorage.Players:FindFirstChild(localplayer.Name).Inventory.ChildRemoved:Connect(function(child)
        sc_removeitem(skingui, child.Name)
    end)
end
skinchangerhandler()

--global cycle--
print("loading global cycles(BY Ardour &_hai_hai )")

task.spawn(function() -- very slow
    while wait(10.5) do
        table.clear(aimignoreparts)
        for i,v in ipairs(workspace:GetDescendants()) do
            if v:GetAttribute("PassThrough") then
                table.insert(aimignoreparts, v)
            end
        end
    end
end)

task.spawn(function() -- slow
    while wait(1) do
        invchecktext.Position = Vector2.new(30, (wcamera.ViewportSize.Y / 2) - 230) --on screen stuff

        if scselected ~= nil and scgui ~= nil then
            scgui.SkinsLabel.Text = "Available skins (For ".. scselected.Name.." ) : "
        else
            scgui.SkinsLabel.Text = "Available skins (For None) : "
        end

        local function handleModDetect()
            if detectmods then
                for _, player in ipairs(game.Players:GetPlayers()) do
                    if detectedmods[player.Name] then continue end

                    local pinfo = game.ReplicatedStorage.Players:FindFirstChild(player.Name)
                    if not pinfo then continue end
                    local status = pinfo:FindFirstChild("Status")
                    if not status then continue end

                    if status.UAC:GetAttribute("Enabled") == true then
                        detectedmods[player.Name] = true
                        Notify("Mod Detected", "UAC Enabled ( ".. player.Name .." ) ")
                        continue
                    end
                    if status.GameplayVariables:GetAttribute("Godmode") == true then
                        detectedmods[player.Name] = true
                        Notify("Mod Detected", "Godmode Enabled ( ".. player.Name .." ) ")
                        continue
                    end
                end
            end
        end

        local function handleAntiMask()
            if antimaskbool == true then
                game.Players.LocalPlayer.PlayerGui.MainGui.MainFrame.ScreenEffects.HelmetMask.TitanShield.Size = UDim2.new(0,0,1,0)
                game.Players.LocalPlayer.PlayerGui.MainGui.MainFrame.ScreenEffects.Mask.GP5.Size = UDim2.new(0,0,1,0)
                for i,v in ipairs(game.Players.LocalPlayer.PlayerGui.MainGui.MainFrame.ScreenEffects.Visor:GetChildren()) do
                    v.Size = UDim2.new(0,0,1,0)
                end
            else
                game.Players.LocalPlayer.PlayerGui.MainGui.MainFrame.ScreenEffects.HelmetMask.TitanShield.Size = UDim2.new(1,0,1,0)
                game.Players.LocalPlayer.PlayerGui.MainGui.MainFrame.ScreenEffects.Mask.GP5.Size = UDim2.new(1,0,1,0)
                for i,v in ipairs(game.Players.LocalPlayer.PlayerGui.MainGui.MainFrame.ScreenEffects.Visor:GetChildren()) do
                    v.Size = UDim2.new(1,0,1,0)
                end
            end
        end

        local function handleRespawn()
            if localplayer.Character and localplayer.Character:FindFirstChild("Humanoid") and localplayer.Character.Humanoid.Health <= 0 and instantrespawn == true then
                localplayer.PlayerGui.RespawnMenu.Enabled = false
                game.ReplicatedStorage.Remotes.SpawnCharacter:InvokeServer()
            elseif instantrespawn == false then
                localplayer.PlayerGui.RespawnMenu.Enabled = true
            else
                localplayer.PlayerGui.RespawnMenu.Enabled = false
                game.ReplicatedStorage.Remotes.SpawnCharacter:InvokeServer()
            end
        end

        local function handleFoliage()
            if not folcheck then return end 
            for _, v in pairs(folcheck.Foliage:GetDescendants()) do
                if v:FindFirstChildOfClass("SurfaceAppearance") then
                    v.Transparency = worldleaves and 1 or 0
                end
            end
        end

        local function handleInventory()
            local offset = CFrame.new(Vector3.new(viewmodX, viewmodY, viewmodZ))
            if not offset then return end

            local inv = game.ReplicatedStorage.Players:FindFirstChild(localplayer.Name).Inventory
            if not inv then return end

            for _, v in pairs(inv:GetChildren()) do
                if not v:FindFirstChild("SettingsModule") then return end
                local sett = require(v.SettingsModule)
                if viewmodoffset then
                    sett.weaponOffSet = offset
                end
                if rapidfire then
                    sett.FireRate = crapidfire and crapidfirenum or 0.001
                end
                if unlockmodes then
                    sett.FireModes = {"Auto", "Semi"}
                end
            end
        end

        local function handleViewModel()
            if viewmodbool and wcamera:FindFirstChild("ViewModel") then
                for _, obj in pairs(wcamera.ViewModel:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        if not obj:FindFirstAncestor("Item") then
                            local mb = obj:FindFirstChildOfClass("SurfaceAppearance")
                            if mb then
                                mb:Destroy()
                            end

                            obj.Color = viewmodhandcolor
                            obj.Material = viewmodhandmat
                        else
                            local mb = obj:FindFirstChildOfClass("SurfaceAppearance")
                            if mb then
                                mb:Destroy()
                            end

                            obj.Color = viewmodguncolor
                            obj.Material = viewmodgunmat
                        end
                    elseif obj:IsA("Model") and obj:FindFirstChild("LL") then
                        obj:Destroy()
                    end
                end
            end
        end

        handleRespawn()
        handleFoliage()
        handleInventory()
        handleViewModel()
        handleAntiMask()
        handleModDetect()
    end
end)

runs.RenderStepped:Connect(function(delta) --  fast
    --runs.RenderStepped:Wait()
    if not localplayer.Character or not localplayer.Character:FindFirstChild("HumanoidRootPart") or not localplayer.Character:FindFirstChild("Humanoid") then
        return
    end

    --nofall method by ds: _hai_hai
    local humstate = localplayer.Character.Humanoid:GetState()
    if nofall and (humstate == Enum.HumanoidStateType.FallingDown or humstate == Enum.HumanoidStateType.Freefall) and localplayer.Character.HumanoidRootPart.AssemblyLinearVelocity.Y < -30 then 
        localplayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)

        if instafall then 
            local rparams = RaycastParams.new()
            rparams.FilterDescendantsInstances = {
                localplayer.Character:GetDescendants()
            }
            local fray = workspace:Raycast(localplayer.Character.HumanoidRootPart.Position, Vector3.new(0, -400, 0), rparams)
            if fray then
                localplayer.Character.HumanoidRootPart.CFrame = CFrame.new(fray.Position + Vector3.new(0, 3, 0))
            end
        end
    end


    local nil1, nil2, newglobalcurrentgun = getcurrentgun(localplayer)
    globalcurrentgun = newglobalcurrentgun
    globalammo = getcurrentammo(globalcurrentgun)


    if aimtrigger and aimtarget ~= nil and not uis.MouseIconEnabled then -- triggerbot
        task.spawn(function()
            mouse1press()
            wait()
            mouse1release()
        end)
    end


    if changerbool and localplayer.Character and localplayer.Character:FindFirstChild("Humanoid") and ACBYPASS_SYNC == true then
        localplayer.Character.Humanoid.WalkSpeed = changerspeed
        localplayer.Character.Humanoid.JumpHeight = changerjump
        localplayer.Character.Humanoid.HipHeight = changerheight
        workspace.Gravity = changergrav
    end


    if charsemifly and localplayer.Character and ACBYPASS_SYNC == true then --semifly
        local hrp = localplayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local dir = Vector3.new(0, 0, 0)

		if uis:IsKeyDown(Enum.KeyCode.W) then
			dir += wcamera.CFrame.LookVector
		elseif uis:IsKeyDown(Enum.KeyCode.S) then
			dir -= wcamera.CFrame.LookVector
		end

		if uis:IsKeyDown(Enum.KeyCode.A) then
			dir -= wcamera.CFrame.RightVector
		elseif uis:IsKeyDown(Enum.KeyCode.D) then
			dir += wcamera.CFrame.RightVector
		end

		if uis:IsKeyDown(Enum.KeyCode.Space) then
			dir += Vector3.new(0, 1, 0)
		elseif uis:IsKeyDown(Enum.KeyCode.LeftShift) then
			dir -= Vector3.new(0, 1, 0)
		end

		local closest = fly_getclosestpoint()
		if closest then
			local d = (hrp.Position - closest).Magnitude
			if d > charsemiflydist then
				local ldir = (hrp.Position - closest).Unit * charsemiflydist
				local offset = fly_getoffset(ldir)
				hrp.CFrame = CFrame.new(closest + ldir - offset)
			else
				fly_move(dir * charsemiflyspeed * runs.RenderStepped:Wait())
			end
		else
			fly_move(dir * charsemiflyspeed * runs.RenderStepped:Wait())
		end
    end


    if crossbool then --crosshair
        crosshair.Visible = true
        crosshair.Rotation += crossrot
        crosshair.Size = UDim2.new(crosssizeog.X.Scale * crosssizek, 0, crosssizeog.Y.Scale * crosssizek, 0)
        crosshair.Image = crossimg
        crosshair.ImageColor3 = crosscolor
    else
        crosshair.Visible = false
    end

    if aimdynamicfov then -- fov changer
        aimfovcircle.Radius = aimfov * (80 / wcamera.FieldOfView )
    else
        aimfovcircle.Radius = aimfov
    end


    --ping check part
    selftrack_update += delta
    if selftrack_update >= 0.01 then
        updateselfpos(selftrack_update)
        selftrack_update = 0
    end


    choosetarget() --aim part


    --snapline--
    if snaplinebool and aimtargetpart then
        aimsnapline.Visible = true
        local headpos = wcamera:WorldToViewportPoint(aimtargetpart.Position)
        aimsnapline.From = Vector2.new(wcamera.ViewportSize.X / 2, wcamera.ViewportSize.Y / 2)
        aimsnapline.To = Vector2.new(headpos.X, headpos.Y)
    else
        aimsnapline.Visible = false
    end


    if aimtarget ~= nil and aimtargetpart ~= nil then --on screen stuff
        aimtargetname.Text = aimtarget.Name

        local thum = aimtargetpart.Parent.Humanoid
        local thealth = thum.Health
        local shotsleft = nil
        if globalammo ~= nil then
            local gundmg = globalammo:GetAttribute("Damage")
            shotsleft = math.floor(thealth / gundmg)
        end

        if shotsleft ~= nil then
            aimtargetshots.Text = "abt " .. shotsleft .. " shots left to kill [without armor]"
        else
            aimtargetshots.Text = ""
        end
    else
        aimtargetname.Text = "None"
        aimtargetshots.Text = " "
    end
    aimtargetname.Position = Vector2.new(wcamera.ViewportSize.X / 2, wcamera.ViewportSize.Y / 2 + aimfov + 20)
    aimtargetshots.Position = Vector2.new(wcamera.ViewportSize.X / 2, wcamera.ViewportSize.Y / 2 + aimfov + 50)
    aimfovcircle.Position = Vector2.new(wcamera.ViewportSize.X / 2, wcamera.ViewportSize.Y / 2)
    if scgui then
        scgui.Position = librarymaingui.Position + UDim2.new(0.16, 0, 0, 0)
    end


    if invcheck and aimtarget ~= nil then --inv checker
        local profile = game.ReplicatedStorage.Players:FindFirstChild(aimtarget.Name)
        if profile then
            local cloth = profile.Clothing
            local inv = profile.Inventory
            local result = ""
    
            for _, item in ipairs(inv:GetChildren()) do
                result = result .. item.Name .. ",\n"
            end
            for _, item in ipairs(cloth:GetChildren()) do
                local itemName = item.Name
                local inventory = item:FindFirstChild("Inventory")
    
                if inventory then
                    result = result .. itemName .. " = {\n"
                    local count = 0
                    for _, invItem in ipairs(inventory:GetChildren()) do
                        local invcount = invItem.ItemProperties:GetAttribute("Amount")
                        count = count + 1
                        if count % 2 == 0 then
                            if invcount and invcount > 1 then
                                result = result .. " " .. invItem.Name .."[x".. invcount .."]".. ","
                            else
                                result = result .. " " .. invItem.Name .. ","
                            end
                            result = result .. "\n"
                        else
                            if invcount and invcount > 1 then
                                result = result .. "    " .. invItem.Name .."[x".. invcount .."]".. ","
                            else
                                result = result .. "    " .. invItem.Name .. ","
                            end
                        end
                    end
                    result = result:sub(1, -2) .. "\n},\n"
                else
                    result = result .. itemName .. ",\n"
                end
            end

            result = result:sub(1, -3)
            result = aimtarget.Name.."'s inventory:\n" .. result
    
            invchecktext.Text = result
        else
            invchecktext.Text = " "
        end
    else
        invchecktext.Text = " "
    end


    for dobj, info in esptable do --esp part
        local dtype = info.type
        local otype = info.otype
        
        if info.primary == nil or info.primary.Parent == nil then
            esptable[dobj] = nil
            if dtype == "Highlight" then
                dobj.Enabled = false
                dobj:Destroy()
            else
                dobj.Visible = false
                dobj:Remove()
            end
            continue
        end

        local obj
        local isHumanoid
        if otype == "Extract" then
            obj = info.primary
            isHumanoid = true
        elseif otype == "Loot" then
            obj = info.primary
            isHumanoid = true
        else
            obj = info.primary.Parent:FindFirstChild("UpperTorso")
            if not obj then
                esptable[dobj] = nil
                if dtype == "Highlight" then
                    dobj.Enabled = false
                    dobj:Destroy()
                else
                    dobj.Visible = false
                    dobj:Remove()
                end
                continue
            end
            isHumanoid = obj.Parent:FindFirstChild("Humanoid")
        end

        if (otype == "Bot333" and espbots == false) or (otype == "Dead333" and espdead == false) or (otype == "Extract" and espexit == false) or (otype == "Loot" and esploot == false) then
            if dtype == "Highlight" then
                dobj.Enabled = false
            else
                dobj.Visible = false
            end
            continue
        end

        if localplayer.Character == nil or localplayer.Character.PrimaryPart == nil then
            if dtype == "Highlight" then
                dobj.Enabled = false
            else
                dobj.Visible = false
            end
            continue
        end
        
        if otype == "Bot333" and obj.Parent.Humanoid.Health == 0 then
            info.otype = "Dead333"
        end

        local metersdist = math.floor((localplayer.Character.PrimaryPart.Position - obj.Position).Magnitude * 0.3336)
        local studsdist = math.floor((localplayer.Character.PrimaryPart.Position - obj.Position).Magnitude)

        if espbool and isonscreen(obj) and isHumanoid and metersdist < esprenderdist then
            local headpos = wcamera:WorldToViewportPoint(obj.Position)
            local resultpos = Vector2.new(headpos.X, headpos.Y)
    
            if dtype == "Name" then
                if espname then
                    resultpos = resultpos - Vector2.new(0, 15)
                    if otype == "Extract" then
                        dobj.Text = obj.Name
                    elseif otype == "Dead333" then 
                        dobj.Text = obj.Parent.Name .. " [DEAD]"
                    else
                        dobj.Text = obj.Parent.Name
                    end
                    dobj.Position = resultpos
                    dobj.Size = esptextsize
                    dobj.Color = esptextcolor
                    dobj.Outline = esptextline
                    dobj.Visible = true
                else
                    dobj.Visible = false
                end
            elseif dtype == "HP" then

                if otype == "Dead333" then
                    dobj.Visible = false
                    continue
                end

                resultpos = resultpos - Vector2.new(0, 30)
                dobj.Text = math.floor(obj.Parent.Humanoid.Health) .. "HP"
                dobj.Position = resultpos
                dobj.Size = esptextsize
                dobj.Color = esptextcolor
                dobj.Visible = esphp
                dobj.Outline = esptextline
            elseif dtype == "Distance" then
                if espdistance then
                    resultpos = resultpos - Vector2.new(0, 45)
                    if espdistmode == "Meters" then
                        dobj.Text = metersdist .. "m"
                    elseif espdistmode == "Studs" then
                        dobj.Text = studsdist .. "s"
                    end
                    dobj.Position = resultpos
                    dobj.Size = esptextsize
                    dobj.Color = esptextcolor
                    dobj.Outline = esptextline
                    dobj.Visible = true
                else
                    dobj.Visible = false
                end
            elseif dtype == "Hotbar" then

                if otype == "Dead333" then
                    dobj.Visible = false
                    continue
                end

                resultpos = resultpos + Vector2.new(0, 15)
                local hotgun = "None"
                for _, v in ipairs(obj.Parent:GetChildren()) do
                    if v:FindFirstChild("ItemRoot") then
                        hotgun = v.Name
                        break
                    end
                end

                dobj.Visible = esphotbar
                if otype == "Loot" then
                    local Amount
                    local TotalPrice = 0
                    local Value = 0

                    for _, h in ipairs(obj.Parent.Inventory:GetChildren()) do
                        Amount = h.ItemProperties:GetAttribute("Amount") or 1
                        TotalPrice += h.ItemProperties:GetAttribute("Price") or 0
                        Value += (valcache[h.ItemProperties:GetAttribute("CallSign")] or 0) * Amount
                    end --original = https://rbxscript.com/post/ProjectDeltaLootEsp-P7xaS

                    if Value >= 20 then
                        dobj.Text = "Rate : Godly | " .. TotalPrice .. "$"
                    elseif Value >= 12 then
                        dobj.Text = "Rate : Good | " .. TotalPrice .. "$"
                    elseif Value >= 8 then
                        dobj.Text = "Rate : Not bad | " .. TotalPrice .. "$"
                    elseif Value >= 4 then
                        dobj.Text = "Rate : Bad | " .. TotalPrice .. "$"
                    end
                else
                    dobj.Text = hotgun
                end
                dobj.Position = resultpos
                dobj.Size = esptextsize
                dobj.Outline = esptextline
                dobj.Color = esptextcolor
            elseif dtype == "Highlight" then
                if otype == "Dead333" or dobj.Parent == nil or obj == nil or obj.Parent == nil or not obj.Parent:IsA("Model") or obj.Parent.Humanoid.Health < 1 then
                    esptable[dobj] = nil
                    dobj.Enabled = false
                    dobj:Destroy()
                    continue
                end

                dobj.FillColor = espfillcolor
                dobj.OutlineColor = esplinecolor
                dobj.FillTransparency = espchamsfill
                dobj.OutlineTransparency = espchamsline
                dobj.Enabled = esphigh
            end
        else
            if dtype == "Highlight" then
                dobj.Enabled = false
            else
                dobj.Visible = false
            end
        end
    end
end)

--loaded--
scriptloading = false

print("loaded")
Notify("HihiHub", "Script loaded on")
game.CoreGui.PCR_1.Enabled = not game.CoreGui.PCR_1.Enabled
