return {
    create = function(self, chunksImage)
        return ({
            init = function(self, chunksImage)
    	        self.image = chunksImage
                self.data  = {}

	            local chunkCount = self:calculateChunkCount()
	            for i = 1, chunkCount do
	                local chunkX = ((i - 1) % 9)           * 256
	                local chunkY = math.floor((i - 1) / 9) * 256
	            
	                table.insert(self.data, love.graphics.newQuad(chunkX, chunkY, 256, 256, self.image:getWidth(), self.image:getHeight()))
	            end
	    
                return self
            end,

            calculateChunkCount = function(self)
                local width, height = self.image:getWidth(), self.image:getHeight()

                return math.floor(width / 256) * math.floor(height / 256)
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
