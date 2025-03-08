-- Miscellaneous features module

local Misc = {}
local Players, ReplicatedStorage, Utils, Cache, States

function Misc.Initialize(PlayersService, ReplicatedStorageService, UtilsModule, CacheModule, StatesModule)
    Players = PlayersService
    ReplicatedStorage = ReplicatedStorageService
    Utils = UtilsModule
    Cache = CacheModule
    States = StatesModule
end

-- Add miscellaneous functions here

return Misc
