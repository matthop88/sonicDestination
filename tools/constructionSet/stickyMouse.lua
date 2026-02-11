return {
	create = function(self)
		return {
			objectTransparency = require("tools/lib/tweenableValue"):create(25, { speed = 5 }),
	
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
				if my < getTabbedPane():getTabsY() and self.object then
					love.mouse.setVisible(false)
					self.objectTransparency:setDestination(205)
				else
					love.mouse.setVisible(true)
					self.objectTransparency:setDestination(25)
				end
				if self.object then
					graphics:setColor(1, 1, 1, self.objectTransparency:get() / 255)
					local x, y = graphics:screenToImageCoordinates(mx, my)
					self.object:draw(graphics, math.floor(x), math.floor(y))
				end
				
			end,

			update = function(self, dt)
				if self.object and self.object.update then self.object:update(dt) end
				self.objectTransparency:update(dt)
			end,

			handleKeypressed = function(self, key)
				if     key == "x" and self.object and self.object.flipX        then self.object:flipX() 
				elseif key == "s" and self.object and self.object.toggleSolids then self.object:toggleSolids() end
			end,
		}
	end,

}
