-- Oly Hub - Saber Legends

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer

-- UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Oly Hub - Saber Legends",
   LoadingTitle = "Oly Hub",
   LoadingSubtitle = "by Oly"
})

local Combat = Window:CreateTab("Combat")
local PlayerTab = Window:CreateTab("Player")
local Teleport = Window:CreateTab("Teleport")

------------------------------------------------
-- SPEED
------------------------------------------------

PlayerTab:CreateSlider({
   Name = "Speed",
   Range = {16,100},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
      player.Character.Humanoid.WalkSpeed = Value
   end
})

------------------------------------------------
-- INFINITE JUMP
------------------------------------------------

_G.InfJump = false

PlayerTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value)
      _G.InfJump = Value
   end
})

UIS.JumpRequest:Connect(function()
   if _G.InfJump then
      player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
   end
end)

------------------------------------------------
-- AUTO ATTACK
------------------------------------------------

_G.AutoAttack = false

Combat:CreateToggle({
   Name = "Auto Attack",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoAttack = Value
   end
})

RunService.RenderStepped:Connect(function()

   if _G.AutoAttack then

      local tool = player.Character:FindFirstChildOfClass("Tool")

      if tool then
         tool:Activate()
      end

   end

end)

------------------------------------------------
-- PERFECT BLOCK
------------------------------------------------

local PerfectBlock = false
local BlockChance = 50
local BlockDistance = 12

Combat:CreateToggle({
   Name = "Perfect Block",
   CurrentValue = false,
   Callback = function(Value)
      PerfectBlock = Value
   end
})

Combat:CreateSlider({
   Name = "Block Chance",
   Range = {1,100},
   Increment = 1,
   CurrentValue = 50,
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

         local enemyRoot = enemy.Character:FindFirstChild("HumanoidRootPart")

         if enemyRoot then

            local dist = (hrp.Position - enemyRoot.Position).Magnitude

            if dist <= BlockDistance then

               if math.random(1,100) <= BlockChance then

                  VirtualInputManager:SendKeyEvent(true,"F",false,game)
                  task.wait(0.1)
                  VirtualInputManager:SendKeyEvent(false,"F",false,game)

               end

            end

         end

      end

   end

end)

------------------------------------------------
-- AUTO PARRY (SMART)
------------------------------------------------

local AutoParry = false
local ParryDistance = 10
local ParryDelay = 0.08

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

         local hum = enemy.Character:FindFirstChildOfClass("Humanoid")
         local root = enemy.Character:FindFirstChild("HumanoidRootPart")

         if hum and root then

            local dist = (hrp.Position - root.Position).Magnitude

            if dist <= ParryDistance then

               for _,track in pairs(hum:GetPlayingAnimationTracks()) do

                  if track.Name:lower():find("attack") or track.Name:lower():find("slash") then

                     task.wait(ParryDelay)

                     VirtualInputManager:SendKeyEvent(true,"F",false,game)
                     task.wait(0.05)
                     VirtualInputManager:SendKeyEvent(false,"F",false,game)

                  end

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
local MagnetDistance = 20

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

------------------------------------------------
-- DASH TO ENEMY
------------------------------------------------

Combat:CreateButton({
   Name = "Dash To Closest Enemy",
   Callback = function()

      local closest
      local dist = math.huge

      for _,v in pairs(Players:GetPlayers()) do

         if v ~= player and v.Character then

            local root = v.Character:FindFirstChild("HumanoidRootPart")

            if root then

               local mag = (player.Character.HumanoidRootPart.Position - root.Position).Magnitude

               if mag < dist then
                  dist = mag
                  closest = root
               end

            end

         end

      end

      if closest then
         player.Character.HumanoidRootPart.CFrame = closest.CFrame * CFrame.new(0,0,-3)
      end

   end
})

------------------------------------------------
-- NOCLIP
------------------------------------------------

local Noclip = false

PlayerTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(Value)
      Noclip = Value
   end
})

RunService.Stepped:Connect(function()

   if Noclip and player.Character then

      for _,v in pairs(player.Character:GetDescendants()) do

         if v:IsA("BasePart") then
            v.CanCollide = false
         end

      end

   end

end)

------------------------------------------------
-- TELEPORT TO PLAYER
------------------------------------------------

local list = {}

for _,v in pairs(Players:GetPlayers()) do
   table.insert(list,v.Name)
end

Teleport:CreateDropdown({
   Name = "Teleport To Player",
   Options = list,
   CurrentOption = list[1],

   Callback = function(Value)

      local target = Players:FindFirstChild(Value)

      if target and target.Character then

         player.Character.HumanoidRootPart.CFrame =
         target.Character.HumanoidRootPart.CFrame

      end

   end
})

------------------------------------------------
-- RESET
------------------------------------------------

PlayerTab:CreateButton({
   Name = "Reset Character",
   Callback = function()
      player.Character.Humanoid.Health = 0
   end
})
