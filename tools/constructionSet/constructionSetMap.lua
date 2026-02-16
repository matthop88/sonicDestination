local CHUNKS, SOLIDS

return {
	create = function(self, params)
		return {
			graphics         = params.graphics,
			coordinateMaster = require("tools/constructionSet/coordinateMaster"),
			
			chunks = {
				place = function(self, chunkID, x, y, xFlipped)
					for n, chunk in ipairs(self) do
						if chunk.x == x and chunk.y == y then
							chunk.id = chunkID
							chunk.xFlipped = xFlipped
							return
						end
					end

					table.insert(self, { id = chunkID, x = x, y = y, xFlipped = xFlipped })
				end,

				draw = function(self, graphics)
					if CHUNKS then
						graphics:setColor(1, 1, 1)
						for _, chunk in ipairs(self) do
							if chunk.xFlipped then
								CHUNKS:drawAt(graphics, (chunk.x * 256) + 256, chunk.y * 256, chunk.id, -1, 1)
							else
								CHUNKS:drawAt(graphics, chunk.x * 256, chunk.y * 256, chunk.id, 1, 1)
							end
						end
					end
				end,
			},

			objects = {
				place = function(self, obj, x, y)
					table.insert(self, { obj = obj, x = x, y = y })
				end,

				draw = function(self, graphics)
					graphics:setColor(1, 1, 1)
					for _, object in ipairs(self) do
						object.obj:draw(graphics, object.x, object.y, 1, 1)
					end
				end,

				update = function(self, dt)
					for _, object in ipairs(self) do
						object.obj:update(dt)
					end
				end,
			},

			initChunkInfo = function(self, chunkInfo)
				CHUNKS = chunkInfo.chunks
				SOLIDS = chunkInfo.solids
			end,

			draw = function(self)
				self.chunks:draw(self.graphics)
				self.objects:draw(self.graphics)
			end,

			drawCoordinates = function(self)
				self.coordinateMaster:drawCoordinates(self.graphics)
			end,

			handleKeypressed = function(self, key)
				if key == "s" then
					print(self.graphics:getScale())
				end
			end,

			placeChunk = function(self, chunkID, x, y, xFlipped)
				self.chunks:place(chunkID, x, y, xFlipped)
			end,

			placeObject = function(self, obj, x, y)
				self.objects:place(obj, x, y)
			end,

			update = function(self, dt)
				self.objects:update(dt)
			end,
	
			---------------------- Graphics Object Methods ------------------------

		    moveImage = function(self, deltaX, deltaY)
		        self.graphics:moveImage(deltaX / self.graphics:getScale(), deltaY / self.graphics:getScale())
		    	--self.graphics:quantizeXY()
		    end,

		    screenToImageCoordinates = function(self, screenX, screenY)
		        return self.graphics:screenToImageCoordinates(screenX, screenY)
		    end,

		    imageToScreenCoordinates = function(self, imageX, imageY)
		        return self.graphics:imageToScreenCoordinates(imageX, imageY)
		    end,

		    adjustScaleGeometrically = function(self, deltaScale)
		        self.graphics:adjustScaleGeometrically(deltaScale)
		    end,

		    syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
		        self.graphics:syncImageCoordinatesWithScreen(imageX, imageY, screenX, screenY)
		    end,
		}
	end,

}
