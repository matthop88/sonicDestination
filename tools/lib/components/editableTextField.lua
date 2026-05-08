local COLOR = require("tools/lib/colors")

return {
	create = function(self, params)
		local fieldFont = love.graphics.newFont(20)
		if params.visible == nil then params.visible = true end
		
		return ({
			x            = params.x,
			y            = params.y,
			w            = params.w,
			h            = params.h or 50,
			text         = params.text or "",
			visible      = params.visible,
			hovered      = false,
			editing      = false,
			inputLayerFn = params.inputLayerFn,

			init = function(self)
				-- Do something?

				return self
			end,

			draw = function(self)
				if not self.visible then return end

				if self.hovered then
					love.graphics.setColor(COLOR.LIGHTER_GREY)
				else
					love.graphics.setColor(COLOR.MEDIUM_DARK_GREY)
				end
				love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
				
				love.graphics.setColor(COLOR.PURE_WHITE)
				love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
				
				love.graphics.setColor(COLOR.PURE_WHITE)
				love.graphics.setFont(fieldFont)
				
				love.graphics.printf(self.text, self.x + 10, self.y + 15, self.w - 20, "left")
			end,
			
			update = function(self, dt, mx, my)
				if not self.visible then return end

				self.hovered = self:containsPoint(mx, my)
			end,

			handleMousepressed = function(self, mx, my)
				if not self.visible then return end
				
				self.editing = self:containsPoint(mx, my)
				if self.inputLayerFn then
					if self.editing then
						self.inputLayerFn():activate()
					else
						self.inputLayerFn():deactivate()
					end
				end
			end,

			handleKeypressed = function(self, key)
				if not self.visible then return end
				
				if self.editing then
					self.text = self.text .. key
					return true
				end
			end,
			
			containsPoint = function(self, mx, my)
				return mx >= self.x and mx <= self.x + self.w and
				       my >= self.y and my <= self.y + self.h
			end,
			
			getText = function(self)
				return self.text
			end,

			setVisible = function(self, visible)
				self.visible = visible
			end,

		}):init()
	end,
}
