local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Destroy previous loader if exists
if PlayerGui:FindFirstChild("NovaLoader") then
    PlayerGui:FindFirstChild("NovaLoader"):Destroy()
end

-- UI
local gui = Instance.new("ScreenGui")
gui.Name = "NovaLoader"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 240)
frame.Position = UDim2.new(0.5, -125, 0.5, -120)
frame.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "Nova"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = frame

-- Layout
local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 8)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Padding
local padding = Instance.new("UIPadding", frame)
padding.PaddingTop = UDim.new(0, 10)
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)

-- Button Scripts
local scripts = {
    { name = "ValoBlox", link = "https://raw.githubusercontent.com/zxbnz/Valolo-Blox/main/code.lua" },
    { name = "Jailbird", link = "https://raw.githubusercontent.com/zxbnz/JailBird-Cheat/main/code.lua" },
    { name = "Operation Siege", link = "https://raw.githubusercontent.com/zxbnz/OS-Cheat/main/code.lua" },
}

for _, data in ipairs(scripts) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(90, 0, 0)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = data.name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        local success, result = pcall(function()
            return game:HttpGet(data.link)
        end)

        if success then
            local func, err = loadstring(result)
            if func then
                pcall(func)
            else
                warn("Loadstring error:", err)
            end
        else
            warn("HttpGet error:", result)
        end

        gui:Destroy() -- Self-destruct
    end)
end

-- Drag support
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
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

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
