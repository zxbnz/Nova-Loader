local players = game:GetService("Players")
local run_service = game:GetService("RunService")
local user_input_service = game:GetService("UserInputService")
local tween_service = game:GetService("TweenService")
local core_gui = game:GetService("CoreGui")

local loader = Instance.new("ScreenGui", core_gui)
loader.Name = "homohackLoader"

local games = {
	{ name = "ValoBlox", link = "https://raw.githubusercontent.com/zxbnz/Valolo-Blox/refs/heads/main/code" },
	{ name = "Jailbird", link = "https://raw.githubusercontent.com/zxbnz/JailBird-Cheat/refs/heads/main/code" },
	{ name = "Operation Siege", link = "https://raw.githubusercontent.com/zxbnz/OS-Cheat/refs/heads/main/code" },
}

local holder_stroke = Instance.new("UIStroke")
holder_stroke.Color = Color3.fromRGB(24, 24, 24)
holder_stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- UI
local dragging = false
local mouse_start = nil
local frame_start = nil_
