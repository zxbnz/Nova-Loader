local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- REMOVE OLD
if CoreGui:FindFirstChild("ScriptLoader") then
    CoreGui.ScriptLoader:Destroy()
end
if Lighting:FindFirstChild("LoaderBlur") then
    Lighting.LoaderBlur:Destroy()
end

-- Blur Glow
local blur = Instance.new("BlurEffect")
blur.Size = 15
blur.Name = "LoaderBlur"
blur.Parent = Lighting

-- Main GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ScriptLoader"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = CoreGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 200)
frame.Position = UDim2.new(0.5, -110, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout.Parent = frame

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 12)
padding.PaddingLeft = UDim.new(0, 12)
padding.PaddingRight = UDim.new(0, 12)
padding.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Text = "Script Loader"
title.Size = UDim2.new(1, 0, 0, 24)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = frame

-- Script List
local Scripts = {
    { name = "ValoBlox", link = "https://raw.githubusercontent.com/zxbnz/Valolo-Blox/refs/heads/main/code.lua" },
    { name = "Jailbird", link = "https://raw.githubusercontent.com/zxbnz/JailBird-Cheat/refs/heads/main/code.lua" },
    { name = "Operation Siege", link = "https://raw.githubusercontent.com/zxbnz/OS-Cheat/refs/heads/main/code.lua" },
}

-- Create Buttons
for _, data in ipairs(Scripts) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = data.name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = frame

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    -- Hover
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(70, 70, 90)
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        }):Play()
    end)

    -- Click
    btn.MouseButton1Click:Connect(function()
        -- Load Script
        local success, result = pcall(function()
            return game:HttpGet(data.link)
        end)
        if success then
            local fn, err = loadstring(result)
            if fn then
                pcall(fn)
            else
                warn("Loadstring error:", err)
            end
        else
            warn("HttpGet failed:", result)
        end

        -- Cleanup loader
        gui:Destroy()
        if blur then blur:Destroy() end
    end)
end

-- Drag
local dragging, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
