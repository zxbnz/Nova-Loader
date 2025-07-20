local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- Clean up previous
if CoreGui:FindFirstChild("ScriptLoader") then CoreGui.ScriptLoader:Destroy() end
if Lighting:FindFirstChild("LoaderBlur") then Lighting.LoaderBlur:Destroy() end

-- Blur background
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
frame.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Animate background (dark red pulse)
task.spawn(function()
	local color1 = Color3.fromRGB(60, 0, 0)
	local color2 = Color3.fromRGB(100, 0, 0)
	while frame and frame.Parent do
		local tween1 = TweenService:Create(frame, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundColor3 = color2})
		local tween2 = TweenService:Create(frame, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundColor3 = color1})
		tween1:Play()
		tween1.Completed:Wait()
		tween2:Play()
		tween2.Completed:Wait()
	end
end)

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
title.Text = "Nova Script Loader"
title.Size = UDim2.new(1, 0, 0, 24)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = frame

-- Script list
local Scripts = {
    { name = "ValoBlox", link = "https://raw.githubusercontent.com/zxbnz/Valolo-Blox/refs/heads/main/code.lua" },
    { name = "Jailbird", link = "https://raw.githubusercontent.com/zxbnz/JailBird-Cheat/refs/heads/main/code.lua" },
    { name = "Operation Siege", link = "https://raw.githubusercontent.com/zxbnz/OS-Cheat/refs/heads/main/code.lua" },
}

-- Buttons
for _, data in ipairs(Scripts) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(70, 0, 0)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = data.name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = frame

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    -- Hover
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(100, 20, 20)
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(70, 0, 0)
        }):Play()
    end)

    -- Click action
    btn.MouseButton1Click:Connect(function()
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

        -- Self-destruct GUI & blur
        gui:Destroy()
        if blur then blur:Destroy() end
    end)
end

-- Dragging support
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
