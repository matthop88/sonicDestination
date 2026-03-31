local COLOR = require("tools/lib/colors")

return {
	create = function(self, params)
		return {
			label = params.label or "Music",
			hasFocus = false,
			isSelected = false,
			isPressed = false,
			
			drawInContainer = function(self, graphics, x, y, w, h)
				if self.isPressed then
					-- Draw filled rectangle for pressed state
					graphics:setColor(1, 1, 0)
					graphics:rectangle("fill", x - w/2, y - h/2, w, h)
					graphics:setColor(0, 0, 0)
				elseif self.isSelected then
					graphics:setColor(1, 1, 0)
				else
					graphics:setColor(COLOR.PURE_WHITE)
				end
				graphics:setFontSize(48)
				graphics:printf(self.label, x - w/2, y - 24, w, "center")
			end,
			
			updateInContainer = function(self, dt)
			end,
			
			gainFocus = function(self)
				self.hasFocus = true
			end,
			
			loseFocus = function(self)
				self.hasFocus = false
			end,
			
			select = function(self)
				self.isSelected = true
				self.isPressed = true
			end,
			
			deselect = function(self)
				self.isSelected = false
			end,
			
			handleMousereleased = function(self, mx, my)
				self.isPressed = false
			end,
			
			newObject = function(self)
				return nil
			end,
		}
	end,
}
