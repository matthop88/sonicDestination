return {
	init = function(self, params)
		self.components = {}
		return self
	end,
	
	add = function(self, component)
		table.insert(self.components, component)
		return self
	end,
	
	draw = function(self, ...)
		for _, component in ipairs(self.components) do
			if component.draw then
				component:draw(...)
			end
		end
	end,
	
	update = function(self, dt, ...)
		for _, component in ipairs(self.components) do
			if component.update then
				component:update(dt, ...)
			end
		end
	end,
	
	modalMousepressed = function(self, mx, my)
		for _, component in ipairs(self.components) do
			if component.handleMousePressed then
				local handled = component:handleMousePressed(mx, my)
				if handled then
					return true
				end
			end
		end
		return false
	end,
	
	modalMousereleased = function(self, mx, my)
		for _, component in ipairs(self.components) do
			if component.handleMouseReleased then
				component:handleMouseReleased(mx, my)
			end
		end
	end,
}
