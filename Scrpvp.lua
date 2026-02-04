local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "TamNguyen-Hub",
    SubTitle = "Aimbot & ESP",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- Sửa lỗi Icon: Tạo một ImageLabel đè lên logo nếu thư viện không hỗ trợ ID trực tiếp
local IconId = "rbxassetid://117935483117473"

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "crosshair" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" })
}

local Options = Fluent.Options

-- --- BIẾN HỖ TRỢ ---
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- --- 1. CHỨC NĂNG SPEED X20 ---
Tabs.Main:AddToggle("SpeedToggle", {Title = "Speed x20 (God Mode Speed)", Default = false})
RunService.Stepped:Connect(function()
    if Options.SpeedToggle.Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 320
    elseif not Options.SpeedToggle.Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        -- Trả về tốc độ gốc nếu không bật (tránh bị kẹt tốc độ 320)
        if LocalPlayer.Character.Humanoid.WalkSpeed == 320 then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

-- --- 2. CHỨC NĂNG AIMBOT ---
Tabs.Main:AddToggle("AimbotToggle", {Title = "Aimbot Camera", Default = false})
RunService.RenderStepped:Connect(function()
    if Options.AimbotToggle.Value then
        local target = nil
        local dist = math.huge
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local pos, visible = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                if visible then
                    local mouseDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if mouseDist < dist then
                        dist = mouseDist
                        target = v
                    end
                end
            end
        end
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
        end
    end
end)

-- --- 3. CHỨC NĂNG ESP BOX & LINE (RAW DRAWING) ---
Tabs.Visuals:AddToggle("EspToggle", {Title = "Enable ESP Box & Line", Default = false})

local function CreateESP(player)
    local Box = Drawing.new("Square")
    local Line = Drawing.new("Line")
    
    Box.Visible = false
    Box.Color = Color3.fromRGB(255, 0, 0)
    Box.Thickness = 1
    Box.Filled = false

    Line.Visible = false
    Line.Color = Color3.fromRGB(255, 255, 255)
    Line.Thickness = 1

    local function Update()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 and Options.EspToggle.Value then
                local rptranking, visible = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if visible then
                    -- Tính toán kích thước Box
                    local head = player.Character.Head.Position
                    local headPos = Camera:WorldToViewportPoint(head + Vector3.new(0, 0.5, 0))
                    local footPos = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0))
                    
                    Box.Size = Vector2.new(2000 / rptranking.Z, headPos.Y - footPos.Y)
                    Box.Position = Vector2.new(rptranking.X - Box.Size.X / 2, rptranking.Y - Box.Size.Y / 2)
                    Box.Visible = true

                    -- Line từ dưới màn hình
                    Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    Line.To = Vector2.new(rptranking.X, rptranking.Y)
                    Line.Visible = true
                else
                    Box.Visible = false
                    Line.Visible = false
                end
            else
                Box.Visible = false
                Line.Visible = false
                if not player.Parent then
                    Box:Remove()
                    Line:Remove()
                    connection:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Update)()
end

for _, v in pairs(Players:GetPlayers()) do
    if v ~= LocalPlayer then CreateESP(v) end
end
Players.PlayerAdded:Connect(function(v) CreateESP(v) end)

-- Thông báo
Fluent:Notify({
    Title = "TamNguen-Hub",
    Content = "Script đã sẵn sàng! Icon ID: " .. tostring(117935483117473),
    Duration = 5
})
