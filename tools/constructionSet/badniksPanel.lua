local COLOR = require("tools/lib/colors")
local BADNIKS

-- A BADNIK is an object. It contains a sprite, and can draw itself into a space of optionally specified dimensions.

local BADNIK = {
    create = function(self, name, spritePath)
        return {
            name       = name,
            sprite     = require("tools/lib/sprites/sprite"):create(spritePath, 0, 0),
            hasFocus   = false,
            isSelected = false,
            
            draw = function(self, graphics, x, y, w, h)
                local scale = 1
                local offX, offY = 0, 0
                if w and h then 
                    scale = math.min((w / self.sprite:getW()), (h / self.sprite:getH())) * 0.9
                    offX = w / 2
                    offY = h / 2
                end
                
                graphics:setColor(COLOR.PURE_WHITE)
                self.sprite:drawAt(graphics, x + offX, y + offY, scale, scale)
                
            end,  

            updateInContainer = function(self, dt)
                if self.hasFocus or self.isSelected then
                    self.sprite:update(dt)
                end
            end,

            gainFocus = function(self) self.hasFocus = true    end,
            loseFocus = function(self) self.hasFocus = false   end, 

            select    = function(self) self.isSelected = true  end,
            unselect  = function(self) self.isSelected = false end,
   
        }
    end,
}
        
return {
    create = function(self)
        local badnikList = {}
        table.insert(badnikList, BADNIK:create("motobug", "objects/motobug"))

        local palette   = require("tools/constructionSet/palette"):create { objects = badnikList, CONTAINER_WIDTH = 96, CONTAINER_HEIGHT = 96 }

        return {
            draw               = function(self, graphics)   palette:draw(graphics)             end,
            update             = function(self, dt, mx, my) palette:update(dt, mx, my)         end,
            handleMousepressed = function(self, mx, my)     palette:handleMousepressed(mx, my) end,
        
        }
    end,
}

