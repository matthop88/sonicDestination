------------------ LOCALS -----------------

local IMAGE_DATA = love.image.newImageData("resources/images/sadNoFileImage.png")

if __INSPECTOR_FILE ~= nil then
    IMAGE_DATA = love.image.newImageData("resources/images/spriteSheets/" .. __INSPECTOR_FILE .. ".png")
end

local IMAGE = love.graphics.newImage(IMAGE_DATA)

---------------- FUNCTIONS ----------------

function getImageWidth()
    return IMAGE:getWidth()
end

function getImageHeight()
    return IMAGE:getHeight()
end

function getImagePixelAt(x, y)
    return IMAGE_DATA:getPixel(x, y)
end

function drawImage()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(IMAGE, x * scale, y * scale, 0, scale, scale)
end

function updateImage()
    if isMotionless() then keepImageInBounds() end
end

function keepImageInBounds()
    x = math.min(0, math.max(x, (WINDOW_WIDTH  / scale) - IMAGE:getWidth()))
    y = math.min(0, math.max(y, (WINDOW_HEIGHT / scale) - IMAGE:getHeight()))
end
