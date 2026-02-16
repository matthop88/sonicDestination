local COLOR     = require("tools/lib/colors")
local CONTAINER = require("tools/constructionSet/container")

return {
    create = function(self, params)
        local LEFTMOST = 31
        local TOPMOST  = 16
        local CONTAINER_WIDTH  = params.CONTAINER_WIDTH  or 128
        local CONTAINER_HEIGHT = params.CONTAINER_HEIGHT or 128

        local containers = {}
        local STICKY_MOUSE = params.STICKY_MOUSE

        return ({
            init = function(self, objects)
                local x, y = LEFTMOST, TOPMOST
                for _, obj in ipairs(objects) do
                    table.insert(containers, CONTAINER:create(obj, x, y, CONTAINER_WIDTH, CONTAINER_HEIGHT, self))
                    x = x + CONTAINER_WIDTH + 15
                    if x > 1080 then
                        x = LEFTMOST
                        y = y + CONTAINER_HEIGHT + 15
                    end
                end

                return self
            end,

            draw = function(self, graphics)
                graphics:clear(COLOR.DARK_GREY)
                for _, c in ipairs(containers) do
                    c:draw(graphics)
                end
            end,

            update = function(self, dt, mx, my)
                for _, c in ipairs(containers) do
                    if c:isInside(mx, my) then c:gainFocus()
                    else                       c:loseFocus() end
                    c:update(dt)
                end
            end,

            handleMousepressed = function(self, mx, my)
                for _, c in ipairs(containers) do
                    if c:isInside(mx, my) then 
                        c:select()
                        STICKY_MOUSE:onSelect(c)
                    else                       
                        c:deselect() 
                        STICKY_MOUSE:onDeselect(c)
                    end
                end
            end,

            getSelectedIndex = function(self)
                for n, c in ipairs(containers) do
                    if c.isSelected then return n end
                end
            end,

            selectNext = function(self)
                local n = self:getSelectedIndex()
                if n then
                    containers[n]:deselect()
                    n = n + 1
                    if n > #containers then n = 1 end
                    containers[n]:select()
                    STICKY_MOUSE:onSelect(containers[n])
                end
            end,

            selectPrev = function(self)
                local n = self:getSelectedIndex()
                if n then
                    containers[n]:deselect()
                    n = n - 1
                    if n < 1 then n = #containers end
                    containers[n]:select()
                    STICKY_MOUSE:onSelect(containers[n])
                end
            end,

        }):init(params.objects)
    end,
}
 
