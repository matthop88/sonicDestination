return {
    badniks = require("tools/lib/dataStructures/linkedList"):create(),  
     
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
    
    placeBadnik = function(self, newBadnik, GRAFX)
        self.badniks:add(newBadnik)
    end,

}
