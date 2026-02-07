local COLOR = require("tools/lib/colors")
local BADNIKS

-- A BADNIK is an object. It contains a sprite, and can draw itself into a space of optionally specified dimensions.

local BADNIK = {
    create = function(self, name, spritePath, containerWidth, containerHeight)
        return ({
            init = function(self, name, spritePath, containerWidth, containerHeight)
                self.name   = name
                self.sprite = require("tools/lib/sprites/sprite"):create(spritePath, 0, 0)
                self.scale  = 1
                if containerWidth and containerHeight then
                    self.scale = math.min((containerWidth / self.sprite:getW()), (containerHeight / self.sprite:getH())) * 0.9
                end

                return self
            end,

            draw = function(self, graphics, x, y, w, h)
                self.sprite:drawAt(graphics, x, y, self.scale, self.scale)
            end,

            drawThumbnail = function(self, graphics, x, y, w, h)
                self.sprite:drawThumbnail(graphics, x, y, self.scale, self.scale)
            end,  

            update = function(self, dt) self.sprite:update(dt) end,
            flipX  = function(self)     self.sprite:flipX()    end,
            
        }):init(name, spritePath, containerWidth, containerHeight)
    end,
}

local BADNIK_TEMPLATE = {
    create = function(self, name, spritePath, containerWidth, containerHeight)
        local coreBadnik = BADNIK:create(name, spritePath, containerWidth, containerHeight)
        
        return {
            name       = name,
            spritePath = spritePath,
            hasFocus   = false,
            isSelected = false,
            
            drawInContainer = function(self, graphics, x, y, w, h)
                graphics:setColor(COLOR.PURE_WHITE)
                if self.isSelected or self.hasFocus then coreBadnik:draw(graphics, x, y, w, h)
                else                                     coreBadnik:drawThumbnail(graphics, x, y, w, h) end
            end,  

            updateInContainer = function(self, dt)
                if self.hasFocus or self.isSelected then
                    coreBadnik:update(dt)
                end
            end,

            gainFocus = function(self) self.hasFocus = true    end,
            loseFocus = function(self) self.hasFocus = false   end, 

            select    = function(self) self.isSelected = true  end,
            deselect  = function(self) self.isSelected = false end,
   
            newObject = function(self) return BADNIK:create(self.name, self.spritePath) end,
        }
    end,
}
        
return {
    create = function(self, stickyMouse)
        local badnikList = {}
        local WIDTH, HEIGHT = 96, 96
        table.insert(badnikList, BADNIK_TEMPLATE:create("motobug", "objects/motobug", WIDTH, HEIGHT))

        local palette   = require("tools/constructionSet/palette"):create { objects = badnikList, CONTAINER_WIDTH = WIDTH, CONTAINER_HEIGHT = HEIGHT, STICKY_MOUSE = stickyMouse }

        return {
            draw               = function(self, graphics)   palette:draw(graphics)             end,
            update             = function(self, dt, mx, my) palette:update(dt, mx, my)         end,
            handleMousepressed = function(self, mx, my)     palette:handleMousepressed(mx, my) end,
        
        }
    end,
}

