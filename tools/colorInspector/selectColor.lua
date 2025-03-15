require "tools/colorInspector/color"

local selectedColor = nil

function selectImageColorAt(mx, my)
    selectedColor = identifyImageColor(mx, my)
end

function setSelectedColor(color)
    selectedColor = color
end

function getSelectedColor()
    return selectedColor
end

function clearSelectedColor()
    selectedColor = nil
end

function identifyImageColor(mx, my)
    local imageX = math.min(getImageWidth()  - 1, math.floor((mx / scale) - x))
    local imageY = math.min(getImageHeight() - 1, math.floor((my / scale) - y))
    
    local r, g, b = getImagePixelAt(imageX, imageY)
    
    print(string.format("{ %.2f, %.2f, %.2f }", r, g, b))
    printToReadout(string.format("R = %s, G = %s, B = %s", love.math.colorToBytes(r, g, b)))
    
    return { r, g, b }
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
