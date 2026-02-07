return {
	create = function(self)
		return {
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
				if self.object then
					love.mouse.setVisible(false)
					graphics:setColor(1, 1, 1, 0.7)
					self.object:draw(graphics, mx, my)
				else
					love.mouse.setVisible(true)
				end
			end,

			update = function(self, dt)
				if self.object and self.object.update then self.object:update(dt) end
			end,

			handleKeypressed = function(self, key)
				if     key == "x" and self.object and self.object.flipX        then self.object:flipX() 
				elseif key == "s" and self.object and self.object.toggleSolids then self.object:toggleSolids() end
			end,
		}
	end,

}
