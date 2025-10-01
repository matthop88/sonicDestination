return {
	create = function(self, mapData, chunkImg, chunks)
		return ({
			mapData  = mapData,
			chunkImg = chunkImg,
			chunks   = chunks,

			init = function(self)
				self.width, self.height = self:calculateImageArea()

				print("Creating a Map Image of dimensions " .. self.width .. "x" .. self.height .. "...")
				self.GRAFX = require("tools/lib/bufferedGraphics"):create(require("tools/lib/graphics"):create(), self.width, self.height)
				return self
			end,

			calculateImageArea = function(self)
				return #self.mapData[1] * 256, #self.mapData * 256
			end,

			save = function(self, filename)
				self:draw()
				return self.GRAFX:saveImage(filename)
			end,

			draw = function(self)
		        for rowNum, row in ipairs(self.mapData) do
		            local y = (rowNum - 1) * 256
		            for colNum, chunkID in ipairs(row) do
		                local x = (colNum - 1) * 256
		                self.GRAFX:setColor(1, 1, 1)
		                self.GRAFX:draw(self.chunkImg, self.chunks[chunkID], x, y, 0, 1, 1)    
		            end
		        end
		    end,

		}):init()
	end,
}
