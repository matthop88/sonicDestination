return {
    imageName = "commonObj",
    animations  = {
        flashing = { fps = 16, isDefault = true, offset = { x = 8, y = 11 }, w = 16, h = 16,
            ------------------------------------------------------------------------------
            { x = 24, y = 540, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 72, y = 603, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 48, y = 540, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 72, y = 603, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 72, y = 540, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 72, y = 603, w = 16, h = 16, offset = { x = 8, y = 11 }, },
        },
        exploding = { fps = 5, offset = { x = 8, y = 11 }, w = 16, h = 16,
            reps = 1, terminal = true,
            { x = 72, y = 603, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 72, y = 603, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            { x = 72, y = 603, w = 16, h = 16, offset = { x = 8, y = 11 }, },
            {},
            {},
            {},
        },  
    },
}
