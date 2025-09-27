--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local GRAFX   = require("tools/lib/graphics"):create()

local chunkImgPath

if __CHUNK_FILE ~= nil then
    chunkImgPath = "resources/zones/chunks/" .. __CHUNK_FILE .. ".png"
end


local chunkImgData = love.image.newImageData(chunkImgPath)
local imgData      = love.graphics.newImage(chunkImgData)

local mapData
if __MAP_FILE ~= nil then
    mapData = require("resources/zones/maps/" .. __MAP_FILE)
end

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Map Viewer")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

img:setFilter("nearest", "nearest")

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    -- Drawing goes here
end

function love.update(dt)
	-- Updating happens here
end

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

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("zooming",      { imageViewer = GRAFX,            })
    :add("scrolling",    
    { 
    	imageViewer = GRAFX,
    	scrollSpeed = 2400,          
    })
	:add("readout",      
    { 
    	printFnName    = "printToReadout", 
    	accessorFnName = "getReadout",
    })    


