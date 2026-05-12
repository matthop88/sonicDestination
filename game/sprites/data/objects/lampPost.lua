return {
    imageName = "commonObj",
    animations  = {
        standingBlue = { isDefault = true, offset = { x = 8, y = 32 }, w = 16, h = 64,
            hitBox = { rX = 5, rY = 28, danger = 0 },
            ----------------------------------------------------------------------------
            parts = {
                {   name = "lampPostHead", animation = "standingBlue",  },
                {   name = "lampPostBody", animation = "standing", },
            }
        },
        standingRed = { offset = { x = 8, y = 32 }, w = 16, h = 64,
            hitBox = { rX = 5, rY = 28, danger = 0 },
            ----------------------------------------------------------------------------
            parts = {
                {   name = "lampPostHead", animation = "standingRed",  },
                {   name = "lampPostBody", animation = "standing", },
            }
        },
        animatingRed = { offset = { x = 8, y = 32 }, w = 16, h = 64, fps = 5,
            hitBox = { rX = 5, rY = 28, danger = 0 },
            { x = 164, y = 486, w = 16, h = 64, offset = { x =  8, y = 32 }, },
            { x = 199, y = 486, w = 21, h = 64, offset = { x = 13, y = 32 }, },
            { x = 243, y = 489, w = 25, h = 61, offset = { x = 17, y = 29 }, },
            { x = 288, y = 493, w = 28, h = 57, offset = { x = 20, y = 25 }, },
            { x = 336, y = 498, w = 28, h = 52, offset = { x = 20, y = 20 }, },
            { x = 384, y = 502, w = 28, h = 48, offset = { x = 20, y = 16 }, },
            { x = 435, y = 502, w = 25, h = 48, offset = { x = 17, y = 16 }, },
            { x = 479, y = 502, w = 21, h = 48, offset = { x = 13, y = 16 }, },
            { x = 164, y = 576, w = 16, h = 48, offset = { x =  8, y = 16 }, },
            { x = 204, y = 576, w = 21, h = 48, offset = { x =  8, y = 16 }, },
            { x = 244, y = 576, w = 25, h = 48, offset = { x =  8, y = 16 }, },
            { x = 292, y = 576, w = 28, h = 48, offset = { x =  8, y = 16 }, },
            { x = 340, y = 572, w = 28, h = 52, offset = { x =  8, y = 20 }, },
            { x = 388, y = 567, w = 28, h = 57, offset = { x =  8, y = 25 }, },
            { x = 436, y = 563, w = 25, h = 61, offset = { x =  8, y = 29 }, },
            { x = 484, y = 560, w = 21, h = 64, offset = { x =  8, y = 32 }, },
        },
    },
}

