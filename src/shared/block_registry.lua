--@name Block Registry
--@author Octo
--@shared

--Global block registry table
gBlockRegistry = {}
gBlockRegistryCategories = {}
mats = mats or 0

if CLIENT and player() == owner() then render.createRenderTarget("spawnicon") end

local export = {}


--Loads a mesh from a URL and calls the callback when it is done with the mesh object.
local function loadModelFromURL(path, cb)
    if SERVER then error("This is a client only function") end
    
    http.get(path,function(objdata)
        local triangles = mesh.trianglesLeft()
    
        local function doneLoadingMesh()
            cb(mymesh)
            return mymesh
        end
    
        local loadmesh = coroutine.wrap(function() mymesh = mesh.createFromObj(objdata, true, true) return true end)
        hook.add("think","loadingMesh",function()
            while quotaAverage()<quotaMax()/2 do
                if loadmesh() then
                    doneLoadingMesh()
                    hook.remove("think","loadingMesh")
                    return
                end
            end
        end)
    end)
end

local function renderSpawnIcon(model, mat, id, spawnicon)
    if SERVER then error("This is a client only function") end
    if player() ~= owner() then return end
    
    local icon
    
    if spawnicon ~= nil then
        icon = spawnicon
    else
        icon = material.create("UnlitGeneric")
        mats = mats + 1
    end
    
    --Load from files if we have one made already
    if file.exists("block_game/spawnicons/"..id..".png") then
        icon = material.createFromImage("data/sf_filedata/block_game/spawnicons/"..id..".png", "")
        return icon
    end
    
    local holo = holograms.create(Vector(0, 0, 0), Angle(0, 0, 0), "models/sprops/cuboids/height36/size_1/cube_36x36x36.mdl")
    
    if type(model) == "string" then
        holo:setModel(model)
    else
        holo:setMesh(model)
    end
    
    local img
    hook.add("renderoffscreen", "si", function()    
        render.selectRenderTarget("spawnicon")
            render.clear(Color(0,0,0,0), true)
            
            render.pushViewMatrix({
                type = "3D",
                origin = Vector(321.212433, 321.693665, 262.42),
                angles = Angle(30.069, 225.043, 0.000),
                fov = 6.36,
                zfar = 800,
                aspect = 1,
            })
            
            render.setLightingMode(1)
                holo:setMaterial("!" .. mat:getName())
                holo:draw()
            render.setLightingMode(0)
            
            img = render.captureImage({
                format = "png",
                x = 0,
                y = 0,
                h = 1024,
                w = 1024,
                alpha = true,
            })
            
            render.popViewMatrix()
        render.selectRenderTarget()
        
        file.createDir("block_game")
        file.createDir("block_game/spawnicons")
        file.write("block_game/spawnicons/"..id..".png", img)
        
        icon:setTextureRenderTarget("$basetexture", "spawnicon")
        --render.destroyRenderTarget("spawnicon")
        hook.remove("renderoffscreen", "si")
        return
    end)
    
    holo:remove()
    
    return icon
end

--Registers a new block with the game.
--id = registry id
--name = human readable name string (defaults to id)
--category = the category in the block selection menu this block will appear in
--metadata = table containing further information about the block, such as if it is directional or block states.
export.registerBlock = function(id, name, category, model, texture, metadata)
    if id == nil or id == "" then
        error("Invalid block ID")
    end
    
    name = name or id
    category = category or "Misc"
    metadata = metadata or {}
    texture = texture or ""
    
    local block = {}
    block.name = name
    block.category = category
    block.onPlace = onPlace
    block.think = think
    block.onDestroy = onDestroy
    block.metadata = metadata

    if CLIENT then
        if mats >= convar.getInt("sf_render_maxusermaterials") then
            print("Failed to register block '" .. name .. "', not enough materials.")
            return
        end
        
        block.material = material.create("VertexLitGeneric")
        mats = mats + 1
        
        --Adjust the UVs of the material so that the ful image is used on the cube model.
        if model == "models/sprops/cuboids/height36/size_1/cube_36x36x36.mdl" then
            block.material:setMatrix("$basetexturetransform", Matrix({
                {4/3, 0, 0, -1/6},
                {0, 4/3, 0, -1/6},
                {0, 0, 1, 0},
                {0, 0, 0, 1},
            }))
        end
        
        if string.find(texture, "https://") == nil then
            block.material:setTexture("$basetexture", texture)
        else
            block.material:setTextureURL("$basetexture", texture, nil, function()
                block.spawnicon = renderSpawnIcon(block.model, block.material, id, block.spawnicon)
            end)
        end
    end
    
    if string.find(model, "https://") == nil then --Game model path
        block.model = model
        -- Render a spawn icon if this is the client.
        if CLIENT then block.spawnicon = renderSpawnIcon(block.model, block.material, id, block.spawnicon) end
    else
        if CLIENT then --URL model path
            block.spawnicon = material.create("UnlitGeneric")
            block.spawnicon:setTexture("$basetexture", "phoenix_storms/lag_sign")
            loadModelFromURL(model, function(mesh)
                block.model = mesh[table.getKeys(mesh)[1]]
                block.spawnicon = renderSpawnIcon(block.model, block.material, id, block.spawnicon)
            end)    
        else
            block.model = nil
        end
    end
    
    --Category registration.
    if not gBlockRegistryCategories[category] then
        gBlockRegistryCategories[category] = {}
    end
    table.insert(gBlockRegistryCategories[category], id)
    
    gBlockRegistry[string.lower(id)] = block
end

--Gets a block with the given id and returns its table.
export.getBlockByID = function(id)
    return gBlockRegistry[string.lower(id)]
end

--Searches for blocks containing the given string in their name, and returns a table of them.
export.searchBlocks = function(str)
    local match = {}
    
    for id,block in pairs(gBlockRegistry) do
        if string.find(block.name, str) ~= nil then
            table.insert(match, block)
        end
    end
    
    return match
end

return export
