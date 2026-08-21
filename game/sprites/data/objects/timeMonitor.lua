return {
    imageName = "commonObj",
    animations  = {
        standing = { isDefault = true, offset = { x = 15, y = 15 }, w = 30, h = 30,
            hitBox = { rX = 14, rY = 14, danger = 0 },
            ----------------------------------------------------------------------------
            parts = {
                {   name = "monitorHull",   animation = "standing",  },
                {   name = "timeMonitorScreen", animation = "flashing",  },
            }
        },
        exploding = { fps = 5, offset = { x = 15, y = 15 }, w = 30, h = 30,
            hitBox = { rX = 14, rY = 14, danger = 0 },
            reps = 1, 
            parts = {
                {   name = "monitorHull",   animation = "exploding", },
                {   name = "timeMonitorScreen", animation = "exploding", },
                {   name = "explosion",     animation = "poof",      },
            }
        },  
        destroyed = { offset = { x = 16, y = 1 }, w = 32, h = 16,
            hitBox = { rX = 14, rY = 7, danger = 0 },
            parts = {
                {   name = "monitorHull",   animation = "destroyed", },
            }
        },
    },
}
