return { 
    addSlice = function(self, x, y, hasValidLeftBorder)
        local resultingRect = self:add({ x = x, y = y, w = 50, h = 1 })
        
        if hasValidLeftBorder then
            self:markAsHavingValidLeftBorder(resultingRect)
        end
        
        return resultingRect
    end,
    
    add = function(self, rect)
        local concatenatedRect = self:updateAdjacentRect(rect)
        if not concatenatedRect then
            self:addNewRect(rect)
        end
        return concatenatedRect or rect
    end,

    updateAdjacentRect = function(self, rect)
        local adjacentRect = self:findAdjacentRect(rect.x, rect.y)
        if adjacentRect ~= nil then
            adjacentRect.h = adjacentRect.h + 1
        end
        return adjacentRect
    end,

    findAdjacentRect = function(self, x, y)
        for _, rect in ipairs(self:getRectsWithLeftX(x)) do
            if rect.y + rect.h == y then
                return rect
            end
        end
    end,

    addNewRect = function(self, rect)
        table.insert(self:getRectsWithLeftX(rect.x), rect)
    end,

    getRectsWithLeftX = function(self, x)
        if self[x] == nil then self[x] = {} end
        return self[x]
    end,

    getWalkableRectList = function(self)
        self.walkableList = self.walkableList or self:createWalkableList()
        return self.walkableList
    end,

    createWalkableList = function(self)
        local list = {}

        for _, spriteRects in pairs(self) do
            if type(spriteRects) ~= "function" then
                for _, spriteRect in ipairs(spriteRects) do
                    if spriteRect.hasValidLeftBorder then
                        table.insert(list, spriteRect)
                    end
                end
            end
        end

        return list
    end,
    
    elements = function(self)
        return ipairs(self:getWalkableRectList())
    end,

    findEnclosingRect = function(self, imageX, imageY)
        for _, rect in self:elements() do
            if  rect ~= nil 
            and self:ptInRect(x, y, rect) then
                return rect
            end
        end
    end,

    ptInRect = function(x, y, rect)
        return  x >= rect.x 
            and x <= rect.x + rect.w - 1
            and y >= rect.y
            and y <= rect.y + rect.h - 1
    end,

    markAsHavingValidLeftBorder = function(self, rect)
        rect.hasValidLeftBorder = true
    end,

    updateSpriteWidth = function(self, x, y, rightX)
        if x ~= nil then
            local spriteRect = self:getRectAt(x, y)
            if spriteRect ~= nil then
                spriteRect.w = rightX - x
            end
        end
    end,

    getRectAt = function(self, x, y)
        for _, rect in ipairs(self:getRectsWithLeftX(x)) do
            if rect.y <= y and (rect.y + rect.h) >= y then
                return rect
            end
        end
    end,

}
