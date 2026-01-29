return {
    imageName = "sonic1BadniksTransparent",
    animations  = {
        motobugRoving = { isDefault = true, offset = { x = 20, y = 14 }, w = 40, h = 28,
            hitBox = { rX = 15, rY = 10, danger = 1 },
            ----------------------------------------------------------------------------
            parts = {
                {   name = "motobugBody", animation = "roving",  },
                {   name = "puffOfSmoke", animation = "puffing", },
            }
        },
        motobugDying = { offset = { x = 20, y = 14 }, w = 40, h = 28,
            reps = 1,
            parts = {
                {   name = "motobugBody", animation = "dying",  },
                {   name = "explosion",   animation = "poof",   },
            },
        },
    },
}

