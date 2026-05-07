return {
	create = function(self, font, key)
		local fontData = font.data[key]
	
		if fontData == nil then
			return {
				w = font.spaceWidth or 16,
				h = 0
			}
		else
			return {
				w    = fontData.w + 1,
				h    = fontData.h,
				quad = fontData.quad,
			}
		end
	end,
}
