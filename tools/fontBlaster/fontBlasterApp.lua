--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800
local FONT_BLASTER_ENGINE

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Font Blaster")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

local FONT_BLASTER_ENGINE = require("tools/fontBlaster/fontBlasterEngine"):create()

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    FONT_BLASTER_ENGINE:draw()
end

function love.update(dt)
    FONT_BLASTER_ENGINE:update(dt)
end

function love.keypressed(key)
    FONT_BLASTER_ENGINE:handleKeypressed(key)
end

function love.mousepressed(mx, my)
    FONT_BLASTER_ENGINE:handleMousepressed(mx, my)
end

function love.mousereleased(mx, my)
    FONT_BLASTER_ENGINE:handleMousereleased(mx, my)
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

require("plugins/engine")
    :add("modKeyEnabler")
    :add("doubleClick",
    {
        accessorFnName = "getDoubleClick",
    })
    :add("keyRepeat", {
        interval    = 0.05,
        delay       = 0.5,
    })
    :add("scrolling",      { imageViewer = FONT_BLASTER_ENGINE })
    :add("zooming",        { imageViewer = FONT_BLASTER_ENGINE })    
    :add("grid2d",         { graphics    = FONT_BLASTER_ENGINE.graphics })

