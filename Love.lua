--// HIRU DEMO MENU ROBLOX
--// Icon ID: 100723301472598

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

--================ GUI ================
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

-- Icon mở menu
local Icon = Instance.new("ImageButton", ScreenGui)
Icon.Size = UDim2.new(0, 50, 0, 50)
Icon.Position = UDim2.new(0, 20, 0.4, 0)
Icon.Image = "rbxassetid://100723301472598"
Icon.BackgroundTransparency = 1
Icon.Draggable = true
Icon.Active = true

-- Menu
local Menu = Instance.new("Frame", ScreenGui)
Menu.Size = UDim2.new(0, 220, 0, 220)
Menu.Position = UDim2.new(0.5, -110, 0.5, -110)
Menu.BackgroundColor3 = Color3.fromRGB(25,25,25)
Menu.Visible = false
Menu.Active = true
Menu.Draggable = true

local UICorner = Instance.new("UICorner", Menu)
UICorner.CornerRadius = UDim.new(0,10)

--================ BUTTON MAKER ================
local function CreateButton(text, y)
    local btn = Instance.new("TextButton", Menu)
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0,8)
    return btn
end

--================ BUTTONS ================
local AimBtn   = CreateButton("AIMBOT : OFF", 10)
local EspBoxBtn= CreateButton("ESP BOX : OFF", 55)
local EspLineBtn=CreateButton("ESP LINE : OFF", 100)
local SpeedBtn = CreateButton("SPEED x20 : OFF", 145)

--================ TOGGLES ================
local Aimbot = false
local EspBox = false
local EspLine = false
local Speed = false

--================ MENU TOGGLE ================
Icon.MouseButton1Click:Connect(function()
    Menu.Visible = not Menu.Visible
end)

--================ AIMBOT ================
local function GetClosestPlayer()
    local closest, dist = nil, math.huge
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            local pos, onscreen = Camera:WorldToViewportPoint(plr.Character.Head.Position)
            if onscreen then
                local mag = (Vector2.new(pos.X,pos.Y) -
                    Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if mag < dist then
                    dist = mag
                    closest = plr
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if Aimbot then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

--================ SPEED ================
SpeedBtn.MouseButton1Click:Connect(function()
    Speed = not Speed
    SpeedBtn.Text = "SPEED x20 : " .. (Speed and "ON" or "OFF")
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Speed and 320 or 16
    end
end)

--================ BUTTON EVENTS ================
AimBtn.MouseButton1Click:Connect(function()
    Aimbot = not Aimbot
    AimBtn.Text = "AIMBOT : " .. (Aimbot and "ON" or "OFF")
end)

EspBoxBtn.MouseButton1Click:Connect(function()
    EspBox = not EspBox
    EspBoxBtn.Text = "ESP BOX : " .. (EspBox and "ON" or "OFF")
end)

EspLineBtn.MouseButton1Click:Connect(function()
    EspLine = not EspLine
    EspLineBtn.Text = "ESP LINE : " .. (EspLine and "ON" or "OFF")
end)
