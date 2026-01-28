local SOUND_MANAGER = requireRelative("sound/soundManager")
local SCRIPT_ENGINE = requireRelative("world/badniks/scripts/lib/scriptEngine")

local OBJECT_ID    = 0

return {
    create = function(self, object, graphics, WORLD)
        local spriteFactory = requireRelative("sprites/spriteFactory", { GRAPHICS = graphics })
        local SPRITE        = spriteFactory:create("objects/" .. object.obj)

        OBJECT_ID = OBJECT_ID + 1

        return {
            x        = object.x,
            y        = object.y,
            xFlip    = false,
            xSpeed   = 0,
            ySpeed   = 0,
            object   = object,
            graphics = graphics,
            HITBOX   = nil,
            name     = object.obj,
            deleted  = false,
            active   = not object.inactive,
            sprite   = SPRITE,
            world    = WORLD,
            id       = OBJECT_ID,
            
            getID    = function(self) return self.id end,

            draw = function(self) 
                if self.active then
                    self.sprite:draw(self.x, self.y) 
                end
                if self.selectedInVisualizer then
                    self.sprite:drawBorder(self.x, self.y)
                end
            end,

            drawThumbnail = function(self, GRAPHICS, x, y, sX, sY)
                self.sprite:drawScaled(GRAPHICS, x, y, sX, sY)
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
                    if self.script then SCRIPT_ENGINE:execute(dt, self.script.program, self) end
                    self.sprite:update(dt)
                    self:updateHitBox(dt)
                    self.deleted = self.sprite.deleted
                    self:setX(self:getX() + (self:getXVelocity() * dt))
                    self:setY(self:getY() + (self:getYSpeed()    * dt))
                end
            end,

            updateHitBox = function(self, dt)
                local hitBox = self:getHitBox()
                if hitBox then hitBox:update(self.x, self.y) end
            end,

            setAnimation = function(self, name) self.sprite:setCurrentAnimation(name) end,
            isForeground = function(self)       return self.sprite:isForeground()     end,
            isPlayer     = function(self)       return false                          end,

            onCollisionWithPlayer = function(self, player)
                -- do nothing
            end,

            getW = function(self) return self.sprite:getImageW() end,
            getH = function(self) return self.sprite:getImageH() end,

            getX = function(self) return self.x                  end,
            getY = function(self) return self.y                  end,
            setX = function(self, x)     self.x = x              end,
            setY = function(self, y)     self.y = y              end,

            getXVelocity = function(self)         
                if self.xFlip then return  self.xSpeed   
                else               return -self.xSpeed end
            end,

            setXSpeed    = function(self, xSpeed) self.xSpeed = xSpeed end,
                    
            getYSpeed    = function(self)         return self.ySpeed   end,
            setYSpeed    = function(self, ySpeed) self.ySpeed = ySpeed end,

            flipX        = function(self) 
                self.sprite:flipX() 
                self.xFlip = not self.xFlip
            end,

            getXFlip     = function(self) return self.xFlip      end,
            getSortValue = function(self) return self.x          end,

            locateVisually = function(self)
                local graphics = self.sprite:getGraphics()
                local centerX, centerY = graphics:getScreenWidth() / 2, graphics:getScreenHeight() / 2
                graphics:syncImageCoordinatesWithScreen(self.x, self.y, centerX, centerY)
            end,

            isOnScreen = function(self)
                local graphics = self.sprite:getGraphics()
                local sX, sY = graphics:imageToScreenCoordinates(self.x, self.y)
                return sX > 50 
                   and sY > 50 
                   and sX < graphics:getScreenWidth()  - 50
                   and sY < graphics:getScreenHeight() - 50
            end,
        }
    end,
}
