
--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 800, 600

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Background Layer Tool")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

local imgPath                     = "game/resources/zones/backgrounds/ghzBG.png"

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.mousepressed(mx, my)
    local imageViewer = getImageViewer()
    local p = imageViewer:getPixelColorAt(imageViewer:screenToImageCoordinates(mx, my))
    getReadout():printMessage(string.format("R = %s, G = %s, B = %s, A = %s", love.math.colorToBytes(p.r, p.g, p.b, p.a)))
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
    :add("imageViewer", 
    { 
        imagePath         = imgPath,
        accessorFnName    = "getImageViewer"
    })
    :add("readout",     { accessorFnName = "getReadout"     })
    :add("zooming",     { imageViewer    = getImageViewer() })
    :add("scrolling",   { imageViewer    = getImageViewer() })
    
