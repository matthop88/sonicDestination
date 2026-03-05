return {
	create = function(self)
		return {
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
						
						-- Draw coordinate box (directly to screen, unscaled)
						local coordText = string.format("(%d, %d)", self.x, self.y)
						local imageBoxX = self.x + self.obj:getW() / 2 + 8
						local imageBoxY = self.y - self.obj:getH() / 2
						
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
				end
			end,

			update = function(self, dt)
				if self.obj then
					self.obj:update(dt)
				end
			end,
		}
	end,
}
