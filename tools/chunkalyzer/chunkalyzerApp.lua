--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800
local WORLD_PANE                  = require("tools/chunkalyzer/worldPane")

local GRAFX                       = require "tools/lib/graphics"


--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Chunkalyzer")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    WORLD_PANE:draw()
end

function love.update(dt)
    WORLD_PANE:update(dt)
end

function love.keypressed(key)
    WORLD_PANE:handleKeypressed(key)
end

function love.mousepressed(mx, my)
    WORLD_PANE:handleMousepressed(mx, my)
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

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("zooming",      { imageViewer = GRAFX })
    :add("scrolling",    
    { 
        imageViewer   = GRAFX,
        scrollSpeed   = 3200,
    })
    :add("readout",
    {
        printFnName    = "printToReadout",
		accessorFnName = "getReadout",
        echoToConsole  = true,
    })
	:add("timedFunctions",
	{
		{	secondsWait = 1, callback = function() WORLD_PANE:resetMode() end },
	})       
