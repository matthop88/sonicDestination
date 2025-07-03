local GallerySlot = {
    create = function(self, x, y, w, h, image, spriteRect)
        return {
            x = x,   y = y,   w = w,   h = h,

            image      = image,
            spriteRect = spriteRect,

            draw = function(self)
                love.graphics.setColor(1, 1, 1)
                love.graphics.setLineWidth(2)
                love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
                love.graphics.draw(self.image, self.spriteRect.quad,
                    self.x + (self.w / 2) - (self.spriteRect.w / 2),
                    self.y + (self.h / 2) - (self.spriteRect.h / 2),
                    0, 1, 1)
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
        self:initQuads()
        return self
    end,

    initQuads = function(self)
        local image = getImageViewer():getImage()
        for n, spriteRect in ipairs(self.spriteRects) do
            spriteRect.quad = love.graphics.newQuad(spriteRect.x, spriteRect.y, spriteRect.w, spriteRect.h,
                                                    image:getWidth(), image:getHeight())

            table.insert(self.slots, GallerySlot:create((n * 73) - 65, 696, 60, 60, image, spriteRect))
        end
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
