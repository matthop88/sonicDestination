return {
	create = function(self, params)
		return {
			graphics         = params.graphics,
			coordinateMaster = require("tools/constructionSet/coordinateMaster"),
			
			chunks  = require("tools/constructionSet/engine/chunks"):create(),
			objects = require("tools/constructionSet/engine/objects"):create(),
			player  = require("tools/constructionSet/engine/player"):create(),

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

			clear = function(self)
				-- Clear chunks
				for i = 1, #self.chunks do
					self.chunks[i] = {}
				end
				
				-- Clear objects
				self.objects.objList = require("game/util/dataStructures/linkedList"):create()
				self.objects.selected = nil
				self.objects.held = nil
				
				-- Clear player
				self.player.obj = nil
				self.player.x = nil
				self.player.y = nil
				self.player.selected = false
				self.player.held = nil
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
