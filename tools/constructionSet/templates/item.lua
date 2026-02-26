return {
    create = function(self, name, spritePath, containerWidth, containerHeight)
        return ({
            init = function(self, name, spritePath, containerWidth, containerHeight)
                self.name   = name
                self.sprite = require("tools/lib/sprites/sprite"):create(spritePath, 0, 0)
                self.scale  = 1
                if containerWidth and containerHeight then
                    self.scale = 8 / math.sqrt(math.max(self.sprite:getW(), self.sprite:getH()))
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

            update = function(self, dt)
                self.sprite:update(dt)
            end,

            flipX  = function(self)     
                -- do nothing
            end,

            place        = function(self, map, x, y)
                self:release()
                return map:placeObject(self, x, y)
            end, 

            hold         = function(self) self.isHeld = true    end,
            release      = function(self) self.isHeld = false   end,
            
        }):init(name, spritePath, containerWidth, containerHeight)
    end,
}
