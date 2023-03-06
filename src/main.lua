--@name Block Game Main File
--@author Octo
--@shared

--Server files

--Shared files
--@include block game/shared/block_registry.txt
--@include block game/shared/storage.txt

--Client files
--@includedir block game/cl/

--Data Folder
--@includedir block game/data/blocks/

--Server file modules

--Shared file modules
local block_registry = require("block game/shared/block_registry.txt")
local storage = require("block game/shared/storage.txt")

--Client file modules
dodir("block game/cl/")

--Blocks
dodir("block game/data/blocks/")

if CLIENT then
    if player() ~= owner() then return end
    
    
end
