return {
	create = function(self, params)
		local widthInChunks  = params.w        or 256
		local heightInChunks = params.h        or 256
		local chunkWidth     = params.chunkW   or 256
		local chunkHeight    = params.chunkH   or 256
		local chunks         = params.chunks
		local chunkIDs       = params.chunkIDs or { 1 }

		local chunkMap       = self:createChunkMap(widthInChunks, heightInChunks)

		return {
			width       = widthInChunks,
			height      = heightInChunks,
			chunkWidth  = chunkWidth,
			chunkHeight = chunkHeight,
			CHUNKS      = chunks,
			chunkIDs    = chunkIDs,
			chunkIndex  = 1,
			chunkMap    = chunkMap,

			draw = function(self, GRAFX)
				GRAFX:setColor(1, 1, 1)
    			for i = 1, self.height do
        			local c = self.chunkMap[i]
        			for j = 1, self.width do
            			if c[j] ~= 0 then
                			self.CHUNKS:drawAt(GRAFX, c[j], (j - 1) * self.chunkWidth, (i - 1) * self.chunkHeight)
                		end
                	end
                end
            end,

            drawMouseChunk = function(self, GRAFX)
        		local x, y = GRAFX:screenToImageCoordinates(love.mouse.getPosition())
        		GRAFX:rectangle("line", 
        			x - (self.chunkWidth / 2), y - (self.chunkHeight / 2), self.chunkWidth, self.chunkHeight)
        		GRAFX:setColor(1, 1, 1, 0.8)
            	self.CHUNKS:drawAt(GRAFX, self.chunkIDs[self.chunkIndex], 
            		x - (self.chunkWidth / 2), y - (self.chunkHeight / 2))
    		end,

    		placeChunk = function(self, GRAFX, mx, my)
    			local x, y = GRAFX:screenToImageCoordinates(mx, my)
        		local j, i = math.floor(x / self.chunkWidth) + 1, math.floor(y / self.chunkHeight) + 1
        		self.chunkMap[i][j] = self.chunkIDs[self.chunkIndex]
        	end,

        	incrementChunk = function(self)
        		self.chunkIndex = self.chunkIndex + 1
        		if self.chunkIndex > #self.chunkIDs then self.chunkIndex = 1 end
        	end,

        	decrementChunk = function(self)
        		self.chunkIndex = self.chunkIndex - 1
        		if self.chunkIndex < 1              then self.chunkIndex = #self.chunkIDs end
        	end,

        	printChunkIndex = function(self)
        		print(self.chunkIndex)
        	end,
		}
	end,

	createChunkMap = function(self, widthInChunks, heightInChunks)
		local chunkMap = {}

		for i = 1, heightInChunks do
		    local c = {}
		    for j = 1, widthInChunks do table.insert(c, 0) end
		    table.insert(chunkMap, c)
		end

		return chunkMap
	end,
}
