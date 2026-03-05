-- A BADNIK is an object. It contains a sprite, and can draw itself into a space of optionally specified dimensions.

return {
    create = function(self, name, spritePath, containerWidth, containerHeight, flipX)
        return ({
            xFlip = flipX or 1,

            init = function(self, name, spritePath, containerWidth, containerHeight)
                self.name   = name
                self.sprite = require("tools/lib/sprites/sprite"):create(spritePath, 0, 0)
                if self.xFlip == -1 then self.sprite:flipX() end
                self.scale  = 1
                if containerWidth and containerHeight then
                    self.scale = math.min((containerWidth / self.sprite:getW()), (containerHeight / self.sprite:getH())) * 0.9
                end

                return self
            end,

            getName = function(self) return self.name          end,
            getW    = function(self) return self.sprite:getW() end,
            getH    = function(self) return self.sprite:getH() end,

            draw    = function(self, graphics, x, y, w, h)
                self.sprite:drawAt(graphics, x, y, self.scale, self.scale)
            end,

            drawThumbnail = function(self, graphics, x, y, w, h)
                self.sprite:drawThumbnail(graphics, x, y, self.scale, self.scale)
            end,  

            update = function(self, dt) self.sprite:update(dt) end,
            flipX  = function(self)     
                self.sprite:flipX()   
                self.xFlip = -1 * self.xFlip 
            end,
            
            place        = function(self, map, x, y)
                self:release()
                return map:placeObject(self, math.floor(x), math.floor(y))
            end, 

            hold         = function(self) self.isHeld = true                    end,
            release      = function(self) self.isHeld = false                   end,

        }):init(name, spritePath, containerWidth, containerHeight)
    end,
}
