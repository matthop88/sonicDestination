return {
	create = function(self)
		return {
			objectTransparency = require("tools/lib/tweenableValue"):create(25, { speed = 5 }),
			lastX, lastY = 0, 0,

			onSelect = function(self, container)
				if self.selected ~= container then
					self.selected = container
					self.object   = container:newObject()
					if self.object.hold then self.object:hold() end
				end
			end,

			onDeselect = function(self, container)
				if self.selected == container then
					self.selected = nil
					self.object   = nil
				end
			end,

			draw = function(self, graphics, mx, my)
				local x, y = graphics:screenToImageCoordinates(mx, my)
				if not self:isWithinBounds(x, y) then
					self.objectTransparency:setDestination(0)
				elseif my < getTabbedPane():getTabsY() and self.object then
					self.objectTransparency:setDestination(205)
				else
					self.objectTransparency:setDestination(25)
				end
				if self.object then
					graphics:setColor(1, 1, 1, self.objectTransparency:get() / 255)
					if self:areWeScrolling(graphics) then
						self.object:draw(graphics, x, y)
					else
						self:drawObjectQuantized(graphics, x, y)
					end
					self.lastX, self.lastY = graphics:getX(), graphics:getY()
				end
			end,

			isWithinBounds = function(self, x, y)
				return x >= 0 and x < 65536 and y >= 0 and y < 65536
			end,

			areWeScrolling = function(self, graphics)
				return graphics:getX() ~= self.lastX or graphics:getY() ~= self.lastY
			end,

			drawObjectQuantized = function(self, graphics, x, y)
				if self.object.quantizeXY then x, y = self.object:quantizeXY(x, y) end
				self.object:draw(graphics, math.floor(x), math.floor(y))
			end,

			update = function(self, dt)
				if self.object and self.object.update then self.object:update(dt) end
				self.objectTransparency:update(dt)
			end,

			handleKeypressed = function(self, key)
				if     key == "x" and self.object and self.object.flipX        then self.object:flipX() 
				elseif key == "s" and self.object and self.object.toggleSolids then self.object:toggleSolids() end
			end,

			handleMousepressed = function(self, graphics, mx, my, map)
				if self.object and self.object.place then
					local x, y = graphics:screenToImageCoordinates(mx, my)
					self.object:place(map, x, y)
				end
			end,
		}
	end,

}
