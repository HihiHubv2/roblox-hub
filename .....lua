local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 初始化變數
local InventoryCheckerEnabled = false
local CheckRadius = 100
local ClosestPlayerTemp = nil
local LastDisplayedInventory = nil

-- 創建圓角函數
local function addUICorner(instance, radius)
    local corner = Instance.new("UICorner", instance)
    corner.CornerRadius = UDim.new(0, radius)
    return corner
end

-- 界面初始化
local ScreenGui = Instance.new("ScreenGui")
syn.protect_gui(ScreenGui)
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.Parent = CoreGui

-- 顯示框架
local inventoryDisplayFrame = Instance.new("Frame")
inventoryDisplayFrame.Size = UDim2.new(0.6, 0, 0.2, 0) -- 寬度60%，高度20%
inventoryDisplayFrame.Position = UDim2.new(0.2, 0, 0.05, 0)
inventoryDisplayFrame.BackgroundTransparency = 0.2
inventoryDisplayFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
inventoryDisplayFrame.BorderSizePixel = 0
inventoryDisplayFrame.Visible = false
inventoryDisplayFrame.Parent = ScreenGui

-- 添加圓角
addUICorner(inventoryDisplayFrame, 10)

-- 添加陰影
local shadow = Instance.new("Frame", inventoryDisplayFrame)
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundTransparency = 0.5
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.ZIndex = 0
shadow.BorderSizePixel = 0
addUICorner(shadow, 12)

-- 玩家名稱
local playerNameLabel = Instance.new("TextLabel", inventoryDisplayFrame)
playerNameLabel.Size = UDim2.new(1, 0, 0.2, 0)
playerNameLabel.Position = UDim2.new(0, 0, 0, 0)
playerNameLabel.BackgroundTransparency = 1
playerNameLabel.Text = "玩家名稱"
playerNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
playerNameLabel.Font = Enum.Font.GothamBold
playerNameLabel.TextScaled = true

-- 物品容器
local inventoryContainer = Instance.new("Frame", inventoryDisplayFrame)
inventoryContainer.Size = UDim2.new(1, 0, 0.8, 0)
inventoryContainer.Position = UDim2.new(0, 0, 0.2, 0)
inventoryContainer.BackgroundTransparency = 1

local inventoryGridLayout = Instance.new("UIGridLayout", inventoryContainer)
inventoryGridLayout.CellSize = UDim2.new(0.1, 0, 0.5, 0) -- 調整物品圖片尺寸
inventoryGridLayout.CellPadding = UDim2.new(0.02, 0, 0.02, 0)

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
    playerNameLabel.Text = "玩家: " .. player.Name

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
-- 添加開關功能
wh:AddToggle('啟用物品檢查器', true, nil, function(v)
    InventoryCheckerEnabled = v
    if inventoryDisplayFrame then
        inventoryDisplayFrame.Visible = v
    else
        warn("未找到 inventoryDisplayFrame，請檢查代碼初始化")
    end
end)

-- 添加滑桿功能
wh:AddSlider('檢查半徑 (Meters)', 100, 50, 500, function(c)
    CheckRadius = c
    print("檢查半徑設置為: " .. c)
end)

print("物品檢查器功能已成功初始化")
