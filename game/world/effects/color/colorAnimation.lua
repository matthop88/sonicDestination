return {
	create = function(self, colors, isSmooth)
		local entries = {}
		for n, color in ipairs(colors) do
			table.insert(entries, { base = { color[1], color[2], color[3] } })
			if n > 1 then
				local prevColor = entries[n - 1].base
				entries[n - 1].delta = { color[1] - prevColor[1], color[2] - prevColor[2], color[3] - prevColor[3] }
			end
		end
		local firstColor = entries[1].base
		local lastColor  = entries[#colors].base
		entries[#colors].delta = { firstColor[1] - lastColor[1], firstColor[2] - lastColor[2], firstColor[3] - lastColor[3] }

		local colorAnimator = {
			offset   = 1,
			dx       = 0,
			isSmooth = isSmooth,
			update = function(self, dt)
				self.offset = self.offset + (12 * dt)
			        self.dx = self.offset - math.floor(self.offset)
			        while self.offset >= 5 do
			        	self.offset = self.offset - 4 
			        end
			    end,
		    get = function(self, n)
		        local index = n + math.floor(self.offset)
		        if index > 4 then index = index - 4 end
		        local c = self[index]
		        if self.isSmooth then
		        	return { c.base[1] + (c.delta[1] * self.dx), c.base[2] + (c.delta[2] * self.dx), c.base[3] + (c.delta[3] * self.dx) }
		        else
		        	return { c.base[1], c.base[2], c.base[3] }
		        end
			end,
		}

		for n, entry in ipairs(entries) do
			table.insert(colorAnimator, entry)
		end

		return colorAnimator
	end
}
