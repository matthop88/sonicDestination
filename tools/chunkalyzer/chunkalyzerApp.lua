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
    GRAFX:draw(img, INSET, INSET)

    local mx, my = love.mouse.getPosition()
    local x, y   = GRAFX:screenToImageCoordinates(mx, my)
    x = (math.floor(x / 256) * 256) + INSET
    y = (math.floor(y / 256) * 256) + INSET

    GRAFX:setColor(1, 1, 1)
    GRAFX:setLineWidth(3)

    GRAFX:rectangle("line", x - 2, y - 2, 260, 260)
end

function love.update(dt)
    keepImageInBounds()
end

-- ...

--------------------------------------------------------------
--                   Specialized Functions                  --
--------------------------------------------------------------

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
    :add("zooming",      { imageViewer = GRAFX })
    :add("scrolling",    
    { 
        imageViewer = GRAFX,
        scrollSpeed = 3200,
    })

        
