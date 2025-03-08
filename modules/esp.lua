-- ESP functionality module

local ESP = {}
local Players, RunService, Utils, Cache, States
local ESPContainer

function ESP.Initialize(PlayersService, RunServiceService, UtilsModule, CacheModule, StatesModule)
    Players = PlayersService or game:GetService("Players")
    RunService = RunServiceService or game:GetService("RunService")
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
            
            -- Update position when part moves - with error handling
            pcall(function()
                if RunService and RunService.Heartbeat then
                    local connection
                    connection = RunService.Heartbeat:Connect(function()
                        pcall(function()
                            if part and part.Parent and outlinePart and outlinePart.Parent then
                                outlinePart.Position = part.Position
                                outlinePart.Orientation = part.Orientation
                            else
                                if outlinePart and outlinePart.Parent then
                                    outlinePart:Destroy()
                                end
                                if connection then
                                    connection:Disconnect()
                                end
                            end
                        end)
                    end)
                    
                    -- Store connection for cleanup
                    if Utils and typeof(Utils.AddTask) == "function" then
                        Utils.AddTask(identifier .. "_" .. part.Name, connection)
                    end
                else
                    -- Fallback for when RunService.Heartbeat is not available
                    spawn(function()
                        while outlinePart and outlinePart.Parent and part and part.Parent do
                            pcall(function()
                                outlinePart.Position = part.Position
                                outlinePart.Orientation = part.Orientation
                            end)
                            wait(0.03) -- Approximately 30 FPS
                        end
                        
                        if outlinePart and outlinePart.Parent then
                            outlinePart:Destroy()
                        end
                    end)
                end
            end)
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
        
        -- Add text label
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Size = UDim2.new(5, 0, 1, 0)
        billboardGui.Adornee = labelPart
        billboardGui.AlwaysOnTop = true
        billboardGui.Parent = labelPart
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = character.Name
        textLabel.TextColor3 = Color3.new(1, 1, 1)
        textLabel.TextStrokeTransparency = 0
        textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.TextScaled = true
        textLabel.Parent = billboardGui
        
        -- Update position to stay above character's head - with error handling
        pcall(function()
            if RunService and RunService.Heartbeat then
                local connection
                connection = RunService.Heartbeat:Connect(function()
                    pcall(function()
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
                            if connection then
                                connection:Disconnect()
                            end
                        end
                    end)
                end)
                
                -- Store connection for cleanup
                if Utils and typeof(Utils.AddTask) == "function" then
                    Utils.AddTask(identifier, connection)
                end
            else
                -- Fallback for when RunService.Heartbeat is not available
                spawn(function()
                    while labelPart and labelPart.Parent and character and character:FindFirstChild("Head") do
                        pcall(function()
                            local headPos = character.Head.Position
                            labelPart.Position = headPos + Vector3.new(0, 3, 0)
                            
                            -- Make label face the camera
                            local camera = workspace.CurrentCamera
                            if camera then
                                local cameraPos = camera.CFrame.Position
                                labelPart.CFrame = CFrame.new(labelPart.Position, Vector3.new(cameraPos.X, labelPart.Position.Y, cameraPos.Z))
                            end
                        end)
                        wait(0.03) -- Approximately 30 FPS
                    end
                    
                    if labelPart and labelPart.Parent then
                        labelPart:Destroy()
                    end
                end)
            end
        end)
    end)
end

function ESP.EnablePlayerESP()
    pcall(function()
        ESP.CreateContainer()
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= (Utils and Utils.GetPlayer and Utils.GetPlayer() or Players.LocalPlayer) then
                pcall(function()
                    if player.CharacterAdded then
                        local connection = player.CharacterAdded:Connect(function(character)
                            ESP.Outline(character)
                            ESP.LabelChar(character)
                        end)
                        
                        if Utils and typeof(Utils.AddTask) == "function" then
                            Utils.AddTask("ESP_" .. player.Name, connection)
                        end
                    end
                
                    if player.Character then
                        ESP.Outline(player.Character)
                        ESP.LabelChar(player.Character)
                    end
                end)
            end
        end

        pcall(function()
            if Players.PlayerAdded then
                local connection = Players.PlayerAdded:Connect(function(player)
                    pcall(function()
                        if player.CharacterAdded then
                            local charConnection = player.CharacterAdded:Connect(function(character)
                                ESP.Outline(character)
                                ESP.LabelChar(character)
                            end)
                            
                            if Utils and typeof(Utils.AddTask) == "function" then
                                Utils.AddTask("ESP_" .. player.Name, charConnection)
                            end
                        end
                    end)
                end)
                
                if Utils and typeof(Utils.AddTask) == "function" then
                    Utils.AddTask("ESP_PlayerAdded", connection)
                end
            end
        end)
    end)
