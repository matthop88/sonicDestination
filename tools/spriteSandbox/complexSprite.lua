return {
	create = function(self, sprites, x, y, w, h, offset)
		return {
			sprites  = sprites,
			x        = x,
			y        = y,
			w        = w,
			h        = h,
			xScale   = 1,
			visible  = true,
			id       = sprites[#sprites].id,
			offset   = offset,

			getID = function(self) return self.id end,
			getX  = function(self) return self.x  end,
			getY  = function(self) return self.y  end,
			getW  = function(self) return self.w  end,
			getH  = function(self) return self.h  end,
			setX  = function(self, x)
				for _, sprite in ipairs(self.sprites) do
					sprite:setX(x)
				end
				self.x = x
			end,
			setY  = function(self, y)
				for _, sprite in ipairs(self.sprites) do
					sprite:setY(y)
				end
				self.y = y
			end,
			draw  = function(self, GRAFX)
				GRAFX:setColor(1, 1, 1)
				for _, sprite in ipairs(self.sprites) do
					sprite:draw(GRAFX)
				end
			end,

			drawThumbnail = function(self, GRAFX, x, y, sX, sY)
				for _, sprite in ipairs(self.sprites) do
					sprite:drawThumbnail(GRAFX, x, y, sX, sY)
				end
			end,

			isInside = function(self, px, py)
				return px >= self.x - self.offset.x 
				   and px <= self.x - self.offset.x + self.w
				   and py >= self.y - self.offset.y
				   and py <= self.y - self.offset.y + self.h
			end,

			update = function(self, dt)
				for _, sprite in ipairs(self.sprites) do
					sprite:update(dt)
				end
			end,

			advanceAnimation = function(self)
				-- do nothing so far
			end,

			updateAnimation = function(self)
				-- do nothing so far
			end,

			isPlayer = function(self) return false end,

			isForeground = function(self) return false end,
			
			regressAnimation = function(self)
				-- do nothing so far
			end,

			toggleFreeze = function(self) 
				for _, sprite in ipairs(self.sprites) do
					sprite:toggleFreeze()
				end
			end,

			flipX        = function(self) 
				for _, sprite in ipairs(self.sprites) do
					sprite:flipX()
				end
			end,
				
		}
	end,
}
