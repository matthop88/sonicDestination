return {
    imageName  = "sonic1Transparent",
    animations = {
        standing    = { fps = 1,  offset = { x = 14, y = 20 }, isDefault = true,
            -------------------------------------------------------------------
            { x =  43, y = 257, w = 32, h = 40, offset = { x = 16, y = 20 }, },
        },
        running     = { fps = 10, offset = { x = 16, y = 20 },
            { x =  46, y = 349, w = 24, h = 40, offset = { x = 12, y = 19 }, },
            { x = 109, y = 347, w = 40, h = 40, offset = { x = 20, y = 19 }, },
            { x = 178, y = 348, w = 32, h = 40, offset = { x = 20, y = 19 }, },
            { x = 249, y = 349, w = 40, h = 40, offset = { x = 20, y = 19 }, },
            { x = 319, y = 347, w = 40, h = 40, offset = { x = 20, y = 19 }, },
            { x = 390, y = 348, w = 40, h = 40, offset = { x = 20, y = 19 }, },
        },

        braking     = { fps = 2, offset = { x = 14, y = 17 },
            { x = 481, y = 352, w = 30, h = 36, offset = { x = 13, y = 18 }, },
            { x = 547, y = 352, w = 34, h = 36, offset = { x = 17, y = 18 }, },
        },

        jumping     = { fps = 12, offset = { x = 16, y = 14 },
            { x =  44, y = 626, w = 29, h = 30, offset = { x = 16, y = 14 }, },
            { x = 114, y = 626, w = 30, h = 29, offset = { x = 16, y = 15 }, },
            { x = 185, y = 626, w = 29, h = 30, offset = { x = 11, y = 15 }, },
            { x = 254, y = 627, w = 30, h = 29, offset = { x = 16, y = 14 }, },
            { x = 324, y = 626, w = 30, h = 30, offset = { x = 15, y = 14 }, },
        },
        fastJumping = { fps = 60, offset = { x = 16, y = 14 },
            { x =  44, y = 626, w = 29, h = 30, offset = { x = 16, y = 14 }, },
            { x = 114, y = 626, w = 30, h = 29, offset = { x = 16, y = 15 }, },
            { x = 324, y = 626, w = 30, h = 30, offset = { x = 15, y = 14 }, },
            { x = 185, y = 626, w = 29, h = 30, offset = { x = 15, y = 15 }, },
            { x = 254, y = 627, w = 30, h = 29, offset = { x = 16, y = 14 }, },
            { x = 324, y = 626, w = 30, h = 30, offset = { x = 15, y = 14 }, },
        },
    },
}
    
