return {
	
	createFromFile = function(self, filename, worldHeight)
		local bgData = requireRelative("resources/zones/backgrounds/" .. filename)
		local background = requireRelative("world/background/backgroundBuilder"):create(bgData)
		

		return ({
			bgData      = bgData,
			background  = background,
			slices      = {},
			prevX       = 0,
			height      = 0,
			worldHeight = worldHeight,

			COLORS      = requireRelative("world/effects/color/colorAnimation"):create {
				{ 0.71, 0.85, 0.99 }, 
				{ 0.56, 0.71, 0.99 }, 
				{ 0.42, 0.56, 0.99 }, 
				{ 0.42, 0.56, 0.71 },
			},
			init = function(self)
				self.slices = {}
				local y = 0
				for _, slice in ipairs(self.bgData.slices) do
					if slice.lineScrolling then self:addLineScrollingSlice(slice, y)
					else
						table.insert(self.slices, {
							x = 0,
							y = y,
							w = slice.w,
							xSpeed  = slice.xSpeed  or 0,
							xScalar = slice.xScalar,
							chunks = slice.chunks,
						})
					end
					y = y + slice.h
				end
				self.height = y
				print("Height = " .. self.height .. ", World Height = " .. self.worldHeight)

				return self
			end,

			addLineScrollingSlice = function(self, slice, y)
		        local delay = 0
		        for i = 0, slice.h - 1 do
		            table.insert(self.slices, { x = 0, w = slice.w, y = y + i, h = 1, sliceY = i, quad = nil, xScalar = slice.xScalar, xSpeed = slice.xSpeed or 0, chunks = slice.chunks,
		                lineScrolling = { amount = slice.lineScrolling.amount, speed = slice.lineScrolling.speed, delay = delay, timer = 0, hOffset = 0, xVelocity = -1 }})
		            delay = delay + (slice.lineScrolling.delaySpread or 1)
		        end
		    end,

			draw = function(self, graphics)
				local heightOfWorld = self.worldHeight
				local scalar = math.min((self.height - love.graphics:getHeight() / 3) / heightOfWorld, 0.3)
				local bgY = math.max(-self.height + (love.graphics:getHeight() / 3), math.min(0, graphics:getY() * scalar))
				local oldScale = graphics:getScale()
				graphics:setScale(3)
				graphics:setColor(0, 0.57, 1.0)
				graphics:rectangle("fill", graphics:calculateViewport())
				graphics:setColor(1, 1, 1)
				for _, slice in ipairs(self.slices) do
					self:drawSlice(graphics, slice, bgY)
				end
				graphics:setScale(oldScale)
			end,

			drawSlice = function(self, graphics, slice, bgY)
				local x0, y0 = graphics:screenToImageCoordinates(0, 0)
				local x9, _  = graphics:screenToImageCoordinates(love.graphics:getWidth(), 0)
				local x = slice.x
				if slice.lineScrolling then x = x + slice.lineScrolling.hOffset end
				local chunkNum = 1
				if x > 0 then 
					x = x - 1280
					chunkNum = #slice.chunks - 4
				end
				while x + x0 < x9 do
					local chunk = slice.chunks[chunkNum]
					if (x + 256) > 0 then
						if slice.lineScrolling then
							self.background:drawSlice(graphics, chunk, x0 + x, y0 + bgY + slice.y, slice)
						else
							self.background:drawChunk(graphics, chunk, x0 + x, y0 + bgY + slice.y, { self.COLORS:get(1), self.COLORS:get(2), self.COLORS:get(3), self.COLORS:get(4) })
						end
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

					if slice.lineScrolling then
		                slice.lineScrolling.timer = slice.lineScrolling.timer + (60 * dt)
		                if slice.lineScrolling.timer > slice.lineScrolling.delay then
		                    slice.lineScrolling.hOffset = slice.lineScrolling.hOffset + (slice.lineScrolling.xVelocity * slice.lineScrolling.speed * dt)
		                    if (slice.lineScrolling.hOffset > slice.lineScrolling.amount and slice.lineScrolling.xVelocity > 0) or (slice.lineScrolling.hOffset < -slice.lineScrolling.amount and slice.lineScrolling.xVelocity < 0) then
		                        slice.lineScrolling.xVelocity = slice.lineScrolling.xVelocity * -1
		                    end
		                end
            		end
				end
				self.prevX = graphics:getX()
				graphics:setScale(oldScale)
			end,
			    
		}):init()
	end,
}
