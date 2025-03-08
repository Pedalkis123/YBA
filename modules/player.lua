-- Player modifications module

local PlayerMods = {}
local Players, RunService, Utils, Cache, States

function PlayerMods.Initialize(PlayersService, RunServiceService, UtilsModule, CacheModule, StatesModule)
    Players = PlayersService
    RunService = RunServiceService
    Utils = UtilsModule
    Cache = CacheModule
    States = StatesModule
    
    -- Setup player modifications
    PlayerMods.SetupSpeedJumpHack()
    PlayerMods.SetupAntiTimestop()
    PlayerMods.SetupAntiReset()
    PlayerMods.SetupAntiTeleport()
end

function PlayerMods.SetupSpeedJumpHack()
    -- Cache original values when character loads
    Utils.AddTask("CharacterAdded", Utils.GetPlayer().CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        Cache.Speed = humanoid.WalkSpeed
        Cache.Jump = humanoid.JumpPower
    end))
    
    -- Monitor and set WalkSpeed and JumpPower
    Utils.AddTask("SpeedJumpHack", RunService.Heartbeat:Connect(function()
        local humanoid = Utils.GetHumanoid()
        if humanoid then
            if States.Speed then
                humanoid.WalkSpeed = 100
            else
                humanoid.WalkSpeed = Cache.Speed
            end
            
            if States.Jump then
                humanoid.JumpPower = 100
            else
                humanoid.JumpPower = Cache.Jump
            end
        end
    end))
end

function PlayerMods.SetupAntiTimestop()
    Utils.AddTask("AntiTimestop", RunService.Heartbeat:Connect(function()
        if States.AntiTimestop then
            -- Check and set lighting to prevent vampire burning
            local lighting = game:GetService("Lighting")
            if lighting.ClockTime < 6 or lighting.ClockTime > 18 then
                lighting.ClockTime = 12
            end
        end
    end))
end

function PlayerMods.SetupAntiReset()
    Utils.AddTask("AntiReset", RunService.Heartbeat:Connect(function()
        if States.AntiReset then
            -- Replace reset button functionality
            local player = Utils.GetPlayer()
            if player and player.PlayerGui then
                for _, gui in pairs(player.PlayerGui:GetDescendants()) do
                    if gui:IsA("TextButton") and (gui.Text:lower():find("reset") or gui.Name:lower():find("reset")) then
                        if gui.Activated then
                            for _, connection in pairs(getconnections(gui.Activated)) do
                                connection:Disable()
                            end
                        end
                        if gui.MouseButton1Click then
                            for _, connection in pairs(getconnections(gui.MouseButton1Click)) do
                                connection:Disable()
                            end
                        end
                    end
                end
            end
        end
    end))
end

function PlayerMods.SetupAntiTeleport()
    Utils.AddTask("AntiTeleport", RunService.Heartbeat:Connect(function()
        if States.AntiTeleport then
            -- Monitor and disable teleport-related remote events
            local character = Utils.GetCharacter()
            if character then
                for _, descendant in pairs(character:GetDescendants()) do
                    if descendant:IsA("RemoteEvent") and 
                       (descendant.Name:lower():find("teleport") or 
                        descendant.Name:lower():find("tp")) then
                        descendant.Enabled = false
                    end
                end
            end
        end
    end))
end

function PlayerMods.Cleanup()
    Utils.DisconnectTask("CharacterAdded")
    Utils.DisconnectTask("SpeedJumpHack")
    Utils.DisconnectTask("AntiTimestop")
    Utils.DisconnectTask("AntiReset")
    Utils.DisconnectTask("AntiTeleport")
end

return PlayerMods
