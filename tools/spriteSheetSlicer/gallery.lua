local Editor = {
    create = function(self)
        return {
            draw = function(self)
                love.graphics.setColor(0.3, 0.3, 0.3, 0.7)
                love.graphics.rectangle("fill", 228, 50,  568, 568)
                love.graphics.setColor(0.2, 0.2, 0.2, 0.9)
                love.graphics.rectangle("fill", 312, 84,  400, 400)
                love.graphics.setColor(0.5, 0.5, 0.5)
                love.graphics.rectangle("line", 311, 83,  402, 402)
                love.graphics.setColor(1, 1, 1)
                love.graphics.rectangle("line", 228, 50,  568, 568)
            end,
        }
    end,
}

local GallerySlot = {
    create = function(self, x, y, w, h, image, spriteRect)
        local scale     = 1
        local maxScale  = 2.5
        local zoomSpeed = 18
        
        return {
            
            draw = function(self)
                self:drawBorder()
                self:drawSprite()
            end,

            update = function(self, dt)
                if self:isInsideRect(love.mouse.getPosition()) then scale = math.min(maxScale, scale + (dt * zoomSpeed))
                else                                                scale = math.max(1,        scale - (dt * zoomSpeed))   end
            end,

            mousepressed = function(self, mx, my)
                return self:isInsideRect(mx, my)
            end,
            
            drawBorder = function(self)
                love.graphics.setColor(1, 1, 1)
                love.graphics.setLineWidth(2)
                love.graphics.rectangle("line", x, y, w, h)
            end,

            drawSprite = function(self)
                love.graphics.draw(image, spriteRect.quad, 
                           x + (w / 2) - (spriteRect.w * scale / 2), 
                           y + (h / 2) - (spriteRect.h * scale / 2), 0, scale, scale)
            end,

            isInsideRect = function(self, px, py)
                return px >= x and px <= x + w and py >= y and py <= y + h
            end,
        }
    end,
}

return {
    slots  = { },
    editor = Editor:create(),

    init = function(self, spriteRects)
        local image = getImageViewer():getImage()
        for n, spriteRect in ipairs(spriteRects) do
            spriteRect.quad = self:createQuad(spriteRect, image)
            table.insert(self.slots, GallerySlot:create((n * 73) - 65, 696, 60, 60, image, spriteRect))
        end
        return self
    end,

    createQuad = function(self, spriteRect, image)
        return love.graphics.newQuad(spriteRect.x, spriteRect.y, spriteRect.w, spriteRect.h,
                                     image:getWidth(), image:getHeight())
    end,
    
    draw = function(self)
        self:drawBackground()
        self:drawSlotBorders()
        self:drawSprites()
        self.editor:draw()
    end,

    update = function(self, dt)
        for _, gallerySlot in ipairs(self.slots) do
            gallerySlot:update(dt)
        end
    end,

    mousepressed = function(self, mx, my)
        for _, gallerySlot in ipairs(self.slots) do
            if gallerySlot:mousepressed(mx, my) then
                return true
            end
        end
    end,
    
    drawBackground = function(self)
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", 0, 684, 1024, 86)
        love.graphics.setColor(1, 1, 1)
    end,

    drawSlotBorders = function(self)
        for _, gallerySlot in ipairs(self.slots) do
            gallerySlot:drawBorder()
        end
    end,

    drawSprites = function(self)
        for _, gallerySlot in ipairs(self.slots) do
            gallerySlot:drawSprite()
        end
    end,
}
