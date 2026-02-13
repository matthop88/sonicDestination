--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local STICKY_MOUSE  = require("tools/constructionSet/stickyMouse"):create()
local CHUNKS_PANEL  = require("tools/constructionSet/chunksPanel"):create(STICKY_MOUSE)
local BADNIKS_PANEL = require("tools/constructionSet/badniksPanel"):create(STICKY_MOUSE)
local ITEMS_PANEL   = require("tools/constructionSet/itemsPanel"):create(STICKY_MOUSE)

local graphics      = require("tools/lib/graphics"):create()
local MAP           = require("tools/constructionSet/constructionSetMap"):create { graphics = graphics }

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Construction Set")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    MAP:draw()
end

function love.update(dt)
    STICKY_MOUSE:update(dt)
    MAP:update(dt)
end

function love.keypressed(key)
    STICKY_MOUSE:handleKeypressed(key)
    MAP:handleKeypressed(key)
end

-- ...

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

function drawMouseAndCoordinates()
    MAP:drawCoordinates()
    STICKY_MOUSE:draw(graphics, love.mouse.getPosition())
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
    :add("scrolling",      { imageViewer = MAP })
    :add("zooming",        { imageViewer = MAP })    
    :add("grid2d",         { 
        graphics    = graphics,
        bounds      = { x = 0, y = 0, w = 256, h = 256 },
    }) 
    :add("tabbedPane",
    { 
        TABS = { 
             { label = "Chunks",  panel = CHUNKS_PANEL,  },
             { label = "Badniks", panel = BADNIKS_PANEL, },
             { label = "Items",   panel = ITEMS_PANEL, },
        },
        accessorFnName = "getTabbedPane",
    })
    :add("drawingLayer", { drawingFn = drawMouseAndCoordinates })
