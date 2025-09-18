--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local WORLD_PANE                  = require("tools/chunkalyzer/worldPane")
local CHUNK_PANE                  = require("tools/chunkalyzer/chunkPane")

local CHUNKALYZER = {
	CURRENT_PANE = WORLD_PANE,

	draw = function(self)
		self.CURRENT_PANE:draw()
	end,

	update = function(self, dt)
		self.CURRENT_PANE:update(dt)
	end,

	handleKeypressed = function(self, key)
    	if     key == "1" then self.CURRENT_PANE = WORLD_PANE
		elseif key == "2" then self.CURRENT_PANE = CHUNK_PANE
		else                   self.CURRENT_PANE:handleKeypressed(key) end
	end,

	handleMousepressed = function(self, mx, my)
    	self.CURRENT_PANE:handleMousepressed(mx, my)
	end,

	keepImageInBounds = function(self)
        self.CURRENT_PANE:keepImageInBounds()
    end,

    moveImage = function(self, deltaX, deltaY)
		self.CURRENT_PANE:moveImage(deltaX, deltaY)
	end,
}

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Chunkalyzer")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    CHUNKALYZER:draw()
end

function love.update(dt)
    CHUNKALYZER:update(dt)
end

function love.keypressed(key)
    CHUNKALYZER:handleKeypressed(key)
end

function love.mousepressed(mx, my)
    CHUNKALYZER:handleMousepressed(mx, my)
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
        imageViewer   = CHUNKALYZER,
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
