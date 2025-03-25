return { 
    add = function(self, rect)
        local adjacentRect = self:findAdjacentRect(rect.x, rect.y)
        if adjacentRect == nil then
            self:addNewRect(rect)
        else
            adjacentRect.h = adjacentRect.h + 1
        end
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
                    table.insert(list, spriteRect)
                end
            end
        end

        return list
    end,
    
    elements = function(self)
        return ipairs(self:getWalkableRectList())
    end,

}
