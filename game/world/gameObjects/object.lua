return {
    create = function(self, spriteName, x, y, graphics)
        local spriteFactory = requireRelative("sprites/spriteFactory", { GRAPHICS = graphics })
        local SPRITE = spriteFactory:create(spriteName)

        return {
            x        = x,
            y        = y,
            graphics = graphics,

            draw = function(self)
                SPRITE:draw(self.x, self.y)
            end,

            drawHitBox = function(self)
                self.graphics:setColor(1, 0, 0, 0.5)
                self.graphics:setLineWidth(2)
                SPRITE:drawHitBox(self.x, self.y)
            end,

            update = function(self, dt)
                SPRITE:update(dt)
            end,

            isForeground = function(self)
                return SPRITE:isForeground()
            end,
        }
    end,
}
