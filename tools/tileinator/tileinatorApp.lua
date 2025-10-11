--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local TILE_VIEW = require("tools/tileinator/view") 

local TILE_PIPELINE = require("tools/tileinator/tilePipeline")
local okayToTileinate = false

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Tileinator")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

TILE_PIPELINE:setup(TILE_VIEW)

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    TILE_VIEW:draw()
end

function love.update(dt)
	if not TILE_PIPELINE:isComplete() and okayToTileinate then
        TILE_PIPELINE:execute()
    end
    TILE_VIEW:update(dt)
end

function love.keypressed(key)
    if key == "space" then 
        TILE_VIEW:setTileMode(true)
        okayToTileinate = true 
    else TILE_VIEW:handleKeypressed(key) end
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
    :add("zooming",      { imageViewer = TILE_VIEW, })
    :add("scrolling",    
    { 
    	imageViewer = TILE_VIEW,
    	scrollSpeed = 2400,          
    })
	:add("readout",      
    { 
    	printFnName    = "printToReadout", 
    	accessorFnName = "getReadout",
    }) 
    :add("timedFunctions",
    {
        {   secondsWait = 1, 
            callback = function() 
                getReadout():setSustain(180) 
                printToReadout("Press 'space' to begin tileinating.") 
            end,
        },
    })    


