return {
    imageName = "commonObj",
    animations  = {
        standingBlue = { isDefault = true, offset = { x = 8, y = 32 }, w = 16, h = 64,
            hitBox = { rX = 5, rY = 28, danger = 0 },
            ----------------------------------------------------------------------------
            parts = {
                {   name = "lampPostHead", animation = "standingBlue",  },
                {   name = "lampPostBody", animation = "standing",      },
            }
        },
        standingRed = { offset = { x = 8, y = 32 }, w = 16, h = 64,
            hitBox = { rX = 5, rY = 28, danger = 0 },
            ----------------------------------------------------------------------------
            parts = {
                {   name = "lampPostHead", animation = "standingRed",  },
                {   name = "lampPostBody", animation = "standing",     },
            }
        },
        animatingRed = { offset = { x = 8, y = 32 }, w = 16, h = 64, fps = 60,
            hitBox = { rX = 5, rY = 28, danger = 0 },
            parts = {
                {   name = "lampPostBody", animation = "standing",      },
                {   name = "lampPostHead", animation = "animatingRed",  },
            },
        },
    },
}

