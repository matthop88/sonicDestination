local COLOR = require("tools/lib/colors")

return {
    create = function(self, object, x, y, w, h)
        return {
            object     = object,
            x          = x,
            y          = y,
            w          = w,
            h          = h,
            hasFocus   = false,
            isSelected = false,
            

            draw = function(self, graphics)
                if object.drawInContainer then object:drawInContainer(graphics, self.x, self.y, self.w, self.h)
                else                           object:draw(graphics, self.x, self.y, self.w, self.h)        end
                
                graphics:setColor(self:getOverlayColor())
                graphics:rectangle("fill", self.x, self.y, self.w, self.h)
                graphics:setColor(self:getOutlineColor())
                graphics:setLineWidth(self:getOutlineWidth())
                graphics:rectangle("line", self.x - 1, self.y - 1, self.w + 2, self.h + 2)
                graphics:setLineWidth(1)
            end,

            isInside = function(self, x, y)
                return x >= self.x and x <= self.x + self.w and y >= self.y and y <= self.y + self.h
            end,

            gainFocus = function(self) 
                self.hasFocus = true 
                if self.object.gainFocus then self.object:gainFocus() end 
            end,

            loseFocus = function(self) 
                self.hasFocus = false 
                if self.object.loseFocus then self.object:loseFocus() end
            end,

            getOutlineColor = function(self)
                if     self.isSelected then return COLOR.PURE_WHITE
                elseif self.hasFocus   then return COLOR.LIGHT_YELLOW
                else                        return COLOR.LIGHT_GREY end
            end,

            getOverlayColor = function(self)
                if     self.isSelected then return { 0, 0, 0, 0   }
                else                        return { 0, 0, 0, 0.5 } end
            end,

            getOutlineWidth = function(self)
                if self.hasFocus or self.isSelected then return 3
                else                                     return 1 end
            end,

            select   = function(self) self.isSelected = true  end,
            unselect = function(self) self.isSelected = false end,
        }
    end,
}
