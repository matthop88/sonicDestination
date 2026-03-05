return {
	create = function(self)
		return {
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
					
					-- Draw coordinate box (directly to screen, unscaled)
					local coordText = string.format("(%d, %d)", self.selected.x, self.selected.y)
					local imageBoxX = self.selected.x + self.selected.obj:getW() / 2 + 8
					local imageBoxY = self.selected.y - self.selected.obj:getH() / 2
					
					-- Convert to screen coordinates
					local screenX, screenY = graphics:imageToScreenCoordinates(imageBoxX, imageBoxY)
					
					local textWidth = love.graphics.getFont():getWidth(coordText)
					local textHeight = love.graphics.getFont():getHeight()
					
					love.graphics.setLineWidth(2)
					love.graphics.setColor(0, 0, 0, 0.8)
					love.graphics.rectangle("fill", screenX, screenY, textWidth + 8, textHeight + 4)
					love.graphics.setColor(1, 1, 0)
					love.graphics.rectangle("line", screenX, screenY, textWidth + 8, textHeight + 4)
					love.graphics.setColor(1, 1, 1)
					love.graphics.print(coordText, screenX + 4, screenY + 2)
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
		}
	end,
}
