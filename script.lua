-- Ví dụ nội dung script.lua
local plane = workspace:WaitForChild("Plane")
local speed = 0
local maxSpeed = 100
local acceleration = 5
local turnSpeed = 2
local inputState = {W=false, S=false, A=false, D=false}

-- GUI đơn giản kéo được
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,100)
frame.Position = UDim2.new(0.1,0,0.1,0)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.Active = true
frame.Draggable = true
-- toggle nút W/A/S/D ở đây nếu muốn

-- Bắt phím
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then inputState.W=true end
    if input.KeyCode == Enum.KeyCode.S then inputState.S=true end
    if input.KeyCode == Enum.KeyCode.A then inputState.A=true end
    if input.KeyCode == Enum.KeyCode.D then inputState.D=true end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then inputState.W=false end
    if input.KeyCode == Enum.KeyCode.S then inputState.S=false end
    if input.KeyCode == Enum.KeyCode.A then inputState.A=false end
    if input.KeyCode == Enum.KeyCode.D then inputState.D=false end
end)

-- Di chuyển
local RunService = game:GetService("RunService")
RunService.RenderStepped:Connect(function(delta)
    if inputState.W then speed = math.min(speed + acceleration, maxSpeed)
    elseif inputState.S then speed = math.max(speed - acceleration, -maxSpeed/2)
    else speed = speed*0.95 end
    local rotation = CFrame.Angles(0,0,0)
    if inputState.A then rotation = CFrame.Angles(0, math.rad(-turnSpeed),0)
    elseif inputState.D then rotation = CFrame.Angles(0, math.rad(turnSpeed),0) end
    plane.CFrame = plane.CFrame * rotation + plane.CFrame.LookVector * speed * delta
end)
