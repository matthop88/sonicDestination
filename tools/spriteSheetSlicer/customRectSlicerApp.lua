local WINDOW_WIDTH, WINDOW_HEIGHT = 1024, 768
            
local imgPath     = "resources/images/sadSlicer.png"
local imgName     = __PARAMS["image"]

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Sprite Sheet Custom Rect Slicer")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

if imgName ~= nil then
    if not imgPath then
        imgPath = "resources/images/spriteSheets/"
    else
        imgPath = __PARAMS["path"]
    end
    imgPath = imgPath .. imgName .. ".png"
end

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

-- ...
-- ...
-- ...

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

drawOverlays = function(self)
    -- Do nothing
end

-- ...
-- ...

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("imageViewer",
    {
        imagePath      = imgPath,
        pixelated      = true,
        accessorFnName = "getImageViewer"
    })
    :add("doubleClick",
    {
        accessorFnName = "getDoubleClick",
    })
    :add("modKeyEnabler")
    :add("scrolling",    { 
        imageViewer = getImageViewer(),
        leftKey     = "shiftleft",
        rightKey    = "shiftright",
        upKey       = "shiftup",
        downKey     = "shiftdown",
    })
    :add("zooming",      { imageViewer = getImageViewer() })
    :add("drawingLayer", { drawingFn   = drawOverlays     })
    :add("readout",
    {
        printFnName    = "printToReadout",
        echoToConsole  = true,
    })
    :add("questionBox",
    {   x = 974, destX = 62, w = 900,
        useDoubleClick = true,
        getDoubleClickFn = getDoubleClick,
        lines = {
            tabSize = 500,
            { "Shift-Arrow Keys:",                   "Scroll Image"                },
            { "z/a:",                                "Zoom in/out"                 },
        },
    })



