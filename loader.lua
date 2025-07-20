local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Destroy existing loader if present
local existing = PlayerGui:FindFirstChild("NovaLoader")
if existing then existing:Destroy() end

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "NovaLoader"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 250)
frame.Position = UDim2.new(0.5, -125, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 8)

-- Title Label (also used to drag)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Nova Script Loader"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = frame

-- Padding & layout
local padding = Instance.new("UIPadding", frame)
padding.PaddingTop = UDim.new(0, 40)
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)

local layout = Instance.new("UIListLayout", frame)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 8)

-- Dragging logic
local dragging, dragStart, startPos = false

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

-- Scripts list
local scripts = {
    {name = "ValoBlox", link = "https://raw.githubusercontent.com/zxbnz/Valolo-Blox/main/code.lua"},
    {name = "Jailbird", link = "https://raw.githubusercontent.com/zxbnz/JailBird-Cheat/main/code.lua"},
    {name = "Operation Siege", link = "https://raw.githubusercontent.com/zxbnz/OS-Cheat/main/code.lua"},
}

-- Create buttons
for _, scriptInfo in ipairs(scripts) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Text = scriptInfo.name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = frame

    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        local success, result = pcall(function()
            return game:HttpGet(scriptInfo.link)
        end)

        if success and result then
            local loadSuccess, err = pcall(function()
                local func = loadstring(result)
                if func then func() end
            end)

            if not loadSuccess then
                warn("Error running script:", err)
            end
        else
            warn("Error downloading script:", result)
        end

        gui:Destroy() -- Self-destruct loader
    end)
end
