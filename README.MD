# Block Game
This was originally made to test my skills by recreating similar behaviors to that of Minecraft.
I used a library called `middleclass` to achieve rudimentary OOP behaviors inside of Lua.
__This remains in an unfinished and non-playable state for the forseeable future, however I am uploading it here so its inner workings may be seen.__

The end goal was to make additions to the game as easy as possible. The `src/data/blocks` folder contains the [`vanilla_blocks.lua`](https://github.com/OctothorpeObelus/gmod-block-game/blob/main/src/data/blocks/vanilla_blocks.lua) file, which shows just how easy adding a block to the game is.
The table input at the end of the function call is the Metadata table, and it can contain all sorts of useful information, which can be read about in `src/docs/blocks.txt`.
The [`src/shared/block_registry.lua`](https://github.com/OctothorpeObelus/gmod-block-game/blob/main/src/shared/block_registry.lua) file documents how this block registration function works.
On top of this, it not only registers new blocks but renders their spawn icons for use in the GUI and saves them as .png files.
It achieves this using render targets.
