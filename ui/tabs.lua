-- UI tabs module

local Tabs = {}
local Library, SMAX

function Tabs.Initialize(LibraryModule, SMAXModule)
    Library = LibraryModule
    SMAX = SMAXModule
    
    -- Create window
    local Window = Library:CreateWindow({
        Title = "SMAX YBA",
        Center = true,
        AutoShow = true
    })
    
    -- Create tabs
    Tabs.MainTab = Window:AddTab("Main")
    Tabs.CombatTab = Window:AddTab("Combat")
    Tabs.FarmingTab = Window:AddTab("Farming")
    Tabs.TeleportTab = Window:AddTab("Teleport")
    Tabs.MiscTab = Window:AddTab("Misc")
    Tabs.SettingsTab = Window:AddTab("Settings")
    
    -- Setup tab contents
    Tabs.SetupMainTab()
    Tabs.SetupCombatTab()
    Tabs.SetupFarmingTab()
    Tabs.SetupTeleportTab()
    Tabs.SetupMiscTab()
    
    return Tabs
end

function Tabs.SetupMainTab()
    local MainBox = Tabs.MainTab:AddLeftGroupbox("Main Features")
    
    MainBox:AddToggle("Speed", {
        Text = "Speed Hack",
        Default = false,
        Tooltip = "Increases your movement speed",
        Callback = function(Value)
            SMAX.States.Speed = Value
        end
    })
    
    MainBox:AddToggle("Jump", {
        Text = "Jump Hack",
        Default = false,
        Tooltip = "Increases your jump power",
        Callback = function(Value)
            SMAX.States.Jump = Value
        end
    })
    
    MainBox:AddToggle("AntiTimestop", {
        Text = "Anti Timestop",
        Default = false,
        Tooltip = "Prevents timestop effects",
        Callback = function(Value)
            SMAX.States.AntiTimestop = Value
        end
    })
    
    MainBox:AddToggle("AntiReset", {
        Text = "Anti Reset",
        Default = false,
        Tooltip = "Prevents character reset",
        Callback = function(Value)
            SMAX.States.AntiReset = Value
        end
    })
    
    MainBox:AddToggle("AntiTeleport", {
        Text = "Anti Teleport",
        Default = false,
        Tooltip = "Prevents forced teleportation",
        Callback = function(Value)
            SMAX.States.AntiTeleport = Value
        end
    })
end

function Tabs.SetupCombatTab()
    local CombatBox = Tabs.CombatTab:AddLeftGroupbox("Combat Features")
    
    CombatBox:AddToggle("PlayerESP", {
        Text = "Player ESP",
        Default = false,
        Tooltip = "Shows ESP for players",
        Callback = function(Value)
            if Value then
                SMAX.ESP.EnablePlayerESP()
            else
                SMAX.ESP.DisablePlayerESP()
            end
        end
    })
    
    -- Add more combat features
end

function Tabs.SetupFarmingTab()
    local FarmingBox = Tabs.FarmingTab:AddLeftGroupbox("Item Farming")
    
    FarmingBox:AddToggle("ItemFarm", {
        Text = "Auto Collect Items",
        Default = false,
        Tooltip = "Automatically collects nearby items",
        Callback = function(Value)
            SMAX.States.ItemFarm = Value
        end
    })
    
    FarmingBox:AddToggle("ItemNotify", {
        Text = "Item Notifications",
        Default = false,
        Tooltip = "Notifies when items spawn",
        Callback = function(Value)
            SMAX.States.ItemNotify = Value
        end
    })
    
    local QuestBox = Tabs.FarmingTab:AddRightGroupbox("Quest Farming")
    
    QuestBox:AddToggle("QuestFarm", {
        Text = "Auto Quest",
        Default = false,
        Tooltip = "Automatically completes quests",
        Callback = function(Value)
            SMAX.States.QuestFarm = Value
        end
    })
    
    -- Add more farming features
end

