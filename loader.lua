local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Cleanup
local old = PlayerGui:FindFirstChild("NovaLoader")
if old then old:Destroy() end

-- UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NovaLoader"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 240, 0, 260)
Frame.Position = UDim2.new(0.5, -120, 0.5, -130)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Start dark theme
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 1, 0)
Title.Position = UDim2.new(0, 5, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Nova Script Loader"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Close button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -28, 0, 3)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Drag to move
local dragging, dragStart, startPos = false, nil, nil
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- Layout & Padding
local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.FillDirection = Enum.FillDirection.Vertical
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.VerticalAlignment = Enum.VerticalAlignment.Top
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Frame

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 40)
Padding.PaddingLeft = UDim.new(0, 10)
Padding.PaddingRight = UDim.new(0, 10)
Padding.Parent = Frame

-- Game list
local Games = {
    {name = "ValoBlox", link = "https://raw.githubusercontent.com/zxbnz/Valolo-Blox/main/code.lua"},
    {name = "Jailbird", link = "https://raw.githubusercontent.com/zxbnz/JailBird-Cheat/main/code.lua"},
    {name = "Operation Siege", link = "https://raw.githubusercontent.com/zxbnz/OS-Cheat/main/code.lua"},
}

-- Theme colors
local darkTheme = {
    bg = Color3.fromRGB(0, 0, 0),
    text = Color3.new(1, 1, 1),
    button = Color3.fromRGB(30, 30, 30)
}
local lightTheme = {
    bg = Color3.fromRGB(245, 245, 245),
    text = Color3.new(0, 0, 0),
    button = Color3.fromRGB(200, 200, 200)
}
local currentTheme = darkTheme

local function applyTheme()
    Frame.BackgroundColor3 = currentTheme.bg
    Title.TextColor3 = currentTheme.text
    CloseBtn.TextColor3 = currentTheme.text
    for _, btn in pairs(Frame:GetChildren()) do
        if btn:IsA("TextButton") and btn.Name ~= "Close" then
            btn.BackgroundColor3 = currentTheme.button
            btn.TextColor3 = currentTheme.text
        end
    end
end

-- Buttons
for _, gameData in ipairs(Games) do
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 30)
    Btn.BackgroundColor3 = currentTheme.button
    Btn.TextColor3 = currentTheme.text
    Btn.Text = gameData.name
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 14
    Btn.Parent = Frame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    Btn.MouseButton1Click:Connect(function()
        local success, script = pcall(function()
            return game:HttpGet(gameData.link)
        end)
        if success then
            local loaded, err = loadstring(script)
            if loaded then pcall(loaded) else warn("Loadstring error:", err) end
        else
            warn("HttpGet failed:", script)
        end
        ScreenGui:Destroy()
    end)
end

-- Theme switch button
local ThemeSwitch = Instance.new("TextButton")
ThemeSwitch.Size = UDim2.new(1, 0, 0, 30)
ThemeSwitch.BackgroundColor3 = currentTheme.button
ThemeSwitch.TextColor3 = currentTheme.text
ThemeSwitch.Text = "Switch Theme"
ThemeSwitch.Font = Enum.Font.GothamBold
ThemeSwitch.TextSize = 14
ThemeSwitch.Parent = Frame
Instance.new("UICorner", ThemeSwitch).CornerRadius = UDim.new(0, 6)

ThemeSwitch.MouseButton1Click:Connect(function()
    currentTheme = (currentTheme == darkTheme) and lightTheme or darkTheme
    applyTheme()
end)

applyTheme()
