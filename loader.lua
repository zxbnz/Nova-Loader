local players = game:GetService("Players")
local run_service = game:GetService("RunService")
local user_input_service = game:GetService("UserInputService")
local tween_service = game:GetService("TweenService")
local core_gui = game:GetService("CoreGui")

local loader = Instance.new("ScreenGui", core_gui)
loader.Name = "GameLoader"

local games = {
    {
        name = "ValoBlox",
        link = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/zxbnz/Valolo-Blox/refs/heads/main/code"))()'
    },
    {
        name = "Jailbird",
        link = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/zxbnz/JailBird-Cheat/refs/heads/main/code"))()'
    },
    {
        name = "Operation Siege",
        link = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/zxbnz/OS-Cheat/refs/heads/main/code"))()'
    }
}

local holder_stroke = Instance.new("UIStroke")
holder_stroke.Color = Color3.fromRGB(24, 24, 24)
holder_stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- UI
local dragging = false
local mouse_start = nil
local frame_start = nil

local main = Instance.new("Frame", loader)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
main.Position = UDim2.new(0.427, 0, 0.393, 0)
main.Size = UDim2.new(0.145, 0, 0.267, 0)

local title = Instance.new("TextLabel", main)
title.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
title.Position = UDim2.new(0.036, 0, 0.02, 0)
title.Size = UDim2.new(0.927, 0, 0.112, 0)
title.Font = Enum.Font.RobotoMono
title.Text = "homohack"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextStrokeTransparency = 0
title.TextSize = 18
title.TextWrapped = true

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mouse_start = user_input_service:GetMouseLocation()
        frame_start = main.Position
    end
end)

user_input_service.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = user_input_service:GetMouseLocation() - mouse_start
        tween_service:Create(main, TweenInfo.new(0.1), {
            Position = UDim2.new(frame_start.X.Scale, frame_start.X.Offset + delta.X, frame_start.Y.Scale, frame_start.Y.Offset + delta.Y)
        }):Play()
    end
end)

user_input_service.InputEnded:Connect(function(input)
    if dragging then
        dragging = false
    end
end)

local ui_stroke = Instance.new("UIStroke", main)
ui_stroke.Thickness = 2
ui_stroke.Color = Color3.fromRGB(255, 255, 255)

local ui_gradient = Instance.new("UIGradient", ui_stroke)
ui_gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 70, 73)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})

local ui_corner = Instance.new("UICorner", title)
ui_corner.CornerRadius = UDim.new(0, 2)

local holder = Instance.new("Frame", main)
holder.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
holder.Position = UDim2.new(0.036, 0, 0.167, 0)
holder.Size = UDim2.new(0.927, 0, 0.782, 0)

local stroke = holder_stroke:Clone()
stroke.Parent = holder

local ui_corner_2 = Instance.new("UICorner", holder)
ui_corner_2.CornerRadius = UDim.new(0, 4)

local scrolling_frame = Instance.new("ScrollingFrame", holder)
scrolling_frame.Active = true
scrolling_frame.BackgroundTransparency = 1
scrolling_frame.Position = UDim2.new(0, 0, 0, 0)
scrolling_frame.Size = UDim2.new(1, 0, 1, 0)
scrolling_frame.CanvasSize = UDim2.new(0, 0, 5, 0)

local ui_padding = Instance.new("UIPadding"_
