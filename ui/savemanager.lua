-- Save Manager Module
-- Modified from Linoria Library

local SaveManager = {}
local Library, ConfigFolder

-- Set library reference
function SaveManager:SetLibrary(library)
    Library = library
end

-- Set folder for configs
function SaveManager:SetFolder(folder)
    ConfigFolder = folder
    
    -- Create folder if it doesn't exist
    if not isfolder(ConfigFolder) then
        makefolder(ConfigFolder)
    end
end

-- Build the config section in the UI
function SaveManager:BuildConfigSection(tab)
    local section = tab:AddRightGroupbox('Configuration')
    
    section:AddInput('ConfigName', {
        Text = 'Config Name',
        Default = '',
        Placeholder = 'Default',
    })
    
    section:AddDropdown('ConfigList', {
        Text = 'Configs',
        Values = self:RefreshConfigList(),
        Default = 1,
    })
    
    section:AddButton('Create', function()
        self:SaveConfig(Options.ConfigName.Value)
        Options.ConfigList:SetValues(self:RefreshConfigList())
        Options.ConfigList:SetValue(nil)
    end)
    
    section:AddButton('Save', function()
        self:SaveConfig(Options.ConfigList.Value)
    end)
    
    section:AddButton('Load', function()
        self:LoadConfig(Options.ConfigList.Value)
    end)
    
    section:AddButton('Delete', function()
        self:DeleteConfig(Options.ConfigList.Value)
        Options.ConfigList:SetValues(self:RefreshConfigList())
        Options.ConfigList:SetValue(nil)
    end)
    
    section:AddButton('Refresh', function()
        Options.ConfigList:SetValues(self:RefreshConfigList())
        Options.ConfigList:SetValue(nil)
    end)
    
    section:AddToggle('AutoLoadConfig', {
        Text = 'Auto Load Config',
        Default = false,
        Tooltip = 'Automatically loads the selected config on script startup',
    })
    
    section:AddButton('Set as Autoload', function()
        if Options.ConfigList.Value then
            self:SetAutoloadConfig(Options.ConfigList.Value)
            Library:Notify(string.format('Set %q to auto load', Options.ConfigList.Value))
        end
    end)
    
    return section
end

-- Refresh the config list
function SaveManager:RefreshConfigList()
    local list = {}
    
    if isfolder(ConfigFolder) then
        for _, file in pairs(listfiles(ConfigFolder)) do
            local fileName = string.match(file, '[^\\]+$')
            if fileName:sub(-5) == '.json' then
                table.insert(list, fileName:sub(1, -6))
            end
        end
    end
    
    return list
end

-- Save a config
function SaveManager:SaveConfig(configName)
    if not configName or configName == '' then
        return
    end
    
    local fileName = string.format('%s/%s.json', ConfigFolder, configName)
    local data = {}
    
    for _, option in pairs(Options) do
        if option.Type ~= 'Button' and option.Name ~= 'ConfigList' and option.Name ~= 'ConfigName' then
            data[option.Name] = option.Value
        end
    end
    
    writefile(fileName, game:GetService('HttpService'):JSONEncode(data))
    Library:Notify(string.format('Saved config %q', configName))
end

-- Load a config
function SaveManager:LoadConfig(configName)
    if not configName or configName == '' then
        return
    end
    
    local fileName = string.format('%s/%s.json', ConfigFolder, configName)
    if not isfile(fileName) then
        return Library:Notify(string.format('Config %q does not exist', configName))
    end
    
    local data = game:GetService('HttpService'):JSONDecode(readfile(fileName))
    for _, option in pairs(Options) do
        if data[option.Name] ~= nil and option.Type ~= 'Button' and option.Name ~= 'ConfigList' and option.Name ~= 'ConfigName' then
            option:SetValue(data[option.Name])
        end
    end
    
    Library:Notify(string.format('Loaded config %q', configName))
end

-- Delete a config
function SaveManager:DeleteConfig(configName)
    if not configName or configName == '' then
        return
    end
    
    local fileName = string.format('%s/%s.json', ConfigFolder, configName)
    if not isfile(fileName) then
        return Library:Notify(string.format('Config %q does not exist', configName))
    end
    
    delfile(fileName)
    Library:Notify(string.format('Deleted config %q', configName))
end

-- Set autoload config
function SaveManager:SetAutoloadConfig(configName)
    if not configName or configName == '' then
        return
    end
    
    local fileName = string.format('%s/%s.json', ConfigFolder, configName)
    if not isfile(fileName) then
        return Library:Notify(string.format('Config %q does not exist', configName))
    end
    
    writefile(string.format('%s/_autoload.txt', ConfigFolder), configName)
end

-- Load autoload config
function SaveManager:LoadAutoloadConfig()
    local autoloadFile = string.format('%s/_autoload.txt', ConfigFolder)
    if isfile(autoloadFile) then
        local configName = readfile(autoloadFile)
        self:LoadConfig(configName)
        
        if Options.AutoLoadConfig then
            Options.AutoLoadConfig:SetValue(true)
        end
        
        if Options.ConfigList then
            Options.ConfigList:SetValue(configName)
        end
        
        Library:Notify(string.format('Auto loaded config %q', configName))
    end
end

return SaveManager
