-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local Char = player.Character or player.CharacterAdded:Wait()
local Humanoid = Char:WaitForChild("Humanoid")
local Hrp = Char:WaitForChild("HumanoidRootPart")

-- Repo Rayfield
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

-- Variables toggles
local autoBlockEnabled = false
local perfectBlockPercent = 80
local parryChancePercent = 50

-- UI
local Window = Library:CreateWindow({
    Title = "Oly Hub - Saber Legends",
    Footer = "by Oliver64-lab",
    NotifySide = "Right",
    ShowCustomCursor = false
})

local Tabs = {
    Combat = Window:AddTab("Combat", "sword"),
    Player = Window:AddTab("Player", "user"),
    UI = Window:AddTab("UI Settings", "monitor"),
}

local CombatGroup = Tabs.Combat:AddLeftGroupbox("Combat Enhancements", "sword")
local PlayerGroup = Tabs.Player:AddLeftGroupbox("Player", "zap")

-- Perfect Block Slider
CombatGroup:AddSlider("PerfectBlock", {
    Text = "Perfect Block %",
    Default = 80,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Tooltip = "Chance to perform a perfect block",
    Callback = function(value)
        perfectBlockPercent = value
    end
})

-- Parry Chance Slider
CombatGroup:AddSlider("ParryChance", {
    Text = "Parry Chance %",
    Default = 50,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Tooltip = "Chance to parry incoming attacks",
    Callback = function(value)
        parryChancePercent = value
    end
})

-- Auto Block Toggle
CombatGroup:AddToggle("AutoBlock", {
    Text = "Auto Block",
    Default = false,
    Tooltip = "Automatically block attacks",
    Callback = function(value)
        autoBlockEnabled = value
    end
})

-- Fonction Auto Block
RunService.Heartbeat:Connect(function()
    if autoBlockEnabled then
        -- Exemple simple de block automatique basé sur % chance
        if math.random(1,100) <= perfectBlockPercent then
            -- Fire block event ou key press ici
            local VirtualInputManager = game:GetService("VirtualInputManager")
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
        end

        -- Parry Chance
        if math.random(1,100) <= parryChancePercent then
            -- Fire parry event ici
            local VirtualInputManager = game:GetService("VirtualInputManager")
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        end
    end
end)

-- UI Settings
local MenuGroup = Tabs.UI:AddLeftGroupbox("Menu Options", "wrench")
MenuGroup:AddToggle("ShowCustomCursor", {Text = "Custom Cursor", Default = false, Callback = function(Value)
    Library.ShowCustomCursor = Value
end})
MenuGroup:AddDropdown("NotificationSide", {Values = {"Left", "Right"}, Default = "Right", Text = "Notification Side", Callback = function(Value)
    Library:SetNotifySide(Value)
end})
MenuGroup:AddButton("Unload", function()
    Library:Unload()
end)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
ThemeManager:SetFolder("OlyHub")
SaveManager:SetFolder("OlyHub/configs")
SaveManager:BuildConfigSection(Tabs.UI)
ThemeManager:ApplyToTab(Tabs.UI)
SaveManager:LoadAutoloadConfig()
