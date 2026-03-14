--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer

--// RAYFIELD
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Oly Hub",
   LoadingTitle = "Oly Hub",
   LoadingSubtitle = "by Oly",
   ConfigurationSaving = {
      Enabled = false
   }
})

--// TABS
local Main = Window:CreateTab("Main", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)
local Misc = Window:CreateTab("Misc", 4483362458)

--// WAIT SAFE
local visualGui = player:WaitForChild("PlayerGui"):WaitForChild("Visual")
local shootingElement = visualGui:WaitForChild("Shooting")

local Shoot = ReplicatedStorage:WaitForChild("Packages")
   :WaitForChild("Knit")
   :WaitForChild("Services")
   :WaitForChild("ControlService")
   :WaitForChild("RE")
   :WaitForChild("Shoot")

-------------------------------------------------
-- AUTO GREEN
-------------------------------------------------

local autoShoot = false
local shootPower = 0.8
local shootConnection

Main:CreateToggle({
   Name = "Auto Green",
   CurrentValue = false,

   Callback = function(Value)

      autoShoot = Value

      if Value then

         shootConnection = shootingElement:GetPropertyChangedSignal("Visible"):Connect(function()

            if autoShoot and shootingElement.Visible then
               task.wait(0.23)
               Shoot:FireServer(shootPower)
            end

         end)

      else

         if shootConnection then
            shootConnection:Disconnect()
            shootConnection = nil
         end

      end

   end
})

Main:CreateSlider({
   Name = "Shot Timing",
   Range = {50,100},
   Increment = 1,
   CurrentValue = 90,

   Callback = function(Value)
      shootPower = Value / 100
   end
})

-------------------------------------------------
-- BALL MAGNET
-------------------------------------------------

local magnetEnabled = false
local magnetDistance = 30

Main:CreateToggle({
   Name = "Ball Magnet",
   CurrentValue = false,

   Callback = function(Value)
      magnetEnabled = Value
   end
})

Main:CreateSlider({
   Name = "Magnet Distance",
   Range = {10,80},
   Increment = 1,
   CurrentValue = 30,

   Callback = function(Value)
      magnetDistance = Value
   end
})

RunService.Heartbeat:Connect(function()

   if not magnetEnabled then return end

   local char = player.Character
   if not char then return end

   local hrp = char:FindFirstChild("HumanoidRootPart")
   if not hrp then return end

   for _,v in pairs(workspace:GetDescendants()) do

      if v:IsA("BasePart") and v.Name == "Basketball" then

         if (hrp.Position - v.Position).Magnitude <= magnetDistance then

            firetouchinterest(hrp,v,0)
            firetouchinterest(hrp,v,1)

         end

      end

   end

end)

-------------------------------------------------
-- SPEED BOOST
-------------------------------------------------

local speedEnabled = false
local speedAmount = 20

PlayerTab:CreateToggle({
   Name = "Speed Boost",
   CurrentValue = false,

   Callback = function(Value)
      speedEnabled = Value
   end
})

PlayerTab:CreateSlider({
   Name = "Speed Amount",
   Range = {16,40},
   Increment = 1,
   CurrentValue = 20,

   Callback = function(Value)
      speedAmount = Value
   end
})

RunService.RenderStepped:Connect(function(dt)

   if not speedEnabled then return end

   local char = player.Character
   if not char then return end

   local root = char:FindFirstChild("HumanoidRootPart")
   local humanoid = char:FindFirstChildOfClass("Humanoid")

   if root and humanoid then

      local move = humanoid.MoveDirection

      if move.Magnitude > 0 then
         root.CFrame = root.CFrame + move.Unit * speedAmount * dt
      end

   end

end)

-------------------------------------------------
-- FOLLOW BALL CARRIER
-------------------------------------------------

local followEnabled = false

Main:CreateToggle({
   Name = "Follow Ball Carrier",
   CurrentValue = false,

   Callback = function(Value)
      followEnabled = Value
   end
})

RunService.Heartbeat:Connect(function()

   if not followEnabled then return end

   local char = player.Character
   if not char then return end

   local hrp = char:FindFirstChild("HumanoidRootPart")
   if not hrp then return end

   for _,plr in pairs(Players:GetPlayers()) do

      if plr ~= player and plr.Character then

         local tool = plr.Character:FindFirstChild("Basketball")

         if tool then

            local root = plr.Character:FindFirstChild("HumanoidRootPart")

            if root then
               hrp.CFrame = root.CFrame * CFrame.new(0,0,-3)
            end

         end

      end

   end

end)

-------------------------------------------------
-- SERVER
-------------------------------------------------

Misc:CreateButton({
   Name = "Rejoin Server",

   Callback = function()

      TeleportService:TeleportToPlaceInstance(
         game.PlaceId,
         game.JobId,
         player
      )

   end
})

-------------------------------------------------
-- NOTIFICATION
-------------------------------------------------

Rayfield:Notify({
   Title = "Oly Hub Loaded",
   Content = "Welcome to Oly Hub",
   Duration = 6
})
