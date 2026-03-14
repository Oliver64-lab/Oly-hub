-- Oly Hub
-- Saber Legends
-- Version 2.6

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Oly Hub - Saber Legends",
   LoadingTitle = "Oly Hub",
   LoadingSubtitle = "v2.6"
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
      if hum then
         hum:ChangeState("Jumping")
      end

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
-- SMART PERFECT BLOCK
------------------------------------------------

local PerfectBlock = false
local BaseBlockChance = 60
local BlockDistance = 12
local LastBlock = 0
local BlockCooldown = 0.4

Combat:CreateToggle({
   Name = "Smart Perfect Block",
   CurrentValue = false,
   Callback = function(Value)
      PerfectBlock = Value
   end
})

Combat:CreateSlider({
   Name = "Base Block Chance",
   Range = {1,100},
   Increment = 1,
   CurrentValue = 60,
   Callback = function(Value)
      BaseBlockChance = Value
   end
})

RunService.Heartbeat:Connect(function()

   if not PerfectBlock then return end
   if tick() - LastBlock < BlockCooldown then return end

   local char = player.Character
   if not char then return end

   local hrp = char:FindFirstChild("HumanoidRootPart")
   if not hrp then return end

   for _,enemy in pairs(Players:GetPlayers()) do

      if enemy ~= player and enemy.Character then

         local root = enemy.Character:FindFirstChild("HumanoidRootPart")
         local hum = enemy.Character:FindFirstChildOfClass("Humanoid")

         if root and hum then

            local dist = (hrp.Position - root.Position).Magnitude
            local Chance = BaseBlockChance

            if dist < 10 then
               Chance = Chance + 15
            end

            if dist < 6 then
               Chance = Chance + 25
            end

            Chance = math.clamp(Chance,1,100)

            if math.random(1,100) <= Chance then

               local tool = char:FindFirstChildOfClass("Tool")

               if tool then
                  tool:Activate()
                  LastBlock = tick()
               end

            end

         end

      end

   end

end)

------------------------------------------------
-- SMART AUTO PARRY
------------------------------------------------

local AutoParry = false
local BaseParryChance = 60
local ParryDistance = 12
local LastParry = 0
local ParryCooldown = 0.35

Combat:CreateToggle({
   Name = "Smart Auto Parry",
   CurrentValue = false,
   Callback = function(Value)
      AutoParry = Value
   end
})

Combat:CreateSlider({
   Name = "Base Parry Chance",
   Range = {1,100},
   Increment = 1,
   CurrentValue = 60,
   Callback = function(Value)
      BaseParryChance = Value
   end
})

RunService.Heartbeat:Connect(function()

   if not AutoParry then return end
   if tick() - LastParry < ParryCooldown then return end

   local char = player.Character
   if not char then return end

   local hrp = char:FindFirstChild("HumanoidRootPart")

   for _,enemy in pairs(Players:GetPlayers()) do

      if enemy ~= player and enemy.Character then

         local root = enemy.Character:FindFirstChild("HumanoidRootPart")
         local hum = enemy.Character:FindFirstChildOfClass("Humanoid")

         if root and hum then

            local dist = (hrp.Position - root.Position).Magnitude
            local Chance = BaseParryChance

            if dist < 10 then
               Chance = Chance + 20
            end

            if dist < 6 then
               Chance = Chance + 30
            end

            Chance = math.clamp(Chance,1,100)

            if math.random(1,100) <= Chance then

               local tool = char:FindFirstChildOfClass("Tool")

               if tool then
                  tool:Activate()
                  LastParry = tick()
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
