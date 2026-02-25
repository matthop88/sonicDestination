return {
	create = function(self, params)
		return {
			graphics         = params.graphics,
			coordinateMaster = require("tools/constructionSet/coordinateMaster"),
			
			chunks = ({
				selected = nil,
				hidden   = { x = nil, y = nil },
				held     = nil,

				init = function(self)
					for i = 1, 256 do table.insert(self, {}) end
					return self
				end,

				add = function(self, obj, x, y)
					local row = self[y + 1]
					if #row <= x then
						for j = #row, x + 1 do table.insert(row, {}) end
					end
					row[x + 1] = { obj = obj, x = x, y = y }
				end,

				place = function(self, obj, x, y)
					if x < 0 or y < 0 or x > 255 or y > 255 then return end
					local wasHeld = self.held ~= nil
					self:releaseSelected()
					for r, row in ipairs(self) do
						for c, chunk in ipairs(row) do
							if chunk and chunk.obj == obj then
								self[r][c] = {}
							end
						end
					end
					self:add(obj, x, y)

					return wasHeld
				end,

				draw = function(self, graphics)
					for _, row in ipairs(self) do
						for _, chunk in ipairs(row) do
							if self:isChunkHidden(chunk) then graphics:setColor(0.3, 0.3, 0.3) 
							else                              graphics:setColor(1, 1, 1)   end

							if chunk.obj ~= nil and not self:isChunkHeld(chunk) then
								chunk.obj:draw(graphics, (chunk.x * 256), (chunk.y * 256))
							end
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
					if x < 0 or y < 0 or x > 255 or y > 255 then return end
					self:deselect()
					local chunk = self[y + 1][x + 1]
					if chunk and chunk.x == x and chunk.y == y and chunk.obj ~= nil then
						self.selected = chunk
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
			}):init(),

			objects = {
				objList = require("game/util/dataStructures/linkedList"):create(),  
    
				place = function(self, obj, x, y)
					if self.held and self.held.obj == obj then
						self.held.x, self.held.y = x, y
						self:releaseSelected()
						return true
					else
						self.objList:add { obj = obj, x = x, y = y }
					end
				end,

				draw = function(self, graphics)
					graphics:setColor(1, 1, 1)
					self.objList:forEach(function(o) 
						if o ~= self.held then
							o.obj:draw(graphics, o.x, o.y, 1, 1)
						end
					end)
					if self.selected then
						graphics:setColor(1, 1, 0)
						graphics:setLineWidth(2)
						graphics:rectangle("line", 
							self.selected.x - 2 - self.selected.obj:getW() / 2,
							self.selected.y - 2 - self.selected.obj:getH() / 2,
							self.selected.obj:getW() + 4,
							self.selected.obj:getH() + 4)
					end
				end,

				update = function(self, dt)
					self.objList:forEach(function(o) o.obj:update(dt) end)
				end,

				selectAt = function(self, x, y)
					self:deselect()
					local selectionMade = false
					self.objList:forEach(function(o) 
						if    x >= o.x - o.obj:getW() / 2 
						  and x <  o.x + o.obj:getW() / 2 
						  and y >= o.y - o.obj:getH() / 2 
						  and y <  o.y + o.obj:getH() / 2 then
						    self.selected = o
						    selectionMade = true
						end
					end)

					return selectionMade
				end,

				deselect = function(self)
					self.selected = nil
				end,

				deleteSelected = function(self)
					self.objList:forEach(function(o)
            			if self.selected == o then
                			self:deselect()
                			self.objList:remove()
                			return true
            			end
        			end)
				end,

				xFlipSelected = function(self)
					if self.selected then self.selected.obj:flipX() end
				end,

				nudgeSelected = function(self, x, y)
					if self.selected then self.selected.x, self.selected.y = self.selected.x + x, self.selected.y + y end
				end,

				holdSelected = function(self)
					if self.selected then
						self.held = self.selected
						return self.held.obj
					end
				end,

				releaseSelected = function(self)
					if self.held then self.held.obj:release() end
					self.held = nil
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
				if     key == "s"          then self:saveMap()
				elseif key == "escape"     then self:deselectAll()
				elseif key == "backspace"  then self:deleteSelected()
				elseif key == "x"          then self:xFlipSelected()
				elseif key == "shiftleft"  then self.objects:nudgeSelected(-1,  0)
				elseif key == "shiftright" then self.objects:nudgeSelected( 1,  0)
				elseif key == "shiftup"    then self.objects:nudgeSelected( 0, -1)
				elseif key == "shiftdown"  then self.objects:nudgeSelected( 0,  1)
				end
			end,

			selectAt = function(self, x, y)
				if not self.objects:selectAt(x, y) then
					self.chunks:selectAt(math.floor(x / 256), math.floor(y / 256))
				else
					self.chunks:deselect()
				end
			end,

			deselectAll    = function(self)  
				self.chunks:deselect()
				self.objects:deselect()            
			end,

			deleteSelected = function(self)  
				self.objects:deleteSelected()
				self.chunks:deleteSelected()      
			end,

			xFlipSelected  = function(self)  
				self.objects:xFlipSelected()
				self.chunks:xFlipSelected()       
			end,

			nudgeSelected = function(self, x, y)
				self.objects:nudgeSelected(x, y)
			end,

			holdSelected   = function(self)  
				local result = self.objects:holdSelected()
				return result or self.chunks:holdSelected()
			end,

			releaseSelected = function(self) 
				self.objects:releaseSelected()
				self.chunks:releaseSelected()     
			end,

			hideChunkAt = function(self, x, y)
				self.chunks:hideAt(math.floor(x / 256), math.floor(y / 256))
			end,

			placeChunk = function(self, chunk, x, y)
				return self.chunks:place(chunk, x, y)
			end,

			placeObject = function(self, obj, x, y)
				return self.objects:place(obj, x, y)
			end,

			update = function(self, dt)
				self.objects:update(dt)
			end,

			saveMap = function(self)
				print("return {")
				for n, row in ipairs(self.chunks) do
					if #row > 0 then
						local rowString = "  { row = " .. n .. ", data = { "
						for _, chunk in ipairs(row) do
							if chunk.obj then
								rowString = rowString .. chunk.obj:toString()
							else
								rowString = rowString .. "{}"
							end
							rowString = rowString .. ", "
						end
						print(rowString .. "} },")
					end
				end
				print("}")
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
