return {
	create = function(self, font, fontData)
		return ({
			image  = font.image,
			font   = font,
			glyphs = require("game/util/dataStructures/linkedList"):create(),

			init = function(self, fontData)
				for _, key in ipairs(fontData.keys) do
					self.glyphs:add(require("tools/fontBlaster/glyph"):create(self.font, key))
				end

				return self
			end,
		}):init(fontData)
	end,
}
