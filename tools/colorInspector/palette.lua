PALETTE      = { }
PALETTE_LEFT = WINDOW_WIDTH - 134

paletteInFocus = false

function isPaletteInFocus()
    return paletteInFocus
end

function drawPalette()
    local mx, my = love.mouse.getPosition()
   
    paletteInFocus = mx >= PALETTE_LEFT
    
    drawPaletteGrid()
    drawPaletteColors()
    highlightSelectedColor()
end

function drawPaletteGrid()
    love.graphics.setColor(calculatePaletteGridColor())
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", PALETTE_LEFT, 3, 132, WINDOW_HEIGHT - 6)
    drawPaletteGridLines()
end

function calculatePaletteGridColor()
    if isPaletteInFocus() then
        return COLOR.MEDIUM_GREY
    else
        return COLOR.TRANSPARENT_WHITE
    end
end

function drawPaletteGridLines()
    for i = 0, 8 do
        love.graphics.rectangle("line", PALETTE_LEFT,      (i * 66) + 3, 66, 66)
        love.graphics.rectangle("line", WINDOW_WIDTH - 68, (i * 66) + 3, 66, 66)
    end
end

function drawPaletteColors()
    for colorIndex, color in ipairs(PALETTE) do
        love.graphics.setColor(calculatePaletteColorToDraw(color))
        local x, y = calculateCoordinatesOfPaletteColor(colorIndex)
        love.graphics.rectangle("fill", x, y, 60, 60)
    end
end

function calculatePaletteColorToDraw(baseColor)
    if isPaletteInFocus() or baseColor == getSelectedColor() then
        return baseColor
    else
        return { baseColor[1], baseColor[2], baseColor[3], 0.2 }
    end
end

function calculateCoordinatesOfPaletteColor(colorIndex)
    local column = (colorIndex - 1) % 2
    local row    = math.floor((colorIndex - 1) / 2)

    local x = PALETTE_LEFT + (column * 66) + 3
    local y =                (row    * 66) + 6

    return x, y
end

function highlightSelectedColor()
    for i, color in ipairs(PALETTE) do
        local x, y = calculateCoordinatesOfPaletteColor(i)
        if color == getSelectedColor() then
            love.graphics.setColor(COLOR.YELLOW)
            love.graphics.setLineWidth(6)
            love.graphics.rectangle("line", x, y, 60, 60)
        end
    end
end

function insertColorIntoPalette(color)
    if not colorBelongsToPalette(color) then
        table.insert(PALETTE, color)
    end
end

function colorBelongsToPalette(color)
    for _, c in ipairs(PALETTE) do
        if c[1] == color[1] and c[2] == color[2] and c[3] == color[3] then
            return true
        end
    end
end

function selectPaletteColorAt(mx, my)
    local hIndex = math.floor((mx - PALETTE_LEFT) / 68)
    local vIndex = math.floor((my - 3           ) / 66)
    local selectedIndex = vIndex * 2 + hIndex + 1
    
    if PALETTE[selectedIndex] then
        setSelectedColor(PALETTE[selectedIndex])
    end
end
