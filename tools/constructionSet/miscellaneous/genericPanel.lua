local COLOR = require("tools/lib/colors")

local createLabel    = function(name, x, y, w, h)
	return require("tools/lib/components/label"):create { x = x, y = y, w = w, h = h, label = name }
end

local createDropDown = function(params, x, y, w, h)
	return require("tools/lib/components/dropDownField"):create {
		x             = x,
		y             = y,
		width         = w,
		height        = h,
		label         = "",
		list          = params.list,
		selectedValue = params.selectedValue,
		comparisonFn  = function(listItem, value) return listItem.value == value end,
		onChanged     = params.onChanged,
	}
end

local createEditableTextField = function(params, x, y, w, h)
	return require("tools/lib/components/editableTextField"):create {
		x            = x,
		y            = y,
		w            = w,
		h            = h,
		text         = params.text,
		onChanged    = params.onChanged,
		inputLayerFn = getInputLayer,
		validKeys    = params.validKeys,
		transformer  = function(text) return string.upper(text) end,
	}
end

return {
	create = function(self, params)
		return ({
			title      = params.title or "Untitled Panel",
			titleFont  = love.graphics.newFont(24),
			visible    = false,
			
			x          = params.x                 or 300,
			y          = params.y                 or 250,
			w          = params.w                 or 830,
			h          = params.h                 or 400,
			topX       = params.components.topX   or   0,
			topY       = params.components.topY   or   0,
			labelW     = params.components.labelW or 150,
			componentW = params.components.w      or 300,
			componentH = params.components.h      or  50,
			gapX       = params.components.gapX   or   0,
			gapY       = params.components.gapY   or   0,

			components = {},
			dropDowns  = {},
				
			init = function(self, params)
				if _G.getModals then getModals():add(self) end

				self:addComponents(params.components)
				self:addOkButton()

				return self
			end,

			addComponents = function(self, components)
				local x = self.x + self.topX
				local y = self.y + self.topY

				for _, component in ipairs(components) do
					self:addLabeledComponent(component, x, y)
					y = y + self.componentH + self.gapY
				end
			end,

			addLabeledComponent = function(self, component, x, y)
				table.insert(self.components, createLabel(component.label, x, y, self.labelW, self.componentH))
				x = x + self.labelW + self.gapX
				local c = self:createComponent(component, x, y)
				table.insert(self.components, c)
				if component.type == "dropDown" then table.insert(self.dropDowns, c) end
			end,

			createComponent = function(self, component, x, y)
				if     component.type == "dropDown"          then return createDropDown(component, x, y, self.componentW, self.componentH)
				elseif component.type == "editableTextField" then return createEditableTextField(component, x, y, self.componentW, self.componentH)
				end
			end,

			addOkButton = function(self)
				self.okButton = require("tools/lib/components/okButton"):create {
					x = self.x + self.w - 120,
					y = self.y + self.h - 60,
					width = 100,
					height = 40,
				}
			end,
					
			draw = function(self)
				if not self.visible then return end
				
				self:drawPanelBackground()
				self:drawTitle()
				self:drawComponents()
			end,
			
			drawPanelBackground = function(self)
				love.graphics.setColor(COLOR.DARK_GREY)
				love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
				love.graphics.setColor(COLOR.PURE_WHITE)
				love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
			end,
			
			drawTitle = function(self)
				love.graphics.setColor(COLOR.PURE_WHITE)
				love.graphics.setFont(self.titleFont)
				love.graphics.printf(self.title, self.x, self.y + 20, self.w, "center")
			end,

			drawComponents = function(self)
				for _, component in ipairs(self.components) do
					component:draw()
				end
				self.okButton:draw()
			end,

			update = function(self, dt)
				if not self.visible then return end
				
				local mx, my = love.mouse.getPosition()
				self:updateComponents(dt, mx, my)
				
				self.okButton:update(mx, my)
			end,

			updateComponents = function(self, dt, mx, my)
				for _, component in ipairs(self.components) do
					if component.update then component:update(dt, mx, my) end
				end
			end,
								
			handleMousePressed = function(self, mx, my)
				if not self.visible then return false end
				
				if not self:anyListIsVisible() and self:handleMousePressedComponents(mx, my) then return true end

				if self.okButton:containsPoint(mx, my) then
					if not self:anyListIsVisible() then self:setVisible(false) end
					return true
				end

				if self:containsPoint(mx, my) or self:anyListContainsPoint(mx, my) then
					return not self:anyListIsVisible()
				end

				return true
			end,

			handleMousePressedComponents = function(self, mx, my)
				for _, component in ipairs(self.components) do
					if component.handleMousepressed and component:handleMousepressed(mx, my) then return true end
				end
			end,

			keypressed = function(self, key)
				if not self.visible then return false end

				for _, component in ipairs(self.components) do
					if component.handleKeypressed and component:handleKeypressed(key) then return true end
				end
			end,
			
			setVisible = function(self, visible)
				self.visible = visible
			end,

			containsPoint = function(self, mx, my)
				return mx >= self.x and mx <= self.x + self.w and
				       my >= self.y and my <= self.y + self.h
			end,

			anyListIsVisible = function(self)
				for _, dropDown in ipairs(self.dropDowns) do
					if dropDown:isListVisible() then return true end
				end
			end,

			hideLists = function(self)
				for _, dropDown in ipairs(self.dropDowns) do
					dropDown:hideList()
				end
			end,

			anyListContainsPoint = function(self, mx, my)
				for _, dropDown in ipairs(self.dropDowns) do
					if dropDown:listContainsPoint(mx, my) then return true end
				end
			end,
		}):init(params)
	end,
}

