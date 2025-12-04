return {
    imageName  = "commonObj",
    animations  = {
        giantSpinning = { fps = 8, offset = { x = 32, y = 32 }, w = 64, h = 64, isDefault = true, synchronized = true,
            ----------------------------------------------------------------------------------------------------------
            { x =  24, y = 239, w = 64, h = 64, offset = { x = 32, y = 32 }, },
            { x =  96, y = 239, w = 48, h = 64, offset = { x = 24, y = 32 }, },
            { x = 152, y = 239, w = 24, h = 64, offset = { x = 12, y = 32 }, },
            { x = 184, y = 239, w = 48, h = 64, offset = { x = 24, y = 32 }, },
        },
        giantDissolving = { fps = 8, offset = { x = 32, y = 32 }, w = 64, h = 64, foreground = true,
            { x =  24, y = 311, w = 64, h = 64, offset = { x = 32, y = 32 }, },
            { x = 114, y = 311, w = 46, h = 64, offset = { x = 14, y = 32 }, },
            { x = 176, y = 311, w = 56, h = 64, offset = { x = 24, y = 32 }, },
            { x = 240, y = 311, w = 64, h = 64, offset = { x = 32, y = 32 }, },
            { x =  24, y = 383, w = 56, h = 64, offset = { x = 32, y = 32 }, },
            { x =  96, y = 383, w = 46, h = 64, offset = { x = 32, y = 32 }, },
            { x = 168, y = 383, w = 32, h = 64, offset = { x = 32, y = 32 }, },
            { x = 245, y = 386, w = 54, h = 58, offset = { x = 32, y = 32 }, },
        },
    },
}
