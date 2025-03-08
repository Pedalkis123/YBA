-- ESP functionality module

local ESP = {}
local Players, RunService, Utils, Cache, States
local ESPContainer

function ESP.Initialize(PlayersService, RunServiceService, UtilsModule, CacheModule, StatesModule)
    Players = PlayersService
    RunService = RunServiceService
    Utils = UtilsModule
    Cache = CacheModule
    States = StatesModule
    
    -- Create ESP container
    ESP.CreateContainer()
end

function ESP.CreateContainer()
    pcall(function()
        if workspace:FindFirstChild("SMAX_ESP_Container") then
            workspace.SMAX_ESP_Container:Destroy()
        end
        
        ESPContainer = Instance.new("Folder")
        ESPContainer.Name = "SMAX_ESP_Container"
        ESPContainer.Parent = workspace
    end)
end

function ESP.Outline(character)
    pcall(function()
        if not character or not character:IsA("Model") then return end
        if not workspace:FindFirstChild("SMAX_ESP_Container") then
            ESP.CreateContainer()
        end
        
        -- Create a unique identifier for this character
        local identifier = character.Name .. "_outline"
        
        -- Remove any existing outline for this character
        for _, child in pairs(ESPContainer:GetChildren()) do
            if child.Name == identifier then
                child:Destroy()
            end
        end
        
        -- Create a folder to hold outline parts
        local outlineFolder = Instance.new("Folder")
        outlineFolder.Name = identifier
        outlineFolder.Parent = ESPContainer
        
        -- Function to create outline part
        local function createOutlinePart(part)
            if not part:IsA("BasePart") then return end
            
            local outlinePart = Instance.new("Part")
            outlinePart.Size = part.Size + Vector3.new(0.1, 0.1, 0.1)
            outlinePart.Position = part.Position
            outlinePart.Orientation = part.Orientation
            outlinePart.Anchored = true
            outlinePart.CanCollide = false
            outlinePart.Transparency = 0.5
            outlinePart.Material = Enum.Material.Neon
            outlinePart.BrickColor = BrickColor.new("White")
            outlinePart.Parent = outlineFolder
            
            -- Create attachment to the original part
            local attachment = Instance.new("Attachment")
            attachment.Parent = outlinePart
            
            -- Update position when part moves
            Utils.AddTask(identifier .. "_" .. part.Name, RunService.Heartbeat:Connect(function()
                if part and part.Parent and outlinePart and outlinePart.Parent then
                    outlinePart.Position = part.Position
                    outlinePart.Orientation = part.Orientation
                else
                    if outlinePart and outlinePart.Parent then
                        outlinePart:Destroy()
                    end
                    Utils.DisconnectTask(identifier .. "_" .. part.Name)
                end
            end))
        end
        
        -- Create outline for each part in the character
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                createOutlinePart(part)
            end
        end
    end)
end

function ESP.LabelChar(character)
    pcall(function()
        if not character or not character:IsA("Model") then return end
        if not character:FindFirstChild("Head") then return end
        if not workspace:FindFirstChild("SMAX_ESP_Container") then
            ESP.CreateContainer()
        end
        
        -- Create a unique identifier for this character
        local identifier = character.Name .. "_label"
        
        -- Remove any existing label for this character
        for _, child in pairs(ESPContainer:GetChildren()) do
            if child.Name == identifier then
                child:Destroy()
            end
        end
        
        -- Create a part to serve as a label
        local labelPart = Instance.new("Part")
        labelPart.Name = identifier
        labelPart.Size = Vector3.new(2, 0.5, 0.1)
        labelPart.Transparency = 0.5
        labelPart.CanCollide = false
        labelPart.Anchored = true
        labelPart.Material = Enum.Material.Neon
        labelPart.BrickColor = BrickColor.new("White")
        labelPart.Parent = ESPContainer
        
        -- Update position to stay above character's head
        Utils.AddTask(identifier, RunService.Heartbeat:Connect(function()
            if character and character:FindFirstChild("Head") and labelPart and labelPart.Parent then
                local headPos = character.Head.Position
                labelPart.Position = headPos + Vector3.new(0, 3, 0)
                
                -- Make label face the camera
                local camera = workspace.CurrentCamera
                if camera then
                    local cameraPos = camera.CFrame.Position
                    labelPart.CFrame = CFrame.new(labelPart.Position, Vector3.new(cameraPos.X, labelPart.Position.Y, cameraPos.Z))
                end
            else
                if labelPart and labelPart.Parent then
                    labelPart:Destroy()
                end
                Utils.DisconnectTask(identifier)
            end
        end))
    end)
end

function ESP.EnablePlayerESP()
    pcall(function()
        ESP.CreateContainer()
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Utils.GetPlayer() then
                Utils.AddTask("ESP_" .. player.Name, player.CharacterAdded:Connect(function(character)
                    ESP.Outline(character)
                    ESP.LabelChar(character)
                end))
            
                if player.Character then
                    ESP.Outline(player.Character)
                    ESP.LabelChar(player.Character)
                end
            end
        end

        Utils.AddTask("ESP_PlayerAdded", Players.PlayerAdded:Connect(function(player)
            Utils.AddTask("ESP_" .. player.Name, player.CharacterAdded:Connect(function(character)
                ESP.Outline(character)
                ESP.LabelChar(character)
            end))
        end))
    end)
end

function ESP.DisablePlayerESP()
    pcall(function()
        -- Disconnect all ESP-related tasks
        for taskName, _ in pairs(Tasks) do
            if taskName:sub(1, 4) == "ESP_" then
                Utils.DisconnectTask(taskName)
            end
        end
        
        -- Clean up ESP container
        if workspace:FindFirstChild("SMAX_ESP_Container") then
            workspace.SMAX_ESP_Container:Destroy()
        end
    end)
end

function ESP.Cleanup()
    ESP.DisablePlayerESP()
    
    pcall(function()
        if workspace:FindFirstChild("SMAX_ESP_Container") then
            workspace.SMAX_ESP_Container:Destroy()
        end
    end)
end

return ESP
