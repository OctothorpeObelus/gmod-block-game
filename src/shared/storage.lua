--@name Data Storage
--@author Octo
--@shared
--@include block game/shared/block_registry.txt

local block_registry = require("block game/shared/block_registry.txt")

--Global block data table. Stores block positions and other metadata.
gBlockData = {}

local export = {}

export.getBlock = function(position)
    if gBlockData[position[1]] then
        if gBlockData[position[1]][position[2]] then
            if gBlockData[position[1]][position[2]][position[3]] then
                return gBlockData[position[1]][position[2]][position[3]]
            end
        end
    end
    
    return {}
end

export.setBlock = function(position, id)
    local block = block_registry.getBlockByID(id)
    gBlockData[ position[1] ][ position[2] ][ position[3] ] = block
end

return export