end

function ESP.DisablePlayerESP()
    pcall(function()
        -- Disconnect all ESP-related tasks
        if Utils and typeof(Utils.DisconnectTask) == "function" then
            for taskName, _ in pairs(Utils.GetTasks and Utils.GetTasks() or {}) do
                if type(taskName) == "string" and taskName:sub(1, 4) == "ESP_" then
                    Utils.DisconnectTask(taskName)
                end
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

-- Alternative ESP implementation that doesn't rely on RunService.Heartbeat
function ESP.EnableSimpleESP()
    pcall(function()
        ESP.CreateContainer()
        
        -- Function to create simple ESP for a character
        local function createSimpleESP(character)
            if not character or not character:IsA("Model") then return end
            
            -- Create a unique identifier
            local identifier = character.Name .. "_simple_esp"
            
            -- Create a highlight
            local highlight = Instance.new("Highlight")
            highlight.Name = identifier
            highlight.FillColor = Color3.new(1, 0, 0)
            highlight.OutlineColor = Color3.new(1, 1, 1)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Adornee = character
            highlight.Parent = ESPContainer
            
            -- Create a billboard for name
            if character:FindFirstChild("Head") then
                local billboardGui = Instance.new("BillboardGui")
                billboardGui.Name = identifier .. "_name"
                billboardGui.Size = UDim2.new(0, 200, 0, 50)
                billboardGui.Adornee = character.Head
                billboardGui.AlwaysOnTop = true
                billboardGui.Parent = ESPContainer
                
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(1, 0, 1, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = character.Name
                nameLabel.TextColor3 = Color3.new(1, 1, 1)
                nameLabel.TextStrokeTransparency = 0
                nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                nameLabel.Font = Enum.Font.SourceSansBold
                nameLabel.TextScaled = true
                nameLabel.Parent = billboardGui
            end
        end
        
        -- Apply ESP to all players
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= (Utils and Utils.GetPlayer and Utils.GetPlayer() or Players.LocalPlayer) then
                if player.Character then
                    createSimpleESP(player.Character)
                end
                
                pcall(function()
                    if player.CharacterAdded then
                        player.CharacterAdded:Connect(function(character)
                            createSimpleESP(character)
                        end)
                    end
                end)
            end
        end
        
        -- Handle new players
        pcall(function()
            if Players.PlayerAdded then
                Players.PlayerAdded:Connect(function(player)
                    pcall(function()
                        if player.CharacterAdded then
                            player.CharacterAdded:Connect(function(character)
                                createSimpleESP(character)
                            end)
                        end
                    end)
                end)
            end
        end)
        
        -- Create a timer to refresh ESP (fallback for no RunService)
        spawn(function()
            while workspace:FindFirstChild("SMAX_ESP_Container") do
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= (Utils and Utils.GetPlayer and Utils.GetPlayer() or Players.LocalPlayer) then
                        if player.Character then
                            -- Check if ESP exists for this character
                            local hasESP = false
                            for _, child in pairs(ESPContainer:GetChildren()) do
                                if child.Name == player.Name .. "_simple_esp" then
                                    hasESP = true
                                    break
                                end
                            end
                            
                            -- Create ESP if it doesn't exist
                            if not hasESP then
                                createSimpleESP(player.Character)
                            end
                        end
                    end
                end
                wait(1) -- Update every second
            end
        end)
    end)
end

-- Add this function to the ESP module
ESP.GetRunService = function()
    return RunService
end

return ESP
