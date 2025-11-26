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
                local hitBox = SPRITE:getHitBox()
                if hitBox then
                    hitBox:draw(self.graphics, self.x, self.y, { 1, 0, 0, 0.8 }, 2)
                end
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
