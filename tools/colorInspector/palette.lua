require "tools/colorInspector/color"

PALETTE = {
    paletteTable   = { },
    PALETTE_LEFT   = WINDOW_WIDTH - 134,
    paletteInFocus = false,

    isPaletteInFocus = function(self)
        return self.paletteInFocus
    end,

    drawPalette = function(self)
        local mx, my   = love.mouse.getPosition()
        self.paletteInFocus = mx >= self.PALETTE_LEFT
    
        self:drawPaletteGrid()
        self:drawPaletteColors()
        self:highlightSelectedColor()
    end,

    drawPaletteGrid = function(self)
        love.graphics.setColor(self:calculatePaletteGridColor())
        love.graphics.setLineWidth(3)
        love.graphics.rectangle("line", self.PALETTE_LEFT, 3, 132, WINDOW_HEIGHT - 6)
        self:drawPaletteGridLines()
    end,

    calculatePaletteGridColor = function(self)
        if self:isPaletteInFocus() then return COLOR.MEDIUM_GREY
        else                            return COLOR.TRANSPARENT_WHITE
        end
    end,

    drawPaletteGridLines = function(self)
        for i = 0, 8 do
            love.graphics.rectangle("line", self.PALETTE_LEFT,      (i * 66) + 3, 66, 66)
            love.graphics.rectangle("line", WINDOW_WIDTH - 68,      (i * 66) + 3, 66, 66)
        end
    end,

    drawPaletteColors = function(self)
        for colorIndex, color in ipairs(self.paletteTable) do
            love.graphics.setColor(self:calculatePaletteColorToDraw(color))
            local x, y = self:calculateCoordinatesOfPaletteColor(colorIndex)
            love.graphics.rectangle("fill", x, y, 60, 60)
        end
    end,

    calculatePaletteColorToDraw = function(self, baseColor)
        if self:isPaletteInFocus() or compareColors(baseColor, getSelectedColor()) then
            return baseColor
        else
            return { baseColor[1], baseColor[2], baseColor[3], 0.2 }
        end
    end,

    calculateCoordinatesOfPaletteColor = function(self, colorIndex)
        local column = (colorIndex - 1) % 2
        local row    = math.floor((colorIndex - 1) / 2)
    
        local x = self.PALETTE_LEFT + (column * 66) + 3
        local y =                     (row    * 66) + 6
    
        return x, y
    end,

    highlightSelectedColor = function(self)
        for i, color in ipairs(self.paletteTable) do
            local x, y = self:calculateCoordinatesOfPaletteColor(i)
            if compareColors(color, getSelectedColor()) then
                love.graphics.setColor(COLOR.YELLOW)
                love.graphics.setLineWidth(6)
                love.graphics.rectangle("line", x, y, 60, 60)
            end
        end
    end,

    insertColorIntoPalette = function(self, color)
        if not self:colorBelongsToPalette(color) then
            table.insert(self.paletteTable, color)
        end
    end,

    colorBelongsToPalette = function(self, color)
        for _, c in ipairs(self.paletteTable) do
            if compareColors(c, color) then return true end
        end
    end,

    selectPaletteColorAt = function(self, mx, my)
        local hIndex = math.floor((mx - self.PALETTE_LEFT) / 68)
        local vIndex = math.floor((my - 3                ) / 66)
        local selectedIndex = vIndex * 2 + hIndex + 1
    
        if self.paletteTable[selectedIndex] then
            setSelectedColor(self.paletteTable[selectedIndex])
        end
    end
}
