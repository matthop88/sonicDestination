return {
    create = function(self, spriteName, x, y, graphics)
        local spriteFactory = requireRelative("sprites/spriteFactory", { GRAPHICS = graphics })
        local SPRITE = spriteFactory:create(spriteName)

        return {
            x = x,
            y = y,

            draw = function(self)
                SPRITE:draw(self.x, self.y)
            end,

            update = function(self, dt)
                SPRITE:update(dt)
            end,
        }
    end,
}
