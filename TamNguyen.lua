repeat wait() until game:IsLoaded()

-- UI Thông báo trạng thái trái cây
local TextLabel = Instance.new("TextLabel", game.CoreGui)
TextLabel.Size = UDim2.new(0, 300, 0, 50)
TextLabel.Position = UDim2.new(0.5, -150, 0, 100)
TextLabel.TextScaled = true
TextLabel.TextStrokeTransparency = 0
TextLabel.BackgroundTransparency = 0.3
TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.Text = "🔍 Đang kiểm tra trái Blox..."

-- Hàm lưu trái
function SaveFruit(tool)
    local args = {
        [1] = "StoreFruit",
        [2] = tool.Name
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end

-- Hàm lụm trái
function CollectFruits()
    for _, fruit in pairs(game.Workspace:GetChildren()) do
        if fruit:IsA("Tool") and fruit.Handle then
            TextLabel.Text = "✅ Có trái Blox: " .. fruit.Name
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = fruit.Handle.CFrame
            wait(0.5)
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, fruit.Handle, 0)
            wait(1)
            -- Sau khi lụm, thử lưu
            local Backpack = game.Players.LocalPlayer.Backpack
            for _, tool in pairs(Backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    SaveFruit(tool)
                    wait(0.5)
                end
            end
            return true
        end
    end
    return false
end

-- Hàm đổi server khi không có trái
function HopServer()
    TextLabel.Text = "❌ Không có trái Blox - Đang chuyển server..."
    wait(2)
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local PlaceID = game.PlaceId
    local servers = {}
    local success, response = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100")
    end)

    if success then
        local data = HttpService:JSONDecode(response)
        for _, server in pairs(data.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(PlaceID, server.id)
                break
            end
        end
    end
end

-- Chạy chính
while true do
    local found = CollectFruits()
    if not found then
        HopServer()
    end
    wait(10)
end
