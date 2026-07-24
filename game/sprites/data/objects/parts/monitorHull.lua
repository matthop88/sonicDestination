return {
    imageName = "commonObj",
    animations  = {
        standing = { fps = 1, isDefault = true, offset = { x = 15, y = 15 }, w = 30, h = 30,
            ------------------------------------------------------------------------------
            { x = 25, y = 487, w = 30, h = 30, offset = { x = 15, y  = 15 }, },
        },
        destroyed = { fps = 1,                 offset = { x = 16, y  =  1 }, w = 32, h = 16,
            { x = 64, y = 501, w = 32, h = 16, offset = { x = 16, y  =  1 }, },
        },
        exploding = { fps = 5, offset = { x = 15, y = 15 }, w = 30, h = 30,
            reps = 1, endingFrame = 5,
            { x = 25, y = 487, w = 30, h = 30, offset = { x = 15, y  = 15 }, },
            { x = 25, y = 487, w = 30, h = 30, offset = { x = 15, y  = 15 }, },
            { x = 25, y = 487, w = 30, h = 30, offset = { x = 15, y  = 15 }, },
            { x = 64, y = 501, w = 32, h = 16, offset = { x = 16, y  =  1 }, },
            { x = 64, y = 501, w = 32, h = 16, offset = { x = 16, y  =  1 }, },
            { x = 64, y = 501, w = 32, h = 16, offset = { x = 16, y  =  1 }, },
        }, 
    },
}
