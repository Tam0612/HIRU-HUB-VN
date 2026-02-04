--================ HITBOX DEMO (VISUAL ONLY) ================
local Hitbox = false

local HitboxBtn = CreateButton("HITBOX DEMO : OFF", 190)

HitboxBtn.MouseButton1Click:Connect(function()
    Hitbox = not Hitbox
    HitboxBtn.Text = "HITBOX DEMO : " .. (Hitbox and "ON" or "OFF")
end)

RunService.RenderStepped:Connect(function()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart

            if Hitbox then
                if not hrp:FindFirstChild("HitboxVisual") then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Name = "HitboxVisual"
                    box.Adornee = hrp
                    box.Size = Vector3.new(4,6,4) -- kích thước demo
                    box.Color3 = Color3.fromRGB(255,0,0)
                    box.Transparency = 0.6
                    box.AlwaysOnTop = true
                    box.ZIndex = 5
                    box.Parent = hrp
                end
            else
                if hrp:FindFirstChild("HitboxVisual") then
                    hrp.HitboxVisual:Destroy()
                end
            end
        end
    end
end)
