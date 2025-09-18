--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local WORLD_PANE                  = require("tools/chunkalyzer/worldPane")
local CHUNK_PANE                  = require("tools/chunkalyzer/chunkPane")

local CURRENT_PANE                = WORLD_PANE

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Chunkalyzer")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    CURRENT_PANE:draw()
end

function love.update(dt)
    CURRENT_PANE:update(dt)
end

function love.keypressed(key)
    if     key == "1" then CURRENT_PANE = WORLD_PANE
	elseif key == "2" then CURRENT_PANE = CHUNK_PANE
	else                   CURRENT_PANE:handleKeypressed(key) end
end

function love.mousepressed(mx, my)
    CURRENT_PANE:handleMousepressed(mx, my)
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
    :add("zooming",      { imageViewer = WORLD_PANE:getGraphics()})
    :add("scrolling",    
    { 
        imageViewer   = WORLD_PANE:getGraphics(),
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
