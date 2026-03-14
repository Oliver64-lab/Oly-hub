-- Oly Hub | Stable Aim Assist

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

------------------------------------------------
-- UI
------------------------------------------------

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
	Name = "Oly Hub | Shooter",
	LoadingTitle = "Oly Hub",
	LoadingSubtitle = "Aim System"
})

local Combat = Window:CreateTab("Combat")

------------------------------------------------
-- Variables
------------------------------------------------

local AimAssist = false
local ESP = false
local AimStrength = 0.12
local FOV = 200

------------------------------------------------
-- Aim Assist Toggle
------------------------------------------------

Combat:CreateToggle({
	Name = "Aim Assist",
	CurrentValue = false,
	Callback = function(v)
		AimAssist = v
	end
})

Combat:CreateSlider({
	Name = "Aim Strength",
	Range = {5,40},
	CurrentValue = 12,
	Callback = function(v)
		AimStrength = v/100
	end
})

Combat:CreateSlider({
	Name = "Aim FOV",
	Range = {50,400},
	CurrentValue = 200,
	Callback = function(v)
		FOV = v
	end
})

------------------------------------------------
-- POV / Camera FOV
------------------------------------------------

Combat:CreateSlider({
	Name = "POV (Camera FOV)",
	Range = {70,120},
	CurrentValue = 80,
	Callback = function(v)
		Camera.FieldOfView = v
	end
})

------------------------------------------------
-- ESP
------------------------------------------------

Combat:CreateToggle({
	Name = "ESP",
	CurrentValue = false,
	Callback = function(v)
		ESP = v
	end
})

------------------------------------------------
-- Target finder
------------------------------------------------

local function GetClosest()

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
-- Input detection (mobile + pc)
------------------------------------------------

local aiming = false

UIS.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		aiming = true
	end

	if input.UserInputType == Enum.UserInputType.Touch then
		aiming = true
	end

end)

UIS.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

		local target = GetClosest()

		if target and target.Character then

			local head = target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("HumanoidRootPart")

			if head then

				local direction = (head.Position - Camera.CFrame.Position).Unit
				local newCF = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + direction)

				Camera.CFrame = Camera.CFrame:Lerp(newCF, AimStrength)

			end

		end

	end

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
