--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Chunk Doctor")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

local CHUNKS_DATA_PATH = "resources/zones/chunks/" .. __PARAMS["chunkDataIn"] .. ".lua"

local CHUNK_ARTIST = require("tools/chunkDoctor/chunkArtist"):create(CHUNKS_DATA_PATH)

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    CHUNK_ARTIST:draw(1, 200, 200)
end
-- ...
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
