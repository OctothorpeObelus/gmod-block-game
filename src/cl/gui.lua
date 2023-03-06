--@name Block Game HUD and GUI
--@author Octo
--@client
--@include block game/shared/block_registry.txt

local block_registry = require("block game/shared/block_registry.txt")

if player() ~= owner() then return end
enableHud(owner(), true)

local inputStates = {
    inventory = false
}

--Fonts
local fontArial24 = render.createFont("Arial",24,500,true,false,false,false,0,false,0)

local current_tab = table.getKeys(gBlockRegistryCategories)[1]
local ScrW, ScrH

--To percent (width)
local function tpw(width)
    return (width/1920) * ScrW
end

--To percent (height)
local function tph(height)
    return (height/1080) * ScrH
end

--Get percent width of the screen in pixels
local function pctw(width)
    return (width/100) * ScrW
end

--Get percent height of the screen in pixels
local function pcth(height)
    return (height/100) * ScrH
end

hook.add("drawhud", "block_game_hud", function()
    ScrW, ScrH = render.getGameResolution()
    
    --Inventory rendering
    if inputStates.inventory then
        --Background
        render.setColor(Color(80, 80, 80, 160))
        render.drawRectFast(pctw(20), pcth(10), pctw(60), pcth(60))
        render.drawRectFast(pctw(20), pcth(75), pctw(60), pcth(10))
        
        --Tab rendering
        render.setColor(Color(255))
        render.setFont(fontArial24)
        for category, blocks in pairs(gBlockRegistryCategories) do
            if current_tab == category then
                render.setColor(Color(200, 200, 200, 160))
                render.drawRect(pctw(20), pcth(10), pctw(60/#table.getKeys(gBlockRegistryCategories)), pcth(5))
                render.setColor(Color(255))
            end
            render.drawRectOutline(pctw(20), pcth(10), pctw(60/#table.getKeys(gBlockRegistryCategories)), pcth(5), pctw(0.2))
            render.drawSimpleText(pctw(20) + pctw(30/#table.getKeys(gBlockRegistryCategories)), pcth(12.5), category, TEXT_ALIGN.CENTER, TEXT_ALIGN.CENTER)
            
            if current_tab == category then
                render.setColor(Color(255))
                for k, id in pairs(blocks) do
                    local icon = block_registry.getBlockByID(id).spawnicon
                    render.setMaterial(icon)
                    local inc = pctw(60) - tpw(48)
                    render.drawTexturedRect(pctw(20) + inc*(((k-1)%10)/10) + tpw(24), pcth(15) + tph(24) + (inc + tph(128))*((math.floor((k-1)/10))/10), inc/10, inc/10)
                end
            end
        end
    end
end)

hook.add("inputPressed", "block_game_ui_input_listener", function(key)
    if key == KEY.E then
        if current_tab == nil then
            current_tab = table.getKeys(gBlockRegistryCategories)[1]
        end
        inputStates.inventory = !inputStates.inventory
    end
end)
