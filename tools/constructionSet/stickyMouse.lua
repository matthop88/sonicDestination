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
					self.object:draw(graphics, mx, my)
				else
					love.mouse.setVisible(true)
				end
			end,
		}
	end,

}
