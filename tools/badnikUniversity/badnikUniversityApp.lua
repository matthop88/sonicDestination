--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800
local BADNIK_UNIVERSITY_ENGINE    = require("tools/badnikUniversity/badnikUniversityEngine"):create { }
            
--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Badnik University")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    BADNIK_UNIVERSITY_ENGINE:draw()
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
    :add("scrolling",      { imageViewer = BADNIK_UNIVERSITY_ENGINE          })
    :add("zooming",        { imageViewer = BADNIK_UNIVERSITY_ENGINE          })    
    :add("grid2d",         { graphics    = BADNIK_UNIVERSITY_ENGINE.graphics })
    
