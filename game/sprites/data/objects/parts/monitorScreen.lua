local FACE_GRAVITY = 120
local RISE_SPEED   = 120
            
return {
    imageName = "sonicCDCommonObj",
    animations  = {
        flashing = { fps = 48, isDefault = true, offset = { x = 8, y = 11 }, w = 16, h = 16,
            ------------------------------------------------------------------------------
            { x = 249, y = 355, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 249, y = 355, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 249, y = 355, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 249, y = 283, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 249, y = 283, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 249, y = 355, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 249, y = 355, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 249, y = 355, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 273, y = 283, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 273, y = 283, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 249, y = 355, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 249, y = 355, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 249, y = 355, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 297, y = 283, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 297, y = 283, w = 16, h = 16, offset = { x = 8, y = 11 }, },
        },
        exploding = { fps = 5, offset = { x = 8, y = 11 }, w = 16, h = 16,
            reps = 1, terminal = true, endingFrame = 6,
            calculateOffsets = function(frameNumber)
                local dt           = (frameNumber - 1) / 5
                local gravModifier = ((FACE_GRAVITY    / 2) * dt * dt)
                local yOffset      = (RISE_SPEED * dt) - gravModifier
                return 8, 11 + yOffset
            end,
            { x = 249, y = 355, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 249, y = 355, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 249, y = 355, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 249, y = 355, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 249, y = 355, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            {},
        },  
    },
}
