return {
    imageName  = "sonic1Transparent",
    animations = {
        standing = { fps = 1, isDefault = true,
            -------------------------------------------------------------------
            { x =  43, y = 257, w = 32, h = 40, offset = { x = 16, y = 20 }, },
        },
        running  = { fps = 10,
            { x =  46, y = 349, w = 24, h = 40, offset = { x = 12, y = 19 }, },
            { x = 109, y = 347, w = 40, h = 40, offset = { x = 20, y = 19 }, },
            { x = 178, y = 348, w = 32, h = 40, offset = { x = 20, y = 19 }, },
            { x = 249, y = 349, w = 40, h = 40, offset = { x = 20, y = 19 }, },
            { x = 319, y = 347, w = 40, h = 40, offset = { x = 20, y = 19 }, },
            { x = 390, y = 348, w = 40, h = 40, offset = { x = 20, y = 19 }, },
        },

        braking  = { fps = 2,
            { x = 481, y = 352, w = 30, h = 36, offset = { x = 13, y = 18 }, },
            { x = 547, y = 352, w = 34, h = 36, offset = { x = 17, y = 18 }, },
        },
    },
}
    
