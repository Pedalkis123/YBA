-- SMAX YBA Script
-- Main entry point that loads all modules

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- Initialize error handling
local success, errorMsg = pcall(function()
    -- Load modules
    local Cache = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pedalkis123/YBA/main/modules/cache.lua"))()
    local States = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pedalkis123/YBA/main/modules/states.lua"))()
    local Utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pedalkis123/YBA/main/modules/utils.lua"))()
    local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pedalkis123/YBA/main/modules/esp.lua"))()
    local Combat = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pedalkis123/YBA/main/modules/combat.lua"))()
    local Farming = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pedalkis123/YBA/main/modules/farming.lua"))()
    local Teleport = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pedalkis123/YBA/main/modules/teleport.lua"))()
    local PlayerMods = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pedalkis123/YBA/main/modules/player.lua"))()
    local Misc = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pedalkis123/YBA/main/modules/misc.lua"))()
    
    -- Initialize UI
    local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pedalkis123/YBA/main/ui/init.lua"))()
    
    -- Share modules globally
    getgenv().SMAX = {
        Cache = Cache,
        States = States,
        Utils = Utils,
        ESP = ESP,
        Combat = Combat,
        Farming = Farming,
        Teleport = Teleport,
        PlayerMods = PlayerMods,
        Misc = Misc,
        UI = UI
    }
    
    -- Initialize modules with dependencies
    Utils.Initialize(Players, ReplicatedStorage, Cache, States)
    ESP.Initialize(Players, RunService, Utils, Cache, States)
    Combat.Initialize(Players, ReplicatedStorage, Utils, Cache, States)
    Farming.Initialize(Players, ReplicatedStorage, Utils, Cache, States)
    Teleport.Initialize(Players, ReplicatedStorage, Utils, Cache, States)
    PlayerMods.Initialize(Players, RunService, Utils, Cache, States)
    Misc.Initialize(Players, ReplicatedStorage, Utils, Cache, States)
    
    -- Initialize UI with all modules
    UI.Initialize(SMAX)
    
    -- Load saved configuration
    pcall(function()
        if UI.SaveManager and type(UI.SaveManager.LoadAutoloadConfig) == "function" then
            UI.SaveManager:LoadAutoloadConfig()
        end
    end)
    
    -- Setup cleanup
    UI.Library:OnUnload(function()
        ESP.Cleanup()
        PlayerMods.Cleanup()
        Utils.CleanupAllTasks()
        
        pcall(function()
            if workspace:FindFirstChild("AnticheatBypass") then
                workspace.AnticheatBypass:Destroy()
            end
        end)
        
        pcall(function()
            if workspace:FindFirstChild("DashAnims") then
                workspace.DashAnims:Destroy()
            end
        end)
    end)
end)

if not success then
    warn("Error during script initialization: " .. tostring(errorMsg))
end
