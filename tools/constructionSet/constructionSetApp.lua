--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local CHUNKS_PANEL = require("tools/constructionSet/chunksPanel"):create()


--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Construction Set")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

-- ...
-- ...
-- ...

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("doubleClick")
    :add("timedFunctions",
    {
        {   secondsWait = 0.25, 
            callback = function() 
                CHUNKS_PANEL:initChunkInfo()
            end,
        },
    })  
    :add("tabbedPane",
    { 
        TABS = { 
             { label = "Chunks",  panel = CHUNKS_PANEL, },
             { label = "Badniks", panel = nil, },
             { label = "Items",   panel = nil, },
        }
    })

    
--        ...
--        ...

