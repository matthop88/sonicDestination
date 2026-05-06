local createGlyph = function(font, key)
	local glyph = {}
	local f = font.data[key]
	if f == nil then
		glyph.w = font.spaceWidth or 16
		glyph.h = 0
	else
		glyph.w = f.w + 1
		glyph.h = f.h
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

local drawFontObject = function(self)
	local graphics = self.graphics
	graphics:setColor(1, 1, 1)
	local myX = self.x
	for _, glyph in ipairs(self.obj.glyphs) do 
		if glyph.quad then
			graphics:draw(self.obj.image, glyph.quad, myX, self.y, 0, 1, 1)
		end
		myX = myX + glyph.w
	end
	if self.selected then
		graphics:setColor(0, 0, 0, 0.3)
		graphics:rectangle("fill", self.x - 1, self.y - 1, self.w + 1, self.h + 2)
		graphics:setColor(1, 1, 1)
		graphics:setLineWidth(3)
		graphics:rectangle("line", self.x - 2, self.y - 2, self.w + 3, self.h + 4)
		graphics:setColor(0, 0, 0)
		graphics:setLineWidth(1)
		graphics:rectangle("line", self.x - 1, self.y - 1, self.w + 1, self.h + 2)
		graphics:rectangle("line", self.x - 4, self.y - 4, self.w + 7, self.h + 8)
	elseif self.highlighted then
		graphics:setColor(1, 1, 0)
		graphics:rectangle("line", self.x - 1, self.y - 1, self.w + 1, self.h + 2)
	end
end

local calculateWidth = function(self)
	local width = 0
	for _, glyph in ipairs(self.obj.glyphs) do
		width = width + glyph.w
	end
	return width
end

local calculateHeight = function(self)
	local height = 0
	for _, glyph in ipairs(self.obj.glyphs) do
		height = math.max(height, glyph.h)
	end
	return height
end

return {
	create = function(self, params)
		return ({
			obj         = createFontObject(params.font, params.fontData),
			x           = params.x,
			y           = params.y,
			highlighted = false,
			selected    = false,
			graphics    = params.graphics,

			draw = drawFontObject,

			init = function(self)
				self.w = calculateWidth(self)
				self.h = calculateHeight(self)

				return self
			end,

			update = function(self, dt)
				self.highlighted = self:ptInBounds(self.graphics:screenToImageCoordinates(love.mouse.getPosition()))
			end,

			mousepressed = function(self, mx, my)
				self.selected = self:ptInBounds(self.graphics:screenToImageCoordinates(mx, my))
			end,

			ptInBounds = function(self, px, py)
				return px >= self.x and py >= self.y and px < self.x + self.w and py < self.y + self.h
			end,

		}):init()
	end,
}
