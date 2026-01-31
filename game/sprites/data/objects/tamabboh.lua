return {
    imageName = "PTPBadniksTransparent",

    animations  = {
        grinding = { fps = 5, isDefault = true, offset = { x = 20, y = 15 }, w = 31, h = 31,
            hitBox = { rX = 10, rY = 8, danger = 1 },
            ----------------------------------------------------------------------------
            { x = 405, y = 197, w = 31, h = 29, offset = { x = 20, y = 14 }, },
            { x = 445, y = 197, w = 31, h = 28, offset = { x = 20, y = 14 }, },
            { x = 445, y = 239, w = 31, h = 28, offset = { x = 20, y = 14 }, },
        },
        charging = { fps = 1, offset = { x = 20, y = 15 }, w = 32, h = 31,
            hitBox = { rX = 10, rY = 8, danger = 1 },
            { x = 405, y = 236, w = 32, h = 31, offset = { x = 20, y = 15 }, },
        },
        dying  = { fps = 5, offset = { x = 20, y = 15 }, w = 31, h = 31,
            reps = 1,
            parts = {
                {   name = "tamabbohBody", animation = "dying",  },
                {   name = "explosion",    animation = "poof",   },
            },
        },
    },
}
