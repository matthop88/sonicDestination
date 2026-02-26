--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local graphics        = require("tools/lib/graphics"):create()

local MAP             = require("tools/constructionSet/constructionSetMap"):create { graphics = graphics }
local STICKY_MOUSE    = require("tools/constructionSet/stickyMouse"):create(MAP)
local CHUNKS_PANEL    = require("tools/constructionSet/panels/chunksPanel"):create(STICKY_MOUSE, { 1, 2, 3, 4, 5, 6, 7 })
local CHUNKS_2_PANEL  = require("tools/constructionSet/panels/chunksPanel"):create(STICKY_MOUSE, { 1, 2, 3, 4, 5, 6, 7 })
local BADNIKS_PANEL   = require("tools/constructionSet/panels/badniksPanel"):create( { { name = "motobug", spritePath = "objects/motobug" } }, STICKY_MOUSE)
local BADNIKS_2_PANEL = require("tools/constructionSet/panels/badniksPanel"):create( { 
    { name = "patabata", spritePath = "objects/patabata" },
    { name = "tamabboh", spritePath = "objects/tamabboh" },
}, STICKY_MOUSE)

local ITEMS_PANEL     = require("tools/constructionSet/panels/itemsPanel"):create(STICKY_MOUSE)

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

function love.mousepressed(mx, my)
    STICKY_MOUSE:handleMousepressed(graphics, mx, my)
end

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

function drawMouse()
    local mx, my = love.mouse.getPosition()
    STICKY_MOUSE:draw(graphics, mx, my)
end

function drawCoordinates()
    MAP:drawCoordinates()
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
                CHUNKS_PANEL:initChunkInfo("ghzChunks_2")
                CHUNKS_2_PANEL:initChunkInfo("scdPtpChunks")
                require("tools/constructionSet/mapReader"):readMapIntoChunksList(require("tools/constructionSet/data/maps/sampleMap"), MAP.chunks)
            end,
        },
    }) 
    :add("zooming",        { imageViewer = MAP })    
    :add("grid2d",         { 
        graphics    = graphics,
        bounds      = { x = 0, y = 0, w = 256, h = 256 },
    }) 
    :add("drawingLayer", { drawingFn = drawCoordinates })
    :add("drawingLayer", { drawingFn = drawMouse })
    :add("tabbedPane",
    { 
        TABS = { 
             { label = "Chunks",  panel = require("tools/constructionSet/panels/multiPanel"):create { CHUNKS_PANEL,  CHUNKS_2_PANEL  }, },
             { label = "Badniks", panel = require("tools/constructionSet/panels/multiPanel"):create { BADNIKS_PANEL, BADNIKS_2_PANEL }, },
             { label = "Items",   panel = ITEMS_PANEL, },
        },
        accessorFnName = "getTabbedPane",
    })
    :add("scrolling",      { imageViewer = MAP })
    
