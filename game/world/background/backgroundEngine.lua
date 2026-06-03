return {
	
	createFromFile = function(self, filename)
		local bgData = requireRelative("resources/zones/backgrounds/" .. filename)
		local background = requireRelative("world/background/backgroundBuilder"):create(bgData)
		

		return ({
			bgData     = bgData,
			background = background,
			slices     = {},
			prevX      = 0,

			COLORS     = {
			    { base = { 0.71, 0.85, 0.99 }, delta = { -0.15, -0.14,  0.0  } },
			    { base = { 0.56, 0.71, 0.99 }, delta = { -0.14, -0.15,  0.0  } },
			    { base = { 0.42, 0.56, 0.99 }, delta = {  0.0,   0.0,  -0.28 } },
			    { base = { 0.42, 0.56, 0.71 }, delta = {  0.29,  0.29,  0.28 } },
			    offset = 1,
			    dx     = 0,
			    update = function(self, dt)
			        self.offset = self.offset + (9 * dt)
			        self.dx = self.offset - math.floor(self.offset)
			        if self.offset >= 5 then self.offset = self.offset - 4 end
			    end,
			    get = function(self, n)
			        local index = n + math.floor(self.offset)
			        if index > 4 then index = index - 4 end
			        local c = self[index]
			        return { c.base[1] + (c.delta[1] * self.dx), c.base[2] + (c.delta[2] * self.dx), c.base[3] + (c.delta[3] * self.dx) }
    			end,
			},

			init = function(self)
				self.slices = {}
				local y = 0
				for _, slice in ipairs(self.bgData.slices) do
					table.insert(self.slices, {
						x = 0,
						y = y,
						w = slice.w,
						xSpeed  = slice.xSpeed  or 0,
						xScalar = slice.xScalar,
						chunks = slice.chunks,
					})
					y = y + slice.h
				end

				return self
			end,

			draw = function(self, graphics)
				local oldScale = graphics:getScale()
				graphics:setScale(3)
				graphics:setColor(0, 0.57, 1.0)
				graphics:rectangle("fill", graphics:calculateViewport())
				graphics:setColor(1, 1, 1)
				for _, slice in ipairs(self.slices) do
					self:drawSlice(graphics, slice)
				end
				graphics:setScale(oldScale)
			end,

			drawSlice = function(self, graphics, slice)
				local x0, y0 = graphics:screenToImageCoordinates(0, 0)
				local x9, _  = graphics:screenToImageCoordinates(love.graphics:getWidth(), 0)
				local x = slice.x
				local chunkNum = 1
				if x > 0 then 
					x = x - 1280
					chunkNum = #slice.chunks - 4
				end
				while x + x0 < x9 do
					local chunk = slice.chunks[chunkNum]
					if (x + 256) > 0 then
						self.background:drawChunk(graphics, chunk, x0 + x, y0 + slice.y, { self.COLORS:get(1), self.COLORS:get(2), self.COLORS:get(3), self.COLORS:get(4) })
					end
					x = x + 256
					chunkNum = chunkNum + 1
					if chunkNum > #slice.chunks then chunkNum = 1 end
				end
			end,

			update = function(self, dt, graphics)
				self.COLORS:update(dt)
				local oldScale = graphics:getScale()
				graphics:setScale(3)
				local deltaX = graphics:getX() - self.prevX
				local x0, _ = graphics:screenToImageCoordinates(0, 0)
				local x9, _  = graphics:screenToImageCoordinates(love.graphics:getWidth(), 0)
				for _, slice in ipairs(self.slices) do
					slice.x = slice.x + (slice.xSpeed * dt)
					if slice.xScalar then
						slice.x = slice.x + (deltaX / slice.xScalar)
					end
					if     x0 + slice.x > x0 + slice.w then
						slice.x = slice.x - slice.w
					elseif x0 + slice.x < x9 - slice.w then
						slice.x = slice.x + slice.w
					end
				end
				self.prevX = graphics:getX()
				graphics:setScale(oldScale)
			end,
			    
		}):init()
	end,
}
