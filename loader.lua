local players = game:GetService("Players")
local core_gui = game:GetService("CoreGui")
local user_input_service = game:GetService("UserInputService")

-- Clean up old GUI if already present
if core_gui:FindFirstChild("homohackLoader") then
    core_gui:FindFirstChild("homohackLoader"):Destroy()
end

-- Game list
local games = {
	{ name = "ValoBlox", link = "https://raw.githubusercontent.com/zxbnz/Valolo-Blox/refs/heads/main/code" },
	{ name = "Jailbird", link = "https://raw.githubusercontent.com/zxbnz/JailBird-Cheat/refs/heads/main/code" },
	{ name = "Operation Siege", link = "https://raw.githubusercontent.com/zxbnz/OS-Cheat/refs/heads/main/code" },
}

-- UI Setup
local loader = Instance.new("ScreenGui")
loader.Name = "homohackLoader"
loader.ResetOnSpawn = false
loader.Parent = core_gui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0.5, -125, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = loader

local uicorner = Instance.new("UICorner", frame)
uicorner.CornerRadius = UDim.new(0, 6)

local title = Instance.new("TextLabel")
title.Text = "Nova Game Loader"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

-- Dragging functionality
local dragging = false
local dragStart, startPos

title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

user_input_service.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

user_input_service.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale
