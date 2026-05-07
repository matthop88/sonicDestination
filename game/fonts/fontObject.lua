return {
	create = function(self, font, fontData)
		return ({
			image  = font.image,
			font   = font,
			glyphs = require(relativePath("util/dataStructures/linkedList")):create(),

			init = function(self, fontData)
				for _, key in ipairs(fontData.keys) do
					self.glyphs:add(require(relativePath("fonts/glyph")):create(self.font, key))
				end

				return self
			end,

			setColor = function(self, color)
				self.color = color
			end,

			draw = function(self, graphics, x, y)
				if not self.color then
					graphics:setColor(1, 1, 1)
				else
					graphics:setColor(self.color)
				end
				local w = 0
				local image = self.image
				self.glyphs:forEach(function(glyph) 
					if glyph.quad then
						graphics:draw(image, glyph.quad, x + w, y, 0, 1, 1)
					end
					w = w + glyph.w
				end)
				return w
			end,
		}):init(fontData)
	end,
}
