--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local STICKY_MOUSE  = require("tools/constructionSet/stickyMouse"):create()
local CHUNKS_PANEL  = require("tools/constructionSet/chunksPanel"):create(STICKY_MOUSE)
local BADNIKS_PANEL = require("tools/constructionSet/badniksPanel"):create(STICKY_MOUSE)
local ITEMS_PANEL   = require("tools/constructionSet/itemsPanel"):create(STICKY_MOUSE)

local graphics      = require("tools/lib/graphics"):create()
graphics:setScale(3)

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
--                  Specialized Functions                   --
--------------------------------------------------------------

function drawMouse()
    local mx, my = love.mouse.getPosition()
    STICKY_MOUSE:draw(graphics, mx / 3, my / 3)
end

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
             { label = "Chunks",  panel = CHUNKS_PANEL,  },
             { label = "Badniks", panel = BADNIKS_PANEL, },
             { label = "Items",   panel = ITEMS_PANEL, },
        }
    })
    :add("drawingLayer", { drawingFn = drawMouse })

    
--        ...
--        ...

