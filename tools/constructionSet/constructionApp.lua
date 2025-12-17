--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local GRAFX = require("tools/lib/graphics"):create()

GRAFX.moveImageOld = GRAFX.moveImage
GRAFX.moveImage = function(self, deltaX, deltaY)
    self:moveImageOld(deltaX / self:getScale(), deltaY / self:getScale())
end

local CHUNKS_PATH = "game/resources/zones/chunks/ghzChunks.lua"
local CHUNKS_INFO = require("tools/constructionSet/terrain/chunkImageBuilder"):create(CHUNKS_PATH)
local CHUNKS      = require("tools/constructionSet/terrain/chunksBuilder"):create(CHUNKS_INFO.image)
    
local TILES_TEMP  = require("tools/constructionSet/tilesTemp"):create(CHUNKS_PATH)

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Construction Set")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    GRAFX:setColor(1, 1, 1)
    local x, y = GRAFX:screenToImageCoordinates(love.mouse.getPosition())
    GRAFX:draw(TILES_TEMP.image, math.floor(x), math.floor(y))
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
    :add("modKeyEnabler")
    :add("doubleClick",
    {
        accessorFnName = "getDoubleClick",
    })
    :add("keyRepeat", {
        interval    = 0.05,
        delay       = 0.5,
    })
    :add("scrolling",      { imageViewer = GRAFX })
    :add("zooming",        { imageViewer = GRAFX })    
    :add("grid2d",         { 
        graphics    = GRAFX,
        bounds      = { x = 0, y = 0, w = 256, h = 256 },
    })
    
