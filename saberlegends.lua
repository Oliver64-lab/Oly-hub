-- Oly Hub V2 - Saber Legends (Mobile + PC)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Oly Hub - Saber Legends V2",
   LoadingTitle = "Oly Hub",
   LoadingSubtitle = "Mobile Friendly"
})

local Combat = Window:CreateTab("Combat")
local PlayerTab = Window:CreateTab("Player")

------------------------------------------------
-- SPEED
------------------------------------------------

PlayerTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16,35},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)

      local char = player.Character
      if char then
         char:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
      end

   end
})

------------------------------------------------
-- INFINITE JUMP
------------------------------------------------

local InfJump = false

PlayerTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value)
      InfJump = Value
   end
})

UIS.JumpRequest:Connect(function()

   if InfJump then

      local hum = player.Character:FindFirstChildOfClass("Humanoid")
      hum:ChangeState("Jumping")

   end

end)

------------------------------------------------
-- AUTO ATTACK
------------------------------------------------

local AutoAttack = false

Combat:CreateToggle({
   Name = "Auto Attack",
   CurrentValue = false,
   Callback = function(Value)
      AutoAttack = Value
   end
})

RunService.RenderStepped:Connect(function()

   if not AutoAttack then return end

   local char = player.Character
   if not char then return end

   local tool = char:FindFirstChildOfClass("Tool")

   if tool then
      tool:Activate()
   end

end)

------------------------------------------------
-- PERFECT BLOCK
------------------------------------------------

local PerfectBlock = false
local BlockChance = 70
local BlockDistance = 12

Combat:CreateToggle({
   Name = "Perfect Block",
   CurrentValue = false,
   Callback = function(Value)
      PerfectBlock = Value
   end
})

Combat:CreateSlider({
   Name = "Block Chance %",
   Range = {1,100},
   Increment = 1,
   CurrentValue = 70,
   Callback = function(Value)
      BlockChance = Value
   end
})

RunService.Heartbeat:Connect(function()

   if not PerfectBlock then return end

   local char = player.Character
   if not char then return end

   local hrp = char:FindFirstChild("HumanoidRootPart")
   if not hrp then return end

   for _,enemy in pairs(Players:GetPlayers()) do

      if enemy ~= player and enemy.Character then

         local root = enemy.Character:FindFirstChild("HumanoidRootPart")

         if root then

            local dist = (hrp.Position - root.Position).Magnitude

            if dist <= BlockDistance then

               if math.random(1,100) <= BlockChance then

                  local tool = char:FindFirstChildOfClass("Tool")

                  if tool then
                     tool:Activate()
                  end

               end

            end

         end

      end

   end

end)

------------------------------------------------
-- AUTO PARRY (Improved)
------------------------------------------------

local AutoParry = false
local ParryDistance = 10

Combat:CreateToggle({
   Name = "Auto Parry",
   CurrentValue = false,
   Callback = function(Value)
      AutoParry = Value
   end
})

RunService.Heartbeat:Connect(function()

   if not AutoParry then return end

   local char = player.Character
   if not char then return end

   local hrp = char:FindFirstChild("HumanoidRootPart")

   for _,enemy in pairs(Players:GetPlayers()) do

      if enemy ~= player and enemy.Character then

         local root = enemy.Character:FindFirstChild("HumanoidRootPart")

         if root then

            local dist = (hrp.Position - root.Position).Magnitude

            if dist <= ParryDistance then

               local tool = char:FindFirstChildOfClass("Tool")

               if tool then

                  task.wait(math.random(40,90)/1000)
                  tool:Activate()

               end

            end

         end

      end

   end

end)

------------------------------------------------
-- ENEMY MAGNET
------------------------------------------------

local Magnet = false
local MagnetDistance = 18

Combat:CreateToggle({
   Name = "Enemy Magnet",
   CurrentValue = false,
   Callback = function(Value)
      Magnet = Value
   end
})

RunService.Heartbeat:Connect(function()

   if not Magnet then return end

   local char = player.Character
   if not char then return end

   local hrp = char:FindFirstChild("HumanoidRootPart")

   for _,enemy in pairs(Players:GetPlayers()) do

      if enemy ~= player and enemy.Character then

         local root = enemy.Character:FindFirstChild("HumanoidRootPart")

         if root then

            if (hrp.Position - root.Position).Magnitude <= MagnetDistance then

               root.CFrame = hrp.CFrame * CFrame.new(0,0,-3)

            end

         end

      end

   end

end)
