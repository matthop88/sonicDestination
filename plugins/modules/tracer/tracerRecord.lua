return {
    EVENT_LIMIT = 256,

    create = function(self, color)
        return {
            EVENT_LIMIT = self.EVENT_LIMIT,
            headIndex   = 1,

            color   = color,

            records = { },

            getColor = function(self)        return self.color           end,
            size     = function(self)        return #self.records        end,
            get      = function(self, index) return self.records[index]  end,

        	getNth   = function(self, n)
                local i = n + self.headIndex - 1
                
        		if i > self:size() then i = i - self:size() end
                
        		return self:get(i)
            end,

            each     = function(self)
                local n = 0
                
                return function()
                    n = n + 1
                    if n <= self:size() then
                        local v = self:getNth(n)
                        if v then
                            return n, v
                        end
                    end
                end
            end,
        	
            clear  = function(self)        
                self.records = {}           
                self.headIndex = 1
            end,
            
            add    = function(self, x, y, r)
                local newEvent    = { x = math.floor(x), y = math.floor(y), r = math.floor(r) }
                if self:size() < self.EVENT_LIMIT then
                    table.insert(self.records, newEvent)
                else
        			self.records[self.headIndex] = newEvent
                    self:incrementHeadIndex()
                end
            end,

            canAdd = function(self, x, y, r)
                local tailEvent = self:getTail()
                return self:size() == 0 
                    or tailEvent.x ~= math.floor(x) 
                    or tailEvent.y ~= math.floor(y) 
                    or tailEvent.r ~= math.floor(r)
            end,

            getTail = function(self)
                return self:get(self:getTailIndex())
            end,

        	getTailIndex = function(self)
        		local tailIndex = self.headIndex - 1
        		if tailIndex < 1 then
        			tailIndex = self:size()
        		end
        		return tailIndex
        	end,

            incrementHeadIndex = function(self)
                self.headIndex = self.headIndex + 1
                if self.headIndex > self:size() then
                    self.headIndex = 0
                end
            end,
        }
    end,
}
