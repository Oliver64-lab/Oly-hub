-- Oly Hub
-- Saber Legends
-- Version 2.6

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

------------------------------------------------
-- LOAD RAYFIELD
------------------------------------------------

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

------------------------------------------------
-- WINDOW
------------------------------------------------

local Window = Rayfield:CreateWindow({
   Name = "Oly Hub - Saber Legends",
   LoadingTitle = "Oly Hub",
   LoadingSubtitle = "v2.6",
   ConfigurationSaving = {
      Enabled = false
   }
})

------------------------------------------------
-- TABS
------------------------------------------------

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
         local hum = char:FindFirstChildOfClass("Humanoid")
         if hum then
            hum.WalkSpeed = Value
         end
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
      local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
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

   local tool = char:FindFirstChildOfClass("Tool")

   if tool then

      if math.random(1,100) <= BaseBlockChance then
         tool:Activate()
         LastBlock = tick()
      end

   end

end)

------------------------------------------------
-- SMART AUTO PARRY
------------------------------------------------

local AutoParry = false
local BaseParryChance = 60
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

   local tool = char:FindFirstChildOfClass("Tool")

   if tool then

      if math.random(1,100) <= BaseParryChance then
         tool:Activate()
         LastParry = tick()
      end

   end

end)
