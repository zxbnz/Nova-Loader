local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Destroy any existing loader
local existing = PlayerGui:FindFirstChild("NovaLoader")
if existing then existing:Destroy() end

-- Create ScreenGui
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

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Nova Script Loader"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = frame

-- Dragging logic
local dragging = false
local dragInput, dragStart, startPos

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

-- Add buttons for scripts
local scripts = {
	{name = "ValoBlox", link = "https://raw.githubusercontent.com/zxbnz/Valolo-Blox/main/code.lua"},
	{name = "Jailbird", link = "https://raw.githubusercontent.com/zxbnz/JailBird-Cheat/main/code.lua"},
	{name = "Operation Siege", link = "https://raw.githubusercontent.com/zxbnz/OS-Cheat/main/code.lua"},
}

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = frame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 40)
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)
padding.Parent = frame

for _, data in ipairs(scripts) do
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 0, 30)
	button.Text = data.name
	button.Font = Enum.Font.Gotham
	button.TextSize = 14
	button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Parent = frame

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = button

	button.MouseButton1Click:Connect(function()
		local success, result = pcall(function()
			return game:HttpGet(data.link)
		end)

		if success then
			local func = loadstring(result)
			if func then pcall(func) end
		else
			warn("Error loading script:", result)
		end

		gui:Destroy()
	end)
end
