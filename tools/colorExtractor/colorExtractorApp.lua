
--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1024, 600

local destRect = { x = 256, y = 16 }
local rects = {}
local selectedColor = nil
local selectedTileCoordinates = { x = 0, y = 0 }
local rectData = {}

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Color Extractor")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

local imgPath = "game/resources/images/backgrounds/ghzBGTiles.png"

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.mousereleased(mx, my)
    local x, y = getImageViewer():screenToImageCoordinates(mx, my)
    x, y = math.floor(math.floor(x) / 16) * 16, math.floor(math.floor(y) / 16) * 16
    printToReadout("Tile Coordinates: { x = " .. x .. ", y = " .. y .. " }")
    selectedTileCoordinates = { x = x, y = y }
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
    local tx, ty = imageViewer:imageToScreenCoordinates(math.floor(px / 16) * 16, math.floor(py / 16) * 16)
    return math.floor(tx), math.floor(ty)
end
    

function onColorSelected(color)
    selectedColor = color
    local r, g, b = unpack(color)
    print(string.format("{ r = %.2f, g = %.2f, b = %.2f }", r, g, b))
    printToReadout(string.format("R = %s, G = %s, B = %s", love.math.colorToBytes(r, g, b)))
end 

extractColor = function(x, y, r, g, b, a)
    if x >= selectedTileCoordinates.x and y >= selectedTileCoordinates.y
        and x <  selectedTileCoordinates.x + 16 and y < selectedTileCoordinates.y + 16 then
            if r == selectedColor[1] and g == selectedColor[2] and b == selectedColor[3] then
                table.insert(rectData, { x = destRect.x + x - selectedTileCoordinates.x, y = destRect.y + y - selectedTileCoordinates.y })
                return 0, 0, 0, 0
            end
    end
    return r, g, b, a
end

addExtractedColor = function(x, y, r, g, b, a)
    if x >= destRect.x and y >= destRect.y and x < destRect.x + 16 and y < destRect.y + 16 then
        for _, d in ipairs(rectData) do
            --print("RectData.x, y = ", d.x, d.y)
            if x == d.x and y == d.y then
                return 1, 1, 1, 1
            end
        end
    end
    return r, g, b, a
end
    

function addRect()
    if selectedColor then
        print("selectedTileCoordinates: x = " .. selectedTileCoordinates.x .. ", y = " .. selectedTileCoordinates.y)
        --table.insert(rects, { x = destRect.x, y = destRect.y, c = selectedColor })  
        rectData = {}
        getImageViewer():editPixels(extractColor)
        getImageViewer():editPixels(addExtractedColor)
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
