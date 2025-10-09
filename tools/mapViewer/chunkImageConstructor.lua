return {
	create = function(self, chunkData, tileImg)
		return ({
			chunkData = chunkData,
			tileImg   = tileImg,
			chunkImg  = nil,

			constructChunkImg = function(self)
				local width, height = self:calculateImageDimensions()

				return self:createImage(width, height)
			end,	

			calculateImageDimensions = function(self)
				local widthInChunks  = math.min(#self.chunkData, 9)
				local heightInChunks = math.floor((#self.chunkData - 1) / 9) + 1

				return widthInChunks * 256, heightInChunks * 256
			end,

			createImage = function(self, width, height)
				self.GRAFX = require("tools/lib/bufferedGraphics"):create(require("tools/lib/graphics"):create(), width, height)
				
				self:drawTiles(self:createTileArray())

				self.GRAFX.buffer:setFilter("nearest", "nearest")
				return self.GRAFX.buffer
			end,

			createTileArray = function(self)
				local tiles = {}
				local widthInTiles  = self.tileImg:getWidth()  / 16
				local heightInTiles = self.tileImg:getHeight() / 16

				local tileCount = widthInTiles * heightInTiles

				local x, y, baseX = 0, 0, 0

				for i = 1, tileCount do
					local quad = love.graphics.newQuad(x, y, 16, 16, self.tileImg:getWidth(), self.tileImg:getHeight())
					table.insert(tiles, quad)
					x = x + 16
					if x >= baseX + 256 then
						x = baseX
						y = y + 16
						if y >= 256 then
							y = 0
							baseX = baseX + 256
							x = baseX
						end
					end
				end

				return tiles
			end,

			drawTiles = function(self, tiles)
				local x, y = 0, 0
				for n, chunk in ipairs(self.chunkData) do
					x = ((n - 1) % 9) * 256
					y = math.floor((n - 1) / 9) * 256
					for _, row in ipairs(chunk) do
						self:drawRow(row, x, y, tiles)
						y = y + 16
					end
				end
			end,

			drawRow = function(self, row, x, y, tiles)
				for n, tileID in ipairs(row) do
					self.GRAFX:setColor(1, 1, 1)
					self.GRAFX:draw(self.tileImg, tiles[tileID], x, y, 0, 1, 1)
		            x = x + 16 
		        end
		    end,

		}):constructChunkImg()
	end,
}
