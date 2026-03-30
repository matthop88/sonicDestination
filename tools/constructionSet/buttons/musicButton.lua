local COLOR = require("tools/lib/colors")

return {
	create = function(self, params)
		return {
			label = params.label or "Music",
			hasFocus = false,
			isSelected = false,
			
    		drawInContainer = function(self, graphics, x, y, w, h)
    			graphics:setColor(COLOR.PURE_WHITE)
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
			end,
			
			deselect = function(self)
				self.isSelected = false
			end,
			
			newObject = function(self)
				return nil
			end,
		}
	end,
}
