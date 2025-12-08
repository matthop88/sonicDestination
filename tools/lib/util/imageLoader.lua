return {
	images = {},

	loadImage = function(self, imagePath)
		local image = self.images[imagePath]
		if image == nil then
			image = love.graphics.newImage(imagePath)
			image:setFilter("nearest", "nearest")
			self.images[imagePath] = image
		end
		return image
	end,           
}
