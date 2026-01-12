return {
    badniks = require("tools/lib/dataStructures/linkedList"):create(),  
     
    draw = function(self, GRAFX)
        self.badniks:head()
        while not self.badniks:isEnd() do 
            local badnik = self.badniks:getNext()
            badnik:draw(GRAFX)
        end
    end,
    
    placeBadnik = function(self, newBadnik, GRAFX)
        self.badniks:add(newBadnik)
    end,
}
