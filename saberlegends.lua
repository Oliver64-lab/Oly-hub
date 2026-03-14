-- Oly Hub
-- Saber Legends
-- Combat Edition

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

------------------------------------------------
-- ORION UI
------------------------------------------------

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
	Name = "Oly Hub | Saber Legends",
	HidePremium = false,
	SaveConfig = false
})

local Combat = Window:MakeTab({
	Name = "Combat",
	Icon = "rbxassetid://4483345998"
})

------------------------------------------------
-- VARIABLES
------------------------------------------------

local AutoSwing = false
local AutoBlock = false
local PerfectBlock = false
local InfStamina = false

------------------------------------------------
-- AUTO SWING
------------------------------------------------

Combat:AddToggle({
	Name = "Auto Swing",
	Default = false,
	Callback = function(Value)
		AutoSwing = Value
	end
})

RunService.RenderStepped:Connect(function()

	if not AutoSwing then return end

	local char = player.Character
	if not char then return end

	local tool = char:FindFirstChildOfClass("Tool")

	if tool then
		tool:Activate()
	end

end)

------------------------------------------------
-- AUTO BLOCK
------------------------------------------------

Combat:AddToggle({
	Name = "Auto Block",
	Default = false,
	Callback = function(Value)
		AutoBlock = Value
	end
})

RunService.Heartbeat:Connect(function()

	if not AutoBlock then return end

	local char = player.Character
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")

	for _,enemy in pairs(Players:GetPlayers()) do

		if enemy ~= player and enemy.Character then

			local root = enemy.Character:FindFirstChild("HumanoidRootPart")

			if root then

				local dist = (hrp.Position - root.Position).Magnitude

				if dist < 10 then

					local tool = char:FindFirstChildOfClass("Tool")

					if tool then
						tool:Activate()
					end

				end

			end

		end

	end

end)

------------------------------------------------
-- PERFECT BLOCK
------------------------------------------------

Combat:AddToggle({
	Name = "Perfect Block",
	Default = false,
	Callback = function(Value)
		PerfectBlock = Value
	end
})

RunService.Heartbeat:Connect(function()

	if not PerfectBlock then return end

	local char = player.Character
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")

	for _,enemy in pairs(Players:GetPlayers()) do

		if enemy ~= player and enemy.Character then

			local hum = enemy.Character:FindFirstChildOfClass("Humanoid")

			if hum then

				for _,track in pairs(hum:GetPlayingAnimationTracks()) do

					if track.IsPlaying then

						task.wait(0.1)

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
-- INFINITE STAMINA
------------------------------------------------

Combat:AddToggle({
	Name = "Infinite Stamina",
	Default = false,
	Callback = function(Value)
		InfStamina = Value
	end
})

RunService.Heartbeat:Connect(function()

	if not InfStamina then return end

	local char = player.Character
	if not char then return end

	local stamina = char:FindFirstChild("Stamina")

	if stamina then
		stamina.Value = stamina.MaxValue
	end

end)

------------------------------------------------

OrionLib:Init()
