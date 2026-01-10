return {
    sprites = require("tools/lib/dataStructures/linkedList"):create(),  
     
    draw = function(self, GRAFX)
        self.sprites:head()
        while not self.sprites:isEnd() do 
            local sprite = self.sprites:getNext()
            sprite:draw(GRAFX)
        end
    end,
    
    placeBadnik = function(self, newBadnik, GRAFX)
        self.sprites:add(newBadnik)
    end,
}
