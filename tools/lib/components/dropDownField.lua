local COLOR = require("tools/lib/colors")

return {
	create = function(self, params)
		local fieldFont = love.graphics.newFont(20)
		if params.visible == nil then params.visible = true end

		local selectedValue = params.selectedValue or "None"
		if params.selectedIndex then
			selectedValue = params.list[params.selectedIndex]
		end

		return {
			x = params.x,
			y = params.y,
			width = params.width,
			height = params.height or 50,
			label = params.label or "",
			selectedValue = selectedValue,
			hovered = false,
			list = nil,
			visible = params.visible,
			onChanged = params.onChanged,
			listItems = params.list or {},
			comparisonFn = params.comparisonFn or function(listItem, outsideItem) return listItem == outsideItem end,

			draw = function(self)
				if not self.visible then return end

				-- Draw field background
				if self.hovered then
					love.graphics.setColor(COLOR.LIGHTER_GREY)
				else
					love.graphics.setColor(COLOR.MEDIUM_DARK_GREY)
				end
				love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
				love.graphics.setColor(COLOR.PURE_WHITE)
				love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
				
				-- Draw label and selected value
				love.graphics.setColor(COLOR.PURE_WHITE)
				love.graphics.setFont(fieldFont)
				
				local selectedValue = self.selectedValue
				if type(self.selectedValue) == "table" then
					selectedValue = self.selectedValue.label
				end
				if self.label and self.label ~= "" then
					love.graphics.print(self.label .. ":", self.x + 10, self.y + 15)
					local labelWidth = fieldFont:getWidth(self.label .. ": ")
					love.graphics.print(selectedValue, self.x + 10 + labelWidth, self.y + 15)
				else
					love.graphics.printf(selectedValue, self.x + 10, self.y + 15, self.width - 20, "left")
				end
			end,
			
			update = function(self, dt, mx, my)
				if not self.visible then return end

				self.hovered = self:containsPoint(mx, my)
				if self.list then
					self.list:update(dt, mx, my)
				end
			end,

			handleMousepressed = function(self, mx, my)
				if not self.visible then return end
				
				if self:containsPoint(mx, my) then
					self:showList()
					return true
				end
			end,

			handleKeypressed = function(self, key)
				if not self.visible then return end
				return self.list:handleKeyPressed(key)
			end,
			
			containsPoint = function(self, mx, my)
				return mx >= self.x and mx <= self.x + self.width and
				       my >= self.y and my <= self.y + self.height
			end,
			
			setSelectedValue = function(self, value)
				for _, item in ipairs(self.listItems) do
					if self.comparisonFn(item, value) then
						self.selectedValue = item
						break
					end
				end
			end,

			getSelectedValue = function(self)
				return self.selectedValue
			end,

			showList = function(self)
				if not self.list then
					self:initializeList()
				end
				self.list:setVisible(true)
			end,

			hideList = function(self)
				if self.list then
					self.list:setVisible(false)
				end
			end,

			initializeList = function(self)
				self.list = require("tools/lib/guiList/list"):create {
					x      = self.x,
					y      = self.y + self.height,
					width  = self.width,
					height = 400,
					fontSize = 24,
					scrollSpeed = 1200,
					items = self.listItems,
					onItemSelected = function(list, item, index)
						list:setVisible(false)
						self.selectedValue = item
						if self.onChanged then self.onChanged(item, index) end
					end,
				}
			
				if _G.getModals then
					getModals():add(self.list)
				end
			end,

			setVisible = function(self, visible)
				self.visible = visible
				if visible == false then
					if self.list then
						self.list:setVisible(false)
					end
				end
			end,

		}
	end,
}
