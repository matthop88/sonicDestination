
--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 800, 600

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Background Layer Tool")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

local imgPath = "game/resources/images/backgrounds/ccPastBG.png"

local MARGIN_COLOR = { r = 0.73, g = 0.25, b = 0.27, a = 1.0 }

local layerRect = nil
--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.mousepressed(mx, my)
    local imageViewer = getImageViewer()
    seekEdgesFrom(mx, my)
    printLayerRect()
end

-- ...
-- ...

--------------------------------------------------------------
--                   Specialized Functions                  --
--------------------------------------------------------------

function drawOverlays()
    if layerRect then
        local imageViewer = getImageViewer()
        local x, y, w, h = imageViewer:imageToScreenRect(layerRect.x, layerRect.y, layerRect.w, layerRect.h)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", x, y, w, h)
    end
end

function seekEdgesFrom(mx, my)
    local imageViewer = getImageViewer()
    local oX, oY = imageViewer:screenToImageCoordinates(mx, my)
    layerRect = {}
    for x = oX, 0, -1 do
        local p = imageViewer:getPixelColorAt(x, oY)
        if equalsMarginColor(p.r, p.g, p.b, p.a) then
            layerRect.x = math.floor(x + 1)
            break
        end
    end
    for y = oY, 0, -1 do
        local p = imageViewer:getPixelColorAt(oX, y)
        if equalsMarginColor(p.r, p.g, p.b, p.a) then
            layerRect.y = math.floor(y + 1)
            break
        end
    end
    for x = oX, imageViewer:getImageWidth() - 1 do
        local p = imageViewer:getPixelColorAt(x, oY)
        if equalsMarginColor(p.r, p.g, p.b, p.a) then
            layerRect.w = math.floor(x - layerRect.x)
            break
        end
    end
    for y = oY, imageViewer:getImageHeight() - 1 do
        local p = imageViewer:getPixelColorAt(oX, y)
        if equalsMarginColor(p.r, p.g, p.b, p.a) then
            layerRect.h = math.floor(y - layerRect.y)
            break
        end
    end
end

function equalsMarginColor(r, g, b, a)
    return approximatelyEqualTo(r, MARGIN_COLOR.r)
       and approximatelyEqualTo(g, MARGIN_COLOR.g)
       and approximatelyEqualTo(b, MARGIN_COLOR.b)
       and approximatelyEqualTo(a, MARGIN_COLOR.a)
end

function approximatelyEqualTo(c1, c2)
    return math.abs(c1 - c2) < 0.01
end

function printLayerRect()
    local layerRectString = string.format("{ x = %s, y = %s, w = %s, h = %s }", layerRect.x, layerRect.y, layerRect.w, layerRect.h)
    getReadout():printMessage(layerRectString)
    print(layerRectString)
end

    
-- ...

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("imageViewer", 
    { 
        imagePath         = imgPath,
        accessorFnName    = "getImageViewer"
    })
    :add("doubleClick",
    {
        accessorFnName = "getDoubleClick",
    })
    :add("drawingLayer", { drawingFn      = drawOverlays     })
    :add("readout",      { accessorFnName = "getReadout"     })
    :add("zooming",      { imageViewer    = getImageViewer() })
    :add("scrolling",    { imageViewer    = getImageViewer() })
    :add("questionBox",
    {   x     = 750,
        w     = 600,
        destX = 100,
        useDoubleClick = true,
        getDoubleClickFn = getDoubleClick,
        lines = {
            "Click inside a background slice rect to find",
            "the coordinates of the rect",
            "in { x, y, w, h } format.",
        },
    })
