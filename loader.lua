local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Destroy existing UI if present
local oldGui = PlayerGui:FindFirstChild("NovaLoader")
if oldGui then oldGui:Destroy() end

-- Themes
local darkTheme = {
	bg = Color3.fromRGB(15, 15, 15),
	text = Color3.fromRGB(255, 255, 255),
	button = Color3.fromRGB(35, 35, 35)
}
local lightTheme = {
	bg = Color3.fromRGB(240, 240, 240),
	text = Color3.fromRGB(0, 0, 0),
	button = Color3.fromRGB(200, 200, 200)
}
local currentTheme = darkTheme

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "NovaLoader"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0.5, -125, 0.5, -150)
frame.BackgroundColor3 = currentTheme.bg
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 0, 30)
title.Position = UDim2.new(0, 5, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Nova Script Loader"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = currentTheme.text
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- Close Button
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 24, 0, 24)
close.Position = UDim2.new(1, -28, 0, 3)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)
close.Parent = frame
Instance.new("UICorner", close).Parent = close
close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- Drag support
local dragging, dragStart, startPos
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

-- Buttons Layout
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = frame

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 40)
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)
padding.Parent = frame

-- Game scripts
local Games = {
	{name = "ValoBlox", link = "https://raw.githubusercontent.com/zxbnz/Valolo-Blox/main/code.lua"},
	{name = "Jailbird", link = "https://raw.githubusercontent.com/zxbnz/JailBird-Cheat/main/code.lua"},
	{name = "Operation Siege", link = "https://raw.githubusercontent.com/zxbnz/OS-Cheat/main/code.lua"},
}

-- Theme switch
local function applyTheme()
	frame.BackgroundColor3 = currentTheme.bg
	title.TextColor3 = currentTheme.text
	for _, child in ipairs(frame:GetChildren()) do
		if child:IsA("TextButton") and child.Name ~= "Close" then
			child.BackgroundColor3 = currentTheme.button
			child.TextColor3 = currentTheme.text
		end
	end
end

for _, g in ipairs(Games) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 32)
	btn.Text = g.name
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.BackgroundColor3 = currentTheme.button
	btn.TextColor3 = currentTheme.text
	btn.Parent = frame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	btn.MouseButton1Click:Connect(function()
		local success, result = pcall(function()
			return game:HttpGet(g.link)
		end)
		if success then
			local loaded = loadstring(result)
			if loaded then pcall(loaded) end
		else
			warn("Failed to load script:", result)
		end
		gui:Destroy()
	end)
end

-- Theme toggle button
local themeBtn = Instance.new("TextButton")
themeBtn.Size = UDim2.new(1, 0, 0, 30)
themeBtn.Text = "Switch Theme"
themeBtn.Font = Enum.Font.GothamBold
themeBtn.TextSize = 14
themeBtn.BackgroundColor3 = currentTheme.button
themeBtn.TextColor3 = currentTheme.text
themeBtn.Parent = frame
Instance.new("UICorner", themeBtn).CornerRadius = UDim.new(0, 6)

themeBtn.MouseButton1Click:Connect(function()
	currentTheme = (currentTheme == darkTheme) and lightTheme or darkTheme
	applyTheme()
end)

applyTheme()
