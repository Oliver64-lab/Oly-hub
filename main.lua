-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

------------------------------------------------
-- CHARACTER HANDLER
------------------------------------------------

local function getChar()
	return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

------------------------------------------------
-- RAYFIELD
------------------------------------------------

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
	Name = "Oly Hub | Optimized",
	LoadingTitle = "Oly Hub",
	LoadingSubtitle = "Superhero Update"
})

local Main = Window:CreateTab("Main")

------------------------------------------------
-- TRANSPARENCY
------------------------------------------------

local transparencyEnabled = false
local originalTransparency = {}

local function applyTransparency(char, state)

	for _, part in pairs(char:GetDescendants()) do
		if part:IsA("BasePart") then

			if state then
				if originalTransparency[part] == nil then
					originalTransparency[part] = part.Transparency
				end
				part.Transparency = 0.6
			else
				if originalTransparency[part] then
					part.Transparency = originalTransparency[part]
				end
			end

		end
	end

	char.DescendantAdded:Connect(function(part)
		if transparencyEnabled and part:IsA("BasePart") then
			part.Transparency = 0.6
		end
	end)
end

Main:CreateToggle({
	Name = "Transparency",
	Callback = function(v)
		transparencyEnabled = v
		applyTransparency(getChar(), v)
	end
})

LocalPlayer.CharacterAdded:Connect(function(char)
	if transparencyEnabled then
		task.wait(1)
		applyTransparency(char, true)
	end
end)

------------------------------------------------
-- FLY SUPERHERO
------------------------------------------------

local flying = false
local flySpeed = 60
local flyConn
local bodyVel

local idleAnimTrack
local moveAnimTrack

Main:CreateToggle({
	Name = "Fly (Superhero)",
	Callback = function(v)

		flying = v

		local char = getChar()
		local hrp = char:WaitForChild("HumanoidRootPart")
		local humanoid = char:WaitForChild("Humanoid")

		if v then
			bodyVel = Instance.new("BodyVelocity")
			bodyVel.MaxForce = Vector3.new(9e9,9e9,9e9)
			bodyVel.Parent = hrp

			local idleAnim = Instance.new("Animation")
			idleAnim.AnimationId = "rbxassetid://913402848"

			local moveAnim = Instance.new("Animation")
			moveAnim.AnimationId = "rbxassetid://507770239"

			idleAnimTrack = humanoid:LoadAnimation(idleAnim)
			moveAnimTrack = humanoid:LoadAnimation(moveAnim)

			idleAnimTrack:Play()

			flyConn = RunService.RenderStepped:Connect(function()

				local direction = Camera.CFrame.LookVector
				local moveDirection = humanoid.MoveDirection

				if moveDirection.Magnitude > 0 then
					bodyVel.Velocity = direction * flySpeed

					if not moveAnimTrack.IsPlaying then
						idleAnimTrack:Stop()
						moveAnimTrack:Play()
					end
				else
					bodyVel.Velocity = Vector3.new(0,0,0)

					if not idleAnimTrack.IsPlaying then
						moveAnimTrack:Stop()
						idleAnimTrack:Play()
					end
				end

			end)

		else
			if flyConn then flyConn:Disconnect() end
			if bodyVel then bodyVel:Destroy() end

			if idleAnimTrack then idleAnimTrack:Stop() end
			if moveAnimTrack then moveAnimTrack:Stop() end
		end

	end
})

Main:CreateSlider({
	Name = "Fly Speed",
	Range = {20,150},
	CurrentValue = 60,
	Callback = function(v)
		flySpeed = v
	end
})

------------------------------------------------
-- NOCLIP
------------------------------------------------

local noclip = false

RunService.Stepped:Connect(function()
	if noclip then
		for _, part in pairs(getChar():GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

Main:CreateToggle({
	Name = "Noclip",
	Callback = function(v)
		noclip = v
	end
})

------------------------------------------------
-- SPEED
------------------------------------------------

Main:CreateSlider({
	Name = "Speed",
	Range = {16,100},
	CurrentValue = 16,
	Callback = function(v)
		local hum = getChar():FindFirstChild("Humanoid")
		if hum then
			hum.WalkSpeed = v
		end
	end
})

------------------------------------------------
-- VIEW PLAYER
------------------------------------------------

Main:CreateInput({
	Name = "View Player",
	PlaceholderText = "Pseudo",
	Callback = function(name)

		for _,plr in pairs(Players:GetPlayers()) do
			if string.lower(plr.Name):find(string.lower(name)) then
				if plr.Character and plr.Character:FindFirstChild("Humanoid") then
					Camera.CameraSubject = plr.Character.Humanoid
				end
			end
		end

	end
})

------------------------------------------------
-- TP TOOL
------------------------------------------------

Main:CreateButton({
	Name = "TP Tool",
	Callback = function()

		local tool = Instance.new("Tool")
		tool.RequiresHandle = false
		tool.Name = "TP"

		tool.Activated:Connect(function()
			local mouse = LocalPlayer:GetMouse()
			getChar():MoveTo(mouse.Hit.Position)
		end)

		tool.Parent = LocalPlayer.Backpack

	end
})

------------------------------------------------
-- ESP
------------------------------------------------

local esp = false
local espCache = {}

Main:CreateToggle({
	Name = "ESP",
	Callback = function(v)

		esp = v

		if not v then
			for _, h in pairs(espCache) do
				if h then h:Destroy() end
			end
			espCache = {}
		end

	end
})

RunService.RenderStepped:Connect(function()

	if not esp then return end

	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character then

			if not espCache[plr] then
				local h = Instance.new("Highlight")
				h.FillColor = Color3.new(1,0,0)
				h.Parent = plr.Character

				espCache[plr] = h
			end

		end
	end

end)

------------------------------------------------
-- JUMPSCARE
------------------------------------------------

Main:CreateButton({
	Name = "Jumpscare",
	Callback = function()

		local gui = Instance.new("ScreenGui")
		gui.Parent = game.CoreGui

		local img = Instance.new("ImageLabel")
		img.Size = UDim2.new(1,0,1,0)
		img.BackgroundTransparency = 1
		img.Image = "rbxassetid://7072719335"
		img.Parent = gui

		task.wait(0.3)
		gui:Destroy()

	end
})
