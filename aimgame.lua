-- Oly Hub | Mobile + PC Aim Assist

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

------------------------------------------------
-- Rayfield UI
------------------------------------------------

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
	Name = "Oly Hub | Aim System",
	LoadingTitle = "Oly Hub",
	LoadingSubtitle = "Mobile + PC"
})

local Combat = Window:CreateTab("Combat")

------------------------------------------------
-- Variables
------------------------------------------------

local AimAssist = false
local SilentAim = false
local ESP = false
local AimStrength = 0.03
local FOV = 150

------------------------------------------------
-- UI
------------------------------------------------

Combat:CreateToggle({
	Name = "Aim Assist",
	CurrentValue = false,
	Callback = function(v)
		AimAssist = v
	end
})

Combat:CreateToggle({
	Name = "Silent Aim",
	CurrentValue = false,
	Callback = function(v)
		SilentAim = v
	end
})

Combat:CreateToggle({
	Name = "ESP",
	CurrentValue = false,
	Callback = function(v)
		ESP = v
	end
})

Combat:CreateSlider({
	Name = "Aim Strength",
	Range = {1,20},
	CurrentValue = 3,
	Callback = function(v)
		AimStrength = v/100
	end
})

Combat:CreateSlider({
	Name = "Aim FOV",
	Range = {50,400},
	CurrentValue = 150,
	Callback = function(v)
		FOV = v
	end
})

------------------------------------------------
-- Target Finder
------------------------------------------------

local function GetClosestTarget()

	local closest
	local shortest = FOV

	for _,plr in pairs(Players:GetPlayers()) do

		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then

			local pos, visible = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)

			if visible then

				local dist = (Vector2.new(pos.X,pos.Y) -
				Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)).Magnitude

				if dist < shortest then
					shortest = dist
					closest = plr
				end

			end

		end

	end

	return closest
end

------------------------------------------------
-- Detect input (mobile + pc)
------------------------------------------------

local aiming = false

UIS.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		aiming = true
	end

	if input.UserInputType == Enum.UserInputType.Touch then
		aiming = true
	end

end)

UIS.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		aiming = false
	end

	if input.UserInputType == Enum.UserInputType.Touch then
		aiming = false
	end

end)

------------------------------------------------
-- Aim Assist
------------------------------------------------

RunService.RenderStepped:Connect(function()

	if AimAssist and aiming then

		local target = GetClosestTarget()

		if target and target.Character then

			local part = target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("HumanoidRootPart")

			if part then

				local direction = (part.Position - Camera.CFrame.Position).Unit
				local targetCF = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + direction)

				Camera.CFrame = Camera.CFrame:Lerp(targetCF, AimStrength)

			end

		end

	end

end)

------------------------------------------------
-- Silent Aim
------------------------------------------------

local old
old = hookmetamethod(game,"__namecall",function(self,...)

	local args = {...}
	local method = getnamecallmethod()

	if SilentAim and tostring(method) == "Raycast" then

		local target = GetClosestTarget()

		if target and target.Character and target.Character:FindFirstChild("Head") then

			args[2] = (target.Character.Head.Position - args[1]).Unit * 1000
			return old(self,unpack(args))

		end

	end

	return old(self,...)

end)

------------------------------------------------
-- ESP
------------------------------------------------

RunService.RenderStepped:Connect(function()

	if ESP then

		for _,plr in pairs(Players:GetPlayers()) do

			if plr ~= LocalPlayer and plr.Character then

				if not plr.Character:FindFirstChild("OlyESP") then

					local h = Instance.new("Highlight")
					h.Name = "OlyESP"
					h.FillColor = Color3.fromRGB(255,0,0)
					h.OutlineColor = Color3.fromRGB(255,255,255)
					h.Parent = plr.Character

				end

			end

		end

	end

end)
