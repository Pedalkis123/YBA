-- UI initialization module

local UI = {}
local Library, Tabs, SaveManager

function UI.Initialize(SMAX)
    -- Load UI library
    Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/Library.lua"))()
    
    -- Load tabs
    Tabs = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/SMAX-YBA/main/ui/tabs.lua"))()
    Tabs.Initialize(Library, SMAX)
    
    -- Load save manager
    SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/SMAX-YBA/main/ui/savemanager.lua"))()
    SaveManager:SetLibrary(Library)
    SaveManager:SetFolder("SMAX/YBA")
    SaveManager:BuildConfigSection(Tabs.SettingsTab)
    
    -- Make UI accessible
    UI.Library = Library
    UI.Tabs = Tabs
    UI.SaveManager = SaveManager
    
    -- Initialize UI
    Library:OnUnload(function()
        -- This will be called by the main script
    end)
    
    -- Show UI
    Library:Notify("SMAX YBA Loaded!")
    Library.KeybindFrame.Visible = true
    Library:SetWatermarkVisibility(true)
    Library:SetWatermark("SMAX YBA")
    
    return UI
end

return UI
