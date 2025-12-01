local SOUND_MANAGER = requireRelative("sound/soundManager")
local ringPanRight  = true

return {
    create = function(self, object, graphics)
        local spriteFactory = requireRelative("sprites/spriteFactory", { GRAPHICS = graphics })
        local SPRITE        = spriteFactory:create("objects/" .. object.obj)

        return {
            x        = object.x,
            y        = object.y,
            graphics = graphics,
            HITBOX   = nil,
            name     = spriteName,
            deleted  = false,
            active   = not object.inactive,

            draw = function(self) 
                if self.active then
                    SPRITE:draw(self.x, self.y) 
                end
            end,

            drawHitBox = function(self)
                local hitBox = self:getHitBox()
                if hitBox then hitBox:draw(self.graphics, { 1, 0, 0, 0.8 }, 2) end
            end,

            getHitBox = function(self)
                if self.active then
                    if     SPRITE:getHitBox() == nil then self.HITBOX = nil
                    elseif self.HITBOX        == nil then self.HITBOX = requireRelative("collision/hitBoxes/hitBox"):create(SPRITE:getHitBox()) end
                    return self.HITBOX
                end
            end,

            update = function(self, dt)
                if self.active then
                    SPRITE:update(dt)
                    self:updateHitBox(dt)
                    self.deleted = SPRITE.deleted
                end
            end,

            updateHitBox = function(self, dt)
                local hitBox = self:getHitBox()
                if hitBox then hitBox:update(self.x, self.y) end
            end,

            setAnimation = function(self, name) SPRITE:setCurrentAnimation(name) end,
            isForeground = function(self)       return SPRITE:isForeground()     end,
            isPlayer     = function(self)       return false                     end,

            onTerminalCollisionWithPlayer = function(self, player)
                if self.name == "ring" then
                    self:setAnimation("dissolving")
                    if ringPanRight then SOUND_MANAGER:play("ringCollectR")
                    else                 SOUND_MANAGER:play("ringCollectL") end
                    ringPanRight = not ringPanRight
                end
            end,
        }
    end,
}
