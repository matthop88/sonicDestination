return {
	create = function(self, font, fontData)
		return ({
			image  = font.image,
			font   = font,
			glyphs = require(relativePath("util/dataStructures/linkedList"):create(),

			init = function(self, fontData)
				for _, key in ipairs(fontData.keys) do
					self.glyphs:add(require(relativePath("fonts/glyph")):create(self.font, key))
				end

				return self
			end,

			draw = function(self, graphics, x, y)
				graphics:setColor(1, 1, 1)
				local image = self.image
				self.glyphs:forEach(function(glyph) 
					if glyph.quad then
						graphics:draw(image, glyph.quad, x, y, 0, 1, 1)
					end
					x = x + glyph.w
				end)
			end,
		}):init(fontData)
	end,
}
