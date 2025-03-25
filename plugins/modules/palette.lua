require "plugins/libraries/color"

return {
    --[[
        Depends upon these initialization parameters:
        -------------------------------------------------------
        colorSelectorFn -> Color Selector object, with methods
                           get(), set() and
                           selectFromImageAt(mx, my)
                           (Latter is a poorly-coupled dependency)
        -------------------------------------------------------
    --]]
    
    table       = { },
    LEFT_BORDER = love.graphics:getWidth() - 134,
    inFocus     = false,

    init = function(self, params)
        self.refreshColorSelector = params.colorSelectorFn
        return self
    end,
    
    isInFocus = function(self)
        return self.inFocus
    end,

    draw = function(self)
        local mx, my = love.mouse.getPosition()
        self.inFocus = mx >= self.LEFT_BORDER
    
        self:drawGrid()
        self:drawColors()
        self:highlightSelectedColor()
    end,

    drawGrid = function(self)
        love.graphics.setColor(self:calculateGridColor())
        love.graphics.setLineWidth(3)
        love.graphics.rectangle("line", self.LEFT_BORDER, 3, 132, WINDOW_HEIGHT - 6)
        self:drawGridLines()
    end,

    calculateGridColor = function(self)
        if self:isInFocus() then return COLOR.MEDIUM_GREY
        else                     return COLOR.TRANSPARENT_WHITE
        end
    end,

    drawGridLines = function(self)
        for i = 0, 8 do
            love.graphics.rectangle("line", self.LEFT_BORDER,         (i * 66) + 3, 66, 66)
            love.graphics.rectangle("line", WINDOW_WIDTH - 68,        (i * 66) + 3, 66, 66)
        end
    end,

    drawColors = function(self)
        for colorIndex, color in ipairs(self.table) do
            love.graphics.setColor(self:calculateColorToDraw(color))
            local x, y = self:calculateCoordinatesOfColor(colorIndex)
            love.graphics.rectangle("fill", x, y, 60, 60)
        end
    end,

    calculateColorToDraw = function(self, baseColor)
        if self:isInFocus() or compareColors(baseColor, self.selectedColor:get()) then
            return baseColor
        else
            return { baseColor[1], baseColor[2], baseColor[3], 0.2 }
        end
    end,

    calculateCoordinatesOfColor = function(self, colorIndex)
        local column = (colorIndex - 1) % 2
        local row    = math.floor((colorIndex - 1) / 2)
    
        local x = self.LEFT_BORDER + (column * 66) + 3
        local y =                    (row    * 66) + 6
    
        return x, y
    end,

    highlightSelectedColor = function(self)
        for i, color in ipairs(self.table) do
            local x, y = self:calculateCoordinatesOfColor(i)
            if compareColors(color, self.selectedColor:get()) then
                love.graphics.setColor(COLOR.YELLOW)
                love.graphics.setLineWidth(6)
                love.graphics.rectangle("line", x, y, 60, 60)
            end
        end
    end,

    insertColor = function(self, color)
        if not self:colorBelongs(color) then
            table.insert(self.table, color)
        end
    end,

    colorBelongs = function(self, color)
        for _, c in ipairs(self.table) do
            if compareColors(c, color) then return true end
        end
    end,

    selectColorAt = function(self, mx, my)
        local hIndex = math.floor((mx - self.LEFT_BORDER) / 68)
        local vIndex = math.floor((my - 3               ) / 66)
        local selectedIndex = vIndex * 2 + hIndex + 1
    
        if self.table[selectedIndex] then
            self.selectedColor:set(self.table[selectedIndex])
        end
    end,

    update = function(self, dt)
        self.LEFT_BORDER   = love.graphics:getWidth() - 134
        self.selectedColor = self:refreshColorSelector()
    end,

    handleMousepressed = function(self, mx, my)
        if self:isInFocus() then self:selectColorAt(mx, my)
        else                     self.selectedColor:selectFromImageAt(mx, my)
        end

        self:insertColor(self.selectedColor:get())
    end,
}
