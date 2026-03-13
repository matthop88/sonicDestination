return {
	create = function(self)
		return {
			setColor = function(self, arg1, arg2, arg3, arg4)
				love.graphics.setColor(arg1, arg2, arg3, arg4)
			end,

			setAlpha = function(self, alpha)
				local r, g, b = love.graphics.getColor()
				love.graphics.setColor(r, g, b, alpha or 1)
			end,

			getAlpha = function(self)
				local r, g, b, a = love.graphics.getColor()
				return a
			end,

			setLineWidth = function(self, lineWidth)
				love.graphics.setLineWidth(lineWidth)
			end,

			setFont = function(self, font)
				love.graphics.setFont(font)
			end,

			setFontSize = function(self, fontSize)
				love.graphics.setFont(love.graphics.newFont(fontSize))
			end,

			getFontHeight = function(self)
				return love.graphics.getFont():getHeight()
			end,

			getFontWidth = function(self, text)
				return love.graphics.getFont():getWidth(text)
			end,

			clear = function(self, arg1, arg2, arg3, arg4)
				love.graphics.clear(arg1, arg2, arg3, arg4)
			end,

			rectangle = function(self, mode, x, y, w, h)
				love.graphics.rectangle(mode, x, y, w, h)
			end,

			line = function(self, x1, y1, x2, y2)
				love.graphics.line(x1, y1, x2, y2)
			end,

			circle = function(self, mode, x, y, radius)
				love.graphics.circle(mode, x, y, radius)
			end,

			ellipse = function(self, mode, x, y, rx, ry)
				love.graphics.ellipse(mode, x, y, rx, ry)
			end,

			draw = function(self, image, quad, x, y, r, sx, sy)
				love.graphics.draw(image, quad, x, y, r, sx, sy)
			end,

			drawImage = function(self, image, x, y)
				love.graphics.draw(image, x, y)
			end,

			printf = function(self, text, x, y, w, align)
				love.graphics.printf(text, x, y, w, align)
			end,

			print = function(self, text, x, y)
				love.graphics.print(text, x, y)
			end,

			getX = function(self) return 0 end,
			getY = function(self) return 0 end,
			
			setX = function(self, x) end,
			setY = function(self, y) end,

			moveImage = function(self, deltaX, deltaY) end,

			getScale = function(self) return 1 end,
			setScale = function(self, scale) end,

			screenToImageCoordinates = function(self, mx, my)
				return mx, my
			end,

			imageToScreenCoordinates = function(self, x, y)
				return x, y
			end,

			adjustScaleGeometrically = function(self, delta) end,

			syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY) end,

			syncImageXWithScreen = function(self, imageX, screenX) end,

			syncImageYWithScreen = function(self, imageY, screenY) end,

			getScreenWidth = function(self) return love.graphics.getWidth() end,
			getScreenHeight = function(self) return love.graphics.getHeight() end,

			calculateViewportRect = function(self)
				return 0, 0, love.graphics.getWidth(), love.graphics.getHeight()
			end,

			calculateViewport = function(self)
				return {
					left = 0,
					right = love.graphics.getWidth(),
					top = 0,
					bottom = love.graphics.getHeight(),
				}
			end,
		}
	end,
}
