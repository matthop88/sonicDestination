return {
    create = function(self, graphics, w, h)
        return {
            buffer = love.graphics.newCanvas(w, h),

            getFontHeight = function(self)       return graphics:getFontHeight()     end,
            getFontWidth  = function(self, text) return graphics:getFontWidth(text) end, 

            setColor     = function(self, arg1, arg2, arg3, arg4)
                graphics:setColor(arg1, arg2, arg3, arg4)
            end,

            setAlpha     = function(self, alpha)
                graphics:setAlpha(alpha)
            end,

            setLineWidth = function(self, lineWidth)
                graphics:setLineWidth(lineWidth)
            end,

            setFont     = function(self, font)
                graphics:setFont(font)
            end,

            setFontSize = function(self, fontSize)
                graphics:setFontSize(fontSize)
            end,

            rectangle = function(self, mode, x, y, w, h)
                love.graphics.setCanvas(self.buffer)
                graphics:rectangle(mode, x, y, w, h)
                love.graphics.setCanvas()
            end,

            line      = function(self, x1, y1, x2, y2)
                love.graphics.setCanvas(self.buffer)
                graphics:line(x1, y1, x2, y2)
                love.graphics.setCanvas()
            end,

            circle    = function(self, mode, x, y, radius)
                love.graphics.setCanvas(self.buffer)
                graphics:circle(mode, x, y, radius)
                love.graphics.setCanvas()
            end,

            draw      = function(self, image, quad, x, y, r, sx, sy)
                love.graphics.setCanvas(self.buffer)
                graphics:draw(image, quad, x, y, r, sx, sy)
                love.graphics.setCanvas()
            end,

            printf    = function(self, text, x, y, w, align)
                love.graphics.setCanvas(self.buffer)
                graphics:printf(text, x, y, w, align)
                love.graphics.setCanvas()
            end,

            getX = function(self) return graphics:getX() end,
            getY = function(self) return graphics:getY() end,
            
            setX = function(self, x) graphics:setX(x) end,
            setY = function(self, y) graphics:setY(y) end,

            moveImage = function(self, deltaX, deltaY)
                graphics:moveImage(deltaX, deltaY)
            end,

            getScale = function(self)        return graphics:getScale() end,
            setScale = function(self, scale) graphics:setScale(scale)   end,

            screenToImageCoordinates = function(self, mx, my)
                return graphics:screenToImageCoordinates(mx, my)
            end,

            adjustScaleGeometrically = function(self, delta)
                graphics:adjustScaleGeometrically(delta)
            end,

            syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
                graphics:syncImageCoordinatesWithScreen(imageX, imageY, screenX, screenY)
            end,

            syncImageXWithScreen = function(self, imageX, screenX)
                graphics:syncImageXWithScreen(imageX, screenX)
            end,

            syncImageYWithScreen = function(self, imageY, screenY)
                graphics:syncImageYWithScreen(imageY, screenY)
            end,

            getScreenWidth  = function(self) return graphics:getScreenWidth()  end,
            getScreenHeight = function(self) return graphics:getScreenHeight() end,

            calculateViewportRect = function(self)
                return graphics:calculateViewportRect()
            end,

            calculateViewport = function(self)
                return graphics:calculateViewport()
            end,

            blitToScreen = function(self, x, y, c, r, sx, sy)
                x  = x  or 0
                y  = y  or 0
                r  = r  or 0
                sx = sx or 1
                sy = sy or 1
                c  = c  or { 1, 1, 1 }

                love.graphics.setColor(c)
                love.graphics.draw(self.buffer, x, y, r, sx, sy)
            end,

            saveImage = function(self, imgName)
                return self.buffer:newImageData():encode("png", imgName .. ".png")
            end,
        }
    end,
}
