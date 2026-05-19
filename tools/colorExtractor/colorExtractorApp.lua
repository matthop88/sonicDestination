
--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1024, 600

local destRect = { x = 512, y = 0 }
local rects = {}
local selectedColor = nil

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

function love.keypressed(key)
    if key == "space" then addRect() end
end
-- ...

--------------------------------------------------------------
--                   Specialized Functions                  --
--------------------------------------------------------------

function drawOverlays()
    local scale = getImageViewer():getScale()
    local x, y = calculateTileCoordinates(love.mouse.getPosition())
    love.graphics.setLineWidth(scale)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", x - scale, y - scale, 18 * scale, 18 * scale)

    for _, rect in ipairs(rects) do
        love.graphics.setColor(rect.c)
        local rx, ry = getImageViewer():imageToScreenCoordinates(rect.x, rect.y)
        love.graphics.rectangle("fill", rx, ry, scale * 16, scale * 16)
    end
end

function calculateTileCoordinates(mx, my)
    local imageViewer = getImageViewer()
    local px, py = imageViewer:screenToImageCoordinates(mx, my)

    return imageViewer:imageToScreenCoordinates(math.floor(px / 16) * 16, math.floor(py / 16) * 16)
end
    

function onColorSelected(color)
    selectedColor = color
    local r, g, b = unpack(color)
    print(string.format("{ r = %.2f, g = %.2f, b = %.2f }", r, g, b))
    printToReadout(string.format("R = %s, G = %s, B = %s", love.math.colorToBytes(r, g, b)))
end 

function addRect()
    if selectedColor then
        table.insert(rects, { x = destRect.x, y = destRect.y, c = selectedColor })  
        destRect.x = destRect.x + 16
    end
end


--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("imageViewer", 
    { 
        imagePath         = imgPath,
        pixelated         = true,
        accessorFnName    = "getImageViewer"
    })
    :add("drawingLayer", { drawingFn      = drawOverlays     })
    :add("selectColor", 
    {
        imageViewer       = getImageViewer(),
        onColorSelected   = onColorSelected,
        accessorFnName    = "getColorSelector"
    })
    :add("readout",      { printFnName    = "printToReadout" })
    :add("zooming",      { imageViewer    = getImageViewer() })
    :add("scrolling",    { imageViewer    = getImageViewer() })
