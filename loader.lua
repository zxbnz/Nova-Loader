local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Remove old loader if exists
if PlayerGui:FindFirstChild("NovaScriptLoader") then
    PlayerGui:FindFirstChild("NovaScriptLoader"):Destroy()
end

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "NovaScriptLoader"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 240)
frame.Position = UDim2.new(0.5, -125, 0.5, -120)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- black
frame.BorderSizePixel = 0
frame.Parent = gui

-- Make corners rounded
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- Title Label (draggable area)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Nova Script Loader"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = frame

-- Scripts
local scripts = {
    {name = "ValoBlox", link = "https://raw.githubusercontent.com/zxbnz/Valolo-Blox/main/code.lua"},
    {name = "Jailbird", link = "https://raw.githubusercontent.com/zxbnz/JailBird-Cheat/main/code.lua"},
    {name = "Operation Siege", link = "https://raw.githubusercontent.com/zxbnz/OS-Cheat/main/code.lua"},
}

-- UI Layout
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout.Parent = frame

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 40)
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)
padding.Parent = frame

-- Add buttons
for _, script in ipairs(scripts) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 32)
    button.Text = script.name
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = button

    button.MouseButton1Click:Connect(function()
        local success, result = pcall(function()
            return game:HttpGet(script.link)
        end)

        if success then
            local f, err = loadstring(result)
            if f then
                pcall(f)
            else
                warn("Script error:", err)
            end
        else
            warn("Download failed:", result)
        end

        gui:Destroy() -- self-destruct
    end)
end

-- Dragging logic
local dragging = false
local dragStart, startPos

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)
