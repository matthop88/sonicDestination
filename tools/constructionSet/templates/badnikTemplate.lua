local COLOR = require("tools/lib/colors")

local BADNIK = require("tools/constructionSet/templates/badnik")

return {
    create = function(self, name, spritePath, containerWidth, containerHeight)
        local coreBadnik    = BADNIK:create(name, spritePath, containerWidth, containerHeight)
        local workingBadnik = nil

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
   
            newObject = function(self) 
                local xFlip = 1
                if workingBadnik then xFlip = workingBadnik.xFlip end
                workingBadnik = BADNIK:create(self.name, self.spritePath, nil, nil, xFlip) 
                return workingBadnik
            end,
        }
    end,
}
