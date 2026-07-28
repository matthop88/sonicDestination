local FACE_GRAVITY = 120
local RISE_SPEED   = 120
            
return {
    imageName = "commonObj",
    animations  = {
        flashing = { fps = 16, isDefault = true, offset = { x = 8, y = 11 }, w = 16, h = 16,
            ------------------------------------------------------------------------------
            { x = 24, y = 540, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 72, y = 603, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 48, y = 540, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 72, y = 603, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 72, y = 540, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 72, y = 603, w = 16, h = 16, offset = { x = 8, y = 11 }, },
        },
        exploding = { fps = 5, offset = { x = 8, y = 11 }, w = 16, h = 16,
            reps = 1, terminal = true, endingFrame = 6,
            calculateOffsets = function(frameNumber)
                local dt           = (frameNumber - 1) / 5
                local gravModifier = ((FACE_GRAVITY    / 2) * dt * dt)
                local yOffset      = (RISE_SPEED * dt) - gravModifier
                return 8, 11 + yOffset
            end,
            { x = 72, y = 603, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 72, y = 603, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 72, y = 603, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 72, y = 603, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 72, y = 603, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            {},
        },  
    },
}
