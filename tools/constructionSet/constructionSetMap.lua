return {
	create = function(self, params)
		return {
			graphics         = params.graphics,
			coordinateMaster = require("tools/constructionSet/coordinateMaster"),
			
			chunks = {
				selected = nil,
				hidden   = { x = nil, y = nil },
				held     = nil,

				place = function(self, obj, x, y)
					local wasHeld = self.held ~= nil
					self:releaseSelected()
					local replaced = false
					for n, chunk in ipairs(self) do
						if chunk.obj == obj then
							chunk.obj = nil
						elseif chunk.x == x and chunk.y == y then
							chunk.obj = obj
							replaced = true
						end
					end

					if not replaced then
						table.insert(self, { obj = obj, x = x, y = y })
					end

					return replaced or wasHeld
				end,

				draw = function(self, graphics)
					graphics:setColor(1, 1, 1)
					for _, chunk in ipairs(self) do
						if chunk.obj ~= nil and not self:isChunkHeld(chunk) and not self:isChunkHidden(chunk) then
							chunk.obj:draw(graphics, (chunk.x * 256), (chunk.y * 256))
						end
					end

					if self.selected and self.selected.obj ~= nil then
						graphics:setColor(1, 1, 1, 0.3)
						graphics:rectangle("fill", self.selected.x * 256, self.selected.y * 256, 256, 256)
						graphics:setColor(1, 1, 0)
						graphics:setLineWidth(5)
						graphics:rectangle("line", (self.selected.x * 256) - 2, (self.selected.y * 256) - 2, 260, 260)
					end
				end,

				selectAt = function(self, x, y)
					self:deselect()
					for _, chunk in ipairs(self) do
						if chunk.x == x and chunk.y == y and chunk.obj ~= nil then
							self.selected = chunk
							break
						end
					end
				end,

				deleteSelected = function(self)
					if self.selected then self.selected.obj = nil end
					self:deselect()
				end,

				xFlipSelected = function(self)
					if self.selected and self.selected.obj ~= nil then self.selected.obj:flipX() end
				end,

				holdSelected = function(self)
					if self.selected and self.selected.obj ~= nil then
						self.held = self.selected
						return self.held.obj
					end
				end,

				releaseSelected = function(self)
					if self.held then self.held.obj:release() end
					self.held = nil
				end,

				hideAt = function(self, x, y)
					self.hidden.x, self.hidden.y = x, y
				end,

				isChunkHidden = function(self, chunk)
					return chunk.x == self.hidden.x and chunk.y == self.hidden.y
				end,

				isChunkHeld = function(self, chunk)
					return self.held == chunk
				end,

				deselect = function(self)
					self.selected = nil
					self.hidden   = { x = nil, y = nil }
				end,

				report = function(self)
					for n, chunk in ipairs(self) do
						local obj = "nil"
						if chunk.obj then obj = chunk.obj.chunkID end
						print(n .. ": { obj = " .. obj .. ", x = " .. chunk.x .. ", y = " .. chunk.y .. " }")
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

			draw = function(self)
				self.chunks:draw(self.graphics)
				self.objects:draw(self.graphics)
			end,

			drawCoordinates = function(self)
				self.coordinateMaster:drawCoordinates(self.graphics)
			end,

			handleKeypressed = function(self, key)
				if     key == "s"         then print(self.graphics:getScale())
				elseif key == "escape"    then self:deselectAll()
				elseif key == "backspace" then self:deleteSelected()
				elseif key == "x"         then self:xFlipSelected()
				elseif key == "c"         then self.chunks:report()
				end
			end,

			selectAt = function(self, x, y)
				self.chunks:selectAt(math.floor(x / 256), math.floor(y / 256))
			end,

			deselectAll    = function(self)  self.chunks:deselect()            end,
			deleteSelected = function(self)  self.chunks:deleteSelected()      end,
			xFlipSelected  = function(self)  self.chunks:xFlipSelected()       end,
			holdSelected   = function(self)  return self.chunks:holdSelected() end,
			releaseSelected = function(self) self.chunks:releaseSelected()     end,

			hideChunkAt = function(self, x, y)
				self.chunks:hideAt(math.floor(x / 256), math.floor(y / 256))
			end,

			placeChunk = function(self, chunk, x, y)
				return self.chunks:place(chunk, x, y)
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
