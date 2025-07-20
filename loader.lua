local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

-- Cleanup previous GUI
if guiParent:FindFirstChild("ScriptLoader") then
	guiParent.ScriptLoader:Destroy()
end

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ScriptLoader"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = guiParent

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 220)
frame.Position = UDim2.new(0.5, -120, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(180, 0, 0) -- Solid red
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Layout & padding
local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top

local padding = Instance.new("UIPadding", frame)
padding.PaddingTop = UDim.new(0, 12)
padding.PaddingLeft = UDim.new(0, 12)
padding.PaddingRight = UDim.new(0, 12)

-- Title Label
local title = Instance.new("TextLabel")
title.Text = "Nova"
title.Size = UDim2.new(1, 0, 0, 26)
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

for _, data in ipairs(Scripts) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 32)
	btn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Text = data.name
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Parent = frame

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	btn.MouseButton1Click:Connect(function()
		print("Loading:", data.name)
		local success, result = pcall(function()
			return game:HttpGet(data.link)
		end)

		if success then
			local fn, err = loadstring(result)
			if fn then
				pcall(fn)
			else
				warn("Loadstring failed:", err)
			end
		else
			warn("HttpGet failed:", result)
		end

		gui:Destroy() -- Self-destruct
	end)
end

-- Make draggable
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
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
