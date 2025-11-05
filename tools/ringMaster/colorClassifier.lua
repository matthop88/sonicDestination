return {
	classifyImageData = function(self, imgData, startX, startY, width, height)
		local colorFrequencies = {}

		for y = startY, startY + height - 1 do
			for x = startX, startX + width - 1 do
				local r, g, b, a = love.math.colorToBytes(imgData:getPixel(x, y))
				local colorKey = "" .. ((r * 16777216) + (g * 65536) + (b * 256) + a)
				if not colorFrequencies[colorKey] then
					colorFrequencies[colorKey] = { color = { r = r, g = g, b = b, a = a }, frequency = 1 }
				else
					colorFrequencies[colorKey].frequency = colorFrequencies[colorKey].frequency + 1
				end
			end
		end

		return colorFrequencies
	end,
}
