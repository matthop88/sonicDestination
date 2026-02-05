local COLOR     = require("tools/lib/colors")
local CONTAINER = require("tools/constructionSet/container")

return {
    create = function(self, params)
        local LEFTMOST = 31
        local TOPMOST  = 16
        local CONTAINER_WIDTH  = params.CONTAINER_WIDTH  or 128
        local CONTAINER_HEIGHT = params.CONTAINER_HEIGHT or 128

        local containers = {}

        return ({
            init = function(self, objects)
                local x, y = LEFTMOST, TOPMOST
                for _, obj in ipairs(objects) do
                    table.insert(containers, CONTAINER:create(obj, x, y, CONTAINER_WIDTH, CONTAINER_HEIGHT))
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
                end
            end,

            handleMousepressed = function(self, mx, my)
                for _, c in ipairs(containers) do
                    if c:isInside(mx, my) then c:select()
                    else                       c:unselect() end
                end
            end,
        }):init(params.objects)
    end,
}
 
