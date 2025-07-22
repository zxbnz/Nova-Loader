local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Destroy any previous loader
local existing = PlayerGui:FindFirstChild("NovaScriptLoader")
if existing then existing:Destroy() end

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "NovaScriptLoader"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

-- Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 200)
frame.Position = UDim2.new(0.5, -130, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Parent = gui

-- UICorner
Instance.new("UICorner", frame)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "nova script loader"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

-- Create Button Function
local function makeButton(text, positionY, url)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, positionY)
	btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = text
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.Parent = frame
	Instance.new("UICorner", btn)

	btn.MouseButton1Click:Connect(function()
		local success, result = pcall(function()
			return game:HttpGet(url)
		end)

		if success then
			local func, err = loadstring(result)
			if func then
				pcall(func)
				gui:Destroy() -- Self-destruct
			else
				warn("Loadstring error:", err)
			end
		else
			warn("HttpGet failed:", result)
		end
	end)
end

-- Buttons
makeButton("ValoBlox", 40, "https://raw.githubusercontent.com/zxbnz/Valolo-Blox/refs/heads/main/code.lua")
makeButton("Jailbird", 80, "https://raw.githubusercontent.com/zxbnz/JailBird-Cheat/refs/heads/main/code.lua")
makeButton("Operation Siege", 120, "https://raw.githubusercontent.com/zxbnz/OS-Cheat/refs/heads/main/code.lua")

-- Dragging
local dragging = false
local dragInput, startPos, dragStart

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
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Discord Invite TextBox at bottom
local inviteBox = Instance.new("TextBox")
inviteBox.AnchorPoint = Vector2.new(0, 1) -- anchor bottom left
inviteBox.Position = UDim2.new(0, 10, 1, -10) -- 10px above bottom edge
inviteBox.Size = UDim2.new(1, -20, 0, 30)
inviteBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
inviteBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inviteBox.Font = Enum.Font.Gotham
inviteBox.TextSize = 14
inviteBox.Text = "https://discord.gg/y9zwCcN6bx"  -- Replace this
inviteBox.ClearTextOnFocus = false
inviteBox.TextEditable = false
inviteBox.Parent = frame
Instance.new("UICorner", inviteBox)

