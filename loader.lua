local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Destroy any existing loader
if PlayerGui:FindFirstChild("NovaScriptLoader") then
	PlayerGui.NovaScriptLoader:Destroy()
end

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "NovaScriptLoader"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 180)
frame.Position = UDim2.new(0.5, -125, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Parent = gui

-- Round Corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- Title Bar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Nova Script Loader"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = frame

-- Button Template
local function createButton(text, link)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, 0)
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = text
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.Parent = frame

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = btn

	btn.MouseButton1Click:Connect(function()
		local success, code = pcall(function()
			return game:HttpGet(link)
		end)

		if success and code then
			local run = loadstring(code)
			if run then
				pcall(run)
			else
				warn("Loadstring failed.")
			end
		else
			warn("Failed to load script.")
		end

		gui:Destroy()
	end)

	return btn
end

-- Buttons
local valoblox = createButton("ValoBlox", "https://raw.githubusercontent.com/zxbnz/Valolo-Blox/main/code.lua")
valoblox.Position = UDim2.new(0, 10, 0, 40)

local jailbird = createButton("Jailbird", "https://raw.githubusercontent.com/zxbnz/JailBird-Cheat/main/code.lua")
jailbird.Position = UDim2.new(0, 10, 0, 80)

local siege = createButton("
