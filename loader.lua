local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- Clean up old loader
local existing = CoreGui:FindFirstChild("ScriptLoader")
if existing then existing:Destroy() end

-- Add blur effect
local blur = Instance.new("BlurEffect")
blur.Size = 12
blur.Name = "ScriptLoaderBlur"
blur.Parent = Lighting

-- Cleanup blur if GUI closes
local function removeBlur()
    local b = Lighting:FindFirstChild("ScriptLoaderBlur")
    if b then b:Destroy() end
end

-- UI base
local LoaderGui = Instance.new("ScreenGui")
LoaderGui.Name = "ScriptLoader"
LoaderGui.IgnoreGuiInset = true
LoaderGui.ResetOnSpawn = false
LoaderGui.Parent = CoreGui

LoaderGui.AncestryChanged:Connect(function(_, parent)
    if not parent then removeBlur() end
end)

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 200)
Frame.Position = UDim2.new(0.5, -110, 0.5, -100)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
Frame.BorderSizePixel = 0
Frame.Parent = LoaderGui

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

local Layout = Instance.new("UIListLayout", Frame)
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.VerticalAlignment = Enum.VerticalAlignment.Top

local Padding = Instance.new("UIPadding", Frame)
Padding.PaddingTop = UDim.new(0, 12)
Padding.PaddingLeft = UDim.new(0, 12)
Padding.PaddingRight = UDim.new(0, 12)
Padding.PaddingBottom = UDim.new(0, 12)

-- Title
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 24)
Title.BackgroundTransparency = 1
Title.Text = "Script Loader"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.new(1,1,1)

-- Scripts to load
local Scripts = {
    { name = "ValoBlox", link = "https://raw.githubusercontent.com/zxbnz/Valolo-Blox/refs/heads/main/code.lua" },
    { name = "Jailbird", link = "https://raw.githubusercontent.com/zxbnz/JailBird-Cheat/refs/heads/main/code.lua" },
    { name = "Operation Siege", link = "https://raw.githubusercontent.com/zxbnz/OS-Cheat/refs/heads/main/code.lua" },
}

-- Function to load scripts
local function loadScript(url)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)

    if success and result then
        local fn, err = loadstring(result)
        if fn then
            pcall(fn)
        else
            warn("Loadstring failed:", err)
        end
    else
        warn("HttpGet failed:", result)
    end
end

-- Buttons
for _, script in ipairs(Scripts) do
    local Btn = Instance.new("TextButton", Frame)
    Btn.Size = UDim2.new(1, 0, 0, 32)
    Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.Text = script.name
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Btn.AutoButtonColor = false

    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    -- Hover
    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(65, 65, 85)
        }):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        }):Play()
    end)

    Btn.MouseButton1Click:Connect(function()
        -- Load script
        loadScript(script.link)

        -- Self-destruct
        if LoaderGui then LoaderGui:Destroy() end
        removeBlur()
    end)
end

-- Draggable UI
local dragging = false
local dragStart, startPos

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
