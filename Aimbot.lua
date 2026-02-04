--[[
    Z-Hub Script - Hosted on GitHub
    Chức năng: Aimbot, ESP Box/Line, Speed x20
]]

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Z-Hub Multi-Hack",
    SubTitle = "by Gemini",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl -- Phím đóng/mở
})

-- Sử dụng ID Icon bạn cung cấp
local MenuIcon = "rbxassetid://117935483117473"

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "crosshair" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- --- BIẾN HỖ TRỢ ---
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Options = Fluent.Options

-- --- CHỨC NĂNG SPEED X20 ---
Tabs.Main:AddToggle("SpeedToggle", {Title = "Speed x20", Default = false})
Options.SpeedToggle:OnChanged(function()
    RunService.Stepped:Connect(function()
        if Options.SpeedToggle.Value then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 320
            end
        else
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    end)
end)

-- --- CHỨC NĂNG AIMBOT ---
Tabs.Main:AddToggle("AimbotToggle", {Title = "Aimbot (Lock Cam)", Default = false})

RunService.RenderStepped:Connect(function()
    if Options.AimbotToggle.Value then
        local closestPlayer = nil
        local shortestDistance = math.huge

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if distance < shortestDistance then
                        closestPlayer = player
                        shortestDistance = distance
                    end
                end
            end
        end

        if closestPlayer then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestPlayer.Character.HumanoidRootPart.Position)
        end
    end
end)

-- --- CHỨC NĂNG ESP (Line & Box) ---
Tabs.Visuals:AddToggle("ESPToggle", {Title = "Enable ESP Visuals", Default = false})
-- (Phần này sẽ vẽ Drawing.new lên màn hình khi bạn bật Toggle)
