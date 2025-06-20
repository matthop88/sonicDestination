return {
    -----------------------------------------------
    --   Methods called by LOVE events go here   --
    -----------------------------------------------
    draw = function(self)
        local topLineY, midLineY = 512, 534

        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(4)
        love.graphics.line(0, topLineY, 1024, topLineY)

        love.graphics.setLineWidth(2)
        love.graphics.line(0, midLineY, 1024, midLineY)
    end,

}
