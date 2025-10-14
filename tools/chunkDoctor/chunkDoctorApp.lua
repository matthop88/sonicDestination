--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local CHUNKS_DATA_PATH = "resources/zones/chunks/" .. __PARAMS["chunkDataIn"] .. ".lua"
local CHUNK_ARTIST     = require("tools/chunkDoctor/chunkArtist"):create(CHUNKS_DATA_PATH)

local MAIN_PANEL       = require("tools/chunkDoctor/mainPanel"):init(CHUNK_ARTIST)
local SIDEBAR_PANEL    = require("tools/chunkDoctor/sidebarPanel"):init(CHUNK_ARTIST)

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Chunk Doctor")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    MAIN_PANEL:draw()
    SIDEBAR_PANEL:draw()
end

function love.update(dt)
    MAIN_PANEL:update(dt)
end

function love.keypressed(key)
    MAIN_PANEL:handleKeypressed(key)
end

function love.keyreleased(key)
    MAIN_PANEL:handleKeyreleased(key)
end

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
    :add("keyRepeat", {
        interval    = 0.1,
        delay       = 0.5,
        onKeyRepeat = function() MAIN_PANEL:onKeyRepeat() end,
    })

