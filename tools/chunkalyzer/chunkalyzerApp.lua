--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local imgPath

if __WORLD_MAP_FILE ~= nil then
    imgPath = "tools/chunkalyzer/data/" .. __WORLD_MAP_FILE .. ".png"
end

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Chunkalyzer")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

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
    :add("imageViewer",
    {
        imagePath      = imgPath,
        horizMargins   = 16,
        vertMargins    = 16,
        accessorFnName = "getImageViewer",
    })
    :add("zooming",      { imageViewer = getImageViewer() })
    :add("scrolling",    { imageViewer = getImageViewer() })

        
