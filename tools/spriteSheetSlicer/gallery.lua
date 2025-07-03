local GallerySlot = {
    create = function(self, x, y, w, h, image, spriteRect)
        return {
            draw = function(self)
                self:drawBorder()
                self:drawSprite()
            end,

            drawBorder = function(self)
                love.graphics.setColor(1, 1, 1)
                love.graphics.setLineWidth(2)
                love.graphics.rectangle("line", x, y, w, h)
            end,

            drawSprite = function(self)
                love.graphics.draw(image, spriteRect.quad, 
                           x + (w / 2) - (spriteRect.w / 2), 
                           y + (h / 2) - (spriteRect.h / 2), 0, 1, 1)
            end,

            isInsideRect = function(self, px, py)
                return px >= x and px <= x + w and py >= y and py <= y + h
            end,
        }
    end,
}

return {
    spriteRects = {
        { x =  41, y = 347, w = 26, h = 39 },
        { x = 102, y = 346, w = 29, h = 40 },
        { x = 162, y = 345, w = 39, h = 40 },
        { x = 224, y = 346, w = 39, h = 39 },
        { x = 293, y = 347, w = 26, h = 39 },
        { x = 355, y = 346, w = 28, h = 40 },
        { x = 412, y = 345, w = 40, h = 38 },
        { x = 476, y = 346, w = 39, h = 39 },
    },

    slots = { },

    init = function(self)
        local image = getImageViewer():getImage()
        for n, spriteRect in ipairs(self.spriteRects) do
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
        self:drawSlots()
    end,

    drawBackground = function(self)
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", 0, 684, 1024, 86)
        love.graphics.setColor(1, 1, 1)
    end,

    drawSlots = function(self)
        for _, gallerySlot in ipairs(self.slots) do
            gallerySlot:draw()
        end
    end,
}
