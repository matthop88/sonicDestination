return {
    imageName = "PTPBadniksTransparent",

    animations  = {
        flying = { fps = 5, isDefault = true, offset = { x = 13, y = 8 }, w = 28, h = 22,
            hitBox = { rX = 10, rY = 8 },
            ----------------------------------------------------------------------------
            { x = 407, y = 60, w = 28, h = 27, offset = { x = 13, y = 17, }, },
            { x = 448, y = 61, w = 26, h = 17, offset = { x = 13, y =  8, }, },
            { x = 487, y = 63, w = 26, h = 22, offset = { x = 13, y =  9, }, },
            { x = 448, y = 61, w = 26, h = 17, offset = { x = 13, y =  8, }, },
        },
        dying  = { fps = 5, offset = { x = 13, y = 8 }, w = 28, h = 22,
            reps = 1,
            parts = {
                {   name = "patabataBody", animation = "dying",  },
                {   name = "explosion",   animation = "poof",   },
            },
        },
    },
}
