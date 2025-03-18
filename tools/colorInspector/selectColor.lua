require "tools/colorInspector/color"

local selectedColor = nil

function selectImageColorAt(mx, my)
    selectedColor = identifyImageColor(mx, my)
    printSelectedColor()
end

function setSelectedColor(color)
    selectedColor = color
    printSelectedColor()
end

function getSelectedColor()
    return selectedColor
end

function clearSelectedColor()
    selectedColor = nil
end

function identifyImageColor(mx, my)
    local imageX, imageY = IMAGE_VIEWER:screenToImageCoordinates(mx, my)
    local r, g, b        = IMAGE_VIEWER:getImagePixelAt(imageX, imageY)
    
    return { r, g, b }
end

function printSelectedColor()
    local r, g, b = unpack(selectedColor)
    print(string.format("{ %.2f, %.2f, %.2f }", r, g, b))
    printToReadout(string.format("R = %s, G = %s, B = %s", love.math.colorToBytes(r, g, b)))
end

function drawSelectedColor()
    if selectedColor ~= nil then
        local mx, my = love.mouse.getPosition()
        love.graphics.setColor(selectedColor)
        love.graphics.rectangle("fill", mx - 50, my - 50, 100, 100)
        love.graphics.setLineWidth(3)
        love.graphics.setColor(COLOR.JET_BLACK)
        love.graphics.rectangle("line", mx - 50, my - 50, 100, 100)
    end
end
