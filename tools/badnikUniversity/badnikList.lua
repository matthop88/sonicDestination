return {
    badniks = require("tools/lib/dataStructures/linkedList"):create(),  
     
    selectedBadnik = nil,

    draw = function(self, GRAFX)
        self.badniks:head()
        while not self.badniks:isEnd() do 
            local badnik = self.badniks:getNext()
            badnik:draw(GRAFX)
        end
    end,

    drawMouseOver = function(self, GRAFX)
        local x, y = GRAFX:screenToImageCoordinates(love.mouse.getPosition())

        self.badniks:head()
        while not self.badniks:isEnd() do 
            local badnik = self.badniks:getNext()
            if badnik:isInside(x, y) then
                GRAFX:setColor(0.5, 0.5, 1)
                GRAFX:setLineWidth(2)
                GRAFX:rectangle("line", badnik:getX() - (badnik:getW() / 2) - 2, badnik:getY() - (badnik:getH() / 2) - 2, badnik:getW() + 4, badnik:getH() + 4)
            end
        end
    end,

    update = function(self, dt)
        self.badniks:head()
        while not self.badniks:isEnd() do 
            local badnik = self.badniks:get()
            if badnik.deleted then
                if self.selectedBadnik  and self.selectedBadnik.deleted  then self:deselect()      end
                self.badniks:remove() 
            else                   
                self.badniks:next()   
            end
        end
    end,

    nudgeSelected = function(self, dx, dy)
        if self.selectedBadnik then
            self.selectedBadnik:setX(self.selectedBadnik:getX() + dx)
            self.selectedBadnik:setY(self.selectedBadnik:getY() + dy)
        end
    end,

    selectBadnikAt = function(self, mx, my, GRAFX)
        local x, y = GRAFX:screenToImageCoordinates(love.mouse.getPosition())

        self:deselect()
        self.badniks:head()
        while not self.badniks:isEnd() do 
            local badnik = self.badniks:getNext()
            if badnik:isInside(x, y) then
                self.selectedBadnik = badnik
            end
        end
    end,

    deselect = function(self)
        self.selectedBadnik = nil
    end,

    deleteSelected = function(self)
        if self.selectedBadnik then self.selectedBadnik.deleted = true end
    end,

    drawSelected = function(self, GRAFX)
        local badnik = self.selectedBadnik
        if badnik ~= nil then
            GRAFX:setColor(1, 1, 1)
            GRAFX:setLineWidth(2)
            GRAFX:rectangle("line", badnik:getX() - (badnik:getW() / 2) - 2, badnik:getY() - (badnik:getH() / 2) - 2, badnik:getW() + 4, badnik:getH() + 4)
        end
    end,

    flipSelected = function(self)
        if self.selectedBadnik then self.selectedBadnik:flipX() end
    end,
    
    placeBadnik = function(self, newBadnik, GRAFX)
        self.badniks:add(newBadnik)
        self.selectedBadnik = newBadnik
    end,

    getList = function(self) return self.badniks end,

}
