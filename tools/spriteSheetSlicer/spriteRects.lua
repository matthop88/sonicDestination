return { 
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
                    if spriteRect.isExactColorMatch then
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
            and imageX >= rect.x and imageX <= rect.x + rect.w - 1
            and imageY >= rect.y and imageY <= rect.y + rect.h - 1 
            then 
                return rect 
            end
        end
    end,

    markExactColorMatch = function(self, rect)
        rect.isExactColorMatch = true
    end,

    getRectAt = function(self, x, y)
        for _, rect in ipairs(self:getRectsWithLeftX(x)) do
            if rect.y <= y and (rect.y + rect.h) >= y then
                return rect
            end
        end
    end,

}