function Tabs.SetupTeleportTab()
    local TeleportBox = Tabs.TeleportTab:AddLeftGroupbox("Teleport Locations")
    
    TeleportBox:AddButton("Main Game", function()
        SMAX.Teleport.ToPosition(Vector3.new(0, 0, 0)) -- Replace with actual coordinates
    end)
    
    TeleportBox:AddButton("Italy", function()
        SMAX.Teleport.ToPosition(Vector3.new(100, 0, 100)) -- Replace with actual coordinates
    end)
    
    TeleportBox:AddButton("Morioh", function()
        SMAX.Teleport.ToPosition(Vector3.new(200, 0, 200)) -- Replace with actual coordinates
    end)
    
    TeleportBox:AddButton("Devil's Palm", function()
        SMAX.Teleport.ToPosition(Vector3.new(300, 0, 300)) -- Replace with actual coordinates
    end)
    
    local PlayerTeleportBox = Tabs.TeleportTab:AddRightGroupbox("Player Teleport")
    
    local PlayerDropdown = PlayerTeleportBox:AddDropdown("PlayerToTeleport", {
        Text = "Select Player",
        Values = {},
        Default = 1,
    })
    
    -- Update player list
    local function UpdatePlayerList()
        local playerNames = {}
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player ~= game:GetService("Players").LocalPlayer then
                table.insert(playerNames, player.Name)
            end
        end
        PlayerDropdown:SetValues(playerNames)
    end
    
    UpdatePlayerList()
    
    -- Refresh player list button
    PlayerTeleportBox:AddButton("Refresh Player List", function()
        UpdatePlayerList()
    end)
    
    -- Teleport to selected player button
    PlayerTeleportBox:AddButton("Teleport to Player", function()
        local selectedPlayer = PlayerDropdown.Value
        if selectedPlayer then
            SMAX.Teleport.ToPlayer(selectedPlayer)
        end
    end)
end

function Tabs.SetupMiscTab()
    local MiscBox = Tabs.MiscTab:AddLeftGroupbox("Miscellaneous")
    
    MiscBox:AddToggle("StandFarm", {
        Text = "Auto Stand Farm",
        Default = false,
        Tooltip = "Automatically farms for stands",
        Callback = function(Value)
            SMAX.States.StandFarm = Value
        end
    })
    
    MiscBox:AddToggle("ShinySniping", {
        Text = "Shiny Sniping",
        Default = false,
        Tooltip = "Automatically keeps shiny stands",
        Callback = function(Value)
            SMAX.States.ShinySniping = Value
        end
    })
    
    local WebhookBox = Tabs.MiscTab:AddRightGroupbox("Discord Webhook")
    
    WebhookBox:AddInput("WebhookURL", {
        Text = "Webhook URL",
        Default = "",
        Placeholder = "https://discord.com/api/webhooks/...",
    })
    
    WebhookBox:AddButton("Test Webhook", function()
        local url = Options.WebhookURL.Value
        if url and url ~= "" then
            SMAX.Utils.SendWebhook(url, {
                content = "SMAX YBA Webhook Test",
                embeds = {
                    {
                        title = "Test Successful",
                        description = "Your webhook is working correctly!",
                        color = 65280, -- Green
                    }
                }
            })
            Library:Notify("Webhook test sent!")
        else
            Library:Notify("Please enter a valid webhook URL first!", 3)
        end
    end)
    
    WebhookBox:AddToggle("NotifyItems", {
        Text = "Notify Items",
        Default = false,
        Tooltip = "Sends webhook notifications for items",
        Callback = function(Value)
            SMAX.States.ItemNotify = Value
        end
    })
    
    WebhookBox:AddToggle("NotifyStands", {
        Text = "Notify Stands",
        Default = false,
        Tooltip = "Sends webhook notifications for stands",
        Callback = function(Value)
            SMAX.States.StandNotify = Value
        end
    })
end

return Tabs
