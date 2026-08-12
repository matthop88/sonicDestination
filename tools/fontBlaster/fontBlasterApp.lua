--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800
local GRAPHICS = require("tools/lib/graphics"):create()
local FONT_BLASTER_ENGINE = require("tools/fontBlaster/fontBlasterEngine"):create { graphics = GRAPHICS }

------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Font Blaster")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })



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

function love.mousepressed(mx, my, params)
    FONT_BLASTER_ENGINE:handleMousepressed(mx, my, params)
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
    :add("inputLayer", {
        accessorFnName = "getInputLayer",
        keypressedFn = function(key)
            FONT_BLASTER_ENGINE:handleKeypressed(key)
            return true
        end,
    })
    :add("scrolling",      { imageViewer = FONT_BLASTER_ENGINE })
    :add("zooming",        { imageViewer = FONT_BLASTER_ENGINE })    
    :add("grid2d",         { graphics    = GRAPHICS })
    :add("timedFunctions", {
        {   secondsWait = 0.1, 
            callback = function() 
                FONT_BLASTER_ENGINE:init() 
            end,
        },
    }) 
     

