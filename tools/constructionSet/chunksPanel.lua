return {
	draw = function(self, graphics)
        graphics:setColor(1, 1, 1)
        graphics:setLineWidth(1)
        for y = 16, 290, 143 do
            for x = 31, 1080, 143 do
                graphics:rectangle("line", x - 1, y - 1, 130, 130)
            end
        end
    end,
}
