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
			validKeys    = params.validKeys,
			transformer  = params.transformer,
			cursorTimer  = 0,

			init = function(self)
				self:transformText()
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
				
				love.graphics.printf(self.displayedText, self.x + 10, self.y + 15, self.w - 20, "left")
				if self.editing then self:drawCursor() end
			end,

			drawCursor = function(self)
				if math.floor(self.cursorTimer) % 2 == 0 then
					local width = fieldFont:getWidth(self.displayedText)
					love.graphics.setColor(COLOR.PURE_WHITE)
					love.graphics.rectangle("fill", self.x + width + 12, self.y + 5, 3, 40)
				end
			end,
			
			update = function(self, dt, mx, my)
				if not self.visible then return end

				self.hovered = self:containsPoint(mx, my)
				self.cursorTimer = self.cursorTimer + (2 * dt)
			end,

			handleMousepressed = function(self, mx, my)
				if not self.visible then return end
				
				self:setEditing(self:containsPoint(mx, my))
			end,

			handleKeypressed = function(self, key)
				if not self.visible then return end
				
				if self.editing then
					if key == "space" or key == "shiftspace" then 
						key = " "
					elseif key == "backspace" then 
						self.text = string.sub(self.text, 1, string.len(self.text) - 1)
						self:transformText()
						return true
					elseif string.len(key) ~= 1 or not self:isValid(key) then
						return true
					end
					self.text = self.text .. key
					self:transformText()
					return true
				end
			end,

			isValid = function(self, key)
				if not self.validKeys then 
					return true
				else
					for _, k in ipairs(self.validKeys) do
						if key == k then return true end
					end
				end
			end,

			transformText = function(self)
				if self.transformer then
					self.displayedText = self.transformer(self.text)
				else
					self.displayedText = self.text
				end
			end,
			
			containsPoint = function(self, mx, my)
				return mx >= self.x and mx <= self.x + self.w and
				       my >= self.y and my <= self.y + self.h
			end,
			
			getText = function(self)
				return self.text
			end,

			setEditing = function(self, editing)
				if self.editing == true and editing == false then
					if self.inputLayerFn then self.inputLayerFn():deactivate() end
				elseif self.editing == false and editing == true then
					if self.inputLayerFn then self.inputLayerFn():activate()   end
					self.cursorTimer = 0
				end
				self.editing = editing
			end,

			setVisible = function(self, visible)
				self.visible = visible
				if self.editing and not self.visible then
					self:setEditing(false)
				end
			end,

		}):init()
	end,
}
