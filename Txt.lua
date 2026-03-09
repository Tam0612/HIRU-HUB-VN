-- GUI
local ScreenGui = Instance.new("ScreenGui")
local Icon = Instance.new("ImageButton")
local Frame = Instance.new("Frame")
local StopButton = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui

-- Icon menu
Icon.Parent = ScreenGui
Icon.Size = UDim2.new(0,60,0,60)
Icon.Position = UDim2.new(0,20,0.5,-30)
Icon.Image = "rbxassetid://100723301472598"
Icon.BackgroundTransparency = 1

-- Menu
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0,200,0,150)
Frame.Position = UDim2.new(0.5,-100,0.5,-75)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Visible = false

-- Nút stop
StopButton.Parent = Frame
StopButton.Size = UDim2.new(0,120,0,40)
StopButton.Position = UDim2.new(0.5,-60,0.5,-20)
StopButton.Text = "STOP NHAC"
StopButton.BackgroundColor3 = Color3.fromRGB(200,50,50)
StopButton.TextColor3 = Color3.new(1,1,1)

-- Mở / đóng menu
Icon.MouseButton1Click:Connect(function()
	Frame.Visible = not Frame.Visible
end)

-- Nhạc
local sound = Instance.new("Sound")
sound.Name = "Ai Dua Em Ve"
sound.SoundId = "rbxassetid://110919391228823"
sound.Volume = 5
sound.Parent = workspace

sound:Play()

-- Khi hết nhạc tự phát lại
sound.Ended:Connect(function()
	sound:Play()
end)

-- Stop nhạc
StopButton.MouseButton1Click:Connect(function()
	sound:Stop()
end)
