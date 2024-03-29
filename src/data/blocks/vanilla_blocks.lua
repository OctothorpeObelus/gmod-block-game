--@name Vanilla Blocks
--@author Octo
--@shared
--@include block game/shared/block_registry.txt

local blocks = require("block game/shared/block_registry.txt")

local cube = "models/sprops/cuboids/height36/size_1/cube_36x36x36.mdl"
local path = "https://raw.githubusercontent.com/OctothorpeObelus/gmod-block-game/main/textures/blocks/"
local bmat = "Building Materials"

//Dirt
blocks.registerBlock("blocks.dirt", "Dirt", bmat, cube, path.."dirt.png", {})
