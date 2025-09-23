--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local imgPath

if __WORLD_MAP_FILE ~= nil then
    imgPath = "tools/chunkalyzer/data/" .. __WORLD_MAP_FILE .. ".png"
end

local imgData = love.image.newImageData(imgPath)
local img     = love.graphics.newImage(imgData)
		
local CHUNKALYZER_MODEL = require("tools/chunkalyzer/model"):init(img)
local CHUNKALYZER_VIEW  = require("tools/chunkalyzer/view"):init(img, CHUNKALYZER_MODEL)

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Chunkalyzer")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

img:setFilter("nearest", "nearest")

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    CHUNKALYZER_VIEW:draw()
end

-- ...
-- ...

--------------------------------------------------------------
--                   Specialized Functions                  --
--------------------------------------------------------------

function love.keypressed(key)
	if key == "c" then CHUNKALYZER_VIEW:toggleChunkMode() end
end

-- ...
-- ...

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("zooming",      { imageViewer = CHUNKALYZER_VIEW,            })
    :add("scrolling",    
    { 
    	imageViewer = CHUNKALYZER_VIEW,
    	scrollSpeed = 2400,          
    })
    :add("readout",      { printFnName = "printToReadout", })      

