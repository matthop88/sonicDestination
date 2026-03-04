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
					for r, row in ipairs(self) do
						for c, chunk in ipairs(row) do
							if chunk and chunk.obj == obj then
								self[r][c] = {}
							end
						end
					end
					obj:release()
					self:add(obj, x, y)
					if self.held then
						self:releaseSelected()
						return true
					end
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
						self:releaseSelected()
						self:add(obj, x, y)
						return true
					else
						self:add(obj, x, y)
					end
				end,

				add = function(self, obj, x, y)
					self.objList:add { obj = obj, x = x, y = y }
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
						self:deleteSelected()
						return self.held.obj
					end
				end,

				releaseSelected = function(self)
					if self.held then self.held.obj:release() end
					self.held = nil
				end,

				forEach = function(self, fn)
					self.objList:forEach(fn)
				end,

			},

			player = {
				obj = nil,
				x = nil,
				y = nil,
				selected = false,
				held = nil,

				place = function(self, obj, x, y)
					self.obj = obj
					self.x = x
					self.y = y
					self.selected = false
					self.held = nil
					obj:release()
					return true
				end,

				selectAt = function(self, x, y)
					if not self.obj then return false end
					
					if    x >= self.x - self.obj:getW() / 2 
					  and x <  self.x + self.obj:getW() / 2 
					  and y >= self.y - self.obj:getH() / 2 
					  and y <  self.y + self.obj:getH() / 2 then
						self.selected = true
						return true
					end
					return false
				end,

				deselect = function(self)
					self.selected = false
				end,

				deleteSelected = function(self)
					if self.selected then
						self.obj = nil
						self.x = nil
						self.y = nil
						self.selected = false
					end
				end,

				xFlipSelected = function(self)
					if self.selected and self.obj then
						self.obj:flipX()
					end
				end,

				nudgeSelected = function(self, dx, dy)
					if self.selected and self.obj then
						self.x = self.x + dx
						self.y = self.y + dy
					end
				end,

				holdSelected = function(self)
					if self.selected and self.obj then
						self.held = { obj = self.obj, x = self.x, y = self.y }
						self.selected = false
						return self.held.obj
					end
				end,

				releaseSelected = function(self)
					if self.held then
						self.held.obj:release()
					end
					self.held = nil
				end,

				draw = function(self, graphics)
					if self.obj and not self.held then
						graphics:setColor(1, 1, 1)
						self.obj:draw(graphics, self.x, self.y, 1, 1)
						
						if self.selected then
							graphics:setColor(1, 1, 0)
							graphics:setLineWidth(2)
							graphics:rectangle("line", 
								self.x - 2 - self.obj:getW() / 2,
								self.y - 2 - self.obj:getH() / 2,
								self.obj:getW() + 4,
								self.obj:getH() + 4)
						end
					end
				end,

				update = function(self, dt)
					if self.obj then
						self.obj:update(dt)
					end
				end,
			},

			draw = function(self)
				self.chunks:draw(self.graphics)
				self.objects:draw(self.graphics)
				self.player:draw(self.graphics)
			end,

			drawCoordinates = function(self)
				self.coordinateMaster:drawCoordinates(self.graphics)
			end,

			handleKeypressed = function(self, key)
				if     key == "escape"     then self:deselectAll()
				elseif key == "backspace"  then self:deleteSelected()
				elseif key == "x"          then self:xFlipSelected()
				elseif key == "shiftleft"  then self:nudgeSelected(-1,  0)
				elseif key == "shiftright" then self:nudgeSelected( 1,  0)
				elseif key == "shiftup"    then self:nudgeSelected( 0, -1)
				elseif key == "shiftdown"  then self:nudgeSelected( 0,  1)
				end
			end,

			selectAt = function(self, x, y)
				if self.player:selectAt(x, y) then
					self.objects:deselect()
					self.chunks:deselect()
				elseif self.objects:selectAt(x, y) then
					self.player:deselect()
					self.chunks:deselect()
				else
					self.player:deselect()
					self.objects:deselect()
					self.chunks:selectAt(math.floor(x / 256), math.floor(y / 256))
				end
			end,

			deselectAll    = function(self)  
				self.chunks:deselect()
				self.objects:deselect()
				self.player:deselect()
			end,

			deleteSelected = function(self)  
				self.objects:deleteSelected()
				self.chunks:deleteSelected()
				self.player:deleteSelected()
			end,

			xFlipSelected  = function(self)  
				self.objects:xFlipSelected()
				self.chunks:xFlipSelected()
				self.player:xFlipSelected()
			end,

			nudgeSelected = function(self, x, y)
				self.objects:nudgeSelected(x, y)
				self.player:nudgeSelected(x, y)
			end,

			holdSelected   = function(self)  
				local result = self.player:holdSelected()
				if not result then result = self.objects:holdSelected() end
				return result or self.chunks:holdSelected()
			end,

			releaseSelected = function(self) 
				self.objects:releaseSelected()
				self.chunks:releaseSelected()
				self.player:releaseSelected()
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

			placePlayer = function(self, obj, x, y)
				return self.player:place(obj, x, y)
			end,

			update = function(self, dt)
				self.objects:update(dt)
				self.player:update(dt)
			end,

			saveMap = function(self, filename)
				love.filesystem.createDirectory("game/resources/zones/maps")
				love.filesystem.write("game/resources/zones/maps/" .. filename .. "Map.lua", self:encodeMapData())
			end,

			encodeMapData = function(self)
				local encodedMap = "return {\n"
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
						encodedMap = encodedMap .. rowString .. "} },\n"
					end
				end
				return encodedMap .. "}\n"
			end,

			saveObjects = function(self, filename)
				love.filesystem.createDirectory("game/resources/zones/objects")
				love.filesystem.write("game/resources/zones/objects/" .. filename .. "Objects.lua", self:encodeObjectData())
			end,

			encodeObjectData = function(self)
				local encodedObjects = "return {\n"
				
				-- Write player origin if player exists
				if self.player.obj then
					encodedObjects = encodedObjects .. "  origin = { x = " .. self.player.x .. ", y = " .. self.player.y .. ", sprite = \"" .. self.player.obj:getName() .. "\" },\n"
				end
				
				self.objects:forEach(function(object)
					local xFlipString = ""
					if object.obj.xFlip == -1 then xFlipString = ", xFlip = true" end
					encodedObjects = encodedObjects .. "  { obj = \"" .. object.obj:getName() .. "\", x = " .. object.x .. ", y = " .. object.y .. xFlipString .. " },\n"
				end)
				return encodedObjects .. "}\n"
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
