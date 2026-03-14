-- Oly Hub - Saber Legends
-- V3 (AutoSwing + Smart Block + Perfect Block + Stamina Boost)

-- Venyx UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Skidware/venyx-library/main/VenyxLibrary.lua"))()
local Window = Library:CreateWindow("Oly Hub | Saber Legends")

-- Tabs
local Combat = Window:CreateTab("Combat")

-- Sections
local CombatSection = Combat:CreateSection("Combat Settings")

-- Variables
local AutoSwing = false
local SmartBlock = false
local PerfectBlock = false
local BlockChance = 50
local StaminaBoost = false

-- Toggles
CombatSection:CreateToggle("Auto Swing", nil, function(value)
    AutoSwing = value
end)

CombatSection:CreateToggle("Smart Block", nil, function(value)
    SmartBlock = value
end)

CombatSection:CreateToggle("Perfect Block", nil, function(value)
    PerfectBlock = value
end)

CombatSection:CreateSlider("Block Chance", 1, 100, function(value)
    BlockChance = value
end)

CombatSection:CreateToggle("Stamina Boost", nil, function(value)
    StaminaBoost = value
end)

-- Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Main logic
RunService.Heartbeat:Connect(function()

    local char = player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local tool = char:FindFirstChildOfClass("Tool")

    -- Auto Swing (attack automatically when enemy close)
    if AutoSwing and tool then
        for _,enemy in pairs(Players:GetPlayers()) do
            if enemy ~= player and enemy.Character then
                local enemyHrp = enemy.Character:FindFirstChild("HumanoidRootPart")
                if enemyHrp and (enemyHrp.Position - hrp.Position).Magnitude <= 12 then
                    tool:Activate()
                end
            end
        end
    end

    -- Smart Block / Perfect Block
    if (SmartBlock or PerfectBlock) and tool then
        for _,enemy in pairs(Players:GetPlayers()) do
            if enemy ~= player and enemy.Character then
                local enemyHrp = enemy.Character:FindFirstChild("HumanoidRootPart")
                if enemyHrp then
                    local dist = (enemyHrp.Position - hrp.Position).Magnitude
                    if dist <= 8 then
                        local chance = BlockChance

                        -- boost perfect block when very close
                        if PerfectBlock then
                            chance = chance + 20
                        end

                        if math.random(1,100) <= chance then
                            tool:Activate()
                        end
                    end
                end
            end
        end
    end

    -- Stamina Boost (client attempt)
    if StaminaBoost then
        local stamina = char:FindFirstChild("Stamina")
        if stamina and stamina.Value < stamina.MaxValue then
            stamina.Value = stamina.MaxValue
        end
    end

end)

print("Oly Hub - Saber Legends loaded!")
