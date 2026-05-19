
--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1024, 600

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Color Extractor")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

local imgPath = "game/resources/images/backgrounds/ghzBGTiles.png"

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.mousepressed(mx, my)
    local x, y = calculateTileCoordinates(mx, my)
    printToReadout("Tile Coordinates: { x = " .. x .. ", y = " .. y .. " }")
end

-- ...
-- ...

--------------------------------------------------------------
--                   Specialized Functions                  --
--------------------------------------------------------------

function drawOverlays()
    local scale = getImageViewer():getScale()
    local x, y = calculateTileCoordinates(love.mouse.getPosition())
    love.graphics.setLineWidth(scale)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", x - 1, y - 1, 18 * scale, 18 * scale)
end

function calculateTileCoordinates(mx, my)
    local imageViewer = getImageViewer()
    local px, py = imageViewer:screenToImageCoordinates(mx, my)

    return imageViewer:imageToScreenCoordinates(math.floor(px / 16) * 16, math.floor(py / 16) * 16)
end
    

-- ...    
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
    :add("drawingLayer", { drawingFn      = drawOverlays     })
    :add("readout",      { printFnName    = "printToReadout" })
    :add("zooming",      { imageViewer    = getImageViewer() })
    :add("scrolling",    { imageViewer    = getImageViewer() })
