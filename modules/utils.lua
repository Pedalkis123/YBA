-- Utility functions module

local Utils = {}
local Players, ReplicatedStorage, Cache, States
local Tasks = {}

function Utils.Initialize(PlayersService, ReplicatedStorageService, CacheModule, StatesModule)
    Players = PlayersService
    ReplicatedStorage = ReplicatedStorageService
    Cache = CacheModule
    States = StatesModule
end

function Utils.GetPlayer()
    return Players.LocalPlayer
end

function Utils.GetCharacter()
    local player = Utils.GetPlayer()
    if player then
        return player.Character
    end
    return nil
end

function Utils.GetHumanoidRootPart()
    local character = Utils.GetCharacter()
    if character then
        return character:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

function Utils.GetHumanoid()
    local character = Utils.GetCharacter()
    if character then
        return character:FindFirstChild("Humanoid")
    end
    return nil
end

function Utils.AddTask(name, task)
    if Tasks[name] then
        pcall(function()
            if typeof(Tasks[name]) == "RBXScriptConnection" then
                Tasks[name]:Disconnect()
            end
        end)
    end
    Tasks[name] = task
end

function Utils.DisconnectTask(name)
    if Tasks[name] then
        pcall(function()
            if typeof(Tasks[name]) == "RBXScriptConnection" then
                Tasks[name]:Disconnect()
            end
        end)
        Tasks[name] = nil
    end
end

function Utils.CleanupAllTasks()
    for name, _ in pairs(Tasks) do
        Utils.DisconnectTask(name)
    end
end

function Utils.SendWebhook(url, data)
    pcall(function()
        if url and data then
            local HttpService = game:GetService("HttpService")
            local request = (syn and syn.request) or (http and http.request) or http_request or request
            
            if request then
                request({
                    Url = url,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = HttpService:JSONEncode(data)
                })
            end
        end
    end)
end

function Utils.HasItem(itemName)
    if not itemName then return false end
    
    local player = Utils.GetPlayer()
    if not player then return false end
    
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return false end
    
    for _, item in pairs(backpack:GetChildren()) do
        if item.Name == itemName then
            return true
        end
    end
    
    local character = Utils.GetCharacter()
    if not character then return false end
    
    for _, item in pairs(character:GetChildren()) do
        if item.Name == itemName then
            return true
        end
    end
    
    return false
end

function Utils.HasStand(standName)
    if not standName then return false end
    
    local player = Utils.GetPlayer()
    if not player then return false end
    
    local stand = player:FindFirstChild("Stand")
    if not stand or not stand.Value then return false end
    
    return stand.Value == standName
end

function Utils.HasShiny()
    local player = Utils.GetPlayer()
    if not player then return false end
    
    local stand = player:FindFirstChild("Stand")
    if not stand or not stand.Value then return false end
    
    local shiny = player:FindFirstChild("StandShiny")
    if not shiny then return false end
    
    return shiny.Value
end

-- Add more utility functions as needed

return Utils
