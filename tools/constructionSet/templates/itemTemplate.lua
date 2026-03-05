local COLOR = require("tools/lib/colors")

local ITEM = require("tools/constructionSet/templates/item")

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
