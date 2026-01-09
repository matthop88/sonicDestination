--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800
local GRAPHICS                    = require("tools/lib/graphics"):create(), 
            

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Badnik University")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

-- ...
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
    :add("scrolling",      { imageViewer = GRAPHICS })
    :add("zooming",        { imageViewer = GRAPHICS })    
    :add("grid2d",         { graphics    = GRAPHICS })
    
