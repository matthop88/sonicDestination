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

    init = function(self)
        self.image = getImageViewer():getImage()
        self:initQuads()
        return self
    end,

    initQuads = function(self)
        for _, spriteRect in ipairs(self.spriteRects) do
            spriteRect.quad = love.graphics.newQuad(spriteRect.x, spriteRect.y, spriteRect.w, spriteRect.h,
                                                    self.image:getWidth(), self.image:getHeight())
        end
    end,
    
    draw = function(self)
        self:drawBackground()
        self:drawSlots()
        self:drawSprites()
    end,

    drawBackground = function(self)
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.rectangle("fill", 0, 684, 1024, 86)
        love.graphics.setColor(1, 1, 1)
    end,

    drawSlots = function(self)
        love.graphics.setLineWidth(2)
        for x = 8, 1024, 73 do
            love.graphics.rectangle("line", x, 696, 60, 60)
        end
    end,
    
    drawSprites = function(self)
        for n, spriteRect in ipairs(self.spriteRects) do
            self:drawSpriteCentered(spriteRect, (n * 73) - 35, 726)
        end
    end,

    drawSpriteCentered = function(self, spriteRect, x, y)
        love.graphics.draw(self.image, spriteRect.quad, x - (spriteRect.w / 2), y - (spriteRect.h / 2), 0, 1, 1)
    end,
}
