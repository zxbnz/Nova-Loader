local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- Destroy existing loader if it exists
local existing = CoreGui:FindFirstChild("GameScriptLoader")
if existing then
    existing:Destroy()
end

-- Create blur background
local blur = Instance.new("BlurEffect")
blur.Size = 12
blur.Name = "UILoaderBlur"
blur.Parent = Lighting

-- Auto-remove blur when GUI closes
local function removeBlur()
    local existingBlur = Lighting:FindFirstChild("UILoaderBlur")
    if existingBlur then
        existingBlur:Destroy()
    end
end

local LoaderGui = Instance.new("ScreenGui")
LoaderGui.Name = "GameScriptLoader"
LoaderGui.ResetOnSpawn = false
LoaderGui.IgnoreGuiInset = true
LoaderGui.Parent = CoreGui

LoaderGui.AncestryChanged:Connect(function(_, parent)
    if not parent then
        removeBlur()
    end
end)

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 200)
Frame.Position = UDim2.new(0.5, -110, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
Frame.BorderSizePixel = 0
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Parent = LoaderGui

local Corner = Instance.new("UICorner", Frame)
Corner.CornerRadius = UDim.new(0, 8)

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.FillDirection = Enum.FillDirection.Vertical
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.VerticalAlignment = Enum.VerticalAlignment.Top
Layout.Parent = Frame

local Padding = Instance.new("UIPadding", Frame)
Padding.PaddingTop = UDim.new(0, 12)
Padding.PaddingLeft = UDim.new(0, 12)
Padding.PaddingRight = UDim.new(0, 12)
Padding.PaddingBottom = UDim.new(0, 12)

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 24)
Title.BackgroundTransparency = 1
Title.Text = "Game Script Loader"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = Frame

local Games = {
    { name = "ValoBlox", link = "https://raw.githubusercontent.com/zxbnz/Valolo-Blox/refs/heads/main/code.lua" },
    { name = "Jailbird", link = "https://raw.githubusercontent.com/zxbnz/JailBird-Cheat/refs/heads/main/code.lua" },
    { name = "Operation Siege", link = "https://raw.githubusercontent.com/zxbnz/OS-Cheat/refs/heads/main/code.lua" },
}

-- Function to load and run script from URL
local function loadGameScript(url)
    print("Attempting to load:", url)
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if success and response then
        print("Script downloaded, executing...")
        local fn, loadErr = loadstring(response)
        if fn then
            pcall(fn)
        else
            warn("Loadstring failed:", loadErr)
        end
    else
        warn("HttpGet failed:", response)
    end
end

-- Create buttons
for _, game in ipairs(Games) do
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 32)
    Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Text = game.name
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Btn.AutoButtonColor = false
    Btn.Parent = Frame

    local btnCorner = Instance.new("UICorner", Btn)
    btnCorner.CornerRadius = UDim.new(0, 6)

    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(65, 65, 85)}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}):Play()
    end)

    Btn.MouseButton1Click:Connect(function()
        loadGameScript(game.link)
        LoaderGui:Destroy()      -- 💥 Self-destruct the GUI
        removeBlur()             -- ✨ Remove the blur
    end)
end

-- Make Frame draggable
local dragging, dragStart, startPos

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
