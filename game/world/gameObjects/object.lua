local SOUND_MANAGER = requireRelative("sound/soundManager")

return {
    create = function(self, object, graphics)
        local spriteFactory = requireRelative("sprites/spriteFactory", { GRAPHICS = graphics })
        local SPRITE        = spriteFactory:create("objects/" .. object.obj)

        return {
            x        = object.x,
            y        = object.y,
            object   = object,
            graphics = graphics,
            HITBOX   = nil,
            name     = object.obj,
            deleted  = false,
            active   = not object.inactive,
            sprite   = SPRITE,

            draw = function(self) 
                if self.active then
                    self.sprite:draw(self.x, self.y) 
                end
            end,

            drawHitBox = function(self)
                local hitBox = self:getHitBox()
                if hitBox then hitBox:draw(self.graphics, { 1, 0, 0, 0.8 }, 2) end
            end,

            getHitBox = function(self)
                if self.active then
                    if     self.sprite:getHitBox() == nil then self.HITBOX = nil
                    elseif self.HITBOX             == nil then self.HITBOX = requireRelative("collision/hitBoxes/hitBox"):create(self.sprite:getHitBox()) end
                    return self.HITBOX
                end
            end,

            update = function(self, dt)
                if self.active then
                    self.sprite:update(dt)
                    self:updateHitBox(dt)
                    self.deleted = self.sprite.deleted
                end
            end,

            updateHitBox = function(self, dt)
                local hitBox = self:getHitBox()
                if hitBox then hitBox:update(self.x, self.y) end
            end,

            setAnimation = function(self, name) self.sprite:setCurrentAnimation(name) end,
            isForeground = function(self)       return self.sprite:isForeground()     end,
            isPlayer     = function(self)       return false                          end,

            onTerminalCollisionWithPlayer = function(self, player)
                -- do nothing
            end,
        }
    end,
}
