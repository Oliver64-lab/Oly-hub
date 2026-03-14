
-- Oly Hub | Aim Assist Script

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Oly Hub | Aim Assist",
   LoadingTitle = "Oly Hub",
   LoadingSubtitle = "Aiming System"
})

local Tab = Window:CreateTab("Combat")

local AimAssist = false
local AimStrength = 0.15
local ESPEnabled = false

-- Aim Toggle
Tab:CreateToggle({
   Name = "Aim Assist",
   CurrentValue = false,
   Callback = function(Value)
      AimAssist = Value
   end
})

-- Aim Strength
Tab:CreateSlider({
   Name = "Aim Strength",
   Range = {1,100},
   Increment = 1,
   CurrentValue = 15,
   Callback = function(Value)
      AimStrength = Value/100
   end
})

-- ESP Toggle
Tab:CreateToggle({
   Name = "Player ESP",
   CurrentValue = false,
   Callback = function(Value)
      ESPEnabled = Value
   end
})

-- Find closest enemy
local function GetClosest()
   local closest = nil
   local dist = math.huge

   for _,v in pairs(Players:GetPlayers()) do
      if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then

         local pos, onscreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)

         if onscreen then
            local magnitude = (Vector2.new(pos.X,pos.Y) - Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)).Magnitude

            if magnitude < dist then
               dist = magnitude
               closest = v
            end
         end

      end
   end

   return closest
end

-- Aim Assist
RunService.RenderStepped:Connect(function()

   if AimAssist then

      local target = GetClosest()

      if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then

         local targetPos = target.Character.HumanoidRootPart.Position

         Camera.CFrame = Camera.CFrame:Lerp(
            CFrame.new(Camera.CFrame.Position, targetPos),
            AimStrength
         )

      end

   end

end)

-- ESP
RunService.RenderStepped:Connect(function()

   if ESPEnabled then

      for _,v in pairs(Players:GetPlayers()) do

         if v ~= LocalPlayer and v.Character then

            if not v.Character:FindFirstChild("OlyESP") then

               local highlight = Instance.new("Highlight")
               highlight.Name = "OlyESP"
               highlight.FillColor = Color3.fromRGB(255,0,0)
               highlight.Parent = v.Character

            end

         end

      end

   end

end)
