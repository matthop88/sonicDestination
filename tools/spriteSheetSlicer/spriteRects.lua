return {
    rects = { 
        add = function(self, rect)
            table.insert(self, rect)
        end,
    },

    rectsGroupedByLeftX = {
        add = function(self, rect)
            local rectsWithLeftX = self:getRectsWithLeftX(rect.x)
            table.insert(rectsWithLeftX, rect)
        end,

        getRectsWithLeftX = function(self, x)
            self[x] = self[x] or { }
            return self[x]
        end,

        getRectAdjacentTo = function(self, rect)
            local rectsWithLeftX = self:getRectsWithLeftX(rect.x)

            for _, adjacentRect in ipairs(rectsWithLeftX) do
                if adjacentRect.y + adjacentRect.h == rect.y then
                    return adjacentRect
                end
            end
        end,
    },

    addLeftEdge = function(self, x, y)
        local rect         = { x = x, y = y, w = 50, h = 1 }
        local adjacentRect = self:getRectAdjacentTo(rect)

        if adjacentRect == nil then return self:addRect(rect)
        else                        return self:appendRectToAdjacentRect(adjacentRect, rect)
        end
    end,

    getRectAdjacentTo = function(self, rect)
        return self.rectsGroupedByLeftX:getRectAdjacentTo(rect)
    end,

    appendRectToAdjacentRect = function(self, adjacentRect, rect)
        adjacentRect.h = adjacentRect.h + rect.h
        return adjacentRect
    end,
        
    addRect = function(self, rect)
        self.rects:add(rect)
        self.rectsGroupedByLeftX:add(rect)
        return rect
    end,

    elements = function(self)
        return ipairs(self.rects)
    end,

    count = function(self)
        return #self.rects
    end,

    findEnclosingRect = function(self, imageX, imageY, whereFn)
        local smallestRect = nil
        local smallestArea = 250000
        for _, rect in self:elements() do
            if  imageX >= rect.x and imageX <= rect.x + rect.w - 1
            and imageY >= rect.y and imageY <= rect.y + rect.h - 1 then
                if not whereFn or whereFn(rect) then
                    local area = rect.w * rect.h
                    if area < smallestArea then
                        smallestArea = area
                        smallestRect = rect
                    end
                end
            end
        end

        return smallestRect
    end,
}
