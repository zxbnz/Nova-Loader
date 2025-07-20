local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")

if not PlayerGui then
    warn("PlayerGui not found")
    return
end

-- Destroy old loader if exists
local old = PlayerGui:FindFirstChild("NovaLoader")
if old then old:Destroy() end

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NovaLoader"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

-- Main Frame (Black background)
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 200)
Frame.Position = UDim2.new(0.5, -110, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

-- Title Label
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Nova"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.new(1, 1, 1) -- White
Title.Parent = Frame

-- Layout
local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 10)
Layout.FillDirection = Enum.FillDirection.Vertical
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.VerticalAlignment = Enum.VerticalAlignment.Top
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Frame

-- Padding
local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 10)
Padding.PaddingLeft = UDim.new(0, 10)
Padding.PaddingRight = UDim.new(0, 10)
Padding.Parent = Frame

-- Script Buttons
local scripts = {
    {name = "ValoBlox", link = "https://raw.githubusercontent.com/zxbnz/Valolo-Blox/main/code.lua"},
    {name = "Jailbird", link = "https://raw.githubusercontent.com/zxbnz/JailBird-Cheat/main/code.lua"},
    {name = "Operation Siege", link = "https://raw.githubusercontent.com/zxbnz/OS-Cheat/main/code.lua"},
}

for _, data in ipairs(scripts) do
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 30)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Dark gray for contrast
    Btn.TextColor3 = Color3.new(1, 1, 1) -- White
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 14
    Btn.Text = data.name
    Btn.Parent = Frame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    Btn.MouseButton1Click:Connect(function()
        local success, scriptData = pcall(function()
            return game:HttpGet(data.link)
        end)

        if success then
            local loaded, err = loadstring(scriptData)
            if loaded then
                pcall(loaded)
            else
                warn("Loadstring failed:", err)
            end
        else
            warn("HttpGet failed:", scriptData)
        end

        ScreenGui:Destroy()
    end)
end
