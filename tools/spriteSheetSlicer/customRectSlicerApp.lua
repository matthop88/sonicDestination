local WINDOW_WIDTH, WINDOW_HEIGHT = 1024, 768
            
local imgPath     = "resources/images/sadSlicer.png"
local imgName     = __PARAMS["image"]
local rect        = { x = 0, y = 0, w = 40, h = 40 }
local width       = 40
local height      = 40

local colorInvert = false

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

love.update = function(dt)
    local imageViewer = getImageViewer()
    local x, y = imageViewer:screenToImageCoordinates(love.mouse.getPosition())
    rect = { x = math.floor(x - (width / 2)), y = math.floor(y - (height / 2)), w = width, h = height }
end

love.mousepressed = function(mx, my)
    printToReadout("{ x = " .. rect.x .. ", y = " .. rect.y .. ", w = " .. rect.w .. ", h = " .. rect.h .. " }")
end

love.keypressed = function(key)
    if     key == "left"  then width  = width  - 1
    elseif key == "right" then width  = width  + 1
    elseif key == "up"    then height = height - 1
    elseif key == "down"  then height = height + 1
    elseif key == "i"     then colorInvert = not colorInvert
    end
end

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

drawOverlays = function(self)
    if colorInvert then
        love.graphics.setColor(0, 0, 0)
    else
        love.graphics.setColor(1, 1, 1)
    end
    local imageViewer = getImageViewer()
    local rx, ry = imageViewer:imageToScreenCoordinates(rect.x, rect.y)
    local rx2, ry2 = imageViewer:imageToScreenCoordinates(rect.x + rect.w, rect.y + rect.h)
    local rw, rh = rx2 - rx, ry2 - ry
    
    love.graphics.rectangle("line", rx, ry, rw, rh)
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
    :add("keyRepeat", {
        interval    = 0.05,
        delay       = 0.5,
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
            { "", },
            { "Left Arrow:",                         "Decrease width  by 1 pixel"  },
            { "Right Arrow:",                        "Increase width  by 1 pixel"  },
            { "Up Arrow:",                           "Decrease height by 1 pixel"  },
            { "Down Arrow:",                         "Increase height by 1 pixel"  },
            
        },
    })



