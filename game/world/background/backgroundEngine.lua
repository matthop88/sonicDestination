return {
	createFromFile = function(self, filename)
		local bgData = requireRelative("resources/zones/backgrounds/" .. filename)
		local bgImgPath = relativePath("resources/images/backgrounds/" .. bgData.bgImageName .. ".png")

		local bgImg = love.graphics.newImage(bgImgPath)
		bgImg:setFilter("nearest", "nearest")

		return ({
			bgImg   = bgImg,
			bgData  = bgData,
			slices  = {},

			init = function(self)
				self.slices = {}
				local y = 0
				for _, slice in ipairs(self.bgData.slices) do
					table.insert(self.slices, {
						y = y,
						quad = love.graphics.newQuad(slice.x, slice.y, slice.w, slice.h, self.bgImg:getWidth(), self.bgImg:getHeight())
					})
					y = y + slice.h
				end

				return self
			end,

			draw = function(self, graphics)
				local oldScale = graphics:getScale()
				graphics:setScale(2)
				local x0, y0 = graphics:screenToImageCoordinates(0, 0)
				graphics:setColor(0, 0.57, 1.0)
				graphics:rectangle("fill", graphics:calculateViewport())
				graphics:setColor(1, 1, 1)
				for _, slice in ipairs(self.slices) do
					graphics:draw(self.bgImg, slice.quad, x0, y0 + slice.y, 0, 1, 1)
				end
				graphics:setScale(oldScale)
			end,
			    
		}):init()
	end,
}
