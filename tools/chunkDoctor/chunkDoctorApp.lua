--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local MAIN_GRAFX                  = require("tools/lib/graphics"):create()
local SIDEBAR_GRAFX               = require("tools/lib/graphics"):create()

local CHUNKS_DATA_PATH = "resources/zones/chunks/" .. __PARAMS["chunkDataIn"] .. ".lua"
local CHUNK_ARTIST     = require("tools/chunkDoctor/chunkArtist"):create(CHUNKS_DATA_PATH)

local chunkID = 1

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Chunk Doctor")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

MAIN_GRAFX:setScale(2)

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    for i = 1, CHUNK_ARTIST:getNumChunks() do
        CHUNK_ARTIST:draw(i, 100, ((i - 1) * 400) + 72, MAIN_GRAFX)
    end
end

function love.keypressed(key)
    if key == "up" then
        chunkID = chunkID - 1
        if chunkID < 1 then chunkID = CHUNK_ARTIST:getNumChunks() end
        MAIN_GRAFX:setY(-(chunkID - 1) * 400)
    elseif key == "down" then
        chunkID = chunkID + 1
        if chunkID > CHUNK_ARTIST:getNumChunks() then
            chunkID = 1
        end
        MAIN_GRAFX:setY(-(chunkID - 1) * 400)
    end
end

-- ...

--------------------------------------------------------------
--                   Specialized Functions                  --
--------------------------------------------------------------

-- ...
-- ...
-- ...

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    -- :add( ... )
