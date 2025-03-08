-- Teleportation features module

local Teleport = {}
local Players, ReplicatedStorage, Utils, Cache, States

function Teleport.Initialize(PlayersService, ReplicatedStorageService, UtilsModule, CacheModule, StatesModule)
    Players = PlayersService
    ReplicatedStorage = ReplicatedStorageService
    Utils = UtilsModule
    Cache = CacheModule
    States = StatesModule
end

function Teleport.ToPosition(position)
    pcall(function()
        local character = Utils.GetCharacter()
        local humanoidRootPart = Utils.GetHumanoidRootPart()
        
        if character and humanoidRootPart then
            humanoidRootPart.CFrame = CFrame.new(position)
        end
    end)
end

function Teleport.ToPlayer(playerName)
    pcall(function()
        local targetPlayer = Players:FindFirstChild(playerName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local character = Utils.GetCharacter()
            local humanoidRootPart = Utils.GetHumanoidRootPart()
            
            if character and humanoidRootPart then
                humanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
            end
        end
    end)
end

-- Add more teleport functions as needed

return Teleport
