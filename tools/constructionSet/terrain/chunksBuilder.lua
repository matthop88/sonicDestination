return {
    create = function(self, chunksImage, chunkCount)
        return ({
            init = function(self, chunksImage)
    	        self.image = chunksImage
                self.data  = {}

	            for i = 1, chunkCount do
	                local chunkX = ((i - 1) % 9)           * 256
	                local chunkY = math.floor((i - 1) / 9) * 256
	            
	                table.insert(self.data, love.graphics.newQuad(chunkX, chunkY, 256, 256, self.image:getWidth(), self.image:getHeight()))
	            end
	    
                return self
            end,

            get = function(self, chunkID)
    	        return self.data[chunkID]
            end,

            size = function(self)
                return #self.data
            end,

            draw = function(self, graphics, rowNum, colNum, chunkID)
    	        local y = (rowNum - 1) * 256
                local x = (colNum - 1) * 256

		        graphics:setColor(1, 1, 1)
    	        graphics:draw(self.image, self:get(chunkID), x, y, 0, 1, 1)
	        end,

            drawAt = function(self, graphics, chunkID, x, y)
                graphics:draw(self.image, self:get(chunkID), x, y, 0, 1, 1)
            end,

        }):init(chunksImage)
    end,
}
