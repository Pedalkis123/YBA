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
    
    -- Add more tele
