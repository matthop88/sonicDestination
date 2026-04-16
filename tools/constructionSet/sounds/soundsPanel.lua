local COLOR = require("tools/lib/colors")
local verticalSliderPane = require("tools/lib/components/verticalSliderPane")
local horizontalSlider = require("tools/lib/components/horizontalSlider")

local createOkButton = function(params)
	local buttonFontSize = params.fontSize or 16
	local buttonFont     = love.graphics.newFont(buttonFontSize)

	return {
		x = params.x,
		y = params.y,
		width = params.width or 100,
		height = params.height or 40,
		hovered = false,
		cornerRadius = 10,
		
		draw = function(self)
			if self.hovered then
				love.graphics.setColor(COLOR.MEDIUM_GREY)
			else
				love.graphics.setColor(COLOR.MEDIUM_DARK_GREY)
			end
			love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.cornerRadius, self.cornerRadius)
			love.graphics.setColor(COLOR.PURE_WHITE)
			love.graphics.rectangle("line", self.x, self.y, self.width, self.height, self.cornerRadius, self.cornerRadius)
			
			love.graphics.setFont(buttonFont)
			love.graphics.printf("OK", self.x, self.y + 10, self.width, "center")
		end,
		
		update = function(self, mx, my)
			self.hovered = self:containsPoint(mx, my)
		end,
		
		containsPoint = function(self, mx, my)
			return mx >= self.x and mx <= self.x + self.width and
			       my >= self.y and my <= self.y + self.height
		end,
	}
end

				
return {
	create = function(self, params)
		local okButton = nil
		
		return ({
			x = params.x or 300,
			y = params.y or 250,
			width = params.width or 830,
			height = params.height or 400,
			visible = false,
				
			init = function(self)
				okButton = createOkButton {
					x = self.x + self.width - 120,
					y = self.y + self.height - 60,
					width = 100,
					height = 40,
				}
		
				return self
			end,
					
			draw = function(self)
				if not self.visible then return end
				
				self:drawPanelBackground()
				self:drawTitle()
				okButton:draw()
			end,
			
			drawPanelBackground = function(self)
				love.graphics.setColor(COLOR.DARK_GREY)
				love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
				love.graphics.setColor(COLOR.PURE_WHITE)
				love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
			end,
			
			drawTitle = function(self)
				love.graphics.setColor(COLOR.PURE_WHITE)
				local font = love.graphics.newFont(24)
				love.graphics.setFont(font)
				love.graphics.printf("Select Sound", self.x, self.y + 20, self.width, "center")
			end,
							
			update = function(self, dt)
				if not self.visible then return end
				
				local mx, my = love.mouse.getPosition()
				okButton:update(mx, my)
			end,
								
			handleMousePressed = function(self, mx, my)
				if not self.visible then return false end
				
				if okButton:containsPoint(mx, my) then
					self:setVisible(false)
					return true
				end
				return false
			end,
			
			containsPoint = function(self, mx, my)
				return mx >= self.x and mx <= self.x + self.width and
				       my >= self.y and my <= self.y + self.height
			end,
							
			handleMouseReleased = function(self, mx, my)
				-- Do nothing
			end,
				
			setVisible = function(self, visible)
				self.visible = visible
			end,
		
		}):init()
	end,
}
