return {
    badniks = require("tools/lib/dataStructures/linkedList"):create(),  
     
    selectedBadnik       = nil,
    consideredBadnik     = nil,
    externallyConsidered = nil,

    draw = function(self, GRAFX)
        self.badniks:forEach(function(badnik) badnik:draw(GRAFX) end)
    end,

    drawMouseOver = function(self, GRAFX)
        local c = self.consideredBadnik or self.externallyConsidered
        if c then
            GRAFX:setColor(0.5, 0.5, 1)
            GRAFX:setLineWidth(2)
            GRAFX:rectangle("line", c:getX() - (c:getW() / 2) - 2, c:getY() - (c:getH() / 2) - 2, c:getW() + 4, c:getH() + 4)
        end
    end,

    calculateMouseOver = function(self, GRAFX) 
        local x, y = GRAFX:screenToImageCoordinates(love.mouse.getPosition())

        self.consideredBadnik = nil

        self.badniks:forEach(function(badnik)
            if badnik:isInside(x, y) then
                self.consideredBadnik = badnik
                self.externallyConsidered = nil
                return true
            end
        end)
    end,

    update = function(self, dt, GRAFX)
        self:calculateMouseOver(GRAFX)
        self:badniks:forEach(function(badnik) badnik:update(dt) end)
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
        self.badniks:forEach(function(badnik)
            if badnik:isInside(x, y) then
                self:selectBadnik(badnik)
                return true
            end
        end)
    end,

    selectBadnik = function(self, badnik)
        self:deselect()
        badnik.selected     = true
        self.selectedBadnik = badnik
    end,

    deselect = function(self)
        if self.selectedBadnik then self.selectedBadnik.selected = false end
        self.selectedBadnik = nil
    end,

    deleteSelected = function(self)
        self.badniks:forEach(function(badnik)
            if self.selectedBadnik == badnik then
                self:deselect()
                self.badniks:remove()
                return true
            end
        end)
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
        self:selectBadnik(newBadnik)
    end,

    size    = function(self)     return  self.badniks:size()          end,
    remove  = function(self)      
        self.badniks:remove()  
        self.selectedBadnik = nil
        self.consideredBadnik = nil  
        self.externallyConsidered = nil    
    end,
    forEach       = function(self, fn)     return self.badniks:forEach(fn)     end,
    getSelected   = function(self)         return self.selectedBadnik          end,
    setSelected   = function(self, badnik) self.selectedBadnik = badnik        end,
    getConsidered = function(self)         return self.consideredBadnik        end,
    setConsidered = function(self, badnik) self.externallyConsidered = badnik  end,
}
