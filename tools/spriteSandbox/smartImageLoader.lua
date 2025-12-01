local STRING_UTIL = require("tools/lib/stringUtil")

return {
	loadImage = function(self, imageName)
		local imagePath = self:createImagePath(imageName)
		return self:loadFromPath(imagePath)
	end,

	createImagePath = function(self, imageName)
		local path = self:createSmartPath(imageName)
		return "resources/" .. path .. ".png"
	end,

	createSmartPath = function(self, imageName)
		if STRING_UTIL:endsWith(string.lower(imageName), "map") then
			return "zones/maps/" .. imageName
		else
			return imageName
		end
	end,

	loadFromPath = function(self, imagePath)
		local image = love.graphics.newImage(imagePath)
    	image:setFilter("nearest", "nearest")
    	return image
    end,
}
