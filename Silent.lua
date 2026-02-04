local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "TamNguyen-Hub",
    SubTitle = "SCR PVP",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "crosshair" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" })
}

local Options = Fluent.Options
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- BIẾN MỤC TIÊU
local Target = nil

-- --- HÀM TÌM ĐỐI TƯỢNG GẦN TÂM CHUỘT NHẤT ---
local function GetClosestPlayer()
    local closest = nil
    local dist = math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local pos, visible = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if visible then
                local mouseDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mouseDist < dist then
                    dist = mouseDist
                    closest = v
                end
            end
        end
    end
    return closest
end

-- --- 1. SILENT AIM (Giúp chiêu thức bay trúng) ---
local oldIndex = nil
oldIndex = hookmetamethod(game, "__index", function(self, Index)
    if self == Mouse and (Index == "Hit" or Index == "Target") and Options.AimbotToggle.Value then
        if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
            return (Index == "Hit" and Target.Character.HumanoidRootPart.CFrame or Target.Character.HumanoidRootPart)
        end
    end
    return oldIndex(self, Index)
end)

-- --- 2. AIMBOT CAMERA & TARGET LOCK ---
Tabs.Main:AddToggle("AimbotToggle", {Title = "Aimbot & Silent Aim", Default = false})

RunService.RenderStepped:Connect(function()
    if Options.AimbotToggle.Value then
        Target = GetClosestPlayer()
        if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
            -- Xoay Camera
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character.HumanoidRootPart.Position)
        end
    else
        Target = nil
    end
end)

-- --- 3. SPEED X20 ---
Tabs.Main:AddToggle("SpeedToggle", {Title = "Speed x20", Default = false})
RunService.Stepped:Connect(function()
    if Options.SpeedToggle.Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 320
    end
end)

-- --- 4. ESP BOX & LINE ---
Tabs.Visuals:AddToggle("EspToggle", {Title = "Enable ESP Visuals", Default = false})

local function CreateESP(player)
    local Box = Drawing.new("Square")
    local Line = Drawing.new("Line")
    Box.Visible = false; Box.Color = Color3.fromRGB(255, 0, 0); Box.Thickness = 1; Box.Filled = false
    Line.Visible = false; Line.Color = Color3.fromRGB(255, 255, 255); Line.Thickness = 1

    RunService.RenderStepped:Connect(function()
        if Options.EspToggle.Value and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos, visible = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if visible then
                Box.Size = Vector2.new(1000 / pos.Z, 1500 / pos.Z)
                Box.Position = Vector2.new(pos.X - Box.Size.X / 2, pos.Y - Box.Size.Y / 2)
                Box.Visible = true
                Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                Line.To = Vector2.new(pos.X, pos.Y)
                Line.Visible = true
            else
                Box.Visible = false; Line.Visible = false
            end
        else
            Box.Visible = false; Line.Visible = false
        end
    end)
end

for _, v in pairs(Players:GetPlayers()) do if v ~= LocalPlayer then CreateESP(v) end end
Players.PlayerAdded:Connect(function(v) CreateESP(v) end)

Window:SelectTab(1)
