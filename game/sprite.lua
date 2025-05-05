local COLOR_PURE_WHITE = { 1, 1, 1 }

return ({
    image    = love.graphics.newImage(relativePath("resources/images/spriteSheets/sonic1Transparent.png")),
    standing = {
        rect = { x = 43, y = 257, w = 32, h = 40 },
        quad = nil,
    },
    
    offset   = { x = 16, y = 20 },
    scale    = { x =  3, y =  3 },

    init = function(self)
        self.standing.quad = love.graphics.newQuad(self.standing.rect.x,  self.standing.rect.y,
                                                   self.standing.rect.w,  self.standing.rect.h,
                                                   self.image:getWidth(), self.image:getHeight())
        self.image:setFilter("nearest", "nearest")
        return self
    end,

    draw = function(self, x, y)
        love.graphics.setColor(COLOR_PURE_WHITE)
        love.graphics.draw(self.image,        self.standing.quad,
                           self:getImageX(x), self:getImageY(y),
                        0, self.scale.x,      self.scale.y)
    end,

    --------------------------------------------------------------
    --                  Specialized Functions                   --
    --------------------------------------------------------------

    getImageX = function(self, x) return x - (self.offset.x * self.scale.x) end,
    getImageY = function(self, y) return y - (self.offset.y * self.scale.y) end,
        
    flipX     = function(self)    self.scale.x = self.scale.x * -1          end,
          
}):init()
