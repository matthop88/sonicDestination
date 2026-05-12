local drawBlueBall = function(graphics, x, y)
    graphics:setColor(0.28, 0.28, 0.71)
    graphics:ellipse("fill", x + 8, y + 9, 8, 7)
    graphics:setColor(0.42, 0.42, 0.85)
    graphics:ellipse("fill", x + 8, y + 7, 8, 7)
    graphics:setColor(0.56, 0.56, 0.99)
    graphics:circle("fill", x + 8, y + 4, 2, 2)
    graphics:setColor(0.99, 0.99, 0.99)
    graphics:circle("fill", x + 8, y + 3.75, 1, 1)
end

local drawRedBall = function(graphics, x, y)
    graphics:setColor(0.49, 0, 0)
    graphics:ellipse("fill", x + 8, y + 9, 8, 7)
    graphics:setColor(0.99, 0, 0)
    graphics:ellipse("fill", x + 8, y + 7, 8, 7)
    graphics:setColor(0.99, 0.71, 0.56)
    graphics:circle("fill", x + 8, y + 4, 2, 2)
    graphics:setColor(0.99, 0.99, 0.99)
    graphics:circle("fill", x + 8, y + 3.75, 1, 1)
end

return {
    imageName = "commonObj",
    animations  = {
        standingBlue = { fps = 1, isDefault = true, offset = { x = 8, y = 32 }, w = 16, h = 16,
            ----------------------------------------------------------------------------------
            { x = 132, y = 486, w = 16, h = 16, offset = { x = 8, y = 32 }, },
            draw = drawBlueBall,
        },
        standingRed  = { fps = 1, offset = { x = 8, y = 32 }, w = 16, h = 16,
            { x = 132, y = 510, w = 16, h = 16, offset = { x = 8, y = 32 }, },
            draw = drawRedBall,
        },
        animatingRed = { fps = 6, offset = { x = 8, y = 32 }, w = 16, h = 16,
            reps = 2, endingFrame = 1,
            draw = drawRedBall,
            calculateOffsets = function(frameNumber)
                local rad = (frameNumber - 1) * (math.pi / 8) + (math.pi / 2)
                return 8 + (math.cos(rad) * 12), 20 + (math.sin(rad) * 12)
            end,
            { x = 132, y = 510, w = 16, h = 16, offset = { x =  8, y = 32 }, },
            { x = 132, y = 510, w = 16, h = 16, offset = { x = 13, y = 32 }, },
            { x = 132, y = 510, w = 16, h = 16, offset = { x = 17, y = 29 }, },
            { x = 132, y = 510, w = 16, h = 16, offset = { x = 20, y = 25 }, },
            { x = 132, y = 510, w = 16, h = 16, offset = { x = 20, y = 20 }, },
            { x = 132, y = 510, w = 16, h = 16, offset = { x = 20, y = 16 }, },
            { x = 132, y = 510, w = 16, h = 16, offset = { x = 17, y = 12 }, },
            { x = 132, y = 510, w = 16, h = 16, offset = { x = 13, y =  9 }, },
            { x = 132, y = 510, w = 16, h = 16, offset = { x =  8, y =  8 }, },
            { x = 132, y = 510, w = 16, h = 16, offset = { x =  3, y =  9 }, },
            { x = 132, y = 510, w = 16, h = 16, offset = { x = -1, y = 12 }, },
            { x = 132, y = 510, w = 16, h = 16, offset = { x = -4, y = 16 }, },
            { x = 132, y = 510, w = 16, h = 16, offset = { x = -4, y = 20 }, },
            { x = 132, y = 510, w = 16, h = 16, offset = { x = -4, y = 25 }, },
            { x = 132, y = 510, w = 16, h = 16, offset = { x = -1, y = 29 }, },
            { x = 132, y = 510, w = 16, h = 16, offset = { x =  3, y = 32 }, },
        },
    },
}
