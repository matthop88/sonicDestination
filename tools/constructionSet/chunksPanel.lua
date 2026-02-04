local CONTAINER = {
    create = function(self, x, y, w, h)
        return {
            x = x,
            y = y,
            w = w,
            h = h,

            draw = function(self, graphics)
                graphics:setColor(1, 1, 1)
                graphics:setLineWidth(1)
                graphics:rectangle("line", self.x - 1, self.y - 1, self.w + 2, self.h + 2)
            end,
        }
    end,
}

return {
    create = function(self)
        local containers = {}

        for y = 16, 290, 143 do
            for x = 31, 1080, 143 do
                table.insert(containers, CONTAINER:create(x, y, 128, 128))
            end
        end

        return {
            draw = function(self, graphics)
                for _, c in ipairs(containers) do
                    c:draw(graphics)
                end
            end,
        }
    end,
}
