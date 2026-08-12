return {
	create = function(self)
		return {
			objects = {},

			add = function(self, fontObject, color)
				table.insert(self.objects, fontObject)
				fontObject:setColor(color)
				return self
			end,
			
			draw = function(self, graphics, x, y)
				local w = 0
				for _, fontObject in ipairs(self.objects) do
					w = w + fontObject:draw(graphics, x + w, y)
				end
			end,
		}
	end,
}
