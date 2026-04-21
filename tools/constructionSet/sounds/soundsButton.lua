local COLOR = require("tools/lib/colors")

return {
	create = function(self, params)
		local title = nil
		local soundsPanel = nil

		return {
			label = params.label or "Sounds",
			hasFocus = false,
			isSelected = false,
			isPressed = false,
			
			drawInContainer = function(self, graphics, x, y, w, h)
				if self.isPressed then
					-- Draw filled rectangle for pressed state
					graphics:setColor(COLOR.YELLOW)
					graphics:rectangle("fill", x - w/2, y - h/2, w, h)
					graphics:setColor(COLOR.JET_BLACK)
				elseif self.isSelected then
					graphics:setColor(COLOR.YELLOW)
				else
					graphics:setColor(COLOR.PURE_WHITE)
				end
				graphics:setFontSize(48)
				graphics:printf(self.label, x - w/2, y - 24, w, "center")
				graphics:setFontSize(24)
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
				if self.isSelected then
					self:showSoundsPanel()
				end
			end,
			
			showSoundsPanel = function(self)
				if not soundsPanel then
					soundsPanel = require("tools/constructionSet/sounds/soundsPanel"):create {
						x = 300,
						y = 250,
						width = 830,
						height = 400,
					}
					
				end
				
				soundsPanel:setVisible(true)
				self.isSelected = false
				self.isPressed = false
			end,
			
			newObject = function(self)
				return nil
			end,
		}
	end,
}
