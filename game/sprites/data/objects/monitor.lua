return {
    imageName = "commonObj",
    animations  = {
        standing = { isDefault = true, offset = { x = 15, y = 15 }, w = 30, h = 30,
            hitBox = { rX = 14, rY = 14, danger = 0 },
            ----------------------------------------------------------------------------
            parts = {
                {   name = "monitorHull",   animation = "standing",  },
                {   name = "monitorScreen", animation = "flashing",  },
            }
        },
    },
}



