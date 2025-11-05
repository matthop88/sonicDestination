local isFullyTransparent = function(color) return color.a == 0 end

local buildColor = function(r, g, b, a)
	local rb, gb, bb, ab = love.math.colorToBytes(r, g, b, a)
	return { r = rb, g = gb, b = bb, a = ab }
end

local buildColorKey = function(color)
	return "" .. ((color.r * 16777216) + (color.g * 65536) + (color.b * 256) + color.a)
end

return {
	classifyImageData = function(self, imgData, startX, startY, width, height)
		local colorFrequencyMap = self:buildColorFrequencyMap(imgData, startX, startY, width, height)

		return self:convertToColorFrequencyList(colorFrequencyMap)
	end,

	buildColorFrequencyMap = function(self, imgData, startX, startY, width, height)
		local colorFrequencyMap = {}

		for y = startY, startY + height - 1 do
			for x = startX, startX + width - 1 do
				local myColor = buildColor(imgData:getPixel(x, y))
				if not isFullyTransparent(myColor) then
					local colorKey = buildColorKey(myColor)
					if not colorFrequencyMap[colorKey] then
						colorFrequencyMap[colorKey] = { color = myColor, frequency = 1 }
					else
						colorFrequencyMap[colorKey].frequency = colorFrequencyMap[colorKey].frequency + 1
					end
				end
			end
		end

		return colorFrequencyMap
	end,

	convertToColorFrequencyList = function(self, colorFrequencyMap)
		local colorFrequencies = {}

		for k, colorFrequency in pairs(colorFrequencyMap) do
			table.insert(colorFrequencies, colorFrequency)
		end

		return colorFrequencies
	end,

}
