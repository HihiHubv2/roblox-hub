local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/oShyyyyy/Plaguecheat.cc-Roblox-Ui-library/main/Source.lua", true))()
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService") -- 引入按鍵監聽

-- 初始化變數
local InventoryCheckerEnabled = false
local CheckRadius = 100
local ClosestPlayerTemp = nil
local LastDisplayedInventory = nil
local customKeyBind = Enum.KeyCode.Insert -- 默認按鍵綁定

-- 隱藏和顯示主界面邏輯
local function toggleGUI()
    if library.GUI:FindFirstChild("MAIN") then
        local mainFrame = library.GUI:FindFirstChild("MAIN")
        mainFrame.Visible = not mainFrame.Visible
        print("Toggled GUI visibility:", mainFrame.Visible)
    else
        warn("Library Main Frame not found!")
    end
end

-- 監聽玩家自定義按鍵事件
UIS.InputBegan:Connect(function(input, isProcessed)
    if not isProcessed and input.KeyCode == customKeyBind then
        toggleGUI()
    end
end)

-- 創建 UI
local function createUI()
    local ScreenGui = Instance.new("ScreenGui")
    syn.protect_gui(ScreenGui)
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ScreenGui.Parent = CoreGui

    local inventoryDisplayFrame = Instance.new("Frame")
    inventoryDisplayFrame.Size = UDim2.new(0.6, 0, 0.2, 0)
    inventoryDisplayFrame.Position = UDim2.new(0.2, 0, 0.05, 0)
    inventoryDisplayFrame.BackgroundTransparency = 0.2
    inventoryDisplayFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    inventoryDisplayFrame.BorderSizePixel = 1
    inventoryDisplayFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
    inventoryDisplayFrame.Visible = false
    inventoryDisplayFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner", inventoryDisplayFrame)
    UICorner.CornerRadius = UDim.new(0, 10)

    local playerNameLabel = Instance.new("TextLabel", inventoryDisplayFrame)
    playerNameLabel.Size = UDim2.new(1, 0, 0.2, 0)
    playerNameLabel.Position = UDim2.new(0, 0, 0, 0)
    playerNameLabel.BackgroundTransparency = 1
    playerNameLabel.Text = "PlayName"
    playerNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    playerNameLabel.Font = Enum.Font.GothamBold
    playerNameLabel.TextScaled = true

    local inventoryContainer = Instance.new("Frame", inventoryDisplayFrame)
    inventoryContainer.Size = UDim2.new(1, 0, 0.8, 0)
    inventoryContainer.Position = UDim2.new(0, 0, 0.2, 0)
    inventoryContainer.BackgroundTransparency = 1

    local inventoryGridLayout = Instance.new("UIGridLayout", inventoryContainer)
    inventoryGridLayout.CellSize = UDim2.new(0.12, 0, 0.5, 0)
    inventoryGridLayout.CellPadding = UDim2.new(0.02, 0, 0.02, 0)

    return inventoryDisplayFrame, playerNameLabel, inventoryContainer
end

local inventoryDisplayFrame, playerNameLabel, inventoryContainer = createUI()

-- 顯示玩家物品邏輯
local function displayInventory(player)
    if not player or not ReplicatedStorage:FindFirstChild("Players") or not ReplicatedStorage.Players:FindFirstChild(player.Name) then
        warn("找不到玩家數據或物品數據無效")
        return
    end

    local profile = ReplicatedStorage.Players[player.Name]
    local inventory = profile:FindFirstChild("Inventory")
    local clothing = profile:FindFirstChild("Clothing")

    local currentInventory = {}
    if inventory then
        for _, item in ipairs(inventory:GetChildren()) do
            table.insert(currentInventory, item.Name .. (item.ItemProperties:GetAttribute("Amount") or 1))
        end
    end
    if clothing then
        for _, item in ipairs(clothing:GetChildren()) do
            table.insert(currentInventory, item.Name)
        end
    end

    if LastDisplayedInventory and table.concat(LastDisplayedInventory) == table.concat(currentInventory) then
        return
    end
    LastDisplayedInventory = currentInventory

    inventoryDisplayFrame.Visible = true
    playerNameLabel.Text = "Play: " .. player.Name

    for _, child in pairs(inventoryContainer:GetChildren()) do
        if child:IsA("ImageLabel") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    local function addItemToUI(item, count)
        if item:FindFirstChild("ItemProperties") and item.ItemProperties:FindFirstChild("ItemIcon") then
            local itemIcon = Instance.new("ImageLabel", inventoryContainer)
            itemIcon.Size = UDim2.new(0, 50, 0, 50)
            itemIcon.BackgroundTransparency = 1
            itemIcon.Image = item.ItemProperties.ItemIcon.Image

            local tooltip = Instance.new("TextLabel", itemIcon)
            tooltip.Size = UDim2.new(1, 0, 0.3, 0)
            tooltip.Position = UDim2.new(0, 0, 1, 0)
            tooltip.BackgroundTransparency = 1
            tooltip.Text = item.Name .. (count > 1 and (" x" .. count) or "")
            tooltip.TextScaled = true
            tooltip.Font = Enum.Font.SourceSans
            tooltip.TextColor3 = Color3.fromRGB(255, 255, 255)
            tooltip.TextWrapped = true
        end
    end

    if inventory then
        for _, item in ipairs(inventory:GetChildren()) do
            local amount = item.ItemProperties:GetAttribute("Amount") or 1
            addItemToUI(item, amount)
        end
    end
    if clothing then
        for _, item in ipairs(clothing:GetChildren()) do
            addItemToUI(item, 1)
        end
    end
end

-- 遊戲邏輯
RunService.RenderStepped:Connect(function()
    if InventoryCheckerEnabled then
        local camera = Workspace.CurrentCamera
        local mouse = Players.LocalPlayer:GetMouse()
        local closestDistance = math.huge
        ClosestPlayerTemp = nil

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer and player.Character and player.Character.PrimaryPart then
                local part = player.Character.PrimaryPart
                local screenPoint = camera:WorldToScreenPoint(part.Position)
                local mousePosition = Vector2.new(mouse.X, mouse.Y)
                local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePosition).Magnitude

                if distance < CheckRadius and distance < closestDistance then
                    closestDistance = distance
                    ClosestPlayerTemp = player
                end
            end
        end

        if ClosestPlayerTemp then
            displayInventory(ClosestPlayerTemp)
        else
            LastDisplayedInventory = nil
            inventoryDisplayFrame.Visible = false
        end
    end
end)

-- 創建控制介面
local visual = library:AddWindow('inv checker') -- UI 窗口
local controls = visual:AddSection('inv checker') -- UI 分區

-- 添加開關功能
controls:AddToggle('inv checker', false, nil, function(state)
    InventoryCheckerEnabled = state
    if state then
        print("物品檢查器已啟用")
    else
        print("物品檢查器已禁用")
    end
end)

-- 添加按鍵綁定
controls:AddKeyBind('KeyBind', Enum.KeyCode.Home, function(key)
    customKeyBind = key -- 更新自定義按鍵
    print("Custom KeyBind updated to:", customKeyBind.Name)
end)
