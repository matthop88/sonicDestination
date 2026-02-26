local COLOR = require("tools/lib/colors")

local ITEM = {
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

return {
    create = function(self, name, spritePath, containerWidth, containerHeight)
        local coreItem = ITEM:create(name, spritePath, containerWidth, containerHeight)

        return {
            name       = name,
            spritePath = spritePath,
            hasFocus   = false,
            isSelected = false,
            
            drawInContainer = function(self, graphics, x, y, w, h)
                graphics:setColor(COLOR.PURE_WHITE)
                if self.isSelected or self.hasFocus then coreItem:draw(graphics, x, y, w, h)
                else                                     coreItem:drawThumbnail(graphics, x, y, w, h) end 
            end,  

            updateInContainer = function(self, dt)
                if self.hasFocus or self.isSelected then
                    coreItem:update(dt)
                end
            end,

            gainFocus = function(self) self.hasFocus = true    end,
            loseFocus = function(self) self.hasFocus = false   end, 

            select    = function(self) self.isSelected = true  end,
            deselect  = function(self) self.isSelected = false end,
      
            newObject = function(self) return ITEM:create(self.name, self.spritePath) end,
        }
    end,
}
