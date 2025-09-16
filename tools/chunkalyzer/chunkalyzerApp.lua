--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800
local INSET                       = 16
local GRAFX                       = require "tools/lib/graphics"

local imgPath

if __WORLD_MAP_FILE ~= nil then
    imgPath = "tools/chunkalyzer/data/" .. __WORLD_MAP_FILE .. ".png"
end

local imgData = love.image.newImageData(imgPath)
local img     = love.graphics.newImage(imgData)

local OFFSET  = { x = 0, y = 0 }

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
    drawWorldMap()
    drawCurrentChunk()
end

function love.update(dt)
    keepImageInBounds()
end

function love.keypressed(key)
    if     key == "optionleft"  then OFFSET.x = math.max(0,   OFFSET.x - 1)
    elseif key == "optionright" then OFFSET.x = math.min(128, OFFSET.x + 1)
    elseif key == "optionup"    then OFFSET.y = math.max(0,   OFFSET.y - 1)
    elseif key == "optiondown"  then OFFSET.y = math.min(128, OFFSET.y + 1)
    end
end

function love.mousepressed(mx, my)
    local cX, cY = getChunkXY(mx, my)
    printToReadout("Clicked on Chunk { x = " .. cX .. ", y = " .. cY .. "}")
end

--------------------------------------------------------------
--                   Specialized Functions                  --
--------------------------------------------------------------

function drawWorldMap()
    GRAFX:setColor(1, 1, 1)
    GRAFX:draw(img, INSET, INSET)
end

function drawCurrentChunk()
    local cX, cY = getChunkXY(love.mouse.getPosition())
    local x,  y  = getWorldCoordinatesOfChunk(cX, cY)

    if love.mouse.isDown(1) then drawChunkSelection(x, y)
    else                         drawChunkOutline(  x, y) end
end

function getChunkXY(x, y)
    local imgX, imgY = GRAFX:screenToImageCoordinates(x, y)
    return math.floor(imgX / 256), math.floor(imgY / 256)
end

function getWorldCoordinatesOfChunk(cX, cY)
    return (cX * 256) + INSET + OFFSET.x, (cY * 256) + INSET + OFFSET.y
end

function drawChunkSelection(x, y)
    GRAFX:setColor(1, 1, 0, 0.7)
    GRAFX:rectangle("fill", x, y, 256, 256)
end

function drawChunkOutline(x, y)
    GRAFX:setColor(1, 1, 1)
    GRAFX:setLineWidth(3)
    GRAFX:rectangle("line", x - 2, y - 2, 260, 260)
end

function keepImageInBounds()
    GRAFX.x = math.min(0, math.max(GRAFX.x, (love.graphics:getWidth()  / GRAFX.scale) - getPageWidth()))
    GRAFX.y = math.min(0, math.max(GRAFX.y, (love.graphics:getHeight() / GRAFX.scale) - getPageHeight()))
end

function getPageWidth()  return img:getWidth()  + (INSET * 2) end
function getPageHeight() return img:getHeight() + (INSET * 2) end

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("zooming",      { imageViewer = GRAFX })
    :add("scrolling",    
    { 
        imageViewer   = GRAFX,
        scrollSpeed   = 3200,
    })
    :add("readout",
    {
        printFnName   = "printToReadout",
        echoToConsole = true,
    })

        
