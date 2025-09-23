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

local GRAFX   = require("tools/lib/graphics"):create()

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Chunkalyzer")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

img:setFilter("nearest", "nearest")

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

-- ...
-- ...
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
    :add("scrolling",    { imageViewer = GRAFX,            })
    :add("readout",      { printFnName = "printToReadout", })      
