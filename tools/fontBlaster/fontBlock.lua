local createGlyph = function(font, key)
	local glyph = {}
	local f = font.data[key]
	if f == nil then
		glyph.w = font.spaceWidth or 16
	else
		glyph.w = f.w + 1
		glyph.quad = f.quad
	end
	return glyph
end

local createFontObject = function(font, fontData)
	local obj = { image = font.image, glyphs = {} }
	for _, key in ipairs(fontData.keys) do 
		local glyph = createGlyph(font, key)
		table.insert(obj.glyphs, glyph)
	end
	return obj
end

local drawFontObject = function(self, graphics)
	graphics:setColor(1, 1, 1)
	local myX = self.x
	for _, glyph in ipairs(self.obj.glyphs) do 
		if glyph.quad then
			graphics:draw(self.obj.image, glyph.quad, myX, self.y, 0, 1, 1)
		end
		myX = myX + glyph.w
	end
end

return {
	create = function(self, params)
		return {
			obj = createFontObject(params.font, params.fontData),
			x   = params.x,
			y   = params.y,

			draw = drawFontObject,

		}
	end,
}
