local COLOR = require("tools/lib/colors")

return {
    create = function(self, object, x, y, w, h)
        return {
            object     = object,
            x          = x,
            y          = y,
            w          = w,
            h          = h,
            cx         = x + (w / 2),
            cy         = y + (h / 2),
            hasFocus   = false,
            isSelected = false,
            

            draw = function(self, graphics)
                if object.drawInContainer then object:drawInContainer(graphics, self.cx, self.cy, self.w, self.h) end
                graphics:setColor(self:getOverlayColor())
                graphics:rectangle("fill", self.x, self.y, self.w, self.h)
                graphics:setColor(self:getOutlineColor())
                graphics:setLineWidth(self:getOutlineWidth())
                graphics:rectangle("line", self.x - 1, self.y - 1, self.w + 2, self.h + 2)
                graphics:setLineWidth(1)
            end,

            update = function(self, dt)
                if     object.updateInContainer then object:updateInContainer(dt) end
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

            select   = function(self) 
                self.isSelected = true  
                if self.object.select then self.object:select() end
            end,

            deselect = function(self) 
                self.isSelected = false 
                if self.object.deselect then self.object:deselect() end
            end,

            getOutlineColor = function(self)
                if     self.isSelected then return COLOR.PURE_WHITE
                elseif self.hasFocus   then return COLOR.LIGHT_YELLOW
                else                        return COLOR.LIGHT_GREY end
            end,

            getOverlayColor = function(self)
                if not self.hasFocus and not self.isSelected then return { 0, 0, 0, 0.5 }
                else                                              return { 0, 0, 0, 0   } end
            end,

            getOutlineWidth = function(self)
                if self.hasFocus or self.isSelected then return 3
                else                                     return 1 end
            end,

            newObject = function(self)
                return self.object:newObject()
            end,
        }
    end,
}
