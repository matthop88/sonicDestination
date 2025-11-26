return {
    create = function(self, spriteName, x, y, graphics)
        local spriteFactory = requireRelative("sprites/spriteFactory", { GRAPHICS = graphics })
        local SPRITE = spriteFactory:create(spriteName)

        return {
            x        = x,
            y        = y,
            graphics = graphics,
            HITBOX   = nil,

            draw = function(self)
                SPRITE:draw(self.x, self.y)
            end,

            drawHitBox = function(self)
                local hitBox = self:getHitBox()
                if hitBox then
                    hitBox:draw(self.graphics, { 1, 0, 0, 0.8 }, 2)
                end
            end,

            getHitBox = function(self)
                if self.HITBOX == nil then
                    self.HITBOX = requireRelative("collision/hitBoxes/hitBox"):create(SPRITE:getHitBox())
                end
                return self.HITBOX
            end,

            update = function(self, dt)
                SPRITE:update(dt)
                self:updateHitBox(dt)
            end,

            updateHitBox = function(self, dt)
                local hitBox = self:getHitBox()
                if hitBox then hitBox:update(self.x, self.y) end
            end,

            isForeground = function(self)
                return SPRITE:isForeground()
            end,
        }
    end,
}
